----- mission side settigns ------
----- more about: http://code.google.com/p/nota/wiki/NOE_side

newSideSettings = {
    ["asim-base"] = {
        ["groups"] = {
			"ASBBot1Lab1",
			"ASBBot1Lab2",
			"ASBBot1Lab3",
			"ASBBot1Lab4",
			"ASBBot1Lab5",
			"ASBAkBuffer",
			"ASBStormBuffer",
			"ASBThudBuffer",
			"ASBPyroBuffer",
			"ASBCrasherBuffer",
			"ASBAkAttacker1",
			"ASBAkAttacker2",
			"ASBAkDefender1",
			"ASBAkDefender2",
			"ASBStormShield",
			"ASBThudAttackLine1",
			"ASBThudAttackLine2",
			"ASBPyroMen",
			"ASBCrashers",
			"ASBKroggyLab",
			"ASBKroggyBuffer",
			"ASBKroggy",
			"ASBVeh1Lab1",
			"ASBTankBuffer",
			"ASBRaiderFist",
        },
		["basicTools"] = {
		    {toolPurpose = "basicGroundMex", unitName = "armmex"},
		},
		["startMetal"]         = 1000,
		["startMetalStorage"]  = 2000,
		["startEnergy"]        = 1000,
		["startEnergyStorage"] = 33000,
	},
	["air-base"] = {
        ["groups"] = {
			--"ABBot1Lab1",
			--"ABPyroBuffer",
			--"ABPyroAirborn1",
			--"ABPyroAirborn2",
			"ABBot2Lab2",
			"ABCrabbeBuffer",
			"ABCrabbeAirborne1",
			"ABCrabbeAirborne2",
			"ABValkFact1",
			"ABValkFact2",
			"ABValkBusBuffer",
			"ABValkBuffer",
			"ABBus1",
			"ABBus2",
			"ABValk1",
			"ABValk2",
			"ABAir1Lab1",
			"ABAir1Lab2",
			"ABVasphBuffer",
			"ABAvengerBuffer",
			"ABVasphsRevenge1",
			"ABVasphsRevenge2",
			"ABAvengerSupport1",
			"ABAvengerSupport2",
			"ABAvengerSupport3",
			"ABAir2Lab1",
			"ABAABuffer",
			"ABNapalmBuffer",
			"ABAAShield",
			"ABFlamingRevenge1",
			"ABFlamingRevenge2",
        },
		["basicTools"] = {
		    {toolPurpose = "basicGroundMex", unitName = "armmex"},
		},
		["startMetal"]         = 200,
		["startMetalStorage"]  = 4500,
		["startEnergy"]        = 200,
		["startEnergyStorage"] = 24000,
	},
	["transport-guards"] = {
        ["groups"] = {
			"TGBot1Lab1",
			-- "TGVeh1Lab1",
			"TGAkBuffer",
			-- "TGThudBuffer",
			-- "TGStormBuffer",
			-- "TGCrasherBuffer",
			"TGNecroBuffer",
			-- "TGInstigatorBuffer",
			"TGTransportedBuffer",
			"TGAkDefs1",
			"TGAkDefs2",
			"TGAkDefsX",
			-- "TGThudDefs",
			-- "TGStormDefs",
			"TGRessurectors",
        },
		["basicTools"] = {
		    {toolPurpose = "basicGroundMex", unitName = "armmex"},
		},
		["startMetal"]         = 100,
		["startMetalStorage"]  = 500,
		["startEnergy"]        = 100,
		["startEnergyStorage"] = 500,
	},
}

local trasportsCount = missionInfo.transportsNumber

-- thuds
-- for i=1,trasportsCount do
	-- local thisList = newSideSettings["transport-guards"].groups
	-- newSideSettings["transport-guards"].groups[#thisList+1] = "TGThudEscort" .. i
-- end

-- storms
-- for i=1,trasportsCount do
	-- local thisList = newSideSettings["transport-guards"].groups
	-- newSideSettings["transport-guards"].groups[#thisList+1] = "TGStormEscort" .. i
-- end

-- crashers
-- for i=1,trasportsCount do
	-- local thisList = newSideSettings["transport-guards"].groups
	-- newSideSettings["transport-guards"].groups[#thisList+1] = "TGCrasherEscort" .. i
-- end

-- for i=1,trasportsCount do
	-- local thisList = newSideSettings["transport-guards"].groups
	-- newSideSettings["transport-guards"].groups[#thisList+1] = "TGInstigatorEscort" .. i
-- end

-- transported unit
for i=1,trasportsCount do
	local thisList = newSideSettings["transport-guards"].groups
	newSideSettings["transport-guards"].groups[#thisList+1] = "TGTransportedUnit" .. i	
end