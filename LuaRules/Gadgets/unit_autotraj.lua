local unitList = {"cormart", "armmart"}
local artyUnits = {}
local buttonToggle = {}

local CMD_TRAJECTORY = CMD.TRAJECTORY
  
function gadget:GetInfo()
  return {
    name      = "AutoTrajectory",
    desc      = "Sets artillery to the best trajectory",
    author    = "THOR",
    date      = "Aug 12, 2008",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true
  }
end

-- synced only
if (not gadgetHandler:IsSyncedCode()) then
	return false
end


local GetUnitDefID    = Spring.GetUnitDefID
local GetUnitCommands = Spring.GetUnitCommands
local FindUnitCmdDesc = Spring.FindUnitCmdDesc

-- temporary include from commmand constants
-- CMD_AUTOTRAJ
include("LuaRules/Configs/commandsIDs.lua")

local autotrajCmdDesc = {
  id      = CMD_AUTOTRAJ,
  type    = CMDTYPE.ICON_MODE,
  name    = 'AutoTraj',
  cursor  = 'AutoTraj',
  action  = 'AutoTraj',
  tooltip = 'Automatically Switches Trajectories',
  params  = { '0', 'AutoTraj Off', 'AutoTraj'}
}
  
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function AddAutotrajCmdDesc(unitID)
  if (FindUnitCmdDesc(unitID, CMD_AUTOTRAJ)) then
    return  -- already exists
  end
  local insertID = 
    FindUnitCmdDesc(unitID, CMD.CLOAK)      or
    FindUnitCmdDesc(unitID, CMD.ONOFF)      or
    FindUnitCmdDesc(unitID, CMD.TRAJECTORY) or
    FindUnitCmdDesc(unitID, CMD.REPEAT)     or
    FindUnitCmdDesc(unitID, CMD.MOVE_STATE) or
    FindUnitCmdDesc(unitID, CMD.FIRE_STATE) or
    FindUnitCmdDesc(unitID, CMD.AREA_ATTACK) or
    123456 -- back of the pack
  autotrajCmdDesc.params[1] = '1'
  Spring.InsertUnitCmdDesc(unitID, insertID + 1, autotrajCmdDesc)
end


local function UpdateButton(unitID, statusStr)
  local cmdDescID = FindUnitCmdDesc(unitID, CMD_AUTOTRAJ)
  if (cmdDescID == nil) then
    return
  end

 local tooltip
  if (statusStr == '0') then
    tooltip = 'Automatically Switches Trajectories'
  else
    tooltip = 'Automatically Switches Trajectories'
  end

  autotrajCmdDesc.params[1] = statusStr

  Spring.EditUnitCmdDesc(unitID, cmdDescID, { 
    params  = autotrajCmdDesc.params, 
    tooltip = tooltip,
  })
end


local function autotrajCommand(unitID, unitDefID, cmdParams, teamID)

   local name = UnitDefs[unitDefID].name
   if (name == "cormart" or name == "armmart") then

    local status
    if cmdParams[1] == 1 then
      status = '1'
      buttonToggle[unitID] = true
    else
      status = '0'
	buttonToggle[unitID] = false
    end
  UpdateButton(unitID, status)
  end

end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


function gadget:Initialize()
  gadgetHandler:RegisterCMDID(CMD_AUTOTRAJ)
  for _, unitID in ipairs(Spring.GetAllUnits()) do
    local teamID = Spring.GetUnitTeam(unitID)
    local unitDefID = GetUnitDefID(unitID)
    gadget:UnitCreated(unitID, unitDefID, teamID)
  end
end




function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, _)
  local returnvalue
  if cmdID ~= CMD_AUTOTRAJ then
    return true
  end
  autotrajCommand(unitID, unitDefID, cmdParams, teamID)  
  return false
end

function gadget:Shutdown()
  for _, unitID in ipairs(Spring.GetAllUnits()) do
    local cmdDescID = FindUnitCmdDesc(unitID, CMD_AUTOTRAJ)
    if (cmdDescID) then
      Spring.RemoveUnitCmdDesc(unitID, cmdDescID)
    end
  end
end




function gadget:UnitCreated(unitID, unitDefID, unitTeam)

  local name = UnitDefs[unitDefID].name
   if (name == "cormart" or name == "armmart") then
	artyUnits[unitID] = true
      AddAutotrajCmdDesc(unitID)
      UpdateButton(unitID, '1')
	buttonToggle[unitID] = true
   end
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
artyUnits[unitID] = nil
buttonToggle[unitID] = nil
end

function gadget:GameFrame(n)

  	if (math.fmod(n,33) == 0) then
		for unitID in pairs(artyUnits) do 
			if (buttonToggle[unitID] ~= nil and buttonToggle[unitID] == true) then
				local _, traj = Spring.CallCOBScript(unitID, "CheckTraj", 1, 1)
				Spring.GiveOrderToUnit(unitID, CMD_TRAJECTORY, { traj }, {})
			end
 		end
	end

end
