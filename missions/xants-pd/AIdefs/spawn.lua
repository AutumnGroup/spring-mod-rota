----- mission spawn list ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

newSpawnDef = {
    ["solar"]       = {unit = "armsolar", class = "single"},
    ["hive"]        = {unit = "roost2", class = "single"},
	["beta"]        = {unit = "bug2", class = "single"},
	["target"]      = {unit = "cormonstaq", class = "single"},
	["hive-things"] = {
	    class = "buildingsSet",
		list  = {
			{unit = "chickend", relX = -350, relZ = 25, class = "single"},
			{unit = "chickend", relX = 500, relZ = 120, class = "single"},
			{unit = "chickend", relX = -75, relZ = -250, class = "single"},
			{unit = "chickend", relX = -225, relZ = 80, class = "single"},

		}, 
	},
}

newSpawnThis = {
    --- TIME: 0 ---
	-- formal unit for player --
	{name = "solar", posX = 50, posZ = 50, facing = "n", teamName = "mapper", checkType = "none", gameTime = 0},
	-- formal unit for mapper --
	-- xants ---
	{name = "hive", posX = 1400, posZ = 800, facing = "n", teamName = "xants", checkType = "none", gameTime = 0},
	{name = "hive-things", posX = 1480, posZ = 800, facing = "n", teamName = "xants", checkType = "none", gameTime = 0},
	{name = "target", posX = 7050, posZ = 7550, facing = "n", teamName = "xants", checkType = "none", gameTime = 0},
}

for i=1,missionInfo.numberOfAnts do
	newSpawnThis[#newSpawnThis+1] = {name = "beta", posX = 1500, posZ = 800, facing = "s", teamName = "xants", checkType = "single", checkName = "ant" .. i, gameTime = 250 + i*missionInfo.spawnSplit}
end

function NewSpawner()
    -- Spring.Echo("N.O.E. mission_spawner: mission spawner works, but its empty")
end