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


for i=1, 4 do
	newSpawnThis[#newSpawnThis+1] = {name = "t_armpw", posX = 4400 + i*5, posZ = 1300 + i*5, facing = "s", teamName = "player1", checkType = "single", checkName="peewee" .. i, gameTime = 0}
end
for i=1, 10 do
	newSpawnThis[#newSpawnThis+1] = {name = "t_armrock", posX = 4480 + i*5, posZ = 1200 + i*5, facing = "s", teamName = "player1", checkType = "single", checkName="rocko" .. i, gameTime = 0}
end
for i=1, 6 do
	newSpawnThis[#newSpawnThis+1] = {name = "t_armham", posX = 4500 + i*5, posZ = 1250 + i*5, facing = "s", teamName = "player1", checkType = "single", checkName="hammer" .. i, gameTime = 0}
end
for i=1, 2 do
	newSpawnThis[#newSpawnThis+1] = {name = "t_armspy", posX = 4700 + i*5, posZ = 1300 + i*5, facing = "s", teamName = "player1", checkType = "single", checkName="spy" .. i, gameTime = 0}
end

--newSpawnThis[#newSpawnThis+1] = {name = "t_armpeep", posX = 4500, posZ = 100, facing = "s", teamName = "player1", checkType = "single", checkName="peeper", gameTime = 0}
newSpawnThis[#newSpawnThis+1] = {name = "t_corbtrans", posX = 4460, posZ = 1450, facing = "s", teamName = "player1", checkType = "single", checkName="airtrans", gameTime = 0}
newSpawnThis[#newSpawnThis+1] = {name = "t_armseer", posX = 4600, posZ = 1700, facing = "s", teamName = "player1", checkType = "single", checkName="airtrans", gameTime = 0}

for i=1, 5 do
	newSpawnThis[#newSpawnThis+1] = {name = "t_armsolar", posX = 500 + i*100, posZ = 500, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
	newSpawnThis[#newSpawnThis+1] = {name = "t_armestor", posX = 500 + i*100, posZ = 750, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
end

-- ENEMY

for i=1, 28 do
	newSpawnThis[#newSpawnThis+1] = {name = "t_armstump", posX = 8000 + i*5, posZ = 3400 + i*5, facing = "s", teamName = "Attacker", checkType = "single", checkName="tank" .. i, gameTime = 0}
end


function NewSpawner()
    --Spring.Echo("N.O.E. mission_spawner: mission spawner works, but its empty")
end