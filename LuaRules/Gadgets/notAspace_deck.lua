include 'LuaRules/Configs/constants.lua'

function gadget:GetInfo()
	return {
	name      = "notAspace_deck",
	desc      = "Serves as notAdecks manager gadget",
	author    = "PepeAmpere",
	date      = "2015-05-24",
	license   = "notAlicense",
	layer     = 0,
	enabled   = constants.DEV.NOTASPACE, -- loaded by default?
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
include "LuaRules/modules/notAspace/api/messageSender.lua"
include "LuaRules/modules/notAspace/api/messageReceiver.lua"

decks = {}

function gadget:RecvLuaMsg(msg, playerID)
	message.Receive(msg, playerID, "notAspace_deck")
end