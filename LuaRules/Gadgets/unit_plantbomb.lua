--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "PlantBomb",
    desc      = "Plants a remote bomb" ..
                "for the infiltrator",
    author    = "cake + Pepe",
    date      = "March 12, 2009",
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

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- local MAX_STOCKPILE = 3 -- replaced by maxStockpile[]

CMD_PLANTBOMB = 33488

local maxStockpile = {
    ["corsabo"]		= 3,
	["hertrapper"]	= 1,
}
local lowerStockpile = {
    ["corsabo"]		= true,
	["hertrapper"]	= false,
}

local commandoDefs = {
    ["corsabo"]		=true,
	["hertrapper"]	=true,
}
local commandoCommands = {
    ["corsabo"]		=	"PlantBombCmdDesc",
	["hertrapper"]	=	"PlantEmpCmdDesc",
}
local commandoBombs = {
    ["corsabo"]		=	"cormine1",
	["hertrapper"]	=	"armmine4",
}

local commandos = {}
local commandosDefs = {}

local cmdDesc = {
	["PlantBombCmdDesc"] = {
	  id      = CMD_PLANTBOMB,
	  type    = CMDTYPE.ICON,
	  name    = '',
	  texture = "LuaUI/Images/commands/bold/plantmine.png",
	  cursor  = 'Plant Bomb',
	  action  = 'Plant Bomb',
	  tooltip = 'Plant Remote Bomb',
	  params  = { 'Plant Bomb'},
	},
	["PlantEmpCmdDesc"] = {
	  id      = CMD_PLANTBOMB,
	  type    = CMDTYPE.ICON,
	  name    = '',
	  texture = "LuaUI/Images/commands/bold/plantmine.png",
	  cursor  = 'Plant Bomb',
	  action  = 'Plant Bomb',
	  tooltip = 'Plant Trap',
	  params  = { 'Plant Bomb'},
	},
}
  
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function AddPlantBombCmdDesc(unitID,name)
  local thisCmdDescription = cmdDesc[commandoCommands[name]]
  
  if (FindUnitCmdDesc(unitID, thisCmdDescription.id)) then
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
  thisCmdDescription.params[1] = '0'
  Spring.InsertUnitCmdDesc(unitID, insertID + 1, thisCmdDescription)
end


local function UpdateButton(unitID, statusStr, name)
  local thisCmdDescription = cmdDesc[commandoCommands[name]]

  local cmdDescID = FindUnitCmdDesc(unitID, thisCmdDescription.id)
  if (cmdDescID == nil) then
    return
  end

  thisCmdDescription.params[1] = statusStr

  Spring.EditUnitCmdDesc(unitID, cmdDescID, { 
    params  = thisCmdDescription.params, 
    tooltip = tooltip,
  })
end


local function PlantBombCommand(unitID, unitDefID, cmdParams, teamID)
  local ud = UnitDefs[unitDefID]
  if (commandoDefs[ud.name]) then
	local thisCmdDescription = cmdDesc[commandoCommands[ud.name]]
    local stockpile = Spring.GetUnitStockpile(unitID)
    if ( stockpile > 0) then
      local _, plant = Spring.CallCOBScript(unitID, "PlantBomb", 1, 1)
      if (plant == 1) then
        
		-- remove stockpile
		stockpile = stockpile - 1		
        Spring.SetUnitStockpile(unitID, stockpile)
		
        local x, y, z  = Spring.GetUnitPosition(unitID)
        Spring.CreateUnit(commandoBombs[ud.name], x, y, z, 0, teamID)
        local status
        status = '0'
        UpdateButton(unitID, status, ud.name)
      end
    end
  end
end

function gadget:GameFrame(n)
	for unitID in pairs(commandos) do 
		local stockpile, stockqueue, buildpercent = Spring.GetUnitStockpile(unitID)
		local unitName = commandosDefs[unitID]
		if (stockpile >= maxStockpile[unitName]) then
			if (lowerStockpile[unitName]) then
				stockpile = maxStockpile[unitName]
			end
			buildpercent = 0
			Spring.SetUnitStockpile(unitID, stockpile, buildpercent)
		end
		if (stockqueue+stockpile > maxStockpile[unitName]) then
			--stockqueue = maxStockpile[unitName] 
			--Spring.SetUnitStockpile(unitID, stockpile, buildpercent, stockqueue)
			Spring.GiveOrderToUnit(unitID, CMD.STOCKPILE, {}, { "ctrl", "shift", "right" })
			for i=1, (maxStockpile[unitName] - stockpile) do
				Spring.GiveOrderToUnit(unitID, CMD.STOCKPILE, {}, { })
			end
		end
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:UnitCreated(unitID, unitDefID, teamID, builderID)
  local ud = UnitDefs[unitDefID]
  if (commandoDefs[ud.name]) then
    AddPlantBombCmdDesc(unitID,ud.name)
    UpdateButton(unitID, '0',ud.name)
    commandos[unitID] = true
	commandosDefs[unitID] = ud.name
  end
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
	commandos[unitID]=nil
end



function gadget:Initialize()
  gadgetHandler:RegisterCMDID(CMD_PLANTBOMB)
  for _, unitID in ipairs(Spring.GetAllUnits()) do
    local teamID = Spring.GetUnitTeam(unitID)
    local unitDefID = GetUnitDefID(unitID)
    gadget:UnitCreated(unitID, unitDefID, teamID)
  end
end




function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, _)
  if cmdID ~= CMD_PLANTBOMB then
    return true
  end
  PlantBombCommand(unitID, unitDefID, cmdParams, teamID)  
  return false
end

function gadget:Shutdown()
  for _, unitID in ipairs(Spring.GetAllUnits()) do
    local cmdDescID = FindUnitCmdDesc(unitID, CMD_PLANTBOMB)
    if (cmdDescID) then
      Spring.RemoveUnitCmdDesc(unitID, cmdDescID)
    end
  end
end



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

