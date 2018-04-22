----- NOE tasks - missions for groups --------
----- more about: http://code.google.com/p/nota/wiki/NOE_tasks

local lowerLimitDistanceSQ		= 250*250
local standardLimitDistanceSQ	= 300*300

newTask = {
	["TankCircuit"] = {
		pathName			= "Circuit",
		limitDistance		= standardLimitDistanceSQ,
		alertLimit			= 10,
		alertListIndexes	= {7,10,11},
		conditionNames		= {},
	},
}