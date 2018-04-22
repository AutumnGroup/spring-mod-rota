----- mission spawn list ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

-- !! not finished --
-- ! not own spawner
-- ! need add resources start setting

newSpawnDef = {

}

newSpawnThis = {

}

-- adit
local eggName 	= missionInfo.eggName

-- spawn type init
for id,unitDef in pairs(UnitDefs) do
	local uName 			= unitDef.name
	local tName				= "t_" .. uName
	newSpawnDef[tName] 		= {unit = uName, class = "single"}
	if (uName == eggName) then
		missionInfo["eggDefID"] = id
	end
end

-- addin bugs
local counter 	= 0
local limit		= 10
local line		= 1
local squareDist= 350

for i=1,missionInfo.numberOfBugs do
	counter 				= counter + 1
	local row				= counter % limit
	if (row == 0) then line = line + 1 end
	newSpawnThis[counter] 	= {name = "t_corgamma", posX = row*squareDist + 200, posZ = line*squareDist + 200, facing = "s", teamName = "trasporters", checkType = "none", gameTime = 0}
end

-- adding eggs
local lowX = missionInfo.activeBorder
local maxX = missionInfo.activeMapX - missionInfo.activeBorder
local lowZ = missionInfo.activeBorder
local maxZ = missionInfo.activeMapZ - missionInfo.activeBorder

for i=1,missionInfo.numberOfEggs do
	local newX 		= math.random(lowX,maxX)
	local newZ 		= math.random(lowZ,maxZ)
	local teamColor = "eggs" .. math.random(1,4)
	
	newSpawnThis[#newSpawnThis+1] 	= {name = "t_bugegg", posX = newX, posZ = newZ, facing = "s", teamName = teamColor, checkType = "none", gameTime = 0}
end

-- adding spec enemy (just technical thing)
newSpawnThis[#newSpawnThis+1] 	= {name = "t_pireye", posX = 5000, posZ = 5000, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

-- misc
function NewSpawner()
    Spring.Echo("N.O.E. mission_spawner: mission spawner works, but its empty")
end