------------------------
--- MISSION SETTINGS ---
------------------------

----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

missionInfo = {
    name               = "xants-pd",
	maxPlayers         = 0,
	victoryCount       = 1,
	defeatCount        = 1,
	AIcount            = 2,
	AInames            = {
	    "mapper",
		"xants",		
	},
	notStartUnit       = true,
	specificMapNeeded  = true,
	specMapName        = "Canyon_Redux-v01",
	endGameTime        = 1000000,
	---------
	numberOfAnts       = 80,     -- how many ants created
	spawnSplit         = 120,     -- how many frames between ants creation   (120 = 2s)
	reportTime         = 600,     -- how many frames between reports in log  (600 = 10s)
	valueOfOneAnt      = 0.15,    -- how valuable is one ant  (KEEP it around 10/numberOfAnts)
	startLevel         = 6,       -- after getting this level on some control point ants start using pheromons
	decreaseValue      = 0.90,     -- multiplier - how much of ant's "mark" stay on the place
	decreaseTimes      = 1,       -- timing of decreasing (big values makes strange steps) LET 1
	---------
	randomization      = 1627,    -- change randomseed
	--startMarking       = 600,     -- number of frames before ants start to use pheromons to make decisions
	--startConstant      = 0.01,    -- start constant for decision points
}

gameTime = 0

--- one setting for map ---

path = {
    -- start/ziel --
    ["start"] = {x=1500, z=900},
	["ziel"] = {x=7000, z=7500},
	-- decision points --
	["A"] = {x=2000, z=2830},
	["B"] = {x=5500, z=6520},
	-- decision makers --
	["H1"] = {x=3450, z=2450},
	["D1"] = {x=1900, z=4250},
	["HN"] = {x=5750, z=5300},
	["DN"] = {x=3950, z=6550},
	-- others --
	["H2"] = {x=6300, z=1750},
	["D2"] = {x=2900, z=5900},
}