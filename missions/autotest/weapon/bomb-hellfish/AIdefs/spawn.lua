----- mission spawn list ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

-- !! not finished --
-- ! not own spawner
-- ! need add resources start setting

newSpawnDef = {
}

newSpawnThis = {
}

for id,unitDef in pairs(UnitDefs) do
	local uName 			= unitDef.name
	local tName				= "t_" .. uName
	newSpawnDef[tName] 		= {unit = uName, class = "single"}
end

for i=1, 10 do
	newSpawnThis[#newSpawnThis+1] 	= {name = "t_armasp", posX = 100, posZ = i*60, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
end
for i=1, 10 do
	newSpawnThis[#newSpawnThis+1] 	= {name = "t_armrad", posX = 20, posZ = 1000+i*60, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
end

-- 10 planes
local thisType = "t_armhell"
local positionBaseX = 10*200
local positionBaseZ = 100

for p = 1, 10 do		
	newSpawnThis[#newSpawnThis+1] = {name = thisType, posX = positionBaseX + p*300, posZ = positionBaseZ * p, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane" .. p, gameTime = 0}
end

-- 10 spyplanes
local thisType = "t_armpeep"
local positionBaseX = 10*200
local positionBaseZ = 100

for p = 11, 20 do		
	newSpawnThis[#newSpawnThis+1] = {name = thisType, posX = positionBaseX + (p - 10)*300, posZ = positionBaseZ * p, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane" .. p, gameTime = 0}
end

-- technical enemy
newSpawnThis[#newSpawnThis+1] 	= {name = "t_pireye", posX = 8000, posZ = 8000, facing = "s", teamName = "Defender", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corfus", posX = 7500, posZ = 7500, facing = "s", teamName = "Defender", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_coreter", posX = 7700, posZ = 7700, facing = "s", teamName = "Defender", checkType = "none", gameTime = 0}

-- real enemy
-- 50 peewees
local thisType = "t_armpw"
local positionBaseX = 3500
local positionBaseZ = 3500

for p = 1, 50 do		
	newSpawnThis[#newSpawnThis+1] = {name = thisType, posX = positionBaseX + math.random(300), posZ = positionBaseZ + math.random(300), facing = "s", teamName = "Defender", checkType = "single", checkName="bot" .. p, gameTime = 0}
end


function NewSpawner()
    --Spring.Echo("N.O.E. mission_spawner: mission spawner works, but its empty")
end