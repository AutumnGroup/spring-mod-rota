local moduleInfo = {
	name 	= "resourcesMessageReceiverFuelGadget",
	desc 	= "Definition of specific functions called for specific message subjects - custom messages related to fuel gadget",
	author 	= "PepeAmpere",
	date 	= "2015/02/17",
	license = "notAlicense",
}

-- @description called as receiveCustomMessage[SubjectOfTheMessage]
-- @comment only for fuel gadget
local newReceiveCustomMessage = {
	
	-- @description Receive init message about unit personal resources initialization
	-- @comment Message defined in module modules\resources\data\api\messageSender.lua
	["resources_unitInitPersonalRes"] = function(decodedMsg, playerID, context)
		CheckAddingPlane(decodedMsg.unitID, decodedMsg.unitDefID, decodedMsg.unitResourcesData)
		CheckAddingPad(decodedMsg.unitID, decodedMsg.unitDefID, decodedMsg.unitResourcesData)
	end,
	
	-- @description Receive message about ending personal res simulation (in case of unit death)
	-- @comment Message defined in module modules\resources\data\api\messageSender.lua
	["resources_unitRemovePersonalRes"] = function(decodedMsg, playerID, context)
		
		-- ? WHY IT IS COMMENTED ?
		-- because we duplicate this functionality in gadget itself using engine call-in for dead units. it was necessary, because message have one frame delay => some engine functions would receive dead units as params because the tables were not cleaned fast enough
		
		-- CheckRemovingPlane(decodedMsg.unitID, decodedMsg.unitDefID, decodedMsg.unitResourcesData)
		-- CheckRemovingPad(decodedMsg.unitID, decodedMsg.unitDefID, decodedMsg.unitResourcesData)
	end,
	
	-- @description Receive message about change of the personal resources
	-- @comment Message defined in module modules\resources\data\api\messageSender.lua
	["resources_unitResourceStorageChanged"] = function(decodedMsg, playerID, context)
		local planeUnitID = decodedMsg.unitID
		local planeResData = decodedMsg.unitResourcesData
		local planeData = planes[planeUnitID]
		
		if (decodedMsg.resourceName == "hydrocarbons" and planeData ~= nil) then -- we handle just initialized planes
			CheckModeChange(planeUnitID, planeData.resSimulationMode, decodedMsg.newStorage, planeResData.storageSize, planeResData.shortage, "resources_unitResourceStorageChanged")
		end
	end,
	
	-- @description Receive message about change of the shortage
	-- @comment Message defined in module modules\resources\data\api\messageSender.lua
	-- @comment Seems to be redundant in this gadget because we handle the shortage as part of the resource change event
	["resources_unitResourceShortageChanged"] = function(decodedMsg, playerID, context)
		local planeUnitID = decodedMsg.unitID
		local planeData = planes[planeUnitID]
		
		if (decodedMsg.resourceName == "hydrocarbons" and planeData ~= nil) then -- we handle just initialized planes
			CheckModeChange(planeUnitID, planeData.resSimulationMode, 1, 2, decodedMsg.newValue, "resources_unitResourceShortageChanged") -- using numbers 1 and 2 is just optimization because all cases where real value is needed is solved by different handler
		end
	end,
	
	-- @description Force plane to search for refuel
	["resources_refuelOrder"] = function(decodedMsg, playerID, context)
		local planeUnitID = decodedMsg.unitID
		local planeData = planes[planeUnitID]
		
		if (planeData ~= nil) then -- we handle just initialized planes
			CheckModeChange(planeUnitID, planeData.resSimulationMode, 0, 2, true, "resources_refuelOrder") 
		end
	end,

}

-- END OF MODULE DEFINITIONS --

-- update global structures 
message.AttachCustomReceiver(newReceiveCustomMessage, moduleInfo)