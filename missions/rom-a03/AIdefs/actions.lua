----- mission conditions settings ------
----- more about: http://code.google.com/p/nota/wiki/NOE_actions

local spGetUnitsInRectangle 		= Spring.GetUnitsInRectangle
local spGetTeamList					= Spring.GetTeamList

newAction = {
	-- OTHER ACTIONS --
	["callForTransportDefence"] = function(bool)
		-- DESCRIPTION --
		-- change the value of allert
		local transportID	= missionKnowledge.lastSentTransport
		if ((transportID >= 1) and (transportID <= missionInfo.transportsNumber)) then
			if ((not missionKnowledge.transports[transportID].usedHlp) and (missionKnowledge.transports[transportID].sent)) then
				missionKnowledge.transports[transportID].usedHlp 	= true
				missionKnowledge.numberOfUsedHelps 					= missionKnowledge.numberOfUsedHelps + 1
				missionKnowledge.globalCallTime						= realGameTime
			end
		end
		return true
	end,
	["cancelGlobalCallForHelp"] = function()
		-- DESCRIPTION --
		-- just cancel the attack
		missionKnowledge.globalCallForHelp	= false
		missionKnowledge.globalCallTime		= realGameTime
		return true
	end,
	["callForGlobalRevenge"] = function()
		missionKnowledge.globalRevengeStart = true
		return true
	end,
	["spawnNewTransport"] = function(spawnTime)
		-- DESCRIPTION --
		-- just cancel the attack
		Spawner(spawnTime)
		return true
	end,
	["addSpawnOfNewTransport"] = function()
		-- DESCRIPTION --
		-- just cancel the attack
		local realTime 			= 3600*realGameTime[1] + 60*realGameTime[2] + realGameTime[3]
		local newFrameTime		= realTime*30 + missionInfo.spawnStep
		if (missionKnowledge.numberOfSpawned < missionInfo.transportsNumber) then
			spawnThis[#spawnThis+1] = {name = "t-cortruck", posX = 7519, posZ = 461, facing = "s", teamName = "transport-guards", checkType = "none", gameTime = newFrameTime}
			local classicTime 		= TimeCounter(newFrameTime)
			events[#events+1] 		= {
				repeating			= false,						active			= true,								slow	= false,
				conditionsNames		= {"time"},						actionsNames	= {"spawnNewTransport"},
				conditionsParams	= {{classicTime}},				actionsParams	= {{newFrameTime}},
			}
			--Spring.Echo(classicTime[1],classicTime[2],classicTime[3],realTime*30,newFrameTime)
		end
		return true
	end,
	["activateKroggyBuffer"] = function()
		-- DESCRIPTION --
		-- just activate kroggy lab
		for i=1,#groupInfo do
			if (groupInfo[i].name == "ASBKroggyBuffer") then
				groupInfo[i].membersListMax = 1
				return true
			end
		end
		return false
	end,
	

	
    ["setTheAreaAlert"] = function(areaNumber,thisAllyID)
		-- DESCRIPTION --
		-- save amount of enemy units in areaAlert missionKnowledge table
		
		local thisAllyTeams = spGetTeamList(thisAllyID)
		local finalCounter	= 0
		local areaName		= "area" .. areaNumber
		local thisArea 		= map[areaName]
		
		-- count all enemy units in the area
		for i=1,#thisAllyTeams do
			local unitsInArea 	= spGetUnitsInRectangle(thisArea[1][1],thisArea[1][2],thisArea[2][1],thisArea[2][2],thisAllyTeams[i])
			finalCounter 		= finalCounter + #unitsInArea
		end

		if (finalCounter >= 1) then
			-- this is executed only when more then one enemies IN
			missionKnowledge.areasAlert[areaNumber] = finalCounter
			-- action["consoleWrite"]("In " .. areaName .. " is " .. finalCounter .. " players units.")
		    return true
		elseif (finalCounter == 0) then
			-- this is executed only when friendly units IN
			missionKnowledge.areasAlert[areaNumber] = 0
			-- action["consoleWrite"]("" .. areaName .. " is clear.")
		    return true
		else
			return false
		end
	end,
}