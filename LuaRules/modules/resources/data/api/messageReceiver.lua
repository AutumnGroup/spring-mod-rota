local moduleInfo = {
	name 	= "resourcesMessageReceiver",
	desc 	= "Definition of specific functions called for specific message subjects - private core functions",
	author 	= "PepeAmpere",
	date 	= "2015/01/02",
	license = "notAlicense",
}

local spGetUnitTeam = Spring.GetUnitTeam
local spGetPlayerInfo = Spring.GetPlayerInfo
local spGetTeamInfo = Spring.GetTeamInfo

-- @description called as receiveCustomMessage[SubjectOfTheMessage]
-- @comment functions below all private, just for internal resources module usage
local newReceiveCustomMessage = {
	["resources_unitResourceModeChanged"] = function(decodedMsg, playerID, context)
		local unitID = decodedMsg.unitID		
		local unitDefID = decodedMsg.unitDefID
		local resourceName = decodedMsg.resourceName
		local newModeName = decodedMsg.modeName
		local unitName = fromDefIDToNameTable[unitDefID]
		
		if (unitName == nil) then
			Spring.Echo("[" .. moduleInfo.name .. "] msg: [resources_unitResourceModeChanged] ERROR: We tried to update resourceMode for undefined unitName")
			return false
		end
		
		-- optional, a bit hacky solution to fake transfers between team and unit
		local partnerUnit = decodedMsg.partnerUnit
		local newLimits = {
			incomeTeam = math.huge,
			consumptionTeam = math.huge,
			incomeUnit = math.huge,
			consumptionUnit = math.huge,
		}
		
		if (partnerUnit ~= nil and partnerUnit.unitDefID ~= nil) then
			local partnerUnitName = fromDefIDToNameTable[unitDefID]
			if (partnerUnitName == nil) then
				Spring.Echo("[" .. moduleInfo.name .. "] msg: [resources_unitResourceModeChanged] ERROR: There is planned fake transfer from registered unitID: [" .. unitID .. "] to uknown partnerUnit.ID [" .. partnerUnit.ID .. "]")
				return false
			else
				-- calculate limits from minimum of both, we allow just unit faking the transfer
				-- unitName = personal res
				-- partnerUnitName = represents team res
				local fromUnitToTeam = math.min(resourcesPerUnitName[unitName][resourceName].unitToTeamTransferRate, resourcesPerUnitName[partnerUnitName][resourceName].teamToUnitTransferRate)
				local fromTeamToUnit = math.min(resourcesPerUnitName[unitName][resourceName].teamToUnitTransferRate, resourcesPerUnitName[partnerUnitName][resourceName].unitToTeamTransferRate)
				newLimits = {
					incomeTeam = fromUnitToTeam,
					consumptionTeam = fromTeamToUnit,
					incomeUnit = fromTeamToUnit,
					consumptionUnit = fromUnitToTeam,
				}
			end
		end
		
		-- if mode exist
		if (newModeName == "default" or (resourcesModes[newModeName] ~= nil and resourcesModes[newModeName].validUnitsNames[unitName] and resourcesModes[newModeName].validResourceNames[resourceName])) then
			resources.UnitResourceModeChanged(unitID, spGetUnitTeam(unitID), unitName, resourceName, newModeName, newLimits) -- no implicit res sharing!, thats why same team
			return true
		else
			Spring.Echo("[" .. moduleInfo.name .. "] msg: [resources_unitResourceModeChanged] ERROR: Someone tried to change my resourceMode to not valid value: [" .. newModeName .. "]")
			return true
		end
	end,
	
	["resources_unitResourceConsumptionRequest"] = function(decodedMsg, playerID, context)
		local unitID = decodedMsg.unitID
		local resourceName = decodedMsg.resourceName
		local requestedAmount = decodedMsg.requestedAmount
		local unitName = fromDefIDToNameTable[decodedMsg.unitDefID]
		
		resources.UnitResourceConsumptionRequest(unitID, unitName, resourceName, requestedAmount)
	end,
}

-- END OF MODULE DEFINITIONS --

-- update global structures 
message.AttachCustomReceiver(newReceiveCustomMessage, moduleInfo)
