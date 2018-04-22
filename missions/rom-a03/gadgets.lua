---------------------------------------
--- DIRECT ACCESS TO GADGET CALLINS ---
---------------------------------------

--- NOE CALLINs ---
function MissionNewUnitComming(unitID, unitDefID, unitTeam)
end

function MissionUnitLost(unitID, unitDefID, unitTeam)
end

--- SPRING GADGETS CALLINs ---
function MissionUnitIdle(unitID, unitDefID, unitTeam)
end

function MissionUnitCreated(unitID, unitDefID, unitTeam, builderID)
	local name 			= UnitDefs[unitDefID].name
	if (name == "cortruck") then
		missionKnowledge.numberOfSentTrans				= missionKnowledge.numberOfSentTrans + 1
		missionKnowledge.lastSentTransport				= missionKnowledge.lastSentTransport + 1 --- !! this will be done by some separe spirit, test only now
		local transportID								= missionKnowledge.lastSentTransport
		if ((transportID >= 1) and (transportID <= missionInfo.transportsNumber)) then
			missionKnowledge.transports[transportID].alive	= true
			missionKnowledge.transportMapPosition			= "nodA"
			-- !?here is possible scenario bug - ressurecting can fuck the counters and breake it, 
			-- but its not easy to get res. technology and for mission purpose - res is not enough to get full info from transports
		end
	end
end

function MissionUnitGiven(unitID, unitDefID, unitTeam)
end

function MissionUnitCaptured(unitID, unitDefID, unitTeam)
end

function MissionUnitFromFactory(unitID, unitDefID, unitTeam, factID, factDefID, userOrders)
end

function MissionUnitDestroyed(unitID, unitDefID, unitTeam)
	local name 			= UnitDefs[unitDefID].name
	if (name == "cortruck") then
		missionKnowledge.numberOfKilledTrans			= missionKnowledge.numberOfKilledTrans + 1
		missionKnowledge.numberOfAliveTrans				= missionKnowledge.numberOfAliveTrans - 1
		local transportID								= missionKnowledge.lastSentTransport
		if ((transportID >= 1) and (transportID <= missionInfo.transportsNumber)) then
			missionKnowledge.transports[transportID].alive			= false
			missionKnowledge.transportMapPosition					= "nodA"
			groupInfo[missionKnowledge.lastTransportGroupID].active = false
			missionKnowledge.numberOfSpawned						= missionKnowledge.numberOfSpawned + 1
			action.addSpawnOfNewTransport()
		end
	end
end

function MissionUnitTaken(unitID, unitDefID, unitTeam)
	local name 			= UnitDefs[unitDefID].name
	local currentTeam 	= "t" .. unitTeam
	local teamNumber 	= reverseAITeamID[currentTeam] or 0
	if (teamNumber ~= 0) then   -- = if (its NOE AI)
		if (name == "cortruck") then
			missionKnowledge.kiddnapedTransports				= missionKnowledge.kiddnapedTransports + 1
			local transportID									= missionKnowledge.lastSentTransport
			if ((transportID >= 1) and (transportID <= missionInfo.transportsNumber)) then
				missionKnowledge.transports[transportID].kidnapped		= true
				missionKnowledge.transportMapPosition					= "nodA"
				groupInfo[missionKnowledge.lastTransportGroupID].active = false
				action.addSpawnOfNewTransport()
			end
		end
	end
end

function MissionGameFrame(n)
end

function MissionInitialize()
end