local moduleInfo = {
	name 	= "notAspaceMessageReceiver",
	desc 	= "External definition of actions based on incomming messages for notAspace,",
	author 	= "PepeAmpere",
	date 	= "2015/08/14",
	license = "notAlicense",
}

-- called as receiveCustomMessage.SubjectOfTheMessage
local newReceiveCustomMessage = {
	["notAspace_initDeck"] = function(decodedMsg, playerID, context)
		-- this is function handling init message
		Spring.Echo("NOTASPACE ONE PLAYER TEST INPUT")
		Spring.Echo("-------------------------------")
		Spring.Echo("playerID: " .. decodedMsg.playerID)
		
		local cardList = decodedMsg.cardList
		for i=1, #cardList do
			-- print data of each card
			Spring.Echo("card no. " .. i .. ", ID: " .. cardList[i].cardID)
			Spring.Echo("* level: " .. cardList[i].cardData.level)
			Spring.Echo("* unitDefName: " .. cardList[i].cardData.unitDefName)
			Spring.Echo("* unitCount: " .. cardList[i].cardData.unitCount)
			Spring.Echo("* weapons: " .. cardList[i].cardData.technology.weapons)
			Spring.Echo("* plating: " .. cardList[i].cardData.technology.plating)
			Spring.Echo("* experience: " .. cardList[i].cardData.experience)
			Spring.Echo("* formationName: " .. cardList[i].cardData.formationName)
		end

		decks[decodedMsg.playerID] = cardList
	end,
}

-- END OF MODULE DEFINITIONS --

-- update global tables 
if (receiveCustomMessage == nil) then receiveCustomMessage = {} end
for k,v in pairs(newReceiveCustomMessage) do
	if (receiveCustomMessage[k] ~= nil) then Spring.Echo("NOTIFICATION: Attempt to rewrite global table in module [" .. moduleInfo.name ..  "] - key: " .. k) end
	receiveCustomMessage[k] = v 
end

