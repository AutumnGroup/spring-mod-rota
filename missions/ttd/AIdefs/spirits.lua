----- mission spirits settigns ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

gameSpawnCounter = 0
randominator     = math.random(Spring.GetModOptions().mo_maxburrows)
missionEnd       = false
missionStep      = 25

spawnPlaces      = {
    {1633,3133},
	{5143,1072},
	{9612,2388},
	{10923,6791},
	{9028,10887},
	{4747,11080},
	{1400,7764},
}

spawnNames       = {
    "peeweeGang",
	"hammerGang",
	"rockoGang",
	"peeweeGang",
	"hammerGang",
}

newPlan = {
    ["simpleAttack"] = function(groupID,teamNumber)
	    local thisGroup = groupInfo[groupID]
	    local targetX = 6100
		local targetZ = 5500
	    commands.Move.Group(groupID,targetX,0,targetZ,0,thisGroup.formation,waiting,targetX,targetZ)
	end,
}

function GameEnd(result)
    if (result == "won") then
	    for _, u in ipairs(Spring.GetTeamUnits(teamNames["nastyAttacker"])) do
			Spring.DestroyUnit(u, true)
		end
		--- Spring.Echo("Defending team won!")
	else
	    for _, u in ipairs(Spring.GetAllUnits()) do
			if(not Spring.AreTeamsAllied(Spring.GetUnitTeam(u), teamNames["nastyAttacker"])) then
				Spring.DestroyUnit(u, true)
			end
		end
		--- Spring.Echo("Defending team lost the game!")
	end
end

newSpiritDef = {
    ["angryRaid"] = function(groupID,teamNumber,mode)
	    if (mode == "prepare") then
		    local thisGroup       = groupInfo[groupID]
		    thisGroup.planCurrent = "simpleAttack"
		else  -- execute mode:
		    local thisGroup       = groupInfo[groupID]
		    plan[thisGroup.planCurrent](groupID,teamNumber)
		end
    end,
	["spawnLeader"] = function(groupID,teamNumber,mode)
	    if (mode == "prepare") then
		    local thisGroup  = groupInfo[groupID]
			gameSpawnCounter = gameSpawnCounter + 1
			if (gameSpawnCounter >= missionInfo.endGameTime/2) then
			    if (gameSpawnCounter >= (missionInfo.endGameTime/3)*4) then
					missionStep = 20
				else
					missionStep = 15
				end
			end
			if (gameSpawnCounter >= missionInfo.endGameTime) then
			    GameEnd("won")
			end
			-- in standard way: code above should be in conditions library
			if (not(unitsUnderGreatEyeNameToID["keyEnergy"].isAlive)) then
			    GameEnd("loose") 
			end
		else  -- execute mode:
		    local thisGroup  = groupInfo[groupID]
			-- Spring.Echo(gameSpawnCounter)
			if (gameSpawnCounter <= missionInfo.endGameTime) then
				if (gameSpawnCounter % 5 == 0) then
					local wasWave = Spawner(gameSpawnCounter)
					if (wasWave) then
						local spawnGroupName    = spawnNames[(randominator % 5) +1]
						local spawnPosition     = (math.random(randominator) % 7) + 1 --GiveMeRandomSpanwnPos()
						spawnThis[#spawnThis+1] = {name = spawnGroupName, posX = spawnPlaces[spawnPosition][1], posZ = spawnPlaces[spawnPosition][2], facing = "n", teamName = "nastyAttacker", checkType = "none", gameTime = gameSpawnCounter + missionStep}
						if (gameSpawnCounter % 100 <= 10) then
						    spawnThis[#spawnThis+1] = {name = "peeweeGang", posX = spawnPlaces[spawnPosition][1]+20, posZ = spawnPlaces[spawnPosition][2]-13, facing = "n", teamName = "nastyAttacker", checkType = "none", gameTime = gameSpawnCounter + missionStep}
						    spawnThis[#spawnThis+1] = {name = spawnGroupName, posX = spawnPlaces[spawnPosition][1]-50, posZ = spawnPlaces[spawnPosition][2]+10, facing = "n", teamName = "nastyAttacker", checkType = "none", gameTime = gameSpawnCounter + missionStep}
							if (missionStep == 15) then
								spawnThis[#spawnThis+1] = {name = "bulldogGang", posX = spawnPlaces[spawnPosition][1]+19, posZ = spawnPlaces[spawnPosition][2]+35, facing = "n", teamName = "nastyAttacker", checkType = "none", gameTime = gameSpawnCounter + missionStep}
								spawnThis[#spawnThis+1] = {name = "bulldogGang", posX = spawnPlaces[spawnPosition][1]-40, posZ = spawnPlaces[spawnPosition][2]-58, facing = "n", teamName = "nastyAttacker", checkType = "none", gameTime = gameSpawnCounter + missionStep}
							end
							if (missionStep == 20) then
								spawnThis[#spawnThis+1] = {name = "bulldogGang", posX = spawnPlaces[spawnPosition][1]-17, posZ = spawnPlaces[spawnPosition][2]+55, facing = "n", teamName = "nastyAttacker", checkType = "none", gameTime = gameSpawnCounter + missionStep}
							end
						end
						randominator = randominator + 1
					end
				end
			else
			    missionEnd = true
			end
		end
    end,
}