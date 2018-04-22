
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "Refuel",
    desc      = "Adds a button that sets the production rate" ..
                "for a factory",
    author    = "thor",
    date      = "July 12, 2008",
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

-- get madatory module operators
include("LuaRules/modules.lua") -- modules table
include(modules.attach.data.path .. modules.attach.data.head) -- attach lib module

-- get other madatory dependencies
attach.Module(modules, "message")

-- add one custommessage sender
if (sendCustomMessage == nil) then sendCustomMessage = {} end
sendCustomMessage["resources_refuelOrder"] = function(unitID, unitDefID)
	if (unitID == nil or type(unitID) ~= "number") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [resources_refuelOrder] with wrong parameter for [unitID]") end
	if (unitDefID == nil or type(unitDefID) ~= "number") then Spring.Echo("[" .. moduleInfo.name ..  "]" .. "WARNING: Attempt to send message [resources_refuelOrder] with wrong parameter for [unitDefID]") end
		
	local newMessage = {
		subject = "resources_refuelOrder",
		unitID = unitID,
		unitDefID = unitDefID,
		resourceName = "hydrocarbons",
		-- optional
	}
		
	message.SendSyncedRules(newMessage)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--Speed-ups

local GetUnitDefID    = Spring.GetUnitDefID
local GetUnitCommands = Spring.GetUnitCommands
local FindUnitCmdDesc = Spring.FindUnitCmdDesc

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local airDefs = {

 armfig = true,
 armhell = true,
 armthund = true,
 armtoad = true,
 armlance = true,
 corveng = true,
 corevashp = true,
 corshad = true,
 cortitan = true,
 armsfig = true,
 armseap = true,
 corsfig = true,
 corseap = true,
 armhawk = true, 
 armbrawl = true,
 armpnix = true,
 armwing = true,
 blade = true,
 corvamp = true,
 corape = true,
 corhurc = true,
 corerb = true,
 corgryp = true,
 corsbomb = true,

}

-- temporary include from commmand constants
-- CMD_REFUEL
include("LuaRules/Configs/commandsIDs.lua")

local refuelCmdDesc = {
  id      = CMD_REFUEL,
  type    = CMDTYPE.ICON_MODE,
  name    = 'Refuel',
  cursor  = 'Refuel',
  action  = 'Refuel',
  tooltip = 'Return Immediately to Base',
  params  = { 'Refuel'}
}
  
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function AddrefuelCmdDesc(unitID)
  if (FindUnitCmdDesc(unitID, CMD_REFUEL)) then
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
  refuelCmdDesc.params[1] = '0'
  Spring.InsertUnitCmdDesc(unitID, insertID + 1, refuelCmdDesc)
end


local function UpdateButton(unitID, statusStr)
  local cmdDescID = FindUnitCmdDesc(unitID, CMD_REFUEL)
  if (cmdDescID == nil) then
    return
  end

  refuelCmdDesc.params[1] = statusStr

  Spring.EditUnitCmdDesc(unitID, cmdDescID, { 
    params  = refuelCmdDesc.params, 
    tooltip = tooltip,
  })
end


local function refuelCommand(unitID, unitDefID, cmdParams, teamID)

  local ud = UnitDefs[unitDefID]
  if (airDefs[ud.name]) then
    -- Spring.CallCOBScript(unitID, "Refuel", 0)
	sendCustomMessage.resources_refuelOrder(unitID, unitDefID)

     local status
      status = '0'

  UpdateButton(unitID, status)
  end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:UnitCreated(unitID, unitDefID, teamID, builderID)
  local ud = UnitDefs[unitDefID]
  if (airDefs[ud.name]) then
    AddrefuelCmdDesc(unitID)
    UpdateButton(unitID, '0')
    --RetreatCommand(unitID, unitDefID, { builderInfo[1] }, teamID)
  end
end


function gadget:Initialize()
  gadgetHandler:RegisterCMDID(CMD_REFUEL)
  for _, unitID in ipairs(Spring.GetAllUnits()) do
    local teamID = Spring.GetUnitTeam(unitID)
    local unitDefID = GetUnitDefID(unitID)
    gadget:UnitCreated(unitID, unitDefID, teamID)
  end
end




function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, _)
  local returnvalue
  if cmdID ~= CMD_REFUEL then
    return true
  end
  refuelCommand(unitID, unitDefID, cmdParams, teamID)  
  return false
end

function gadget:Shutdown()
  for _, unitID in ipairs(Spring.GetAllUnits()) do
    local cmdDescID = FindUnitCmdDesc(unitID, CMD_REFUEL)
    if (cmdDescID) then
      Spring.RemoveUnitCmdDesc(unitID, cmdDescID)
    end
  end
end



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
