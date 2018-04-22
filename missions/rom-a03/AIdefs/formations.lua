----- mission formations settigns ------
----- more about: http://code.google.com/p/nota/wiki/NOE_formations

newFormationBySpirit = {
	["patrol1"]				= "swarm",
	["ASBattacker"]			= "standardLine",
	["ASBattackSupportLine"]= "standardLine",
	["ASBdefender"]			= "swarm",
	["kroggyAttacker"]		= "swarm",
	["kroggyFactory"]		= "noForm",
	["ASBTankAttacker"]		= "wedge",
	["airborn"]				= "swarm",
	["airbornTransport"]	= "swarm",
	["ABgroundKiller"]		= "swarm",
	["asistAAAcover"]		= "swarm",
	["areaAAAcover"]		= "swarm",
	["TGdefender"]			= "swarm",
	["TGressurector"]		= "swarm",
	["TGtransportAssister"]	= "doubleColumn",
	["transport"]			= "swarm",
	["truckBuffer"]			= "swarm",
	["truckDefenceBuffer"]	= "swarm",
	["specialDefence"]		= "doubleCircle"
}

newFormationNames = {"pentagram","doubleCircle"}

newFormationDef = {
    ["pentagram"] = {name = "pentagram", limit = 5, scales = {20,20}, gen = true, hilly = 60, constrained = true, variant = false, rotable = true, rotations = 16, rotationCheckDistance = 2000},
	["doubleCircle"] = {name = "doubleCircle", limit = 16,	scales = {20,20},   gen = true,  hilly = 20, constrained = true, constrainLevel = 2, variant = false, rotable = false},
}

newFormations = {
    ["pentagram"] = { 
	    [1]  = {0,3},
		[2]  = {2,1}, 
		[3]  = {-2,1}, 
		[4]  = {1,-2},
		[5]  = {-1,-2},
	},
	["doubleCircle"] = {
	    [1]  = {4,0},		[2]  = {-4,4},		[3]  = {-8,0},		[4]  = {-4,-4},		[5]  = {-1,3},		[6]  = {-1,-3},		[7]  = {-7,3},		[8]  = {-7,-3},
		[9]  = {8,0},		[10]  = {-8,8},		[11]  = {-16,0},	[12]  = {-8,-8},	[13]  = {-2,6},		[14]  = {-2,-6},	[15]  = {-15,6},	[16]  = {-14,-6},
	},
}

newFormationsGeneration = {
	["pentagram"] = function(limit) 
	    OnlyScaling("pentagram",limit)
	end,
	["doubleCircle"] = function(limit) 
	    OnlyScaling("doubleCircle",limit)
	end,
}