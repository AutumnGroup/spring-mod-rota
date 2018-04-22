GADGET_NAME = "unit_air_fuel"
FIND_NEW_PAD_FRAME = 30 -- speedup
HEALING_FRAME = 10 -- speedup ! hotfix
ADDING_PAD_FRAME = 6 -- speedup ! hotfix
HEALING_SPEED = 4 -- based on constant above it means 12HP/per second ! hotfix
FLYING_CHECKS_FRAME = 13 -- how ofter we check if the plane landing/isFlying
FORCED_PLANES_RETURN_FRAME = 60 -- how often we check if forced planes in case of no airpads will try to look for airpads

function gadget:GetInfo()
	return {
		name 		= GADGET_NAME,
		desc 		= "Control air units fuel usage consequences",
		author 		= "PepeAmpere",
		date 		= "2016/01/07",
		license 	= "notAlicense",
		layer 		= 1,
		enabled 	= true
	}
end

-- synced only
if (not gadgetHandler:IsSyncedCode()) then
	return false
end

-- get madatory module operators
include("LuaRules/modules.lua") -- modules table
include(modules.attach.data.path .. modules.attach.data.head) -- attach lib module

-- get other madatory dependencies
attach.Module(modules, "message")
attach.Module(modules, "mathExt")

-- attach message sender config
attach.File("LuaRules/modules/resources/data/api/messageSender.lua") -- source of mode change request message
-- attach custom reciever for our needs
attach.File("LuaRules/modules/resources/config/api/messageReceiverFuelGadget.lua") -- functions reacting on received messages

-- main data structures
planes = {}
pads = {} -- pad here is not one unit, it is each piece where some unit which need fuel can land
padsToBeAdded = {} -- pads on units currently beeing built, not finished yet
padUnitIDToPadNames = {} -- mapping to be able to identify all pads
commandsStorage = {} -- TABLE: key: unitID, value: commandQueue
planesWithBlockedOrders = {} -- TABLE: key: unitID, value: true, units which handles the user orders special way

-- "stages" helping lists and tables
planesWhichNeedToLand = {} -- TABLE: key: unitID, value: true, units which should receive order to land
planesWithReservations = {} -- TABLE: key: unitID, value: padName, to know where unit is registered right now, implicitly covers all planes which are landing
planesAttached = {} -- TABLE: key: unitID, value: padName, landed planes
planesWhichNeedToBeDetached = {} -- ARRAY: units which should be physically detached, cleared every iteration
planesOnMobilePads = {} -- TABLE: key: unitID, value: true, units which need to be repositioned
planesForcedToLand = {} -- TABLE: key: unitID, value: true, units which were forced to land because side had no pads - some kind of slow-update version of planesWhichNeedToLand table

-- stages:
-- planes which are candidates for landing but they do not have the reservation: planesWhichNeedToLand
-- planes which are are landing and have reservation: planesWithReservations
-- planes which failed to get reservation: planesForcedToLand
-- planes which already landed: planesAttached
-- planes which are landed and refueled: planesWhichNeedToBeDetached

PI = 3.14

-- we load that from shared folder to prevent overriding
include 'LuaRules/Configs/commandsIDs.lua'

-- HOTFIXES
local DETACH_IMPULSE_DISTANCE = { -- just helper to the physical simulation, detach impulse
	["armfig"] = 75,
	["armhell"] = 75,
	["armlance"] = 75,
	["armpnix"] = 75,
	["armthund"] = 75,
	["armtoad"] = 75,
	
	["armhawk"] = 75,
	["armwing"] = 100,
	["armblade"] = 75,
	["armbrawl"] = 50,
	["blade"] = 100,
	
	["armsfig"] = 75,
	["armseap"] = 75,
	
	["corevashp"] = 75,
	["corhurc"] = 75,
	["corshad"] = 75,
	["cortitan"] = 75,
	["corveng"] = 75,
	
	["corape"] = 75,
	["corerb"] = 75,
	["corgryp"] = 100,
	["corsbomb"] = 75,
	["corvamp"] = 75,
	
	["corseap"] = 75,
	["corsfig"] = 75,
}
local PRIMARY_BASE_UNITS = {
	-- towers
	["armbase"] = true,
	["corbase"] = true,
	
	-- commanders
	["armcom"] = true,
	["armcom2"] = true,
	["corcom"] = true,
	["corcom2"] = true,
	
	-- expansion
	["arm2veh"] = true,
	["arm2air"] = true,
	["arm2def"] = true,
	["arm2kbot"] = true,
	["armlvl2"] = true,
	["armnanotc"] = true,
}
local SECONDARY_BASE_UNITS = {
	["cor2air"] = true,
	["cor2def"] = true,
	["cor2kbot"] = true,
	["cor2veh"] = true,
	["corlvl2"] = true,
	["corntow"] = true,
	
	["armaap"] = true,
	["armalab"] = true,
	["armap"] = true,
	["armavp"] = true,
	["armhklab"] = true,
	["armhp"] = true,
	["armlab"] = true,
	["armshltx"] = true,
	["armvp"] = true,
	["armplab"] = true,

	["coraap"] = true,
	["coralab"] = true,
	["corap"] = true,
	["coravp"] = true,
	["corvp"] = true,
	["corgant"] = true,
	["corhp"] = true,
	["corlab"] = true,
	["corslab"] = true,
	["corvalkfac"] = true,
	["corplab"] = true,
	["armfff"] = true,
}

