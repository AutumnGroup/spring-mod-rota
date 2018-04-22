--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "0fix_unit",
    desc      = "Fix model radius and hitsphere for units",
    author    = "PepeAmpere",
    date      = "Sep 7, 2013",
    license   = "notAlicense",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

-- synced only
if (not gadgetHandler:IsSyncedCode()) then
	return false
end

local spSetUnitRadiusAndHeight 			= Spring.SetUnitRadiusAndHeight				-- ( number unitID, number radius, number height ) -> boolean success
local spSetUnitCollisionVolumeData 		= Spring.SetUnitCollisionVolumeData			-- ( number unitID, number scaleX, number scaleY, number scaleZ, number offsetX, number offsetY, number offsetX, number vType, number tType, number Axis )
local spSetUnitBlocking 				= Spring.SetUnitBlocking
local spSetUnitMidAndAimPos 			= Spring.SetUnitMidAndAimPos

include "LuaRules/Configs/fix_defs.lua"

function gadget:UnitCreated(unitID, unitDefID, unitTeam)
    local name = UnitDefs[unitDefID].name
	
	-- ModelSphere
	if (newRadiusAndHeight[name] ~= nil) then -- hotfix
		spSetUnitRadiusAndHeight(unitID,newRadiusAndHeight[name][1],newRadiusAndHeight[name][2])
	end
	
	-- Blocking
	if (blocking[name] == nil) then
		-- spSetUnitBlocking(unitID,true,_,_) 
	else
		spSetUnitBlocking(unitID,blocking[name][1], blocking[name][2], blocking[name][3], blocking[name][4], blocking[name][5], blocking[name][6], blocking[name][7])
	end
	
	-- AimCenter
	if (newAimCenter[name]) then
		spSetUnitMidAndAimPos(unitID,newAimCenter[name][1],newAimCenter[name][2],newAimCenter[name][3],newAimCenter[name][4],newAimCenter[name][5],newAimCenter[name][6],true)
	end
	
	-- rest general spheres
	-- spacebugs --
	if (name=="darkswarmunit") then
		spSetUnitCollisionVolumeData(unitID,0,0,0,0,-250,0,-1,0,0)
		spSetUnitBlocking(unitID, false, false, false) 
	end
	if (name=="concrete") then
		spSetUnitCollisionVolumeData(unitID,0,0,0,0,-250,0,-1,0,0)
		spSetUnitBlocking(unitID, false, false, false) 
	end
end
