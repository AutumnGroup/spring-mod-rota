
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "Chicken Spawner",
    desc      = "Spawns burrows and chickens",
    author    = "quantum, modified by thor, cake",
    date      = "April 29, 2008",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
if (gadgetHandler:IsSyncedCode()) then
-- BEGIN SYNCED
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Speed-ups and upvalues
--

local Spring              = Spring
local math                = math
local Game                = Game
local table               = table
local ipairs              = ipairs
local pairs               = pairs


local queenID
local targetCache     
local luaAI  
local chickenTeamID
local patrollers	  = {}
local knownList           = {}
local hatchlings          = {}
local hivedefenders       = {}
local smartbugs           = {}
local montros             = {}
local burrows             = {}
local burrowBirths	  = {}
local burrowLevel		  = {}
local burrowSpawnProgress = 0
local commanders          = {}
local maxTries            = 100
local computerTeams       = {}
local humanTeams          = {}
local enemyTeams          = {}
local lagging             = false
local cpuUsages           = {}
local chickenBirths       = {}
local kills               = {}
local idleQueue           = {}
local turrets             = {}
local timeOfLastSpawn     = 0
local hiveposx		  		= 0
local hiveposz            	= 0   
local checkDisabled	  		= 0
local unitlists		 		= {}
local dangermap 			= {}
local enemymap 				= {}
local shortmap 				= {}
local flares 				= {}
--pepes AI speedup
local currentBugsList		= {}
local bugAlive				= {}
---------------------
--pepes f.speedups---

local SpCallCOBScript                 = Spring.CallCOBScript
local spCreateUnit                    = Spring.CreateUnit
local SpDestroyUnit                   = Spring.DestroyUnit
local SpEcho                          = Spring.Echo
local SpEditUnitCmdDesc               = Spring.EditUnitCmdDesc
local SpFindUnitCmdDesc               = Spring.FindUnitCmdDesc
local SpGetGaiaTeamID                 = Spring.GetGaiaTeamID
local spGetGameFrame	              = Spring.GetGameFrame
local spGetGameSeconds                = Spring.GetGameSeconds
local SpGetGameSpeed                  = Spring.GetGameSpeed
local spGetGroundBlocked              = Spring.GetGroundBlocked
local spGetGroundHeight               = Spring.GetGroundHeight
local SpGetModOption                  = Spring.GetModOption
-- local SpGetModOptions                 = Spring.GetModOptions
local spGetPlayerInfo                 = Spring.GetPlayerInfo
local spGetPlayerList                 = Spring.GetPlayerList
local spGetTeamLuaAI                  = Spring.GetTeamLuaAI
local spGetTeamList                   = Spring.GetTeamList
local spGetTeamUnits                  = Spring.GetTeamUnits
local spGetTeamUnitCount              = Spring.GetTeamUnitCount
local spGetTeamUnitsCounts            = Spring.GetTeamUnitsCounts
local spGetUnitCommands               = Spring.GetUnitCommands
local spGetUnitDefID	              = Spring.GetUnitDefID
local spGetUnitHealth                 = Spring.GetUnitHealth
local spGetUnitIsCloaked              = Spring.GetUnitIsCloaked
local spGetUnitNearestEnemy           = Spring.GetUnitNearestEnemy
local spGetUnitNeutral                = Spring.GetUnitNeutral
local spGetUnitPosition               = Spring.GetUnitPosition
local spGetUnitsInCylinder            = Spring.GetUnitsInCylinder
local spGetUnitTeam                   = Spring.GetUnitTeam
local spGiveOrderToUnit               = Spring.GiveOrderToUnit
local SpMarkerAddPoint                = Spring.MarkerAddPoint
local SpMarkerAddLine                 = Spring.MarkerAddLine
--local xxxMoveCtrl.Enable              = Spring.MoveCtrl.Enable
--local xxxMoveCtrl.SetNoBlocking       = Spring.MoveCtrl.SetNoBlocking
--local xxxMoveCtrl.SetPosition         = Spring.MoveCtrl.SetPosition
-- Spring.LoadSoundFile
local SpPlaySoundFile                 = Spring.PlaySoundFile
local spRequestPath                   = Spring.RequestPath
local SpSetGameRulesParam             = Spring.SetGameRulesParam
local SpSetUnitAlwaysVisible          = Spring.SetUnitAlwaysVisible
local SpSetUnitBlocking               = Spring.SetUnitBlocking
local SpSetUnitExperience             = Spring.SetUnitExperience
local spSetUnitHealth	              = Spring.SetUnitHealth
local spSetUnitMaxHealth              = Spring.SetUnitMaxHealth
local SpSetUnitNoDraw                 = Spring.SetUnitNoDraw
local SpSetUnitNoSelect               = Spring.SetUnitNoSelect
local spSetUnitStealth                = Spring.SetUnitStealth
local SpTestBuildOrder                = Spring.TestBuildOrder
local SpValidUnitID                   = Spring.ValidUnitID

---------------------


gameMode                  = 'normal' --SpGetModOption("gamemode")
local mexes = {
  "armmex", 
  "cormex",
  "armmoho", 
  "cormoho",
  "armuwmex", 
  "coruwmex",
  "cormmkr",
  "armmmkr",
}

