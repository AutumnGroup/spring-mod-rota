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
end

function MissionUnitGiven(unitID, unitDefID, unitTeam)
end

function MissionUnitCaptured(unitID, unitDefID, unitTeam)
end

function MissionUnitFromFactory(unitID, unitDefID, unitTeam, factID, factDefID, userOrders)
end

function MissionUnitDestroyed(unitID, unitDefID, unitTeam)
end

function MissionUnitTaken(unitID, unitDefID, unitTeam)
end

function MissionGameFrame(n)
	if (n>0) then
		Spawner(n)
	end
	if (n == 10) then
		local units = Spring.GetAllUnits()
		for i=1, #units do
			local unitID = units[i]
			local unitDefID = Spring.GetUnitDefID(unitID)
			if (UnitDefs[unitDefID].name == "corsilo") then
				Spring.SetUnitStockpile(unitID, 5)
			end
		end
	end
end

function MissionInitialize()
end