-- COMMANDS
local landCmd = {
	id = CMD_LAND_ON_AIRPAD,
	name = "Land",
	action = "land",
	cursor = 'Repair',
	type = CMDTYPE.ICON_UNIT,
	tooltip = "Land at a specific airpad",
	hidden = true,
}
local forceLandCmd = {
	id = CMD_FORCE_LAND,
	name = "ForceLand",
	action = "forceland",
	type = CMDTYPE.ICON,
	tooltip = "Enforces returning of the plane instantly",
}

-- NAME
local function CreatePadName(unitID, pieceID)
	return unitID .. pieceID
end

-- TYPE CHECK - temporary
function IsPlane(unitDefID)
	local name = UnitDefs[unitDefID].name
	
	local namesOfPlanes = {
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
	
	if (namesOfPlanes[name]) then
		return true
	else
		return false
	end
end
function IsPadUnit(unitDefID)
	local name = UnitDefs[unitDefID].name
	
	local namesOfUnitsWithPad = {
		["armasp"] = true,
		["corasp"] = true,
		
		["armap"] = true,
		["corap"] = true,
		
		["armarspd"] = true,
		
		["armcarry"] = true,
		["corcarry"] = true,
		["coraat"] = true,
		["corcrus"] = true,
		
		["armuwasp"] = true,
		["coruwasp"] = true,
	}
	
	if (namesOfUnitsWithPad[name] ~= nil) then
		return true
	else
		return false
	end
end
function GetAmphibiousTypeOfPlane(unitDefID)
	local name = UnitDefs[unitDefID].name
	
	local namesOfUWPlanes = {
		["armsfig"] = true,
		["corsfig"] = true,
		
		["armseap"] = true,
		["corseap"] = true,
	}
	
	if (namesOfUWPlanes[name] ~= nil) then
		return "water"
	else
		return "land"
	end
end
function GetAttachRadius(planeID, unitDefID) -- !hotfix only
	local name = UnitDefs[unitDefID].name
	
	local namesOfPlanesWithBadRadius = {
		["armsfig"] = true,
		["corsfig"] = true,
		
		["armseap"] = true,
		["corseap"] = true,
		
		["corveng"] = true,
		["armtoad"] = true,
	}
	
	if (namesOfPlanesWithBadRadius[name] ~= nil) then
		return Spring.GetUnitRadius(planeID) * 3
	else
		return Spring.GetUnitRadius(planeID)
	end
end

-- ADDING
function PrepareAddPad(padUnitID, padUnitDefID, pieceID, static, transferRate, amphibiousType)
	local posX, posY, posZ = Spring.GetUnitPiecePosDir(padUnitID, pieceID)
	local padName = CreatePadName(padUnitID, pieceID)
	
	-- pads are added to temporary structure where they wait for beeing added once unit (holding the pad(s)) construction is finished
	padsToBeAdded[padName] = {
		unitID = padUnitID,
		unitDefID = padUnitDefID,
		pieceID = pieceID,
		teamID = Spring.GetUnitTeam(padUnitID),
		static = static,
		position = {posX, posY, posZ},
		transferRate = transferRate,
		amphibiousType = amphibiousType,
		occupied = false,
		reservations = {},
	}
	
	return padName
end
function AddAllPadsOnUnit(padUnitID, padUnitDefID, unitDefData, resourceData)
	local pieceMap = Spring.GetUnitPieceMap(padUnitID)
	local listOfNewPads = {}
	
	for pieceName, pieceID in pairs(pieceMap) do
		if (string.find(pieceName, "landpad")) then -- thats keyword for model "piece" whic is used for all land spots
			listOfNewPads[#listOfNewPads + 1] = PrepareAddPad(padUnitID, padUnitDefID, pieceID, unitDefData.isBuilding, resourceData.teamToUnitTransferRate, "land")
		elseif (string.find(pieceName, "waterpad")) then -- thats keyword for model "piece" whic is used for all water (not necessary mean underwater) spots
			listOfNewPads[#listOfNewPads + 1] = PrepareAddPad(padUnitID, padUnitDefID, pieceID, unitDefData.isBuilding, resourceData.teamToUnitTransferRate, "water")
		end
	end
	
	padUnitIDToPadNames[padUnitID] = {}
	padUnitIDToPadNames[padUnitID] = listOfNewPads
end
function AddPlane(planeID, planeUnitDefID, receiveRate, amphibiousType)
	local newMode = "landed" -- once unit is created, it is landed
	planes[planeID] = {
		unitID = planeID,
		unitDefID = planeUnitDefID,
		teamID = Spring.GetUnitTeam(planeID),
		receiveRate = receiveRate,
		attachRadius = GetAttachRadius(planeID, planeUnitDefID),
		amphibiousType = GetAmphibiousTypeOfPlane(planeUnitDefID),
		mass = UnitDefs[planeUnitDefID].mass,
		landed = false,
		resSimulationMode = newMode, 
	}
	
	-- make sure the change is propagated
	sendCustomMessage.resources_unitResourceModeChanged(planeID, planeUnitDefID, "hydrocarbons", newMode)
end

-- SEARCH 
function FindPad2(planeID, maxReservationLevel, goodDistance)
	local bestPadName
	local bestPadReservationLevel
	local bestScore = math.huge
	
	local function CalculatePadScore(distance, reservationLevel, goodDistance)
		local score = distance * (reservationLevel+1)
		if (distance > goodDistance) then score = score * (0.1 + distance/goodDistance) end
		return score
	end

	for padName, padData in pairs(pads) do
		if (Spring.AreTeamsAllied(planes[planeID].teamID, padData.teamID)) then -- at least allies
			local notLandOnUW = not ((planes[planeID].amphibiousType == "land") and (padData.amphibiousType == "water")) -- land-plane not landing uwpad, other combinations are OK
			if (notLandOnUW) then -- TBD, one day we can improve this so uw pads above water level are still available
				local reservationsCount = #(padData.reservations)
				if (not padData.occupied and (reservationsCount <= maxReservationLevel)) then -- TBD later we can calculate some score from distance and reservation level	
					local distance = Spring.GetUnitSeparation(planeID, padData.unitID)
					local padScore = CalculatePadScore(distance, reservationsCount, goodDistance)
					if (padScore < bestScore) then
						bestPadReservationLevel = reservationsCount
						bestPadName = padName
						bestScore = padScore					
					end
				end
			end
		end
	end
	
	return bestPadName, bestPadReservationLevel, bestScore
end
function FindAndReserve2(planeID, maxReservationLevel, goodDistance)
	local foundPadName, reservationLevel = FindPad2(planeID, maxReservationLevel, goodDistance)
	if (foundPadName ~= nil) then
		-- in case we already have some reservation
		if (planesWithReservations[planeID] ~= nil) then
			CancelReservation(planeID)
		end
		
		-- enable giving orders
		planesWithBlockedOrders[planeID] = nil
		
		-- remove all orders
		local commandQueue = Spring.GetUnitCommands(planeID)
		if (commandQueue ~= nil) then
			for i=1, #commandQueue do
				Spring.GiveOrderToUnit(planeID, CMD.REMOVE, {i, commandQueue[i].tag}, {"alt"})
			end
		end
		
		-- and perform new reservation and related stuff
		if (reservationLevel == 0) then -- land on pad
			-- Spring.GiveOrderToUnit(planeID, CMD.INSERT, {0, CMD_LAND_ON_AIRPAD, 0, pads[foundPadName].unitID}, {"alt"}) -- to override allowCommmand
			Spring.GiveOrderToUnit(planeID, CMD.INSERT, {0, CMD_LAND_ON_AIRPAD, 0, pads[padName]}, {"alt"}) --? wrong by intent? :)
			CreateReservation(planeID, foundPadName)
		else -- if you are not the first, just move on the position of the pad
			local padX, padY, padZ = GetPadPosition(pads[foundPadName])
			--Spring.SetUnitLandGoal(planeID, padX + math.cos(reservationLevel*PI)*50, padY, padZ + math.sin(reservationLevel*PI)*50, 100)
			--Spring.GiveOrderToUnit(planeID, CMD.INSERT, {0, CMD.MOVE, 0, padX + math.cos(reservationLevel*PI)*50, padY, padZ + math.sin(reservationLevel*PI)*50}, {"alt"}) -- to override allowCommmand
			Spring.GiveOrderToUnit(planeID, CMD.MOVE, {padX, padY, padZ},{"alt"})
			CreateReservation(planeID, foundPadName)
		end
		
		-- disable giving orders
		planesWithBlockedOrders[planeID] = true
		
		return true
	end
	return false -- to avoid playing without airpads :)
end
function FindBasePos(planeID) -- this is not called very offten so it does not need to optimized
	local allUnits = Spring.GetAllUnits()
	local spGetUnitDefID = Spring.GetUnitDefID
	local spGetUnitTeam = Spring.GetUnitTeam
	local spAreTeamsAllied = Spring.AreTeamsAllied
	
	-- first search in primary list
	for i=1, #allUnits do
		local unitDefID = spGetUnitDefID(allUnits[i])
		local unitName = UnitDefs[unitDefID].name
		if (spAreTeamsAllied(planes[planeID].teamID, spGetUnitTeam(allUnits[i]))) then
			if (PRIMARY_BASE_UNITS[unitName] ~= nil) then
				local posX, posY, posZ = Spring.GetUnitPosition(allUnits[i])
				local randX, randZ = GetRandomPlaceAround(posX, posZ, 100, 500) -- mathExt.lua
				return randX, Spring.GetGroundHeight(randX, randZ), randZ
			end
		end
	end
	
	-- now search in secondary list
	for i=1, #allUnits do
		local unitDefID = spGetUnitDefID(allUnits[i])
		local unitName = UnitDefs[unitDefID].name
		if (spAreTeamsAllied(planes[planeID].teamID, spGetUnitTeam(allUnits[i]))) then
			if (SECONDARY_BASE_UNITS[unitName] ~= nil) then
				local posX, posY, posZ = Spring.GetUnitPosition(allUnits[i])
				local randX, randZ = GetRandomPlaceAround(posX, posZ, 100, 500) -- mathExt.lua
				return randX, Spring.GetGroundHeight(randX, randZ), randZ
			end
		end
	end
	
	-- if both failed, land instantly
	local posX, posY, posZ = Spring.GetUnitPosition(planeID)
	return posX, posY, posZ
end
function LandOnSafePosition(planeID) -- get some safe position to land nearby if there are no pads
	local baseX, baseY, baseZ = FindBasePos(planeID)
	Spring.GiveOrderToUnit(planeID, CMD.MOVE, {baseX, baseY, baseZ},{"alt"})
	planesForcedToLand[planeID] = true -- this implicitly blocks unit to get any command, important to have it "after" order to land :)
