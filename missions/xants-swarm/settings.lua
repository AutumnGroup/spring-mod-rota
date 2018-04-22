------------------------
--- MISSION SETTINGS ---
------------------------

----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

missionInfo = {
    name         = "xants-swarm",
	victoryCount = 2,
	defeatCount  = 1,
	maxPlayers			= 2,
	playersMetal		= 1000,
	playersEnergy		= 1000,
	AIcount      = 1,
	AInames      = {
	    "defaultMissionAI",
	},
	victoryCount		= 2,
	defeatCount			= 1,
	victory	= {
		{	-- prefered victory			
			description = "Win 100.",
			reward		= 100,
			message		= "Great job, we won!",
		},
		{	-- alternative victory
			description = "Win 40",	
			reward		= 40,
			message		= "Ok, we haven't lost. Good job.",
		},
	},
	defeat	= {
		{	-- loose
			description = "Loose",	
			reward		= -100,
			message		= "Bad day",
		},
	},
	notStartUnit		= true,
	specificMapNeeded	= true,
	specMapName			= "Green_Fields_fix",
}
