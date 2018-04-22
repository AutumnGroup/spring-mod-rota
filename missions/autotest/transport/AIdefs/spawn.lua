----- mission spawn list ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

-- !! not finished --
-- ! not own spawner
-- ! need add resources start setting

newSpawnDef = {
	["t_armatlas"] = {unit = "armatlas", class = "single"},
	["t_corbrik"] = {unit = "corbrik", class = "single"},
	["t_cmercdrag"] = {unit = "cmercdrag", class = "single"},
	["t_corbtrans"] = {unit = "corbtrans", class = "single"},
	["t_corvalk"] = {unit = "corvalk", class = "single"},
	["t_corvalkii"] = {unit = "corvalkii", class = "single"},
	["t_coraat"] = {unit = "coraat", class = "single"},
	["t_armthovr"] = {unit = "armthovr", class = "single"},
	["t_corthovr"] = {unit = "corthovr", class = "single"},
	
	-- something to transport
	["t_armzeus"] = {unit = "armzeus", class = "single"},

	-- just something which survivies anything :)
	["t_corfus_oneHit"] = {unit = "corfus", class = "single", initHealthMult = 0.01},
	["t_pireye"] = {unit = "pireye", class = "single"},
	["t_coreter"] = {unit = "coreter", class = "single"},
}

newSpawnThis = {

}

-- transported
local transportableIndex = 1
for i=1, 10 do
	newSpawnThis[#newSpawnThis+1] 	= {name = "t_armzeus", posX = 5000 + i*10, posZ = 500 + i*60, facing = "s", teamName = "Attacker", checkType = "none", checkType = "single", checkName = "transportable" .. transportableIndex, gameTime = 0}
	transportableIndex = transportableIndex + 1
end
for i=1, 5 do
	for j=1, 10 do
		newSpawnThis[#newSpawnThis+1] 	= {name = "t_armzeus", posX = 4880 + i*10 + j*2, posZ = 1000 + i*200 + j*2, facing = "s", teamName = "Attacker", checkType = "none", checkType = "single", checkName = "transportable" .. transportableIndex, gameTime = 0}
		transportableIndex = transportableIndex + 1
	end
end

-- trasporters
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armatlas", posX = 5000, posZ = 500, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armatlas", posX = 4980, posZ = 500, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armatlas", posX = 4960, posZ = 500, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armatlas", posX = 4940, posZ = 500, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armatlas", posX = 4920, posZ = 500, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corbrik", posX = 5000, posZ = 700, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corbrik", posX = 4980, posZ = 700, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corbrik", posX = 4960, posZ = 700, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corbrik", posX = 4940, posZ = 700, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corbrik", posX = 4920, posZ = 700, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cmercdrag", posX = 5000, posZ = 900, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corbtrans", posX = 5500, posZ = 500, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corvalk", posX = 5500, posZ = 700, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corvalkii", posX = 5500, posZ = 900, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_coraat", posX = 4500, posZ = 1000, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armthovr", posX = 4500, posZ = 1200, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corthovr", posX = 4500, posZ = 1400, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}

-- enemy
newSpawnThis[#newSpawnThis+1] 	= {name = "t_pireye", posX = 16000, posZ = 16000, facing = "s", teamName = "Defender", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corfus_oneHit", posX = 15000, posZ = 15000, facing = "s", teamName = "Defender", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_coreter", posX = 15800, posZ = 15800, facing = "s", teamName = "Defender", checkType = "none", gameTime = 0}


function NewSpawner()
    --Spring.Echo("N.O.E. mission_spawner: mission spawner works, but its empty")
end