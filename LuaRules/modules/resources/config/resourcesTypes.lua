local moduleInfo = {
	name 	= "resourcesTypes",
	desc	= "resources types defs",
	author 	= "PepeAmpere",
	date 	= "2015/12/06",
	license = "notAlicense",
}

local spSetUnitFuel = Spring.SetUnitFuel -- only Spring 100.0 and older backwards compatibility

newResourcesTypes = {
	[1] = {
		name = "hydrocarbons",
		defaultStored = 0,
		defaultStorageSize = 0,
		defaultIncome = 0,
		defaultConsumption = 0,
		events = {
			teamIncome = function()
			
			end,
			unitReceived = function()
				
			end,
			unitLost = function()

			end,
			unitUpdate = function(unitID, newStorage)				
				spSetUnitFuel(unitID, newStorage)
			end,
		},
	},
}

-- END OF MODULE DEFINITIONS --

-- update global tables 
if (resourcesTypes == nil) then resourcesTypes = {} end
for k,v in pairs(newResourcesTypes) do
	if (resourcesTypes[k] ~= nil) then Spring.Echo("NOTIFICATION: Attempt to rewrite global table in module [" .. moduleInfo.name ..  "] - key: " .. k) end
	resourcesTypes[k] = v 
end

