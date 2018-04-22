--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    unit_morph.lua
--  brief:   Adds unit morphing command
--  author:  Dave Rodgers (improved by jK, Licho and aegis)
--
--  Copyright (C) 2007.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "UnitMorph",
    desc      = "Adds unit morphing",
    author    = "trepan (improved by jK, Licho and aegis)",
    date      = "Apr 24, 2007",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- temporary include from commmand constants
-- CMD_MORPH
include("LuaRules/Configs/commandsIDs.lua")
local MAX_MORPH = 10

local morphPenalty = 1.0
local upgradingBuildSpeed = 250

--------------------------------------------------------------------------------
--  COMMON
--------------------------------------------------------------------------------

-- // for use with any mod -_-
function GetTechLevel(udid)
  local ud = UnitDefs[udid];
  return (ud and ud.techLevel) or 0
end
--

--[[ // for use with mods like CA <_<
function GetTechLevel(UnitDefID)
  --return UnitDefs[UnitDefID].techLevel or 0
  local cats = UnitDefs[UnitDefID].modCategories
  if (cats) then
    --// bugfix, cuz lua don't remove uppercase :(
    if     (cats["LEVEL1"]) then return 1
    elseif (cats["LEVEL2"]) then return 2
    elseif (cats["LEVEL3"]) then return 3
      elseif (cats["level1"]) then return 1
      elseif (cats["level2"]) then return 2
      elseif (cats["level3"]) then return 3
    end
  end
  return 0
end
]]--

function isFactory(UnitDefID)
  return UnitDefs[UnitDefID].isFactory or false
end


function isFinished(UnitID)
  local _,_,_,_,buildProgress = Spring.GetUnitHealth(UnitID)
  return (buildProgress==nil)or(buildProgress>=1)
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local defNamesL = {}
for defName in pairs(UnitDefNames) do
  defNamesL[string.lower(defName)] = defName
end

local function DefCost(paramName, udSrc, udDst)
  local pSrc = udSrc[paramName]
  local pDst = udDst[paramName]
  if ((not pSrc) or (not pDst) or
      (type(pSrc) ~= 'number') or
      (type(pDst) ~= 'number')) then
    return 0
  end
  local cost = (pDst - pSrc) * morphPenalty
  if (cost < 0) then
    cost = 0
  end
  return math.floor(cost)
end

local function BuildDef(udSrc, morphData)
  local udDst = UnitDefNames[defNamesL[string.lower(morphData.into)] or -1]
  if (not udDst) then
    Spring.Echo('Morph gadget: Bad morph dst type: ' .. morphData.into)
    return
  else
    local unitDef = udDst --UnitDefs[udSrc.id]
    local newData = {}
    newData.into = udDst.id
    newData.time = morphData.time or math.floor(unitDef.buildTime*7/upgradingBuildSpeed)
    newData.increment = (1 / (30 * newData.time))
    newData.metal  = morphData.metal  or DefCost('metalCost',  udSrc, udDst)
    newData.energy = morphData.energy or DefCost('energyCost', udSrc, udDst)
    newData.resTable = {
      m = (newData.increment * newData.metal),
      e = (newData.increment * newData.energy)
    }
    newData.tech = morphData.tech or 0
    newData.xp   = morphData.xp or 0
    return newData
  end
end

local function ValidateMorphDefs(mds)
  local newDefs = {}
  for src,morphData in pairs(mds) do
    local udSrc = UnitDefNames[defNamesL[string.lower(src)] or -1]
    if (not udSrc) then
      Spring.Echo('Morph gadget: Bad morph src type: ' .. src)
    else
      newDefs[udSrc.id] = {}
      if (morphData.into) then
        newDefs[udSrc.id][1] = BuildDef(udSrc, morphData)
      else
        for number, morphData in ipairs(morphData) do
          newData = BuildDef(udSrc, morphData)
          if (newData) then newDefs[udSrc.id][number] = newData end
        end
      end
    end
  end
  return newDefs
end


if (gadgetHandler:IsSyncedCode()) then
--------------------------------------------------------------------------------
--  SYNCED
--------------------------------------------------------------------------------

