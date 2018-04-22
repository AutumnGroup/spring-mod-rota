----- mission spawn list ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

-- !! not finished --
-- ! not own spawner
-- ! need add resources start setting

newSpawnDef = {
	["t_armcarry"] = {unit = "armcarry", class = "single"},
	["t_corcarry"] = {unit = "corcarry", class = "single"},
	
	["t_armexcal2"] = {unit = "armexcal2", class = "single"},
	
	["t_armasp"] = {unit = "armasp", class = "single"},
	["t_armrad"] = {unit = "armrad", class = "single"},
	
	["lancet"] = {unit = "armlance", class = "single"},
	["titan"] = {unit = "cortitan", class = "single"},
	["t_armseap"] = {unit = "armseap", class = "single"},
	["t_corseap"] = {unit = "corseap", class = "single"},

	-- just something which survivies anything :)
	["t_corfus_oneHit"] = {unit = "corfus", class = "single", initHealthMult = 0.01},
	["t_pireye"] = {unit = "pireye", class = "single"},
	["t_coreter"] = {unit = "coreter", class = "single"},
}

newSpawnThis = {

}

-- for id,unitDef in pairs(UnitDefs) do
	-- local uName 			= unitDef.name
	-- local tName				= "t_" .. uName
	-- newSpawnDef[tName] 		= {unit = uName, class = "single"}
-- end

for i=1, 10 do
	newSpawnThis[#newSpawnThis+1] 	= {name = "t_armasp", posX = 100, posZ = i*60, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
end
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armrad", posX = 2000, posZ = 2000, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armrad", posX = 8000, posZ = 2000, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armrad", posX = 2000, posZ = 8000, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armrad", posX = 100, posZ = 4000, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_armcarry", posX = map["shipsPositions"][1][1], posZ = map["shipsPositions"][1][3], facing = "s", teamName = "Defender", checkType = "single", checkName = "target1", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corcarry", posX = map["shipsPositions"][2][1], posZ = map["shipsPositions"][2][3], facing = "s", teamName = "Defender", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_armexcal2", posX = map["shipsPositions"][1][1], posZ = map["shipsPositions"][1][3]-1000, facing = "e", teamName = "Defender", checkType = "none", gameTime = 0}


local types = {
	"lancet",
	"titan",
	"t_armseap",
	"t_corseap",
}

-- spawn 4x10 planes
for typeIndex = 1, 4 do
	local thisType = types[typeIndex]
	local positionBaseX = typeIndex*200
	local positionBaseZ = 100
	
	for p = 1, 10 do		
		newSpawnThis[#newSpawnThis+1] = {name = thisType, posX = positionBaseX + p*300, posZ = positionBaseZ * p, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane" .. typeIndex .. p, gameTime = 0}
	end
end

-- enemy
newSpawnThis[#newSpawnThis+1] 	= {name = "t_pireye", posX = 8000, posZ = 8000, facing = "s", teamName = "Defender", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corfus_oneHit", posX = 7500, posZ = 7500, facing = "s", teamName = "Defender", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_coreter", posX = 7700, posZ = 7700, facing = "s", teamName = "Defender", checkType = "none", gameTime = 0}


function NewSpawner()
    --Spring.Echo("N.O.E. mission_spawner: mission spawner works, but its empty")
end