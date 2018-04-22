
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "Altitude",
    desc      = "Toggles altitude a plane flies at",
    author    = "thor",
    date      = "Jul 25, 2010",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

if (not gadgetHandler:IsSyncedCode()) then
  return false  --  silent removal
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--Speed-ups

local GetUnitDefID    = Spring.GetUnitDefID
local GetUnitCommands = Spring.GetUnitCommands
local FindUnitCmdDesc = Spring.FindUnitCmdDesc
local SetUnitBuildspeed = Spring.SetUnitBuildSpeed

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- temporary include from commmand constants
-- CMD_ALTITUDE
include("LuaRules/Configs/commandsIDs.lua")

local altitudeList = {}

local aircraftDefs = {
  armfig = true,
  corveng = true,
  armthund = true,
  corshad = true,
  armhawk = true,
  corvamp = true,
  armpnix = true,
  corhurc = true,
  blade = true,
  corgryp = true,
  armawac = true,
  corawac = true,
  armangel = true,
  corsbomb = true,
  corff = true,
  armsfig = true,
  corsfig = true,
  armtoad = true,

}

local altitudeCmdDesc = {
  id      = CMD_ALTITUDE,
  type    = CMDTYPE.ICON_MODE,
  name    = 'Production',
  cursor  = 'Production',
  action  = 'Production',
  tooltip = 'Orders: Production Rate',
  params  = { '0', 'Low', 'High'}
}
  
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function AddAltitudeCmdDesc(unitID)
  if (FindUnitCmdDesc(unitID, CMD_ALTITUDE)) then
    return  -- already exists
  end
  local insertID = 
    FindUnitCmdDesc(unitID, CMD.CLOAK)      or
    FindUnitCmdDesc(unitID, CMD.ONOFF)      or
    FindUnitCmdDesc(unitID, CMD.TRAJECTORY) or
    FindUnitCmdDesc(unitID, CMD.REPEAT)     or
    FindUnitCmdDesc(unitID, CMD.MOVE_STATE) or
    FindUnitCmdDesc(unitID, CMD.FIRE_STATE) or
    123456 -- back of the pack
  altitudeCmdDesc.params[1] = '1'
  Spring.InsertUnitCmdDesc(unitID, insertID + 1, altitudeCmdDesc)
end


local function UpdateButton(unitID, statusStr)
  local cmdDescID = FindUnitCmdDesc(unitID, CMD_ALTITUDE)
  if (cmdDescID == nil) then
    return
  end

  local tooltip
  if (statusStr == '0') then
    tooltip = 'Orders: Fly at Low Altitude.'
  else
    tooltip = 'Orders: Fly at High Altitude.'
  end

  altitudeCmdDesc.params[1] = statusStr

  Spring.EditUnitCmdDesc(unitID, cmdDescID, { 
    params  = altitudeCmdDesc.params, 
    tooltip = tooltip,
  })
end


local function AltitudeCommand(unitID, unitDefID, cmdParams, teamID)

  local ud = UnitDefs[unitDefID]
  if (aircraftDefs[ud.name]) then

    local status
    if cmdParams[1] == 1 then
      status = '1'
      Spring.MoveCtrl.SetAirMoveTypeData(unitID, {
							wantedHeight=altitudeList[unitID]*2
							})
    else
      status = '0'
      Spring.MoveCtrl.SetAirMoveTypeData(unitID, {
							wantedHeight=altitudeList[unitID]
							})

    end
  UpdateButton(unitID, status)
  end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:UnitCreated(unitID, unitDefID, teamID, builderID)
  local ud = UnitDefs[unitDefID]
  if (aircraftDefs[ud.name]) then
    altitudeList[unitID]=ud.wantedHeight
    AddAltitudeCmdDesc(unitID)
    UpdateButton(unitID, '1')
    --RetreatCommand(unitID, unitDefID, { builderInfo[1] }, teamID)
  end
end

function gadget:UnitDestroyed(unitID, _, teamID)
  altitudeList[unitID] = nil
end

function gadget:Initialize()
  gadgetHandler:RegisterCMDID(CMD_ALTITUDE)
  for _, unitID in ipairs(Spring.GetAllUnits()) do
    local teamID = Spring.GetUnitTeam(unitID)
    local unitDefID = GetUnitDefID(unitID)
    gadget:UnitCreated(unitID, unitDefID, teamID)
  end
end




function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, _)
  local returnvalue
  if cmdID ~= CMD_ALTITUDE then
    return true
  end
  AltitudeCommand(unitID, unitDefID, cmdParams, teamID)  
  return false
end

function gadget:Shutdown()
  for _, unitID in ipairs(Spring.GetAllUnits()) do
    local cmdDescID = FindUnitCmdDesc(unitID, CMD_ALTITUDE)
    if (cmdDescID) then
      Spring.RemoveUnitCmdDesc(unitID, cmdDescID)
    end
  end
end



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
