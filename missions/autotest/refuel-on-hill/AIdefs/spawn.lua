----- mission spawn list ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

-- !! not finished --
-- ! not own spawner
-- ! need add resources start setting

newSpawnDef = {
	["t_armasp"] = {unit = "armasp", class = "single"},
	["t_armfig"] = {unit = "armfig", class = "single"},
	["t_armhell"] = {unit = "armhell", class = "single"},
	["t_corevashp"] = {unit = "corevashp", class = "single"},
	["t_cormist"] = {unit = "cormist", class = "single"},
	["t_corsolar"] = {unit = "corsolar", class = "single"},
	["t_corllt"] = {unit = "corllt", class = "single"},
	["t_corfury"] = {unit = "corfury", class = "single"},
	["t_corcrash"] = {unit = "corcrash", class = "single"},
	["t_corfus"] = {unit = "corfus", class = "single"},
	["t_corestor"] = {unit = "corestor", class = "single"},
	["t_pireye"] = {unit = "pireye", class = "single"},
	["t_coreter"] = {unit = "coreter", class = "single"},
}

for id,unitDef in pairs(UnitDefs) do
	local uName = unitDef.name
	local tName	= "t_" .. uName
	newSpawnDef[tName] = {unit = uName, class = "single"}
end

newSpawnThis = {

}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_armasp", posX = 50, posZ = 100, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armasp", posX = 50, posZ = 200, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armasp", posX = 50, posZ = 300, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armasp", posX = 50, posZ = 400, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armasp", posX = 50, posZ = 500, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armasp", posX = 50, posZ = 600, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armasp", posX = 50, posZ = 700, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armasp", posX = 50, posZ = 800, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armasp", posX = 50, posZ = 900, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armasp", posX = 50, posZ = 1000, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_armfig", posX = 200, posZ = 100, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane1", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armfig", posX = 200, posZ = 200, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane2", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armhell", posX = 200, posZ = 300, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane3", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armhell", posX = 200, posZ = 400, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane4", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armhell", posX = 200, posZ = 500, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane5", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corevashp", posX = 200, posZ = 600, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane6", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corevashp", posX = 200, posZ = 700, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane7", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corevashp", posX = 200, posZ = 800, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane8", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corevashp", posX = 200, posZ = 900, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane9", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corevashp", posX = 200, posZ = 1000, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane10", gameTime = 0}

-- enemy
newSpawnThis[#newSpawnThis+1] 	= {name = "t_dca", posX = 3200, posZ = 1500, facing = "s", teamName = "Defender", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corbase", posX = 4800, posZ = 2500, facing = "s", teamName = "Defender", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsolar", posX = 3000, posZ = 1000, facing = "s", teamName = "Defender", checkType = "single", checkName="target1", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsolar", posX = 3000, posZ = 1200, facing = "s", teamName = "Defender", checkType = "single", checkName="target2", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsolar", posX = 3000, posZ = 1400, facing = "s", teamName = "Defender", checkType = "single", checkName="target3", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsolar", posX = 3000, posZ = 1600, facing = "s", teamName = "Defender", checkType = "single", checkName="target4", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsolar", posX = 3000, posZ = 1800, facing = "s", teamName = "Defender", checkType = "single", checkName="target5", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsolar", posX = 3300, posZ = 1100, facing = "s", teamName = "Defender", checkType = "single", checkName="target6", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsolar", posX = 3300, posZ = 1300, facing = "s", teamName = "Defender", checkType = "single", checkName="target7", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsolar", posX = 3300, posZ = 1500, facing = "s", teamName = "Defender", checkType = "single", checkName="target8", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsolar", posX = 3300, posZ = 1700, facing = "s", teamName = "Defender", checkType = "single", checkName="target9", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsolar", posX = 3300, posZ = 1900, facing = "s", teamName = "Defender", checkType = "single", checkName="target10", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsolar", posX = 4000, posZ = 1000, facing = "s", teamName = "Defender", checkType = "single", checkName="target11", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsolar", posX = 4000, posZ = 1200, facing = "s", teamName = "Defender", checkType = "single", checkName="target12", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsolar", posX = 4000, posZ = 1400, facing = "s", teamName = "Defender", checkType = "single", checkName="target13", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsolar", posX = 4000, posZ = 1600, facing = "s", teamName = "Defender", checkType = "single", checkName="target14", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corllt", posX = 4000, posZ = 1800, facing = "s", teamName = "Defender", checkType = "single", checkName="target15", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corllt", posX = 4500, posZ = 1100, facing = "s", teamName = "Defender", checkType = "single", checkName="target16", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsolar", posX = 4500, posZ = 1300, facing = "s", teamName = "Defender", checkType = "single", checkName="target17", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsolar", posX = 4500, posZ = 1500, facing = "s", teamName = "Defender", checkType = "single", checkName="target18", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsolar", posX = 4500, posZ = 1700, facing = "s", teamName = "Defender", checkType = "single", checkName="target19", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsolar", posX = 4500, posZ = 1900, facing = "s", teamName = "Defender", checkType = "single", checkName="target20", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_corfury", posX = 4700, posZ = 1000, facing = "s", teamName = "Defender", checkType = "single", checkName="target21", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corfury", posX = 4700, posZ = 1200, facing = "s", teamName = "Defender", checkType = "single", checkName="target22", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corfury", posX = 4700, posZ = 1400, facing = "s", teamName = "Defender", checkType = "single", checkName="target23", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsolar", posX = 4700, posZ = 1600, facing = "s", teamName = "Defender", checkType = "single", checkName="target24", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corllt", posX = 4700, posZ = 1800, facing = "s", teamName = "Defender", checkType = "single", checkName="target25", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corllt", posX = 4900, posZ = 1100, facing = "s", teamName = "Defender", checkType = "single", checkName="target26", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsolar", posX = 4900, posZ = 1300, facing = "s", teamName = "Defender", checkType = "single", checkName="target27", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsolar", posX = 4900, posZ = 1500, facing = "s", teamName = "Defender", checkType = "single", checkName="target28", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsolar", posX = 4900, posZ = 1700, facing = "s", teamName = "Defender", checkType = "single", checkName="target29", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsolar", posX = 4900, posZ = 1900, facing = "s", teamName = "Defender", checkType = "single", checkName="target30", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_pireye", posX = 8000, posZ = 8000, facing = "s", teamName = "Defender", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corfus", posX = 7500, posZ = 7500, facing = "s", teamName = "Defender", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_coreter", posX = 7700, posZ = 7700, facing = "s", teamName = "Defender", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corfus", posX = 8200, posZ = 7700, facing = "s", teamName = "Defender", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corestor", posX = 7700, posZ = 7700, facing = "s", teamName = "Defender", checkType = "none", gameTime = 0}


function NewSpawner()
    --Spring.Echo("N.O.E. mission_spawner: mission spawner works, but its empty")
end