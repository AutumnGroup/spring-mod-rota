--- just sets the air loop back for given units 

function widget:GetInfo()
  return {
    name      = "Air loopback default",
    desc      = "Sets the air loopback for given units on default value.",
    author    = "PepeAmpere",
    date      = "Apr 23, 2013",
    license   = "notAlicense",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

local spGiveOrderToUnit 	= Spring.GiveOrderToUnit
local CMD_LOOPBACKATTACK 	= CMD.LOOPBACKATTACK

local units = {
	["armfig"] = 0,
	["armhawk"] = 0,
	["armsfig"] = 0,
	["armtoad"] = 1,
	["blade"] = 0,
	["corsfig"] = 0,
	["corvamp"] = 0,
	["corveng"] = 0,
}

function widget:Initialize()
  local _, _, spec = Spring.GetPlayerInfo(Spring.GetMyPlayerID())
  if spec then
    widgetHandler:RemoveWidget()
    return false
  end
end

function widget:UnitCreated(unitID, unitDefID, unitTeam)
  local ud = UnitDefs[unitDefID]
   if ((ud ~= nil) and (unitTeam == Spring.GetMyTeamID())) then
	if (units[ud.name] ~= nil) then
		spGiveOrderToUnit(unitID, CMD_LOOPBACKATTACK, { units[ud.name] }, {})
	end
  end
end
