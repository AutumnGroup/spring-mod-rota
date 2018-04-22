include 'LuaRules/Configs/constants.lua'

function gadget:GetInfo()
	return {
	name      = "notAspace_init",
	desc      = "Read data from startscript and send init setup messages",
	author    = "PepeAmpere",
	date      = "2015-05-18",
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

-- example data
include "LuaRules/modules/notAspace/exampleDeck.lua"

function gadget:GameFrame(n)
end

function gadget:Initialize()
	sendCustomMessage.notAspace_initDeck(0, GiveMeRandomDeck(6))
	sendCustomMessage.notAspace_initDeck(1, exmapleDeck)
end

