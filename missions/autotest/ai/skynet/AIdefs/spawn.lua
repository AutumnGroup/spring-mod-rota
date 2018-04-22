----- mission spawn list ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

newSpawnDef = {
}

newSpawnThis = {
}

for id,unitDef in pairs(UnitDefs) do
	local uName = unitDef.name
	local tName	= "t_" .. uName
	newSpawnDef[tName] = {unit = uName, class = "single"}
end

-- PLAYER
for i=1, 10 do
	newSpawnThis[#newSpawnThis+1] = {name = "t_corak", posX = 1000 + math.random(200), posZ = 1000 + math.random(200), facing = "s", teamName = "player1", checkType = "single", checkName="ak" .. i, gameTime = 0}
end
for i=1, 10 do
	newSpawnThis[#newSpawnThis+1] = {name = "t_armspy", posX = 1200 + math.random(200), posZ = 500 + math.random(200), facing = "s", teamName = "player1", checkType = "single", checkName="spy" .. i, gameTime = 0}
end
for i=1, 5 do
	newSpawnThis[#newSpawnThis+1] = {name = "t_corsolar", posX = 500 + i*100, posZ = 500, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
	newSpawnThis[#newSpawnThis+1] = {name = "t_corestor", posX = 500 + i*100, posZ = 750, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
end

newSpawnThis[#newSpawnThis+1] = {name = "t_corrad", posX = 3000, posZ = 200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] = {name = "t_corsilo", posX = 200, posZ = 200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] = {name = "t_corfus", posX = 400, posZ = 100, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

-- ENEMY
local baseX = math.random(1000, 6000)
local baseZ = math.random(2500, 7000)
local smallRadius = 200
local middleRadius = 500
local bigRadius = 1000
newSpawnThis[#newSpawnThis+1] = {name = "t_roost", posX = baseX, posZ = baseZ, facing = "s", teamName = "HumanInsect", checkType = "single", checkName="base", gameTime = 0}
newSpawnThis[#newSpawnThis+1] = {name = "t_wormy", posX = baseX + math.random(-smallRadius, smallRadius), posZ = baseZ + math.random(-smallRadius, smallRadius), facing = "s", teamName = "HumanInsect", checkType = "single", checkName="wormy", gameTime = 120}
for i=1, 100 do
	newSpawnThis[#newSpawnThis+1] = {name = "t_bug1", posX = baseX + math.random(-bigRadius, bigRadius), posZ = baseZ + math.random(-bigRadius, bigRadius), facing = "s", teamName = "HumanInsect", checkType = "single", checkName="bug" .. i, gameTime = 30}
end
for i=1, 12 do
	newSpawnThis[#newSpawnThis+1] = {name = "t_chickend", posX = baseX + math.random(-middleRadius, middleRadius), posZ = baseZ + math.random(-middleRadius, middleRadius), facing = "s", teamName = "HumanInsect", checkType = "single", checkName="tube" .. i, gameTime = 30}
end

function NewSpawner()
    --Spring.Echo("N.O.E. mission_spawner: mission spawner works, but its empty")
end