----- mission spirits settigns ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

local spGetUnitPosition	= Spring.GetUnitPosition

newPlan = {
    ["bombFacility"] = function(groupID, teamNumber)
		local myName = unitsUnderGreatEyeIDtoName[groupInfo[groupID].membersList[1]]
		local numberOfAttacker = string.sub(myName, 6)
		local targetName = "target" .. numberOfAttacker
		local x, y, z = spGetUnitPosition(unitsUnderGreatEyeNameToID[targetName].id)
		commands.Attack.Unit(groupID, {x, y, z})
		
		-- commands.Attack.Unit(groupID, unitsUnderGreatEyeNameToID[targetName].id)
		return true
	end,
	["wait"] = function(groupID, teamNumber)
        return true
	end,
}

newSpiritDef = {
    ["bomber"] = function(groupID, teamNumber, mode)
	    if (mode == "prepare") then
		    return -- do nothing
		else  -- execute mode:
		    local thisGroup = groupInfo[groupID]
			local isAttacking = blackboard.Get(groupID, "isAttacking")
		    if (isAttacking) then
				plan.wait(groupID, teamNumber)
			else
				plan.bombFacility(groupID, teamNumber)
				blackboard.Set(groupID, "isAttacking", true)
			end
		end
    end,
}