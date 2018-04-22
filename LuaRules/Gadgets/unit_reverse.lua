function gadget:GetInfo()
	return {
		name      = "reverse",
		desc      = "Makes guys reverse", -- replace cake's avantgard solution by engine supported one
		author    = "PepeAmpere",
		date      = "November 2016",
		license   = "notAlicense",
		layer     = 0,
		enabled   = true, -- loaded by default?
	}
end

-- synced only
if (not gadgetHandler:IsSyncedCode()) then
	return false
end

STANDARD_REVERSE_SPEED_MULT = 0.7
STANDARD_MIN_REVERSE_ANGLE = 145
STANDARD_MAX_REVERSE_DISTANCE = 550

-- reverse settings for choosen units (currently outside of unitDefs)
local reverseDefs = {
	-- arm tech1
	["armbull"] = {reverseSpeedMult = STANDARD_REVERSE_SPEED_MULT, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},
	["armcv"] = {reverseSpeedMult = STANDARD_REVERSE_SPEED_MULT, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},
	["armflash"] = {reverseSpeedMult = STANDARD_REVERSE_SPEED_MULT, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},
	["armlatnk"] = {reverseSpeedMult = STANDARD_REVERSE_SPEED_MULT, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},
	["armmart"] = {reverseSpeedMult = STANDARD_REVERSE_SPEED_MULT, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},
	["armsam"] = {reverseSpeedMult = STANDARD_REVERSE_SPEED_MULT, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},
	["armseer"] = {reverseSpeedMult = STANDARD_REVERSE_SPEED_MULT, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},
	["armstump"] = {reverseSpeedMult = STANDARD_REVERSE_SPEED_MULT, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},
	["armyork"] = {reverseSpeedMult = STANDARD_REVERSE_SPEED_MULT, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},
	["avtr"] = {reverseSpeedMult = STANDARD_REVERSE_SPEED_MULT, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},
	
	-- arm tech2
	["ahermes"] = {reverseSpeedMult = STANDARD_REVERSE_SPEED_MULT, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},
	["armcroc"] = {reverseSpeedMult = STANDARD_REVERSE_SPEED_MULT, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},
	["armjam"] = {reverseSpeedMult = STANDARD_REVERSE_SPEED_MULT, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},
	["armmanni"] = {reverseSpeedMult = STANDARD_REVERSE_SPEED_MULT, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},
	["armmerl"] = {reverseSpeedMult = STANDARD_REVERSE_SPEED_MULT, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},
	["grayhound"] = {reverseSpeedMult = STANDARD_REVERSE_SPEED_MULT, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},
	
	-- core tech1
	["corcv"] = {reverseSpeedMult = STANDARD_REVERSE_SPEED_MULT, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},
	["cordemo"] = {reverseSpeedMult = STANDARD_REVERSE_SPEED_MULT, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},
	["corfatnk"] = {reverseSpeedMult = 1, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},
	["corgator"] = {reverseSpeedMult = STANDARD_REVERSE_SPEED_MULT, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},
	["corlevlr"] = {reverseSpeedMult = STANDARD_REVERSE_SPEED_MULT, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},
	["cormart"] = {reverseSpeedMult = STANDARD_REVERSE_SPEED_MULT, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},
	["cormist"] = {reverseSpeedMult = STANDARD_REVERSE_SPEED_MULT, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},
	["corraid"] = {reverseSpeedMult = STANDARD_REVERSE_SPEED_MULT, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},
	["correap"] = {reverseSpeedMult = STANDARD_REVERSE_SPEED_MULT, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},
	["corsent"] = {reverseSpeedMult = STANDARD_REVERSE_SPEED_MULT, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},
	["corvrad"] = {reverseSpeedMult = STANDARD_REVERSE_SPEED_MULT, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},
	
	-- core tech2
	["coreter"] = {reverseSpeedMult = 0.4, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},
	["corgol"] = {reverseSpeedMult = 0.4, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},
	["corhorg"] = {reverseSpeedMult = STANDARD_REVERSE_SPEED_MULT, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},
	["cormamb"] = {reverseSpeedMult = STANDARD_REVERSE_SPEED_MULT, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},
	["corseal"] = {reverseSpeedMult = STANDARD_REVERSE_SPEED_MULT, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},
	["corvroc"] = {reverseSpeedMult = STANDARD_REVERSE_SPEED_MULT, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = STANDARD_MAX_REVERSE_DISTANCE},	
	
	-- other
	["herjuggernaut"] = {reverseSpeedMult = 1, minReverseAngle = STANDARD_MIN_REVERSE_ANGLE, maxReverseDistance = 1000},
}

function gadget:UnitCreated(unitID, unitDefID, unitTeam)
	local ud = UnitDefs[unitDefID]
	local defs = reverseDefs[ud.name]
	if (defs ~= nil) then
		--Spring.Echo(ud.speed * defs.reverseSpeedMult, defs.minReverseAngle, defs.maxReverseDistance)
		Spring.MoveCtrl.SetGroundMoveTypeData(unitID, {maxReverseSpeed = ud.speed * defs.reverseSpeedMult, minReverseAngle = defs.minReverseAngle, maxReverseDist = defs.maxReverseDistance})
	end
end
