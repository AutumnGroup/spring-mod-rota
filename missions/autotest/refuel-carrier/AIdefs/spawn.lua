----- mission spawn list ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

-- !! not finished --
-- ! not own spawner
-- ! need add resources start setting

newSpawnDef = {
	["t_armcarry"] = {unit = "armcarry", class = "single"},
	["t_corcarry"] = {unit = "corcarry", class = "single"},
	["t_armthund"] = {unit = "armthund", class = "single"},
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

newSpawnThis[#newSpawnThis+1] 	= {name = "t_armcarry", posX = map["carrierPositions"][1][1], posZ = map["carrierPositions"][1][3], facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corcarry", posX = map["carrierPositions"][2][1], posZ = map["carrierPositions"][2][3], facing = "s", teamName = "Attacker", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_armthund", posX = 200, posZ = 100, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane1", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armthund", posX = 200, posZ = 200, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane2", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armthund", posX = 200, posZ = 300, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane3", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armthund", posX = 200, posZ = 400, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane4", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armthund", posX = 200, posZ = 500, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane5", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armthund", posX = 200, posZ = 600, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane6", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armthund", posX = 200, posZ = 700, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane7", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armthund", posX = 200, posZ = 800, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane8", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armthund", posX = 200, posZ = 900, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane9", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armthund", posX = 200, posZ = 1000, facing = "s", teamName = "Attacker", checkType = "single", checkName="plane10", gameTime = 0}

-- enemy
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corfus_oneHit", posX = 4500, posZ = 5500, facing = "s", teamName = "Defender", checkType = "single", checkName="target1", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corfus_oneHit", posX = 4750, posZ = 5000, facing = "s", teamName = "Defender", checkType = "single", checkName="target2", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corfus_oneHit", posX = 5000, posZ = 6500, facing = "s", teamName = "Defender", checkType = "single", checkName="target3", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corfus_oneHit", posX = 5250, posZ = 5600, facing = "s", teamName = "Defender", checkType = "single", checkName="target4", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corfus_oneHit", posX = 5500, posZ = 4900, facing = "s", teamName = "Defender", checkType = "single", checkName="target5", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corfus_oneHit", posX = 5750, posZ = 6400, facing = "s", teamName = "Defender", checkType = "single", checkName="target6", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corfus_oneHit", posX = 6000, posZ = 5400, facing = "s", teamName = "Defender", checkType = "single", checkName="target7", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corfus_oneHit", posX = 6250, posZ = 7200, facing = "s", teamName = "Defender", checkType = "single", checkName="target8", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corfus_oneHit", posX = 6500, posZ = 8000, facing = "s", teamName = "Defender", checkType = "single", checkName="target9", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corfus_oneHit", posX = 6750, posZ = 5900, facing = "s", teamName = "Defender", checkType = "single", checkName="target10", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_pireye", posX = 8000, posZ = 8000, facing = "s", teamName = "Defender", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corfus_oneHit", posX = 7500, posZ = 7500, facing = "s", teamName = "Defender", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_coreter", posX = 7700, posZ = 7700, facing = "s", teamName = "Defender", checkType = "none", gameTime = 0}


function NewSpawner()
    --Spring.Echo("N.O.E. mission_spawner: mission spawner works, but its empty")
end