local moduleInfo = {
	name 	= "messageReceiverHealthbarsWidget",
	desc 	= "Definition of specific functions called for specific message subjects - custom messages related to healthbars widget, for fuel needs",
	author 	= "PepeAmpere",
	date 	= "2015/02/17",
	license = "notAlicense",
}

-- @description called as receiveCustomMessage[SubjectOfTheMessage]
-- @comment only fuel related updates
local newReceiveCustomMessage = {
	
	-- @description Receive init message about unit personal resources initialization
	-- @comment Message defined in module modules\resources\data\api\messageSender.lua
	["resources_unitDefResourceData"] = function(decodedMsg, playerID, context)
		if (decodedMsg.resourceName == "hydrocarbons") then
			fuelMaxStorage[decodedMsg.unitDefID] = decodedMsg.resourceDef.storageUnit
		end
	end,
}

-- END OF MODULE DEFINITIONS --

-- update global structures 
message.AttachCustomReceiver(newReceiveCustomMessage, moduleInfo)