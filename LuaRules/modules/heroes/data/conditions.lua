local moduleInfo = {
	name 	= "heroesConditions",
	desc	= "Heroes powers conditions logic", -- here we just call TSP actions with proper parameters
	author 	= "PepeAmpere",
	date 	= "2015/08/20",
	license = "notAlicense",
}

-- SPEED-UPS
-- read
local spGetUnitStockpile 	= Spring.GetUnitStockpile

local newConditions = {
	["heroes"] = {
		["stockpile"] = {
			["NotEmpty"] = function(unitID)
				local stockpile = spGetUnitStockpile(unitID)
				if (stockpile > 0) then
					return true, {stockpile = stockpile}
				end
				return false, {}
			end,
			["MaxCheck"] = function(abilityInfo, abilityDefinition)
				local unitID = abilityInfo.unitID
				local stockpile, stockqueue, buildpercent = spGetUnitStockpile(unitID)
				local actualMaxStockpile = abilityDefinition.perLevel.maxStockpile * abilityInfo.level
				
				if (stockqueue + stockpile > actualMaxStockpile) then
					return true, stockpile, actualMaxStockpile
				end
				return false
			end,
		},
	},
}

-- END OF MODULE DEFINITIONS --

-- update global tables 
if (conditions == nil) then conditions = {} end
for k,v in pairs(newConditions) do
	if (conditions[k] ~= nil) then Spring.Echo("NOTIFICATION: Attempt to rewrite global table in module [" .. moduleInfo.name ..  "] - key: " .. k) end
	conditions[k] = v 
end