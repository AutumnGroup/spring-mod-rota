local moduleInfo = {
	name 	= "someModule",
	desc 	= "Knowledge of the notAspace",
	author 	= "notAslave",
	date 	= "YYYY/MM/DD",
	license = "notAlicense",
}

local moduleTable = {
	-- here start to define your items
}

-- END OF MODULE DEFINITIONS --

-- update global tables 
if (_globalTable == nil) then _globalTable = {} end
for k,v in pairs(moduleTable) do
	if (_globalTable[k] ~= nil) then Spring.Echo("NOTIFICATION: Attempt to rewrite global table in module [" .. moduleInfo.name ..  "] - key: " .. k) end
	_globalTable[k] = v 
end