end

function GetPadPosition(padData)
	local padX, padY, padZ 
	if (padData.static) then -- use already calculated position
		padX, padY, padZ = padData.position[1], padData.position[2], padData.position[3]
	else
		padX, padY, padZ = Spring.GetUnitPiecePosDir(padData.unitID, padData.pieceID)
	end
	return padX, padY, padZ
end

-- MODE INFO
function UpdateSimulationMode(planeID, newMode) -- local duplication of the mode
	planes[planeID].resSimulationMode = newMode
end

-- RESERVATIONS
function CreateReservation(planeID, padName)
	-- update pads data
	local thisPadReservations = pads[padName].reservations
	thisPadReservations[#thisPadReservations + 1] = planeID
	pads[padName].reservations = thisPadReservations
	
	-- updata mapping
	planesWithReservations[planeID] = padName
	
	-- remove from list of waiting planes
	planesWhichNeedToLand[planeID] = nil
end
function CancelReservation(planeID)
	-- get info
	local padName = planesWithReservations[planeID]
	
	if (padName == nil) then
		-- Spring.Echo("[WARNING][" .. GADGET_NAME .. "] > CancelReservation(): attempt to remove reservation for planeID " .. planeID .. " which had no reservation.")
		return false
	end
	
	-- update pads data
	local oldPadReservations = pads[padName].reservations
	local newPadReservations = {}
	local counter = 0
	for i=1, #oldPadReservations do
		if (oldPadReservations[i] ~= planeID) then -- copy all except the removed ones
			counter = counter + 1
			newPadReservations[counter] = oldPadReservations[i]
		end
	end
	pads[padName].reservations = newPadReservations
	
	-- update mapping
	planesWithReservations[planeID] = nil
end
function CancelAllReservations(padName)
	local padReservations = pads[padName].reservations
	for i=1, #padReservations do
		planesWithReservations[padReservations[i]] = nil
	end
	pads[padName].reservations = nil
end
function GetReservationPadName(planeID)
	local padName = planesWithReservations[planeID] -- if flying	
	if (padName == nil) then
		padName = planesAttached[planeID] -- if check during the attachment
	end
	return padName -- if nil, then nil ;)
