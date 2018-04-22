local moduleInfo = {
	name 	= "heroesAbilitiesDefs",
	desc	= "All heroes abilities", 
	author 	= "PepeAmpere",
	date 	= "2015/08/10",
	license = "notAlicense",
}

-- possible events for each ability
-- * onActivation
-- * onDeactivation
-- * onFrame
-- * onInit
-- * onPreactivation (before onActivation - condition of activation)
-- * onReadyUp
-- * onRechargeEnd (before to onReadyUp)
-- * onRechargeStart
-- * onRechargeStep
-- * onRunningEnd
-- * onRunningStart (after to onActivation)
-- * onRunningStep


newAbilityDefs = {
	["PlantNukeMine"] = {
		-- custom prerequisities:
		-- * CallCOBScript - "PlantBomb"
		-- * maxStockpile parameter
		recharge = {
			steps = 1,
			stepLenght = {0, 0, 5, 0},
		},
		running = { 
			steps = 0,
			stepLenght = {0, 0, 0, 0},
		},
		perLevel = {
			maxStockpile = 1,
		},
		events = {
			onActivation = function(abilityInfo, unitID, unitDefID, unitTeamID, cmdID, cmdParams, cmdOptions, cmdTag, synced, preactivationData)
				-- define mine type and pass data about actual stockpile size
				local mineUnitDefName = "cormine1"
				local stockpile = preactivationData.stockpile
				
				return actions.heroes.PlantMine(unitID, mineUnitDefName, stockpile)
			end,
			onFrame = function(abilityInfo, abilityDefinition, frameNumber)
				-- keep max stockpile
				local overMaxStockpile, stockpile, maxStockpile = conditions.heroes.stockpile.MaxCheck(abilityInfo, abilityDefinition)
				if (overMaxStockpile) then
					actions.heroes.stockpile.ResetMax(abilityInfo.unitID, stockpile, maxStockpile)
				end
				return true
			end,
			onPreactivation = function(abilityInfo, unitID, unitDefID, unitTeamID, cmdID, cmdParams, cmdOptions, cmdTag, synced)
				return conditions.heroes.stockpile.NotEmpty(unitID)
			end,
		},
	},
	["PlantEMPMinefield"] = {
		-- custom prerequisities:
		-- * CallCOBScript - "PlantBomb"
		-- * maxStockpile parameter
		recharge = {
			steps = 1,
			stepLenght = {0, 0, 5, 0},
		},
		running = { 
			steps = 0,
			stepLenght = {0, 0, 0, 0},
		},
		perLevel = {
			maxStockpile = 4,
		},
		events = {
			onActivation = function(abilityInfo, unitID, unitDefID, unitTeamID, cmdID, cmdParams, cmdOptions, cmdTag, synced, preactivationData)
				-- define mine type and pass data about actual stockpile size
				local mineUnitDefName = "armmine4"
				local stockpile = preactivationData.stockpile
				
				return actions.heroes.PlantMinefield(unitID, mineUnitDefName, stockpile)
			end,
			onFrame = function(abilityInfo, abilityDefinition, frameNumber)
				-- keep max stockpile
				local overMaxStockpile, stockpile, maxStockpile = conditions.heroes.stockpile.MaxCheck(abilityInfo, abilityDefinition)
				if (overMaxStockpile) then
					actions.heroes.stockpile.ResetMax(abilityInfo.unitID, stockpile, maxStockpile)
				end
				return true 
			end,
			onPreactivation = function(abilityInfo, unitID, unitDefID, unitTeamID, cmdID, cmdParams, cmdOptions, cmdTag, synced)
				return conditions.heroes.stockpile.NotEmpty(unitID)
			end,
		},
	},
}

-- END OF MODULE DEFINITIONS --

-- update global tables 
if (abilityDefs == nil) then abilityDefs = {} end
for k,v in pairs(newAbilityDefs) do
	if (abilityDefs[k] ~= nil) then Spring.Echo("NOTIFICATION: Attempt to rewrite global table in module [" .. moduleInfo.name ..  "] - key: " .. k) end
	abilityDefs[k] = v 
end