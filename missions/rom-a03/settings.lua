------------------------
--- MISSION SETTINGS ---
------------------------

----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

missionInfo = {
    name 				= "rom-a03",
	maxPlayers			= 3,
	playersMetal		= 3000,
	playersEnergy		= 3000,
	AIcount				= 3,
	AInames				= {
		"asim-base",
		"air-base",
		"transport-guards",		
	},
	victoryCount		= 2,
	defeatCount			= 1,
	victory	= {
		{	-- prefered victory			
			description = "You have to capture and move at least 12 transports at starting area.",
			reward		= 100,
			message		= "Great job, we won!",
		},
		{	-- alternative victory
			description = "You have to kill at least 10 tranports to secure NOE wont be able to brake our coding and get access to our command units",	
			reward		= 40,
			message		= "Ok, we haven't lost. Good job.",
		},
	},
	defeat	= {
		{	-- loose
			description = "If AI succefuly transport at least 8 transports to its main base, you have lost.",	
			reward		= -100,
			message		= "We lost to much commander module parts. Today the bad luck was on our side.",
		},
	},
	notStartUnit		= true,
	specificMapNeeded	= true,
	specMapName			= "RoughShoresV6",
	
	-- end of mandatory part of missionInfo --
	transportsNumber	= 12,						-- number of all transports
	successLimit		= 10,						-- number of transports needed to be captured for Victory 1
	killedLimit			= 8,						-- number of transports needed to be killed for Victory 2
	looseLimit			= 6,						-- number of transports in AI base meaning the Defeat 1
	
	-- triger areas
	activeAreas			= 11,						-- how many trigger areas we have in the mission
	defaultTransArea	= {7883,354},				-- default starting area for transports
	
	-- attack time
	attackTime			= {0,1,30},					-- how much time it takes until attack call is canceled
	transportSafeRadius = 250,						-- 500x500 area around transport
	safeEnemyLimitCount	= 8,						
	loadingPerimeter	= 700,
	unlodadingPerimeter = 600,
	
	-- spawnTimes
	spawnStep			= 1350,						-- (45 secs) how long it takes the new transport is spawned after previous completed its trip
	firstSpawnTime		= 450,
}

-- end of mandatory part of SETTINGS --

missionKnowledge = {
	playersWin			= false,
	playersLoose		= false,
	--- sub win&loose conditions ---
	kiddnapedTransports	= 0,
	transportsInBase	= 0,
	--- identfication ---
	allyIDofPlayers		= 0,
	--- areas
	lastSentTransport	= 0,
	lastTransportGroupID= 0,
	transportPosition	= {missionInfo.defaultTransArea[1],missionInfo.defaultTransArea[2]},
	transportMapPosition= "nodA",
	transportSafeRadius	= missionInfo.transportSafeRadius * 3,
	transportFinished	= false,
	numberOfAlerts		= 0,
	numberOfAliveTrans	= missionInfo.transportsNumber,
	numberOfKilledTrans	= 0,
	numberOfSentTrans	= 0,
	numberOfUsedHelps	= 0,
	numberOfSpawned		= 0,
	transports 			= {},
	areasAlert 			= {},
	globalCallForHelp	= false,
	globalRevengeStart	= false,
	globalCallTime 		= {0,0,0},
}

-- init of transports subtable
for i=1,missionInfo.transportsNumber do
	missionKnowledge.transports[i] = {
		alive 		= false,
		sent 		= false,
		kidnapped 	= false,
		usedHlp 	= false,
	}
end

-- init of areas players unitCounts
for i=1,missionInfo.activeAreas do
	missionKnowledge.areasAlert[i] = 0
end

-- check if allyIDofPlayers is ok --
-- !! add here code testing, if alliance of players has really number 0