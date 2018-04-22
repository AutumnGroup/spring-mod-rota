----- mission spirits settigns ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

local spGiveOrderToUnit					= Spring.GiveOrderToUnit
local spGetGroundHeight					= Spring.GetGroundHeight
local spGetUnitDefID 					= Spring.GetUnitDefID
local spGetUnitIsTransporting 			= Spring.GetUnitIsTransporting
local spGetUnitPosition					= Spring.GetUnitPosition
local spGetUnitTransporter 				= Spring.GetUnitTransporter
local spGetUnitsInSphere 				= Spring.GetUnitsInSphere
local spGetUnitTeam						= Spring.GetUnitTeam

local CMD_MOVE							= CMD.MOVE
local CMD_LOAD_UNITS					= CMD.LOAD_UNITS
local CMD_UNLOAD_UNITS					= CMD.UNLOAD_UNITS
local random							= math.random

local sensorSQ							= missionInfo.bugSensorLenght*missionInfo.bugSensorLenght

newPlan = {
	["nextSpot"] = function(groupID,teamNumber,groupIDstring)
		local pos = random(1,spotsCount)
        return pos
	end,
	["normalization"] = function(scanResult)
		local sum = 0
		local newResult = {}
		for i=1,4 do
			sum = sum + scanResult[i]
		end
		for i=1,4 do
			newResult[i] = scanResult[i] / sum
		end
		return newResult[1],newResult[2],newResult[3],newResult[4]
	end,
    ["scanUpdate"] = function(groupIDstring,x,y,z)
		local units 			= spGetUnitsInSphere(x,y,z,missionInfo.bugSensorLenght)
		local newUnits			= {}
		local newUnitsCounter	= 0
		
		-- kill all non-egg units from list
		for i=1,#units do
			if (spGetUnitDefID(units[i]) == missionInfo.eggDefID) then
				newUnitsCounter 			= newUnitsCounter + 1
				newUnits[newUnitsCounter] 	= units[i]
			end
		end
		
		-- add IDs and colors of all units, which are not yet in memory
		for i=1,newUnitsCounter do
			local isNotHere = true
			for mem=1,missionInfo.memorySize do
				if (bug[groupIDstring].idMem[mem] == newUnits[i]) then
					isNotHere = false
					break
				end
			end
			
			if (isNotHere) then
				local lastID 	= bug[groupIDstring].lastID
				local color 	= spGetUnitTeam(newUnits[i])
				bug[groupIDstring].idMem[lastID] 	= newUnits[i]
				bug[groupIDstring].colorMem[lastID] = color
				lastID = lastID + 1
				if (lastID > missionInfo.memorySize ) then lastID = 1 end
				bug[groupIDstring].lastID = lastID
			end
		end
		
		-- calculate colors score
		local lastID 	= bug[groupIDstring].lastID
		local thisColorMemory 	= bug[groupIDstring].colorMem
		local colorCounter		= {0,0,0,0}
		local measureIndex		= 0
		local measureIndexName	= missionInfo.scoreType
		for i=(missionInfo.memorySize + lastID - 1),1,-1 do
			measureIndex 	= measureIndex + 1
			local newScore 	= memWeight[measureIndexName][measureIndex]
			local realIndex = (i % missionInfo.memorySize) + 1
			
			-- add new score to color, which lay in chooen memory spot (realIndex-ed)
			if (thisColorMemory[realIndex] ~= 0) then				
				local thisColor = eggTeamIDtoColor[thisColorMemory[realIndex]]
				colorCounter[thisColor] = colorCounter[thisColor] + newScore			
			end
			
			if (measureIndex == missionInfo.memorySize) then
				break
			end
		end
		
		-- save colors score
		bug[groupIDstring].colorsScore = colorCounter
		return colorCounter
		
		-- TESTING --
		-- if (groupIDstring == "2") then
			-- for i=1,missionInfo.memorySize do
				-- Spring.Echo(thisColorMemory[i])
			-- end
		-- end
		
		-- TESTING 2 --
		-- if (groupIDstring == "2") then
			-- local soTheScore = bug[groupIDstring].colorsScore
			-- Spring.Echo(soTheScore[1],soTheScore[2],soTheScore[3],soTheScore[4])
		-- end
		
		-- if (groupIDstring == "2") then
			-- Spring.Echo(realIndex,measureIndex,thisColorMemory[realIndex],eggTeamIDtoColor[thisColorMemory[realIndex]])
		-- end
	end,
	["lust"] = function(flightLength,maxLength)
		local try = random(1,maxLength)
		if (try < flightLength) then 
			return true
		else
			return false
		end
	end,	
	["scanEvalLoad"] = function(groupIDstring,scanResult,eggColor)
		-- normalization
		local newScanResult = {}
		newScanResult[1],newScanResult[2],newScanResult[3],newScanResult[4] = plan.normalization(scanResult)
		
		if (newScanResult[eggColor] > 0.66) then
			return false
		else
			return true
		end
	end,	
	["scanEvalUnload"] = function(groupIDstring,scanResult,eggColor)
		-- many ways, i choose one
		
		-- normalization
		local newScanResult = {}
		newScanResult[1],newScanResult[2],newScanResult[3],newScanResult[4] = plan.normalization(scanResult)
		
		local someIdea = random()
		
		-- negativni podminka
		for i=1,4 do
			if (i ~= eggColor) then
				if (newScanResult[i] > 0.20) then
					return false
				end
			end
		end		
		
		-- pozitivni podminka
		-- if (newScanResult[i] > 0.6 and someIdea > 0.5) then
		if (newScanResult[eggColor] > someIdea + 0.33) then
			return true
		else
			return false
		end
	end,
}

