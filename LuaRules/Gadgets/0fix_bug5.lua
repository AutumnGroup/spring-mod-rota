--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "0fix_bug5",
    desc      = "Fix weapon of bug5 for engine 94.1",
    author    = "PepeAmpere",
    date      = "Jul 28, 2013",
    license   = "notAlicense",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

-- synced only
if (not gadgetHandler:IsSyncedCode()) then
	return false
end

local spSetUnitWeaponState 	= Spring.SetUnitWeaponState
local spGetUnitNearestEnemy = Spring.GetUnitNearestEnemy
local spUnitWeaponFire 		= Spring.UnitWeaponFire
local spGiveOrderToUnit		= Spring.GiveOrderToUnit
local spGetUnitPosition		= Spring.GetUnitPosition

local bugs					= {}
local needWeaponFix			= {}
local bugUnitDefID			= 0
local darkswarmDefID		= 0
local weaponNumber			= 1

-- Spring.Echo(Engine.version)
if (tonumber(Engine.version) >= 95) then
	weaponNumber = 2
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
    if (bugUnitDefID == unitDefID) then
		bugs[unitID] = 0
		needWeaponFix[unitID] = true
	end
	if (darkswarmDefID == unitDefID) then
		spSetUnitWeaponState(builderID,weaponNumber,"range",110)
		bugs[builderID] = 28
		needWeaponFix[builderID] = true
	end
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
	if (bugs[unitID]) then
		bugs[unitID] = nil
	end
end

function gadget:GameFrame(n)
    if ((n % 30) == 0) then
        for unitID,seconds in pairs(bugs) do

			if ((seconds ~= nil) and (seconds ~= 0)) then
				bugs[unitID] = seconds - 1
				--Spring.Echo(bugs[unitID])
			end

			if (seconds < 1 and needWeaponFix[unitID]) then
				spSetUnitWeaponState(unitID,weaponNumber,"range",560)
				needWeaponFix[unitID] = false
			end
		end
	end
end

function gadget:Initialize()
	for id,unitDef in pairs(UnitDefs) do
		local uName = unitDef.name
		if (uName == "bug5") then
			bugUnitDefID = unitDef.id
		end
		if (uName == "darkswarmunit") then
			darkswarmDefID = unitDef.id
		end
	end
end
