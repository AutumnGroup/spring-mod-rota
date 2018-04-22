include 'LuaRules/Configs/constants.lua'

function gadget:GetInfo()
	return {
		name 	= "heroes_abilities",
		desc	= "Care about heroes abilities control",
		author 	= "PepeAmpere",
		date 	= "2015/08/01",
		license = "notAlicense",
		layer 	= 0,
		enabled = constants.DEV.HEROES, -- loaded by default?
	}
end

if (not gadgetHandler:IsSyncedCode()) then
	return false -- silent removal
end

-- get madatory module operators
VFS.Include("LuaRules/modules.lua") -- modules table
VFS.Include(modules.attach.data.path .. modules.attach.data.head) -- attach lib module

-- get other madatory dependencies
attach.Module(modules, "message")
attach.Module(modules, "cmdDesc")
attach.Module(modules, "timeExt")
include "LuaRules/modules/heroes/config/abilityDefs.lua" -- abilityDefs = {}
include "LuaRules/modules/heroes/config/commandDefs.lua" -- commandDefs = {}
include "LuaRules/modules/heroes/data/api/messageReceiver.lua" -- receiveCustomMessage = {}
include "LuaRules/modules/heroes/data/actions.lua" -- actions.heroes = {}
include "LuaRules/modules/heroes/data/conditions.lua" -- conditions.heroes = {}

-- global defs
heroInfo = {}
abilityInfo = {}
unitIDtoHeroInfoID = {}
commandToAbilityInfoID = {} -- using combined key to get reference from unitID and cmdID of given hero to abilityInfoID
commandToCommandDefName = {} -- using same key to get commandDefName

-- constants speedup
DEBUG_HEROES = constants.DEBUG.HEROES -- if we debug abilitites status
TECHNAME = "[HEROES]"

function GetHeroByUnitID(unitID)
	return unitIDtoHeroInfoID[tostring(unitID)]
end

function SetAbilityInfoStatus(abilityID, status, nextTimeCheck, nextTimeCheckType) -- change abilityInfo data
	abilityInfo[abilityID]["status"] = status
	abilityInfo[abilityID]["nextTimeCheck"] = nextTimeCheck
	abilityInfo[abilityID]["nextTimeCheckType"] = nextTimeCheckType
	return true
end

function CommandKey(unitID, cmdID) -- just make unique key by combining unitID and cmdID
	return unitID .. "_" .. cmdID
end

-- speed-ups
local spGetUnitDefID 		= Spring.GetUnitDefID
local spGetUnitCommands 	= Spring.GetUnitCommands
local spFindUnitCmdDesc 	= Spring.FindUnitCmdDesc

function gadget:AllowCommand(unitID, unitDefID, unitTeamID, cmdID, cmdParams, cmdOptions, cmdTag, synced)
	
	local combinedKey = CommandKey(unitID, cmdID)
	local abilityID = commandToAbilityInfoID[combinedKey]
	if (abilityID == nil) then -- filter out commands which are not related to this technology (heroes abilities)
		return true
	end
	
	local thisAbilityInfo = abilityInfo[abilityID] -- load table with all info about ability it exist
	-- Spring.Echo(combinedKey)
	-- Spring.Echo(commandToAbilityInfoID[combinedKey])
	-- Spring.Echo(commandToCommandDefName[combinedKey])
	-- Spring.Echo(commandDefs[commandToCommandDefName[combinedKey]].abilityDefName)
	-- Spring.Echo(thisAbilityInfo.defName)
	
	-- load definition of definition of ability and then test preActivation condition
	local thisAbilityDefinition = abilityDefs[thisAbilityInfo.defName]
	local allowThisAbility, testData = true, {}
	
	if (thisAbilityDefinition.events.onPreactivation ~= nil) then
		allowThisAbility, testData = thisAbilityDefinition.events.onPreactivation(thisAbilityInfo, unitID, unitDefID, unitTeamID, cmdID, cmdParams, cmdOptions, cmdTag, synced)
		if (DEBUG_HEROES) then
			Spring.Echo(TECHNAME .. " - allowThisAbility = " .. tostring(allowThisAbility) .. ", testData = " .. tostring(testData))
		end
	end
		
	-- if allowed, execute ability
	if (allowThisAbility) then
		if (DEBUG_HEROES) then
			Spring.Echo(TECHNAME .. " - ability activation [" .. thisAbilityInfo.defName .. "] on unit [" .. tostring(unitID) .. "]")
		end
		local resultOfActivation = thisAbilityDefinition.events.onActivation(thisAbilityInfo, unitID, unitDefID, unitTeamID, cmdID, cmdParams, cmdOptions, cmdTag, synced, testData)
		local status = '0' -- ?? unknown legacy :)
		cmdDesc.UpdateButton(unitID, commandDefs[commandToCommandDefName[combinedKey]].desc, status)
	end
	
	return false
end

function gadget:RecvLuaMsg(msg, playerID)
	message.Receive(msg, playerID, "heroes_abilities")
end

function gadget:Initialize()

end

function gadget:GameFrame(n)
	for i=1, #abilityInfo do 
		local thisAbilityInfo = abilityInfo[i]
		local thisAbilityDefinition = abilityDefs[thisAbilityInfo.defName]
		
		if (thisAbilityDefinition.events.onFrame ~= nil) then
			local result = thisAbilityDefinition.events.onFrame(thisAbilityInfo, thisAbilityDefinition, n)
		end
	end
end

