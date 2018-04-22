------------------------
--- MISSION SETTINGS ---
------------------------

----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

missionInfo = {
    name         = "xants-sort",
	victoryCount = 2,
	defeatCount  = 1,
	maxPlayers			= 1,
	playersMetal		= 1000,
	playersEnergy		= 1000000,
	AIcount      = 5,
	AInames      = {
	    "trasporters",
		"eggs1",
		"eggs2",
		"eggs3",
		"eggs4",
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
	specMapName			= "TitanDuel",
	--specMapName			= "Trololo",
	
	-- END OF MANDATORY part of missionInfo, START OF CUSTOM part --
	
	memorySize			= 10,					-- how many last seen eggs bug remembers, minimal 3
	scoreType			= "harmony",			-- just weight of last seen objects styling
	numberOfBugs		= 100,					-- how many bugs is spawned
	numberOfEggs		= 280,					-- how many eggs is spawned
	
	bugSensorLenght		= 340,					-- how big area bug scans aroun himself
	lust				= 60,					-- after how many iterations bug wants to load some egg?
	
	eggName				= "bugegg",
	eggDefID			= 0,
	
	activeMapX			= Game.mapSizeX,		-- just map sizeX
	activeMapZ			= Game.mapSizeZ,		-- just map sizeZ
	activeBorder		= 150,					-- minimal distance of egg/bug spawn from map border
	moveBorder			= 50,					-- move targets limit
	spotsSplit			= 200,					-- simplification of randomization of moves create targets of moves at borders of map
}

bug 			= {}
spot 			= {}
memWeight 		= {}
spotsCount		= 0
eggTeamIDtoColor= {}
eggColorToTeamID= {}

function newBug(groupIDstring)
	local colorMemory 	= {}
	local idMemory 		= {}
	for i=1,missionInfo.memorySize do 
		colorMemory[i] 	= 0
		idMemory[i] 	= 0
	end
	bug[groupIDstring] = {
		colorMem 	= colorMemory,
		idMem		= idMemory,
		colorsScore = {},
		lastID		= 1,
		spot		= 0,
		idleFlight	= 0,
		likeToLoad	= 0,
	}
end

for i=missionInfo.moveBorder,missionInfo.activeMapX-missionInfo.moveBorder,missionInfo.spotsSplit do
	spotsCount = spotsCount + 1
	spot[spotsCount] = {i,missionInfo.moveBorder}
	spotsCount = spotsCount + 1
	spot[spotsCount] = {i,missionInfo.activeMapZ-missionInfo.moveBorder}
end
for i=missionInfo.moveBorder,missionInfo.activeMapZ-missionInfo.moveBorder,missionInfo.spotsSplit do
	spotsCount = spotsCount + 1
	spot[spotsCount] = {missionInfo.moveBorder,i}
	spotsCount = spotsCount + 1
	spot[spotsCount] = {missionInfo.activeMapX-missionInfo.moveBorder,i}
end

-- init of weight arrays
-- "static"
memWeight["static"] = {}
for i=1,missionInfo.memorySize do 
	memWeight["static"][i] = 1
end
-- "harmony"
memWeight["harmony"] = {}
for i=1,missionInfo.memorySize do 
	memWeight["harmony"][i] = 1/i
end
-- "geometric"
memWeight["geometric"] = {}
memWeight["geometric"][1] = 0.5
for i=2,missionInfo.memorySize do 
	memWeight["geometric"][i] = memWeight["geometric"][i-1] / 2
end

-- init of IDs of teams
local teams = Spring.GetTeamList()
for i=1,#teams do
	eggTeamIDtoColor[i] = 0
end

local countColorer = 0
for i=1,(numberOfNoeAITeams or 0) do
	if (aiOptions[i].side == "eggs1" or aiOptions[i].side == "eggs2" or aiOptions[i].side == "eggs3" or aiOptions[i].side == "eggs4") then
		countColorer = countColorer + 1
		eggTeamIDtoColor[AITeamID[i]] = countColorer
		eggColorToTeamID[countColorer] = AITeamID[i]
		-- Spring.Echo(AITeamID[i],"má color",countColorer)
	end
end