-- hotfix

function gadget:GetInfo()
	return {
		name      = "0fix_feature",
		desc      = "Fix health and spheres of corpses on battlefield",
		author    = "PepeAmpere",
		date      = "Oct 7, 2013",
		license   = "notAlicense",
		layer     = 0,
		enabled   = true  --  loaded by default?
	}
end

-- synced only
if (not gadgetHandler:IsSyncedCode()) then
	return false
end

include "LuaRules/Configs/fix_defs.lua"
include "LuaRules/Configs/constants.lua"

local spGetFeatureCollisionVolumeData = Spring.GetFeatureCollisionVolumeData
local spSetFeatureCollisionVolumeData = Spring.SetFeatureCollisionVolumeData

local spGetFeatureDefID = Spring.GetFeatureDefID
local spGetFeatureHealth = Spring.GetFeatureHealth	
local spSetFeatureHealth = Spring.SetFeatureHealth

local spSetFeatureRadiusAndHeight = Spring.SetFeatureRadiusAndHeight
local spGetUnitCollisionVolumeData = Spring.GetUnitCollisionVolumeData	
local spGetUnitHeight = Spring.GetUnitHeight
local spGetUnitRadius = Spring.GetUnitRadius

local unitCollisionData = {}
local deadUnitData = {}
local unitHealth = {}
local gameStarted = false

-- CUSTOM
local FEATURE_HEALTH_MULTIPLIER = constants.FEATURE_HEALTH_MULTIPLIER
local features = {}

function gadget:FeatureCreated(featureID, allyTeam)
	if (gameStarted) then
		local defID = spGetFeatureDefID(featureID)
		local featureName = FeatureDefs[defID].name
		local thisUnitData = deadUnitData[featureName]
		
		if (thisUnitData ~= nil) then
			--spSetFeatureHealth(featureID, oldHealth * FEATURE_HEALTH_MULTIPLIER)
			--local oldHealth = spGetFeatureHealth(featureID)
			--local wantedHealth = thisUnitData.health * FEATURE_HEALTH_MULTIPLIER
			--Spring.SetFeatureMaxHealth(featureID, wantedHealth)
			--Spring.SetFeatureHealth(featureID, wantedHealth)
			--local newHealth = spGetFeatureHealth(featureID)
			--Spring.Echo(featureName, thisUnitData.health, oldHealth, "=>", wantedHealth, "=>", newHealth)
			
			-- HEALTH FIXED IN POSTDEFS
			
			if (FeatureDefs[defID]["tooltip"] == "Wreckage") then
				local isDead = string.find(featureName,"_dead") 
				if (isDead ~= nil) then
					-- local nameOfUnit = string.sub(name,1,isDead-1)
					-- local parentUnit = UnitDefNames[nameOfUnit]
					
					if (unitCollisionData[featureName] ~= nil) then
						local c = unitCollisionData[featureName]
						-- Spring.Echo(featureID,c[1],c[2],c[3],c[4],c[5],c[6],c[7],c[8],c[9])
						spSetFeatureCollisionVolumeData(featureID,c[1],c[2],c[3],c[4],c[5],c[6],c[7],c[8],c[9])
					end
					
					-- Spring.Echo(nameOfUnit, featureID,unitModelData[nameOfUnit][1],unitModelData[nameOfUnit][2])
					-- Spring.Echo(featureID, thisUnitData.radius,thisUnitData.height)
					spSetFeatureRadiusAndHeight(featureID, thisUnitData.radius,thisUnitData.height)
					
					-- HOTFIX make it less blocking
					Spring.SetFeatureBlocking(featureID, false, true, true, true, true, true, false)
				end
				
				local isHeap = string.find(featureName,"_heap")
				if (isHeap) then
					spSetFeatureCollisionVolumeData(featureID,40,10,40,0,0,0,2,0,0)
				end
				
				--Spring.SetFeatureBlocking(featureID, false, false, true, true, true, false, false)
			end
		end		
	end
	features[#features + 1] = featureID
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam)
	-- EXPERIMENTAL
	-- local oldHealth = Spring.GetUnitHealth(unitID)
	-- Spring.SetUnitMaxHealth(unitID, oldHealth*20)
	-- Spring.SetUnitHealth(unitID, oldHealth * 20)
	-- local newHealth = Spring.GetUnitHealth(unitID)
	-- Spring.Echo("unit", oldHealth, newHealth)
	

    local name = UnitDefs[unitDefID].name
	
	-- save data about model values for given unitDef
	-- ! so dont work for features which parent unit was not in game yet
	local wreckName = UnitDefs[unitDefID].wreckName
	if(deadUnitData[wreckName] == nil) then
		local radius = spGetUnitRadius(unitID)
		local height = spGetUnitHeight(unitID)
		
		-- use special values if defined in fix_def.lua
		if (newRadiusAndHeight[name] ~= nil) then
			radius = newRadiusAndHeight[name][1]
			height = newRadiusAndHeight[name][2]
		end
		
		deadUnitData[wreckName] = {
			radius = radius,
			height = height,
			health = UnitDefs[unitDefID].health
		}
		
		-- save data about collision values for given unitDef
		if(unitCollisionData[wreckName] == nil) then
			local scaleX, scaleY, scaleZ, offsetX, offsetY, offsetZ, volumeType, testType, primaryAxis, disabled = spGetUnitCollisionVolumeData(unitID)
			unitCollisionData[wreckName] = {scaleX, scaleY, scaleZ, offsetX, offsetY, offsetZ, volumeType, testType, primaryAxis, disabled}
		end	
	end	
