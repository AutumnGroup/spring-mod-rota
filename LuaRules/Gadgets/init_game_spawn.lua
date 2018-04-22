--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    game_spawn.lua
--  brief:   spawns start unit and sets storage levels
--  author:  Tobi Vollebregt
--
--  Copyright (C) 2010.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name      = "Spawn",
		desc      = "spawns start unit and sets storage levels",
		author    = "Tobi Vollebregt/TheFatController",
		date      = "January, 2010",
		license   = "GNU GPL, v2 or later",
		layer     = 0,
		enabled   = true  --  loaded by default?
	}
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- synced only
if (not gadgetHandler:IsSyncedCode()) then
	return false
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local modOptions = Spring.GetModOptions()

local commodes= {
	comstart=true,
}

local coopMode = tonumber(Spring.GetModOptions().mo_coop) or 0

local startUnits = {} -- get the side calculation

local mapX                   = Game.mapSizeX
local mapZ                   = Game.mapSizeZ
local baseFromBorder         = 1000
local baseGap				 = 500

-----------------
-- speedups -----
-----------------
local spGetPlayerInfo        = Spring.GetPlayerInfo
local spGetTeamInfo          = Spring.GetTeamInfo
local spGetTeamStartPosition = Spring.GetTeamStartPosition
local spGetAllyTeamStartBox  = Spring.GetAllyTeamStartBox
local spCreateUnit           = Spring.CreateUnit
local spGetGroundHeight      = Spring.GetGroundHeight

local spSetUnitResourcing    = Spring.SetUnitResourcing
local spSetTeamResource      = Spring.SetTeamResource
local spAddTeamResource      = Spring.AddTeamResource
local spGetSideData          = Spring.GetSideData
local spGetModOptions        = Spring.GetModOptions
local spGetTeamList          = Spring.GetTeamList
local spGetPlayerList        = Spring.GetPlayerList
local spGetGaiaTeamID        = Spring.GetGaiaTeamID

local mapSizeX               = Game.mapSizeX
local mapSizeZ               = Game.mapSizeZ

local startingPositions		 = {}
local startingPosCount		 = 0

