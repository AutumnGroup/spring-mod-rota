----- mission groups settigns ------
----- more about: http://code.google.com/p/nota/wiki/NOE_groups

newGroupDef = {
    
	--- ASIMILATION BASE (ASB) ---
	
	-- bot1 labs --
	["ASBBot1Lab1"] 	= {size = 1, unit = "corlab", spirit = "advancedFactory"},
	["ASBBot1Lab2"] 	= {size = 1, unit = "corlab", spirit = "advancedFactory"},
	["ASBBot1Lab3"] 	= {size = 1, unit = "corlab", spirit = "advancedFactory"},
	["ASBBot1Lab4"] 	= {size = 1, unit = "corlab", spirit = "advancedFactory"},
	["ASBBot1Lab5"] 	= {size = 1, unit = "corlab", spirit = "advancedFactory"},
	-- bot1 buffers --
	["ASBAkBuffer"] 	= {size = 20, unit = "corak", spirit = "advancedBuffer", transfer = 6, status = {0,0,0,1}, source = "Bot1", dependance = false, factories = {"ASBBot1Lab1","ASBBot1Lab2"}},
	["ASBStormBuffer"] = {size = 30, unit = "corstorm", spirit = "advancedBuffer", transfer = 4, status = {0,0,0,1}, source = "Bot1", dependance = false, factories = {"ASBBot1Lab2","ASBBot1Lab4"}},
	["ASBThudBuffer"] 	= {size = 30, unit = "corthud", spirit = "advancedBuffer", transfer = 4, status = {0,0,0,1}, source = "Bot1", dependance = false, factories = {"ASBBot1Lab1","ASBBot1Lab3"}},
	["ASBPyroBuffer"] 	= {size = 30, unit = "corpyro", spirit = "advancedBuffer", transfer = 3, status = {0,0,0,1}, source = "Bot1", dependance = false, factories = {"ASBBot1Lab1","ASBBot1Lab4"}},
	["ASBCrasherBuffer"] = {size = 20, unit = "corcrash", spirit = "advancedBuffer", transfer = 2, status = {0,0,0,1}, source = "Bot1", dependance = false, factories = {"ASBBot1Lab1","ASBBot1Lab4"}},
	-- bot1 battlegroups --
	["ASBAkAttacker1"] 	= {size = 26, unit = "corak", spirit = "ASBattacker", transfer = 1, status = {6,12,16,18}, taskName = "ASBFullAttack", targetClasses = {}, source = "Bot1", dependance = false},
	["ASBAkAttacker2"] 	= {size = 26, unit = "corak", spirit = "ASBattacker", transfer = 8, status = {6,12,16,18}, taskName = "ASBFullAttack",targetClasses = {}, source = "Bot1", dependance = false},
	["ASBAkDefender1"] 	= {size = 20, unit = "corak", spirit = "ASBdefender", transfer = 4, status = {6,12,16,18}, taskName = "ASBdefenceBaseNorth", targetClasses = {}, source = "Bot1", dependance = false},
	["ASBAkDefender2"] 	= {size = 20, unit = "corak", spirit = "ASBdefender", transfer = 4, status = {6,12,16,18}, taskName = "ASBdefenceBaseEast", targetClasses = {}, source = "Bot1", dependance = false},
	["ASBStormShield"] 	= {size = 30, unit = "corstorm", spirit = "ASBattacker", transfer = 2, status = {6,12,16,18}, taskName = "ASBFullAttack", targetClasses = {}, source = "Bot1", dependance = false},
	["ASBThudAttackLine1"] 	= {size = 35, unit = "corthud", spirit = "ASBattacker", transfer = 8, status = {12,18,24,30}, taskName = "ASBFullAttack", targetClasses = {}, source = "Bot1", dependance = false},
	["ASBThudAttackLine2"] 	= {size = 35, unit = "corthud", spirit = "ASBattackSupportLine", transfer = 8, status = {6,12,16,18}, targetClasses = {}, source = "Bot1", dependance = true, leader = "ASBThudAttackLine1"},
	["ASBPyroMen"] 	= {size = 22, unit = "corpyro", spirit = "ASBdefender", transfer = 2, status = {4,8,14,20}, taskName = "ASBdefenceBaseNorth", targetClasses = {}, source = "Bot1", dependance = false},
	["ASBCrashers"] 	= {size = 18, unit = "corcrash", spirit = "ASBattackSupportLine", transfer = 1, status = {0,2,4,8}, targetClasses = {}, source = "Bot1", dependance = true, leader = "ASBThudAttackLine1"},
	
	-- kroggy lab ---
	["ASBKroggyLab"] 	= {size = 1, unit = "corgant", spirit = "kroggyFactory"},
	-- kroggy buffer --
	["ASBKroggyBuffer"] = {size = 0, unit = "corkrog", spirit = "advancedBuffer", transfer = 1, status = {0,1,1,1}, source = "Bot1", dependance = false, factories = {"ASBKroggyLab"}},
	-- kroggy battlergroup --
	["ASBKroggy"] 	= {size = 2, unit = "corkrog", spirit = "ASBattacker", transfer = 1, status = {1,1,1,1}, taskName = "ASBFullAttack", targetClasses = {}, source = "Bot1", dependance = false},

	-- tank fact --
	["ASBVeh1Lab1"] 	= {size = 1, unit = "corvp", spirit = "advancedFactory"},
	-- tank buffer --
	["ASBTankBuffer"] 	= {size = 30, unit = "corraid", spirit = "advancedBuffer", transfer = 15, status = {0,2,4,8}, source = "Veh1", dependance = false, factories = {"ASBVeh1Lab1"}},
	-- tank squad --
	["ASBRaiderFist"] 	= {size = 28, unit = "corraid", spirit = "ASBTankAttacker", transfer = 4, status = {6,12,22,26}, taskName = "ASBTankFist", targetClasses = {}, source = "Veh1", dependance = false},
	
	--- AIR-BASE (AB) ---
	
	-- bot1 lab --
	["ABBot1Lab1"] 	= {size = 1, unit = "corlab", spirit = "advancedFactory"},
	-- bot1 buffer --
	["ABPyroBuffer"] 	= {size = 15, unit = "corpyro", spirit = "advancedBuffer", transfer = 5, status = {0,2,4,8}, source = "Bot1", dependance = false, factories = {"ABBot1Lab1"}},
	-- bot1 battlegroups --
	["ABPyroAirborn1"] 	= {size = 10, unit = "corpyro", spirit = "airborn", transfer = 2, status = {0,2,4,8}, targetClasses = {}, source = "Bot1", dependance = false},
	["ABPyroAirborn2"] 	= {size = 10, unit = "corpyro", spirit = "airborn", transfer = 2, status = {0,2,4,8}, targetClasses = {}, source = "Bot1", dependance = false},
	
	-- bot2 lab --
	["ABBot2Lab2"] 	= {size = 1, unit = "coralab", spirit = "advancedFactory"},
	-- bot2 buffer --
	["ABCrabbeBuffer"] 	= {size = 5, unit = "corcrabe", spirit = "advancedBuffer", transfer = 2, status = {0,2,4,8}, source = "Bot1", dependance = false, factories = {"ABBot2Lab2"}},
	-- bot2 battlegroups --
	["ABCrabbeAirborne1"] 	= {size = 3, unit = "corcrabe", spirit = "airborn", transfer = 1, status = {0,2,4,8}, source = "Bot1", dependance = false},
	["ABCrabbeAirborne2"] 	= {size = 3, unit = "corcrabe", spirit = "airborn", transfer = 1, status = {0,2,4,8}, source = "Bot1", dependance = false},
	
	-- valk fact --
	["ABValkFact1"] 	= {size = 1, unit = "corvalkfac", spirit = "advancedFactory"},
	["ABValkFact2"] 	= {size = 1, unit = "corvalkfac", spirit = "advancedFactory"},
	-- valk buffers --
	["ABValkBusBuffer"] 	= {size = 5, unit = "corvalkii", spirit = "advancedBuffer", transfer = 2, status = {0,2,4,8}, source = "Bot1", dependance = false, factories = {"ABValkFact1"}},
	["ABValkBuffer"] 	= {size = 5, unit = "corvalk", spirit = "advancedBuffer", transfer = 2, status = {0,2,4,8}, source = "Bot1", dependance = false, factories = {"ABValkFact2"}},
	-- valk battlegroups --
	["ABBus1"] 	= {size = 1, unit = "corvalkii", spirit = "airbornTransport", transfer = 1, status = {0,1,1,1}, taskName = "revengeAirDrop-transport-bus", targetClasses = {}, source = "Bot1", dependance = true, leader = "ABPyroAirborn1"},
	["ABBus2"] 	= {size = 1, unit = "corvalkii", spirit = "airbornTransport", transfer = 1, status = {0,1,1,1}, taskName = "revengeAirDrop-transport-bus", targetClasses = {}, source = "Bot1", dependance = true, leader = "ABPyroAirborn2"},
	["ABValk1"] 	= {size = 3, unit = "corvalk", spirit = "airbornTransport", transfer = 1, status = {0,1,1,1}, taskName = "revengeAirDrop-transport-heavy", targetClasses = {}, source = "Bot1", dependance = true, leader = "ABCrabbeAirborne1"},
	["ABValk2"] 	= {size = 3, unit = "corvalk", spirit = "airbornTransport", transfer = 1, status = {0,1,1,1}, taskName = "revengeAirDrop-transport-heavy", targetClasses = {}, source = "Bot1", dependance = true, leader = "ABCrabbeAirborne2"},
	
	-- air1 lab --
	["ABAir1Lab1"] 	= {size = 2, unit = "corap", spirit = "advancedFactory"},
	["ABAir1Lab2"] 	= {size = 1, unit = "corap", spirit = "advancedFactory"},
	-- air buffers --
	["ABVasphBuffer"] 	= {size = 20, unit = "corevashp", spirit = "advancedBuffer", transfer = 4, status = {0,2,4,8}, source = "Bot1", dependance = false, factories = {"ABAir1Lab1"}},
	["ABAvengerBuffer"] 	= {size = 25, unit = "corveng", spirit = "advancedBuffer", transfer = 4, status = {0,2,4,8}, source = "Bot1", dependance = false, factories = {"ABAir1Lab2"}},
	-- air battlegroups --
	["ABVasphsRevenge1"] 	= {size = 12, unit = "corevashp", spirit = "ABgroundKiller", transfer = 1, status = {1,2,3,4}, taskName = "revengeAttackOne", targetClasses = {}, source = "Bot1", dependance = false},
	["ABVasphsRevenge2"] 	= {size = 12, unit = "corevashp", spirit = "ABgroundKiller", transfer = 1, status = {1,2,3,4}, taskName = "revengeAttackTwo", targetClasses = {}, source = "Bot1", dependance = false},
	["ABAvengerSupport1"] 	= {size = 8, unit = "corveng", spirit = "asistAAAcover", transfer = 1, status = {1,2,3,4}, taskName = "mainAAApatrol", targetClasses = {}, source = "Bot1", dependance = false},
	["ABAvengerSupport2"] 	= {size = 8, unit = "corveng", spirit = "asistAAAcover", transfer = 1, status = {1,2,3,4}, taskName = "mainAAApatrol", targetClasses = {}, source = "Bot1", dependance = false},
	["ABAvengerSupport3"] 	= {size = 8, unit = "corveng", spirit = "asistAAAcover", transfer = 1, status = {1,2,3,4}, taskName = "mainAAApatrol", targetClasses = {}, source = "Bot1", dependance = false},
	
	-- air2 lab --
	["ABAir2Lab1"] 	= {size = 1, unit = "coraap", spirit = "advancedFactory"},
	-- air2 buffers --
	["ABAABuffer"] 	= {size = 10, unit = "corvamp", spirit = "advancedBuffer", transfer = 2, status = {0,2,4,8}, source = "Bot1", dependance = false, factories = {"ABAir2Lab1"}},
	["ABNapalmBuffer"] 	= {size = 10, unit = "corerb", spirit = "advancedBuffer", transfer = 2, status = {0,2,4,8}, source = "Bot1", dependance = false, factories = {"ABAir2Lab1"}},
	-- air2 battlegroups --
	["ABAAShield"] 	= {size = 20, unit = "corvamp", spirit = "areaAAAcover", transfer = 2, status = {1,2,4,8}, taskName = "mainAAApatrol", targetClasses = {}, source = "Bot1", dependance = false},
	["ABFlamingRevenge1"] 	= {size = 4, unit = "corerb", spirit = "ABgroundKiller", transfer = 1, status = {0,1,1,1}, taskName = "revengeFlame-transport", targetClasses = {}, source = "Bot1", dependance = false},
	["ABFlamingRevenge2"] 	= {size = 4, unit = "corerb", spirit = "ABgroundKiller", transfer = 1, status = {0,1,1,1}, taskName = "revengeFlame-area", targetClasses = {}, source = "Bot1", dependance = false},
	
	--- TRANSPORT GUARDS (TG) ---
	-- bot1 lab --
	["TGBot1Lab1"] 	= {size = 1, unit = "corlab", spirit = "advancedFactory"},
	--["TGVeh1Lab1"] 	= {size = 1, unit = "corvp", spirit = "advancedFactory"},
	-- bot1 buffers --
	["TGAkBuffer"] 	= {size = 12, unit = "corak", spirit = "advancedBuffer", transfer = 8, status = {0,2,4,8}, source = "Bot1", dependance = false, factories = {"TGBot1Lab1"}},
	["TGThudBuffer"] 	= {size = 10, unit = "corthud", spirit = "advancedBuffer", transfer = 5, status = {0,2,4,8}, source = "Bot1", dependance = false, factories = {"TGBot1Lab1"}},
	["TGStormBuffer"] 	= {size = 10, unit = "corstorm", spirit = "advancedBuffer", transfer = 5, status = {0,2,4,8}, source = "Bot1", dependance = false, factories = {"TGBot1Lab1"}},
	["TGCrasherBuffer"] 	= {size = 5, unit = "corcrash", spirit = "advancedBuffer", transfer = 2, status = {0,2,4,8}, source = "Bot1", dependance = false, factories = {"TGBot1Lab1"}},
	["TGNecroBuffer"] 	= {size = 3, unit = "cornecro", spirit = "advancedBuffer", transfer = 1, status = {0,1,2,3}, source = "Bot1", dependance = false, factories = {"TGBot1Lab1"}},
	["TGTransportedBuffer"] = {size = 2, unit = "cortruck", spirit = "truckBuffer", transfer = 1, status = {0,2,4,8}, source = "Bot1", dependance = false, factories = {}},
	--["TGInstigatorBuffer"] 	= {size = 12, unit = "corgator", spirit = "truckDefenceBuffer", transfer = 6, status = {1,2,4,8}, source = "Veh1", dependance = true, leader = "TGTransportedBuffer", factories = {"TGVeh1Lab1"}},
	-- bot1 not generated battlegroups --
	["TGAkDefs1"] 	= {size = 12, unit = "corak", spirit = "TGdefender", transfer = 2, status = {2,4,8,10}, taskName = "TGdefenceOne", targetClasses = {}, source = "Bot1", dependance = false},
	["TGAkDefs2"] 	= {size = 12, unit = "corak", spirit = "TGdefender", transfer = 2, status = {2,4,8,10}, taskName = "TGdefenceTwo", targetClasses = {}, source = "Bot1", dependance = false},
	["TGAkDefsX"] 	= {size = 14, unit = "corak", spirit = "specialDefence", transfer = 1, status = {2,4,8,10}, taskName = "specialTDefence", targetClasses = {}, source = "Bot1", dependance = false},
	["TGThudDefs"] 	= {size = 18, unit = "corthud", spirit = "TGdefender", transfer = 2, status = {4,8,12,16}, taskName = "TGdefenceTwo", targetClasses = {}, source = "Bot1", dependance = false},
	["TGStormDefs"] 	= {size = 12, unit = "corstorm", spirit = "TGdefender", transfer = 2, status = {2,4,8,10}, taskName = "TGdefenceTwo", targetClasses = {}, source = "Bot1", dependance = false},
	["TGRessurectors"] 	= {size = 12, unit = "cornecro", spirit = "eco", transfer = 1, status = {0,2,4,8}, targetClasses = {}, source = "Bot1", dependance = false},
	-- now 1..n thud, storm, crasher and transported units groups
	-- done be script under def file
}