end

function gadget:GameFrame(n)
	if (n == 0) then
		gameStarted = true
	end
	-- for k,featureID in pairs (features) do
		-- local health = Spring.GetFeatureHealth(featureID)
		-- Spring.SetFeatureHealth(featureID, health + 1)
		-- health = Spring.GetFeatureHealth(featureID)
		-- Spring.Echo(health)
	-- end
end

-- for testing purposes --

-- Spring.Echo("----------",FeatureDefs[defID]["name"],"----------")
-- Spring.Echo("blocking",FeatureDefs[defID]["blocking"])
-- Spring.Echo("burnable",FeatureDefs[defID]["burnable"])
-- Spring.Echo("destructable",FeatureDefs[defID]["destructable"])
-- Spring.Echo("drawType",FeatureDefs[defID]["drawType"])
-- Spring.Echo("drawTypeString",FeatureDefs[defID]["drawTypeString"]) 
-- Spring.Echo("energy",FeatureDefs[defID]["energy"])
-- Spring.Echo("filename",FeatureDefs[defID]["filename"])
-- Spring.Echo("floating",FeatureDefs[defID]["floating"])
-- Spring.Echo("geoThermal",FeatureDefs[defID]["geoThermal"]) 
-- Spring.Echo("height",FeatureDefs[defID]["height"])
-- Spring.Echo("id",FeatureDefs[defID]["id"])
-- Spring.Echo("mass",FeatureDefs[defID]["mass"])
-- Spring.Echo("maxHealth",FeatureDefs[defID]["maxHealth"])
-- Spring.Echo("maxx",FeatureDefs[defID]["maxx"])
-- Spring.Echo("maxy",FeatureDefs[defID]["maxy"])
-- Spring.Echo("maxz",FeatureDefs[defID]["maxz"])
-- Spring.Echo("metal",FeatureDefs[defID]["metal"])
-- Spring.Echo("midx",FeatureDefs[defID]["midx"])
-- Spring.Echo("midy",FeatureDefs[defID]["midy"])
-- Spring.Echo("midz",FeatureDefs[defID]["midz"])
-- Spring.Echo("minx",FeatureDefs[defID]["minx"])
-- Spring.Echo("miny",FeatureDefs[defID]["miny"])
-- Spring.Echo("minz",FeatureDefs[defID]["minz"])
-- Spring.Echo("modelname",FeatureDefs[defID]["modelname"])
-- Spring.Echo("name",FeatureDefs[defID]["name"])
-- Spring.Echo("noSelect",FeatureDefs[defID]["noSelect"])
-- Spring.Echo("radius",FeatureDefs[defID]["radius"])
-- Spring.Echo("reclaimable",FeatureDefs[defID]["reclaimable"])
-- Spring.Echo("reclaimTime",FeatureDefs[defID]["reclaimTime"])
-- Spring.Echo("resurrectable",FeatureDefs[defID]["resurrectable"])
-- Spring.Echo("smokeTime",FeatureDefs[defID]["smokeTime"])
-- Spring.Echo("tooltip",FeatureDefs[defID]["tooltip"])
-- Spring.Echo("upright",FeatureDefs[defID]["upright"]) 
-- Spring.Echo("xsize",FeatureDefs[defID]["xsize"])
-- Spring.Echo("zsize",FeatureDefs[defID]["zsize"])
-- Spring.Echo("--------------------------------")
