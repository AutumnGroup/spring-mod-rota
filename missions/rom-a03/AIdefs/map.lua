----- NOE map - important places list in this mission --------
----- more about: http://code.google.com/p/nota/wiki/NOE_map

newMap = {
    --- main trigger areas ---
	["area1"]= {
		[1] = {6589,130},
		[2] = {8113,1500},
	},
	["area2"]= {
		[1] = {333,6395},
		[2] = {1551,7866},
	},
	["area3"]= {
		[1] = {1827,5339},
		[2] = {2554,7074},
	},
	["area4"]= {
		[1] = {107,4862},
		[2] = {1371,6170},
	},
	["area5"]= {
		[1] = {3370,5698},
		[2] = {5503,8002},
	},
	["area6"]= {
		[1] = {4700,1211},
		[2] = {6709,2941},
	},
	["area7"]= {
		[1] = {2762,4489},
		[2] = {3736,5416},
	},
	["area8"]= {
		[1] = {5971,2402},
		[2] = {8123,3880},
	},
	["area9"]= {
		[1] = {4705,3577},
		[2] = {6319,4905},
	},
	["area10"]= {
		[1] = {1941,2556},
		[2] = {4250,4488},
	},
	["area11"]= {
		[1] = {1271,3396},
		[2] = {1965,5033},
	},
	["areaLZ"]= {
		[1] = {286,122},
		[2] = {1704,1503},
	},
	
	--- GRAPH MAP of transport routes
	["nodA"] = {posX = 7519,	posZ = 461,		nextNod = {"nodB"},				nextNodProb = {1}},
	["nodB"] = {posX = 6161, 	posZ = 1531, 	nextNod = {"nodC","nodD"},		nextNodProb = {0.5,0.5}},
	["nodC"] = {posX = 6201, 	posZ = 2603, 	nextNod = {"nodE"},				nextNodProb = {1}},
	["nodD"] = {posX = 4341, 	posZ = 2834, 	nextNod = {"nodF"},				nextNodProb = {1}},
	["nodE"] = {posX = 7316, 	posZ = 2603, 	nextNod = {"nodG"},				nextNodProb = {1}},
	["nodF"] = {posX = 3384, 	posZ = 3415, 	nextNod = {"nodO","nodN"},		nextNodProb = {0.6,0.4}},
	["nodG"] = {posX = 6563, 	posZ = 3984, 	nextNod = {"nodH"},				nextNodProb = {1}},
	["nodH"] = {posX = 5160, 	posZ = 4247, 	nextNod = {"nodI","nodJ"},		nextNodProb = {0.3,0.7}},
	["nodI"] = {posX = 4492, 	posZ = 4744, 	nextNod = {"nodK","nodL"},		nextNodProb = {0.2,0.8}},
	["nodJ"] = {posX = 4268, 	posZ = 3859, 	nextNod = {"nodF","nodK"},		nextNodProb = {0.5,0.5}},
	["nodK"] = {posX = 3854, 	posZ = 4252, 	nextNod = {"nodN"},				nextNodProb = {1}},
	["nodL"] = {posX = 4982, 	posZ = 5455, 	nextNod = {"nodM"},				nextNodProb = {1}},
	["nodM"] = {posX = 4294, 	posZ = 5735, 	nextNod = {"nodN"},				nextNodProb = {1}},
	["nodN"] = {posX = 3181, 	posZ = 5026, 	nextNod = {"nodR"},				nextNodProb = {1}},
	["nodO"] = {posX = 2055, 	posZ = 2934, 	nextNod = {"nodP"},				nextNodProb = {1}},
	["nodP"] = {posX = 1427, 	posZ = 3585, 	nextNod = {"nodQ"},				nextNodProb = {1}},
	["nodQ"] = {posX = 1704, 	posZ = 4648, 	nextNod = {"nodU","nodR"},		nextNodProb = {0.5,0.5}},
	["nodR"] = {posX = 2241, 	posZ = 5032, 	nextNod = {"nodS"},				nextNodProb = {1}},
	["nodS"] = {posX = 2329, 	posZ = 6330, 	nextNod = {"nodT"},				nextNodProb = {1}},
	["nodT"] = {posX = 1413, 	posZ = 6724, 	nextNod = {"nodZ"},				nextNodProb = {1}},
	["nodU"] = {posX = 1002, 	posZ = 5479, 	nextNod = {"nodV"},				nextNodProb = {1}},
	["nodV"] = {posX = 887, 	posZ = 6291, 	nextNod = {"nodT"},				nextNodProb = {1}},
	["nodZ"] = {posX = 653, 	posZ = 7212, 	nextNod = {},					nextNodProb = {0}},
	
	--- TASKS MAPS ---
	["ASBTankFist"]= {
		[1] = {4504,5850},		[2] = {3176,5030},		[3] = {3288,2674},
		[4] = {820,2800},		[5] = {1698,4803},		[6] = {3276,5030},
	},
	["ASBTankFistReturnPoint"]	= {3730,7257},
	["ASBTankFistWaitingPoint"]	= {4517,6462},
	
	--- ASB full attack --
	["ASBFullAttack"]= {
		[1] = {1235,5000},		[2] = {1710,4711},		[3] = {1438,3622},
		[3] = {942,2404},		[4] = {800,500},		[5] = {3572,3780},
		[6] = {1710,4711},		[7] = {1235,5000},
	},
	["ASBFullAttackReturnPoint"]	= {1151,5961},
	["ASBFullAttackWaitingPoint"]	= {954,5488},
	
	--- ASB defence north -- 
	["ASBdefenceBaseNorth"]= {
		[1] = {1235,5000},		[2] = {1710,4711},		[3] = {1438,3622},
		[4] = {1710,4711},		[5] = {1235,5000},
	},
	["ASBdefenceBaseNorthReturnPoint"]	= {1151,5961},
	["ASBdefenceBaseNorthWaitingPoint"]	= {954,5488},
	
	--- ASB defence East --
	["ASBdefenceBaseEast"]= {
		[1] = {2310,5724},		[2] = {2273,4989},		[3] = {3190,4950},
		[4] = {3207,4517},		[5] = {2273,4989},		[6] = {2310,5724},
	},
	["ASBdefenceBaseEastReturnPoint"]	= {2247,6510},
	["ASBdefenceBaseEastWaitingPoint"]	= {1418,6593},
	
	--- main AAA patrol
	["mainAAApatrol"]= {
		[1] = {7037,3498},		[2] = {3786,6069},		[3] = {830,5296},
	},
	
	--- TG defence East --
	["TGdefence"]= {
		[1] = {6543,1188},		[2] = {5565,1992},		[3] = {5109,2520},
		[4] = {6223,2500},		[5] = {6579,1120},
	},
	["TGdefenceReturnPoint"]	= {6717,438},
	["TGdefenceWaitingPoint"]	= {7504,1333},
	
	--- air-ground return --
	["baseAirReturnPoint"]	 	= {7416,7388},
	["baseAirLoadAreaCenter"] 	= {7350,7350},
	
	["asimBaseReturnPoint"]	 	= {1296,6706},
	["asimBaseLoadAreaCenter"] 	= {1322,6341},
}