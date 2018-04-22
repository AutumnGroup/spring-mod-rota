function widget:GetInfo()
	return {
		name = "gui_ai_marker",
		desc = "Display custom markers to identify units under control of the assist AI",
		author = "PepeAmpere",
		date = "2017-04-05",
		license = "notAlicense",
		layer = 5,
		enabled = true -- loaded by default?
	}
end

include('Headers/billboard.lua')

local glDepthTest = gl.DepthTest
local glDepthMask = gl.DepthMask
local glAlphaTest = gl.AlphaTest
local glTexture = gl.Texture
local glTexRect = gl.TexRect
local glTranslate = gl.Translate
local glBillboard = gl.BillboardFixed
local glCreateBillboard = gl.CreateBillboard
local glDrawFuncAtUnit = gl.DrawFuncAtUnit

local markedUnits = {}
local markedUnitsRadius = {}

local iconsize   = 16
local GL_GREATER = 516

-- TBD, hardcoded now, no relation with XP makers, yet
local CORRECTION_X = -5
local CORRECTION_Y = -16
local x1 = -iconsize+CORRECTION_X
local y1 = CORRECTION_Y
local x2 = CORRECTION_X
local y2 = iconsize + CORRECTION_Y

local rankTexBase = 'LuaUI/Images/aiMarkers/'
local textureLocked = rankTexBase .. "locked32.png"
local textureUnlocked = rankTexBase .. "unlocked32.png"


-- get madatory module operators
VFS.Include("LuaRules/modules.lua") -- modules table
VFS.Include(modules.attach.data.path .. modules.attach.data.head) -- attach lib module

-- get other madatory dependencies
attach.Module(modules, "message") -- communication backend

function AddUnitAIMarkers(units, locked)
	for i=1, #units do
		local thisUnitID = units[i]
		local unitDefID = Spring.GetUnitDefID(thisUnitID)
		local ud = UnitDefs[unitDefID]
		
		if (ud) then
		
			if (locked) then 
				markedUnits[thisUnitID] = textureLocked
			else
				markedUnits[thisUnitID] = textureUnlocked
			end
			markedUnitsRadius[thisUnitID] = ud.height
		end
	end
end

function RemoveUnitAIMarkers(units)
	for i=1, #units do
		local thisUnitID = units[i]
		markedUnits[thisUnitID] = nil
		markedUnitsRadius[thisUnitID] = nil
	end
end

function widget:RecvLuaMsg(msg, playerID)
	local decodedMsg = message.Decode(msg)
	if (decodedMsg ~= nil and decodedMsg.subject ~= nil) then
		if (decodedMsg.subject == "AddUnitAIMarkers") then
			AddUnitAIMarkers(decodedMsg.units, decodedMsg.locked)
		end
		if (decodedMsg.subject == "RemoveUnitAIMarkers") then
			RemoveUnitAIMarkers(decodedMsg.units)
		end
	end
end

function widget:UnitDestroyed(unitID)
	RemoveUnitAIMarkers({unitID})
end

-- DRAWING FUNCTIONS

local function DrawUnitFunc(yshift)
	glTranslate(0,yshift,0)
	glBillboard()
	glTexRect(x1,y1,x2,y2)
end

function widget:DrawWorld()
	if (next(markedUnits) == nil) then
		return -- avoid unnecessary GL calls
	end

	glCreateBillboard()

	glDepthMask(true)
	glDepthTest(true)
	glAlphaTest(GL_GREATER, 0.01)
	
	for unitID, texture in pairs(markedUnits) do
		glTexture(texture)
		glDrawFuncAtUnit(unitID, true, DrawUnitFunc, markedUnitsRadius[unitID])
	end
	
	glTexture(false)

	glAlphaTest(false)
	glDepthTest(false)
	glDepthMask(false)
end