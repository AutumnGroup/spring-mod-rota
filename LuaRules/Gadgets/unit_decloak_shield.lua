--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    unit_decloak_shield.lua
--  brief:   adds a decloak-shield to units, blinks a light
--  author:  Dave Rodgers, modified by Evil4Zerggin
--
--  Copyright (C) 2007.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "UnitDeCloakShield",
    desc      = "Adds a decloak-shield to units, governed by active on/off state, blinks a light with lups, destealth for now :-(",
    author    = "trepan, modified by Evil4Zerggin, modified by thor, modified by cake",
    date      = "May 02, 2007",
    license   = "GNU GPL, v2 or later",
    layer     = 1,
    enabled   = true  --  loaded by default?
  }
end


local SYNCSTR = "unit_decloak_shield"


--------------------------------------------------------------------------------
--  COMMON
--------------------------------------------------------------------------------
if (gadgetHandler:IsSyncedCode()) then
--------------------------------------------------------------------------------
--  SYNCED
--------------------------------------------------------------------------------

--
--  speed-ups
--

local GetUnitDefID       = Spring.GetUnitDefID
local UseUnitResource    = Spring.UseUnitResource
local GetUnitSeparation  = Spring.GetUnitSeparation
local SetUnitStealth     = Spring.SetUnitStealth
local SetUnitAlwaysVisible = Spring.SetUnitAlwaysVisible

local FRAMESKIP = 6



--------------------------------------------------------------------------------

local cloakShieldDefs = {}
local uncloakableDefs = {}

local cloakShieldUnits = {} -- make it global in Initialize()
local cloakers = {}
local cloakees = {}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


local function SendOff(unitID)
	local teamID = Spring.GetUnitAllyTeam(unitID)
	SendToUnsynced("radar", unitID, teamID, 0)
end

local function SendOn(unitID)
	local teamID = Spring.GetUnitAllyTeam(unitID)
	SendToUnsynced("radar", unitID, teamID, 1)
end

local function ValidateCloakShieldDefs(mds)
  local newDefs = {}
  for udName, def in pairs(mds) do
    local ud = UnitDefNames[udName]
    if (not ud) then
      Spring.Echo('Bad cloakShield unit type: ' .. udName)
    else
      local newData = {}
      --newData.draw   = def.draw   or true
      newData.init   = def.init   or false
      newData.level  = def.level  or 2
      newData.delay  = def.delay  or 30
      newData.energy = def.energy or 0
      newData.minrad = def.minrad or 64
      newData.maxrad = def.maxrad or 256
      newData.growRate   = def.growRate   or 256
      newData.shrinkRate = def.shrinkRate or 256
      newData.selfCloak  = def.selfCloak or false
      newData.decloakDistance  = def.decloakDistance or false
      newData.isTransport = ud.isTransport
      newDefs[ud.id] = newData
    end
  end

  -- print the table (alphabetically)
--[[
  local sorted = {}
  for n, ud in pairs(UnitDefNames) do table.insert(sorted, {n, ud.id}) end
  table.sort(sorted, function(a,b) return (a[1] < b[1]) end)
  for _, name_id in ipairs(sorted) do
    local nd = newDefs[ name_id[2] ]
    if (nd) then
      print('CloakShield ' .. name_id[1])
     -- print('  draw   = ' .. tostring(nd.draw))
      print('  init   = ' .. tostring(nd.init))
      print('  delay  = ' .. tostring(nd.delay))
      print('  energy = ' .. tostring(nd.energy))
      print('  minrad = ' .. tostring(nd.minrad))
      print('  maxrad = ' .. tostring(nd.maxrad))
      print('  growRate   = ' .. tostring(nd.growRate))
      print('  shrinkRate = ' .. tostring(nd.shrinkRate))
      print('  selfCloak  = ' .. tostring(nd.selfCloak))
      print('  decloakDistance  = ' .. tostring(nd.decloakDistance))
    end
  end
--]]

  return newDefs
end


local function ValidateUncloakableDefs(unclks)
  local newDefs = {}
  for udName, data in pairs(unclks) do
    local ud = UnitDefNames[udName]
    if (not ud) then
      Spring.Echo('Bad uncloakable unit type: ' .. udName)
    else
      newDefs[ud.id] = true
--      print('uncloakable: ' .. udName)
    end
  end
  return newDefs
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function AddCloakShieldUnit(unitID, cloakShieldDef)

  local data = {
    id      = unitID,
    def     = cloakShieldDef,
   -- draw    = cloakShieldDef.draw,
    radius  = 0,
    minrad  = cloakShieldDef.minrad,
    maxrad  = cloakShieldDef.maxrad,
    energy  = cloakShieldDef.energy / 32,
    unitRadius  = Spring.GetUnitRadius(unitID),
    
  }
  cloakShieldUnits[unitID] = data

  if (cloakShieldDef.init) then
    data.want = true
    cloakers[unitID] = data
  end
end


--------------------------------------------------------------------------------

