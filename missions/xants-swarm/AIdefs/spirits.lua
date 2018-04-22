----- mission spirits settigns ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

local spGiveOrderToUnit					= Spring.GiveOrderToUnit
local spGetUnitPosition					= Spring.GetUnitPosition

local CMD_MOVE							= CMD.MOVE

newPlan = {
	["separation"] = function(groupID,teamNumber,groupIDstring)
		local pos
        return pos
	end,	
	["alignment"] = function(groupID,teamNumber,groupIDstring)
		local pos
        return pos
	end,
	["cohesion"] = function(groupID,teamNumber,groupIDstring)
		local pos
        return pos
	end,
    ["moveAround"] = function(groupID,teamNumber)
        local thisGroup       = groupInfo[groupID]
		if (thisGroup.membersListAlive[1]) then
			local x,y,z 	= spGetUnitPosition(thisGroup.membersList[1])
			local targetX	= 5000
			local targetY	= 200
			local targetZ 	= 5000
			local distance	= GetDistance3DSQ(x,y,z,targetX,targetY,targetZ)
			if (distance > 100000) then
				Spring.MoveCtrl.Enable(thisGroup.membersList[1])
				Spring.MoveCtrl.SetVelocity(thisGroup.membersList[1],25, 10, 25)
				--spGiveOrderToUnit(thisGroup.membersList[1], CMD_MOVE, {5000,200,5000},{})
			end
		end
	end,
}

newSpiritDef = {
    ["bugSwarm"] = function(groupID,teamNumber,mode)
	    if (mode == "prepare") then
		    groupInfo[groupID].planCurrent = "moveAround"
		else  -- execute mode:	
			local currentPlan = groupInfo[groupID].planCurrent
		    plan[currentPlan](groupID,teamNumber)
		end
    end,
}