--// 75b2 compability (removed it in the next release)
if (Spring.SetUnitLineage==nil) then
  Spring.SetUnitLineage = function() end
end
include("LuaRules/colors.h.lua")


local morphDefs = {}
local morphUnits = {} --// make it global in Initialize()

local stopPenalty  = 1.0

local XpScale = 0.50

local devolution = true --// remove upgrade capabilities after factory destruction?
local stopMorphOnDevolution = true --// should morphing stop during devolution

--// per team techlevel table
local teamTechLevel = {}
local allyList = Spring.GetAllyTeamList()
for _,allyID in ipairs(allyList) do
  local teamList = Spring.GetTeamList(allyID)
  for _,teamID in ipairs(teamList) do
    teamTechLevel[teamID] = 0
  end
end

local morphCmdDesc = {
--  id     = CMD_MORPH, -- added by the calling function because there is now more than one option
  type   = CMDTYPE.ICON,
  name   = '',
  cursor = 'Morph',  -- add with LuaUI?
  action = 'morph',
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--// translate lowercase UnitNames to real unitname (with upper-/lowercases)


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function GetMorphToolTip(unitID, morphDef,teamTech,unitXP)
  local ud = UnitDefs[morphDef.into]
  local tt = ''
  tt = tt .. WhiteStr  .. 'Morph into a ' .. ud.humanName .. '\n'
  tt = tt .. GreenStr  .. 'time: '   .. morphDef.time     .. '\n'
  tt = tt .. CyanStr   .. 'metal: '  .. morphDef.metal    .. '\n'
  tt = tt .. YellowStr .. 'energy: ' .. morphDef.energy   .. '\n'
  if (morphDef.tech>teamTech) or (morphDef.xp>unitXP) then
    tt = tt .. RedStr .. 'needs'
    if (morphDef.tech>teamTech) then tt = tt .. ' level: ' .. morphDef.tech  end
    if (morphDef.xp>unitXP)     then tt = tt .. ' xp: ' .. string.format('%.2f',morphDef.xp) end
  end
  return tt
end


local function AddMorphCmdDesc(unitID, number, morphDef, teamTech)
  local unitXP = Spring.GetUnitExperience(unitID)

  morphCmdDesc.tooltip = GetMorphToolTip(unitID, morphDef,0,0)
  morphCmdDesc.texture = "#" .. morphDef.into   --//only works with a patched layout.lua or the TweakedLayout widget!
  morphCmdDesc.disabled= (morphDef.tech > teamTech)or(morphDef.xp > unitXP)
  if number <= MAX_MORPH then
    morphCmdDesc.id = CMD_MORPH+number
    Spring.InsertUnitCmdDesc(unitID, morphCmdDesc)
  else
    Spring.Echo('morph def referenced over the limit.',MAX_MORPH)
    Spring.Echo('either manually hax more possibilities into the script by increasing MAX_MORPH, or limit yourself to 10 defs :)')
  end
  morphCmdDesc.tooltip = nil
  morphCmdDesc.texture = nil
end


local function UpdateMorphPossibilities(teamID)
  local teamTech = teamTechLevel[teamID] or 0

  local units = Spring.GetTeamUnitsSorted(teamID)
  for unitDefID,unitIDs in pairs(units) do
    local morphDefSet  = morphDefs[unitDefID]
    if morphDefSet then
	    for number, morphDef in ipairs(morphDefSet) do
	
	      if (morphDef) then
	        for _,unitID in ipairs(unitIDs) do
	          local cmdDescID = Spring.FindUnitCmdDesc(unitID, CMD_MORPH+number)
	          if (cmdDescID) then
	            local unitXP = Spring.GetUnitExperience(unitID)
	            local morphCmdDesc = {}
	            morphCmdDesc.disabled = (morphDef.tech > teamTech)or(morphDef.xp > unitXP)
	            morphCmdDesc.tooltip  = GetMorphToolTip(unitID, morphDef, teamTech, unitXP)
	            Spring.EditUnitCmdDesc(unitID, cmdDescID, morphCmdDesc)
	
	          end
	        end
	      end
	    end
	  end
  end
end


--------------------------------------------------------------------------------

local function StartMorph(unitID, unitDefID, morphDef, morphID)
  --Spring.SetUnitHealth(unitID, { health = Spring.GetUnitHealth(unitID) * .5 })
  Spring.SetUnitHealth(unitID, { paralyze = 1.0e9 })    --// turns mexes and mm off (paralyze the unit)
  Spring.SetUnitResourcing(unitID,"e",0)                --// turns solars off
  Spring.GiveOrderToUnit(unitID, CMD.ONOFF, { 0 }, { }) --// turns radars/jammers off

  morphUnits[unitID] = {
    def = morphDef,
    progress = 0.0,
    increment = morphDef.increment
  }
  SendToUnsynced("um_str", unitID, unitDefID, morphDef.increment, morphID)
end


local function StopMorph(unitID, morphData)
  morphUnits[unitID] = nil

  Spring.SetUnitHealth(unitID, { paralyze = -1})
  local scale = morphData.progress * stopPenalty
  local unitDefID = Spring.GetUnitDefID(unitID)

  --Spring.SetUnitHealth(unitID, { health = Spring.GetUnitHealth(unitID) * 1.5 })
  Spring.SetUnitResourcing(unitID,"e", UnitDefs[unitDefID].energyMake)
  Spring.GiveOrderToUnit(unitID, CMD.ONOFF, { 1 }, { })
  local usedMetal  = morphData.def.metal  * scale
  Spring.AddUnitResource(unitID, 'metal',  usedMetal)
  local usedEnergy = morphData.def.energy * scale
  Spring.AddUnitResource(unitID, 'energy', usedEnergy)

  SendToUnsynced("um_stp", unitID)
end


local function FinishMorph(unitID, morphData)
  local udSrc = UnitDefs[Spring.GetUnitDefID(unitID)]
  local udDst = UnitDefs[morphData.def.into]
  local defName = udDst.name
  local unitTeam = Spring.GetUnitTeam(unitID)
  local px, py, pz = Spring.GetUnitBasePosition(unitID)
  Spring.SetUnitBlocking(unitID, false)
  morphUnits[unitID] = nil

  --Spring.SetUnitHealth(unitID, { health = Spring.GetUnitHealth(unitID) * 2 })
  local newUnit = Spring.CreateUnit(defName, px, py, pz, 0, unitTeam)
  local h = Spring.GetUnitHeading(unitID)
  Spring.SetUnitRotation(newUnit, 0, -h * math.pi / 32768, 0)

  --//copy experience
  local newXp = Spring.GetUnitExperience(unitID)*XpScale
  local nextMorph = (morphDefs[morphData.def.into] or {})[1]
  if (nextMorph) then --//determine the lowest xp req. of all next possible morphs
    local maxXp = math.huge
    for i=1,#nextMorph do
      local xpinto = nextMorph[i].xp
      if (xpinto>0)and(xpinto<maxXp) then
        maxXp=xpinto
      end
    end
    newXp = math.min( newXp, maxXp*0.9)
  end
  Spring.SetUnitExperience(newUnit, newXp)

  --//copy command queue
  local cmds = Spring.GetUnitCommands(unitID)
  for i = 2, #cmds do  -- skip the first command (CMD_MORPH)
    local cmd = cmds[i]
    Spring.GiveOrderToUnit(newUnit, cmd.id, cmd.params, cmd.options.coded)
  end

  --//copy some state
  local states = Spring.GetUnitStates(unitID)
  Spring.GiveOrderArrayToUnitArray({ newUnit }, {
    { CMD.FIRE_STATE, { states.firestate },             {} },
    { CMD.MOVE_STATE, { states.movestate },             {} },
    { CMD.REPEAT,     { states['repeat']  and 1 or 0 }, {} },
    { CMD.CLOAK,      { states.cloak      and 1 or 0 }, {} },
    { CMD.ONOFF,      { 1 }, {} },
    { CMD.TRAJECTORY, { states.trajectory and 1 or 0 }, {} },
  })

  local oldHealth = Spring.GetUnitHealth(unitID)
  local newHealth = oldHealth * (udDst.health / udSrc.health)
  if newHealth<=1 then newHealth = 1 end
  Spring.SetUnitHealth(newUnit, newHealth)

  --local lineage = Spring.GetUnitLineage(unitID)
  --Spring.SetUnitLineage(newUnit,lineage,true)

  --// FIXME: - re-attach to current transport?
  --// update selection
  SendToUnsynced("um_fin", unitID, newUnit)

  Spring.SetUnitBlocking(newUnit, true)
  Spring.DestroyUnit(unitID, false, true) -- selfd = false, reclaim = true
end


local function UpdateMorph(unitID, morphData)
  if (Spring.UseUnitResource(unitID, morphData.def.resTable)) then
    morphData.progress = morphData.progress + morphData.increment
    SendToUnsynced("um_prg", unitID, morphData.progress)
  end
  if (morphData.progress >= 1.0) then
    FinishMorph(unitID, morphData)
    return false -- remove from the list, all done
  end
  return true
end



--------------------------------------------------------------------------------

function gadget:Initialize()
  --[[
  if Spring.IsReplay() then
    gadgetHandler:RemoveGadget()
    return
  end
  --]]

  --// get the morphDefs
  morphDefs = include("LuaRules/Configs/morph_defs.lua")
  if (not morphDefs) then
    gadgetHandler:RemoveGadget()
    return
  end
  for number = 0, MAX_MORPH, 1 do
    gadgetHandler:RegisterCMDID(CMD_MORPH+number)
  end

  morphDefs = ValidateMorphDefs(morphDefs)

  --// add the Morph command to existing units
  for _,unitID in ipairs(Spring.GetAllUnits()) do
    local teamID    = Spring.GetUnitTeam(unitID)
    local unitDefID = Spring.GetUnitDefID(unitID)
    local morphDefSet  = morphDefs[unitDefID]
    if (morphDefSet) then
      for number, morphDef in ipairs(morphDefSet) do
  	    if (morphDef) then
          local cmdDescID = Spring.FindUnitCmdDesc(unitID, CMD_MORPH+number-1)
          if (not cmdDescID) then
            AddMorphCmdDesc(unitID, number, morphDef, teamTechLevel[teamID])
          end
        end
      end
    end
  end
end


function gadget:Shutdown()
  for _,unitID in ipairs(Spring.GetAllUnits()) do
    local morphData = morphUnits[unitID]
    if (morphData) then
      StopMorph(unitID, morphData)
    end
    for number = 0, MAX_MORPH, 1 do
      local cmdDescID = Spring.FindUnitCmdDesc(unitID, CMD_MORPH+number)
    end
    if (cmdDescID) then
      Spring.RemoveUnitCmdDesc(unitID, cmdDescID)
    end
  end
end


function gadget:UnitCreated(unitID, unitDefID, teamID)
  local morphDefSet = morphDefs[unitDefID]
  if (morphDefSet) then
    for number, morphDef in ipairs(morphDefSet) do
  	  if (morphDef) then
    	  AddMorphCmdDesc(unitID, number, morphDef, teamTechLevel[teamID])
  	  end
    end
  end
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID)
  morphUnits[unitID] = nil
  RemoveFactory(unitID, unitDefID, teamID)
