local moduleInfo = {
	name 	= "blackboard",
	desc 	= "Functions for work with custom agent memory",
	author 	= "PepeAmpere",
	date 	= "2015/07/21",
	license = "notAlicense",
}

local newBlackboard = {
	["Get"] = function(groupID, name) -- get global memory (of one agent) variable value (indexed by name)
		-- groupID 		- number 			- group reference 
		-- name 		- string 			- index to given memory slot

		return groupInfo[groupID].blackboard[name]
	end,
	["Set"] = function(groupID, name, value) -- save value into global memory of one agent (indexed by name)
		-- groupID 		- number 			- group reference 
		-- name 		- string 			- index to given memory slot	
	
		groupInfo[groupID].blackboard[name] = value
	end,
}
	
-- END OF MODULE DEFINITIONS --

-- update global tables 
if (blackboard == nil) then blackboard = {} end
for k,v in pairs(newBlackboard) do
	if (blackboard[k] ~= nil) then Spring.Echo("NOTIFICATION: Attempt to rewrite global table in module [" .. moduleInfo.name ..  "] - key: " .. k) end
	blackboard[k] = v 
end