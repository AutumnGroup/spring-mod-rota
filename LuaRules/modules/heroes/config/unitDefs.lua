local moduleInfo = {
	name 	= "heroDefs",
	desc	= "List all new custom commands related to heroes", 
	author 	= "PepeAmpere",
	date 	= "2015/08/10",
	license = "notAlicense",
}

newHeroDefs = {
	["hersabo"] = {
		abilities = {
			"PlantNukeMine",
		},
	},
	["hertrapper"] = {
		abilities = {
			"PlantEMPMinefield",
		},
	},
}

-- END OF MODULE DEFINITIONS --

-- update global tables 
if (heroDefs == nil) then heroDefs = {} end
for k,v in pairs(newHeroDefs) do
	if (heroDefs[k] ~= nil) then Spring.Echo("NOTIFICATION: Attempt to rewrite global table in module [" .. moduleInfo.name ..  "] - key: " .. k) end
	heroDefs[k] = v 
end