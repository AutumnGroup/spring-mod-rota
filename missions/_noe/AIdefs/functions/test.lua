function AreEnemyAround(groupID, distance)
	local firstUnit = groupInfo[groupID].membersList[1]
	
	if (firstUnit ~= nil) then
		local unitID = Spring.GetUnitNearestEnemy(firstUnit, distance)

		if (unitID ~= nil) then
			return true
		else
			return false
		end
	else
		return false
	end
end


function GetEnemyPosition(groupID)
	local firstUnit = groupInfo[groupID].membersList[1]
	
	if (firstUnit ~= nil) then
		local unitID = Spring.GetUnitNearestEnemy(firstUnit, distance)

		if (unitID ~= nil) then
			return Spring.GetUnitPosition(Spring.GetUnitNearestEnemy(firstUnit, 2000))
		else
			return nil
		end
	else
		return nil
	end
end

function Move(groupID,moveX,moveY,moveZ)
	Spring.GiveOrderToUnit(groupInfo[groupID].membersList[1], CMD.MOVE, {moveX, moveY, moveZ}, {})
end