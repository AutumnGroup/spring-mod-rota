--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


local hardModifier   = 1
spawnSquare          = 150       -- size of the chicken spawn square centered on the burrow
spawnSquareIncrement = 1         -- square size increase for each unit spawned
burrowName           = "roost"   -- burrow unit name
playerMalus          = 1         -- how much harder it becomes for each additional player
maxChicken           = 5000 -- Spring.GetModOptions().mo_maxchicken or 500
lagTrigger           = 0.5       -- average cpu usage after which lag prevention mode triggers
triggerTolerance     = 0.05      -- increase if lag prevention mode switches on and off too fast
maxAge               = 6*60      -- chicken die at this age, seconds // gets set to waverate
burrowUpgradePerWave = 20
queenName            = "cormonstaq"
defenderChance       = 0.5       -- amount of turrets spawned per wave, <1 is the probability of spawning a single turret
maxBurrows           = ((Spring.GetModOptions().mo_maxburrows) or 40) * 1   --Spring.GetModOptions().mo_maxburrows or 40
queenSpawnMult       = 16         -- how many times bigger is a queen hatch than a normal burrow hatch
alwaysVisible        = false     -- chicken are always visible
burrowSpawnRate      = 60       -- higher in games with many players, seconds
chickenSpawnRate     = 60
hatchlingWaitTime    = 360
waveRate = 360
spawnsPerWave = 3
minBaseDistance      = 1000      
maxBaseDistance      = 5000
gracePeriod          = 160       -- no chicken spawn in this period, seconds
queenTime            = (Spring.GetModOptions().mo_queentime or 40) * 60 -- time at which the queen appears, seconds
QUEEN_PATH_TYPE = "montro"
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function Copy(original)   -- Warning: circular table references lead to
  local copy = {}               -- an infinite loop.
  for k, v in pairs(original) do
    if (type(v) == "table") then
      copy[k] = Copy(v)
    else
      copy[k] = v
    end
  end
  return copy
end


local function TimeModifier(d, mod)
  for chicken, t in pairs(d) do
    t.time = t.time*mod
    if (t.obsolete) then
      t.obsolete = t.obsolete*mod
    end
  end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- times in minutes
local chickenTypes = {
  bug1      =  {time =  0,  squadSize = 5, ratio = 1, ratioIncrease = 0},
  bug2     =  {time =  9,  squadSize = 0.5, ratio = 0.3, ratioIncrease = 0.05},
  corgamma     =  {time = 25,  squadSize = 1.5, ratio = 1, ratioIncrease = 0},
  bug3 	=  {time = 34,  squadSize = .3, ratio = 0.3, ratioIncrease = 0.1},
}

local bugSquads = {
  {
    bug2 = {number = 4},
  },
  {
    corgamma = {number = 6},
    bug2 = {number = 2},
  },
  {
    corgamma2 = {number = 4},
  },
}

local cheatingTypes = {
  {type = "bug1", minBurrowLevel = 0, defSquad = 0, number = 6, specialOrders = "airpatrol", startTime = 100, chance = 7, malusAffect = 0, initialSpawnPerPlayer = 0.5},
  {type = "bug2", minBurrowLevel = 0, defSquad = 0, number = 6, specialOrders = "airpatrol", startTime = 200, chance = 50, malusAffect = 0, initialSpawnPerPlayer = 0.5},
  {type = "corgamma", minBurrowLevel = 0, defSquad = 0, number = 2, specialOrders = "airpatrol", startTime = 500, chance = 12, malusAffect = 0, initialSpawnPerPlayer = 0.5},
  {type = "corgamma2", minBurrowLevel = 0, defSquad = 0, number = 3, specialOrders = "airpatrol", startTime = 500, chance = 12, malusAffect = 0, initialSpawnPerPlayer = 0.5},
  {type = "corgamma2", minBurrowLevel = 0, defSquad = 0, number = 4, specialOrders = nil, startTime = 900, chance = 30, malusAffect = 0.3, initialSpawnPerPlayer = 0.5},
  {type = "corgamma2", minBurrowLevel = 0, defSquad = 0, number = 7, specialOrders = "airpatrol", startTime = 1200, chance = 34, malusAffect = 0.2, initialSpawnPerPlayer = 0.5},
  {type = "bug5", minBurrowLevel = 65, defSquad = 2, number = 1, specialOrders = "smartbug", startTime = 600, chance = 38, malusAffect = 0.4, initialSpawnPerPlayer = 0.8},
  {type = "wormy", minBurrowLevel = 65, defSquad = 0, number = 1, specialOrders = nil, startTime = 900, chance = 130, malusAffect = 0.4, initialSpawnPerPlayer = 0.4},
  {type = "cormonstab", minBurrowLevel = 65, defSquad = 0, number = 1, specialOrders = "hatchling", startTime = 1000, chance = 130, malusAffect = 0.5, initialSpawnPerPlayer = 0.4},
}

