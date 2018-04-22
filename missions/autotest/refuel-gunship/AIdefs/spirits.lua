----- mission spirits settigns ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

local spGetUnitPosition	= Spring.GetUnitPosition

newPlan = {
	["patrolAttack"] = function(groupID, teamNumber)
		commands.Move.Unit(groupID, map["patrolPositions"][1])
		commands.Patrol.Unit(groupID, map["patrolPositions"][2], 1, {"shift"})

		return true
	end,
	["wait"] = function(groupID, teamNumber)
        return true
	end,
}

newSpiritDef = {
    ["gunship"] = function(groupID, teamNumber, mode)
	    if (mode == "prepare") then
		    return -- do nothing
		else  -- execute mode:
		    local thisGroup = groupInfo[groupID]
			local isAttacking = blackboard.Get(groupID, "isAttacking")
		    if (isAttacking) then
				plan.wait(groupID, teamNumber)
			else
				plan.patrolAttack(groupID, teamNumber)
				blackboard.Set(groupID, "isAttacking", true)
			end
		end
    end,
}