end
function GetReservationIndex(planeID)
	local padName = GetReservationPadName(planeID)
	
	if (padName == nil) then
		return -1
	end
	
	local padReservations = pads[padName].reservations
	for i=1, #padReservations do
		if (padReservations[i] == planeID) then
			return i
		end
	end
	
	planesWithReservations[planeID] = nil -- obviously not valid
	Spring.Echo("[ERROR][" .. GADGET_NAME .. "] > GetReservationIndex() - the plane has padName in planesWithReservations table but it is not in the array of the reservations of given pad")
	return -1 -- unit is not in the array
end

-- OCCUPATION
function OccupyPad(planeID, padName) 
	-- unitID of the unit occupying the pad is the first unit in reservations array
	pads[padName].occupied = true
	planes[planeID].landed = true
	planesAttached[planeID] = padName
	CheckModeChange(planeID, planes[planeID].resSimulationMode, 1, 2, "true", "OccupyPad")
	CancelReservation(planeID) -- it has to be the last
end
function RemoveOccupation(planeID)
	local padName = planesAttached[planeID]
	pads[padName].occupied = false
	planes[planeID].landed = false
	planesAttached[planeID] = nil
end
function IsOccupied(padName)
	return pads[padName].occupied 
end

-- LANDING
function CanLandOnUnit(planeID, padUnitID)
	if (padUnitIDToPadNames[padUnitID] == nil or planes[planeID] == nil) then -- in case of some shity input
		-- Spring.Echo("[WARNING][" .. GADGET_NAME .. "] > CanLandOnUnit() - planeID or padUnitID is not registered")
		return false
	end
	
	local padTeamID = Spring.GetUnitTeam(padUnitID)
	if (not Spring.AreTeamsAllied(planes[planeID].teamID, padTeamID)) then -- we do not want to land on the enemy pads
		return false
	end
	
	local padNames = padUnitIDToPadNames[padUnitID]
	
	for i=1, #padNames do
		local thisPadName = padNames[i]
		if (not pads[thisPadName].occupied) then
			local thisPadReservations = pads[thisPadName].reservations
			if (#thisPadReservations == 0) then
				return true, thisPadName
			end
		end
	end
	
	return false
end
function CanLandOnPad(planeID, padName)
	if (pads[padName] == nil) then -- in case of destroyed pad
		return false
	end
	
	if (not Spring.AreTeamsAllied(planes[planeID].teamID, pads[padName].teamID)) then -- we do not want to land on the enemy pads
		return false
	end
	
	if (pads[padName].occupied == true) then
		return false
	end
	
	return true
end
function IsLanded(planeID)
	return planes[planeID].landed
end
function UpdateLanded(planeID, landed)
	planes[planeID].landed = landed
end
function IsFlying(planeID, flyDistanceFromSurface)
	local posX, posY, posZ = Spring.GetUnitBasePosition(planeID)
	local groundY = Spring.GetGroundHeight(posX, posZ)
	local absDistanceFromTheSurface = math.abs(posY - groundY)
	
	if (absDistanceFromTheSurface > flyDistanceFromSurface) then
		return true -- I fly!
	else
		return false
	end
end

function NeedRepair(planeID)
	local health, maxHealth = Spring.GetUnitHealth(planeID)
	local autoRepairLevel = Spring.GetUnitStates(planeID).autorepairlevel -- i saw it on the forum :)
	if (health < maxHealth * autoRepairLevel) then
		return true
	else
		return false
	end
