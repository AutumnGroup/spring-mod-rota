local moduleInfo = {
	name 	= "notAspace messages sender",
	desc 	= "Helper sending custom messages related to notAspace",
	author 	= "PepeAmpere",
	date 	= "2015/05/25",
	license = "notAlicense",
}

-- message module
if (message == nil) then VFS.Include("LuaRules/modules/core/ext/message/message.lua", nil, VFS.ZIP_ONLY) end

-- called as sendCustomMessage.SubjectOfTheMessage
local newSendCustomMessage = {
	["notAspace_activateCard"] = function(cardID, activationData)
		local newMessage = {
			subject = "notAspace_activateCard",
			cardID = cardID,
			activationData = activationData,
		}
		if (cardID == nil or type(cardID) ~= "number") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [notAspace_activateCard] with wrong parameter for [cardID]") end
		-- activationData may be nil, that depends on cardType
		
		message.SendRules(newMessage)
		message.SendUI(newMessage)
	end,
	["notAspace_initDeck"] = function(playerID, cardList)
		local newMessage = {
			subject = "notAspace_initDeck",
			playerID = playerID,
			cardList = cardList,
		}
		if (playerID == nil or type(playerID) ~= "number") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [notAspace_initDeck] with wrong parameter for [playerID]") end
		if (cardList == nil or type(cardList) ~= "table") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [notAspace_initDeck] with wrong parameter for [cardList]") end
		
		message.SendRules(newMessage)
		message.SendUI(newMessage)
	end,
	["notAspace_removeCard"] = function(playerID, cardID)
		local newMessage = {
			subject = "notAspace_removeCard",
			playerID = playerID,
			cardID = cardID,
		}
		if (playerID == nil or type(playerID) ~= "number") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [notAspace_removeCard] with wrong parameter for [playerID]") end
		if (cardID == nil or type(cardID) ~= "number") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [notAspace_removeCard] with wrong parameter for [cardID]") end
				
		message.SendRules(newMessage)
		message.SendUI(newMessage)
	end,
	["notAspace_updateCard"] = function(playerID, cardID, cardType, cardData)
		local newMessage = {
			subject = "notAspace_updateCard",
			playerID = playerID,
			cardID = cardID,
			cardType = cardType,
			cardData = cardData,
		}
		if (playerID == nil or type(playerID) ~= "number") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [notAspace_updateCard] with wrong parameter for [playerID]") end
		if (cardID == nil or type(cardID) ~= "number") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [notAspace_updateCard] with wrong parameter for [cardID]") end
		if (cardType == nil or type(cardType) ~= "string") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [notAspace_updateCard] with wrong parameter for [cardType]") end
		if (cardData == nil or type(cardData) ~= "table") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [notAspace_updateCard] with wrong parameter for [cardData]") end
		
		message.SendRules(newMessage)
		message.SendUI(newMessage)
	end,
	["notAspace_updateDeckActivation"] = function(activationLevel, nextLevelTime)
		local newMessage = {
			subject = "notAspace_updateDeckActivation",
			activationLevel = activationLevel,
			nextLevelTime = nextLevelTime,
		}
		if (activationLevel == nil or type(activationLevel) ~= "number") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [notAspace_updateDeckActivation] with wrong parameter for [activationLevel]") end
		if (nextLevelTime == nil or type(nextLevelTime) ~= "number") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [notAspace_updateDeckActivation] with wrong parameter for [nextLevelTime]") end
				
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

