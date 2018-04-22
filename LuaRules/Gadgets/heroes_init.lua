include 'LuaRules/Configs/constants.lua'

function gadget:GetInfo()
	return {
		name 	= "heroes_init",
		desc	= "Care about heroes abilities init",
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
include "LuaRules/modules/heroes/data/api/messageSender.lua" -- sendCustomMessage = {}
include "LuaRules/modules/heroes/config/unitDefs.lua" -- unitDefs = {}
include "LuaRules/modules/heroes/config/abilityDefs.lua" -- abilityDefs = {}
include "LuaRules/modules/heroes/config/commandDefs.lua" -- commandDefs = {}

unitIDtoName = {}
heroes = {} -- all heroes instances during the game

local function InitializeAbilities(unitID, unitDef, teamID, builderID)
	local abilitiesList = heroDefs[unitDef.name].abilities
	local commandsList = {}
	local abilitesInit = {}
	
	-- we go through all abilities and just read abilities init functions and new unique commands used for them
	for i=1, #abilitiesList do
		local thisAbilityName = abilitiesList[i]
		abilitesInit[thisAbilityName] = abilityDefs[thisAbilityName].init
		
		-- ! TBD: setup good level
		local level = 1
		
		-- inform others this ability was added to given hero
		sendCustomMessage["heroes_abilityAdded"](unitID, thisAbilityName, level)

		-- existing commands check
		for cmdDefName, oneCommandDef in pairs (commandDefs) do
			if (oneCommandDef.abilityDefName == thisAbilityName) then
				local initState = "0"
				cmdDesc.Add(unitID, oneCommandDef.desc, initState)
				cmdDesc.UpdateButton(unitID, oneCommandDef.desc, initState)
				
				-- inform others this ability was added to given hero
				sendCustomMessage["heroes_mapCommandToAbility"](unitID, cmdDefName, oneCommandDef.desc.id, thisAbilityName)
			end
		end
		
		-- run init function if needed
		if (abilityDefs[thisAbilityName].onInit ~= nil) then
			abilityDefs[thisAbilityName].onInit(unitID, unitDef, teamID, builderID)
		end
	end
	
	-- commands
	Spring.Echo("[HEROES INIT]" .. " printing commands of hero [" .. unitDef.name .. "]")
	for name, id in pairs(commandsList) do
		Spring.Echo("[HEROES INIT] " .. name .. ", " .. id)
	end 
	
	return true
end

function gadget:UnitCreated(unitID, unitDefID, teamID, builderID)
	local unitDef = UnitDefs[unitDefID]
	if (heroDefs[unitDef.name] ~= nil) then
		-- inform others that hero was created
		sendCustomMessage["heroes_heroCreated"](unitID, unitDef.name) 
	
		-- and initialize structures
		local initStatus = InitializeAbilities(unitID, unitDef, teamID, builderID)
		
		heroes[unitID] = true
		unitIDtoName[unitID] = unitDef.name
	end
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
	heroes[unitID] = nil
end

function gadget:Initialize()
	-- register all custom commands
	for name, definition in pairs(commandDefs) do
		gadgetHandler:RegisterCMDID(definition.desc.id) -- verification of valid combinations is done during InitializeAbilities(...)
	end
	
	-- this is not vital since we have no pre-spawned heroes now, just old code remnant
	for _, unitID in ipairs(Spring.GetAllUnits()) do
		local teamID = Spring.GetUnitTeam(unitID)
		local unitDefID = GetUnitDefID(unitID)
		gadget:UnitCreated(unitID, unitDefID, teamID)
	end
end

function gadget:Shutdown() -- just clean-up
	for _, unitID in ipairs(Spring.GetAllUnits()) do
		for name, definition in pairs(commandDefs) do
			cmdDesc.Remove(unitID, definition.desc.id)
		end
	end
end
