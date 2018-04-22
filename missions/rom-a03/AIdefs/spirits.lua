----- mission spirits settigns ------
----- more about: http://code.google.com/p/nota/wiki/NOE_spirits

-- math.randomseed(missionInfo.randomization)
local spEcho							= Spring.Echo
local spGiveOrderToUnit					= Spring.GiveOrderToUnit
local spGetCommandQueue					= Spring.GetCommandQueue
local spGetFactoryCommands				= Spring.GetFactoryCommands
local spGetUnitPosition					= Spring.GetUnitPosition
local spGetGroundHeight					= Spring.GetGroundHeight
local spGetUnitNearestEnemy				= Spring.GetUnitNearestEnemy
local spGetTeamList						= Spring.GetTeamList
local spGetTeamStartPosition			= Spring.GetTeamStartPosition
local spGetTeamUnitCount				= Spring.GetTeamUnitCount
local spGetUnitsInRectangle				= Spring.GetUnitsInRectangle
local spGetUnitIsBuilding				= Spring.GetUnitIsBuilding
local spGetUnitIsDead					= Spring.GetUnitIsDead
local spGetUnitStockpile				= Spring.GetUnitStockpile
local spTestBuildOrder					= Spring.TestBuildOrder

local CMD_ATTACK						= CMD.ATTACK
local CMD_GUARD							= CMD.GUARD
local CMD_LOAD_UNITS					= CMD.LOAD_UNITS
local CMD_MOVE							= CMD.MOVE
local CMD_ONOFF							= CMD.ONOFF
local CMD_PATROL						= CMD.PATROL
local CMD_REPEAT						= CMD.REPEAT
local CMD_STOP							= CMD.STOP
local CMD_STOCKPILE						= CMD.STOCKPILE
local CMD_UNLOAD_UNITS					= CMD.UNLOAD_UNITS
local CMD_AUTOMEX						= 31243

local spGetGroundHeight					= Spring.GetGroundHeight
local spGetUnitCommands					= Spring.GetUnitCommands
local spGiveOrderToUnit					= Spring.GiveOrderToUnit

