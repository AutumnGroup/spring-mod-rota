-- $Id: unit_is_on_fire.lua 3309 2008-11-28 04:25:20Z google frog $

function gadget:GetInfo()
  return {
    name      = "Units on fire",
    desc      = "Aaagh! It burns! It burns!",
    author    = "quantum",
    date      = "Mar, 2008",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
if (gadgetHandler:IsSyncedCode()) then
-- BEGIN SYNCED
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

Spring.SetGameRulesParam("unitsOnFire",1)

--// customparams values
-- setunitsonfire: 
--    iff a weapon has this tag set to anything it will set units on fire.
-- burntime: 
--    burntime of weapon in frames. defaults to DEFAULT_BURN_TIME*firestarter/100
-- burntimerand: 
--    adds randomness to burntime. Defaults to DEFAULT_BURN_TIME_RANDOMNESS
--    Constant random distribution over domain [burntime*(1-burnTimeRand),burntime]. 
-- burnchance: 
--    Chance of a unit to be set on fire when hit. Defaults to firestarter/1000
-- burndamage: 
--    Damage per frame of burning. Defaults to DEFAULT_BURN_DAMAGE

--//SETTINGS

local DEFAULT_BURN_TIME = 600
local DEFAULT_BURN_TIME_RANDOMNESS = 0.3
local DEFAULT_BURN_DAMAGE = 0.5
local MIN_IMMERSION_FOR_EXTINGUISH = 0.8

local CHECK_INTERVAL = 6

--//VARS

local gameFrame = 0

--//LOCALS

local random = math.random
local Spring = Spring
local gadget = gadget
local AreTeamsAllied    = Spring.AreTeamsAllied
local GetGameFrame      = Spring.GetGameFrame
local AddUnitDamage     = Spring.AddUnitDamage
local SetUnitRulesParam = Spring.SetUnitRulesParam
local SetUnitCloak      = Spring.SetUnitCloak

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function cpv(value)
	return value and tonumber(value) 
end

-- NOTE: fireStarter is divided by 100 somewhere in the engine between weapon defs and here.

local flamerWeaponDefs = {}
for i=1,#WeaponDefs do
	local wcp = WeaponDefs[i].customParams or {}
	if (wcp.setunitsonfire) then -- stupid tdf
		--// (fireStarter-tag: 1.0->always flame trees, 2.0->always flame units/buildings too) -- citation needed
	
		flamerWeaponDefs[i] = {
			burnTime = cpv(wcp.burntime) or WeaponDefs[i].fireStarter*DEFAULT_BURN_TIME,
			burnTimeRand = cpv(wcp.burntimerand) or DEFAULT_BURN_TIME_RANDOMNESS,
			burnTimeBase = 1 - (cpv(wcp.burntimerand) or DEFAULT_BURN_TIME_RANDOMNESS),
			burnChance = cpv(wcp.burnchance) or WeaponDefs[i].fireStarter/10,
			burnDamage = cpv(wcp.burndamage) or DEFAULT_BURN_DAMAGE,
		}
		
		flamerWeaponDefs[i].maxDamage = flamerWeaponDefs[i].burnDamage*flamerWeaponDefs[i].burnTime
	end
end

local unitsOnFire = {}
local inWater = {}
local inGameFrame = false

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function CheckImmersion(unitID)
    local pos = select(2, Spring.GetUnitBasePosition(unitID))
    local height = Spring.GetUnitHeight(unitID)
    if pos < -(height * MIN_IMMERSION_FOR_EXTINGUISH) then
	return true
    end
    return false
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function gadget:UnitEnteredWater(unitID, unitDefID, unitTeam)
        inWater[unitID] = true
end

function gadget:UnitLeftWater(unitID, unitDefID, unitTeam)
        inWater[unitID] = nil
end


function gadget:UnitDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponID,
                            attackerID, attackerDefID, attackerTeam)
	if (inGameFrame) then return end  --ignore own AddUnitDamage calls
  
	if (flamerWeaponDefs[weaponID]) then
		local fwd = flamerWeaponDefs[weaponID]
		if (UnitDefs[unitDefID].customParams.fireproof~="1") then
			if (random() < fwd.burnChance) then
				if (not unitsOnFire[unitID]) or unitsOnFire[unitID].damageLeft < fwd.maxDamage then
					local burnLength = fwd.burnTime*(random()*fwd.burnTimeRand + fwd.burnTimeBase)
					unitsOnFire[unitID] = {
						endFrame    = gameFrame + burnLength, 
						damageLeft  = burnLength*fwd.burnDamage,
						fireDmg     = fwd.burnDamage,
						attackerID  = attackerID,
						--attackerDefID = attackerDefID,
						weaponID    = weaponID,
					}
					SetUnitCloak(unitID, false, 10000)
					SetUnitRulesParam(unitID, "on_fire", 1, {inlos = true})
					SendToUnsynced("onFire", unitID)
				end
			end
		end
	end
end

function gadget:UnitDestroyed(unitID)
	inWater[unitID] = nil
	if (unitsOnFire[unitID]) then
		unitsOnFire[unitID] = nil
		SendToUnsynced("nonFire", unitID)
	end
end

function gadget:GameFrame(n)
	gameFrame = n
	if (n%CHECK_INTERVAL<1)and(next(unitsOnFire)) then
    inGameFrame = true
		for unitID, t in pairs(unitsOnFire) do
			if (n > t.endFrame) or (inWater[unitID] and CheckImmersion(unitID)) then
				SetUnitRulesParam(unitID, "on_fire", 0,{inlos = true})
				SetUnitCloak(unitID, false, false)
				unitsOnFire[unitID] = nil
				SendToUnsynced("nonFire", unitID)
			else
				t.damageLeft = t.damageLeft - t.fireDmg*CHECK_INTERVAL
				AddUnitDamage(unitID,t.fireDmg*CHECK_INTERVAL,0,t.attackerID, t.weaponID )
				--Spring.Echo(t.attackerDefID)
			end
		end
    inGameFrame = false 
	end
	SendToUnsynced("fire_gf")
end


--------------------------------------------------------------------------------
-- END SYNCED
--------------------------------------------------------------------------------
else
--------------------------------------------------------------------------------
-- BEGIN UNSYNCED
--------------------------------------------------------------------------------

local scLuaUI = Script.LuaUI
local burningUnits = {}
local burningChanged = false

local function onFire(_, unitID)
	burningUnits[unitID] = true
	burningChanged = true
end

local function NonFire(_, unitID)
	burningUnits[unitID] = nil
	burningChanged = true
end

local function GameFrame(_)
	if burningChanged and scLuaUI('onFire') then
		scLuaUI.onFire(burningUnits)
	end
	burningChanged = false
end

function gadget:Initialize()
	gadgetHandler:AddSyncAction('onFire',onFire)
	gadgetHandler:AddSyncAction('nonFire',NonFire)
	gadgetHandler:AddSyncAction('fire_gf',GameFrame)
end

function gadget:Shutdown()
	gadgetHandler:RemoveSyncAction('onFire')
	gadgetHandler:RemoveSyncAction('nonFire')
	gadgetHandler:RemoveSyncAction('fire_gf')
end

end