-- !!!if formation for spirit not specified, so add default
-- !!set status numbers
-- !!set target classes
-- !!set sources

local trasportsCount = missionInfo.transportsNumber

-- thuds
-- for i=1,trasportsCount do
	-- newGroupDef["TGThudEscort" .. i] = {size = 4, unit = "corthud", spirit = "TGtransportAssister", transfer = 1, status = {0,1,1,1}, targetClasses = {}, source = "Bot1", dependance = true, leader = ("TGTransportedUnit" .. i), depPos = {0,0}}
-- end

-- storms
-- for i=1,trasportsCount do
	-- newGroupDef["TGStormEscort" .. i] = {size = 6, unit = "corstorm", spirit = "TGtransportAssister", transfer = 1, status = {0,1,1,1}, targetClasses = {}, source = "Bot1", dependance = true, leader = ("TGTransportedUnit" .. i), depPos = {0,0}}
-- end

-- crashers
-- for i=1,trasportsCount do
	-- newGroupDef["TGCrasherEscort" .. i] = {size = 3, unit = "corcrash", spirit = "TGtransportAssister", transfer = 1, status = {0,1,1,1}, targetClasses = {}, source = "Bot1", dependance = true, leader = ("TGTransportedUnit" .. i), depPos = {0,0}}
-- end

-- instigators
-- for i=1,trasportsCount do
	-- newGroupDef["TGInstigatorEscort" .. i] = {size = 6, unit = "corgator", spirit = "TGtransportAssister", transfer = 1, status = {1,2,4,5}, targetClasses = {}, source = "Veh1", dependance = true, leader = ("TGTransportedUnit" .. i), depPos = {0,0}}
-- end

-- transported unit
for i=1,trasportsCount do
	newGroupDef["TGTransportedUnit" .. i] = {size = 1, unit = "cortruck", spirit = "transport", transfer = 1, status = {0,1,1,1}, taskName = "transport", targetClasses = {}, source = "Ressurected", dependance = false}
end