newPlan = {
    ["doSimplePatrol"] = function(groupID,teamNumber,patrolMapName)
	    local thisGroup 	= groupInfo[groupID]
		--Spring.Echo(map[patrolMapName][1][1])
	end,
	["areaAirCleaner"] = function(groupID,teamNumber)
		local thisGroup = groupInfo[groupID]
		
		PrepareFirstUnit(groupID)
		-- init --
		if (groupInfo[groupID].initialization) then
			groupInfo[groupID].initialization	= false
			groupInfo[groupID].taskStatus		= "startPosition"
		end
		
		local thisGroup						= groupInfo[groupID]
		local thisTeam						= teamInfo[teamNumber]
		local thisPosX,thisPosY,thisPosZ	= GetPositionOfGroup(groupID)
		local status						= plan.operationalStatusCheck(groupID)
		-- Spring.Echo(thisGroup.name,thisGroup.taskName)
		local thisTask						= task[thisGroup.taskName]
		local returnPoint					= thisTask.pathName .. "ReturnPoint"		-- we need returnPont map
		
		-- startPosition --
		if (thisGroup.taskStatus == "startPosition") then
			local someAlert,areaID 	= condition.checkAlerts(missionKnowledge.areasAlert,thisTask.alertListIndexes,thisTask.alertLimit)
			local conditions		= condition.conjunction(thisTask.conditionNames)
			
			if (someAlert and conditions) then
				groupInfo[groupID].taskStatus = "onTask"
			end
			
		-- onTask --
		elseif (thisGroup.taskStatus == "onTask") then
			local someAlert,areaID 	= condition.checkAlerts(missionKnowledge.areasAlert,thisTask.alertListIndexes,thisTask.alertLimit)
			
			-- if (areaID ~= 0) then Spring.Echo(thisGroup.name,areaID) end
			-- if (missionKnowledge[thisTask.globalAlert]) then someAlert = true end
			
			if (not(thisGroup.target.hasAny) or (thisGroup.target.id == nil) or (thisGroup.target.id == 0)) then
				local posMinX,posMinZ,posMaxX,posMaxZ
				--- global guards init
				if (areaID == 0 or areaID == nil) then
					posMinX,posMinZ,posMaxX,posMaxZ = plan.giveArea(missionKnowledge[thisTask.centerParameter],missionKnowledge[thisTask.radiusParameter])
				--- given area guards
				else
					local areaName = "area" .. areaID
					posMinX,posMinZ,posMaxX,posMaxZ = map[areaName][1][1],map[areaName][1][2],map[areaName][2][1],map[areaName][2][2]
				end
				
				local targetID = plan.getOneTargetInArea(posMinX,posMinZ,posMaxX,posMaxZ,missionKnowledge.allyIDofPlayers)
				-- Spring.Echo(posMinX,posMinZ,posMaxX,posMaxZ,targetID)
				if (targetID ~= 0) then
					-- Spring.Echo(thisGroup.membersListCounter,targetID)
					groupInfo[groupID].target.id		= targetID
					groupInfo[groupID].target.hasAny	= true	

					local moveX,moveZ	= spGetUnitPosition(targetID)
					local moveY			= spGetGroundHeight(moveX,moveZ)
					for i=1,thisGroup.membersListMax do
						if (thisGroup.membersListAlive[i]) then
							spGiveOrderToUnit(thisGroup.membersList[i], CMD_MOVE , {moveX,moveY,moveZ}, {}) 
						end
					end						
				else
					groupInfo[groupID].taskStatus = "returning"
				end
			else
				local targetUnitID = groupInfo[groupID].target.id
				-- Spring.Echo(targetUnitID)
				local isDead       = spGetUnitIsDead(targetUnitID)
				if (not(isDead) and (isDead ~= nil)) then
					for i=1,thisGroup.membersListMax do
						if (thisGroup.membersListAlive[i]) then
							spGiveOrderToUnit(thisGroup.membersList[i], CMD_ATTACK , {targetUnitID}, {})
						end
					end
					thisGroup.fightStatus = "attacking"
				else
					thisGroup.fightStatus   = "preparingForAttack"
					thisGroup.target.hasAny = false
				end
			end
			
		-- returning --
		elseif (thisGroup.taskStatus == "returning") then
			local moveX,moveZ	= map[returnPoint][1],map[returnPoint][2]
			local moveY			= spGetGroundHeight(moveX,moveZ)
			for i=1,thisGroup.membersListMax do
				if (thisGroup.membersListAlive[i]) then
					spGiveOrderToUnit(thisGroup.membersList[i], CMD_MOVE , {moveX,moveY,moveZ}, {})
				end
			end	
			
			groupInfo[groupID].taskStatus = "startPosition"
		end
	end,
	["simpleAirTransport"] = function(groupID,teamNumber)
		local thisGroup = groupInfo[groupID]
		
		PrepareFirstUnit(groupID)
		-- init --
		if (groupInfo[groupID].initialization) then
			groupInfo[groupID].initialization	= false
			groupInfo[groupID].taskStatus		= "startPosition"
		end
		
		local thisGroup						= groupInfo[groupID]
		local thisTeam						= teamInfo[teamNumber]
		local thisPosX,thisPosY,thisPosZ	= GetPositionOfGroup(groupID)
		local status						= plan.operationalStatusCheck(groupID)
		-- Spring.Echo(thisGroup.name,thisGroup.taskName)
		local thisTask						= task[thisGroup.taskName]
		local returnPoint					= thisTask.pathName .. "ReturnPoint"		-- we need returnPont map
		local loadAreaCenter				= thisTask.pathName .. "LoadAreaCenter"
		
		-- startPosition --
		if (thisGroup.taskStatus == "startPosition") then
			local conditions		= condition.conjunction(thisTask.conditionNames)			
			if (conditions) then
				groupInfo[groupID].taskStatus = "onTask"
			end
			
		-- onTask --
		elseif (thisGroup.taskStatus == "onTask") then

			local moveX,moveZ			= map[loadAreaCenter][1],map[loadAreaCenter][2]
			local moveY					= spGetGroundHeight(moveX,moveZ)
			local unloadPosition		= missionKnowledge[thisTask.centerParameter]
			local unloadPosX,unloadPosZ = unloadPosition[1],unloadPosition[2]
			local unloadPosY			= spGetGroundHeight(unloadPosX,unloadPosZ)
			--Spring.Echo(moveX,moveY,moveZ,missionInfo[thisTask.loadPerimeter])
			--Spring.Echo(unloadPosX,unloadPosY,unloadPosZ,missionInfo[thisTask.unloadPerimeter])
			for i=1,thisGroup.membersListMax do
				if (thisGroup.membersListAlive[i]) then
					spGiveOrderToUnit(thisGroup.membersList[i], CMD_LOAD_UNITS , {moveX,moveY,moveZ,missionInfo[thisTask.loadPerimeter]}, {})
					spGiveOrderToUnit(thisGroup.membersList[i], CMD_UNLOAD_UNITS , {unloadPosX,unloadPosY,unloadPosZ,missionInfo[thisTask.unloadPerimeter]}, {"shift"})
					spGiveOrderToUnit(thisGroup.membersList[i], CMD_REPEAT , {1}, {})
				end
				groupInfo[groupID].taskStatus = "transporting"
			end
		
		-- still on task, but not new orders --
		elseif (thisGroup.taskStatus == "transporting") then
			
			local conditions = condition.conjunction(thisTask.conditionNames)	
			if (not conditions) then
				groupInfo[groupID].taskStatus = "returning"
			end
		
		-- returning --
		elseif (thisGroup.taskStatus == "returning") then
			local moveX,moveZ	= map[returnPoint][1],map[returnPoint][2]
			local moveY			= spGetGroundHeight(moveX,moveZ)
			for i=1,thisGroup.membersListMax do
				if (thisGroup.membersListAlive[i]) then
					spGiveOrderToUnit(thisGroup.membersList[i], CMD_REPEAT , {0}, {})
					spGiveOrderToUnit(thisGroup.membersList[i], CMD_MOVE , {moveX,moveY,moveZ}, {"shift"})					
				end
			end	
			
			groupInfo[groupID].taskStatus = "startPosition"
		end
	end,
}

