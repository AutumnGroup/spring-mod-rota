local moduleInfo = {
	name 	= "resources",
	desc	= "resources API",
	author 	= "PepeAmpere",
	date 	= "2015/12/06",
	license = "notAlicense",
}

-- DEPENDENCIES
-- * constants
-- * unit tables
-- * team tables
-- * resources tables
-- * resource mod tables
-- in case of problems check module init if all parts were loaded properly

-- speedups
local next  	= next
local pairs 	= pairs
local min 		= math.min

newResources = {	
	-- 1ST LAYER of READ
	["GetUnitResourceModeSimData"] = function(modeName, unitName, resourceName)
		if (modeName == "default") then
			return resourcesPerUnitName[unitName][resourceName]
		else
			return resourcesModes[modeName].simulation
		end
	end,
	
	-- 1ST LAYER of WRITE
	["CustomProcedurePerEvent"] = function(eventName, unitID, unitDefID, unitTeamID)
		for i=1, #resourcesTypes do
			if (resourcesTypes[i].events ~= nil) then
				local CustomFunction = resourcesTypes[i].events[eventName]
				if (CustomFunction ~= nil) then
					local teamName = GetTeamNameFromID(unitTeamID)
					CustomFunction(unitID, unitDefID, unitTeamID, teamResourcesData[teamName][i])
				end
			end
		end
	end,
	["UpdateTeam"] = function(teamName, resourceName, resourcesAdded, storageSizeAdded, incomeAdded, consumptionAdded)
		local resourceIndex = resourcesNameToIndex[resourceName]
		local thisResourceData = teamResourcesData[teamName][resourceIndex]
		
		-- storage is never bigger than storage size
		local newStorage = thisResourceData.storage + resourcesAdded
		local newStorageSize = thisResourceData.storageSize + storageSizeAdded
		if (newStorageSize < newStorage) then newStorage = newStorageSize end
		
		local newTeamResourceData = {
			storage = newStorage,
			storageSize = newStorageSize,
			lastIncome = thisResourceData.lastIncome + incomeAdded,
			lastConsumption = thisResourceData.lastConsumption + consumptionAdded,
		}
		teamResourcesData[teamName][resourceIndex] = newTeamResourceData
		
		-- for UI needs
		sendCustomMessage.resources_teamUpdate(teamName, resourceName, newTeamResourceData)
		
		--Spring.Echo(newTeamResourceData.storage, newTeamResourceData.storageSize, newTeamResourceData.lastIncome, newTeamResourceData.lastConsumption)
	end,	
	-- @parameter flowDiff (number|optional) - used in case we do direct withdraw of the resource from the personal storage (not simulated by modes)
	["UpdateUnit"] = function(unitID, unitName, resourceName, resourceData, resourceDefsData, ResourceUpdateUnit, flowDiff)
		-- internal calc
		local oldStorage = resourceData.storage
		local shortage = resourceData.shortage
		local storageSize = resourceData.storageSize		
		
		if (flowDiff == nil) then
			local limits = unitResourcesData[unitID][resourceName].limits
			flowDiff = min(resourceDefsData.incomeUnit, limits.incomeUnit) - min(resourceDefsData.consumptionUnit, limits.consumptionUnit) 
		end
		local newStorage = oldStorage + flowDiff
		local newShortage = shortage
		
		if (flowDiff == 0) then return 0 end -- in case of no change do no updates
		
		if (flowDiff > 0) then -- income bigger than consumption
			if (storageSize < newStorage) then -- storage is full, extra res are lost
				newStorage = storageSize 
			end
			newShortage = false
		else -- bigger consumption
			if (newStorage < 0) then
				newStorage = 0
			end
			if (newStorage == 0) then
				newShortage = true
			end
		end	
		
		-- update storage
		unitResourcesData[unitID][resourceName].storage = newStorage
		
		-- resource specific function if defined
		if (ResourceUpdateUnit ~= nil) then
			ResourceUpdateUnit(unitID, newStorage)
		end
		
		if (shortage ~= newShortage) then -- if there was change
			-- update shortage flag
			unitResourcesData[unitID][resourceName].shortage = newShortage
			
			-- inform Game and UI about shortage
			sendCustomMessage.resources_unitResourceShortageChanged(unitID, resourceName, newShortage)
		end
		
		-- inform Game and UI about storage update
		if (oldStorage ~= newStorage) then
			sendCustomMessage.resources_unitResourceStorageChanged(unitID, resourceName, newStorage, unitResourcesData[unitID][resourceName], flowDiff)
		end

		-- return diff
		return oldStorage - newStorage
	end,
	
	-- 2ND LAYER
	["event"] = {
		["all"] = {
			["teams"] = function(resourceFrequencyMultiplier)
				-- increase resources for each team
				for teamName, teamAllResData in pairs (teamResourcesData) do
					-- increase resources for each resource
					for i=1, #teamAllResData do
						local thisResData = teamAllResData[i]
						local finalIncome = (thisResData.lastIncome - thisResData.lastConsumption) * resourceFrequencyMultiplier
						resources.UpdateTeam(teamName, resourcesIndexToName[i], finalIncome, 0, 0, 0)
					end
				end
			end,
			["units"] = function(resourceFrequencyMultiplier)
				-- SPEEDUP - localize all update functions
				local updateFunctions = {}
				for i=1, #resourcesTypes do
					if (resourcesTypes[i].events ~= nil) then
						updateFunctions[resourcesTypes[i].name] = resourcesTypes[i].events["unitUpdate"]
					end
				end
			
				-- update all units personal resources
				for unitID, resourcesList in pairs(unitResourcesData) do -- for each unit
					for resourceName, thisResourceData in pairs(resourcesList) do -- for each resource which we simulate on personal level
						-- Spring.Echo(unitID .. ":" .. tostring(resourcesList) .. ":" .. resourceName .. ":" .. tostring(thisResourceData))
						if (thisResourceData.simulationEnabled) then
							if (thisResourceData.mode == "default") then -- in case of default setup
								local unitName = fromIDToName[unitID]
								local unitDefResourceInfo = resourcesPerUnitName[unitName]
								local thisResourceDefsData = unitDefResourceInfo[resourceName]
								
								if (thisResourceDefsData ~= nil) then
									resources.UpdateUnit(unitID, unitName, resourceName, thisResourceData, thisResourceDefsData, updateFunctions[resourceName])
								else
									Spring.Echo("[" .. MODULE_NAME .. "] ERROR: bad resourcesPerUnitName definition for unitName [" .. unitName .. "] for resource [" .. resourceName .. "] is not defined")
								end
							else
								local thisResourceModeData = resourcesModes[thisResourceData.mode].simulation -- get replacement data
								if (thisResourceModeData ~= nil) then
									resources.UpdateUnit(unitID, unitName, resourceName, thisResourceData, thisResourceModeData, updateFunctions[resourceName]) -- replace it by mode data
								else
									Spring.Echo("[" .. MODULE_NAME .. "] ERROR: given resourceMode [" .. thisResourceData.mode .. "] for resource [" .. resourceName .. "] is not defined")
								end
							end
						end
					end
				end
			end,
			["gameInit"] = function()
				-- for each team
				for teamName, teamAllResData in pairs (teamResourcesData) do
					-- set each resource to zero
					for i=1, #teamAllResData do
						resources.UpdateTeam(teamName, resourcesIndexToName[i], 0, 0, 0, 0)
					end
				end
			end,
		},
		["team"] = {
			["unitReceived"] = function(teamName, resourceName, resourceDefData)
				local limits = resourceDefData.limits
				
				if (limits == nil) then -- simplified without limits
					resources.UpdateTeam(
						teamName, 
						resourceName, 
						resourceDefData.resourceAddedTeam, 
						resourceDefData.storageTeam, 
						resourceDefData.incomeTeam, 
						resourceDefData.consumptionTeam
					)
				else				
					resources.UpdateTeam(
						teamName, 
						resourceName, 
						resourceDefData.resourceAddedTeam, 
						resourceDefData.storageTeam, 
						min(resourceDefData.incomeTeam, limits.incomeTeam), 
						min(resourceDefData.consumptionTeam, limits.consumptionTeam)
					)
				end
			end,
			["unitLost"] = function(teamName, resourceName, resourceDefData)
				local limits = resourceDefData.limits
				
				if (limits == nil) then -- simplified without limits
					resources.UpdateTeam(
						teamName, 
						resourceName, 
						resourceDefData.resourceLostTeam, 
						-resourceDefData.storageTeam, 
						-resourceDefData.incomeTeam,
						-resourceDefData.consumptionTeam
					)
				else				
					resources.UpdateTeam(
						teamName, 
						resourceName, 
						resourceDefData.resourceLostTeam, 
						-resourceDefData.storageTeam, 
						-(min(resourceDefData.incomeTeam, limits.incomeTeam)), 
						-(min(resourceDefData.consumptionTeam, limits.consumptionTeam))
					)
				end
			end,
			["personalResourceModeChanged"] = function(unitID, teamName, unitName, resourceName, newModeName, oldModeName, newLimits, oldLimits)
				local oldModeDefData = resources.GetUnitResourceModeSimData(oldModeName, unitName, resourceName)
				local newModeDefData = resources.GetUnitResourceModeSimData(newModeName, unitName, resourceName)
				resources.UpdateTeam(
					teamName, 
					resourceName, 
					0, 
					newModeDefData.storageTeam - oldModeDefData.storageTeam, 
					min(newModeDefData.incomeTeam, newLimits.incomeTeam) - min(oldModeDefData.incomeTeam, oldLimits.incomeTeam), 
					min(newModeDefData.consumptionTeam, newLimits.consumptionTeam) - min(oldModeDefData.consumptionTeam, oldLimits.incomeTeam)
				)
			end,
		},
		["unit"] = {
			["initPersonalRes"] = function(unitID, unitDefID, unitTeamID)
				local unitName = fromDefIDToNameTable[unitDefID]
				local unitDefResourceInfo = resourcesPerUnitName[unitName]
				
				-- init helper table
				fromIDToName[unitID] = unitName
				
				-- do res init
				if (next(unitDefResourceInfo) ~= nil) then -- we do not simulate unit-resources for units without definition, same with modes
					unitResourcesData[unitID] = {}
					
					for resourceName, resourceDefData in pairs (unitDefResourceInfo) do -- if unitDefResourceInfo is empty, we do nothing
						if (resourceDefData.storageUnit > 0) then -- if given unit personal storage is non-zero by definition, we simulate its personal storage (otherwise not)
							unitResourcesData[unitID][resourceName] = {
								mode = "default",
								simulationEnabled = true,
								shortage = false,
								storage = resourceDefData.resourceAddedUnit,
								storageSize = resourceDefData.storageUnit,
								limits = { -- slightly hacky solution to have transfer limits
									incomeTeam = math.huge,
									consumptionTeam = math.huge,
									incomeUnit = math.huge,
									consumptionUnit = math.huge,
								},
							}
						else
							unitResourcesData[unitID][resourceName] = {
								mode = "default",
								simulationEnabled = false,
							}
						end
					end
					
					-- send initialized data to the rest of the game (for all res at once)
					sendCustomMessage.resources_unitInitPersonalRes(unitID, unitDefID, unitResourcesData[unitID])
					
					-- send UI update
					for resourceName, resourceData in pairs (unitResourcesData[unitID]) do
						sendCustomMessage.resources_unitResourceStorageChanged(unitID, resourceName, resourceData.storage or 0, resourceData, 0)
					end
				end
			end,
			["consumePersonalRes"] = function(unitID, unitName, resourceName, consumed)
				if (unitResourcesData[unitID] == nil) then -- there is no personal resource simulation running on this unit
					return
				end
				resources.UpdateUnit(unitID, unitName, resourceName, unitResourcesData[unitID][resourceName], nil, nil, -consumed)
			end,
			["personalResourceModeChanged"] = function(unitID, teamName, unitName, resourceName, newModeName, newLimits)
				unitResourcesData[unitID][resourceName].mode = newModeName
				unitResourcesData[unitID][resourceName].limits = newLimits
			end,
			["removePersonalRes"] = function(unitID, unitDefID, unitTeamID)
				if (unitResourcesData[unitID] == nil) then -- there is no personal resource simulation running on this unit
					return
				end
				
				-- send initialized data to the rest of the game (for all res at once)
				sendCustomMessage.resources_unitRemovePersonalRes(unitID, unitDefID, unitResourcesData[unitID])
				
				fromIDToName[unitID] = nil
				unitResourcesData[unitID] = nil
			end,
		},
	},
	
	-- 3RD LAYER
	["TeamChangePerEvent"] = function(eventName, unitID, unitDefID, unitTeamID)
		local unitName = fromDefIDToNameTable[unitDefID]
		local unitDefResourceInfo = resourcesPerUnitName[unitName]
		local thisUnitResourceData = unitResourcesData[unitID]
		local teamName = GetTeamNameFromID(unitTeamID)
		
		-- in case unit has no resourcing defined, return
		if (unitDefResourceInfo == nil) then return end
		
		for resourceName, resourceDefData in pairs (unitDefResourceInfo) do
			if (thisUnitResourceData == nil or thisUnitResourceData[resourceName] == nil or thisUnitResourceData[resourceName].mode == "default") then -- in case of default mode or not set mode we use default simple event call without 4th parameter
				resources.event.team[eventName](teamName, resourceName, resourceDefData)
			
			-- everything below is resource mode specific
			else
				local thisResourceModeData = resourcesModes[thisUnitResourceData[resourceName].mode] -- get replacement data
				if (thisResourceModeData ~= nil) then
					resources.event.team[eventName](teamName, resourceName, thisResourceModeData.simulation) -- replace it by mode data
				else
					Spring.Echo("[" .. MODULE_NAME .. "] ERROR: given resourceMode [" .. thisResourceData.mode .. "] for resource [" .. resourceName .. "] is not defined")
				end
			end
		end
	end,
	
	-- 4TH LAYER
	["Initialize"] = function()
		resources.event.all.gameInit()
	end,
	["CheckTeamUpdate"] = function(frame)
		if (frame % TEAM_RES_UPDATE_FRAME == 0) then
			resources.event.all.teams(TEAM_RES_INCOME_MULT)
		end
	end,
	["CheckUnitUpdate"] = function(frame)
		if (frame % UNIT_RES_UPDATE_FRAME == 0) then
			resources.event.all.units(UNIT_RES_INCOME_MULT)
		end
	end,
	["UnitCreated"] = function(unitID, unitDefID, unitTeamID)
		-- init resource consumption mode
		resources.event.unit.initPersonalRes(unitID, unitDefID, unitTeamID)
	end,	
	["UnitReceived"] = function(unitID, unitDefID, unitTeamID)
		-- change team resources based on custom unit tags
		resources.TeamChangePerEvent("unitReceived", unitID, unitDefID, unitTeamID)
		
		-- run custom procedures per each resource
		resources.CustomProcedurePerEvent("unitReceived", unitID, unitDefID, unitTeamID)
	end,
	["UnitLost"] = function(unitID, unitDefID, unitTeamID)
		-- change team resources based on custom unit tags
		resources.TeamChangePerEvent("unitLost", unitID, unitDefID, unitTeamID)

		-- run custom procedures per each resource
		resources.CustomProcedurePerEvent("unitLost", unitID, unitDefID, unitTeamID)
	end,
	["UnitKilled"] = function(unitID, unitDefID, unitTeamID)
		-- remove personal res simulation
		resources.event.unit.removePersonalRes(unitID, unitDefID, unitTeamID)
	end,
	["UnitResourceModeChanged"] = function(unitID, unitTeamID, unitName, resourceName, newModeName, newLimits)
		-- Spring.Echo(unitID, unitTeamID, unitName, resourceName, newModeName, newLimits)
		local oldModeName = unitResourcesData[unitID][resourceName].mode
		local oldLimits = unitResourcesData[unitID][resourceName].limits
		local teamName = GetTeamNameFromID(unitTeamID)
		
		-- team related part of given event
		resources.event.team.personalResourceModeChanged(unitID, teamName, unitName, resourceName, newModeName, oldModeName, newLimits, oldLimits)

		-- unit related part of given event
		resources.event.unit.personalResourceModeChanged(unitID, teamName, unitName, resourceName, newModeName, newLimits)
	end,
	["UnitResourceConsumptionRequest"] = function(unitID, unitName, resourceName, consumed)
		-- decrease personal res storage if possible
		resources.event.unit.consumePersonalRes(unitID, unitName, resourceName, consumed)
	end,
}

-- END OF MODULE DEFINITIONS --

-- update global tables 
if (resources == nil) then resources = {} end
for k,v in pairs(newResources) do
	if (resources[k] ~= nil) then Spring.Echo("NOTIFICATION: Attempt to rewrite global table in module [" .. moduleInfo.name ..  "] - key: " .. k) end
	resources[k] = v 
end