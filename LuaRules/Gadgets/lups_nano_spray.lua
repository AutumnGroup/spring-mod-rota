-- $Id: lups_nano_spray.lua 3171 2008-11-06 09:06:29Z det $
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "Lups NanoSpray Wrapper",
    desc      = "Wraps the nano spray to LUPS",
    author    = "jK",
    date      = "Feb, 2008",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

if (Game.version=="0.76b1") then
  return false
end

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

-- synced only
if (gadgetHandler:IsSyncedCode()) then

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

  local GetUnitScriptPiece = Spring.GetUnitScriptPiece
  if (not GetUnitScriptPiece) then --//75b2 compa
    GetUnitScriptPiece = function(_,i) return i+1 end
  end
  local GetUnitAllyTeam      = Spring.GetUnitAllyTeam

  local bit_and  = math.bit_and
  local bit_or   = math.bit_or
  local bit_bits = math.bit_bits

  local nanoEmitters = {}
  for i=0,29 do nanoEmitters[i] = {} end

  -------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------

  function QueryNanoPiece(unitID,unitDefID,teamID,piecenum)
    local offset = unitID%30
    local emitter = nanoEmitters[offset][unitID]
    local piece = GetUnitScriptPiece(unitID,piecenum)
    if (emitter) then
      emitter.strength = emitter.strength+1
	if bit_and( emitter.nanoPieces,bit_bits(piecenum) )==0 then
        emitter.nanoPieces = bit_or( emitter.nanoPieces, bit_bits(piecenum) )
        emitter.pieceCount = emitter.pieceCount+1
        emitter[emitter.pieceCount] = piece
      end
      SendToUnsynced("npc1", unitID, piecenum, piece )
    else
      local ally = GetUnitAllyTeam(unitID)
      nanoEmitters[offset][unitID] = {
            teamID = teamID,
            unitDefID = unitDefID,
            allyID = ally,
            strength = 1,
            pieceCount = 1,
            nanoPieces = bit_bits(piecenum),
            [1] = GetUnitScriptPiece(unitID,piecenum),
	}
      SendToUnsynced("npc2", unitID, teamID, unitDefID, ally, piecenum, piece )
    end
  end

  -------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------

  function gadget:GameFrame(n)
    local offset = ((n+16) % 30)
    if (next(nanoEmitters[offset])) then
      SendToUnsynced("nano_GameFrame", offset)
      nanoEmitters[offset] = {}
    end
  end

  function gadget:UnitDestroyed(unitID,unitDefID)
     SendToUnsynced("nano_unit_destroyed", unitID, unitDefID)
  end

  local nanoCmdIDs = {}; nanoCmdIDs[CMD.RECLAIM]=true; nanoCmdIDs[CMD.RESTORE]=true; nanoCmdIDs[CMD.REPAIR]=true;

  function gadget:UnitCmdDone(unitID,unitDefID,unitTeam,cmdID,cmdTag)
    if (cmdID<0)or(nanoCmdIDs[cmdID]) then
      SendToUnsynced("nano_unit_cmddone", unitID, unitDefID, unitTeam, cmdID)
    end
  end

  -------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------

  function gadget:Initialize()
    gadgetHandler:RegisterGlobal("QueryNanoPiece",QueryNanoPiece)
  end

  function gadget:Shutdown()
    gadgetHandler:DeregisterGlobal("QueryNanoPiece")
  end

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
else
------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

local Lups  --// Lua Particle System
local initialized = false --// if LUPS isn't started yet, we try it once a gameframe later
local tryloading  = 1     --// try to activate lups if it isn't found

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

--// Speed-ups
local GetUnitPosition      = Spring.GetUnitPosition
local GetUnitPiecePosDir   = Spring.GetUnitPiecePosDir
local GetUnitCommands      = Spring.GetUnitCommands
local GetUnitIsBuilding    = Spring.GetUnitIsBuilding
local GetUnitRadius        = Spring.GetUnitRadius
local GetGroundHeight      = Spring.GetGroundHeight
local GetFeaturePosition   = Spring.GetFeaturePosition
local GetFeatureRadius     = Spring.GetFeatureRadius
local spGetUnitViewPosition  = Spring.GetUnitViewPosition
local spGetUnitVectors       = Spring.GetUnitVectors
local spGetUnitPiecePosition = Spring.GetUnitPiecePosition
local tinsert = table.insert
local type  = type
local pairs = pairs
local spairs = spairs

