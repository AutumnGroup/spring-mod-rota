local moduleInfo = {
	name 	= "resourceModes",
	desc	= "resources modes",
	author 	= "PepeAmpere",
	date 	= "2016/01/03",
	license = "notAlicense",
}
-- all planes
ALL_PLANES = {
	["armfig"] = true,
	["armhell"] = true,
	["armlance"] = true,
	["armpnix"] = true,
	["armthund"] = true,
	["armtoad"] = true,
	
	["armhawk"] = true,
	["armwing"] = true,
	["armblade"] = true,
	["armbrawl"] = true,
	["blade"] = true,
	
	["armsfig"] = true,
	["armseap"] = true,
	
	["corevashp"] = true,
	["corhurc"] = true,
	["corshad"] = true,
	["cortitan"] = true,
	["corveng"] = true,
	
	["corape"] = true,
	["corerb"] = true,
	["corgryp"] = true,
	["corsbomb"] = true,
	["corvamp"] = true,
	
	["corseap"] = true,
	["corsfig"] = true,
}

newResourcesModes = {
	["flyingNoFuel"] = {
		validUnitsNames = ALL_PLANES,
		validResourceNames = {
			["hydrocarbons"] = true,
		},
		simulation = {
			incomeUnit = 0,
			incomeTeam = 0,
			resourceAddedUnit = 0,
			resourceAddedTeam = 0,
			resourceLostUnit = 0,
			resourceLostTeam = 0,
			consumptionUnit = 0,
			consumptionTeam = 0,
			storageUnit = fuel,
			storageTeam = 0,
		},
		onEvaluation = function()
			--Spring.Echo("Flying without res")
		end,
	},
	["refueling"] = {
		validUnitsNames = ALL_PLANES,
		validResourceNames = {
			["hydrocarbons"] = true,
		},
		simulation = {
			incomeUnit = 10, -- faking real transfer between team and the unit
			incomeTeam = 0,
			resourceAddedUnit = 0,
			resourceAddedTeam = 0,
			resourceLostUnit = 0,
			resourceLostTeam = 0,
			consumptionUnit = 0,
			consumptionTeam = 10, -- faking real transfer between team and the unit
			storageUnit = fuel,
			storageTeam = 0,
		},
		onEvaluation = function()
			--Spring.Echo("Refueling")
		end,
	},
	["landed"] = {
		validUnitsNames = ALL_PLANES,
		validResourceNames = {
			["hydrocarbons"] = true,
		},
		simulation = {
			incomeUnit = 0,
			incomeTeam = 0,
			resourceAddedUnit = 0,
			resourceAddedTeam = 0,
			resourceLostUnit = 0,
			resourceLostTeam = 0,
			consumptionUnit = 0,
			consumptionTeam = 0,
			storageUnit = fuel,
			storageTeam = 0,
		},
		onEvaluation = function()
			--Spring.Echo("landed")
		end,
	},
}

-- END OF MODULE DEFINITIONS --

-- update global tables 
if (resourcesModes == nil) then resourcesModes = {} end
for k,v in pairs(newResourcesModes) do
	if (resourcesModes[k] ~= nil) then Spring.Echo("NOTIFICATION: Attempt to rewrite global table in module [" .. moduleInfo.name ..  "] - key: " .. k) end
	resourcesModes[k] = v 
end

