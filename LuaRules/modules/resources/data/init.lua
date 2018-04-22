-- universal load for resources module
-- if you want customize it for your game, load your configs BEFORE including this file

local MODULE_NAME = "resources"
Spring.Echo("-- " .. MODULE_NAME .. " LOADING --")

------------------------------------------------------

-- MANDATORY
-- check required modules
if (modules == nil) then Spring.Echo("[" .. MODULE_NAME .. "] ERROR: required madatory config [modules] listing paths for modules is missing") end
if (attach == nil) then Spring.Echo("[" .. MODULE_NAME .. "] ERROR: required madatory library [attach] for loading files and modules is missing") end
if (message == nil) then Spring.Echo("[" .. MODULE_NAME .. "] ERROR: required madatory module [message] for communication is missing") end

-- there has to exist modules table which is included before init is called
local thisModuleData = modules[MODULE_NAME]
local THIS_MODULE_DATA_PATH = thisModuleData.data.path

------------------------------------------------------

-- OPTIONAL CONFIG LOAD 
local THIS_MODULE_CONFIG_PATH = thisModuleData.config.path -- custom configs folder (optional)
local listOfFiles = thisModuleData.config.files -- list of files in configPath
attach.try.ModuleOptionalConfigs(THIS_MODULE_CONFIG_PATH, listOfFiles)

------------------------------------------------------

-- MINIMAL CONFIG CHECKS
attach.File(THIS_MODULE_DATA_PATH .. "debug/minimalConstants.lua") -- only if there are no constants loaded

------------------------------------------------------

-- INIT DEFINITIONS
local SIM_FRAMES_IN_SECOND = constants.FRAMES_IN_SECOND
-- team sim constants
local TEAM_RES_UPDATE_FREQUENCY = constants.RESOURCES.TEAM_RES_UPDATE_FREQUENCY -- per second
TEAM_RES_UPDATE_FRAME = math.ceil(SIM_FRAMES_IN_SECOND / TEAM_RES_UPDATE_FREQUENCY)
TEAM_RES_INCOME_MULT = 1 / (SIM_FRAMES_IN_SECOND / TEAM_RES_UPDATE_FRAME)
-- unit sim constants
local UNIT_RES_UPDATE_FREQUENCY = constants.RESOURCES.UNIT_RES_UPDATE_FREQUENCY -- per second
UNIT_RES_UPDATE_FRAME = math.ceil(SIM_FRAMES_IN_SECOND / UNIT_RES_UPDATE_FREQUENCY)
UNIT_RES_INCOME_MULT = 1 / (SIM_FRAMES_IN_SECOND / UNIT_RES_UPDATE_FRAME)

function GetTeamNameFromID(teamID)
	return "t" .. teamID
end

------------------------------------------------------

-- LOAD INTERNAL MODULE FUNCTIONALITY
attach.File(THIS_MODULE_DATA_PATH .. "api/messageSender.lua") -- API for sending messages
attach.File(THIS_MODULE_DATA_PATH .. "api/messageReceiver.lua") -- API for receiving messages
attach.File(THIS_MODULE_DATA_PATH .. "unitsInit.lua") -- load resources info from unit defs customParams, if there is some + create data structures for unit resources
attach.File(THIS_MODULE_DATA_PATH .. "teamsInit.lua") -- create team resources data structures for each team
attach.File(THIS_MODULE_DATA_PATH .. "api/resources.lua") -- main functions library operating over unit and team data structures

------------------------------------------------------

Spring.Echo("-- " .. MODULE_NAME .. " LOADING FINISHED --")

