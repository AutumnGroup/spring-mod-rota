local moduleInfo = {
	name 	= "resourcesMessageSender",
	desc 	= "Helper sending custom messages related to notAspace",
	author 	= "PepeAmpere",
	date 	= "2015/01/02",
	license = "notAlicense",
}

-- message module should be loaded head file

-- called as sendCustomMessage.SubjectOfTheMessage
local newSendCustomMessage = {

	-- RULES + UI
	["resources_unitResourceModeChanged"] = function(unitID, unitDefID, resourceName, modeName, partnerUnit)
		if (unitID == nil or type(unitID) ~= "number") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [resources_unitResourceModeChanged] with wrong parameter for [unitID]") end
		if (unitDefID == nil or type(unitDefID) ~= "number") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [resources_unitResourceModeChanged] with wrong parameter for [unitDefID]") end
		if (resourceName == nil or type(resourceName) ~= "string") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [resources_unitResourceModeChanged] with wrong parameter for [resourceName]") end
		if (modeName == nil or type(modeName) ~= "string") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [resources_unitResourceModeChanged] with wrong parameter for [modeName]") end
			
		local newMessage = {
			subject = "resources_unitResourceModeChanged",
			unitID = unitID,
			unitDefID = unitDefID,
			resourceName = resourceName,
			modeName = modeName,
			-- optional
			partnerUnit = partnerUnit,
		}
			
		message.SendSyncedRules(newMessage)
	end,
	["resources_unitResourceShortageChanged"] = function(unitID, resourceName, newValue)
		if (unitID == nil or type(unitID) ~= "number") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [resources_unitResourceShortageChanged] with wrong parameter for [unitID]") end
		if (resourceName == nil or type(resourceName) ~= "string") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [resources_unitResourceShortageChanged] with wrong parameter for [resourceName]") end
		if (newValue == nil or type(newValue) ~= "boolean") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [resources_unitResourceShortageChanged] with wrong parameter for [newValue]") end
		
		local newMessage = {
			subject = "resources_unitResourceShortageChanged",
			unitID = unitID,
			resourceName = resourceName,
			newValue = newValue,
		}
	
		message.SendSyncedRules(newMessage)
	end,
	["resources_unitResourceStorageChanged"] = function(unitID, resourceName, newStorage, unitResourcesData, flowDiff)
		if (unitID == nil or type(unitID) ~= "number") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [resources_unitResourceStorageChanged] with wrong parameter for [unitID]") end
		if (resourceName == nil or type(resourceName) ~= "string") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [resources_unitResourceStorageChanged] with wrong parameter for [resourceName]") end
		if (newStorage == nil or type(newStorage) ~= "number") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [resources_unitResourceStorageChanged] with wrong parameter for [newStorage]") end
		if (unitResourcesData == nil or type(unitResourcesData) ~= "table") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [resources_unitInitPersonalRes] with wrong parameter for [unitResourcesData]") end
		
		local newMessage = {
			unitID = unitID,
			subject = "resources_unitResourceStorageChanged",
			resourceName = resourceName,
			newStorage = newStorage,
			unitResourcesData = unitResourcesData,
		}
		
		-- all info to game
		message.SendSyncedRules(newMessage)
		
		-- optimize, send minumum data
		local uiData = {
			[resourceName .. "Storage"] = newStorage,
			[resourceName .. "Flow"] = flowDiff,
		}
		
		-- update game data so UI can read it
		message.SendSyncedInfoUnit(uiData, unitID, "allied")
	end,
	["resources_unitResourceConsumptionRequest"] = function(unitID, unitDefID, resourceName, requestedAmount)
		if (unitID == nil or type(unitID) ~= "number") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [resources_unitResourceConsumptionRequest] with wrong parameter for [unitID]") end
		if (unitDefID == nil or type(unitDefID) ~= "number") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [resources_unitResourceConsumptionRequest] with wrong parameter for [unitDefID]") end
		if (resourceName == nil or type(resourceName) ~= "string") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [resources_unitResourceConsumptionRequest] with wrong parameter for [resourceName]") end
		if (requestedAmount == nil or type(requestedAmount) ~= "number") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [resources_unitResourceConsumptionRequest] with wrong parameter for [requestedAmount]") end
			
		local newMessage = {
			subject = "resources_unitResourceConsumptionRequest",
			unitID = unitID,
			unitDefID = unitDefID,
			resourceName = resourceName,
			requestedAmount = requestedAmount,
		}
		
		message.SendSyncedRules(newMessage)
	end,
	
	-- @description sending info about unit class resources definitions as it was extracted from the def files
	["resources_unitDefResourceData"] = function(unitDefID, resourceName, resourceDef)
		if (unitDefID == nil or type(unitDefID) ~= "number") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [resources_unitDefResourceData] with wrong parameter for [unitDefID]") end
		if (resourceName == nil or type(resourceName) ~= "string") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [resources_unitDefResourceData] with wrong parameter for [resourceName]") end
		if (resourceDef == nil or type(resourceDef) ~= "table") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [resources_unitDefResourceData] with wrong parameter for [resourceDef]") end
				
		local newMessage = {
			subject = "resources_unitDefResourceData",
			unitDefID = unitDefID,
			resourceName = resourceName,			
			resourceDef = resourceDef,
		}
		
		message.SendSyncedRules(newMessage)
		message.SendUI(newMessage)
	end,
	
	-- INTERNAL ONLY
	["resources_unitInitPersonalRes"] = function(unitID, unitDefID, unitResourcesData)
		if (unitID == nil or type(unitID) ~= "number") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [resources_unitInitPersonalRes] with wrong parameter for [unitID]") end
		if (unitDefID == nil or type(unitDefID) ~= "number") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [resources_unitInitPersonalRes] with wrong parameter for [unitDefID]") end
		if (unitResourcesData == nil or type(unitResourcesData) ~= "table") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [resources_unitInitPersonalRes] with wrong parameter for [unitResourcesData]") end
		
		local newMessage = {
			subject = "resources_unitInitPersonalRes",
			unitID = unitID,
			unitDefID = unitDefID,
			unitResourcesData = unitResourcesData,
		}
		
		message.SendSyncedRules(newMessage)
	end,
	
	["resources_unitRemovePersonalRes"] = function(unitID, unitDefID, unitResourcesData)
		if (unitID == nil or type(unitID) ~= "number") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [resources_unitRemovePersonalRes] with wrong parameter for [unitID]") end
		if (unitDefID == nil or type(unitDefID) ~= "number") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [resources_unitRemovePersonalRes] with wrong parameter for [unitDefID]") end
		if (unitResourcesData == nil or type(unitResourcesData) ~= "table") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [resources_unitRemovePersonalRes] with wrong parameter for [unitResourcesData]") end
				
		local newMessage = {
			subject = "resources_unitRemovePersonalRes",
			unitID = unitID,
			unitDefID = unitDefID,
			unitResourcesData = unitResourcesData,
		}
		
		message.SendSyncedRules(newMessage)
	end,
	
	-- UI ONLY
	["resources_teamUpdate"] = function(teamName, resourceName, newTeamResourceData)
		--[[ commented to get speedup
		if (resourceName == nil or type(resourceName) ~= "string") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [resources_teamUpdate] with wrong parameter for [resourceName]") end
		if (newData == nil or type(newData) ~= "table") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [resources_teamUpdate] with wrong parameter for [newData]") end
		if (teamName == nil or type(teamName) ~= "string") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [resources_teamUpdate] with wrong parameter for [teamName]") end
		]]--
		
		local encodedData = message.Encode(newTeamResourceData) -- coding it because there are some transfer limits
		local uiData = {
			[resourceName] = encodedData,
		}
		
		-- update game data so UI can read it
		message.SendSyncedInfoTeam(uiData, teamNameToTeamID[teamName], "allied")
	end,
}

-- END OF MODULE DEFINITIONS --

-- update global tables 
if (sendCustomMessage == nil) then sendCustomMessage = {} end
for k,v in pairs(newSendCustomMessage) do
	if (sendCustomMessage[k] ~= nil) then Spring.Echo("NOTIFICATION: Attempt to rewrite global table in module [" .. moduleInfo.name ..  "] - key: " .. k) end
	sendCustomMessage[k] = v 
end

