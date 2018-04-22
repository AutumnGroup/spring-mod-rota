local moduleInfo = {
	name 	= "heroesActions",
	desc	= "Heroes powers actions API", -- here we just call TSP actions with proper parameters
	author 	= "PepeAmpere",
	date 	= "2015/08/10",
	license = "notAlicense",
}

include "LuaRules/modules/core/tsp/actionTypes/actionTypes.lua"

-- SPEED-UPS
-- ctrl
local spCallCOBScript 		= Spring.CallCOBScript
local spGiveOrderToUnit 	= Spring.GiveOrderToUnit
local spSetUnitStockpile 	= Spring.SetUnitStockpile

-- read
local spGetUnitPosition 	= Spring.GetUnitPosition
local spGetUnitTeam 		= Spring.GetUnitTeam

-- cmds
local CMD_STOCKPILE = CMD.STOCKPILE

local newActions = {
	["heroes"] = {
		["PlantMine"] = function(unitID, mineUnitDefName, stockpile)
			-- unitID 			- number	- unitID of hero unit	
			-- mineUnitDefName 	- string 	- defName of mine
			-- stockpile 	 	- number 	- number of mines in stockpile
			
			local _, plant = spCallCOBScript(unitID, "PlantBomb", 1, 1) -- play planting animation

			if (plant == 1) then

				-- planting itself
				local x,y,z = spGetUnitPosition(unitID)
				local heroTeam = spGetUnitTeam(unitID)
				
				-- TBD maybe get hero base team
				actionTypes.Spawn.One(mineUnitDefName, {x,y,z}, heroTeam)
				
				-- update stockpile
				stockpile = stockpile - 1		
				spSetUnitStockpile(unitID, stockpile)
				
				return true
			end
			return false
		end,
		["PlantMinefield"] = function(unitID, mineUnitDefName, stockpile)
			-- unitID 			- number	- unitID of hero unit	
			-- mineUnitDefName 	- string 	- defName of mine
			-- stockpile 	 	- number 	- number of mines in stockpile
			
			-- ! TBD - in the future this will consist own animation and effect so it will be less similar to actions.heroes.PlantMine
			
			local _, plant = spCallCOBScript(unitID, "PlantBomb", 1, 1) -- play planting animation
			
			if (plant == 1) then
				-- planting itself
				local x,y,z = spGetUnitPosition(unitID)
				local heroTeam = spGetUnitTeam(unitID)
				
				-- TBD maybe get hero base team
				actionTypes.Spawn.Complex(mineUnitDefName, {x,y,z}, heroTeam, stockpile, nil, nil, {10, 1, 10})
				
				-- update stockpile
				stockpile = 0 -- we used all mines in stockpile to crete minefield	
				spSetUnitStockpile(unitID, stockpile)
				
				return true
			end
			return false
		end,
		["stockpile"] = {
			["ResetMax"] = function (unitID, stockpile, maxStockpile)
				spGiveOrderToUnit(unitID, CMD_STOCKPILE, {}, { "ctrl", "shift", "right" })
				for i=1, (maxStockpile - stockpile) do
					spGiveOrderToUnit(unitID, CMD_STOCKPILE, {}, { })
				end
			end,
		},
	},
}

-- END OF MODULE DEFINITIONS --

-- update global tables 
if (actions == nil) then actions = {} end
for k,v in pairs(newActions) do
	if (actions[k] ~= nil) then Spring.Echo("NOTIFICATION: Attempt to rewrite global table in module [" .. moduleInfo.name ..  "] - key: " .. k) end
	actions[k] = v 
end