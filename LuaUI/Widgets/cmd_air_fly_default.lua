--- just set choosen air units to fly when idle

function widget:GetInfo()
  return {
    name      = "Idle air fly default",
    desc      = "Set choosen air units to fly when idle.",
    author    = "PepeAmpere",
    date      = "Oct 9, 2013",
    license   = "notAlicense",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

local spGiveOrderToUnit = Spring.GiveOrderToUnit
local CMD_IDLEMODE 		= CMD.IDLEMODE

local units = {
	["armfig"] = 0,
	["armhawk"] = 0,
	["armsfig"] = 0,
	["armtoad"] = 0,
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
		spGiveOrderToUnit(unitID, CMD_IDLEMODE, { units[ud.name] }, {})
	end
  end
end