function gadget:Initialize()
  -- get the cloakShieldDefs
  cloakShieldDefs, uncloakableDefs =
    include("LuaRules/Configs/decloak_shield_defs.lua")

  if (not cloakShieldDefs) then
    gadgetHandler:RemoveGadget()
    return
  end
  
  cloakShieldDefs = ValidateCloakShieldDefs(cloakShieldDefs)
  uncloakableDefs = ValidateUncloakableDefs(uncloakableDefs)

  for _,unitID in ipairs(Spring.GetAllUnits()) do
    local unitDefID = GetUnitDefID(unitID)
    local cloakShieldDef = cloakShieldDefs[unitDefID]
    if (cloakShieldDef) then
      AddCloakShieldUnit(unitID, cloakShieldDef)
    end
  end
end


function gadget:Shutdown()
  for _,unitID in ipairs(Spring.GetAllUnits()) do
    local defID = Spring.GetUnitDefID(unitID)
    local ud = UnitDefs[defID]
    if (ud ~= nil) then
      local defStealth = ud.stealth
      SetUnitStealth(unitID, defStealth)
    end
    --SetUnitCloak(unitID, false, false)
    --SetUnitAlwaysVisible( unitID, false )
    --local want = Spring.GetUnitCOBValue(unitID, 77)
    --Spring.SetUnitCOBValue(unitID, 77, want)
  end
end


--------------------------------------------------------------------------------

function gadget:UnitCreated(unitID, unitDefID, unitTeam)
  
end

function gadget:UnitFinished(unitID, unitDefID, unitTeam)
  local cloakShieldDef = cloakShieldDefs[unitDefID]
  if (not cloakShieldDef) then
    return
  end
  AddCloakShieldUnit(unitID, cloakShieldDef)
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
  if (cloakShieldUnits[unitID]) then
    SendOff(unitID)
  end
  cloakShieldUnits[unitID] = nil
  cloakers[unitID] = nil
  cloakees[unitID] = nil
end


function gadget:UnitTaken(unitID, unitDefID, unitTeam)
end


--------------------------------------------------------------------------------

local GetUnitAllyTeam  = Spring.GetUnitAllyTeam
local GetUnitPosition  = Spring.GetUnitPosition
local GetUnitsInSphere = Spring.GetUnitsInSphere

local function UpdateCloakees(data)
  local unitID = data.id
  local radius = data.radius
  local level     = false
  local selfCloak = data.def.selfCloak
  local decloakDistance = data.def.decloakDistance
  local x, y, z = GetUnitPosition(unitID)
  if (x == nil) then return end
  local closeUnits = GetUnitsInSphere(x, y, z, radius)
  if (closeUnits == nil) then return end
  local allyTeam = GetUnitAllyTeam(unitID)
  for _,cloakee in ipairs(closeUnits) do
    local udid = GetUnitDefID(cloakee)
    if ((not uncloakableDefs[udid]) and (GetUnitAllyTeam(cloakee) ~= allyTeam)) then
      if (cloakee ~= unitID) then
        --other units
        SetUnitStealth(cloakee, false)
        --Spring.SetUnitCOBValue(cloakee, 76, 0)
        --SetUnitAlwaysVisible( cloakee, true )
        cloakees[cloakee] = true
      end
    end
  end
end


local function GrowRadius(cloaker)
  cloaker.radius = cloaker.maxrad
end


local function ShrinkRadius(cloaker)
  cloaker.radius = 0
end


local GetUnitHealth = Spring.GetUnitHealth

function gadget:GameFrame(frameNum)
  local checkCloakees = ((frameNum % FRAMESKIP) < 1)
  if (checkCloakees) then
    for uid in pairs(cloakees) do
      local ud = UnitDefs[Spring.GetUnitDefID(uid)]
      if (ud ~= nil) then
        local defStealth = ud.stealth
        SetUnitStealth(uid, defStealth)
      end
    end
    cloakees = {}
  else
    for uid in pairs(cloakees) do
	if (uid ~= nil) then
        local ud = UnitDefs[Spring.GetUnitDefID(uid)]
        if (ud ~= nil) then
          SetUnitStealth(uid, false)
        end
      end
    end
  end
  for unitID, data in pairs(cloakers) do
    local _, _, amountParalyzed = GetUnitHealth(unitID)
    local states = Spring.GetUnitStates(unitID)
    if (data.delay) then
      data.delay = data.delay - 1
      if (data.delay <= 0) then
        data.delay = nil
      end
      ShrinkRadius(data)
      SendOff(unitID)
    elseif (amountParalyzed == nil) then
      ShrinkRadius(data)
      SendOff(unitID)
    elseif (amountParalyzed > 0) then
      ShrinkRadius(data)
      SendOff(unitID)
    elseif (not data.want) then
      ShrinkRadius(data)
      SendOff(unitID)
    else
	if (states.active) then
        local newState = UseUnitResource(unitID, 'e', data.energy)
        if (newState) then
          GrowRadius(data)
          SendOn(unitID)
        else
          ShrinkRadius(data)
          SendOff(unitID)
        end
      else
        ShrinkRadius(data)
        SendOff(unitID)
      end
    end

    if (checkCloakees and (data.radius > 0)) then
      UpdateCloakees(data)
    end
  end
