local moduleInfo = {
	name 	= "heroesMessageSender",
	desc 	= "Sends messages related to heroes.",
	author 	= "PepeAmpere",
	date 	= "2015/08/17",
	license = "notAlicense",
}

-- message module
if (message == nil) then VFS.Include("LuaRules/modules/core/ext/message/message.lua", nil, VFS.ZIP_ONLY) end

-- called as sendCustomMessage.SubjectOfTheMessage
local newSendCustomMessage = {
	["heroes_heroCreated"] = function(unitID, unitDefName)
		local newMessage = {
			subject = "heroes_heroCreated",
			unitID = unitID,
			unitDefName = unitDefName,
		}
		if (unitID == nil or type(unitID) ~= "number") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [heroes_heroCreated] with wrong parameter for [unitID]") end
		if (unitDefName == nil or type(unitDefName) ~= "string") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [heroes_heroCreated] with wrong parameter for [unitDefName]") end
		
		
		message.SendRules(newMessage)
		message.SendUI(newMessage)
	end,
	["heroes_abilityAdded"] = function(unitID, abilityDefName, level)
		local newMessage = {
			subject = "heroes_abilityAdded",
			unitID = unitID,
			abilityDefName = abilityDefName,
			level = level,
		}
		if (unitID == nil or type(unitID) ~= "number") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [heroes_abilityAdded] with wrong parameter for [unitID]") end
		if (abilityDefName == nil or type(abilityDefName) ~= "string") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [heroes_abilityAdded] with wrong parameter for [abilityDefName]") end
		if (level == nil or type(level) ~= "number") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [heroes_abilityAdded] with wrong parameter for [level]") end
		
		
		message.SendRules(newMessage)
		message.SendUI(newMessage)
	end,
	["heroes_mapCommandToAbility"] = function(unitID, cmdDefName, cmdID, abilityDefName)
		local newMessage = {
			subject = "heroes_mapCommandToAbility",
			unitID = unitID,
			cmdDefName = cmdDefName,
			cmdID = cmdID,
			abilityDefName = abilityDefName,
		}
		if (unitID == nil or type(unitID) ~= "number") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [heroes_mapCommandToAbility] with wrong parameter for [unitID]") end
		if (cmdDefName == nil or type(cmdDefName) ~= "string") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [heroes_mapCommandToAbility] with wrong parameter for [cmdDefName]") end
		if (cmdID == nil or type(cmdID) ~= "number") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [heroes_mapCommandToAbility] with wrong parameter for [cmdID]") end
		if (abilityDefName == nil or type(abilityDefName) ~= "string") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [heroes_mapCommandToAbility] with wrong parameter for [abilityDefName]") end
		
		message.SendRules(newMessage)
		message.SendUI(newMessage)
	end,
}

-- END OF MODULE DEFINITIONS --

-- update global tables 
if (sendCustomMessage == nil) then sendCustomMessage = {} end
for k,v in pairs(newSendCustomMessage) do
	if (sendCustomMessage[k] ~= nil) then Spring.Echo("NOTIFICATION: Attempt to rewrite global table in module [" .. moduleInfo.name ..  "] - key: " .. k) end
	sendCustomMessage[k] = v 
end