end

-- REFUELING
function StartRefueling(planeID, padName)
	-- noone can even try to land there
	local padData = pads[padName]
	Spring.UnitAttach(padData.unitID, planeID, padData.pieceID)
	OccupyPad(planeID, padName)
end
function FinishRefueling(planeID)	
	Spring.UnitDetach(planeID)
	RemoveOccupation(planeID)
end

-- REMOVING
function RemovePad(padName)
	if (pads[padName] == nil) then -- the unit was not completed yet seems
		padsToBeAdded[padName] = nil
		return
	end
	
	if IsOccupied(padName) then
		local padReservations = pads[padName].reservations
		FinishRefueling(padReservations[1])	
	end
	CancelAllReservations(padName)
	pads[padName] = nil
end
function RemovePlane(planeID)
	if (planes[planeID] == nil) then return false end -- in case we already removed that in critical physical sim code (gadet:gameframe)
	
	CancelReservation(planeID)
	if (planesAttached[planeID] ~= nil) then 
		RemoveOccupation(planeID)
	end
	UpdateLanded(planeID, false)
	
	-- make sure it is deleted
	planesWhichNeedToLand[planeID] = nil
	planesWithReservations[planeID] = nil
	planesAttached[planeID] = nil
	planesOnMobilePads[planeID] = nil
	planesForcedToLand[planeID] = nil
	planes[planeID] = nil
	
	return true
end

-- SITUATION HANDLERS
function CheckAddingPlane(unitID, unitDefID, resourceData)
	if (IsPlane(unitDefID)) then
		AddPlane(unitID, unitDefID, resourceData.teamToUnitTransferRate)
	end
end
function CheckAddingPad(unitID, unitDefID, resourceData)
	if (IsPadUnit(unitDefID)) then
		AddAllPadsOnUnit(unitID, unitDefID, UnitDefs[unitDefID], resourceData)
	end
end
function CheckRemovingPlane(unitID, unitDefID)
	if (IsPlane(unitDefID)) then
		RemovePlane(unitID, UnitDefs[unitDefID], resourceData)
	end
