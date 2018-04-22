-- resources constants
local moduleInfo = {
	name 	= "resourcesConstants",
	desc	= "Constants specific for resources module",
	author 	= "PepeAmpere",
	date 	= "2015/12/27",
	license = "notAlicense",
}

newConstants = {
	-- resources simulation
	["RESOURCES"] = {
		["TEAM_RES_UPDATE_FREQUENCY"] = 6, -- 6x per second
		["UNIT_RES_UPDATE_FREQUENCY"] = 1, -- 1x per second
	},
}

-- END OF MODULE DEFINITIONS --

-- update global tables 
if (constants == nil) then constants = {} end
for k,v in pairs(newConstants) do
	if (constants[k] ~= nil) then Spring.Echo("NOTIFICATION: Attempt to rewrite global table in module [" .. moduleInfo.name ..  "] - key: " .. k) end
	constants[k] = v 
end