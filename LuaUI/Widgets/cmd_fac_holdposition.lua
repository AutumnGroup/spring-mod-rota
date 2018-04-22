--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    cmd_fac_holdposition.lua
--  brief:   Sets new factories to hold position
--  author:  Masta Ali
--
--  Copyright (C) 2007.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "Factory hold position",
    desc      = "Sets new factories to hold position automatically",
    author    = "Masta Ali",
    date      = "Mar 20, 2007",   -- edited by pepe january 2011
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
---- edited by pepe for NOTA
--------------------------------------------------------------------------------

local unitSet = {}

local unitArray = {
  "armlab",
  "armalab",
  "armvp",
  "armavp",
  "armplab",
  "armhklab",
  "armsy",
  "armhp",
  "armshtlx",
  "armcsy",
  "corlab",
  "corslab",
  "coralab",
  "corplab",
  "corvp",
  "corvalkfac",
  "coravp",
  "corsy",
  "corasy",
  "corhp",
  "corgant",
  "corcsy",
}
----------------------------------------------
------------------------------------------

function widget:Initialize()
  local _, _, spec = Spring.GetPlayerInfo(Spring.GetMyPlayerID())
  if spec then
    widgetHandler:RemoveWidget()
    return false
  end
end

function widget:Initialize() 
  for i, v in pairs(unitArray) do
    unitSet[v] = true
  end
end

function widget:UnitCreated(unitID, unitDefID, unitTeam)
  local ud = UnitDefs[unitDefID]
   if ((ud ~= nil) and (unitTeam == Spring.GetMyTeamID())) then
    for i, v in pairs(unitSet) do
      if (unitSet[ud.name]) then
        Spring.GiveOrderToUnit(unitID, CMD.MOVE_STATE, { 0 }, {})
      end
    end
  end
end

--------------------------------------------------------------------------------