end
function CheckRemovingPad(unitID, unitDefID)
	if (IsPadUnit(unitDefID)) then
		local listOfPadNames = padUnitIDToPadNames[unitID]
		for i=1, #listOfPadNames do
			RemovePad(listOfPadNames[i])
		end
		padUnitIDToPadNames[unitID] = nil
	end
end

-- @description the core of the mode changing logic
-- @comment message for changing modes is defined inside of module resources
-- @comment given mode is defined in resourcesModes.lua, custom patch for resource module
function CheckModeChange(planeID, currentMode, currentFuel, maxFuel, shortage, debugContext)
	if (planeID == nil) then return end -- hotfix https://trello.com/c/30NxLMtd/

	local newMode = currentMode
	if     (currentMode == "default") then -- flying
		-- lost last fuel
		if (shortage) then
			newMode = "flyingNoFuel"
			planesWhichNeedToLand[planeID] = true
		elseif (not IsFlying(planeID, 15)) then
			newMode = "landed"
		end
	elseif (currentMode == "refueling") then		
		-- finsihed refueling
		if (currentFuel == maxFuel) then
			planesWhichNeedToBeDetached[#planesWhichNeedToBeDetached + 1] = planeID
			newMode = "default"
		end
		
		-- interrupted refueling
		-- if (not planesAttached[planeID]) then 
			-- if (shortage) then
				-- newMode = "flyingNoFuel"
				-- planesWhichNeedToLand[planeID] = true
			-- else
				-- newMode = "default"
			-- end
		-- end

	elseif (currentMode == "flyingNoFuel") then
		-- until gets to place for refuel
		local reservedPadName = planesAttached[planeID]
		if (reservedPadName ~= nil and IsOccupied(reservedPadName) and (GetReservationIndex(planeID) == 1) and (IsLanded(planeID))) then -- attached by other words
			newMode = "refueling"
		end
		
		-- tbd check force landing (if for some reason was removed)
	elseif (currentMode == "landed") then
		-- lost last fuel
		if (shortage) then
			newMode = "flyingNoFuel"
			planesWhichNeedToLand[planeID] = true
		elseif (IsFlying(planeID, 15)) then
			newMode = "default"
		end		
	else
		Spring.Echo("[ERROR][" .. GADGET_NAME .. "] > CheckModeChange() - the plane is in some invalid fuel simulation mode")
	end
	
	-- set choosen mode
	if (newMode ~= currentMode) then
		-- save commandqueue if we land
		if (newMode == "flyingNoFuel") then
			local commandQueue = Spring.GetUnitCommands(planeID)
			commandsStorage[planeID] = commandQueue -- store it for later
			planesWithBlockedOrders[planeID] = true
		end
	
		-- do the change locally 
		UpdateSimulationMode(planeID, newMode)
		
		-- propagate the change outside
		if (newMode ~= "refueling") then -- any other mode
			sendCustomMessage.resources_unitResourceModeChanged(planeID, planes[planeID].unitDefID, "hydrocarbons", newMode)
		else -- specific mode change "refueling" attaching extra data
			local reservedPadName = planesWithReservations[planeID]
			sendCustomMessage.resources_unitResourceModeChanged(planeID, planes[planeID].unitDefID, "hydrocarbons", newMode, pads[reservedPadName]) -- adding pad data as a partner unit
		end		
	end	
end

-- SPRING EVENT HANDLERS
function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
	if cmdID == CMD_LAND_ON_AIRPAD then
		local padUnitID = cmdParams[1]
		return CanLandOnUnit(unitID, padUnitID)
	end
	
	-- we pass next just microAI settings order always
	if (cmdID == CMD.AUTOREPAIRLEVEL or cmdID == CMD.IDLEMODE or cmdID == CMD.LOOPBACKATTACK or cmdID == CMD.FIRE_STATE or cmdID == CMD.MOVE_STATE or cmdID == CMD.ONOFF or cmdID == CMD.CLOAK or cmdID == CMD.SELFD or cmdID == CMD.REPEAT or cmdID == CMD.TRAJECTORY) then
		return true
	end
	
	-- filter commands not related to verified planes
	if (planes[unitID] ~= nil) then
		--[[ if plane is:
			* going to refuel
			* refueling
			* there is no airpad
			then
			=> store it externally
			=> dont let it pass
		]]--
		--if (((planesForcedToLand[unitID] ~= nil) or (planesWithReservations[unitID] ~= nil) or (planesAttached[unitID] ~= nil)) and cmdID ~= CMD.INSERT) then
		if (planesWithBlockedOrders[unitID] ~= nil) then
			local newCommand = {
				id = cmdID,
				params  = cmdParams,
				options = cmdOptions,
			}
			local commandQueue
			
			-- add or replace?
			if (cmdOptions.shift or cmdID == CMD.SET_WANTED_MAX_SPEED) then -- add (+ engine hidden orders HACK)
				commandQueue = commandsStorage[unitID]
				if (commandQueue ~= nil) then
					commandQueue[#commandQueue + 1] = newCommand
				else
					commandQueue = {
						[1] = newCommand
					}
				end
			else -- replace
				commandQueue = {
					[1] = newCommand
				}
			end

			-- store it
			commandsStorage[unitID] = commandQueue
			
			-- FOR SURE IGNORE NOW
			return false
		end
	end
	
	return true
end

function gadget:CommandFallback(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
	-- manual land order
	if (cmdID == CMD_LAND_ON_AIRPAD) then
		-- if already landed, stop
		if (planesAttached[unitID]) then
			return true, true
		end
		
		-- throw away old reservation
		CancelReservation(unitID)

		local padUnitID = cmdParams[1]
		local canLand, freePadName = CanLandOnUnit(unitID, padUnitID)

		-- not possible to land there
		if (not canLand) then
			return true, true
		end

		-- if passed to here, update
		CreateReservation(unitID, freePadName)
		return true, false
	end
	
	-- forced landing
	if (cmdID == CMD_FORCE_LAND) then
		planesWhichNeedToLand[planeID] = true
		return true, true
	end

	return false
end

function gadget:UnitCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
	-- in case it is not registered plane, exit
	if (planes[unitID] == nil) then
		return
	end
	
	if (planesAttached[planeID]) then
		FinishRefueling(planeID)
	end
end

-- ? new units comming to the system are handled via messages, look into messageReceiverFuelGadget.lua
-- function gadget:UnitCreated(unitID, unitDefID, unitTeamID, builderID) end

-- handling:
-- * adding new unit into system (init)
-- * changes in fuel storages of the units
-- * personal unit stall
function gadget:RecvLuaMsg(msg, playerID)
	message.Receive(msg, playerID) -- using messageReceiver data structure
end

-- handling:
-- * planes which needs repair
-- * giving orders to planes which have reservation
-- * search for pads and creating reservations
function gadget:GameFrame(n)
	-- adding completed units pads
	if ((n % ADDING_PAD_FRAME) == 0) then
		local spGetUnitHealth = Spring.GetUnitHealth
		local padNamesToRemove = {}
		for padName, padData in pairs(padsToBeAdded) do
			local _, _, _, _, buildProgress = spGetUnitHealth(padData.unitID)
			if (buildProgress > 0.99) then
				pads[padName] = padData
				padNamesToRemove[#padNamesToRemove + 1] = padName
			end
		end
		for i=1, #padNamesToRemove do
			padsToBeAdded[padNamesToRemove[i]] = nil
		end
	end

	-- update a list of planes which need to land by planes which need to be repaired
	for unitName, unitData in pairs(planes) do
		local planeID = unitData.unitID
		
		-- to be sure first check dead planes ;)
		local isDead = Spring.GetUnitIsDead(planeID)
		if (isDead == true) then
			-- perform premature deletion
			RemovePlane(planeID)
		end
		
		-- in case of plane needs repair
		if ((unitData.resSimulationMode ~= "refueling") and (unitData.resSimulationMode ~= "landed")) then -- first filter all landed
			if ((not planesWithReservations[planeID]) and (not planesWhichNeedToLand[planeID]) and NeedRepair(planeID)) then
				planesWhichNeedToLand[planeID] = true
			end
		end
		
		-- run the check mode in case of we no longer fly
		if ((n % FLYING_CHECKS_FRAME) == 0) then
			CheckModeChange(planeID, unitData.resSimulationMode, 1, 2, false, "FLYING_CHECKS_FRAME")
		end
	end
	
	-- iterate over all planes with reservations and recall the landing order
	for planeID, padName in pairs(planesWithReservations) do
		local reservationIndex = GetReservationIndex(planeID)
		if (reservationIndex == 1 and CanLandOnPad(planeID, padName)) then -- if more, you have just move order, so wait
			
			local padData = pads[padName]
			
			 -- get position of the pad piece
			local padX, padY, padZ = GetPadPosition(padData)
			
			-- get position of the plane
			local planeX, planeY, planeZ = Spring.GetUnitPosition(planeID) 
			-- get attachRadius of the plane

			local planeData = planes[planeID]
			local attachRadius = planeData.attachRadius 
			
			local distanceSQ = GetDistance3DSQ(padX, padY, padZ, planeX, planeY, planeZ)
			
			-- if close enough, attach the unit
			if (distanceSQ < (10 * attachRadius * attachRadius)) then
				-- enable giving orders			--
				planesWithBlockedOrders[planeID] = nil
				
				--Spring.GiveOrderToUnit(planeID, CMD.WAIT,{},{})				
				Spring.GiveOrderToUnit(planeID, CMD.STOP,{},{})
				
				-- disable giving orders
				planesWithBlockedOrders[planeID] = true
				
				StartRefueling(planeID, padName)
			else -- otherwise update the goal
				Spring.SetUnitLandGoal(planeID, padX, padY, padZ, attachRadius)
			end
		elseif ((reservationIndex > 1) and ((n % FIND_NEW_PAD_FRAME) == 0)) then -- if more, you have just move order, so wait and sometimes try to find better
			FindAndReserve2(planeID, 2, 4000, 2000)
		end
	end
	
	-- finally send commands to units which need to land
	local unitsToBeForced = {}
	for planeID, _ in pairs(planesWhichNeedToLand) do
		local success = FindAndReserve2(planeID, 4, 100000, 500)
		
		if (not success) then -- important! we cannot let them fly even if there is no airpad around, otherwise they would not make any airpads :)
			planesWhichNeedToLand[planeID] = nil
			unitsToBeForced[#unitsToBeForced + 1] = planeID
		end
	end
	
	-- transfer units from needToLand to ForceToLand
	for i=1, #unitsToBeForced do
		local planeID = unitsToBeForced[i]
		LandOnSafePosition(planeID)
	end
	
	if ((n % FORCED_PLANES_RETURN_FRAME) == 0) then -- give then chance to return back
		for planeID, _ in pairs(planesForcedToLand) do
			local success = FindAndReserve2(planeID, 4, 100000, 500)
			
			if (success) then 
				planesForcedToLand[planeID] = nil -- other assignments are done as part of FindAndReserve2 function
			end
		end
	end
	
	-- physically detach all planes
	for i=1, #planesWhichNeedToBeDetached do
		local planeID = planesWhichNeedToBeDetached[i]
		local padName = planesAttached[planeID]
		local planeData = planes[planeID]
		
		FinishRefueling(planeID)

		-- Spring.GiveOrderToUnit(planeID, CMD.WAIT,{},{}) -- !! it has to be AFTER finishing refueling, because any coommand except move is blocked
		
		-- hotfix1
		-- physical fix to make sure unit do not jump under the pad
		local padX, padY, padZ = GetPadPosition(pads[padName])
		local unitX, unitY, unitZ = Spring.GetUnitPosition(planeID)
		
		--Spring.SetUnitPosition(planeID, unitX, unitY+20, unitZ)
		
		local detachVelocityImpulse = 2
		local detachImpulseDistance = DETACH_IMPULSE_DISTANCE[UnitDefs[planeData.unitDefID].name] or 75

		Spring.SetUnitPhysics(planeID,
			unitX, unitY+detachImpulseDistance, unitZ,
			0,  detachVelocityImpulse,  0,
			0, 0, 0,
			0, 0, 0
		)
		--Spring.AddUnitImpulse(planeID, 0, detachVelocityImpulse, 0)
		--Spring.SetUnitVelocity(planeID, 0, detachVelocityImpulse, 0)

		-- enable giving orders
		planesWithBlockedOrders[planeID] = nil
		
		-- hotfix2
		-- in case of zero orders, plane should fly away (otherwise it fall inside of the unit)		
		local commandQueue = commandsStorage[planeID]
		if (commandQueue == nil) then
			Spring.GiveOrderToUnit(planeID, CMD.MOVE, {unitX+200, unitY+200, unitZ+200},{"alt"})
		else
			Spring.GiveOrderToUnit(planeID, CMD.MOVE, {unitX+50, unitY+200, unitZ+50},{"alt"})
			for i=1, #commandQueue do
				commandQueue[i].options.shift = true
				Spring.GiveOrderToUnit(planeID, commandQueue[i].id, commandQueue[i].params, commandQueue[i].options)
			end
		end
	end
	planesWhichNeedToBeDetached = {}
	
	--hofix healing
	if ((n % HEALING_FRAME) == 0) then
		local spGetUnitHealth = Spring.GetUnitHealth
		local spSetUnitHealth = Spring.SetUnitHealth
		local GetMin = math.min
		for planeName, padName in pairs(planesAttached) do
			local planeID = tonumber(planeName)
			local currentHealth, maxHealth = spGetUnitHealth(planeID)
			if (currentHealth < maxHealth) then
				spSetUnitHealth(planeID, GetMin(currentHealth + HEALING_SPEED, maxHealth))
			end
		end
	end
	
	-- for planeID, planeData in pairs(planes) do
		-- Spring.Echo("endframe: ", n ,planesAttached[planeID], planeData.resSimulationMode, planeData.landed, planesWithReservations[planeID])
	-- end
end

-- this is needed for fast unit removal (faster than message)
function gadget:UnitDestroyed(unitID, unitDefID, unitTeamID, attackerID, attackerDefID, attackerTeamID) 
	CheckRemovingPlane(unitID, unitDefID)
	CheckRemovingPad(unitID, unitDefID)
end
