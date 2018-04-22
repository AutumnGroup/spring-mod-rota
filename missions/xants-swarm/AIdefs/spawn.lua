----- mission spawn list ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

-- !! not finished --
-- ! not own spawner
-- ! need add resources start setting

newSpawnDef = {

}

newSpawnThis = {

}

local counter 	= 0
local limit		= 10
local line		= 1
local squareDist= 30

for id,unitDef in pairs(UnitDefs) do
	local uName 			= unitDef.name
	local tName				= "t_" .. uName
	newSpawnDef[tName] 		= {unit = uName, class = "single"}
	if (uName == "corgamma2") then
		for i=1,100 do
			counter 				= counter + 1
			local row				= counter % limit
			if (row == 0) then line = line + 1 end
			newSpawnThis[counter] 	= {name = tName, posX = row*squareDist + 200, posZ = line*squareDist + 200, facing = "s", teamName = "defaultMissionAI", checkType = "none", gameTime = 0}
		end
	end
end

newSpawnThis[counter+1] 	= {name = "t_dca", posX = 8000, posZ = 8000, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}


function NewSpawner()
    Spring.Echo("N.O.E. mission_spawner: mission spawner works, but its empty")
end