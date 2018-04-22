------------------------
--- MISSION SETTINGS ---
------------------------

----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

missionInfo = {
    name         = "_noe",
	victoryCount = 1,
	defeatCount  = 1,
	maxPlayers			= 1,
	playersMetal		= 1000,
	playersEnergy		= 1000000,
	AIcount      = 2,
	AInames      = {
	    "active",
		"passive",
	},
	victoryCount		= 2,
	defeatCount			= 1,
	victory	= {
		{	-- prefered victory			
			description = "Win 100.",
			reward		= 100,
			message		= "Great job, we won!",
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
	specMapName			= "TitanDuel",
	--specMapName			= "Trololo",
	
	-- END OF MANDATORY part of missionInfo, START OF CUSTOM part --
}

frameworkTemp = {}