local defenders = {
  chickend =  {time = 1, squadSize = 1 },
  }
    
    
difficulties = {
  ['Bug: Easy'] = {
    waveRate = 380,
    chickenSpawnRate = 80, 
    spawnsPerWave = 2,
    burrowSpawnRate  = 215,
    gracePeriod      = 210,
    burrowUpgradePerWave = 14,       
    firstSpawnSize   = 1,
    timeSpawnBonus   = .005,     -- how much each time level increases spawn size
    chickenTypes     = {
 	 bug1      =  {time =  0,  squadSize = 4, ratio = 1, ratioIncrease = 0},
 	 bug2     =  {time =  18,  squadSize = .25, ratio = 0.2, ratioIncrease = 0.025},
 	 corgamma     =  {time = 36,  squadSize = 1, ratio = 0.5, ratioIncrease = 0},
 	 bug3 	=  {time = 45,  squadSize = .125, ratio = 0.2, ratioIncrease = 0.05},
    },
    cheatingTypes = {
      {type = "bug1", minBurrowLevel = 0, defSquad = 0, number = 6, specialOrders = "airpatrol", startTime = 200, chance = 7, malusAffect = 0, initialSpawnPerPlayer = 0.5},
      {type = "corgamma", minBurrowLevel = 0, defSquad = 0, number = 2, specialOrders = "airpatrol", startTime = 1000, chance = 12, malusAffect = 0, initialSpawnPerPlayer = 0.5},
      {type = "corgamma2", minBurrowLevel = 0, defSquad = 0, number = 3, specialOrders = "airpatrol", startTime = 1000, chance = 12, malusAffect = 0, initialSpawnPerPlayer = 0.5},
      {type = "corgamma2", minBurrowLevel = 0, defSquad = 0, number = 7, specialOrders = "airpatrol", startTime = 2000, chance = 34, malusAffect = 0.2, initialSpawnPerPlayer = 0.5},
      {type = "bug5", minBurrowLevel = 65, defSquad = 1, number = 1, specialOrders = "smartbug", startTime = 2100, chance = 60, malusAffect = 0.4, initialSpawnPerPlayer = 0.8},
      {type = "wormy", minBurrowLevel = 65, defSquad = 0, number = 1, specialOrders = nil, startTime = 4000, chance = 130, malusAffect = 0.4, initialSpawnPerPlayer = 0.4},
      {type = "cormonstab", minBurrowLevel = 65, defSquad = 0, number = 1, specialOrders = "hatchling", startTime = 4000, chance = 130, malusAffect = 0.5, initialSpawnPerPlayer = 0.4},
    },

    bugSquads = Copy(bugSquads),
    defenders        = Copy(defenders),
  },

  ['Bug: Normal'] = {
    waveRate = 350,
    chickenSpawnRate = 80,
    spawnsPerWave = 2,
    burrowSpawnRate  = 162,
    gracePeriod      = 120,
    burrowUpgradePerWave = 20,
    firstSpawnSize   = 1,
    timeSpawnBonus   = .008,
    chickenTypes     = Copy(chickenTypes),
    cheatingTypes = {
      {type = "bug1", minBurrowLevel = 0, defSquad = 0, number = 6, specialOrders = "airpatrol", startTime = 100, chance = 7, malusAffect = 0, initialSpawnPerPlayer = 0.5},
      {type = "corgamma", minBurrowLevel = 0, defSquad = 0, number = 2, specialOrders = "airpatrol", startTime = 500, chance = 12, malusAffect = 0, initialSpawnPerPlayer = 0.5},
      {type = "corgamma2", minBurrowLevel = 0, defSquad = 0, number = 3, specialOrders = "airpatrol", startTime = 500, chance = 12, malusAffect = 0, initialSpawnPerPlayer = 0.5},
      {type = "corgamma2", minBurrowLevel = 0, defSquad = 0, number = 4, specialOrders = nil, startTime = 900, chance = 30, malusAffect = 0.3, initialSpawnPerPlayer = 0.5},
      {type = "corgamma2", minBurrowLevel = 0, defSquad = 0, number = 7, specialOrders = "airpatrol", startTime = 1200, chance = 34, malusAffect = 0.2, initialSpawnPerPlayer = 0.5},
      {type = "bug5", minBurrowLevel = 65, defSquad = 2, number = 1, specialOrders = "smartbug", startTime = 900, chance = 38, malusAffect = 0.4, initialSpawnPerPlayer = 0.8},
      {type = "wormy", minBurrowLevel = 65, defSquad = 0, number = 1, specialOrders = nil, startTime = 1500, chance = 130, malusAffect = 0.4, initialSpawnPerPlayer = 0.4},
      {type = "cormonstab", minBurrowLevel = 65, defSquad = 0, number = 1, specialOrders = "hatchling", startTime = 1500, chance = 130, malusAffect = 0.5, initialSpawnPerPlayer = 0.4},
    },

    bugSquads = Copy(bugSquads),
    defenders        = Copy(defenders),
  },

  ['Bug: Hard'] = {
    waveRate = 380,
    chickenSpawnRate = 60,
    spawnsPerWave = 3,
    burrowSpawnRate  = 147,
    gracePeriod      = 80,
    burrowUpgradePerWave = 30,
    firstSpawnSize   = 1,
    timeSpawnBonus   = .008,
    chickenTypes     = Copy(chickenTypes),
    cheatingTypes = Copy(cheatingTypes),
    bugSquads = Copy(bugSquads),
    defenders        = Copy(defenders),
  },
  ['Bug: Insane'] = {
    waveRate = 350,
    chickenSpawnRate = 60,
    spawnsPerWave = 3,
    burrowSpawnRate  = 147,
    gracePeriod      = 20,
    burrowUpgradePerWave = 40,
    firstSpawnSize   = 1.3,
    timeSpawnBonus   = .010,
    chickenTypes     = 	{
  	bug1      =  {time =  0,  squadSize = 5, ratio = 1, ratioIncrease = 0},
  	bug2     =  {time =  6,  squadSize = 0.5, ratio = 0.3, ratioIncrease = 0.05},
  	corgamma     =  {time = 22,  squadSize = 1.5, ratio = 1.3, ratioIncrease = 0.0},
  	bug3 	=  {time = 33,  squadSize = .3, ratio = 0.3, ratioIncrease = 0.1},
				},
    cheatingTypes = Copy(cheatingTypes),
    bugSquads = Copy(bugSquads),
    defenders        = Copy(defenders),
  },

}



-- minutes to seconds
for _, d in pairs(difficulties) do
  d.timeSpawnBonus = d.timeSpawnBonus/60
  TimeModifier(d.chickenTypes, 60)
  TimeModifier(d.defenders, 60)
end


TimeModifier(difficulties['Bug: Hard'].chickenTypes, hardModifier)
TimeModifier(difficulties['Bug: Hard'].defenders,    hardModifier)

defaultDifficulty = 'Bug: Hard'

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
