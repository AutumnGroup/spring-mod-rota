local moduleInfo = {
	name 	= "resourcesMessageReceiverFuelWeaponsGadget",
	desc 	= "Definition of specific functions called for specific message subjects - custom messages related to fuel weapons gadget",
	author 	= "PepeAmpere",
	date 	= "2015/04/03",
	license = "notAlicense",
}

-- @description called as receiveCustomMessage[SubjectOfTheMessage]
-- @comment only for fuel weapons gadget
local newReceiveCustomMessage = {
	-- @description Receive message about change of the personal resources
	-- @comment Message defined in module modules\resources\data\api\messageSender.lua
	["resources_unitResourceModeChanged"] = function(decodedMsg, playerID, context)
		if (decodedMsg.resourceName == "hydrocarbons") then
			local mode = decodedMsg.modeName
			if (mode == "flyingNoFuel") then
				LockAllWeaponsUsingFuel(decodedMsg.unitID, decodedMsg.unitDefID)
			end
			
			if (mode == "default") then
				UnlockAllWeaponsUsingFuel(decodedMsg.unitID, decodedMsg.unitDefID)
			end
		end
	end,

}

-- END OF MODULE DEFINITIONS --

-- update global structures 
message.AttachCustomReceiver(newReceiveCustomMessage, moduleInfo)