end

else
--------------------------------------------------------------------------------
--  UNSYNCED
--------------------------------------------------------------------------------
local knownRadars = {}
local frameTicker = 0
local cloakShieldDefs = {}
local uncloakableDefs = {}

local blinky_mc_blinksalot = {
    colormap    = { {1, 1, 1, 0.005}, {0, 0, 0, 0.005} },
    count           = 1,
    life            = 7,
    lifeSpread      = 0,
    emitVector      = {0,1,0},
    emitRotSpread   = 90,
    force           = {0,0.3,0},

    --partpos         = "r*sin(alpha),0,r*cos(alpha) | r=rand()*15, alpha=rand()*2*pi",

    rotSpeed        = 0,
    rotSpeedSpread  = 0,
    rotSpread       = 0,
    rotExp          = 1,

    speed           = 0.0,
    speedSpread     = 0.0,
    speedExp        = 1,

    size            = 65,
    sizeSpread      = 10,
    sizeGrowth      = 5.15,
    sizeExp         = 2.5,

    layer           = 1,
    texture         = "bitmaps/GPL/smallflare_blue.png",
  }

local enemy_blinky = {
    colormap    = { {1, .1, .1, 0.005}, {0, 0, 0, 0.005} },
    count           = 1,
    life            = 7,
    lifeSpread      = 0,
    emitVector      = {0,1,0},
    emitRotSpread   = 90,
    force           = {0,0.3,0},

    --partpos         = "r*sin(alpha),0,r*cos(alpha) | r=rand()*15, alpha=rand()*2*pi",

    rotSpeed        = 0,
    rotSpeedSpread  = 0,
    rotSpread       = 0,
    rotExp          = 1,

    speed           = 0.0,
    speedSpread     = 0.0,
    speedExp        = 1,

    size            = 100,
    sizeSpread      = 10,
    sizeGrowth      = 10,
    sizeExp         = 2.5,

    layer           = 1,
    texture         = "bitmaps/GPL/smallflare_blue.png",
  }

function gadget:RecvFromSynced(name, id, team, state)
	if (name == "radar") then
		if (state == 1) then
			knownRadars[id] = team
			--Spring.Echo("radar ", id, " is on")
		else
			knownRadars[id] = nil
		end
	end
end


function gadget:DrawScreen()
	local Lups = GG['Lups']
      local t = Spring.GetLastUpdateSeconds()
	frameTicker = frameTicker + t
      if (frameTicker >= 4) then
		--Spring.Echo("boop...")
		frameTicker = 0
		local PlayerTeam = Spring.GetMyAllyTeamID()
		for radarID, radarTeam in pairs(knownRadars) do
			if (Spring.GetUnitPosition(radarID) ~= nil) then
				local x, y, z = Spring.GetUnitBasePosition(radarID)
				local isseen = Spring.GetPositionLosState( x, y, z, PlayerTeam )
				local defID = Spring.GetUnitDefID(radarID)
				local udName = UnitDefs[defID].name
				if (udName ~= nil) then
					if (cloakShieldDefs[udName].piece ~= nil) then
						if (radarTeam == PlayerTeam) then
							local pieceNum = Spring.GetUnitPieceMap(radarID)[cloakShieldDefs[udName].piece]
							local piecePos = {}
							piecePos.x, piecePos.y, piecePos.z = Spring.GetUnitPiecePosition(radarID, pieceNum)
							if (piecePos.x ~= nil) then
								blinky_mc_blinksalot.pos = { piecePos.x + x, piecePos.y + y + 10, piecePos.z + z }
								blinky_mc_blinksalot.size = (cloakShieldDefs[udName].decloakDistance / 900) * 65
	 							Lups.AddParticles('RadarParticles',blinky_mc_blinksalot)
							end
						else
							if (isseen == true) then
								local pieceNum = Spring.GetUnitPieceMap(radarID)[cloakShieldDefs[udName].piece]
								local piecePos = {}
								piecePos.x, piecePos.y, piecePos.z = Spring.GetUnitPiecePosition(radarID, pieceNum)
								if (piecePos.x ~= nil) then
									enemy_blinky.pos = { piecePos.x + x, piecePos.y + y + 10, piecePos.z + z }
									enemy_blinky.size = (cloakShieldDefs[udName].decloakDistance / 900) * 100
 									Lups.AddParticles('RadarParticles',enemy_blinky)
								end
							end
						end
					end
				else
					--Spring.Echo('cake can't write script ', radarID, ' name is ', udName)
				end
			end
		end
	end
end

function gadget:Initialize()
	-- get the cloakShieldDefs
	cloakShieldDefs, uncloakableDefs = include("LuaRules/Configs/decloak_shield_defs.lua")
	
	if (not cloakShieldDefs) then
		gadgetHandler:RemoveGadget()
		return
	end
end

end
--------------------------------------------------------------------------------
--  COMMON
--------------------------------------------------------------------------------
