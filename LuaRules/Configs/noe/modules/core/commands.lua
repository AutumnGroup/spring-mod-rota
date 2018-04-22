local moduleInfo = {
	name 	= "commands",
	desc 	= "Commands API extension",
	author 	= "PepeAmpere",
	date 	= "2012/03/01",
	license = "notAlicense",
}

local spGiveOrderToUnit 	= Spring.GiveOrderToUnit

local CMD_ATTACK 			= CMD.ATTACK
local CMD_MOVE				= CMD.MOVE
local CMD_PATROL 			= CMD.PATROL
local CMD_STOP 				= CMD.STOP

local newCommands = {
	["Attack"] = {
		["Unit"] = function(groupID, target, memberIndex, options)
			-- groupID 		- number 			- group reference 
			-- target 		- number/3D vector 	- unitID of target OR target position
			-- memberIndex 	- number 			- (optional) member of the group, by default = 1
			-- options 		- array of strings 	- (optional) usually magic keys pressed
						
			-- fill optional arguments with default value
			memberIndex = memberIndex or 1 
			options = options or {}
			
			if (type(target) == "number") then 
				target = {target} -- convert target value to proper format if its single unit
				-- TBD add check that unit is alive to prevent error				
			end
			
			spGiveOrderToUnit(groupInfo[groupID].membersList[memberIndex], CMD_ATTACK, target, options)
			
			return true
		end,
		-- ["Group"] = function(groupID, listOfTargets)
			-- TBD
		-- end,
	},
	["Move"] = {
		["Unit"] = function(groupID, position, memberIndex, options)
			-- groupID 		- number			- group reference 
			-- position 	- 3D vector 		- position to move on
			-- memberIndex 	- number 			- (optional) member of the group, by default = 1
			-- options 		- array of strings 	- (optional) usually magic keys pressed
			
			-- fill optional arguments with default value
			memberIndex = memberIndex or 1
			options = options or {}
			
			spGiveOrderToUnit(groupInfo[groupID].membersList[memberIndex], CMD_MOVE, position, options)
			
			return true
		end,
		["Group"] = function(groupID, moveX, moveY, moveZ, pathType, formation, waiting, targetX, targetZ, overloadCmdID)
			local moveCmdID = CMD_MOVE
			if (overloadCmdID ~= nil) then moveCmdID = overloadCmdID end
			--- pathType --- !! change the numbers into strings !!
			-- 0 -- default
			-- 1 -- formation only at the end
			
			--- param preparations ---
			local thisGroup         = groupInfo[groupID]
			local thisFormationDef  = formationDef[formation]
			local membersLimit      = thisGroup.membersListMax
			local whatIsCalledHilly = thisFormationDef.hilly
			local isFirst           = true
			local flatLand          = true
			local rotation
			local thisFormationPos

			local secondaryMoveX, secondaryMoveY, secondaryMoveZ
			--- use parameter setting default formation setting
			if (waiting == nil) then  
				waiting             = thisFormationDef.constrained
			end
			--- getting position of group
			local unitPosX,unitPosY,unitPosZ = GetPositionOfGroup(groupID, membersLimit)

			--- has this unit rotable formation? ---
			if (thisFormationDef.rotable) then
			
				-- use leaders rotation
				if (thisGroup.dependant) then
					rotation	= groupInfo[thisGroup.itsLeaderID].rotation
				-- or choose own
				else
					local distance = GetDistance2D(unitPosX, unitPosZ, moveX, moveZ)
					if (targetX == nil) then
						if (distance > thisFormationDef.rotationCheckDistance) then 
							targetX            = moveX - (unitPosX - moveX)
							targetZ            = moveZ - (unitPosZ - moveZ)
							rotation           = GetRotation(moveX, moveZ, targetX, targetZ, thisFormationDef.rotations) 
							thisGroup.rotation = rotation
						else   --- keep old rotation
							rotation = thisGroup.rotation
						end
					else  --- so if target is specified
						rotation = GetRotation(moveX, moveZ, targetX, targetZ, thisFormationDef.rotations) 
						thisGroup.rotation = rotation
					end	
				end
				thisFormationPos = formationsRotated[formation][rotation]
				--spEcho(rotation)
			else
				thisFormationPos = formations[formation]
			end 
			--- end of param preparations ---
			
			for i=1, membersLimit do
				--Spring.Echo(i,formation,thisGroup.groupED)
				unitID = thisGroup.membersList[i]
				-- local scaleX = thisFormationDef.scales[1]  -- scaling in definition now 
				-- local scaleZ = thisFormationDef.scales[2]
				if (thisFormationPos[i] ~= nil) then
					--Spring.Echo(i,formation, thisFormationPos[i][1] , thisFormationPos[i][2] )
					local formationX = thisFormationPos[i][1]  ---- * scaleX
					local formationZ = thisFormationPos[i][2]  ---- * scaleZ          --- scaling added in definition now
					if (thisGroup.membersListAlive[i]) then
						--spEcho(i,thisGroup.membersListAlive[i])
						if (isFirst) then -- commanding leader of unit
						
							--- behaviour of waiting for other units, when first run fast... (dependable on formation)
							if (waiting and thisFormationDef.constrained) then 
								if (thisGroup.constrainLevel >= 1 and thisGroup.moveModeChanged) then    --- second unit of group is far a lot and is alive, then
									spGiveOrderToUnit(unitID, CMD_STOP, {}, {})
									thisGroup.constrainLevel = thisGroup.constrainLevel - 1
								else
									spGiveOrderToUnit(unitID, moveCmdID, {moveX + formationX, moveY, moveZ + formationZ}, {})
								end
							else
								spGiveOrderToUnit(unitID, moveCmdID, {moveX + formationX, moveY, moveZ + formationZ}, {})
							end
							isFirst = false

							--- setting behaviour of reamining units depening on height situation around commanding unit
							local coef = GetHillyCoeficient(unitPosX, unitPosZ)
							if (coef >= whatIsCalledHilly) then
								flatLand = false
							else
								flatLand = true
							end
						else  -- commanding remaining units
							if (flatLand and (pathType ~= 1)) then -- this means units can use better, relative formation, becouse terrian around is not hilly
								spGiveOrderToUnit(unitID, moveCmdID, {unitPosX + formationX, unitPosY, unitPosZ + formationZ}, {})
								thisGroup.moveModeChanged = true
							else
								spGiveOrderToUnit(unitID, moveCmdID, {moveX + formationX, moveY, moveZ + formationZ}, {})
								if (thisFormationDef.constrained) then
									if (thisGroup.constrainLevel <= thisFormationDef.constrainLevel) then
										thisGroup.constrainLevel = thisGroup.constrainLevel + 1
									end
								end
								thisGroup.moveModeChanged = false
							end
						end
					end -- end of unit alive
				end -- end of position exist
			end -- end of function
			
			return true
		end,
	},
	["Patrol"] = {
		["Unit"] = function(groupID, position, memberIndex, options)
			-- groupID 		- number			- group reference 
			-- position 	- 3D vector 		- position to patrol on
			-- memberIndex 	- number 			- (optional) member of the group, by default = 1
			-- options 		- array of strings 	- (optional) usually magic keys pressed
			
			-- fill optional arguments with default value
			memberIndex = memberIndex or 1
			options = options or {}
			
			spGiveOrderToUnit(groupInfo[groupID].membersList[memberIndex], CMD_PATROL, position, options)
			
			return true
		end,
		-- ["Group"] = function(groupID, listOfTargets)
			-- TBD
		-- end,
	},
}
	
-- END OF MODULE DEFINITIONS --

-- update global tables 
if (commands == nil) then commands = {} end
for k,v in pairs(newCommands) do
	if (commands[k] ~= nil) then Spring.Echo("NOTIFICATION: Attempt to rewrite global table in module [" .. moduleInfo.name ..  "] - key: " .. k) end
	commands[k] = v 
end