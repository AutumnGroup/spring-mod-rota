------------------------
--- MISSION SETTINGS ---
------------------------

missionInfo = {
    name         = "autotest/weapon/torpedo-air", -- derived from autotest/refuel
	victoryCount = 1,
	defeatCount  = 1,
	maxPlayers			= 2,
	playersMetal		= 15000,
	playersEnergy		= 15000,
	AIcount      = 2,
	AInames      = {
		"Attacker",
	    "Defender",
	},
	victoryCount		= 1,
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
	specificMapNeeded	= false,
	specMapName			= "Tangerine",
}
