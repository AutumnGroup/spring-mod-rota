----- mission conditions settigns ------
----- more about: http://code.google.com/p/nota/wiki/NOE_conditions

local spGetUnitsInRectangle 		= Spring.GetUnitsInRectangle
local spGetTeamList					= Spring.GetTeamList

newCondition = {
	-- MAIN MISSION CONDITIONS --
	["kidnappedChecker"] = function(numberOfKidnapped)
		-- check if number of transports kindapped by players is big enough
		if (missionKnowledge.kiddnapedTransports >= numberOfKidnapped) then
		    return true
		else
		    return false
		end
	end,
	["killedChecker"] = function(numberOfKilled)
		-- check if number of transports kindapped by players is big enough
		if (missionKnowledge.numberOfKilledTrans >= numberOfKilled) then
		    return true
		else
		    return false
		end
	end,
	["deliveredChecker"] = function(numberOfDelivered)
		-- check if number of transports successfuly transported to AIs base is big enough
		if (missionKnowledge.transportsInBase >= numberOfDelivered) then
		    return true
		else
		    return false
		end
	end,
	
	-- AREA --
	["enemyAroundTransport"] = function(radius,enemyAllyID)
		-- DESCRIPTION --
		-- if more then enemyCountLimit enemies around transport => TRUE
		
		local thisAllyTeams 	= spGetTeamList(enemyAllyID)
		local finalCounter 		= 0
		local enemyCountLimit 	= missionInfo.safeEnemyLimitCount
		local posX				= missionKnowledge.transportPosition[1]
		local posZ				= missionKnowledge.transportPosition[2]
		
		-- count all enemy units in the area
		for i=1,#thisAllyTeams do
			local unitsInArea 	= spGetUnitsInRectangle(posX-radius,posZ-radius,posX+radius,posZ+radius,thisAllyTeams[i])
			finalCounter 		= finalCounter + #unitsInArea
		end
	
		if (finalCounter >= enemyCountLimit) then
			-- action["consoleWrite"]("Around transport is " .. finalCounter .. " players units.")
		    return true
		elseif (finalCounter < enemyCountLimit) then
			-- action["consoleWrite"]("Around transport it is clear")
		    return false
		else
			return false
		end
	end,
	["aliveTransport"] = function()
		local transportID = missionKnowledge.lastSentTransport
		if ((transportID >= 1) and (transportID <= missionInfo.transportsNumber)) then
			if (missionKnowledge.transports[transportID].alive) then
				return true
			else
				return false
			end
		else
			return false
		end
	end,
	["notAlertActive"] = function()
		if (missionKnowledge.globalCallForHelp) then
		    return false
		else
			missionKnowledge.globalCallForHelp	= true
		    return true
		end
	end,
	["alertActive"] = function()
		if (missionKnowledge.globalCallForHelp) then
		    return true
		else
		    return false
		end
	end,
	["transportAtTheEnd"] = function()
		if (missionKnowledge.transportFinished) then
			missionKnowledge.transportFinished = false
		    return true
		else
		    return false
		end
	end,
	["checkKilledTransports"] = function(killed)
		if (missionKnowledge.numberOfKilledTrans >= killed) then
		    return true
		else
		    return false
		end
	end,
	
	-- area checkers --
    ["playerInArea"] = function(numberOfArea)
		if (missionKnowledge.areasAlert[numberOfArea] >= 1) then
		    return true
		else
		    return false
		end
	end,
}