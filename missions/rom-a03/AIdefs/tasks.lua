----- NOE tasks - missions for groups --------
----- more about: http://code.google.com/p/nota/wiki/NOE_tasks

local lowerLimitDistanceSQ		= 250*250
local standardLimitDistanceSQ	= 300*300

newTask = {
	["ASBFullAttack"] = {
		pathName			= "ASBFullAttack",
		limitDistance		= lowerLimitDistanceSQ,
		alertListIndexes	= {},
		conditionNames		= {},
	},
	["ASBdefenceBaseNorth"] = {
		pathName			= "ASBdefenceBaseNorth",
		limitDistance		= lowerLimitDistanceSQ,
		alertLimit			= 25,
		alertListIndexes	= {7,11},
		conditionNames		= {},
	},
	["ASBdefenceBaseEast"] = {
		pathName			= "ASBdefenceBaseEast",
		limitDistance		= lowerLimitDistanceSQ,
		alertLimit			= 25,
		alertListIndexes	= {7,11},
		conditionNames		= {},
	},
	["ASBTankFist"] = {
		pathName			= "ASBTankFist",
		limitDistance		= standardLimitDistanceSQ,
		alertLimit			= 10,
		alertListIndexes	= {7,10,11},
		conditionNames		= {},
	},
	
	-- AIR ---
	["revengeAttackOne"] = {
		pathName			= "baseAir",
		alertLimit			= 10,
		alertListIndexes	= {1,2,3,4,5,6,7,8,9,11},
		conditionNames		= {},
		centerParameter		= "transportPosition",
		radiusParameter		= "transportSafeRadius",
		globalAlert			= "globalCallForHelp",
	},
	["revengeAttackTwo"] = {
		pathName			= "baseAir",
		alertLimit			= 10,
		alertListIndexes	= {1,2,3,4,5,6,7,8,9,11},
		conditionNames		= {},
		centerParameter		= "transportPosition",
		radiusParameter		= "transportSafeRadius",
		globalAlert			= "globalCallForHelp",
	},
	["revengeFlame-transport"] = {
		pathName			= "baseAir",
		alertLimit			= 0,
		alertListIndexes	= {},
		conditionNames		= {"alertActive"},
		centerParameter		= "transportPosition",
		radiusParameter		= "transportSafeRadius",
		globalAlert			= "globalCallForHelp",
	},
	["revengeAirDrop-transport-heavy"] = { -- the same as revenge flame
		pathName			= "baseAir",
		alertLimit			= 0,
		alertListIndexes	= {},
		conditionNames		= {"alertActive"},
		centerParameter		= "transportPosition",
		loadPerimeter		= "loadingPerimeter",
		unloadPerimeter		= "unlodadingPerimeter",
		globalAlert			= "globalCallForHelp",
	},
	["revengeAirDrop-transport-bus"] = { -- the same as revenge flame
		pathName			= "asimBase",
		alertLimit			= 0,
		alertListIndexes	= {},
		conditionNames		= {"alertActive"},
		centerParameter		= "transportPosition",
		loadPerimeter		= "loadingPerimeter",
		unloadPerimeter		= "unlodadingPerimeter",
		globalAlert			= "globalCallForHelp",
	},
	["revengeFlame-area"] = {
		pathName			= "baseAir",
		alertLimit			= 5,
		alertListIndexes	= {7,8,9,11},
		conditionNames		= {},
		centerParameter		= "transportPosition",
		radiusParameter		= "transportSafeRadius",
		globalAlert			= "globalCallForHelp",
	},
	["mainAAApatrol"] = {
		pathName			= "mainAAApatrol",
		conditionNames		= {},
	},
	--- END OF AIR ---
	
	["TGdefenceOne"] = {
		pathName			= "TGdefence",
		limitDistance		= lowerLimitDistanceSQ,
		alertLimit			= 10,
		alertListIndexes	= {6},
		conditionNames		= {},
	},
	["TGdefenceTwo"] = {
		pathName			= "TGdefence",
		limitDistance		= lowerLimitDistanceSQ,
		alertLimit			= 20,
		alertListIndexes	= {6},
		conditionNames		= {},
	},
	["transport"] = {
		limitDistance		= lowerLimitDistanceSQ,
	},
	["specialTDefence"] = {
		positionParameter	= "transportPosition",
	},
}