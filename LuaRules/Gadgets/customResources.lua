function gadget:GetInfo()
	return {
		name 		= "customResources",
		desc 		= "Control of all resources not supported by engine",
		author 		= "PepeAmpere",
		date 		= "5th Decemeber 2015",
		license 	= "notAlicense",
		layer 		= 0,
		enabled 	= true
	}
end

-- synced only
if (not gadgetHandler:IsSyncedCode()) then
	-- will be later used for visual messages with updates sent
	return false
end

-- get madatory module operators
include("LuaRules/modules.lua") -- modules table
include(modules.attach.data.path .. modules.attach.data.head) -- attach lib module

-- get other madatory dependencies
attach.Module(modules, "message")

-- load custom stuff
attach.File("LuaRules/Configs/constants.lua")
-- load temporary custom stuff - unitsInitFuel will be replaced by adding proper values to UnitDefs in customParams
attach.File("LuaRules/modules/resources/config/unitsInitFuel.lua") -- customized init specifically for fuel

-- load resources module itself
attach.Module(modules, "resources")

-- init before units are spawned
resources.Initialize()

-- API for created units
-- (i) unit created is for units where building process started => they should not provide resource income or storage
function gadget:UnitCreated(unitID, unitDefID, unitTeamID, builderID) resources.UnitCreated(unitID, unitDefID, unitTeamID) end

-- API for incomming units
function gadget:UnitFinished(unitID, unitDefID, unitTeamID) resources.UnitReceived(unitID, unitDefID, unitTeamID) end
function gadget:UnitGiven(unitID, unitDefID, unitTeamID, oldTeam) resources.UnitReceived(unitID, unitDefID, unitTeamID) end
function gadget:UnitCaptured(unitID, unitDefID, unitTeamID) resources.UnitReceived(unitID, unitDefID, unitTeamID) end

-- API for lost units
function gadget:UnitDestroyed(unitID, unitDefID, unitTeamID, attackerID, attackerDefID, attackerTeamID) 
	resources.UnitLost(unitID, unitDefID, unitTeamID)
	resources.UnitKilled(unitID, unitDefID, unitTeamID) 
end
function gadget:UnitTaken(unitID, unitDefID, unitTeamID, newTeam) resources.UnitLost(unitID, unitDefID, unitTeamID) end

-- API for reclaim
function gadget:FeatureCreated(featureID, allyTeam) end -- nothing yet
function gadget:FeatureDestroyed(featureID, allyTeam) end -- nothing yet

-- function gadget:UnitFinished(unitID, unitDefID, unitTeamID)
-- end

function gadget:GameFrame(n)
	resources.CheckUnitUpdate(n)
	resources.CheckTeamUpdate(n)
end

function gadget:Initialize()
end

function gadget:RecvLuaMsg(msg, playerID)
	message.Receive(msg, playerID) -- using messageReceiver data structure
end