end

function gadget:UnitTaken(unitID, unitDefID, oldTeamID, teamID)
  AddFactory(unitID, unitDefID, teamID)
  self:UnitCreated(unitID, unitDefID, teamID)
end

function gadget:UnitGiven(unitID, unitDefID, newTeamID, teamID)
  RemoveFactory(unitID, unitDefID, teamID)
end


function AddFactory(unitID, unitDefID, teamID)
  if (isFactory(unitDefID)) then
    local unitTechLevel = GetTechLevel(unitDefID)
    if (unitTechLevel > teamTechLevel[teamID]) then
      teamTechLevel[teamID]=unitTechLevel
      UpdateMorphPossibilities(teamID)
    end
  end
end

function RemoveFactory(unitID, unitDefID, teamID)
  if (devolution)and(isFactory(unitDefID)) then
    --// check all factories and determine team level
    local level = 0
    for _,unitID2 in ipairs(Spring.GetTeamUnits(teamID)) do
      local unitDefID2 = Spring.GetUnitDefID(unitID2)
      if (isFactory(unitDefID2) and isFinished(unitID2) and (unitID2 ~= unitID)) then
        local unitTechLevel = GetTechLevel(unitDefID2)
        if (unitTechLevel>level) then level = unitTechLevel end
      end
    end

    if (level ~= teamTechLevel[teamID]) then
      teamTechLevel[teamID] = level
      UpdateMorphPossibilities(teamID)

      if (stopMorphOnDevolution) then
        for morphID, data in pairs(morphUnits) do
          if (data.def.tech > level and Spring.GetUnitTeam(morphID) == teamID) then
            StopMorph(morphID, data)
          end
        end
      end

    end

  end
