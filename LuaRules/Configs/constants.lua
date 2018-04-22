-- notAlab 2015 --
-- this file will list all game constants from this time

constants = {
	-- simultation
	["FRAMES_IN_SECOND"] = 30,
	["SECONDS_IN_MINUTE"] = 60,
	["MINUTES_IN_HOUR"] = 60,
	-- customResources simulation
	["CUSTOM_RESOURCES"] = {
		["TEAM_RES_UPDATE_RATE"] = 6, -- each 6th frame
	},
	-- features
	["FEATURE_HEALTH_MULTIPLIER"] = 5,
	-- debug
	DEBUG = {
		["HEROES"] = true,
		["MESSAGE"] = {
			["LOG_ENCODED"] = false,
			["LOG_INGNORED_BY_RECEIVER"] = false,
		},
		["NOTASPACE"] = false,
	},
	-- development (this way you disable/enable techs which are in development)
	DEV = {
		["HEROES"] = true,
		["NOTASPACE"] = false,
	},
}