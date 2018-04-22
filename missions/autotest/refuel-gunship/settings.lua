------------------------
--- MISSION SETTINGS ---
------------------------

----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

missionInfo = {
    name         = "autotest/refuel-gunship", -- derived from autotest/refuel-carrier
	victoryCount = 2,
	defeatCount  = 1,
	maxPlayers			= 2,
	playersMetal		= 15000,
	playersEnergy		= 15000,
	AIcount      = 2,
	AInames      = {
		"Attacker",
	    "Defender",
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
	specMapName			= "Tangerine",
}