newSpiritDef = {
	["truckBuffer"] = function(groupID,teamNumber,mode)
		local transportID = missionKnowledge.lastSentTransport
		if ((transportID >= 1) and (transportID <= missionInfo.transportsNumber)) then
			plan.bufferDirectTransfer(groupID,transportID)
		end
    end,
	["truckDefenceBuffer"] = function(groupID,targetGroupListID)
		local transportID = missionKnowledge.lastSentTransport
		if ((transportID >= 1) and (transportID <= missionInfo.transportsNumber)) then
			if (mode == "execute") then
				plan.bufferDirectTransfer(groupID,transportID)
			else
				plan.bufferCommand(groupID)
			end
		end		
	end,
	["ASBattacker"] = function(groupID,teamNumber,mode)
		--- DESCRIPTION --- 
		--- main attack group of ASIM-BASE	
		GetPositionOfGroup(groupID)
		
		if (missionKnowledge.globalRevengeStart) then
			plan.pathCleaner(groupID,teamNumber)
		end
	end,
	["ASBattackSupportLine"] = function(groupID,teamNumber,mode)
		--- DESCRIPTION --- 
		--- support line
		if (mode == "prepare") then
		    PrepareFirstUnit(groupID)
		else
			local thisTeam  	= teamInfo[teamNumber]
			local thisGroup 	= groupInfo[groupID]
			local itsLeader  	= groupInfo[thisGroup.itsLeaderID]
			if (not itsLeader.sleeping) then
				local moveX,moveZ	= itsLeader.posX,itsLeader.posZ
				local moveY			= spGetGroundHeight(moveX,moveZ)
				commands.Move.Group(groupID,moveX,moveY,moveZ,0,thisGroup.formation,waiting)
			end
		end
	end,

	["ASBdefender"] = function(groupID,teamNumber,mode)
		--- DESCRIPTION --- 
		--- ! defence group of ASIM-BASE
	
		-- use pathCleanerPlan
		plan.pathCleaner(groupID,teamNumber)
	end,
	["ASBTankAttacker"] = function(groupID,teamNumber,mode)
		--- DESCRIPTION --- 
		--- tank group of second base prepared for raiding the central area of map

		-- use pathCleanerPlan
		plan.pathCleaner(groupID,teamNumber)
	end,
	["kroggyAttacker"] = function(groupID,teamNumber,mode)
		--- DESCRIPTION --- 
		--- ! krogoth spirit
		if (missionKnowledge.globalRevengeStart) then
			plan.pathCleaner(groupID,teamNumber)
		end
	end,
	["kroggyFactory"] = function(groupID,teamNumber,mode)
		--- DESCRIPTION --- 
		--- !! build krogoths, if 3/5 storage empty, wait till more resources
		local thisTeam		= teamInfo[teamNumber]
		local thisGroup		= groupInfo[groupID]
		local factoryLimit 	= (thisTeam.metalStorage/5)*2
		if (thisTeam.metalLevel > factoryLimit) then
			if (thisGroup.membersListAlive[1]) then
			end
			-- its ok
		else
			if (thisGroup.membersListAlive[1]) then		
			end
		end
	end,
	["airborn"] = function(groupID,teamNumber,mode)
		--- DESCRIPTION --- 
		--- ! spirit for group, that is transported on place by different group of air-transports
	end,
	["airbornTransport"] = function(groupID,teamNumber,mode)
		--- DESCRIPTION --- 
		--- ! air-transport for airborne groups
		plan.simpleAirTransport(groupID,teamNumber)
	end,
	["ABgroundKiller"] = function(groupID,teamNumber,mode)
		--- DESCRIPTION --- 
		--- ! group of antiground planes - task is elimination of small forces of enemies in given sector, mostly as support for airborne units	
		if (mode == "prepare") then
		    --- nothing
		else
			plan.areaAirCleaner(groupID,teamNumber,mode)
		end
	end,
	["asistAAAcover"] = function(groupID,teamNumber,mode)
		--- DESCRIPTION --- 
		--- ! air-cover for antiground planes
		spiritDef.areaAAAcover(groupID,teamNumber,mode)
	end,
	["areaAAAcover"] = function(groupID,teamNumber,mode)
		--- DESCRIPTION --- 
		--- ! simple group commanding units guarding custom area against enemy air
		if (mode == "prepare") then
		    --- nothing
		else
			plan.areaAirPatrol(groupID,teamNumber)
		end
	end,
	["TGdefender"] = function(groupID,teamNumber,mode)
		--- DESCRIPTION --- 
		--- ! groups defending crash site
		
		-- use pathCleanerPlan
		plan.pathCleaner(groupID,teamNumber)
	end,
	["TGressurector"] = function(groupID,teamNumber,mode)
		--- DESCRIPTION --- 
		--- ! spirit of defender of transport
	end,
	["TGtransportAssister"] = function(groupID,teamNumber,mode)
		--- DESCRIPTION --- 
		--- ! spirit of defender of transport
		spiritDef.builderDefender(groupID,teamNumber,mode)		
	end,
	["specialDefence"] = function(groupID,teamNumber,mode)
		--- DESCRIPTION --- 
		--- ! spirit of defender of transport
		PrepareFirstUnit(groupID)
		local thisGroup  	= groupInfo[groupID]
		local thisTask		= task[thisGroup.taskName]
		local position		= missionKnowledge[thisTask.positionParameter]
		local moveX,moveZ	= position[1],position[2]
		local moveY			= spGetGroundHeight(moveX,moveZ)
		commands.Move.Group(groupID,moveX,moveY,moveZ,0,thisGroup.formation,waiting) 
	end,	
	["transport"] = function(groupID,teamNumber,mode)
		--- DESCRIPTION --- 
		--- ! spirit of transport
		PrepareFirstUnit(groupID)
		local thisGroup							= groupInfo[groupID]
		local thisPosX,thisPosY,thisPosZ		= GetPositionOfGroup(groupID)
		-- if (missionKnowledge.transportMapPosition ~= "nodA" and missionKnowledge.transportMapPosition ~= "nodB") then
			missionKnowledge.transportPosition		= {thisPosX,thisPosZ}
		-- end
		
		local thisTask							= task[thisGroup.taskName]
		local thisTransportID					= missionKnowledge.lastSentTransport
		missionKnowledge.lastTransportGroupID 	= groupID
		
		-- if not kidnapped and not destroyed, do something
		if ((thisTransportID <= missionInfo.transportsNumber) and not missionKnowledge.transports[thisTransportID].kidnapped and missionKnowledge.transports[thisTransportID].alive) then
		
			-- if not alert, move
			if (not missionKnowledge.globalCallForHelp) then
				local mapPosition	= missionKnowledge.transportMapPosition
				local distanceSQ 	= GetDistance2DSQ(thisPosX,thisPosZ,map[mapPosition].posX,map[mapPosition].posZ)
				
				-- compute SQ distance from next target nod, if far, go to that nod
				if (distanceSQ >= thisTask.limitDistance) then
				
					-- move order
					local moveX,moveZ						= map[mapPosition].posX,map[mapPosition].posZ
					local moveY								= spGetGroundHeight(moveX,moveZ)
					commands.Move.Group(groupID,moveX,moveY,moveZ,1,thisGroup.formation,waiting)
					
				-- else choose next nod
				else
					
					-- choose nod
					local newMapPosition 	= mapPosition
					local nextNodList		= map[mapPosition].nextNod
					if (#nextNodList == 1) then							-- if simple, so its simple
						newMapPosition = nextNodList[1] 
					elseif (#nextNodList > 1) then						-- elseif more - choose
						local decision 	= math.random()
						local dLimit	= 0
						for i=1,#nextNodList do
							dLimit		= dLimit + map[mapPosition].nextNodProb[i]
							if (decision <= dLimit) then
								newMapPosition = nextNodList[i]
								break
							end
						end
					-- else end position
					else
						Spring.Echo("Transport is in enemy base.")
						missionKnowledge.transportFinished 	= true
						groupInfo[groupID].active			= false
						return
					end
					
					-- save that nod name in missionKnowledge
					missionKnowledge.transportMapPosition	= newMapPosition
					
					-- move order
					local moveX,moveZ						= map[newMapPosition].posX,map[newMapPosition].posZ
					local moveY								= spGetGroundHeight(moveX,moveZ)
					commands.Move.Group(groupID,moveX,moveY,moveZ,1,thisGroup.formation,waiting)
				end
				
			-- else stop
			else
				if (thisGroup.membersListAlive[1]) then
					spGiveOrderToUnit(thisGroup.membersList[1], CMD.STOP, {},{})
				end
			end
		end
	end,
}