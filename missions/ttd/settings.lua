------------------------
--- MISSION SETTINGS ---
------------------------

----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

missionInfo = {
    name               = "ttd",
	maxPlayers         = 9,
	victoryCount       = 1,
	defeatCount        = 1,
	AIcount            = 1,
	AInames            = {
	    "nastyAttacker",
	},
	notStartUnit       = true,
	specificMapNeeded  = true,
	specMapName        = "Throne v1",
	endGameTime        = Spring.GetModOptions().hilltime * 80,
}

introImg = "intro.png"

victory = {
    [1] = {
	    description = "Mission Accomplished",
		message     = "You have survived!",
		image       = "1victory.png",
		score       = 100,
	},
}

defeat = {
    [1] = {
	    description = "Defeat",
		message     = "You have been killed!",
		image       = "1defeat.png",
		score       = 0,
	},
}