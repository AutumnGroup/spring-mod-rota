----- mission spawn list ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

-- !! not finished --
-- ! not own spawner
-- ! need add resources start setting

newSpawnDef = {
    ["peewee"] = {unit = "armpw", class = "single"},
	["solar"] = {unit = "armpw", class = "single"},
	["radar"] = {unit = "armrad", class = "single"},
	["warrior"] = {unit = "armwar", class = "single"},
}

newSpawnThis = {
	{name = "warrior", posX = 200, posZ = 200, facing = "s", teamName = "active", checkType = "none", gameTime = 0},
	{name = "radar", posX = 1, posZ = 1, facing = "s", teamName = "active", checkType = "none", gameTime = 0},
	{name = "solar", posX = 5000, posZ = 5000, facing = "s", teamName = "passive", checkType = "none", gameTime = 0}
}

-- misc
function NewSpawner()
    -- Spring.Echo("N.O.E. mission_spawner: mission spawner works, but its empty")
end