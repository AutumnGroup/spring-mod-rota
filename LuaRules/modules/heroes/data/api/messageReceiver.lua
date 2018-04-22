local moduleInfo = {
	name 	= "heroesMessageReceiver",
	desc 	= "External definition of actions based on incomming messages for heroes.",
	author 	= "PepeAmpere",
	date 	= "2015/08/13",
	license = "notAlicense",
}

-- called as receiveCustomMessage.SubjectOfTheMessage
-- see expected message content in ..\data\api\messageSender.lua

local newReceiveCustomMessage = {
	["heroes_heroCreated"] = function(decodedMsg, playerID, context)
		if (DEBUG_HEROES) then
			Spring.Echo(TECHNAME .. "[heroes_heroCreated] - unitID: " ..  decodedMsg.unitID .. " of type: " .. decodedMsg.unitDefName)
		end		
		local newIndex = #heroInfo + 1
		
		heroInfo[newIndex] = {
			unitID = decodedMsg.unitID, -- store ID of unit
			unitDefName = decodedMsg.unitDefName, -- store string of defName
			listOfAbilities = {0, 0, 0, 0}, -- store abilityInfo IDs (those four numbers is memory optimization
		}
		
		-- helper mapping
		unitIDtoHeroInfoID[tostring(unitID)] = newIndex
	end,
	["heroes_abilityAdded"] = function(decodedMsg, playerID, context)
		if (DEBUG_HEROES) then
			Spring.Echo(TECHNAME .. "[heroes_abilityAdded] + " .. decodedMsg.unitID .. " gets ability: " ..  decodedMsg.abilityDefName .. " on level: " .. decodedMsg.level)
		end

		abilityInfo[#abilityInfo + 1] = {
			unitID = decodedMsg.unitID,
			heroInfoID = GetHeroByUnitID(decodedMsg.unitID),
			defName = decodedMsg.abilityDefName,
			status = "disabled",
			nextTimeCheck = timeExt.AddToCurrent({0, 0, 5, 0}), -- HMSF - 5 seconds
			nextTimeCheckType = "init",
			level = decodedMsg.level,
		}
	end,
	["heroes_mapCommandToAbility"] = function(decodedMsg, playerID, context)
		-- thisHeroListOfAbilities = heroInfo[GetHeroByUnitID(decodedMsg.unitID)].listOfAbilities
		
		-- ! we presume that last added ability is ability we want to reference here, because thats the order of messages sent
		-- TBD change solution to be be more robust by using code above and search trough given hero abilites list
		
		commandToAbilityInfoID[CommandKey(decodedMsg.unitID, decodedMsg.cmdID)] = #abilityInfo
		if (DEBUG_HEROES) then
			Spring.Echo(TECHNAME .. "[heroes_mapCommandToAbility] commandToAbilityInfoID key " .. CommandKey(decodedMsg.unitID, decodedMsg.cmdID) .. " have value: " .. #abilityInfo)
		end
		
		if (DEBUG_HEROES) then
			Spring.Echo(TECHNAME .. "[heroes_mapCommandToAbility] commandToCommandDefName key " .. CommandKey(decodedMsg.unitID, decodedMsg.cmdID) .. " have value: " .. decodedMsg.cmdDefName)
		end
		commandToCommandDefName[CommandKey(decodedMsg.unitID, decodedMsg.cmdID)] = decodedMsg.cmdDefName
		
		
	end,
}

-- END OF MODULE DEFINITIONS --

-- update global tables 
if (receiveCustomMessage == nil) then receiveCustomMessage = {} end
for k,v in pairs(newReceiveCustomMessage) do
	if (receiveCustomMessage[k] ~= nil) then Spring.Echo("NOTIFICATION: Attempt to rewrite global table in module [" .. moduleInfo.name ..  "] - key: " .. k) end
	receiveCustomMessage[k] = v 
end

