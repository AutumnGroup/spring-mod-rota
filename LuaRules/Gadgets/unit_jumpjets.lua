--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "Jumpjets",
    desc      = "Gives units the jump ability",
    author    = "quantum",
    date      = "May 14, 2008",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- temporary include from commmand constants
-- CMD_JUMP
include("LuaRules/Configs/commandsIDs.lua")

--------------------------------------------------------------------------------
--  COMMON
--------------------------------------------------------------------------------
if (not gadgetHandler:IsSyncedCode()) then
  return false -- no unsynced code
end
--------------------------------------------------------------------------------
--  SYNCED
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local Spring      = Spring
local MoveCtrl    = Spring.MoveCtrl
local coroutine   = coroutine
local Sleep       = coroutine.yield
local pairs       = pairs
local assert      = assert
local ipairs      = ipairs

local coroutines  = {}
local lastJump    = {}
local orders      = {}
local landBoxSize = 60
local jumps       = {}
local precision   = 1
local jumping     = {}

local SetLeaveTracks      = Spring.SetUnitLeaveTracks or MoveCtrl.SetLeaveTracks

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local jumpDefNames  = VFS.Include"LuaRules/Configs/jump_defs.lua"

local jumpDefs = {}
for name, data in pairs(jumpDefNames) do
  jumpDefs[UnitDefNames[name].id] = data
end


local jumpCmdDesc = {
  id      = CMD_JUMP,
  type    = CMDTYPE.ICON_MAP,
  name    = 'Jump',
  cursor  = 'Attack',  -- add with LuaUI?
  action  = 'jump',
  tooltip = 'Jump to selected position.',
}

local ignore = {
  [CMD.SET_WANTED_MAX_SPEED] = true,
}

local accept = {
  [CMD.MOVE] = true,
  [CMD_JUMP] = true,
}
  
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function GetDist3(a, b)
  return ((a[1] - b[1])^2 + (a[2] - b[2])^2 + (a[3] - b[3])^2)^0.5
end


local function GetDist2(a, b)
  return ((a[1] - b[1])^2 + (a[3] - b[3])^2)^0.5
end


local function Approach(unitID, cmdParams, range)
  local x, y, z = unpack(cmdParams)
  Spring.SetUnitMoveGoal(unitID, x, y, z, range)
end


local function StartScript(fn)
  local co = coroutine.create(fn)
  coroutines[co] = 0
end


local function Aprox(x, y)
  local same
  if (type(x) ~= 'table') then
    if (x > y - precision and x < x + precision) then
      same = true
    end
  else
    same = true
    for i in ipairs(y) do
      if (not Aprox(x[i], y[i])) then
        same = nil
      end
    end
  end
  return same
end


local function ReloadQueue(unitID, queue, start)
  if (not queue) then
    return
  end
  Spring.GiveOrderToUnit(unitID, CMD.STOP, {}, {})
  for k,cmd in ipairs(queue) do  --  in order
    if (not cmd.options.internal and 
        not (CMD[cmd.id] == "MOVE" and Aprox(start, cmd.params))) then
      local opts = {}
      table.insert(opts, "shift") -- appending
      if (cmd.options.alt)   then table.insert(opts, "alt")   end
      if (cmd.options.ctrl)  then table.insert(opts, "ctrl")  end
      if (cmd.options.right) then table.insert(opts, "right") end
      Spring.GiveOrderToUnit(unitID, cmd.id, cmd.params, opts)
    end
  end
end


local function Jump(unitID, finish)

  jumping[unitID]= true
  lastJump[unitID] = Spring.GetGameSeconds()
    
  local vector        = {}
  local vertex        = {}
  local start         = {Spring.GetUnitPosition(unitID)}
 
  local unitDefID     = Spring.GetUnitDefID(unitID)
  local speed         = jumpDefs[unitDefID].speed
  local height        = jumpDefs[unitDefID].height
  local teamID        = Spring.GetUnitTeam(unitID)

  for i=1, 3 do
    vector[i]         = finish[i] - start[i]
  end
  
  -- vertex of the parabola
  vertex[1]           = start[1] + vector[1]*0.5
  vertex[2]           = start[2] + vector[2]*0.5 + (1-(2*0.5-1)^2)*height
  vertex[3]           = start[3] + vector[3]*0.5
  
  local lineDist      = GetDist3(start, finish)
  local flightDist    = GetDist3(start, vertex) + GetDist3(vertex, finish)
  
  local speed         = speed * lineDist/flightDist
  
  local step          = speed/lineDist
  
  local rotUnit       = 2^16 / (2*math.pi)
  local startHeading  = Spring.GetUnitHeading(unitID) + 2^15
  local finishHeading = Spring.GetHeadingFromVector(vector[1], vector[3]) + 2^15
  
  -- pick shortest turn direction
  if (finishHeading  >= startHeading + 2^15) then
    startHeading = startHeading + 2^16
  elseif (finishHeading  < startHeading - 2^15)  then
    finishHeading  = finishHeading  + 2^16
  end
  local turn = finishHeading - startHeading
  
  Spring.CallCOBScript(unitID, "BeginJump", 0)
  
  MoveCtrl.Enable(unitID)
  
  SetLeaveTracks (unitID, false)
  
  MoveCtrl.SetRotation(unitID, 0, (startHeading - 2^15)/rotUnit, 0) -- keep current heading
  MoveCtrl.SetRotationVelocity(unitID, 0, turn/rotUnit*step, 0)
  
   
  local function JumpLoop()
    local halfJump
    for i=0, 1, step do
      local x = start[1] + vector[1]*i
      local y = start[2] + vector[2]*i + (1-(2*i-1)^2)*height -- parabola
      local z = start[3] + vector[3]*i
      MoveCtrl.SetPosition(unitID, x, y, z)
      if (not halfJump and step > 0.5) then