end


function gadget:UnitFinished(unitID, unitDefID, teamID)
  AddFactory(unitID, unitDefID, teamID)
end


function gadget:GameFrame(n)
  if ((n+28) % 64)<1 then
    local teamIDs = Spring.GetTeamList()
    for _,teamID in ipairs(teamIDs) do
      UpdateMorphPossibilities(teamID)
    end
  end

  if (next(morphUnits) == nil) then
    return  --// no morphing units
  end
  local killUnits = {}
  for unitID, morphData in pairs(morphUnits) do
    if (not UpdateMorph(unitID, morphData)) then
      killUnits[unitID] = true
    end
  end
  for unitID in pairs(killUnits) do
    morphUnits[unitID] = nil
  end
end


function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
  if (cmdID >= CMD_MORPH and cmdID <= CMD_MORPH+MAX_MORPH) then
    local morphID  = cmdID - CMD_MORPH
    local morphDef = (morphDefs[unitDefID] or {})[morphID]
    if ((morphDef) and (morphDef.tech<=teamTechLevel[teamID]) and (morphDef.xp<=Spring.GetUnitExperience(unitID))) then
      return true
    end
    return false
  end

  local morphData = morphUnits[unitID]
  if (morphData) then
    if (cmdID == CMD.STOP) then
      StopMorph(unitID, morphData)
      morphUnits[unitID] = nil
    elseif (cmdID == CMD.ONOFF) then
      return false
    else
      return false
    end
  end
  return true
