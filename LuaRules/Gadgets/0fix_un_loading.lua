GADGET_NAME = "0fix_un_loading"
UNLOAD_CHECK_FRAME = 20 -- speedup
FORMATION_SCALE_XZ_MIN = 7 -- formation size
FORMATION_SCALE_XZ_MAX = 13 -- formation size

-- HACKY SOLUTION
function gadget:GetInfo()
	return {
		name 		= GADGET_NAME,
		desc 		= "Fix colision spheres for transported units",
		author 		= "PepeAmpere",
		date 		= "2016/07/25",
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
attach.Module(modules, "mathExt")

-- non-standard include
include("LuaRules/Configs/noe/formations.lua")

local spSetUnitRadiusAndHeight = Spring.SetUnitRadiusAndHeight
local spGetUnitHeight = Spring.GetUnitHeight
local spGetUnitRadius = Spring.GetUnitRadius
local spGetUnitPosition = Spring.GetUnitPosition
-- local spSetUnitCollisionVolumeData = Spring.SetUnitCollisionVolumeData -- ( number unitID, number scaleX, number scaleY, number scaleZ, number offsetX, number offsetY, number offsetX, number vType, number tType, number Axis )
-- local spGetUnitCollisionVolumeData = Spring.GetUnitCollisionVolumeData

local airtransportsDefs = {
	["corbtrans"] = true,
	["corvalkii"] = true,	
}

airtransports = {}
unitsLoaded = {}
unitsSettings = {}
randomBasePosition = {0, 0}
formationScaleXZ = math.random(FORMATION_SCALE_XZ_MIN, FORMATION_SCALE_XZ_MAX)

function IsNearUnloadPos(x, y, z, x2, y2, z2, distanceSQLimit)
	local distanceSQ = GetDistance2DSQ(x, z, x2, z2)
	if (distanceSQ < distanceSQLimit) then
		return true
	end
	return false
end

function gadget:UnitLoaded(unitID, unitDefID, unitTeam, transportID, transportTeam)
	if (airtransports[transportID] == nil) then return end
	-- local scaleX, scaleY, scaleZ, offsetX, offsetY, offsetZ, volumeType, testType, primaryAxis, disabled = spGetUnitCollisionVolumeData(unitID)
	-- local isBlocking, isSolidObjectCollidable, isProjectileCollidable, isRaySegmentCollidable, crushable, blockEnemyPushing, blockHeightChanges = Spring.GetUnitBlocking(unitID)
	-- unitsSettings[unitID] = {scaleX, scaleY, scaleZ, offsetX, offsetY, offsetZ, volumeType, testType, primaryAxis, disabled}
	-- spSetUnitCollisionVolumeData(unitID, 0, 0, 0, 0, 0, 0, -1, 0, 0)
	local radius = spGetUnitRadius(unitID)
	local height = spGetUnitHeight(unitID)
	unitsSettings[unitID] = {radius, height}
	spSetUnitRadiusAndHeight(unitID, 0, 0)
	-- spSetUnitCollisionVolumeData(transportID, 0, 0, 0, 0, 0, 0, -1, 0, 0)
	-- spSetUnitRadiusAndHeight(transportID, 0, 0)
	-- Spring.SetUnitBlocking(unitID, false, false, false, false, false, false, false)
	-- Spring.SetUnitBlocking(transportID, false, false, false, false, false, false, false)
	-- Spring.UnitAttach(unitID, transportID, 1)
	airtransports[transportID][unitID] = true
	unitsLoaded[transportID] = unitsLoaded[transportID] + 1
end

function gadget:UnitUnloaded(unitID, unitDefID, unitTeam, transportID, transportTeam)
	-- if (unitsSettings[unitID] ~= nil) then
		-- local blockingData = unitsSettings[unitID]
		-- spSetUnitCollisionVolumeData(blockingData[1], blockingData[2], blockingData[3], blockingData[4], blockingData[5], blockingData[6], blockingData[7], blockingData[8], blockingData[9])
		-- Spring.SetUnitBlocking(unitID, blockingData[1], blockingData[2], blockingData[3], blockingData[4], blockingData[5], blockingData[6], blockingData[7])
	-- end
end

-- function gadget:UnitCommand(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOpts, cmdTag)
	
-- end

function gadget:UnitCreated(transportID, unitDefID)
	local name = UnitDefs[unitDefID].name
	if  (airtransportsDefs[name] ~= nil) then
		airtransports[transportID] = {}
		unitsLoaded[transportID] = 0
	end
end

function gadget:GameFrame(n)
	if ((n % UNLOAD_CHECK_FRAME) == 0) then
		for unitID, data in pairs(airtransports) do
			local commandQueue = Spring.GetUnitCommands(unitID)
			if (commandQueue ~= nil and commandQueue[1] ~= nil) then
				if (commandQueue[1].id == CMD.UNLOAD_UNITS) then
					local x, y, z = spGetUnitPosition(unitID)
					local params = commandQueue[1].params
					local closeEnough = IsNearUnloadPos(x, y, z, params[1], params[2], params[3], 20000)					
					if (closeEnough) then						
						-- deploy
						local unitsTable = airtransports[unitID]
						local referenceID
						local formationIndex
						for passangerID, _ in pairs (unitsTable) do
							referenceID = passangerID
							formationIndex = unitsLoaded[unitID]
							Spring.UnitDetach(passangerID)
							if (unitsSettings[passangerID] ~= nil) then
								spSetUnitRadiusAndHeight(passangerID, unitsSettings[passangerID][1], unitsSettings[passangerID][2])
							end
							unitsLoaded[unitID] = unitsLoaded[unitID] - 1
							break
						end
						
						if (airtransports[unitID][referenceID] ~= nil) then
							airtransports[unitID][referenceID] = nil
							local finalX = x + formationScaleXZ*formations.swarm[formationIndex][1] + randomBasePosition[1]
							local finalZ = z + formationScaleXZ*formations.swarm[formationIndex][2] + randomBasePosition[2]
							local finalY = Spring.GetGroundHeight(finalX, finalZ)
							
							Spring.GiveOrderToUnit(referenceID, CMD.MOVE, {finalX, finalY, finalZ}, {})
							
							if (formationIndex == 1) then -- if latest unit, update the base pos
								local newX, newZ = GetRandomPlaceAround(0, 0, 0, 100)
								randomBasePosition = {newX, newZ}
								formationScaleXZ = math.random(FORMATION_SCALE_XZ_MIN, FORMATION_SCALE_XZ_MAX)
							end
						end
					end

				end
			end
		end
	end
end