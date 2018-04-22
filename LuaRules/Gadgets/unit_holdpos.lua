local unitList = {"armbox", "armmllt", "armmllt2", "armexcal", "cordest", "armtflak", "cortflak", "corfury", "corfury2", "splinter", "armcarry", "corcarry", "armyork", "corsent", "armsam", "cormist", "ahermes", "corhorg", "armraz", "armah", "corah", "armsnipe", "armaacrus", "coraacrus", "corbtrans", "cormart", "armmart", "hersabo"}
local unitList2 = {"armtoad"}
local unitList3 = {"armhawk", "corvamp"}
local unitList4 = {"armmart", "cormart"}
local unitList5 = {"armbox", "armmllt", "armmllt2", "armtflak", "cortflak", "corfury", "corfury2", "splinter"}
local unitList6 = {"bug1", "bug2", "bug3", "bug5", "corgamma", "corgamma2"}
local holdUnits = {}
local holdUnits2 = {}
local holdUnits3 = {}
local holdUnits4 = {}
local holdUnits5 = {}
local holdUnits6 = {}

local CMD_MOVE_STATE       = CMD.MOVE_STATE
local CMD_LOOPBACKATTACK   = CMD.LOOPBACKATTACK
local CMD_CLOAK		   	   = CMD.CLOAK
local CMD_TRAJECTORY       = CMD.TRAJECTORY
  
function gadget:GetInfo()
  return {
    name      = "Auto hold pos",
    desc      = "Sets units defined in unitList to hold position.",
    author    = "CAKE",
    date      = "Oct 20, 2007",
    license   = "notAlicense",
    layer     = 0,
    enabled   = true
  }
end

-- synced only
if (not gadgetHandler:IsSyncedCode()) then
	return false
end

function gadget:Initialize() 
  for i, v in pairs(unitList) do
    holdUnits[v] = true
  end
  for i, v in pairs(unitList2) do  -- pepe: do i want it???
    holdUnits2[v] = true
  end
  for i, v in pairs(unitList3) do  -- pepe: this one to.. air to hold pos???
   holdUnits3[v] = true
  end
  for i, v in pairs(unitList4) do
    holdUnits4[v] = true
  end
  for i, v in pairs(unitList5) do
    holdUnits5[v] = true
  end
  for i, v in pairs(unitList6) do
    holdUnits6[v] = true
  end
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam)
  local ud = UnitDefs[unitDefID]
   if (ud ~= nil) then
    for i, v in pairs(holdUnits) do
      if (holdUnits[ud.name]) then
        Spring.GiveOrderToUnit(unitID, CMD_MOVE_STATE, { 0 }, {})
      end
    end
    for i, v in pairs(holdUnits2) do
      if (holdUnits2[ud.name]) then
        Spring.GiveOrderToUnit(unitID, CMD_LOOPBACKATTACK, { 1 }, {})
      end
    end
    for i, v in pairs(holdUnits3) do
      if (holdUnits3[ud.name]) then
        Spring.GiveOrderToUnit(unitID, CMD_CLOAK, { 0 }, {})
      end
    end
    for i, v in pairs(holdUnits4) do
      if (holdUnits4[ud.name]) then
        Spring.GiveOrderToUnit(unitID, CMD_TRAJECTORY, { 1 }, {})
      end
    end
    for i, v in pairs(holdUnits5) do
      if (holdUnits5[ud.name]) then
        Spring.SetUnitCOBValue(unitID, 75, 0) 
      end
    end
    for i, v in pairs(holdUnits6) do
      if (holdUnits6[ud.name]) then
        Spring.GiveOrderToUnit(unitID, CMD_MOVE_STATE, { 2 }, {})
      end
    end
  end
end

function gadget:UnitFromFactory(unitID, unitDefID, unitTeam)
  local ud = UnitDefs[unitDefID]
   if (ud ~= nil) then
    for i, v in pairs(holdUnits) do
      if (holdUnits[ud.name]) then
        Spring.GiveOrderToUnit(unitID, CMD_MOVE_STATE, { 0 }, {})
      end
    end
   end
end