--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    game_end_team_com.lua
--  author:  PepeAmpere
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name      = "Team Com End",
		desc      = "Handles team commander end",
		author    = "PepeAmpere",
		date      = "24th June, 2012",
		license   = "BY-NC-SA",
		layer     = 0,
		enabled   = true  --  loaded by default?
	}
end

-- synced only
if (not gadgetHandler:IsSyncedCode()) then
	return false
end

local allyTeamList 				= {}
local teamList					= {}
local allianceCommandersCount	= {}  -- count of commanders in each ally
local allianceMembersIDs		= {}
local leaderUnits				= {
    "armbase",
	"corbase",
	"armcom",
	"armcom2",
	"armbcom",
	"corcom",
	"corcom2",
	"bug1",
	"roost",
	"herfatboy",
	"repmum",
	"repdrone",
}
local destroyAlliance 			= {}
local stepSizeMax				= 10
local spacebugsGame 			= false

local spDestroyUnit 			= Spring.DestroyUnit
local spGetTeamInfo 			= Spring.GetTeamInfo
local spGetTeamUnits 			= Spring.GetTeamUnits

local function GetAllianceID(teamID)
    local _,_,_,_,_,alliance = Spring.GetTeamInfo(teamID)
	return alliance+1
end

local function DestroyAllianceByStep(allyID,step)
    local thisAllyMembers = allianceMembersIDs[allyID]
    for i=1,#thisAllyMembers do
		local allTeamUnits = spGetTeamUnits(thisAllyMembers[i])
		
		local newStep = step
		if (#allTeamUnits < newStep) then newStep = #allTeamUnits	end
		
        for j=1,newStep do
			if (allTeamUnits[j] ~= nil) then -- hotfix
				spDestroyUnit(allTeamUnits[j])
			end
        end
		--Spring.Echo(allyID,thisAllyMembers[i])
	end
end

function gadget:GameOver()
	gadgetHandler:RemoveGadget()
end

local function TestCommandUnits()
    for i=1,#allianceMembersIDs-1 do                      --- minus One becouse in current spring the last is Gaia
	    --Spring.Echo(i,allianceCommandersCount[i])
		if (allianceCommandersCount[i] == 0 and (not destroyAlliance[i])) then
			destroyAlliance[i] = true
		end
		if (destroyAlliance[i]) then
			local numberOfKilled = math.random(1,stepSizeMax)
			DestroyAllianceByStep(i,numberOfKilled)
		end
	end
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam)
    local name = UnitDefs[unitDefID].name
	for i=1,#leaderUnits do
	    if (name == leaderUnits[i]) then
		    local alliance = GetAllianceID(unitTeam)
			allianceCommandersCount[alliance] = allianceCommandersCount[alliance] + 1   
		end
	end
end

function gadget:UnitGiven(unitID, unitDefID, unitTeam)
    local name = UnitDefs[unitDefID].name
	for i=1,#leaderUnits do
	    if (name == leaderUnits[i]) then
		    local alliance = GetAllianceID(unitTeam)
			allianceCommandersCount[alliance] = allianceCommandersCount[alliance] + 1   
		end
	end
end


function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
    local name = UnitDefs[unitDefID].name
	for i=1,#leaderUnits do
	    if (name == leaderUnits[i]) then
		    local alliance = GetAllianceID(unitTeam)
			allianceCommandersCount[alliance] = allianceCommandersCount[alliance] - 1   
		end
	end
end

function gadget:UnitTaken(unitID, unitDefID, unitTeam)
    local name = UnitDefs[unitDefID].name
	for i=1,#leaderUnits do
	    if (name == leaderUnits[i]) then
		    local alliance = GetAllianceID(unitTeam)
			allianceCommandersCount[alliance] = allianceCommandersCount[alliance] - 1  
		end
	end
end


function gadget:GameFrame(n)
    if ((n % 30) == 14) then
		-- avoid testing first minute if its spacebugs game
		if (spacebugsGame and n < 2700) then
			return
		end
	    TestCommandUnits()
	end
end

function gadget:Initialize()
	teamList = Spring.GetTeamList()
	
	-- first check if there are spacebugs
	for t=1,#teamList do
		local someName, _, _, isAITeam, side = Spring.GetTeamInfo(teamList[t])
		if (isAITeam) then
			--local _, name, _, shortName, version, options = Spring.GetAIInfo(teamList[t])
			local name = Spring.GetTeamLuaAI(teamList[t])
			if (name == "Bug: Easy" or name == "Bug: Normal" or name == "Bug: Hard" or name == "Bug: Insane") then
				spacebugsGame = true
			end
		end
	end
	
	-- init
	local missionName = Spring.GetModOptions().mission_name  -- name of scenario
	if (missionName == "none") then  --- here have to be this condition, onOption only dont work becouse C bool, second killed in mission
	    Spring.Echo("Team Com End ON")
	    allyTeamList = Spring.GetAllyTeamList()		
		for i=1,#allyTeamList do
		    allianceCommandersCount[i] 	= 0
			allianceMembersIDs[i] 		= {}
			destroyAlliance[i] 			= false
			local counter 				= 1
		    for j=1,#teamList do
			    local alliance = GetAllianceID(j-1)  --- minus one becouse teams from 0
				--Spring.Echo(i,alliance,j)
				if (alliance == i) then
				    allianceMembersIDs[i][counter] = j-1
				    --allianceCommandersCount[i] = allianceCommandersCount[i] + 1
					counter                        = counter + 1	
				end
			end
			--Spring.Echo(allianceCommandersCount[i])
		end
	else
	    Spring.Echo("Removing Team Com End")
	    gadgetHandler:RemoveGadget()
	end
end