local CMD_RECLAIM   = CMD.RECLAIM
local CMD_REPAIR    = CMD.REPAIR
local CMD_RESTORE   = CMD.RESTORE
local CMD_CAPTURE   = CMD.CAPTURE
local CMD_RESURRECT = CMD.RESURRECT

  local bit_and  = math.bit_and
  local bit_or   = math.bit_or
  local bit_bits = math.bit_bits

  local nanoEmitters = {}
  for i=0,29 do nanoEmitters[i] = {} end

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

if (not GetFeatureRadius) then
  GetFeatureRadius = function(featureID)
    local fDefID = Spring.GetFeatureDefID(featureID)
    return (FeatureDefs[fDefID].radius or 0)
  end
end


local teamColors = {}
local function GetTeamColor(teamID)
  local color = teamColors[teamID]
  if (color) then
    return color
  end
  local r, g, b = Spring.GetTeamColor(teamID)
  if (r and g and b) then
    local color =  { r, g, b, 0.05 }
    teamColors[teamID] = color
    return color
  end
end


local function SetTable(table,arg1,arg2,arg3,arg4)
  table[1] = arg1
  table[2] = arg2
  table[3] = arg3
  table[4] = arg4
end


local function CopyTable(outtable,intable)
  for i,v in pairs(intable) do 
    if (type(v)=='table') then
      if (type(outtable[i])~='table') then outtable[i] = {} end
      CopyTable(outtable[i],v)
    else
      outtable[i] = v
    end
  end
end


local function CopyMergeTables(table1,table2)
  local ret = {}
  CopyTable(ret,table2)
  CopyTable(ret,table1)
  return ret
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  «« some basic functions »»
--

local supportedFxs = {}
local function fxSupported(fxclass)
  if (supportedFxs[fxclass]~=nil) then
    return supportedFxs[fxclass]
  else
    supportedFxs[fxclass] = Lups.HasParticleClass(fxclass)
    return supportedFxs[fxclass]
  end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Lua StrFunc parsing and execution
--

local loadstring = loadstring
local pcall = pcall
local function ParseLuaStrFunc(strfunc)
  local luaCode = [[
    return function(count,inversed)
      local limcount = (count/6)
            limcount = limcount/(limcount+1)
      return ]] .. strfunc .. [[
    end
  ]]

  local luaFunc = loadstring(luaCode)
  local success,ret = pcall(luaFunc)

  if (success) then
    return ret
  else
    Spring.Echo("LUPS(NanoSpray): parsing error in user function: \n" .. ret)
    return function() return 0 end
  end
end

local function ParseLuaCode(t)
  for i,v in pairs(t) do
    if (type(v)=="string")and(i~="texture")and(i~="fxtype") then
      t[i] = ParseLuaStrFunc(v)
    end
  end
end

local function ExecuteLuaCode(t)
  for i,v in pairs(t) do
    if (type(v)=="function") then
      t[i]=v(t.count,t.inversed)
    end
  end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  «« NanoSpray handling »»
--

local nanoParticles = {}
local nanoLasers    = {}

local nanoPart = {
  dir          = {0,1,0},
  pos          = {0,0,0},
  radius       = 100,
  terraform    = false,
  color        = {0, 0, 0, 0},
  count        = 20,

  delaySpread = 30,
  size        = 3,
  sizeSpread  = 1,
  sizeGrowth  = 0.05,
}