local gameTime = 0
local queenPlan = {
  plan = "",
  time = 0,
  retreatLevel = 0.5,
  queenTargetID = nil,
  queenTargetCache = nil,
}
local queenDoingStuff = {
  time = 0,
  stuff = "",
}
local lastQueenHealth = 0
--local queenTargetCache, queenTargetID
--local queenDoingStuff
--local queenRetreatLevel = 50
--local queenAI = {
--  queenRetreatLevel = 50,
--  queen


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Teams
--


local modes = {
    [0] = 0,
    [1] = 'Bug: Easy',
    [2] = 'Bug: Normal',
    [3] = 'Bug: Hard',
    [4] = 'Bug: Insane',
}


for i, v in ipairs(modes) do -- make it bi-directional
  modes[v] = i
end


local function CompareDifficulty(...)
  level = 1
  for _, difficulty in ipairs{...} do
    if (modes[difficulty] > level) then
      level = modes[difficulty]
    end
  end
  return modes[level]
end

local function BuildUnitLists()
  unitlists = {
    all = {},
    notair = {},
    defensive = {},
    mobilefight = {},
    longrange = {},
    shortrange = {},
  }
  for i, udef in ipairs(UnitDefs) do
    unitlists.all[i] = true
    if (udef.weapons[1] ~= nil) then
      if (udef.canFly == false) then
        if (udef.canMove == false or udef.speed < (30*1.7)) then
          unitlists.defensive[i] = true
        end
        if (udef.canMove == true and udef.speed > (30*0.2)) then
          unitlists.mobilefight[i] = true
        end
        if (udef.weapons[1].onlyTargets.notair == true and WeaponDefs[udef.weapons[1].weaponDef].range > 1000) then
          local wdef = udef.weapons[1].weaponDef
          local firepower = WeaponDefs[wdef].damages[1] / WeaponDefs[wdef].reload
          --if (WeaponDefs[wdef].onlyTargetCategories.notair == true and WeaponDefs[wdef].range < 30000) then          -- keep nukes out of the list

          --  unitlists.longrange[i] = firepower
          --end
        end
        if (udef.weapons[1].onlyTargets.notair == true and WeaponDefs[udef.weapons[1].weaponDef].range < 1000) then
          local wdef = udef.weapons[1].weaponDef
          local firepower = WeaponDefs[wdef].damages[1] / WeaponDefs[wdef].reload
          --if (WeaponDefs[wdef].onlyTargetCategories.notair == true) then          -- keep nukes out of the list
            --SpEcho(udef.name, firepower)
          --  unitlists.shortrange[i] = firepower
          --end
        end
      end
    end
    if (udef.canFly == false) then
      unitlists.notair[i] = true
    end
  end
end


if (not gameMode) then -- set human and computer teams
  humanTeams[0]    = true
  enemyTeams[0]    = true
  computerTeams[1] = true
  chickenTeamID    = 1
  luaAI            = defaultDifficulty
else
  local teams = spGetTeamList()
  local highestLevel = 0
  for _, teamID in ipairs(teams) do
    local teamLuaAI = spGetTeamLuaAI(teamID)
	local bugInName = string.find(teamLuaAI, "Bug")
    if (teamLuaAI and bugInName ~= nil) then
      luaAI = teamLuaAI
      highestLevel = CompareDifficulty(teamLuaAI, highestLevel)
      chickenTeamID = teamID
      computerTeams[teamID] = true
    else
      humanTeams[teamID]    = true
    end
  end
  
  -- once we know which team is spacebugs team
  for _, teamID in pairs(teams) do
	if (not Spring.AreTeamsAllied(teamID, chickenTeamID)) then
		enemyTeams[teamID] = true
	end
  end
  
  luaAI = highestLevel
end


local gaiaTeamID          = SpGetGaiaTeamID()
computerTeams[gaiaTeamID] = nil
humanTeams[gaiaTeamID]    = nil
enemyTeams[gaiaTeamID]    = nil
maxage = waverate


if (gameMode and luaAI == 0) then
  return false
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Utility
--

local function SetToList(set)
  local list = {}
  for k in pairs(set) do
    table.insert(list, k)
  end
  return list
end


local function SetCount(set)
  local count = 0
  for k in pairs(set) do
    count = count + 1
  end
  return count
end

local function RandomElementOfSet(set, setamount)
  if (setamount and setamount >= 1) then
    local chosenElementNumber = math.random(1, setamount)
    local count = 0
    for k in pairs(set) do
      count = count + 1
      if (chosenElementNumber == count) then
        return k
      end
    end
  end
  return nil
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Difficulty
--

do -- load config file
  local CONFIG_FILE = "LuaRules/Configs/spacebugs_defs.lua"
  local VFSMODE = VFS.RAW_FIRST
  local s = assert(VFS.LoadFile(CONFIG_FILE, VFSMODE))
  local chunk = assert(loadstring(s, file))
  setfenv(chunk, gadget)
  chunk()
end


local function SetGlobals(difficulty)
  for key, value in pairs(gadget.difficulties[difficulty]) do
    gadget[key] = value
  end
  gadget.difficulties = nil
end


SetGlobals(luaAI or defaultDifficulty) -- set difficulty


-- adjust for player and chicken bot count
local malus = SetCount(enemyTeams)^playerMalus

if (luaAI == 'Bug: Easy') then
   malus = malus*0.6
elseif (luaAI == 'Bug: Normal') then
   malus = malus*0.9
elseif (luaAI == 'Bug: Insane') then
   malus = malus*1.2
end

burrowSpawnRate = burrowSpawnRate/(malus^0.5)/SetCount(computerTeams)


local function DisableBuildButtons(unitID, ...)
  for _, unitName in ipairs({...}) do
    local cmdDescID = SpFindUnitCmdDesc(unitID, -UnitDefNames[unitName].id)
    if (cmdDescID) then
      local cmdArray = {disabled = true, tooltip = tooltipMessage}
      SpEditUnitCmdDesc(unitID, cmdDescID, cmdArray)
    end
  end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Game Rules
--


local function SetupUnit(unitName)
  SpSetGameRulesParam(unitName.."Count", 0)
  SpSetGameRulesParam(unitName.."Kills", 0)
end


SpSetGameRulesParam("lagging",           0)
SpSetGameRulesParam("queenTime",        queenTime)

for unitName in pairs(chickenTypes) do
  SetupUnit(unitName)
end

for unitName in pairs(defenders) do
  SetupUnit(unitName)
end

SetupUnit(burrowName)
SetupUnit(queenName)
BuildUnitLists()




local difficulty = modes[luaAI or defaultDifficulty]
SpSetGameRulesParam("difficulty", difficulty)



local function UpdateUnitCount()
  local teamUnitCounts = spGetTeamUnitsCounts(chickenTeamID)
  for unitDefID, count in pairs(teamUnitCounts) do
    if (unitDefID ~= "n") then
      SpSetGameRulesParam(UnitDefs[unitDefID].name.."Count", count)
    end
  end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- CPU Lag Prevention
--

local function DetectCpuLag()
  local setspeed,actualspeed,paused = SpGetGameSpeed()
  if paused then return end
  local n = spGetGameFrame()
  local players = spGetPlayerList()
  for _, playerID in ipairs(players) do
    local _, active, spectator, _, _, _, cpuUsage = spGetPlayerInfo(playerID)
    if (cpuUsage > 0) then
      cpuUsages[playerID] = {cpuUsage=math.min(cpuUsage, 1.2), frame=n}
    end
  end
  if (n > 30*10) then
    local toRemove = {}
    for playerID, t in pairs(cpuUsages) do
      if (n-t.frame > 30*60) then
        table.insert(toRemove, playerID)
      end
      local _, active = spGetPlayerInfo(playerID)
      if (not active) then
        table.insert(toRemove, playerID)
      end
    end
    for _, playerID in ipairs(toRemove) do
      cpuUsages[playerID] = nil
    end
    local cpuUsageCount = 0
    local cpuUsageSum   = 0
    for playerID, t in pairs(cpuUsages) do
      cpuUsageSum   = cpuUsageSum + t.cpuUsage
      cpuUsageCount = cpuUsageCount + 1
    end
    local averageCpu = (cpuUsageSum/cpuUsageCount) * (setspeed/actualspeed)
    if (averageCpu > lagTrigger+triggerTolerance) then
           if (not lagging) then
             SpSetGameRulesParam("lagging", 1)
           end
    end
    if (averageCpu < lagTrigger-triggerTolerance) then
      if (lagging) then
        SpSetGameRulesParam("lagging", 0)
      end
      lagging = false
    end
  end
end


local function KillOldChicken()
  for unitID, birthDate in pairs(chickenBirths) do
    local age = spGetGameSeconds() - birthDate
    if (age > maxAge + math.random(10)) then
      if (targetCache) then
        spGiveOrderToUnit(unitID, CMD.FIGHT, targetCache, {})
      end
    end
  end
  for unitID, birthDate in pairs(chickenBirths) do
    local age = spGetGameSeconds() - (birthDate * 4)
    if (age > maxAge + math.random(10)) then
      local unitDefID = spGetUnitDefID(unitID)
      local unitName = UnitDefs[unitDefID].humanName
      if (unitName ~= "Plasma Worm") then
        SpDestroyUnit(unitID)
      end
    end
  end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Game End Stuff
--

local function KillAllChicken()
  local chickenUnits = spGetTeamUnits(chickenTeamID)
  for _, unitID in ipairs(chickenUnits) do
    SpDestroyUnit(unitID)
  end
end


local function KillAllComputerUnits()
  for teamID in pairs(computerTeams) do
    local teamUnits = spGetTeamUnits(teamID)
    for _, unitID in ipairs(teamUnits) do
      SpDestroyUnit(unitID)
    end
  end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Spawn Dynamics
--

local function BullshitTarget(unitID)
  local MINIMUM_TARGET_COST = 200
  local cmdQueue = spGetUnitCommands(unitID, 5)
  if (#cmdQueue>0) then 
    for i, command in ipairs(cmdQueue) do
      --SpEcho(i, command)
      local cmdTag = command.tag
      local cmdID = command.id
      if (cmdID == CMD.FIGHT) then
        if (#command.params == 1) then
          -- This is a fight command to a unit ID
          local unitDefID = spGetUnitDefID(unitID)
          --SpEcho('params is ', command.params[1])
          local myTarget = command.params[1]
          local _, _, _, _, buildProgress = spGetUnitHealth(myTarget)
          local unitMetalCost = UnitDefs[unitDefID].metalCost
          if ((unitMetalCost and buildProgress) and buildProgress < 0.7 and buildProgress * unitMetalCost < MINIMUM_TARGET_COST) then
            --SpEcho('bullshit detected on ', UnitDefs[unitDefID].name, unitID)
            return true
          end
        end
      end
    end
  end
end

local function ChooseOptimalCloseTarget(unitID)
--  SpEcho('choosing a new target')
  -- yeah, this
  local unitx, _, unitz = spGetUnitPosition(unitID)
  local scanlist, listamount = ScanSpotList(unitx, unitz, 700, 'notair')
  attacktarget = RandomElementOfSet(scanlist, listamount)
  if (attacktarget ~= nil) then
    --SpEcho('attacking with ', unitID, 'at 700 range, target ', attacktarget)
    spGiveOrderToUnit(unitID, CMD.ATTACK, {attacktarget}, {})
  else
    -- nuh uh, you aint fooling me, EXPAND THE SEARCH!
    scanlist, listamount = ScanSpotList(unitx, unitz, 1100, 'notair')
    attacktarget = RandomElementOfSet(scanlist, listamount)
    if (attacktarget ~= nil) then
      --SpEcho('attacking with ', unitID, 'at 1100 range, target ', attacktarget)
      spGiveOrderToUnit(unitID, CMD.ATTACK, {attacktarget}, {})
    else
      -- now you're just pissing me off
      scanlist, listamount = ScanSpotList(unitx, unitz, 1600, 'notair')
      attacktarget = RandomElementOfSet(scanlist, listamount)
      if (attacktarget ~= nil) then
        --SpEcho('attacking with ', unitID, 'at 1600 range, target ', attacktarget) 
        spGiveOrderToUnit(unitID, CMD.ATTACK, {attacktarget}, {})
      else
        -- ok, fuck it
      end
    end
  end
end

local function IsPlayerUnitNear(x, z, r)
  for teamID in pairs(enemyTeams) do   
    if (#spGetUnitsInCylinder(x, z, r, teamID) > 0) then
      return true
    end
  end
end


local function AttackNearestEnemy(unitID)
  local targetID = spGetUnitNearestEnemy(unitID)
  if (targetID) then
    local tx, ty, tz  = spGetUnitPosition(targetID)
    spGiveOrderToUnit(unitID, CMD.FIGHT, {tx, ty, tz}, {})
  end
end


local function ChooseTarget()
  local humanTeamList = SetToList(enemyTeams)
  if (#humanTeamList <= 0) then
    return
  end
  local teamID = humanTeamList[math.random(#humanTeamList)]
  local units  = spGetTeamUnits(teamID)
  if (#units <= 0) then
    return
  end
  local unitID = units[math.random(#units)]
  return {spGetUnitPosition(unitID)}
end

local function ChooseTargetID()
  local humanTeamList = SetToList(enemyTeams)
  if (#humanTeamList <= 0) then
    return
  end
  local teamID = humanTeamList[math.random(#humanTeamList)]
  local units  = spGetTeamUnits(teamID)
  if (#units <= 0) then
    return
  end
  local unitID = units[math.random(#units)]
  return unitID
end

local function ChooseExpensiveTarget()
  local humanTeamList = SetToList(enemyTeams)
  if (#humanTeamList <= 0) then
    return
  end
  local bestCost = 0
  local bestUnit = nil
  for teamID in pairs(enemyTeams) do
    for _, unitID in ipairs(spGetTeamUnits(teamID)) do
	local _, _, _, _, buildProgress = spGetUnitHealth(unitID)
      if (buildProgress > 0.9) then
        local unitDefID = spGetUnitDefID(unitID)
        local metalCost = UnitDefs[unitDefID].metalCost
        if (metalCost > bestCost) then
          bestCost = metalCost
          bestUnit = unitID
        end
      end
    end
  end
  if (bestUnit ~= nil) then
    return {spGetUnitPosition(bestUnit)}, bestUnit
  else
    return nil
  end
end


local function ChooseChicken(units)
  local s = spGetGameSeconds()
  units = units or chickenTypes
  choices = {}
  for chickenName, c in pairs(units) do
    if (c.time <= s and (c.obsolete or math.huge) > s) then   
      local chance = math.floor((c.initialChance or 1) + 
                                (s-c.time) * (c.chanceIncrease or 0))
      for i=1, chance do
        table.insert(choices, chickenName)
      end
    end
  end
  if (#choices < 1) then
    return
  else
    return choices[math.random(#choices)], choices[math.random(#choices)], choices[math.random(#choices)], choices[math.random(#choices)]
  end
end

local function ChooseChickenList(units)
  local s = spGetGameSeconds()
  units = units or chickenTypes
  choices = {}
  for chickenName, c in pairs(units) do
    if (c.time <= s*(2400/queenTime)) then   
      table.insert(choices, chickenName)
    end
  end
  for _, unitName in pairs(choices) do
    --SpEcho('choices is ', unitName)
  end
  if (#choices < 1) then
    return
  else
    return choices
  end
end

local function SpawnTheSpecialGuy(burrowID, cheatType)
  local bx, by, bz    = spGetUnitPosition(burrowID)
  if (not bx or not by or not bz) then
    return
  end
  local x, z
  local tries         = 0
  local s             = spawnSquare
  repeat
    x = math.random(bx - s, bx + s)
    z = math.random(bz - s, bz + s)
    s = s + spawnSquareIncrement
    tries = tries + 1
  until (not spGetGroundBlocked(x, z) or tries > cheatType.number + maxTries)
  local squadLeader = spCreateUnit(cheatType.type, x, 0, z, "n", chickenTeamID)
  if (squadLeader) then
    if (cheatType.specialOrders == nil) then
      if (targetCache) then
        spGiveOrderToUnit(squadLeader, CMD.FIGHT, targetCache, {})
      end
    elseif (cheatType.specialOrders == "airpatrol") then
      patrollers[squadLeader] = true
      spGiveOrderToUnit(squadLeader, CMD.PATROL, {hiveposx, 0, hiveposz}, {})
    elseif (cheatType.specialOrders == "defender") then
      hivedefenders[squadLeader] = { hive = burrowID, }
    elseif (cheatType.specialOrders == "arty") then
      montros[squadLeader] = true
      if (targetCache) then
        spGiveOrderToUnit(squadLeader, CMD.FIGHT, targetCache, {})
      end
    elseif (cheatType.specialOrders == "hatchling") then
      hatchlings[squadLeader] = { hive = burrowID, }
    elseif (cheatType.specialOrders == "smartbug") then
      smartbugs[squadLeader] = { target = ChooseTargetID(), }
    end
    chickenBirths[squadLeader] = spGetGameSeconds() 
  end
  if (cheatType.defSquad > 0) then
    local squad_x, squad_z
    local squad_tries   = 0
    for squadNumber = 1, cheatType.defSquad do
      local choosenSquad = math.random(1, #bugSquads)
      for squadUnitName, c_squad in pairs(bugSquads[squadNumber]) do
        for squadSpawnUnit_i = 1, c_squad.number do
          s = spawnSquare
          repeat
            squad_x = math.random(bx - s, bx + s)
            squad_z = math.random(bz - s, bz + s)
            s = s + spawnSquareIncrement
            squad_tries = squad_tries + 1
          until (not spGetGroundBlocked(squad_x, squad_z) or squad_tries > cheatType.number + maxTries)
          local squadMember = spCreateUnit(squadUnitName, squad_x, 0, squad_z, "n", chickenTeamID)
          if (targetCache and squadMember) then
            spGiveOrderToUnit(squadMember, CMD.GUARD, {squadLeader}, {})
            chickenBirths[squadMember] = spGetGameSeconds() 
          end
        end
      end
    end
  end
end



local function SpawnChicken(burrowID, spawnNumber, chickenName)
  local x, z
  local bx, by, bz    = spGetUnitPosition(burrowID)
  if (not bx or not by or not bz) then
    return
  end
  local tries         = 0
  local s             = spawnSquare
  
  for i=1, spawnNumber do  
    repeat
      x = math.random(bx - s, bx + s)
      z = math.random(bz - s, bz + s)
      s = s + spawnSquareIncrement
      tries = tries + 1
    until (not spGetGroundBlocked(x, z) or tries > spawnNumber + maxTries)
    
    local unitID = spCreateUnit(chickenName, x, 0, z, "n", chickenTeamID)
    if (targetCache and unitID) then
      spGiveOrderToUnit(unitID, CMD.FIGHT, targetCache, {})
      chickenBirths[unitID] = spGetGameSeconds()
    end
  end
end

local function SpawnSpecialChickens(burrowID)
  local sec = spGetGameSeconds()
  for i, cheatType in pairs(cheatingTypes) do
    if (burrowLevel[burrowID] >= cheatType.minBurrowLevel and sec >= (cheatType.startTime/2400)*queenTime) then
      if (math.random(0, cheatType.chance/malus^cheatType.malusAffect) == 0) then
        for specialSpawnAmount = 1, cheatType.number do
          SpawnTheSpecialGuy(burrowID, cheatType)
        end
      end
    end
  end
end


local function SpawnTurret(burrowID, turret)
  
  local x, z
  local bx, by, bz    = spGetUnitPosition(burrowID)
  local tries         = 0
  local s             = spawnSquare
  local spawnNumber   = math.max(math.floor(defenderChance), 1)
  
  for i=1, spawnNumber do
    
    repeat
      x = math.random(bx - s, bx + s)
      z = math.random(bz - s, bz + s)
      s = s + spawnSquareIncrement
      tries = tries + 1
    until (not spGetGroundBlocked(x, z) or tries > spawnNumber + maxTries)
    
    local unitID = spCreateUnit(turret, x, 15, z, "n", chickenTeamID) -- FIXME --pepeedit 0 on 15
	-- SpEcho (unitID)
	if (unitID ~= nil) then
        SpSetUnitBlocking(unitID, false)
        turrets[unitID] = spGetGameSeconds()
	end
  end
  
end


local function SpawnBurrow(number)
  
  if (queenID) then
    return
  end

  local t     = spGetGameSeconds()
  local unitDefID = UnitDefNames[burrowName].id
    
  for i=1, 1 do
    local x, z
    local tries = 0

    repeat
      x = math.random(spawnSquare, Game.mapSizeX - spawnSquare)
      z = math.random(spawnSquare, Game.mapSizeZ - spawnSquare)
      local y = spGetGroundHeight(x, z)  
      tries = tries + 1
      local blocking = SpTestBuildOrder(UnitDefNames["armmmkr"].id, x, y, z, 1)
      if (blocking == 2) then
        local proximity = spGetUnitsInCylinder(x, z, minBaseDistance)
        local vicinity = spGetUnitsInCylinder(x, z, maxBaseDistance)
        local humanUnitsInVicinity = false
        local humanUnitsInProximity = false
        for i=1,#vicinity,1 do
          if (spGetUnitTeam(vicinity[i]) ~= chickenTeamID) then
            humanUnitsInVicinity = true
            break
          end
        end

        for i=1,#proximity,1 do
          if (spGetUnitTeam(proximity[i]) ~= chickenTeamID) then
            humanUnitsInProximity = true
            break
          end
        end

        if (humanUnitsInProximity or not humanUnitsInVicinity) then
          blocking = 1
        end
      end
    until (blocking == 2 or tries > maxTries)
    local unitID = spCreateUnit(burrowName, x, 15, z, "n", chickenTeamID) --pepeedit 0 on 15
    if (unitID) then
      hiveposx = x
      hiveposz = z
      burrows[unitID] = true
      SpSetUnitBlocking(unitID, false)  --87.0 change?
      burrowBirths[unitID] = spGetGameSeconds() 
      burrowLevel[unitID] = 0
    end
  end
end

local function SpawnInitialSpecials()
  local sec = spGetGameSeconds()
  for i, cheatType in pairs(cheatingTypes) do
    if (cheatType.beenIntroduced == nil and sec >= (cheatType.startTime/2400)*queenTime) then
      -- pick a burrow and spawn amount
      cheatType.beenIntroduced = true
      local numBurrows = SetCount(burrows)
      if (numBurrows >= 1) then
        local chosenBurrowToSpawnAt = math.random(numBurrows)
        local burrowIndex = 1
        local spawnNumber = math.ceil(cheatType.initialSpawnPerPlayer * malus)
  	  for f=1, spawnNumber do
          for burrowID in pairs(burrows) do
           if (burrowIndex == chosenBurrowToSpawnAt) then
              for specialSpawnAmount = 1, cheatType.number do
              -- spawn it here
              SpawnTheSpecialGuy(burrowID, cheatType)
              end
            end
           burrowIndex = burrowIndex + 1
	    end
        end
      end
    end
  end
end

local function PutDefendersOnNewBurrows() 
  local t     = spGetGameSeconds()
  local turret = ChooseChicken(defenders)
  --local spawnNumber = math.floor(2.1+malus)
  local spawnNumber = 3
  for burrowID in pairs(burrows) do
    if (t - burrowBirths[burrowID] < 13) then
      if (turret) then
         for i=1, spawnNumber do
        	SpawnTurret(burrowID, turret)
         end
      end
    end
  end
end



local function SpawnQueen()
  
  local x, z
  local tries = 0
 
 repeat
    x = math.random(spawnSquare, Game.mapSizeX - spawnSquare)
    z = math.random(spawnSquare, Game.mapSizeZ - spawnSquare)
    local y = spGetGroundHeight(x, z)
    tries = tries + 1
    local blocking = SpTestBuildOrder(UnitDefNames["armfff"].id, x, y, z, 1)
    if (blocking == 2 and tries < maxTries - 10) then
      local proximity = spGetUnitsInCylinder(x, z, minBaseDistance)
      local vicinity = spGetUnitsInCylinder(x, z, maxBaseDistance)
      local humanUnitsInVicinity = false
      local humanUnitsInProximity = false
      for i=1,#vicinity,1 do -- pepe
        if (spGetUnitTeam(vicinity[i]) ~= chickenTeamID) then
          humanUnitsInVicinity = true
          break
        end
      end

      for i=1,#proximity,1 do  --pepe
        if (spGetUnitTeam(proximity[i]) ~= chickenTeamID) then
          humanUnitsInProximity = true
          break
        end
      end

      if (humanUnitsInProximity or not humanUnitsInVicinity) then
        blocking = 1
      end
    end
  until (blocking == 2 or tries > maxTries)  
  --Spring.LoadSoundFile("sounds/TRexRoar.wav")
  SpPlaySoundFile("sounds/TRexRoar.wav") --, 1.0, x, 0 ,z)
  return spCreateUnit(queenName, x, 0, z, "n", chickenTeamID)
end


local function Wave()
  
  local t = spGetGameSeconds()
  
  if (spGetTeamUnitCount(chickenTeamID) > maxChicken or lagging or t < gracePeriod) then
    return
  end
  
  local chickenSpawningList = ChooseChickenList(chickenTypes)
  --local chicken1Name, chicken2Name, chicken3Name = ChooseChicken(chickenTypes)
  local turret = ChooseChicken(defenders)
  local squadNumber = (t * timeSpawnBonus * malus^0.6) + firstSpawnSize
  local totalRatio = 0
  for _, chickenName in pairs(chickenSpawningList) do
    --chickenTypes[chickenName].ratio = 1
    chickenTypes[chickenName].ratio = chickenTypes[chickenName].ratio + chickenTypes[chickenName].ratioIncrease
    totalRatio = totalRatio + chickenTypes[chickenName].ratio
  end
  --local chicken1Number = math.ceil(waveRatio * squadNumber * chickenTypes[chicken1Name].squadSize)
  --local chicken2Number = math.floor((1-waveRatio) * squadNumber * chickenTypes[chicken2Name].squadSize)
  --local chicken3Number = math.floor((1-waveRatio) * squadNumber * chickenTypes[chicken2Name].squadSize)
  --if (queenID) then
  --  SpawnChicken(queenID, chicken1Number*queenSpawnMult*malus, chicken1Name)
  --  SpawnChicken(queenID, chicken2Number*queenSpawnMult*malus, chicken2Name)
  --else
  SpawnInitialSpecials()
  for burrowID in pairs(burrows) do
    burrowLevel[burrowID] = burrowLevel[burrowID] + burrowUpgradePerWave
    SpawnSpecialChickens(burrowID)
    for _, chickenName in pairs(chickenSpawningList) do
      local chickenNumber = math.ceil(squadNumber * chickenTypes[chickenName].squadSize * (chickenTypes[chickenName].ratio / totalRatio))
      SpawnChicken(burrowID, chickenNumber, chickenName)
    end
    if (math.random() < defenderChance and defenderChance < 1 and turret) then
      SpawnTurret(burrowID, turret)
    end
  end
  return chickenName, chickenNumber
end

local function MiniWave()
  
  local t = spGetGameSeconds()
  
  if (spGetTeamUnitCount(chickenTeamID) > maxChicken or lagging or t < gracePeriod) then
    return
  end
  
  local chickenSpawningList = ChooseChickenList(chickenTypes)
  --local chicken1Name, chicken2Name, chicken3Name = ChooseChicken(chickenTypes)
  local turret = ChooseChicken(defenders)
  local squadNumber = (t * timeSpawnBonus * malus^0.6) + firstSpawnSize
  squadNumber = squadNumber * 0.6
  local totalRatio = 0
  for _, chickenName in pairs(chickenSpawningList) do
    --chickenTypes[chickenName].ratio = 1
    chickenTypes[chickenName].ratio = chickenTypes[chickenName].ratio + chickenTypes[chickenName].ratioIncrease
    totalRatio = totalRatio + chickenTypes[chickenName].ratio
  end
  for burrowID in pairs(burrows) do
    for _, chickenName in pairs(chickenSpawningList) do
      local chickenNumber = math.ceil(squadNumber * chickenTypes[chickenName].squadSize * (chickenTypes[chickenName].ratio / totalRatio))
      SpawnChicken(burrowID, chickenNumber, chickenName)
    end
  end
  return chickenName, chickenNumber
end


-------------------------------------------------------------------------------------------------------
-- QUEEN AI PART OF STUFF
-------------------------------------------------------------------------------------------------------

function FillInDangermaps()
  local mapx = Game.mapSizeX
  local mapz = Game.mapSizeZ
  local MAP_DIVISION_SIZE = 256
  local MAP_X_DIVISIONS = math.floor(mapx / MAP_DIVISION_SIZE)
  local MAP_Z_DIVISIONS = math.floor(mapz / MAP_DIVISION_SIZE)
  for gridx = 0, MAP_X_DIVISIONS do
    dangermap[gridx] = {}
    enemymap[gridx] = {}
    shortmap[gridx] = {}
    for gridz = 0, MAP_Z_DIVISIONS do
      shortmap[gridx][gridz] = 0
      dangermap[gridx][gridz] = 0
      enemymap[gridx][gridz] = {}
    end
  end
  for teamID in pairs(enemyTeams) do
    for _, unit in ipairs(spGetTeamUnits(teamID)) do
      local defID = spGetUnitDefID(unit)
      local unitHealth, _, _, _, buildProgress = spGetUnitHealth(unit)
      if ((unitlists["longrange"][defID] ~= nil) and buildProgress >= .98) then
        local unitx, _, unitz = spGetUnitPosition(unit)
        local range = UnitDefs[defID].maxWeaponRange
        local tryBoxesRange = math.floor(range / MAP_DIVISION_SIZE)
        local unitBoxX, unitBoxZ = math.floor(unitx / MAP_DIVISION_SIZE), math.floor(unitz / MAP_DIVISION_SIZE)
        local leftBoxes, rightBoxes = unitBoxX - tryBoxesRange, unitBoxX + tryBoxesRange
        local topBoxes, bottomBoxes = unitBoxZ - tryBoxesRange, unitBoxZ + tryBoxesRange
        if (leftBoxes < 0) then
          leftBoxes = 0
        end
        if (rightBoxes > MAP_X_DIVISIONS) then
          rightBoxes = MAP_X_DIVISIONS
        end
        if (topBoxes < 0) then
          topBoxes = 0
        end
        if (bottomBoxes > MAP_Z_DIVISIONS) then
          bottomBoxes = MAP_Z_DIVISIONS
        end
        for boxX = leftBoxes, rightBoxes do
          for boxZ = topBoxes, bottomBoxes do
            local realBoxX, realBoxZ = (boxX * MAP_DIVISION_SIZE) - MAP_DIVISION_SIZE / 2, (boxZ * MAP_DIVISION_SIZE) - MAP_DIVISION_SIZE / 2
            local distance = GetDistance(unitx, unitz, realBoxX, realBoxZ)
            if (distance < range) then
              enemymap[boxX][boxZ][unit] = true
              --local wdef = UnitDefs[defID].weapons[1].weaponDef
              --local reductionRatio = (WeaponDefs[wdef].accuracy * distance)
              dangermap[boxX][boxZ] = dangermap[boxX][boxZ] + unitlists["longrange"][defID]
              --local addx, addz = math.random(-100, 100), math.random(-100, 100)
              --SpMarkerAddLine(realBoxX+addx, 0, realBoxZ+addz, realBoxX+10+addx, 0, realBoxZ+10+addz)
            end
          end
        end
      end
      if (unitlists["shortrange"][defID] ~= nil and buildProgress >= .98) then
        local unitx, _, unitz = spGetUnitPosition(unit)
        local unitBoxX, unitBoxZ = math.floor(unitx / MAP_DIVISION_SIZE), math.floor(unitz / MAP_DIVISION_SIZE)
        if (unitBoxX >= 0 and unitBoxX <= MAP_X_DIVISIONS and unitBoxZ >= 0 and unitBoxZ <= MAP_Z_DIVISIONS) then
          shortmap[unitBoxX][unitBoxZ] = shortmap[unitBoxX][unitBoxZ] + unitlists["shortrange"][defID] * (unitHealth / 1000)
        end
      end
    end
  end
end

function ScanSpotList(spotx, spotz, radius, scanWhat)
  local list = {}
  local unitAmount = 0
  for teamID in pairs(enemyTeams) do
    local doodsOnSpot = spGetUnitsInCylinder(spotx, spotz, radius, teamID)
    for i = 1, table.getn(doodsOnSpot) do
      local defID = spGetUnitDefID(doodsOnSpot[i])
      if (scanWhat == nil or unitlists[scanWhat][defID] ~= nil) then
        local _, _, _, _, buildProgress = spGetUnitHealth(doodsOnSpot[i])
        if (spGetUnitNeutral(doodsOnSpot[i]) ~= true and (buildProgress > .95) and (spGetUnitIsCloaked(doodsOnSpot[i]) == false or knownList[doodsOnSpot[i]])) then
          list[doodsOnSpot[i]] = true
          unitAmount = unitAmount + 1
        end
      end
    end
  end
  return list, unitAmount
end

function ScanSpotCost(spotx, spotz, radius, scanWhat)
	local spotCost = 0
	local unitAmount = 0
	for teamID in pairs(enemyTeams) do
		local doodsOnSpot = spGetUnitsInCylinder(spotx, spotz, radius, teamID)
		for i = 1, table.getn(doodsOnSpot) do
			local defID = spGetUnitDefID(doodsOnSpot[i])
			if (scanWhat == nil or unitlists[scanWhat][defID] ~= nil) then
				local _, _, _, _, buildProgress = spGetUnitHealth(doodsOnSpot[i])
				if ((buildProgress > .95) and (spGetUnitIsCloaked(doodsOnSpot[i]) == false)) then
					spotCost = spotCost + UnitDefs[defID].metalCost + (UnitDefs[defID].energyCost / 50)
					unitAmount = unitAmount + 1
				end
			end
		end
	end
	return spotCost, unitAmount
end

function AddSenseGroup(foundEnemyGroups, sensex, sensez, senseType, groupSenseRadius)
  local closestDist = 100000
  local list = ScanSpotList(sensex, sensez, groupSenseRadius, senseType)
  local unitID
  for doodID in pairs(list) do
    local ux, _, uz = spGetUnitPosition(doodID)
    local xdist, zdist
    if (ux < sensex) then
      xdist = sensex - ux
    else
      xdist = ux - sensex
    end
    if (uz < sensez) then
      zdist = sensez - uz
    else
      zdist = uz - sensez 
    end
    local dist = math.sqrt((xdist*xdist) + (zdist * zdist))
    if (dist < closestDist) then
      closestDist = dist
      unitID = doodID
    end
  end
  if (unitID ~= nil) then
    local countGroups = 1
    for _, _ in ipairs(foundEnemyGroups) do
      countGroups = countGroups + 1
    end	
  local sensex, sensey, sensez = spGetUnitPosition(unitID)
  local spotCost = ScanSpotCost(sensex, sensez, groupSenseRadius, senseType)
  foundEnemyGroups[countGroups] = {
    cost = spotCost,
    x = sensex,
    y = sensey,
    z = sensez,
  }
  end
  return foundEnemyGroups
end

function SenseGroups(avgx, avgz, senseType, scandist)
  local listSense = ScanSpotList(avgx, avgz, scandist, senseType)
  local foundEnemyGroups = {}
  local countGroups = 0
  -- skips are done so it doesn't make too many scans... too cpu heavy
  local SKIP_SENSE_AMOUNT = 16
  local SENSE_GROUP_RADIUS = 350
  local MAX_ENEMY_GROUPS = 6
  local numlist = 0
  for id in pairs(listSense) do  -- list isn't ordered so get.tablen is fail
    numlist = numlist + 1
  end
  local skip = (numlist / SKIP_SENSE_AMOUNT) - 1
  local skipcounter = 0
  for id in pairs(listSense) do
    if (skipcounter < 1) then
      countGroups = countGroups + 1
      local px, py, pz  = spGetUnitPosition(id)
      local spotCost = ScanSpotCost(px, pz, SENSE_GROUP_RADIUS, senseType)
      foundEnemyGroups[countGroups] = {
        cost = spotCost,
        x = px,
        y = py,
        z = pz,
	}
	skipcounter = skipcounter + skip
    else
      skipcounter = skipcounter - 1
    end
  end
  -- order randomly found groups from strongest to weakest
  for groupnum, first in ipairs(foundEnemyGroups) do
    local tic = false
    for swapnumber, second in ipairs(foundEnemyGroups) do
      if (swapnumber > groupnum) then
        tic = true
      end
      if (tic == true and foundEnemyGroups[groupnum].cost < foundEnemyGroups[swapnumber].cost) then
        -- swap
        local temp = foundEnemyGroups[groupnum]
        foundEnemyGroups[groupnum] = foundEnemyGroups[swapnumber]
        foundEnemyGroups[swapnumber] = temp
      end
    end
  end
  -- order them again, checking for duplicate units this time
  local marked = {}
  for dagroup in ipairs(foundEnemyGroups) do
    local px, py, pz  = foundEnemyGroups[dagroup].x, foundEnemyGroups[dagroup].y, foundEnemyGroups[dagroup].z
    local subscan = ScanSpotList(px, pz, SENSE_GROUP_RADIUS, senseType)
    local spotCost = 0
    for u in pairs(subscan) do
      if (marked[u] == nil) then
        local defID = spGetUnitDefID(u)
        if (unitlists[senseType][defID] ~= nil) then
          spotCost = spotCost + UnitDefs[defID].metalCost + (UnitDefs[defID].energyCost / 50)
        end
        marked[u] = true
      end
    end
    foundEnemyGroups[dagroup].cost = spotCost
  end
  -- order them once more, strongest to weakest and no more than max_enemy_groups
  for groupnum, first in ipairs(foundEnemyGroups) do
    local tic = false
    if (groupnum <= MAX_ENEMY_GROUPS) then
      for swapnumber, second in ipairs(foundEnemyGroups) do
        if (swapnumber > groupnum) then
          tic = true
        end
        if (tic == true and foundEnemyGroups[groupnum].cost < foundEnemyGroups[swapnumber].cost) then
          -- swap
          local temp = foundEnemyGroups[groupnum]
          foundEnemyGroups[groupnum] = foundEnemyGroups[swapnumber]
          foundEnemyGroups[swapnumber] = temp
        end
      end
      if (foundEnemyGroups[groupnum].cost == 0) then
        foundEnemyGroups[groupnum] = nil
      end
    else
      foundEnemyGroups[groupnum] = nil
    end
  end
  --foundEnemyGroups = AddSenseGroup(foundEnemyGroups, groupAction[group].prevAtt.x, groupAction[group].prevAtt.z, senseType, SENSE_GROUP_RADIUS)
  return foundEnemyGroups
end

function GetDistance(x1, z1, x2, z2)
  local xdist, zdist
  if (x1 < x2) then
    xdist = x2 - x1
  else
    xdist = x1 - x2 
  end
  if (z1 < z2) then
    zdist = z2 - z1
  else
    zdist = z1 - z2 
  end
  return (math.sqrt(xdist*xdist + zdist*zdist))
end

function UnitGoesNuclear(unitID)
  -- LOL write this
  return true
end

function SwitchQueenPlan(newPlan)
  if (newPlan ~= nil and newPlan == 'attack') then
    targetCache = ChooseExpensiveTarget()
    if (targetCache == nil) then
      targetCache = ChooseTarget()
    end
    MiniWave()
  end
  queenPlan.plan = newPlan
  queenPlan.time = gameTime
  queenPlan.queenTargetID = nil
  queenPlan.queenTargetCache = nil
end

function SwitchQueenOrders(newOrders)
  queenDoingStuff.stuff = newOrders
  queenDoingStuff.time = gameTime
end

function FindQueenRetreatTarget()
  local mapx = Game.mapSizeX
  local mapz = Game.mapSizeZ
  local queenx, _, queenz = spGetUnitPosition(queenID)
  local bestBurrowRating = -1000000
  local bestBurrow = nil
  for burrowID in pairs(burrows) do
    -- to do, is pathing good?, guns in range?
    local burrowx, _, burrowz = spGetUnitPosition(burrowID)
    local MAP_DIVISION_SIZE = 256
    local MAP_X_DIVISIONS = math.floor(mapx / MAP_DIVISION_SIZE)
    local MAP_Z_DIVISIONS = math.floor(mapz / MAP_DIVISION_SIZE)
    local gridx = math.floor(burrowx / MAP_DIVISION_SIZE)
    local gridz = math.floor(burrowz / MAP_DIVISION_SIZE) 
    local burrowDanger = 0
    if (gridx >= 0 and gridx <= MAP_X_DIVISIONS and gridz >= 0 and gridz <= MAP_Z_DIVISIONS) then
      burrowDanger = dangermap[gridx][gridz]
    end
    -- also add in enemymap info
    local spotCost = ScanSpotCost(burrowx, burrowz, 1600, 'notair')
    local burrowDistance = GetDistance(queenx, queenz, burrowx, burrowz)
    local burrowRating = (burrowLevel[burrowID]/2) - (burrowDistance / 200) - (burrowDanger/1.5) - (spotCost / 30)
    if (burrowRating > bestBurrowRating) then
      bestBurrowRating = burrowRating
      bestBurrow = burrowID
    end
  end
  if (bestBurrow ~= nil) then
    return {spGetUnitPosition(bestBurrow)}, bestBurrow
  else
    return nil, nil
  end
end

function QueenSafeToHeal()
  local mapx = Game.mapSizeX
  local mapz = Game.mapSizeZ
  local queenx, _, queenz = spGetUnitPosition(queenID)
  local burrowx, _, burrowz = spGetUnitPosition(queenPlan.queenTargetID)
  local MAP_DIVISION_SIZE = 256
  local MAP_X_DIVISIONS = math.floor(mapx / MAP_DIVISION_SIZE)
  local MAP_Z_DIVISIONS = math.floor(mapz / MAP_DIVISION_SIZE)
  local gridx = math.floor(queenx / MAP_DIVISION_SIZE)
  local gridz = math.floor(queenz / MAP_DIVISION_SIZE) 
  local danger = 0
  if (gridx >= 0 and gridx <= MAP_X_DIVISIONS and gridz >= 0 and gridz <= MAP_Z_DIVISIONS) then
    danger = dangermap[gridx][gridz]
  end
  if (GetDistance(queenx, queenz, burrowx, burrowz) < 300 and danger == 0) then
    return true
  end
  return false
end

function QueenAtHealyPlace()
  local queenx, _, queenz = spGetUnitPosition(queenID)
  local burrowx, _, burrowz = spGetUnitPosition(queenPlan.queenTargetID)
  if (GetDistance(queenx, queenz, burrowx, burrowz) < 300) then
    return true
  end
  return false
end

function QueenTakingSeriousDamage()
  local queenx, queeny, queenz = spGetUnitPosition(queenID)
  local queenHealth, queenMaxHealth = spGetUnitHealth(queenID)
  local queenHealthPercentage = queenHealth / queenMaxHealth
  if (lastQueenHealth - queenHealth > 5000) then
    return  true
  else
    return false
  end
end

--function TemporarilyRetreatQueen()
--  SwitchQueenOrders("tempRetreat")
--  local retreatMoveCoordinates = {50,0,50}
--  spGiveOrderToUnit(queenID, CMD.MOVE, retreatMoveCoordinates, {})
--  --spGiveOrderToUnit(queenID, CMD.MOVE, {50, 0, 50}, {})
--end

function CheckMoveDanger(xspot, zspot)
  
end

function RateTargetPath(targetx, targetz)
  local targety = spGetGroundHeight(targetx, targetz)
  local queenx, queeny, queenz = spGetUnitPosition(queenID)
  local mapx = Game.mapSizeX
  local mapz = Game.mapSizeZ
  local totalPathDist, nodes, firstStep, skirmishPoint, skirmishNodes = PathItUp(queenx, queenz, targetx, targetz)
  local pathbadness = 0
  local skirmishBadness = 0
  local time = 0
  local longjerks = {}
  for nodeNum in pairs(nodes) do
    local MAP_DIVISION_SIZE = 256
    local MAP_X_DIVISIONS = math.floor(mapx / MAP_DIVISION_SIZE)
    local MAP_Z_DIVISIONS = math.floor(mapz / MAP_DIVISION_SIZE)
    local gridx = math.floor(nodes[nodeNum].x / MAP_DIVISION_SIZE)
    local gridz = math.floor(nodes[nodeNum].z / MAP_DIVISION_SIZE)  
    local rangedDamage, riffraff = 0,0
    if (gridx >= 0 and gridx <= MAP_X_DIVISIONS and gridz >= 0 and gridz <= MAP_Z_DIVISIONS) then
      rangedDamage = dangermap[gridx][gridz]
      riffraff = shortmap[gridx][gridz]
      --longjerks = longjerks + enemymap[gridx][gridz]
    end
    local slowtime = riffraff / 40
    if (slowtime < 1) then
      slowtime = 1
    end
    time = time + slowtime
    pathbadness = pathbadness + (slowtime * rangedDamage)
    if (skirmishNodes[nodeNum] ~= nil) then
      skirmishBadness = pathbadness
    end
  end
  local moverating = { badness = skirmishBadness, time = time, dist = totalPathDist, firstStep = firstStep, x = targetx, y = targety, z = targetz, pathDist = totalPathDist, }
  return moverating
end

function RateGroupTargets(groups)
  local proposedMoves = {}
  for groupnum, dagroup in ipairs(groups) do
    moverating = RateTargetPath(dagroup.x, dagroup.z)
    proposedMoves[groupnum] = moverating
  end
  return proposedMoves;
end


function PathItUp(startx, startz, xloc, zloc)
  local reducedNodes = {}
  local nodesToSkirmish = {}
  local distByLand = 0
  local SINGLE_MOVE_DIST = 256
  local range = 750
  local firstStep
  local skirmishLoc
  local starty = spGetGroundHeight(startx, startz)
  local yloc = spGetGroundHeight(xloc, zloc)
  local thePath = spRequestPath(QUEEN_PATH_TYPE, startx, starty, startz, xloc, yloc, zloc)
  -- SpMarkerAddLine(startx, starty, startz, xloc, yloc, zloc)
  --thePath.GetEstimatedPath ---> GetPathWayPoints in (83.0---->85.00)
  --
  if (thePath ~= nil) then
    local morePath, startIdxOfDetailedPath = thePath.GetPathWayPoints(thePath)
    if (morePath ~= nil) then
      local curx, curz = startx, startz
      local lastMilepost = 0
      local milepostNum = 1
      for nodeNumber in ipairs(morePath) do
        local nx, ny, nz = morePath[nodeNumber][1], morePath[nodeNumber][2], morePath[nodeNumber][3]
        local lastDist = GetDistance(curx, curz, nx, nz)
        lastMilepost = lastMilepost + lastDist
        distByLand = distByLand + lastDist
        if (milepostNum == 1 and firstStep == nil) then
          if (lastMilepost >= SINGLE_MOVE_DIST) then
            firstStep = {
              x = nx,
              y = ny,
              z = nz,
            }
          end
        end
        if (lastMilepost >= 600) then
          reducedNodes[milepostNum] = {
            x = nx,
            y = ny,
            z = nz,
          }
          nodesToSkirmish[milepostNum] = reducedNodes[milepostNum]
          milepostNum = milepostNum + 1
          --SpMarkerAddLine(nx, ny, nz, nx+10, ny, nz+10)
          lastMilepost = 0
        end
        -- try to find the point where it will be possible to skirmish from
        if (skirmishLoc == nil) then
          local heightDifference = yloc - spGetGroundHeight(nx, nz)
          if (heightDifference < 0) then
            heightDifference = 0
          end
          local newDifference = GetDistance(nx, nz, xloc, zloc) - heightDifference
          if (newDifference < range) then
            --local curHeightDifference = yloc - spGetGroundHeight(curx, curz)
            --if (curHeightDifference < 0) then
            -- curHeightDifference = 0
            --end
            local add_dist = lastDist - (range - newDifference)
            local addx, addz = (nx - curx)*(add_dist/lastDist), (nz - curz)*(add_dist / lastDist)
            --SpMarkerAddLine(curx+addx, ny, curz+addz, curx+10+addx, ny, curz+10+addz)
            skirmishLoc = {
              x = curx + addx,
              z = curz + addz,
            }
          end
        end
        curx, curz = nx, nz
      end
      if (firstStep == nil and distByLand > 0) then
        -- path distance was less than the first mile post
        firstStep = {
          x = curx,
          y = spGetGroundHeight(curx, curz),
          z = curz,
        }
      end
    end
  end
  return distByLand, reducedNodes, firstStep, skirmishLoc, nodesToSkirmish
end

local function QueenMoveController(movex, movey, movez)
  local queenx, queeny, queenz = spGetUnitPosition(queenID)
  local endcost, endpointamount = ScanSpotCost(movex, movez, 50, 'notair')
  local midcost, midpointamount = ScanSpotCost((movex+queenx)/2, (movez+queenz)/2, 50, 'notair')
  if ((endpointamount + midpointamount >= 12 and endcost + midcost > 1500)) then
    spGiveOrderToUnit(queenID, CMD.FIGHT, {movex, movey, movez}, {})
  else
    spGiveOrderToUnit(queenID, CMD.MOVE, {movex, movey, movez}, {})
  end
end

local function QueenFightMoveController(movex, movey, movez)
  spGiveOrderToUnit(queenID, CMD.FIGHT, {movex, movey, movez}, {})
end

local function QueenFightManager(proposedMove)
  local sec = spGetGameSeconds()
  local queenx, queeny, queenz = spGetUnitPosition(queenID)
  if (queenDoingStuff.stuff == "flare") then
    if (sec - queenDoingStuff.time > 3) then
      --SpEcho("flare done")
      spGiveOrderToUnit(queenID, CMD.TRAJECTORY, { 0 }, {})
      SpCallCOBScript(queenID, "SetFlare", 1, 0)
      SwitchQueenOrders("nothing")
    end
  end
  if (queenDoingStuff.stuff == "nothing" or queenDoingStuff.stuff == "") then
    SwitchQueenOrders("fighting")
  end
  if (queenDoingStuff.stuff == "fighting") then
    if (sec - queenDoingStuff.time > 20) then
      asteroidturkeys = SenseGroups(queenx, queenz, 'defensive', 1400)
      for groupnum, dagroup in ipairs(asteroidturkeys) do
        if (GetDistance(queenx, queenz, dagroup.x, dagroup.z) > 800) then
          if (dagroup.cost > 3000) then
            --SpEcho("flare go!")
            flares.time = sec
            flares.x = dagroup.x
            flares.y = dagroup.y
            flares.z = dagroup.z
            spGiveOrderToUnit(queenID, CMD.TRAJECTORY, { 1 }, {})
            SpCallCOBScript(queenID, "SetFlare", 1, 1)
            spGiveOrderToUnit(queenID, CMD.DGUN, {dagroup.x, dagroup.y, dagroup.z}, {})
            SwitchQueenOrders("flare")
          end
        end
      end
    end
  end
  if (queenDoingStuff.stuff == "fighting") then
    if (GetDistance(proposedMove.x, proposedMove.z, queenx, queenz) < 650) then
      local movex, movey, movez = proposedMove.x, proposedMove.y, proposedMove.z
      QueenFightMoveController(movex, movey, movez)
    else
      local movex, movey, movez = proposedMove.firstStep.x, proposedMove.firstStep.y, proposedMove.firstStep.z
      QueenMoveController(movex, movey, movez)
    end
  end
end

local function QueenAttackManager()
  local queenx, queeny, queenz = spGetUnitPosition(queenID)
  local queenHealth, queenMaxHealth = spGetUnitHealth(queenID)
  local queenHealthPercentage = queenHealth / queenMaxHealth
  if (queenPlan.plan == "attack") then
    -- the usual...
    local targetx, targety, targetz = spGetUnitPosition(queenPlan.queenTargetID)
    local distByLand, reducedNodes, firstStep, skirmishLoc, nodesToSkirmish = PathItUp(queenx, queenz, targetx, targetz)
    local nearGroups = SenseGroups(queenx, queenz, 'notair', 2300)
    local proposedMoves = RateGroupTargets(nearGroups)
    local bestMove = nil
    local bestMoveRating = 0
    for movenum, move in ipairs(proposedMoves) do
      local moveRating = nearGroups[movenum].cost / (move.badness + (move.dist) + (move.time * 50))
      if (moveRating > bestMoveRating) then
        bestMoveRating = moveRating
        bestMove = movenum
      end
      --proposedMoves[groupnum] = 
    end
    if (bestMove) then
      --SpMarkerAddPoint(proposedMoves[bestMove].x, 0, proposedMoves[bestMove].z, bestMoveRating)
    end
    if (bestMove and bestMoveRating > 1) then
      QueenFightManager(proposedMoves[bestMove])
    elseif (firstStep ~= nil) then
      local tempPropose = RateTargetPath(targetx, targetz)
      --local tempPropose = { badness = 1, time = 1, firstStep = firstStep, x = targetx, y = targety, z = targetz, pathDist = distByLand, }
      --SpEcho("temp propose")
      QueenFightManager(tempPropose)
      --QueenMoveController(firstStep.x, firstStep.y, firstStep.z)
    end
  end
  if (queenPlan.plan == "kamiattack") then
    -- chaaaaaaarge
    local distByLand, reducedNodes, firstStep, skirmishLoc, nodesToSkirmish = PathItUp(queenx, queenz, targetx, targetz)
    if (firstStep ~= nil) then
      QueenMoveController(firstStep.x, firstStep.y, firstStep.z)
    end
  end
end

local function QueenRetreatManager()
  local queenx, queeny, queenz = spGetUnitPosition(queenID)
  local targetx, targety, targetz = spGetUnitPosition(queenPlan.queenTargetID)
  local queenHealth, queenMaxHealth = spGetUnitHealth(queenID)
  local queenHealthPercentage = queenHealth / queenMaxHealth
  local distByLand, reducedNodes, firstStep, skirmishLoc, nodesToSkirmish = PathItUp(queenx, queenz, targetx, targetz)
  if (firstStep ~= nil) then
    spGiveOrderToUnit(queenID, CMD.MOVE, {firstStep.x, firstStep.y, firstStep.z}, {})
  end
end

local function QueenHealManager()
  local queenx, queeny, queenz = spGetUnitPosition(queenID)
  local queenHealth, queenMaxHealth = spGetUnitHealth(queenID)
  local queenHealthPercentage = queenHealth / queenMaxHealth
  if (queenPlan.queenTargetID == nil or not SpValidUnitID(queenPlan.queenTargetID)) then
    if (queenPlan.retreatLevel == 0.3) then
      queenPlan.retreatLevel = 0.5
    else
      queenPlan.retreatLevel = 0.3
    end
    SwitchQueenPlan("retreat")
  else
    -- the usual...
    local targetx, targety, targetz = spGetUnitPosition(queenPlan.queenTargetID)
    local distByLand, reducedNodes, firstStep, skirmishLoc, nodesToSkirmish = PathItUp(queenx, queenz, targetx, targetz)
    local nearGroups = SenseGroups(queenx, queenz, 'notair', 2300)
    local proposedMoves = RateGroupTargets(nearGroups)
    local bestMove = nil
    local bestMoveRating = 0
    for movenum, move in ipairs(proposedMoves) do
      local moveRating = nearGroups[movenum].cost / (move.badness + (move.dist) + (move.time * 50))
      if (moveRating > bestMoveRating) then
        bestMoveRating = moveRating
        bestMove = movenum
      end
    end
    if (bestMove and bestMoveRating > 1.8) then
      QueenFightManager(proposedMoves[bestMove])
    elseif (firstStep ~= nil) then
      if (QueenAtHealyPlace() and not QueenSafeToHeal()) then
        if (queenPlan.retreatLevel == 0.3) then
          queenPlan.retreatLevel = 0.5
        else
          queenPlan.retreatLevel = 0.3
        end
        SwitchQueenPlan("retreat")
      else
        local tempPropose = RateTargetPath(targetx, targetz)
        QueenFightManager(tempPropose)
      end
    end
  end
end

local function RunQueenAI()
  local queenx, queeny, queenz = spGetUnitPosition(queenID)
  local queenHealth, queenMaxHealth = spGetUnitHealth(queenID)
  local queenHealthPercentage = queenHealth / queenMaxHealth
  FillInDangermaps()
  if (queenPlan.plan == "attack" or queenPlan.plan == "kamiattack") then
    if (queenPlan.queenTargetID == nil or not SpValidUnitID(queenPlan.queenTargetID)) then
      queenPlan.queenTargetCache, queenPlan.queenTargetID = ChooseExpensiveTarget()
      --SpEcho('QUEEN ANGRY AT ID', queenPlan.queenTargetID, ' POS ', queenPlan.queenTargetCache[1], queenPlan.queenTargetCache[3])
    end
    if (queenHealthPercentage < queenPlan.retreatLevel) then
      SwitchQueenPlan("retreat")
    elseif (queenPlan.queenTargetID ~= nil) then
      QueenAttackManager()
    end
  elseif (queenPlan.plan == "retreat") then
    if (queenPlan.queenTargetID == nil or not SpValidUnitID(queenPlan.queenTargetID)) then
      queenPlan.queenTargetCache, queenPlan.queenTargetID = FindQueenRetreatTarget()
      --SpEcho('QUEEN RUNNING TO ID', queenPlan.queenTargetID, ' POS ', queenPlan.queenTargetCache[1], queenPlan.queenTargetCache[3])
      if (queenPlan.queenTargetID == nil) then
        -- nowhere left to retreat to...
        queenPlan.retreatLevel = -1
        SwitchQueenPlan("attack")
      end
    end
    if (queenPlan.queenTargetID ~= nil) then
      local targetx, targety, targetz = spGetUnitPosition(queenPlan.queenTargetID)
      if (QueenSafeToHeal()) then
        SwitchQueenPlan("heal")
        if (queenPlan.retreatLevel == 0.5) then
          queenPlan.retreatLevel = 0.3
        elseif (queenPlan.retreatLevel == 0.3) then
          queenPlan.retreatLevel = -1
        end
      else
        if (QueenAtHealyPlace()) then
          -- not safe, but i'm here... find a new spot
          SwitchQueenPlan("retreat")
        else
          QueenRetreatManager()
        end
      end
    end
  elseif (queenPlan.plan == "heal") then
    QueenHealManager()
    if (QueenTakingSeriousDamage() or queenHealthPercentage > 0.9) then
      SwitchQueenPlan("attack")
    end
  end
  lastQueenHealth = queenHealth
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Other AI types
--

local function RunSmartbugAI(unitID)
  if (smartbugs[unitID].target and SpValidUnitID(smartbugs[unitID].target)) then
    local targetPosition = {spGetUnitPosition(smartbugs[unitID].target)}
    spGiveOrderToUnit(unitID, CMD.FIGHT, targetPosition, {})
  else
    smartbugs[unitID].target = ChooseTargetID()
  end
end

local function RunHatchlingAI(hatchling)
  local sec = spGetGameSeconds()
  if (math.random(15) <= 1) then
    local myHive = hatchlings[hatchling].hive
    if (myHive ~= nil) then
      if (SpValidUnitID(myHive)) then
        local bx, by, bz    = spGetUnitPosition(myHive)
        local wanderCoordinates = {}
        wanderCoordinates[1], wanderCoordinates[2], wanderCoordinates[3] = spGetUnitPosition(myHive)
        wanderCoordinates[1] = wanderCoordinates[1] + math.random(200) - 100
        wanderCoordinates[3] = wanderCoordinates[3] + math.random(200) - 100
        spGiveOrderToUnit(hatchling, CMD.MOVE, wanderCoordinates, {})
        if (chickenBirths[hatchling] < sec - hatchlingWaitTime) then
          -- it is time for the montro!
          --SpEcho('montro!!!')
          SpDestroyUnit(hatchling)
          if (not bx or not by or not bz) then
            return
          end
          local tries         = 0
          local s             = spawnSquare
          repeat
            x = math.random(bx - s, bx + s)
            z = math.random(bz - s, bz + s)
            s = s + spawnSquareIncrement
            tries = tries + 1
          until (not spGetGroundBlocked(x, z) or tries > cheatType.number + maxTries)
          local montro = spCreateUnit('cormonsta', x, 0, z, "n", chickenTeamID)
          montros[montro] = { target = ChooseTargetID()}
        end
      end
    end
  end
end
  
local function RunHiveDefenderAI(unitID)
  
end

local function RunArtybugAI(unitID)
  if (montros[unitID].target and SpValidUnitID(montros[unitID].target)) then
    local targetPosition = {spGetUnitPosition(montros[unitID].target)}
    spGiveOrderToUnit(unitID, CMD.FIGHT, targetPosition, {})
  else
    montros[unitID].target = ChooseTargetID()
  end
end

local function AttackWithPatrols()
  for unitID, _ in pairs(patrollers) do
    patrollers[unitID] = nil
    if (targetCache) then
      spGiveOrderToUnit(unitID, CMD.FIGHT, targetCache, {})
    end
  end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Get rid of the AI
--

local function DisableUnit(unitID)
  Spring.MoveCtrl.Enable(unitID)
  Spring.MoveCtrl.SetNoBlocking(unitID, true)
  Spring.MoveCtrl.SetPosition(unitID, Game.mapSizeX+4000, 0, Game.mapSizeZ+4000)
  spSetUnitHealth(unitID, {paralyze=99999999})
  SpSetUnitNoDraw(unitID, true)
  spSetUnitStealth(unitID, true)
  SpSetUnitNoSelect(unitID, true)
  commanders[unitID] = nil
end

local function DisableComputerUnits()
  for teamID in pairs(computerTeams) do
    local teamUnits = spGetTeamUnits(teamID)
    for _, unitID in ipairs(teamUnits) do
      DisableUnit(unitID)
    end
  end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Call-ins
--

function gadget:UnitCreated(unitID, unitDefID, unitTeam)
  local name = UnitDefs[unitDefID].name
  if (name == "armbase" or
      name == "corbase") then
    commanders[unitID] = true
  end
  if (alwaysVisible and unitTeam == chickenTeamID) then
    SpSetUnitAlwaysVisible(unitID, true)
  end
  if (unitTeam == chickenTeamID) then
	bugAlive[unitID] = true
  end
end



function gadget:GameFrame(n)
  local t = spGetGameSeconds()
  gameTime = t

  if (n == 1) then
    DisableComputerUnits()
    checkDisabled = checkDisabled + 1
  end

  if (checkDisabled == 0) then
    DisableComputerUnits()
    checkDisabled = checkDisabled + 1
  end
  
  if ((n+19) % (30 * chickenSpawnRate) < 0.1) then
    local timeInWave = (n+19) % (30 * waveRate)
    --if (timeInWave == 0) then
    --  SpEcho('Wave!')
    --end
    if (timeInWave <= chickenSpawnRate * spawnsPerWave * 30) then
      local args
      if (t >= queenTime) then
        args = {MiniWave()}
      else
        args = {Wave()}
      end
      if (#args > 0) then
        _G.chickenEventArgs = {type="wave", unpack(args)}
        SendToUnsynced("ChickenEvent")
        _G.chickenEventArgs = nil
      end
    end
  end
  
  local framing = (n+21) % 30
  if (framing >= 0 and framing < 21) then

    --DetectCpuLag()
    UpdateUnitCount()
    targetCache = ChooseTarget()
	
	-- pepes speedup
	local step = 20
	if (framing == 0) then
		currentBugsList = spGetTeamUnits(chickenTeamID)
	end
  
    for i=framing,#currentBugsList,step do
	  local unitID = currentBugsList[i]
	  if (bugAlive[unitID]) then
		  if (unitID == queenID) then
			RunQueenAI()
		  elseif (smartbugs[unitID]) then
			RunSmartbugAI(unitID)
		  elseif (hatchlings[unitID]) then
			RunHatchlingAI(unitID)
		  elseif (hivedefenders[unitID]) then
			RunHiveDefenderAI(unitID)
		  elseif (montros[unitID]) then
			RunArtybugAI(unitID)
		  else
			local commandsCount = spGetUnitCommands(unitID, 0)
			if ((commandsCount > 0) and BullshitTarget(unitID)) then
			  -- FUUUUUUUUUUU bullshit cheating exploit you die now
			  ChooseOptimalCloseTarget(unitID)
			elseif (targetCache and 
			(commandsCount < 1)) then
			  spGiveOrderToUnit(unitID, CMD.FIGHT, targetCache, {})
			end
		  end
	  end
    end  


    if (t >= queenTime) then
      if (not queenID) then
        _G.chickenEventArgs = {type="queen"}
        SendToUnsynced("ChickenEvent")
        _G.chickenEventArgs = nil
        AttackWithPatrols()
        FillInDangermaps()
        queenID = SpawnQueen()
        local xp = (malus^2 or 1) - 1
		if (xp == nil or xp < 0.1) then xp = 0.1 end -- hacky fix = i was not reading the code much :/, it does not matter much, will be replaced
        SpSetUnitExperience(queenID, xp)
	  local _, maxhp = spGetUnitHealth(queenID)
	  spSetUnitMaxHealth(queenID, maxhp*malus^2)
	  spSetUnitHealth(queenID, maxhp*malus^2)

    	  --if (targetCache) then
          --spGiveOrderToUnit(queenID, CMD.MOVE, targetCache, {})
    	  --end
        SwitchQueenPlan("attack")
        RunQueenAI()
      end
    end
  end

  if ((n+26) % (30*12) < 0.1) then 

    KillOldChicken()
   
    local malus = SetCount(enemyTeams)^playerMalus

    local burrowCount = SetCount(burrows)
    local timeSinceLastSpawn = t - timeOfLastSpawn
    local burrowSpawnTime = burrowSpawnRate/(malus^0.2)
   
    if ((burrowCount+1)/malus^0.6 <= 6) then
      burrowSpawnTime = (burrowSpawnRate*math.log(((burrowCount+1)*1.15)^0.4))/malus
    end    
    PutDefendersOnNewBurrows()
    --SpEcho("burrowcount", burrowCount, " maxBurrows", maxBurrows)
    if (burrowSpawnTime < timeSinceLastSpawn and burrowCount < maxBurrows) then
      SpawnBurrow()
      timeOfLastSpawn = t
      _G.chickenEventArgs = {type="burrowSpawn"}
      SendToUnsynced("ChickenEvent")
      _G.chickenEventArgs = nil
    end
    
  end
  
end


function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
  patrollers[unitID] = nil
  chickenBirths[unitID] = nil
  burrowBirths[unitID] = nil
  commanders[unitID] = nil
  turrets[unitID] = nil
  hatchlings[unitID] = nil
  hivedefenders[unitID] = nil
  smartbugs[unitID] = nil
  montros[unitID] = nil
  local name = UnitDefs[unitDefID].name
  if (unitTeam == chickenTeamID) then
    if (chickenTypes[name] or defenders[name]) then
      local kills = Spring.GetGameRulesParam(name.."Kills")
      SpSetGameRulesParam(name.."Kills", kills + 1)
    end
    if (name == queenName) then
      --KillAllComputerUnits()
      KillAllChicken()
    end
  end
  if (name == burrowName) then
    burrowLevel[unitID] = nil
    burrows[unitID] = nil
    local burrowCount = SetCount(burrows)
    if (burrowCount/malus^.8 <= 2) then
      SpawnBurrow()
    end
  end
  
  if (unitTeam == chickenTeamID) then
	bugAlive[unitID] = nil
  end
end


function gadget:TeamDied(teamID)
  humanTeams[teamID] = nil
  computerTeams[teamID] = nil
  enemyTeams[teamID] = nil
end


function gadget:AllowCommand(unitID, unitDefID, teamID,
                             cmdID, cmdParams, cmdOptions)
  return true  -- command was not used
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
else

-- END SYNCED
-- BEGIN UNSYNCED
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- local Script = Script
-- local SYNCED = SYNCED


-- function WrapToLuaUI()
  -- if (Script.LuaUI('ChickenEvent')) then
    -- local chickenEventArgs = {}
    -- for k, v in spairs(SYNCED.chickenEventArgs) do
      -- chickenEventArgs[k] = v
    -- end
    -- Script.LuaUI.ChickenEvent(chickenEventArgs)
  -- end
-- end


-- function gadget:Initialize()
  -- if(Spring.GetModOptions().startoptions ~= 'spacebugs') then
    -- SpEcho('Removing Spacebugs', Spring.GetModOptions().startoptions)
    -- gadgetHandler:RemoveGadget()
  -- else
    -- gadgetHandler:AddSyncAction('ChickenEvent', WrapToLuaUI)
  -- end
-- end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
end
-- END UNSYNCED
--------------------------------------------------------------------------------
