----- mission spawn list ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

-- !! not finished --
-- ! not own spawner
-- ! need add resources start setting

newSpawnDef = {
	["t_armasp"] = {unit = "armasp", class = "single"},
	["t_armbrawl"] = {unit = "armbrawl", class = "single"},
	["t_cormist"] = {unit = "cormist", class = "single"},
	["t_corcrash"] = {unit = "corcrash", class = "single"},
	["t_corfus"] = {unit = "pireye", class = "single"},
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


newSpawnThis[#newSpawnThis+1] 	= {name = "t_armasp", posX = 100, posZ = 100, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armasp", posX = 100, posZ = 200, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armasp", posX = 100, posZ = 300, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armasp", posX = 100, posZ = 400, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armasp", posX = 100, posZ = 500, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armasp", posX = 100, posZ = 600, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armasp", posX = 100, posZ = 700, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armasp", posX = 100, posZ = 800, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armasp", posX = 100, posZ = 900, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armasp", posX = 100, posZ = 1000, facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_armbrawl", posX = 200, posZ = 100, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane1", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armbrawl", posX = 200, posZ = 200, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane2", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armbrawl", posX = 200, posZ = 300, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane3", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armbrawl", posX = 200, posZ = 400, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane4", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armbrawl", posX = 200, posZ = 500, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane5", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armbrawl", posX = 200, posZ = 600, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane6", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armbrawl", posX = 200, posZ = 700, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane7", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armbrawl", posX = 200, posZ = 800, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane8", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armbrawl", posX = 200, posZ = 900, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane9", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armbrawl", posX = 200, posZ = 1000, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane10", gameTime = 0}

-- enemy
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cormist", posX = 3000, posZ = 1000, facing = "s", teamName = "Defender", checkType = "single", checkName="target1", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cormist", posX = 3000, posZ = 1200, facing = "s", teamName = "Defender", checkType = "single", checkName="target2", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cormist", posX = 3000, posZ = 1400, facing = "s", teamName = "Defender", checkType = "single", checkName="target3", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cormist", posX = 3000, posZ = 1600, facing = "s", teamName = "Defender", checkType = "single", checkName="target4", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cormist", posX = 3000, posZ = 1800, facing = "s", teamName = "Defender", checkType = "single", checkName="target5", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corcrash", posX = 3300, posZ = 1100, facing = "s", teamName = "Defender", checkType = "single", checkName="target6", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corcrash", posX = 3300, posZ = 1300, facing = "s", teamName = "Defender", checkType = "single", checkName="target7", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corcrash", posX = 3300, posZ = 1500, facing = "s", teamName = "Defender", checkType = "single", checkName="target8", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corcrash", posX = 3300, posZ = 1700, facing = "s", teamName = "Defender", checkType = "single", checkName="target9", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corcrash", posX = 3300, posZ = 1900, facing = "s", teamName = "Defender", checkType = "single", checkName="target10", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_pireye", posX = 8000, posZ = 8000, facing = "s", teamName = "Defender", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corfus", posX = 7500, posZ = 7500, facing = "s", teamName = "Defender", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_coreter", posX = 7700, posZ = 7700, facing = "s", teamName = "Defender", checkType = "none", gameTime = 0}


function NewSpawner()
    --Spring.Echo("N.O.E. mission_spawner: mission spawner works, but its empty")
end