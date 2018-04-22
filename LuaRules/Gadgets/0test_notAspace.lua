-- gadget for testing purposes

function gadget:GetInfo()
	return {
	name      = "notAspace_test",
	desc      = "testing new techs and features for notAspace",
	author    = "PepeAmpere",
	date      = "March 7, 2014",
	license   = "notAlicense",
	layer     = 0,
	enabled   = false --  loaded by default?
	}
end

-- synced only
if (not gadgetHandler:IsSyncedCode()) then
	return false
end

-- get madatory module operators
VFS.Include("LuaRules/modules.lua") -- modules table
VFS.Include(modules.attach.data.path .. modules.attach.data.head) -- attach lib module

-- get other madatory dependencies
attach.Module(modules, "message")

local counter = 0
function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	if (UnitDefs[unitDefID].name == "armrock" or UnitDefs[unitDefID].name == "armham") then
		counter = counter + 1
		if (counter % 4	== 2) then
			Spring.SetUnitMaxHealth(unitID,1000)
			Spring.SetUnitHealth(unitID,1000)
			Spring.Echo("Health bot")
		end
		if (counter % 4 == 3) then
			Spring.SetUnitWeaponState(unitID,1,"reloadTime",0.01)
			Spring.Echo("Reloader")
		end
	end
	
	-- example message
	local complicatedMessage = {
		unitID = unitID,
		unitDefID = unitDefID,
		unitTeam = unitTeam,
		builderID = builderID,
	}
	message.SendRules(complicatedMessage)
end

function gadget:RecvLuaMsg(msg, playerID)
	local decodedMsg = message.DecodeLuaMessage(msg)
	Spring.Echo("notAspace msg - unitID: " .. decodedMsg.unitID .. ", unitDefID: " .. decodedMsg.unitDefID .. " from player: " .. playerID)
end

