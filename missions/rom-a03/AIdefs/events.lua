----- mission events settigns ------
----- more about: http://code.google.com/p/nota/wiki/NOE_events
----- !? be aware of params! they cannot be changed without rewriting event

newEvents = {
    --- victory 1 ---
	{	repeating			= false,						active			= true,								slow	= true,
		conditionsNames		= {"kidnappedChecker"},			actionsNames	= {"victoryForPlayers"},
		conditionsParams	= {{missionInfo.successLimit}},	actionsParams	= {{teamNumberWinning,1}},
	},	
	--- victory 2 ---
	{	repeating			= false,						active			= true,								slow	= true,
		conditionsNames		= {"killedChecker"},			actionsNames	= {"victoryForPlayers"},
		conditionsParams	= {{missionInfo.killedLimit}},	actionsParams	= {{teamNumberWinning,2}},
	},	
	--- defeat ---
	{	repeating			= false,						active			= true,								slow	= true,
		conditionsNames		= {"deliveredChecker"},			actionsNames	= {"defeatForPlayers"},
		conditionsParams	= {{missionInfo.looseLimit}},	actionsParams	= {{teamNumberWinning,1}},
	},
	
	--- transport alert checker ---
	{	repeating			= true,							active			= true,								slow	= true,
		conditionsNames		= {"enemyAroundTransport","aliveTransport","notAlertActive"},					actionsNames	= {"callForTransportDefence","tauntAttack"},
		conditionsParams	= {{missionInfo.transportSafeRadius,missionKnowledge.allyIDofPlayers},{},{}},	actionsParams	= {{true},{"AI: Mission AI: "}},
	},
	--- transport defence cancel after some time 
	{	repeating			= true,							active			= true,								slow	= true,
		conditionsNames		= {"missionTimeElapsed"},						actionsNames	= {"cancelGlobalCallForHelp"},
		conditionsParams	= {{missionInfo.attackTime,"globalCallTime"}},	actionsParams	= {{}},
	}, 
	--- first transport spawn
	{	repeating			= false,											active			= true,								slow	= false,
		conditionsNames		= {"time"},											actionsNames	= {"spawnNewTransport"},
		conditionsParams	= {{TimeCounter(missionInfo.firstSpawnTime)}},		actionsParams	= {{missionInfo.firstSpawnTime}},
	}, 
	--- AND THERE ARE ADDED NEW SUCH EVENTS LATER via action below = "addSpawnOfNewTransport"
	--- if transport safely in target base, then spawn another
	{	repeating			= true,							active			= true,								slow	= true,
		conditionsNames		= {"transportAtTheEnd"},		actionsNames	= {"addSpawnOfNewTransport"},
		conditionsParams	= {{}},							actionsParams	= {{}},
	}, 
	
	--- global revenge attack of main base
	{	repeating			= false,						active			= true,								slow	= true,
		conditionsNames		= {"checkKilledTransports"},	actionsNames	= {"callForGlobalRevenge"},
		conditionsParams	= {{1}},						actionsParams	= {{}},
	},
	
	--- area 1 checker for rush (taunt) ---
	{	repeating			= false,						active			= true,								slow	= true,
		conditionsNames		= {"timeLess","playerInArea","notAlertActive"},	actionsNames	= {"consoleWrite"},
		conditionsParams	= {{{0,8,0}},{1},{}},							actionsParams	= {{"AI: Mission AI: (12) This noob's rushing me"}},
	},
	
	--- activate kroggy buffer ---
	{	repeating			= false,						active			= true,								slow	= true,
		conditionsNames		= {"timeMore"},		actionsNames	= {"activateKroggyBuffer"},
		conditionsParams	= {{{0,10,0}}},		actionsParams	= {{}},
	},
}

-- generate area 1-11 triggers --
-- 1) CONDITION: check if there is any unit in area, if YES, condition satisified
-- 2) ACTION: count number of players units in area and save it the number to table
local sizeOfNewEvents = #newEvents
for i=1,11 do
	local areaName = "area" .. i
	newEvents[sizeOfNewEvents+i] = {	
		repeating			= true,				active			= true,								slow	= true,
		conditionsNames		= {"isUnitInArea"},	actionsNames	= {"setTheAreaAlert"},
		conditionsParams	= {{areaName}},		actionsParams	= {{i,missionKnowledge.allyIDofPlayers}},
	}
end