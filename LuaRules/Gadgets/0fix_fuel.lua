--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "0fix_fuel",
    desc      = "Fix fuel of unit when completed",
    author    = "PepeAmpere",
    date      = "Sep 17, 2013",
    license   = "notAlicense",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

-- synced only
if (not gadgetHandler:IsSyncedCode()) then
	return false
end

local spSetUnitFuel = Spring.SetUnitFuel

local unitNeedSetFuel 	= {}
local activefix			= true

-- bug in Spring 94.1 and lower
if ((tonumber(Engine.version) or 95) >= 95) then
	activefix = false
end

function gadget:UnitFinished(unitID, unitDefID, unitTeam)
	local fuel = UnitDefs[unitDefID].maxFuel
	if (fuel) then
		unitNeedSetFuel[tostring(unitID)] = fuel
	end
end

function gadget:GameFrame(n)
	if (n % 30 == 0 and unitNeedSetFuel ~= nil) then
		for id,fuel in pairs(unitNeedSetFuel) do
			spSetUnitFuel(tonumber(id),fuel)
			unitNeedSetFuel[id] = nil
		end
	end
end

function gadget:Initialize()
	if (not activefix) then
		gadgetHandler:RemoveGadget()
	end
end