local function GetFaction(udid)
  local udef_factions = UnitDefs[udid].factions or {}
  return ((#udef_factions~=1) and 'unknown') or udef_factions[1]
end

local factionsNanoFx = {
  arm = {
    fxtype      = "NanoParticles",
    delaySpread = 30,
    size        = 3,
    sizeSpread  = 1,
    sizeGrowth  = 0.05,
    texture     = "bitmaps/PD/nano.tga"
  },
  ["arm_high_quality"] = {
    fxtype      = "NanoParticles",
    alpha       = 0.25,
    size        = 3,
    sizeSpread  = 5,
    sizeGrowth  = 0.35,
    rotSpeed    = 0.1,
    rotSpread   = 360,
    texture     = "bitmaps/Other/Poof.png",
    particles   = 1.55,
  },
  core = {
    fxtype          = "NanoLasers",
    alpha           = "0.2+count/30",
    corealpha       = "0.7+count/15",
    corethickness   = "limcount",
    streamThickness = "1+4*limcount",
    streamSpeed     = "(inversed)and(70-count) or (120-count*3)",
  },
  unknown = {
    fxtype          = "NanoLasers",
    alpha           = "0.2+count/30",
    corealpha       = "0.7+count/15",
    corethickness   = "limcount",
    streamThickness = "1+4*limcount",
    streamSpeed     = "(inversed)and(70-count) or (120-count*3)",
  },
}

local function UnitCmdDone(_,unitID,unitDefID,unitTeam,cmdID)
  local unitLasers = nanoLasers[unitID]
  if (unitLasers) then
    for i=1,#unitLasers do
      Lups.RemoveParticles(unitLasers[i])
    end
    nanoLasers[unitID] = nil
  end
end

local function UnitDestroyed(_,unitID,unitDefID)
  if (nanoParticles[unitID]) then
    local effects = nanoParticles[unitID]
    for i=1,#effects do
      Lups.RemoveParticles(effects[i])
    end
    nanoParticles[unitID] = nil
  end

  if (nanoLasers[unitID]) then
    local unitLasers = nanoLasers[unitID]
    for i=1,#unitLasers do
      Lups.RemoveParticles(unitLasers[i])
    end
    nanoLasers[unitID] = nil
  end
end

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

function GetUnitPiecePos(unit,piece)
  local x,y,z = spGetUnitViewPosition(unit,false)
  local front,up,right = spGetUnitVectors(unit)
  local px,py,pz = spGetUnitPiecePosition(unit,piece)
  return x + (pz*front[1] + py*up[1] + px*right[1]),
         y + (pz*front[2] + py*up[2] + px*right[2]),
         z + (pz*front[3] + py*up[3] + px*right[3])
end

  function GameFrame(_,offset)
	if (nanoEmitters[offset] ~= nil) then
		for unitID,nanoInfo in pairs(nanoEmitters[offset]) do

		  local count,type,radius,terraform,inversed = nanoInfo.strength,nil,0,false,false
		  local x2,y2,z2 = 0,0,0

		  buildID = GetUnitIsBuilding(unitID)
		  if (buildID) then
			x2,y2,z2 = GetUnitPosition(buildID)
			type   = "building"
			radius = GetUnitRadius(buildID)*0.70
		  else
			local cmds = GetUnitCommands(unitID,1)
			if (cmds)and(cmds[1]) then
			  local cmd   = cmds[1]
			  local cmdID = cmd.id

			   if     cmdID == CMD_RECLAIM then
				if (not cmd.params[2]) then
				  count = 30 --//(you normally reclaim always with 100% power)
				  local reclaimID = cmd.params[1]
				  if (reclaimID>=Game.maxUnits) then --//is featureID
					reclaimID = reclaimID - Game.maxUnits
					x2,y2,z2  = GetFeaturePosition(reclaimID)
					if (x2) then
					  radius    = GetFeatureRadius(reclaimID)
					  type      = "reclaim"
					  inversed  = true
					end
				  elseif (reclaimID>0) then --//is unitID
					x2,y2,z2  = GetUnitPosition(reclaimID)
					if (x2) then
					  radius    = GetUnitRadius(reclaimID)*0.80
					  type      = "reclaim"
					  inversed  = true
					end
				  end
				end

			  elseif cmdID == CMD_REPAIR  then
				local repairID = cmd.params[1]
				x2,y2,z2  = GetUnitPosition(repairID)
				if (x2) then
				  radius    = GetUnitRadius(repairID)*0.80
				  type      = "repair"
				end

			  elseif cmdID == CMD_RESTORE then
				type      = "restore"
				x2,z2     = cmd.params[1],cmd.params[3]
				y2        = GetGroundHeight(x2,z2)+5
				radius    = cmd.params[4]
				terraform = true

			  elseif cmdID == CMD_CAPTURE then
				local captureID = cmd.params[1]
				x2,y2,z2  = GetUnitPosition(captureID)
				if (x2) then
				  radius    = GetUnitRadius(captureID)*0.80
				  type      = "capture"
				end

			  elseif cmdID == CMD_RESURRECT then
				local rezzID = cmd.params[1] - Game.maxUnits
				x2,y2,z2  = GetFeaturePosition(rezzID)
				if (x2) then
				  radius    = GetFeatureRadius(rezzID)*0.80
				  type      = "resurrect"
				end

			  end
			end
		  end

		  if (type) then
			for i=1,nanoInfo.pieceCount do
			  local x1,y1,z1 = GetUnitPiecePos(unitID,nanoInfo[i])
			  local pos = {x1,y1,z1}
			  local dir = {x2-x1,y2-y1,z2-z1}

			  nanoParams = {
				unitID    = unitID,
				unitDefID = nanoInfo.unitDefID,
				teamID    = nanoInfo.teamID,
				allyID    = nanoInfo.allyID,
				nanopiece = nanoInfo[i],
				pos       = pos,
				count     = count,
				color     = GetTeamColor(nanoInfo.teamID),
				type      = type,
				dir       = dir,
				radius    = radius,
				terraform = terraform,
				inversed  = inversed
			  }


			  local faction = GetFaction(nanoParams.unitDefID)
			  local nanoSettings = CopyMergeTables(factionsNanoFx[faction] or factionsNanoFx.unknown,nanoParams)
			  ExecuteLuaCode(nanoSettings)

			  --//FIXME: atm, only laser are turned off when the nano cmd is finished,
			  --// also it destroys the fx. preferable would be that both (particles and lasers)
			  --// FADE OFF when done.

			  local fxType  = nanoSettings.fxtype
			  local fxTable = ((fxType=="nanolasers") and nanoLasers) or nanoParticles
			  if (not fxTable[unitID]) then fxTable[unitID] = {} end
			  local unitFxs = fxTable[unitID]
			  unitFxs[#unitFxs+1] = Lups.AddParticles(nanoSettings.fxtype,nanoSettings)
			end
		  end

		end --//for
	end
  end

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

function gadget:Update()
  if (Spring.GetGameFrame()<1) then 
    return
  end

  gadgetHandler:RemoveCallIn("Update")

  Lups = GG['Lups']

  if (Lups) then
    initialized=true
  else
    return
  end

  --// enable freaky arm nano fx when quality>4
  if ((Lups.Config["quality"] or 4)>=4) then
    factionsNanoFx.arm = factionsNanoFx["arm_high_quality"]
  end

  --// init user custom nano fxs
  for faction,fx in pairs(Lups.Config or {}) do
    if (fx and (type(fx)=='table') and fx.fxtype) then
      local fxType = fx.fxtype 
      local fxSettings = fx

      if (fxType)and
         ((fxType:lower()=="nanolasers")or
          (fxType:lower()=="nanoparticles"))and
         (fxSupported(fxType))and
         (fxSettings)
      then
        factionsNanoFx[faction] = fxSettings
      end
    end
  end

  for faction,fx in pairs(factionsNanoFx) do
    if (not fxSupported(fx.fxtype or "noneNANO")) then
      factionsNanoFx[faction] = factionsNanoFx.unknown
    end

    local factionNanoFx = factionsNanoFx[faction]
    factionNanoFx.delaySpread = 30
    factionNanoFx.fxtype = factionNanoFx.fxtype:lower()
    if ((Lups.Config["quality"] or 3)>=3)and((factionNanoFx.fxtype=="nanolasers")or(factionNanoFx.fxtype=="nanolasersshader")) then
      factionNanoFx.flare = true
    end

    --// parse lua code in the table, so we can execute it later
    ParseLuaCode(factionNanoFx)
  end

end

  function nanoPiece1(_, unitID, piecenum, piece)
    local offset = unitID%30
    local emitter = nanoEmitters[offset][unitID]
    emitter.strength = emitter.strength+1
    if bit_and( emitter.nanoPieces,bit_bits(piecenum) )==0 then
        emitter.nanoPieces = bit_or( emitter.nanoPieces, bit_bits(piecenum) )
        emitter.pieceCount = emitter.pieceCount+1
        emitter[emitter.pieceCount] = piece
      end
  end


  function nanoPiece2(_, unitID, teamID, unitDefID, ally, piecenum, piece)
    local offset = unitID%30
    nanoEmitters[offset][unitID] = {
            teamID = teamID,
            unitDefID = unitDefID,
            allyID = ally,
            strength = 1,
            pieceCount = 1,
            nanoPieces = bit_bits(piecenum),
            [1] = piece,
	}
  end

  function gadget:Initialize()
    gadgetHandler:AddSyncAction("nano_unit_destroyed", UnitDestroyed)
    gadgetHandler:AddSyncAction("nano_unit_cmddone",   UnitCmdDone)
    gadgetHandler:AddSyncAction("nano_GameFrame",      GameFrame)
    gadgetHandler:AddSyncAction("npc1", nanoPiece1)
    gadgetHandler:AddSyncAction("npc2", nanoPiece2)
  end

  function gadget:Shutdown()
    gadgetHandler:RemoveSyncAction("nano_unit_destroyed")
    gadgetHandler:RemoveSyncAction("nano_unit_cmddone")
    gadgetHandler:RemoveSyncAction("nano_GameFrame")
    gadgetHandler:RemoveSyncAction("npc1")
    gadgetHandler:RemoveSyncAction("npc2")
  end

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
end