end


function gadget:CommandFallback(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
  if (cmdID <= CMD_MORPH or cmdID >= CMD_MORPH+MAX_MORPH) then
    return false  --// command was not used
  end
  local morphID  = cmdID - CMD_MORPH
  local morphDef = (morphDefs[unitDefID] or {})[morphID]
  if (not morphDef) then
    return true, true  --// command was used, remove it
  end
  local morphData = morphUnits[unitID]
  if (not morphData) then
		StartMorph(unitID, unitDefID, morphDef, morphID)
		return true, true
  end
  return true, false  --// command was used, do not remove it
end

--------------------------------------------------------------------------------
--  SYNCED
--------------------------------------------------------------------------------
else
--------------------------------------------------------------------------------
--  UNSYNCED
--------------------------------------------------------------------------------

--// 75b2 compability (removed it in the next release)
if (Spring.GetTeamColor==nil) then
  Spring.GetTeamColor = function(teamID) local _,_,_,_,_,_,r,g,b = Spring.GetTeamInfo(teamID); return r,g,b end
end

--
-- speed-ups
--


local gameFrame;
include('LuaUI/Headers/billboard.lua');

local GetUnitTeam         = Spring.GetUnitTeam
local GetUnitHeading      = Spring.GetUnitHeading
local GetUnitBasePosition = Spring.GetUnitBasePosition
local GetGameFrame        = Spring.GetGameFrame
local GetSpectatingState  = Spring.GetSpectatingState
local AddWorldIcon        = Spring.AddWorldIcon
local AddWorldText        = Spring.AddWorldText
local IsUnitVisible       = Spring.IsUnitVisible
local GetLocalTeamID      = Spring.GetLocalTeamID

local glBillboard         = gl.BillboardFixed;  --BUGFIXED
local CreateBillboard     = gl.CreateBillboard; --BUGFIXED
local glColor        = gl.Color
local glPushMatrix   = gl.PushMatrix
local glTranslate    = gl.Translate
local glRotate       = gl.Rotate
local glUnitShape    = gl.UnitShape
local glPopMatrix    = gl.PopMatrix
local glText         = gl.Text
local glPushAttrib   = gl.PushAttrib
local glPopAttrib    = gl.PopAttrib
local GL_COLOR_BUFFER_BIT = GL.COLOR_BUFFER_BIT

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local useLuaUI = false
local oldFrame = 0        --//used to save bandwidth between unsynced->LuaUI
local drawProgress = true --//a widget can do this job to (see healthbars)

local morphUnits = {}
local morphDefs = {}
local extraUnitMorphDefs = {}

local MAX_MORPH = 0 --// will increase dynamically

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--//synced -> unsynced actions

local function SelectSwap(cmd, oldID, newID)
  local selUnits = Spring.GetSelectedUnits()
  for i, unitID in ipairs(selUnits) do
    if (unitID == oldID) then
      selUnits[i] = newID
      Spring.SelectUnitArray(selUnits)
      return true
    end
  end



  if (Script.LuaUI('MorphFinished')) then
    if (useLuaUI) then
      local readTeam, spec, specFullView = nil,GetSpectatingState()
      if (specFullView)
      then readTeam = Script.ALL_ACCESS_TEAM
      else readTeam = GetLocalTeamID() end
      CallAsTeam({ ['read'] = readTeam }, function()
      if (unitID)and(IsUnitVisible(unitID)) then
        Script.LuaUI.MorphFinished(unitID)
      end
      end)
    end
  end

  return true
end

local function StartMorph(cmd, unitID, unitDefID, incr, morphID)
  local tdef = (morphDefs[unitDefID] or {})[morphID]
  morphUnits[unitID] = {
    def = tdef,
    progress = 0.0,
    increment = incr,
  }

  if (Script.LuaUI('MorphStart')) then
    if (useLuaUI) then
      local readTeam, spec, specFullView = nil,GetSpectatingState()
      if (specFullView)
      then readTeam = Script.ALL_ACCESS_TEAM
      else readTeam = GetLocalTeamID() end
      CallAsTeam({ ['read'] = readTeam }, function()
      if (unitID)and(IsUnitVisible(unitID)) then
        Script.LuaUI.MorphStart(unitID)
      end
      end)
    end
  end
  return true
end

local function StopMorph(cmd, unitID)
  morphUnits[unitID] = nil

  if (Script.LuaUI('MorphStop')) then
    if (useLuaUI) then
      local readTeam, spec, specFullView = nil,GetSpectatingState()
      if (specFullView)
      then readTeam = Script.ALL_ACCESS_TEAM
      else readTeam = GetLocalTeamID() end
      CallAsTeam({ ['read'] = readTeam }, function()
      if (unitID)and(IsUnitVisible(unitID)) then
        Script.LuaUI.MorphStop(unitID)
      end
      end)
    end
  end
  return true
end

local function MorphProgress(cmd, unitID, prog)
  if (morphUnits[unitID] ~= nil) then
    morphUnits[unitID].progress = prog
  end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:Initialize()
  --// get the morphDefs
  morphDefs = include("LuaRules/Configs/morph_defs.lua")
  if (not morphDefs) then gadgetHandler:RemoveGadget(); return; end
  morphDefs = ValidateMorphDefs(morphDefs)

  gadgetHandler:AddSyncAction("um_fin", SelectSwap)
  gadgetHandler:AddSyncAction("um_str", StartMorph)
  gadgetHandler:AddSyncAction("um_stp", StopMorph)
  gadgetHandler:AddSyncAction("um_prg", MorphProgress)
end


function gadget:Shutdown()
  gadgetHandler:RemoveSyncAction("um_fin")
  gadgetHandler:RemoveSyncAction("um_str")
  gadgetHandler:RemoveSyncAction("um_stp")
  gadgetHandler:RemoveSyncAction("um_prg")
end


function gadget:Update()
  local frame = Spring.GetGameFrame()
  if (frame>oldFrame) then
    oldFrame = frame
    if next(morphUnits) then
      local useLuaUI_ = Script.LuaUI('MorphUpdate')
      if (useLuaUI_~=useLuaUI) then --//Update Callins on change
        drawProgress = not Script.LuaUI('MorphDrawProgress')
        useLuaUI=useLuaUI_
      end

      if (useLuaUI) then
        local morphTable = {}
        local readTeam, spec, specFullView = nil,GetSpectatingState()
        if (specFullView)
          then readTeam = Script.ALL_ACCESS_TEAM
          else readTeam = GetLocalTeamID() end
        CallAsTeam({ ['read'] = readTeam }, function()
          for unitID, morphData in pairs(morphUnits) do
            if (unitID and morphData)and(IsUnitVisible(unitID)) then
              morphTable[unitID] = {progress=morphData.progress, into=morphData.def.into}
            end
          end
        end)
        Script.LuaUI.MorphUpdate(morphTable)
      end

    end
  end
end


local teamColors = {}
local function SetTeamColor(teamID,a)
  local color = teamColors[teamID]
  if (color) then
    color[4]=a
    glColor(color)
    return
  end
  local r, g, b = Spring.GetTeamColor(teamID)
  if (r and g and b) then
    color = { r, g, b }
    teamColors[teamID] = color
    glColor(color)
    return
  end
end


--// patchs a annoying popup on the first morph a type
local alreadyInit = {}
local function InitializeUnitShape(unitDefID,unitTeam)
  if (alreadyInit[unitTeam])and(alreadyInit[unitTeam][unitDefID]) then return end

  glPushMatrix()
  gl.ColorMask(false)
  glUnitShape(unitDefID, unitTeam)
  gl.ColorMask(true)
  glPopMatrix()
  if (alreadyInit[unitTeam]==nil) then alreadyInit[unitTeam] = {} end
  alreadyInit[unitTeam][unitDefID] = true
end


local function DrawMorphUnit(unitID, morphData, localTeamID)

  local h = GetUnitHeading(unitID)
  if (h==nil) then
    return  -- bonus, heading is only available when the unit is in LOS
  end
  local px,py,pz = GetUnitBasePosition(unitID)
  if (px==nil) then
    return
  end
  local unitTeam = GetUnitTeam(unitID)

  InitializeUnitShape(morphData.def.into,unitTeam) --BUGFIX

  local frac = math.fmod(gameFrame + unitID, 30) / 30
  local alpha = 2.0 * math.abs(0.5 - frac)

  SetTeamColor(unitTeam,alpha)
  glPushMatrix()
  glTranslate(px, py, pz)
  glRotate(h * (360 / 65535), 0, 1, 0)
  glUnitShape(morphData.def.into, unitTeam)
  glPopMatrix()

  --// cheesy progress indicator
  if (drawProgress)and(localTeamID)and
     ((unitTeam==localTeamID)or(localTeamID==Script.ALL_ACCESS_TEAM))
  then
    glPushMatrix()
    glPushAttrib(GL_COLOR_BUFFER_BIT)
    glTranslate(px, py+14, pz)
    glBillboard()
    local progStr = string.format("%.1f%%", 100 * morphData.progress)
    --AddWorldText(progStr, px, py, pz)
    gl.Text(progStr, 0, -20, 9, "oc")
    glPopAttrib()
    glPopMatrix()
  end
end




function gadget:DrawWorld()
  if ((not morphUnits) or (next(morphUnits) == nil)) then
    return --//no morphs to draw
  end

  gameFrame = GetGameFrame()
  CreateBillboard()

  gl.Blending(GL.SRC_ALPHA, GL.ONE)
  gl.DepthTest(GL.LEQUAL)

  local spec, specFullView = GetSpectatingState()
  local readTeam
  if (specFullView) then
    readTeam = Script.ALL_ACCESS_TEAM
  else
    readTeam = GetLocalTeamID()
  end

  CallAsTeam({ ['read'] = readTeam }, function()
    for unitID, morphData in pairs(morphUnits) do
      if (unitID and morphData)and(IsUnitVisible(unitID)) then  -- FIXME: huh?
        DrawMorphUnit(unitID, morphData,readTeam)
      end
    end
  end)
  gl.DepthTest(false)
  gl.Blending(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA)
end



--------------------------------------------------------------------------------
--  UNSYNCED
--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------
--  COMMON
--------------------------------------------------------------------------------