--Spring.CallCOBScript(unitID, "HalfJump", 0)
        halfJump = true
      end
      Sleep()
    end
    MoveCtrl.Disable(unitID)
    Spring.CallCOBScript(unitID, "EndJump", 0)
    jumping[unitID] = nil
    ReloadQueue(unitID, Spring.GetCommandQueue(unitID), start)
  end
  
  StartScript(JumpLoop)
  
end


-- a bit convoluted for this but might be           
-- useful for lua unit scripts
local function UpdateCoroutines()      
  for co, sleepLeft in pairs(coroutines) do 
    if (coroutine.status(co) == "dead") then
      coroutines[co] = nil
    elseif (sleepLeft <= 0) then
      local success, sleep = assert(coroutine.resume(co))
      coroutines[co] = sleep or 0
    else
      coroutines[co] = sleepLeft - 1
    end
  end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:Initialize()
  Spring.SetCustomCommandDrawData(CMD_JUMP, "Attack", {0, 1, 0, 1})
  gadgetHandler:RegisterCMDID(CMD_JUMP)
  for _, unitID in pairs(Spring.GetAllUnits()) do
    gadget:UnitCreated(unitID, Spring.GetUnitDefID(unitID))
  end
end


function gadget:UnitCreated(unitID, unitDefID, unitTeam)
  if (not jumpDefs[unitDefID]) then
    return
  end 
  local t = Spring.GetGameSeconds()
  lastJump[unitID] = t
  Spring.InsertUnitCmdDesc(unitID, jumpCmdDesc)
end


function gadget:UnitDestroyed(unitID, unitDefID)
  lastJump[unitID]  = nil
end


function gadget:AllowCommand(unitID, unitDefID, teamID,
                             cmdID, cmdParams, cmdOptions)
                             
  if (cmdID == CMD_JUMP and 
      Spring.TestBuildOrder(
          unitDefID, cmdParams[1], cmdParams[2], cmdParams[3], 1) == 0) then
      return false
  end
  return true -- allowed
end


function gadget:CommandFallback(unitID, unitDefID, teamID,    -- keeps getting 
                                cmdID, cmdParams, cmdOptions) -- called until
  if (cmdID ~= CMD_JUMP)or(not jumpDefs[unitDefID]) then      -- you remove the
    return false  -- command was not used                     -- order
  end
  local x, y, z = Spring.GetUnitPosition(unitID)
  local dist    = GetDist2({x, y, z}, cmdParams)
  local range   = jumpDefs[unitDefID].range
  local reload  = jumpDefs[unitDefID].reload or 0
  local t       = Spring.GetGameSeconds()


  if (dist < range) then
    if (t - lastJump[unitID] >= reload and not jumping[unitID]) then
      local coords = table.concat(cmdParams)
      if (not jumps[coords]) then
        Jump(unitID, cmdParams)
        jumps[coords] = 1
        return true, true -- command was used, remove it 
      else
        local r = landBoxSize*jumps[coords]^0.5/2
        Jump(unitID, {
          cmdParams[1] + math.random(-r, r),
          cmdParams[2] + math.random(-r, r),
          cmdParams[3] + math.random(-r, r),
        })
        jumps[coords] = jumps[coords] + 1
        return true, true -- command was used, remove it 
      end
    end
  else
    Approach(unitID, cmdParams, range)
  end
  
  return true, false -- command was used but don't remove it
end


function gadget:GameFrame(n)
  UpdateCoroutines()
end


--------------------------------------------------------------------------------
--  SYNCED
--------------------------------------------------------------------------------
-- else
--------------------------------------------------------------------------------
--  UNSYNCED
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--  UNSYNCED
--------------------------------------------------------------------------------
-- end
--------------------------------------------------------------------------------
--  COMMON
--------------------------------------------------------------------------------

 