local function GetStartUnit(teamID)
	-- get the team startup info
	local side = select(5, spGetTeamInfo(teamID))
	local startUnit
	if (side == "") then
		--startscript didn't specify a side for this team
		local sidedata = spGetSideData()
		if (sidedata and #sidedata > 0) then
			startUnit = sidedata[1 + teamID % #sidedata].startUnit
		end
	else
		startUnit = spGetSideData(side)
    end
	
	if (commodes[spGetModOptions().startoptions]) then
		if (startUnit == "corbase") then
			startUnit = "corcom2"
		else
			startUnit = "armcom2"
		end
	end

	return startUnit
end

local function InitKnownPositions(teamID)
	local team = "t" .. teamID
	if (startUnits[team] and startUnits[team] ~= "") then
		local _,_,_,isAI,_,allyTeam 			= spGetTeamInfo(teamID)
		local x,_,z 							= spGetTeamStartPosition(teamID)
		local y 								= spGetGroundHeight(x, z)
		if (not isAI) then
			startingPosCount 						= startingPosCount + 1
			startingPositions[startingPosCount] 	= {}
			startingPositions[startingPosCount][1]	= x
			startingPositions[startingPosCount][2]	= y
			startingPositions[startingPosCount][3]	= z
		end
	end
end

function GetDistance2D(firstX,firstZ,secondX,secondZ)  -- returns 2D distance of two places
    local result = math.sqrt((firstX-secondX)*(firstX-secondX) + (firstZ-secondZ)*(firstZ-secondZ))
	return result
end

local function TestDistanceFromOthers(testX,testZ,gapping)
	local ok = true
	for i=1,startingPosCount do
		if (GetDistance2D(testX,testZ,startingPositions[i][1],startingPositions[i][3]) < gapping) then
			ok = false
		end
	end
	return ok
end

local function RandomPlacer(smallX, smallZ, bigX, bigZ, fromBorder, gap)
    ---- change of fromBorder
	local xSize = math.abs(smallX - bigX)
	local zSize = math.abs(smallZ - bigZ)
	if (xSize < fromBorder) then
	    fromBorder = xSize - 100
	end
	if (zSize < fromBorder) then
	    fromBorder = zSize - 100
	end
    ----
    local x = smallX
	for i=1,25 do
		x = math.random(smallX,bigX)
		if ((x > fromBorder) and (x < (mapX-fromBorder))) then
		    break
		end
	end
	local z = smallZ
	for i=1,25 do
		z = math.random(smallZ,bigZ)
		if ((z > fromBorder) and (z < (mapZ-fromBorder))) then
		    break
		end
	end
	local y = spGetGroundHeight(x, z)
	
	-- test
	if (TestDistanceFromOthers(x, z, gap)) then
		startingPosCount 						= startingPosCount + 1
		startingPositions[startingPosCount] 	= {}
		startingPositions[startingPosCount][1]	= x
		startingPositions[startingPosCount][2]	= y
		startingPositions[startingPosCount][3]	= z
		return x,y,z
	else
		return RandomPlacer(smallX, smallZ, bigX, bigZ, baseFromBorder-100, baseGap-100)
	end
end

local function SpawnStartUnit(teamID)
	-- local startUnit = GetStartUnit(teamID)
	local team = "t" .. teamID
	if (startUnits[team] and startUnits[team] ~= "") then
		local _,_,_,isAI,_,allyTeam   = spGetTeamInfo(teamID)
		local x,y,z                   = spGetTeamStartPosition(teamID)
		local smallX,smallZ,bigX,bigZ = spGetAllyTeamStartBox(allyTeam)
		local notMissionAI            = true
		local missionName             = Spring.GetModOptions().mission_name or "none" -- name of scenario
		if (isAI) then                                  -- condition for notSpawning tower for missionAI in all cases except one - defualt mission_name
		    local AIname = Spring.GetTeamLuaAI(teamID)
			--Spring.Echo(AIname,missionName)
			if ((AIname == "Mission AI") and (missionName ~= "none")) then
			    notMissionAI = false
			end
		end
		local _, skirmishAIName = Spring.GetAIInfo(teamID)
		if (isAI and Game.startPosType == 2 and skirmishAIName ~= "BtEvaluator") then -- BtEvaluator is not running in this moment, if other component (including player) did the selection, we trust it
			x,y,z 	= RandomPlacer(smallX, smallZ, bigX, bigZ, baseFromBorder, baseGap)
		else
		    x,_,z 	= spGetTeamStartPosition(teamID)
	        y 		= spGetGroundHeight(x, z)
		end
		-- spawn the specified start unit
		-- snap to 16x16 grid
		--x, z = 16*math.floor((x+8)/16), 16*math.floor((z+8)/16)
		
		-- facing toward map center
		-- local facing=math.abs(mapSizeX/2 - x) > math.abs(mapSizeZ/2 - z)
			-- and ((x>mapSizeX/2) and "west" or "east")
			-- or ((z>mapSizeZ/2) and "north" or "south")
		if (notMissionAI) then
			if (missionName ~= "none") then
				local missionSettingsPath = "missions/" .. missionName .. "/settings.lua"
				include (missionSettingsPath)
				if (missionInfo.notStartUnit) then
				    return
			    end
			end			
			
			local m = modOptions.startmetal or 1000
			local e = modOptions.startenergy or 1000
			
			local commanderID = spCreateUnit(startUnits[team], x, y, z, 0, teamID)
			
			if (m and tonumber(m) ~= 0) then
				spSetUnitResourcing(commanderID, "m", 0)
				spSetTeamResource(teamID, "m", 0)
				spSetTeamResource(teamID, "ms", tonumber(m))
				spAddTeamResource(teamID, "m", tonumber(m))
			end
			
			if (e and tonumber(e) ~= 0) then
				spSetUnitResourcing(commanderID, "e", 0)
				spSetTeamResource(teamID, "e", 0)
				spSetTeamResource(teamID, "es", tonumber(e))
				spAddTeamResource(teamID, "e", tonumber(e))
			end
	
		else
		    -- RESOURCES --
		    -- => job of unit_noe.lua
			
		    -- SPAWNING --
			--- !! mission AI stuff spawn -- missing now
			--- => thats job of noe_spawner.lua
		end
	end 
end

function gadget:Initialize()
	local gaiaTeamID = spGetGaiaTeamID()
	local teams = spGetTeamList()
	for i = 1,#teams do
		local teamID = teams[i]
		local team = "t" .. teamID
		if (teamID ~= gaiaTeamID) then
			local startUnit = GetStartUnit(teamID)
		    startUnits[team] = startUnit
		end
	end
end

function gadget:GameStart()
	local excludeTeams = {}

	if (coopMode == 1) then

		for _, teamID in ipairs(spGetTeamList()) do
			local playerCount = 0
			for _, playerID in ipairs(spGetPlayerList(teamID)) do
				if not select(3,spGetPlayerInfo(playerID)) then
					playerCount = playerCount + 1
				end
			end
			if (playerCount > 1) then excludeTeams[teamID] = true end
		end
	
	end
	
	local gaiaTeamID = spGetGaiaTeamID()
	local teams = spGetTeamList()
	
	-- init
	for i = 1,#teams do
		local teamID = teams[i]
		if ((teamID ~= gaiaTeamID) and (not excludeTeams[teamID])) then 
			InitKnownPositions(teamID)
		end
	end	
	
	-- spawn start units
	for i = 1,#teams do
		local teamID = teams[i]
		-- don't spawn a start unit for the Gaia team
		if ((teamID ~= gaiaTeamID) and (not excludeTeams[teamID])) then 
			SpawnStartUnit(teamID)
		end
	end
end
