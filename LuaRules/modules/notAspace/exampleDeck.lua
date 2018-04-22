local moduleInfo = {
	name 	= "exampleDeck",
	desc 	= "example TSP definitions",
	author 	= "PepeAmpere",
	date 	= "2015/05/18",
	license = "notAlicense",
}

-- definition based on
local lastIDnumber = 1000
local function GetRandomCardID()
	-- return some numbers, they not much random - but still not the same
	-- for purpose of test we want to be sure that there is no number repeated and we do not get some total bullshit numbers
	local newID = math.random(lastIDnumber + 1, lastIDnumber + 10)
	lastIDnumber = newID
	return newID
end

local function GetRandomCardType()
	-- for current test we needs just one cardType
	return "standardDrop"
end

local function GetRandomCardLevel()
	-- for testing purpose we not care for cases where there small card level with many units, which doesnt fit the size rules
	return math.random(1, 5)
end

local function GetRandomUnitDefName()
	-- just some basic list of units and we choose random item
	local listOfUnitDefNames = {
		"armpw",
		"armrock",
		"armham",
		"armfark",
		"armjeth",
		"armsnipe",
		"armzeus",
		"armwar",
		"armstump",
		"armflash",
		"armlatnk",
		"armpeep",
		"armsh",
	}
	local listItemIndex = math.random(1, #listOfUnitDefNames)
	return listOfUnitDefNames[listItemIndex]
end

local function GetRandomUnitCount()
	-- currently returns some not extraordinary number of units in card
	return math.random(5, 20)
end

local function GetRandomTechnologyEffect()
	-- currently returns usual techs effect values
	return math.random(100, 120)
end

local function GetRandomExperience()
	-- currently returns usual experience values
	return math.random(100, 150)
end

local function GetFormationBasedOnUnitDefName(unitDefName)
	-- currently we want just one formation
	return "swarm"
end

function GiveMeRandomDeck(numberOfItems)
	local newDeck = {}
	for i=1, numberOfItems do
		newDeck[i] = {
			cardID = GetRandomCardID(),
			cardType = GetRandomCardType(),
			cardData = {
				level = GetRandomCardLevel(),
				unitDefName = GetRandomUnitDefName(),
				unitCount = GetRandomUnitCount(),
				technology = {
					weapons = GetRandomTechnologyEffect(),
					plating = GetRandomTechnologyEffect(),
				},
				experience = GetRandomExperience(), 
				formationName = GetFormationBasedOnUnitDefName(),
			},
		}
	end
	return newDeck
end

exmapleDeck = {
	[1] = {
		cardID = 4851,
		cardType = "standardDrop",
		cardData = {
			level = 4,
			unitDefName = "armpw",
			unitCount = 22,
			technology = {
				weapons = 100,
				plating = 100,
			},
			experience = 100, 
			formationName = "swarm",
		},
	},
	[2] = {
		cardID = 86324,
		cardType = "standardDrop",
		cardData = {
			level = 2,
			unitDefName = "armrock",
			unitCount = 10,
			technology = {
				weapons = 110,
				plating = 105,
			},
			experience = 100, 
			formationName = "swarm",
		},
	}, 
	[3] = {
		cardID = 98254,
		cardType = "standardDrop",
		cardData = {
			level = 5,
			unitDefName = "armthund",
			unitCount = 12,
			technology = {
				weapons = 101,
				plating = 108,
			},
			experience = 160, 
			formationName = "swarm",
		},
	}, 
}

