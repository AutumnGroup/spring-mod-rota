----- mission spirits settigns ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

-- math.randomseed(missionInfo.randomization)

local spGetUnitPosition                = Spring.GetUnitPosition
local spGiveOrderToUnit                = Spring.GiveOrderToUnit

local CMD_MOVE                         = CMD.MOVE

ants = {}

for i=1,missionInfo.numberOfAnts do
    local newName = "ant" .. i
    ants[newName] = {
	    ["doReturn"]    = false,
		["lastNod"]     = "start",
		["nextNod"]     = "A",
	}
end

nods = {
    -- endings --
    ["start"] = {
	    ["posX"]            = path.start.x,		
		["posZ"]            = path.start.z,
		["simpleNextThere"] = true,		["simpleNextBack"]  = true,	
		["nextThere"]       = "A",		["nextBack"]        = "A",
		["changeDir"]       = true,
		["marker"]          = 1,
	},
	["ziel"] = {
	    ["posX"]            = path.ziel.x,		
		["posZ"]            = path.ziel.z,
		["simpleNextThere"] = true,		["simpleNextBack"]  = true,	
		["nextThere"]       = "B",		["nextBack"]        = "B",
	    ["changeDir"]       = true,
		["marker"]          = 1,
	},
	-- crossroad --
    ["A"] = {
	    ["posX"]            = path.A.x,		
		["posZ"]            = path.A.z,
		["simpleNextThere"] = false,	["simpleNextBack"]  = true,		
								        ["nextBack"]        = "start",
		["options"]         = {"H1","D1"},
		["changeDir"]       = false,
		["marker"]          = 1,
	},
	["B"] = {
	    ["posX"]            = path.B.x,		
		["posZ"]            = path.B.z,
		["simpleNextThere"] = true,		["simpleNextBack"]  = false,	
		["nextThere"]       = "ziel",	["options"]         = {"HN","DN"},
		["changeDir"]       = false,
		["marker"]          = 1,
	},
	-- decision-makers --
    ["H1"] = {
	    ["posX"]            = path.H1.x,		
		["posZ"]            = path.H1.z,
		["simpleNextThere"] = true,		["simpleNextBack"]  = true,		
		["nextThere"]       = "H2",		["nextBack"]        = "A",
		["changeDir"]       = false,
		["marker"]          = 1,
	},
    ["D1"] = {
	    ["posX"]            = path.D1.x,		
		["posZ"]            = path.D1.z,
		["simpleNextThere"] = true,		["simpleNextBack"]  = true,
		["nextThere"]       = "D2",		["nextBack"]        = "A",
		["changeDir"]       = false,
		["marker"]          = 1,
	},
	["HN"] = {
	    ["posX"]            = path.HN.x,		
		["posZ"]            = path.HN.z,
		["simpleNextThere"] = true,		["simpleNextBack"]  = true,
		["nextThere"]       = "B",		["nextBack"]        = "H2",
		["changeDir"]       = false,
		["marker"]          = 1,
	},
	["DN"] = {
	    ["posX"]            = path.DN.x,		
		["posZ"]            = path.DN.z,
		["simpleNextThere"] = true,		["simpleNextBack"]  = true,
		["nextThere"]       = "B",		["nextBack"]        = "D2",
		["changeDir"]       = false,
		["marker"]          = 1,
	},
	-- others --
	["H2"] = {
	    ["posX"]            = path.H2.x,		
		["posZ"]            = path.H2.z,
		["simpleNextThere"] = true,		["simpleNextBack"]  = true,
		["nextThere"]       = "HN",		["nextBack"]        = "H1",
		["changeDir"]       = false,
		["marker"]          = 1,
	},
	["D2"] = {
	    ["posX"]            = path.D2.x,		
		["posZ"]            = path.D2.z,
		["simpleNextThere"] = true,		["simpleNextBack"]  = true,
		["nextThere"]       = "DN",		["nextBack"]        = "D1",
		["changeDir"]       = false,
		["marker"]          = 1,
	},
}

local firstTime = true

local function Decision(nameOfNodOne,nameOfNodTwo)
    local nodOne       = nods[nameOfNodOne]
	local nodTwo       = nods[nameOfNodTwo]
	local probOne      = nodOne.marker / (nodOne.marker + nodTwo.marker)
	local probTwo      = nodTwo.marker / (nodOne.marker + nodTwo.marker)
	local randomNumber = math.random()
	---- starting case ----
	if (nodOne.marker <= missionInfo.startLevel and nodTwo.marker <= missionInfo.startLevel and firstTime) then
	    --Spring.Echo(randomNumber)
	    if (randomNumber <= 0.5) then
			return nameOfNodOne
		else
			return nameOfNodTwo
		end
	end
	---- normal case ------
	if (randomNumber <= probOne) then
	    firstTime = false
	    return nameOfNodOne
	else
		firstTime = false
	    return nameOfNodTwo
	end
end

local function GiveMeNextNod(currentNodName,doIReturnToHive)
    local directionString 
    if (doIReturnToHive) then
	    directionString = "Back"
	else
	    directionString = "There"
	end
	local dataString          = "next" .. directionString
	local questionDataString  = "simpleNext" .. directionString
	local thisNod             = nods[currentNodName]
	if (thisNod[questionDataString]) then
	    return thisNod[dataString]
	else
	    -- ?! cycle maybe later, now two options --
		local choose = Decision(thisNod.options[1],thisNod.options[2])
		return choose
	end
end

newPlan = {
    ["simplePlan"] = function(groupID,teamNumber)
	    local thisGroup = groupInfo[groupID]
	end,
}

newSpiritDef = {
    ["worker"] = function(groupID,teamNumber,mode)
        local thisGroup = groupInfo[groupID]
		if (thisGroup.membersListAlive[1]) then
		    local checkName  = unitsUnderGreatEyeIDtoName[thisGroup.membersList[1]]
			--- only first time ---
			if (thisGroup.initialization) then
				spGiveOrderToUnit(thisGroup.membersList[1], CMD_MOVE, {nods[ants[checkName].nextNod].posX,0,nods[ants[checkName].nextNod].posZ},{})
				thisGroup.initialization = false
			end
			--- every time ---
			local x,y,z      = spGetUnitPosition(thisGroup.membersList[1])
			local distanceSQ = GetDistance2DSQ(x,z,nods[ants[checkName].nextNod].posX,nods[ants[checkName].nextNod].posZ) 
			if (distanceSQ < 5600) then
                --- replacing lastNod
			    ants[checkName].lastNod = ants[checkName].nextNod
				--- changing direction if lastNod is specific  ---
				if     (ants[checkName].lastNod == "start") then
					ants[checkName].doReturn = false
				elseif (ants[checkName].lastNod == "ziel") then
				    ants[checkName].doReturn = true
				end
				--- choosing nextNod ---
			    ants[checkName].nextNod = GiveMeNextNod(ants[checkName].lastNod,ants[checkName].doReturn)
			    spGiveOrderToUnit(thisGroup.membersList[1], CMD_MOVE, {nods[ants[checkName].nextNod].posX,0,nods[ants[checkName].nextNod].posZ},{})
				-- Spring.Echo(ants[checkName].lastNod,tostring(ants[checkName].doReturn))
			end
		end
    end,
}