newSpiritDef = {
    ["bugTransporter"] = function(groupID,teamNumber,mode)
		local groupIDstring = tostring(groupID)
		
		if (mode == "prepare") then
			if (groupInfo[groupID].initialization) then
				groupInfo[groupID].initialization	= false
				groupInfo[groupID].taskStatus = "needNewSpot"
				newBug(groupIDstring)
				-- Spring.Echo("added " .. groupID)
			end
		else
			local thisGroup     = groupInfo[groupID]
			-- if (groupID == 2 or groupID == 5) then
				-- Spring.Echo(groupInfo[groupID].taskStatus,bug[groupIDstring].idleFlight)
			-- end
			
			-- if no spot, add it
			if (groupInfo[groupID].taskStatus == "needNewSpot") then
				bug[groupIDstring].spot 		= plan.nextSpot(groupID,teamNumber,groupIDstring)
				groupInfo[groupID].taskStatus 	= "move"
			end
			
			if (thisGroup.membersListAlive[1]) then
				-- new pos
				local x,y,z 	= spGetUnitPosition(thisGroup.membersList[1])
				-- scan update
				local scanResult = plan.scanUpdate(groupIDstring,x,y,z)
				-- evaluation not here, but only if loaded (go down)
				local maybeEgg	= spGetUnitIsTransporting(thisGroup.membersList[1])
				
				-- if loading
				if (groupInfo[groupID].taskStatus == "loading") then
					if (maybeEgg[1]) then
						groupInfo[groupID].taskStatus = "needNewSpot"
						bug[groupIDstring].idleFlight = 0
						return
					else
						if (spGetUnitTransporter(bug[groupIDstring].likeToLoad)) then
							-- stealers!
							groupInfo[groupID].taskStatus = "searching"
						else
							if (bug[groupIDstring].idleFlight <= 0) then
								groupInfo[groupID].taskStatus = "needNewSpot"
								bug[groupIDstring].idleFlight = 0
							else
								bug[groupIDstring].idleFlight = bug[groupIDstring].idleFlight - 2
							-- stay in loading status
							end
						end
					end
				end
				
				-- if unloading
				if (groupInfo[groupID].taskStatus == "unloading") then
					if (maybeEgg[1]) then
						-- stay in unloading status
					else
						groupInfo[groupID].taskStatus = "needNewSpot"
						return
					end
				end
				
				-- if fly, empty or not?
				if (groupInfo[groupID].taskStatus == "move") then
					if (maybeEgg[1]) then
						groupInfo[groupID].taskStatus = "transporting"
					else
						groupInfo[groupID].taskStatus = "searching"
					end
				end
				
				-- if empty, check if you want load
				if (groupInfo[groupID].taskStatus == "searching" and (realGameTime[3] > 5)) then
					bug[groupIDstring].idleFlight = bug[groupIDstring].idleFlight + 1
					local wantLoadSomething = plan.lust(bug[groupIDstring].idleFlight,missionInfo.lust)
					if (wantLoadSomething) then
						local eggsAround = spGetUnitsInSphere(x,y,z,3*missionInfo.bugSensorLenght)
						if (eggsAround[1]) then
							for i=1,#eggsAround do
								if (spGetUnitDefID(eggsAround[i]) == missionInfo.eggDefID) then
									local eggColor 	= eggTeamIDtoColor[spGetUnitTeam(eggsAround[i])]
									local wantLoad 	= plan.scanEvalLoad(groupIDstring,scanResult,eggColor)
									if (wantLoad and not spGetUnitTransporter(eggsAround[i])) then
										spGiveOrderToUnit(thisGroup.membersList[1], CMD_LOAD_UNITS, {eggsAround[i]}, {})
										bug[groupIDstring].likeToLoad = eggsAround[i]
										groupInfo[groupID].taskStatus = "loading"
										break
									end
								end
							end
						end
					end
				end
				
				-- if loaded, look around, if its good time to unload it
				if (groupInfo[groupID].taskStatus == "transporting") then
					-- scan evaluation
					local eggID 		= spGetUnitIsTransporting(thisGroup.membersList[1])
					if (eggID[1]) then
						local eggColor 		= eggTeamIDtoColor[spGetUnitTeam(eggID[1])]
						local wantUnload 	= plan.scanEvalUnload(groupIDstring,scanResult,eggColor)
						if (wantUnload and IsFarFromEdge(x,z,missionInfo.bugSensorLenght +50)) then
							spGiveOrderToUnit(thisGroup.membersList[1], CMD_UNLOAD_UNITS, {x,y,z,missionInfo.bugSensorLenght}, {})
							groupInfo[groupID].taskStatus = "unloading"
						end
					end
				end
				
				-- if not loading or unloading, move
				if (groupInfo[groupID].taskStatus ~= "unloading" and groupInfo[groupID].taskStatus ~= "loading") then
					local newX 		= spot[bug[groupIDstring].spot][1]
					local newZ 		= spot[bug[groupIDstring].spot][2]
					local distSQ 	= GetDistance2DSQ(x,z,newX,newZ)
					if (distSQ > sensorSQ ) then
						local newY = spGetGroundHeight(newX,newZ)
						spGiveOrderToUnit(thisGroup.membersList[1], CMD.MOVE, {newX, newY, newZ}, {})
					else
						groupInfo[groupID].taskStatus = "needNewSpot"
					end
				end	
			end
		end
		
    end,
}