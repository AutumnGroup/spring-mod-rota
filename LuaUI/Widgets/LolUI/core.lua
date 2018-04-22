function widget:GetConfigData()
	local sx, sy = widgetHandler:GetViewSizes()
	return {
		disabledparts = GUIDATA.disabledparts,
		expanders = GUIDATA.expanders,
		movablelist = GUIDATA.movablelist,
		settings = GUIDATA.settings,
		lastvsx = vsx,
		lastvsy = vsy,
		profiles = GUIDATA.profiles,
	}
end
function widget:SetConfigData(data)
	local sx, sy = widgetHandler:GetViewSizes()
	GUIDATA.disabledparts  = data.disabledparts or {}
	GUIDATA.expanders = data.expanders or {}
	GUIDATA.movablelist = data.movablelist or {}
	GUIDATA.settings = data.settings or {}
	GUIDATA.profiles = data.profiles or {}
	SAVEDVSX = data.lastvsx
	SAVEDVSY = data.lastvsy
end

sGetActiveCmdDescs = Spring.GetActiveCmdDescs
sSendCommands = Spring.SendCommands
sGetGameFrame = Spring.GetGameFrame
sGetActiveCmdDescs = Spring.GetActiveCmdDescs
sIsGUIHidden = Spring.IsGUIHidden
sGetMouseState = Spring.GetMouseState
sSetMouseCursor = Spring.SetMouseCursor
sGetFPS = Spring.GetFPS

local math_sqrt = math.sqrt
local math_min = math.min
local math_max = math.max
local string_format = string.format
local string_char = string.char
local string_sub = string.sub


glSlaveMiniMap = gl.SlaveMiniMap
local glTranslate = gl.Translate
local glColor = gl.Color
local glTexture = gl.Texture
local glTexRect = gl.TexRect
local glRect = gl.Rect
local glDrawMiniMap = gl.DrawMiniMap
local glResetState = gl.ResetState
local glResetMatrices = gl.ResetMatrices
local glText = gl.Text
local glGetTextWidth = gl.GetTextWidth
local glLineWidth = gl.LineWidth
local glShape = gl.Shape

local glGetTextWidth = gl.GetTextWidth

local GL_LINES = GL.LINES



vsx, vsy = widgetHandler:GetViewSizes()
local lastvsx = vsx
local lastvsy = vsy
local useDefaultMouseCursor = false

DRAWBOARDX = 1280
DRAWBOARDY = 768

CONSOLEBUFFER = {}

MOUSEOVERTIMEOUT = 30 -- used in menus/expanders

CURRENTGAMEFRAME = sGetGameFrame()
CURRENTFPS = 1

LEFTMOUSE = 1
MIDDLEMOUSE = 2
RIGHTMOUSE = 3

LEFT = 1
RIGHT = 2

MIDDLE = 3
CENTER = 3

TOP = 4
BOTTOM = 5

mouseposx = 0
mouseposy = 0


VARS = {}
GUIDATA = {}
GUIDATA.posx = 0
GUIDATA.posy = 0
GUIDATA.sizex = 0
GUIDATA.sizey = 0
GUIDATA.red = 1
GUIDATA.green = 1
GUIDATA.blue = 1
GUIDATA.alpha = 1
GUIDATA.alignx = LEFT
GUIDATA.aligny = TOP
GUIDATA.disabledparts = {}
GUIDATA.clickblockers = {}
GUIDATA.clickunblockers = {}
GUIDATA.mousebuttons = {}
GUIDATA.mousebuttons.waspressed = {}
GUIDATA.mousebuttons.waspressedpos = {}
GUIDATA.mousebuttons.ispressed = {}
GUIDATA.mousebuttons.wasreleased = {}
GUIDATA.movablelist = {}
GUIDATA.expanders = {}
GUIDATA.coloring = {}
GUIDATA.options = {}
GUIDATA.rawoptions = {}
GUIDATA.settings = {}
GUIDATA.profiles = {}
GUIDATA.profiles[1] = GUIDATA.profiles[1] or {}


function getColorBrightness(r,g,b)
	r = r*255
	g = g*255
	b = b*255
	return math_sqrt(0.241*r*r+0.691*g*g+0.068*b*b) -- http://alienryderflex.com/hsp.html
end

function convertColor(r,g,b)
	r = string_format("%i",r*255)
	if (r == "0") then r = 1 end
	g = string_format("%i",g*255)
	if (g == "0") then g = 1 end
	b = string_format("%i",b*255)
	if (b == "0") then b = 1 end
	local convertedcolor = string_char(255)..string_char(r)..string_char(g)..string_char(b)
	return convertedcolor
end

function copytable(t)
	local r = {}
	for i,v in pairs(t) do r[i] = v end
	return r
end

function aligncalc()
	local x,y,horizontal,vertical
	if (((GUIDATA.alignx > 2) and (GUIDATA.alignx ~= 3)) or 
		((GUIDATA.aligny < 2) and (GUIDATA.aligny ~= 3))) then
		horizontal = GUIDATA.aligny
		vertical = GUIDATA.alignx
		
		GUIDATA.alignx = horizontal
		GUIDATA.aligny = vertical
	else
		horizontal = GUIDATA.alignx
		vertical = GUIDATA.aligny
	end
	
	if (horizontal == LEFT) then 
		x = GUIDATA.posx
	elseif (horizontal == CENTER) then
		x = GUIDATA.posx - GUIDATA.sizex/2
	elseif (horizontal == RIGHT) then
		x = GUIDATA.posx - GUIDATA.sizex
	else
		x = GUIDATA.posx
	end
	
	if (vertical == TOP) then
		y = vsy - GUIDATA.posy - GUIDATA.sizey
	elseif (vertical == MIDDLE) then
		y = vsy - GUIDATA.posy - GUIDATA.sizey/2
	elseif (vertical == BOTTOM) then
		y = vsy - GUIDATA.posy
	else
		y = vsy - GUIDATA.posy - GUIDATA.sizey
	end
	
	return x,y
end

function setPos(x,y)
	if (x ~= nil) then
		GUIDATA.posx = x * SCALERATIOX
	end
	if (y ~= nil) then
		GUIDATA.posy = y * SCALERATIOY
	end
end

function setSize(x,y)
	if (x ~= nil) then
		GUIDATA.sizex = x * SCALERATIOX
	end
	if (y ~= nil) then
		GUIDATA.sizey = y * SCALERATIOY
	end
end

function setTexture(texture)
	GUIDATA.texture = texture
end

function setColor(r,g,b,a)
	if (type(r) == "table") then
		GUIDATA.red = r[1] or GUIDATA.red
		GUIDATA.green = r[2] or GUIDATA.green
		GUIDATA.blue = r[3] or GUIDATA.blue
		GUIDATA.alpha = r[4] or GUIDATA.alpha
	else
		GUIDATA.red = r or GUIDATA.red
		GUIDATA.green = g or GUIDATA.green
		GUIDATA.blue = b or GUIDATA.blue
		GUIDATA.alpha = a or GUIDATA.alpha
	end
end

function setColorAlpha(a)
	GUIDATA.alpha = a
end

function setAlign(horizontal,vertical)
	GUIDATA.alignx = horizontal
	GUIDATA.aligny = vertical
end

function drawRectangle()
	if (GUIDATA.alpha <= 0) then
		return
	end

	glColor(GUIDATA.red,GUIDATA.green,GUIDATA.blue,GUIDATA.alpha)
	local x,y = aligncalc()
	glTranslate(x, y, 0) -- set drawing pointer
	if (GUIDATA.texture ~= nil) then
		glTexture(GUIDATA.texture)
		glTexRect(GUIDATA.sizex,GUIDATA.sizey,0,0,true,true)
		glTexture(false)
	else
		glRect(GUIDATA.sizex,GUIDATA.sizey,0,0)
	end
	glTranslate(-x,-y,0) -- restore drawing pointer
end

function drawMinimap()
	local x,_ = aligncalc() --minor hack because of some inconsistencies
	local vertical = GUIDATA.aligny
	if (vertical == TOP) then
		y = GUIDATA.posy
	elseif (vertical == MIDDLE) then
		y = GUIDATA.posy + GUIDATA.sizey/2
	elseif (vertical == BOTTOM) then
		y = GUIDATA.posy + GUIDATA.sizey
	else
		y = GUIDATA.posy
	end
	
	sSendCommands({string_format("minimap geometry %i %i %i %i", x , y, GUIDATA.sizex, GUIDATA.sizey)})
	
	glDrawMiniMap()
	glResetState()
	glResetMatrices()
end

function getStringWidth(text,fontsize)
	return glGetTextWidth(text)*fontsize
end

function drawString(text,usecolorcodes,extra)
	if ((text == nil) or (text == "")) then
		return
	end
	if (usecolorcodes == nil) then
		usecolorcodes = false
	end
	if (extra == nil) then
		extra = ""
	end
	local options = "n"
	if (usecolorcodes) then
		options = ""
	end
	options = options..extra
	
	local x,y = aligncalc()
	if (GUIDATA.alignx == CENTER) then
		options = options.."c"
	elseif (GUIDATA.alignx == RIGHT) then
		options = options.."r"
	end
	
	if (not usecolorcodes) then
		glColor(GUIDATA.red,GUIDATA.green,GUIDATA.blue,GUIDATA.alpha)
	end
	glText(text,GUIDATA.posx,y,GUIDATA.sizex,options)
end

local blockmouseclick = {}
function makeClickBlocker(mousebutton)
	local x,y = aligncalc()
	if (((mouseposx >= x) and (mouseposx <= x + GUIDATA.sizex))
	and ((mouseposy >= y) and (mouseposy <= y + GUIDATA.sizey))) then
		if (mousebutton == nil) then
			blockmouseclick[LEFTMOUSE] = true
			blockmouseclick[MIDDLEMOUSE] = true
			blockmouseclick[RIGHTMOUSE] = true
		else
			blockmouseclick[mousebutton] = true
		end
	end
end

local unblockmouseclick = {}
function makeClickUnblocker(mousebutton)
	local x,y = aligncalc()
	if (((mouseposx >= x) and (mouseposx <= x + GUIDATA.sizex))
	and ((mouseposy >= y) and (mouseposy <= y + GUIDATA.sizey))) then
		if (mousebutton == nil) then
			unblockmouseclick[LEFTMOUSE] = true
			unblockmouseclick[MIDDLEMOUSE] = true
			unblockmouseclick[RIGHTMOUSE] = true
		else
			unblockmouseclick[mousebutton] = true
		end
	end
end

function detectMouseClick(mousebutton,doesrepeat)
	if (type(mousebutton) ~= "number") then
		return false
	end
	if (doesrepeat == nil) then
		doesrepeat = false
	end
	if (not doesrepeat) then
		if (not GUIDATA.mousebuttons.waspressed[mousebutton]) then
			return false
		end
	else
		if (not GUIDATA.mousebuttons.ispressed[mousebutton]) then
			return false
		end
	end
	
	local x,y = aligncalc()
	
	if (GUIDATA.mousebuttons.waspressedpos[mousebutton] ~= {}) then
		local pposx = GUIDATA.mousebuttons.waspressedpos[mousebutton][1]
		local pposy = GUIDATA.mousebuttons.waspressedpos[mousebutton][2]
		if (((pposx >= x) and (pposx <= x + GUIDATA.sizex))
		and ((pposy >= y) and (pposy <= y + GUIDATA.sizey))) then
			--nuthin'
		else
			return false
		end
	end
	
	if (((mouseposx >= x) and (mouseposx <= x + GUIDATA.sizex))
	and ((mouseposy >= y) and (mouseposy <= y + GUIDATA.sizey))) then
		GUIDATA.mousebuttons.waspressedpos[mousebutton] = {mouseposx,mouseposy}
		return true
	end
	return false
end

function detectMouseover()
	local x,y = aligncalc()
	if (((mouseposx >= x) and (mouseposx <= x + GUIDATA.sizex))
	and ((mouseposy >= y) and (mouseposy <= y + GUIDATA.sizey))) then
		return true
	end
	return false
end

function createMovable(id,posx,posy,sizex,sizey,mbutton,minx,miny,maxx,maxy)
	if (mbutton == nil) then
		mbutton = LEFTMOUSE
	end
	local m = GUIDATA.movablelist[id]
	if (type(m) ~= "table") then
		m = {}
	else
		posx = m.posx
		posy = m.posy
	end
	
	setPos(posx,posy)
	setSize(sizex,sizey)
	
	local clicked = m.clicked
	if (detectMouseClick(mbutton)) then
		clicked = true
	end
	if (clicked and (not GUIDATA.mousebuttons.ispressed[mbutton])) then
		clicked = nil
		m.mouseclickx = nil
	end
	
	local tempx,tempy
	if (clicked) then
		if (m.mouseclickx == nil) then
			m.mouseclickx = mouseposx/SCALERATIOX
			m.mouseclicky = (DRAWBOARDY - mouseposy/SCALERATIOY)
		end
		posx = mouseposx/SCALERATIOX - (m.mouseclickx-posx)
		posy = DRAWBOARDY - mouseposy/SCALERATIOY - (m.mouseclicky-posy)
		
		m.mouseclickx = (mouseposx/SCALERATIOX)
		m.mouseclicky = (DRAWBOARDY - mouseposy/SCALERATIOY)
	end
	
	if (minx ~= nil) then
		minx = minx / SCALERATIOX
		if (minx > posx) then
			posx = minx
		end
	end
	if (miny ~= nil) then
		miny = miny / SCALERATIOY
		if (miny > posy) then
			posy = miny
		end
	end
	if (maxx ~= nil) then
		maxx = maxx / SCALERATIOX
		if (maxx < (posx+sizex)) then
			posx = maxx-sizex
		end
	end
	if (maxy ~= nil) then
		maxy = maxy / SCALERATIOY
		if (maxy < (posy+sizey)) then
			posy = maxy-sizey
		end
	end
	
	m.clicked = clicked
	m.posx = posx
	m.posy = posy
	GUIDATA.movablelist[id] = m
	return posx,posy,clicked
end

function drawBorder(width,left,right,top,bottom)
	if (width == 0) then
		return
	end
	if (GUIDATA.alpha <= 0) then
		return
	end
	
	width = width or 1
	
	if (left == nil) then
		left = true
	end
	if (right == nil) then
		right = true
	end
	if (top == nil) then
		top = true
	end
	if (bottom == nil) then
		bottom = true
	end
	
	local posx,posy = aligncalc()
	local sizex = GUIDATA.sizex
	local sizey = GUIDATA.sizey
	local half = width/2
	
	local linescount = 0
	local lines = {}
	
	if (bottom) then
		linescount = linescount + 2
		lines[linescount-1] = {v={posx, posy+half}}
		lines[linescount] = {v={posx+sizex, posy+half}}
	end
	
	if (top) then
		linescount = linescount + 2
		lines[linescount-1] = {v={posx, posy+sizey-half}}
		lines[linescount] = {v={posx+sizex, posy+sizey-half}}
	end
	
	if (left) then
		linescount = linescount + 2
		if (bottom) then
			lines[linescount-1] = {v={posx+half, posy+half*2}}
		else
			lines[linescount-1] = {v={posx+half, posy}}
		end
		if (top) then
			lines[linescount] = {v={posx+half, posy+sizey-half*2}}
		else
			lines[linescount] = {v={posx+half, posy+sizey}}
		end
	end
	
	if (right) then
		linescount = linescount + 2
		if (bottom) then
			lines[linescount-1] = {v={posx+sizex-half, posy+half*2}}
		else
			lines[linescount-1] = {v={posx+sizex-half, posy}}
		end
		if (top) then
			lines[linescount] = {v={posx+sizex-half, posy+sizey-half*2}}
		else
			lines[linescount] = {v={posx+sizex-half, posy+sizey}}
		end
	end
	
	glColor(GUIDATA.red,GUIDATA.green,GUIDATA.blue,GUIDATA.alpha)
	glLineWidth(width)
	glShape(GL_LINES,lines)
end

function drawBar(current,capacity,inverted)
	if (inverted == nil) then
		inverted = false
	end
	if (current > capacity) then
		current = capacity 
	end
	if (current < 0) then
		current = 0
	end
	local sizex,sizey
	local temppx = GUIDATA.posx
	local temppy = GUIDATA.posy
	if (GUIDATA.sizex > GUIDATA.sizey) then
		sizex = current*GUIDATA.sizex/capacity/SCALERATIOX
		sizey = GUIDATA.sizey/SCALERATIOY
		if (inverted) then
			setAlign(RIGHT, TOP)
			setPos(GUIDATA.posx+GUIDATA.sizex,GUIDATA.posy)
		end
	else
		sizex = GUIDATA.sizex/SCALERATIOX
		sizey = current*GUIDATA.sizey/capacity/SCALERATIOY
		if (inverted) then
			setAlign(LEFT, BOTTOM)
			setPos(GUIDATA.posx,GUIDATA.posy+GUIDATA.sizey)
		end
	end
	local tempx = GUIDATA.sizex
	local tempy = GUIDATA.sizey
	setSize(sizex,sizey)
	drawRectangle()
	--restore hijacked variables
	GUIDATA.sizex = tempx
	GUIDATA.sizey = tempy
	GUIDATA.posx = temppx
	GUIDATA.posy = temppy
end

local function colorbarpart(partname,varname,colornum,posx,posy,sizex,sizey)
	local color = {1,0,0,1}
	if (colornum == 2) then
		color = {0,1,0,1}
	elseif (colornum == 3) then
		color = {0,0,1,1}
	elseif (colornum == 4) then
		color = {1,1,1,1}
	end
	tehcolor = GUIDATA.settings[partname][varname].v[colornum]
	
	local c = 1/3.14
	
	setAlign(LEFT, TOP)
	setPos(posx,posy)
	setSize(sizex,sizey)
	setColor(color[1]*c,color[2]*c,color[3]*c)
	drawRectangle()
	setColor(color[1],color[2],color[3])
	drawBar(tehcolor,1)
	setColor(0,0,0,1)
	drawBorder(1)
	
	if (detectMouseClick(LEFTMOUSE,true)) then
		GUIDATA.settings[partname][varname].v[colornum] = ((mouseposx/SCALERATIOX-posx)/sizex)
	end
end

local function drawColorbars(partname,varname,barsizex,barsizey,spready)
	local posx = GUIDATA.posx/SCALERATIOX
	local posy = GUIDATA.posy/SCALERATIOY
	colorbarpart(partname,varname,1,posx,posy,barsizex,barsizey)
	colorbarpart(partname,varname,2,posx,posy+(barsizey+spready),barsizex,barsizey)
	colorbarpart(partname,varname,3,posx,posy+(barsizey+spready)*2,barsizex,barsizey)
	colorbarpart(partname,varname,4,posx,posy+(barsizey+spready)*3,barsizex,barsizey)
end

function drawExpander(id,buttoncaption,fontsize,posx,posy,sizex,sizey,offset,border,enabled,color,bordercolor,blockclicks,clickonly)
	local buttonoffset = 5
	local buttonfontsize = 12
	local expandtimer = GUIDATA.expanders[id.."_expand"] or 0
	
	if ((GUIDATA.expanders[id.."_alwaysexpanded"] == nil) and enabled) then
		GUIDATA.expanders[id.."_alwaysexpanded"] = enabled
	end
	local alwaysexpand = GUIDATA.expanders[id.."_alwaysexpanded"]
	
	if (blockclicks == nil) then
		blockclicks = true
	end

	color = color or {0,0,0,0.5}
	bordercolor = bordercolor or {0,0,0,0.5}
	
	local buttonsizex = getStringWidth(buttoncaption,buttonfontsize)+buttonoffset*2
	local buttonsizey = fontsize+2*buttonoffset
	if (alwaysexpand) then
		buttonsizex = sizex+2*offset
		buttonsizey = offset
		buttoncaption = ""
	else
		offset = buttonoffset
	end
	
	local minx = 0
	local miny = 0
	local maxx = vsx
	local maxy = vsy
	local clicked
	setAlign(TOP, LEFT)
	setColor(0,1,0,1)
	posx,posy,clicked = createMovable(id.."_drag",posx-offset,posy-offset,buttonsizex,buttonsizey,LEFTMOUSE,minx,miny,maxx,maxy)
	posx,posy = posx+offset,posy+offset
	if (detectMouseover() and (not clicked)) then
		drawRectangle()
	end
	
	local notoverexpander = false
	setAlign(TOP, LEFT)
	setPos(posx-offset,posy-offset)
	setSize(buttonsizex,buttonsizey)
	if (clickonly) then
		if (detectMouseClick(LEFTMOUSE)) then
			GUIDATA.expanders[id.."_clicked"] = not GUIDATA.expanders[id.."_clicked"]
		end
	else
		if (detectMouseover()) then
			expandtimer = MOUSEOVERTIMEOUT
		end
	end
	if (detectMouseClick(RIGHTMOUSE)) then
		if (alwaysexpand == nil) then
			alwaysexpand = false
		end
		alwaysexpand = not alwaysexpand
	end
	
	setColor(color)
	drawRectangle()
	makeClickBlocker()
	local disabledborder
	if ((expandtimer > 0) or alwaysexpand) then
		setColor(bordercolor)
		if (posy+buttonsizey>vsy/2) then
			drawBorder(border,_,_,false,_)
			if (alwaysexpand) then
				disabledborder = "top"
			end
		else
			drawBorder(border,_,_,_,false)
			if (alwaysexpand) then
				disabledborder = "bottom"
			end
		end
	else
		setColor(bordercolor)
		drawBorder(border)
	end
	setPos(posx,posy)
	setSize(buttonfontsize,buttonfontsize)
	drawString(buttoncaption,true,'o')
	posy = posy+buttonsizey
	
	if (posy>vsy/2) then
		posy = posy-sizey-2*offset-buttonsizey
	end
	if (posx>vsx/2) then
		posx = posx-sizex-2*offset+buttonsizex
	end
	
	setAlign(TOP, LEFT)
	setPos(posx-offset,posy-offset)
	setSize(sizex+2*offset,sizey+2*offset)
	
	if (GUIDATA.expanders[id.."_clicked"] and (not alwaysexpand)) then
		expandtimer = MOUSEOVERTIMEOUT
	end
	
	local expanded = false
	if ((expandtimer > 0) or alwaysexpand) then
		expanded = true
		setAlign(LEFT, TOP)
		setColor(color)
		if (disabledborder == "top") then
			setPos(posx-offset,posy)
			setSize(sizex+offset*2,sizey+offset)
			posy=posy+offset
			drawRectangle()
			setColor(bordercolor)
			drawBorder(border,_,_,_,false)
		elseif (disabledborder == "bottom") then
			setPos(posx-offset,posy-offset)
			setSize(sizex+offset*2,sizey+offset)
			posy=posy-offset
			drawRectangle()
			setColor(bordercolor)
			drawBorder(border,_,_,false,_)
		else
			setPos(posx-offset,posy-offset)
			setSize(sizex+offset*2,sizey+offset*2)
			drawRectangle()
			setColor(bordercolor)
			drawBorder(border)
		end
		if (detectMouseover()) then
			expandtimer = MOUSEOVERTIMEOUT
		end
		if (blockclicks) then
			makeClickBlocker()
		end
	end
	
	if (alwaysexpand) then
		expandtimer = 0
	else
		if (expandtimer > 0) then
			expandtimer = expandtimer - 1
		end
	end
	
	GUIDATA.expanders[id.."_expand"] = expandtimer
	GUIDATA.expanders[id.."_alwaysexpanded"] = alwaysexpand
	
	return expanded,posx,posy
end

function drawMenu(id,posx,posy,options,colors,fontsize,spready,offset,border,expanderid,borders)
	if (VARS[id] == nil) then
		VARS[id] = {}
	end
	local noptions = #options
	
	local oldoffset
	if (options.core) then
		oldoffset = offset
		offset = 0
	end
	
	local sizex = 0
	for i=1,noptions do
		local captionwidth = getStringWidth(options[i].caption,fontsize)
		if (captionwidth > sizex) then
			sizex = captionwidth
		end
	end
	local sizey = noptions*fontsize+spready*(noptions-1)
	
	setAlign(TOP,LEFT)
	setPos(posx-offset,posy-offset)
	setSize(sizex+offset*2,sizey+offset*2)
	if (expanderid ~= nil) then
		if (detectMouseover()) then
			GUIDATA.expanders[expanderid.."_expand"] = MOUSEOVERTIMEOUT
		end
	end
	
	if (not options.core) then
		makeClickBlocker()
		setColor(colors.background)
		drawRectangle()
		setColor(colors.border)
		borders = borders or {}
		drawBorder(border,borders[1],borders[2],borders[3],borders[4])
	end
	
	for i=1,noptions do
		VARS[id][i] = VARS[id][i] or {}
		local o = options[i]
		o.enabled = VARS[id][i].enabled
		
		local optionposy = posy+(fontsize+spready)*(i-1)
		if (options.core) then
			offset = oldoffset
		end
		setPos(posx-offset,optionposy)
		setSize(sizex+offset*2,fontsize)
		if (options.core) then
			offset = 0
		end
		
		if (o.enabled or detectMouseClick(LEFTMOUSE,true) or detectMouseClick(RIGHTMOUSE,true)) then
			setColor(colors.pressed)
			drawRectangle()
		end
		if (detectMouseover()) then
			setColor(colors.mouseover)
			drawRectangle()
		end
		
		if (detectMouseClick(LEFTMOUSE)) then
			o.enabled = not o.enabled
		end
		
		if (detectMouseClick(RIGHTMOUSE)) then
			o.altenabled = not o.altenabled
		end
		
		if (o.enabled) then
			for j=1,noptions do
				if (j~=i) then
					VARS[id][j].enabled = false
				end
			end
		end
		
		setAlign(TOP,LEFT)
		setSize(fontsize,fontsize)
		setPos(posx,optionposy)
		drawString(o.caption,true,'o')
		
		if (o.enabled) then
			if (type(o.action) == "table") then
				if (options.core) then
					offset = oldoffset
				end
				local newsizex = 0
				for x=1,#o.action do
					local captionwidth = getStringWidth(o.action[x].caption,fontsize)
					if (captionwidth > newsizex) then
						newsizex = captionwidth
					end
				end
				local newsizey = #o.action*fontsize+spready*(#o.action-1)
				
				local newposx = posx-newsizex-offset*2+border
				local newposy = optionposy
				if (newposy+newsizey > DRAWBOARDY) then
					newposy = optionposy-newsizey+offset*2
				end
				
				drawMenu(id.."o"..i,newposx,newposy,o.action,colors,fontsize,spready,offset,border,expanderid,newborders)
			else
				if (o.id == "special") then
					local newsizex = o.sizex+offset*2
					local newsizey = o.sizey+offset*2
					local newposx = posx-newsizex-offset+border
					local newposy = optionposy
					if (newposy+newsizey > DRAWBOARDY) then
						newposy = optionposy-newsizey+offset*2
					end
					setPos(newposx,newposy)
					setSize(newsizex,newsizey)
					if (expanderid ~= nil) then
						if (detectMouseover()) then
							GUIDATA.expanders[expanderid.."_expand"] = MOUSEOVERTIMEOUT
						end
					end
					makeClickBlocker()
					setColor(colors.background)
					drawRectangle()
					setColor(colors.border)
					borders = borders or {}
					drawBorder(border,borders[1],borders[2],borders[3],borders[4])
					setPos(newposx+offset,newposy+offset)
				end
			end
		end
		
		if (o.enabled) then
			if (type(o.action) == "function") then
				o.action()
				o.enabled = o.repeataction
			end
		end
		
		if (o.altenabled) then
			if (type(o.altaction) == "function") then
				o.altaction()
				o.altenabled = o.repeataltaction
			end
		end
		
		VARS[id][i].enabled = o.enabled
		VARS[id][i].altenabled = o.altenabled
	end
end

function stepSet(cur,limit,step)
	local _,ctrl,_,shift = Spring.GetModKeyState()
	if (shift) then
		step = step * 5
	end
	if (ctrl) then
		step = step * 20
	end
	if (step > 0) then
		return math_min(cur+step,limit)
	end
	return math_max(cur+step,limit)
end

function generatePartOptions(partname,settings)
	local sortbuffer = {}
	for name,_ in pairs(settings) do
		sortbuffer[#sortbuffer+1] = name
	end
	table.sort(sortbuffer)
	local tempbuffer = {}
	for i=1,#sortbuffer do
		local var = sortbuffer[i]
		local t = settings[sortbuffer[i]]
		
		GUIDATA.settings[partname] = GUIDATA.settings[partname] or {}
		if (GUIDATA.settings[partname][var] == nil) then
			GUIDATA.settings[partname] = settings
		end
		GUIDATA.settings[partname][var].v = GUIDATA.settings[partname][var].v or t.v
		local option
		
		if (t.id == "special") then
			option = {
				id = t.id,
				repeataction = true,
				
				caption = t.caption,
				sizex = 100,
				sizey = 10*4+2*3,
				action = function ()
					drawColorbars(partname,var,100,10,2)
				end,
				altaction = function ()
					local alt,_,_,_ = Spring.GetModKeyState()
					GUIDATA.settings[partname][var].v = t.v
				end,
			}
		else
			option = {
				caption = t.caption..": \255\1\255\1"..GUIDATA.settings[partname][var].v,
				action = function ()
					local alt,_,_,_ = Spring.GetModKeyState()
					if (alt) then
						GUIDATA.settings[partname][var].v = t.v --default if alt
					else
						GUIDATA.settings[partname][var].v = stepSet(GUIDATA.settings[partname][var].v,t.maxv,1)
					end
				end,
				altaction = function ()
					local alt,_,_,_ = Spring.GetModKeyState()
					if (alt) then
						GUIDATA.settings[partname][var].v = t.v
					else
						GUIDATA.settings[partname][var].v = stepSet(GUIDATA.settings[partname][var].v,t.minv,-1)
					end
				end,
			}
		end
		tempbuffer[#tempbuffer+1] = option
	end
	GUIDATA.options[partname] = tempbuffer
	return tempbuffer
end

local function checkSettings(partname,settings)
	VARS["settingschecker"] = VARS["settingschecker"] or {}
	if (not VARS["settingschecker"][partname]) then
		VARS["settingschecker"][partname] = true
		if (GUIDATA.settings[partname] == nil) then
			return settings
		end
		for var,t in pairs(GUIDATA.settings[partname]) do
			for s,_ in pairs(t) do
				local err = false
				if (settings[var] == nil) then
					return settings
				end
				if (settings[var][s] == nil) then
					return settings
				end
			end
		end
	end
	return GUIDATA.settings[partname]
end

function storePartOptions(partname,settings)
	GUIDATA.settings[partname] = checkSettings(partname,settings)
	GUIDATA.rawoptions[partname] = settings
	return GUIDATA.settings[partname]
end





function widget:MousePress(x,y,mousebutton)
	if (unblockmouseclick[mousebutton]) then
		return false
	end
	if (blockmouseclick[mousebutton]) then
		return true
	end
	return false
end

local function GetCurrentCommands()
	local hiddencmds = {
		[76] = true,	--load units clone
		[65] = true,	--selfd
		[9] = true,	--gatherwait
		[8] = true,	--squadwait
		[7] = true,	--deathwait
		[6] = true,	--timewait
	}

	local buildcmds = {}
	local statecmds = {}
	local othercmds = {}
	local buildcmdscount = 0
	local statecmdscount = 0
	local othercmdscount = 0
	for index,cmd in pairs(sGetActiveCmdDescs()) do
		if (type(cmd) == "table") then
			if (
			(not hiddencmds[cmd.id]) and
			(cmd.action ~= nil) and
			--(not cmd.disabled) and
			(cmd.type ~= 21) and
			(cmd.type ~= 18) and
			(cmd.type ~= 17)
			) then
				if ((cmd.type == 20) --build building
				or (string_sub(cmd.action,1,10) == "buildunit_")) then
					buildcmdscount = buildcmdscount + 1
					buildcmds[buildcmdscount] = cmd
				elseif (cmd.type == 5) then
					statecmdscount = statecmdscount + 1
					statecmds[statecmdscount] = cmd
				else
					othercmdscount = othercmdscount + 1
					othercmds[othercmdscount] = cmd
				end
			end
		end
	end
	
	local tempcmds = {}
	for i=1,statecmdscount do
		tempcmds[i] = statecmds[i]
	end
	for i=1,othercmdscount do
		tempcmds[i+statecmdscount] = othercmds[i]
	end
	othercmdscount = othercmdscount + statecmdscount
	othercmds = tempcmds
	
	return buildcmds,othercmds
end

local consolelinecount = 0
function widget:AddConsoleLine(line,priority)
	consolelinecount = consolelinecount + 1
	CONSOLEBUFFER[consolelinecount] = {[1] = line, [2] = CURRENTGAMEFRAME}
end

function widget:GameFrame(n)
	CURRENTGAMEFRAME = n
end


function widget:DrawScreen()
	if (sIsGUIHidden()) then
		return
	end
	
	--------------------
	-- resizing
	if (SAVEDVSX) then
		lastvsx = SAVEDVSX
		lastvsy = SAVEDVSY
		SAVEDVSX = nil
		SAVEDVSY = nil
	end
	vsx, vsy = widgetHandler:GetViewSizes()
	SCALERATIOX = vsx/DRAWBOARDX
	SCALERATIOY = vsy/DRAWBOARDY
	SCALERATIOX = SCALERATIOY
	if (((lastvsx ~= vsx) or (lastvsy ~= vsy)) and (lastvsx~=1)) then
		for n,m in pairs(GUIDATA.movablelist) do
			if (m.posx > lastvsx*lastvsx/DRAWBOARDX/2) then
				GUIDATA.movablelist[n].posx = m.posx + (vsx/SCALERATIOY-lastvsx/(lastvsy/DRAWBOARDY)) --magic
			end
		end
	end
	--
	--------------------

	
	--------------------
	-- mouseclicks
	local mx,my,m1,m2,m3 = sGetMouseState() --get mouse position
	mouseposx = mx
	mouseposy = my
	local buttons = {m1,m2,m3}
	for id=1,3 do
		ispressednow = buttons[id]
		if (GUIDATA.mousebuttons.waspressed[id] and ispressednow) then
			GUIDATA.mousebuttons.waspressed[id] = false
		elseif ((not GUIDATA.mousebuttons.ispressed[id]) and ispressednow) then
			GUIDATA.mousebuttons.waspressed[id] = true
			GUIDATA.mousebuttons.waspressedpos[id] = {mouseposx,mouseposy}
			GUIDATA.mousebuttons.wasreleased[id] = false
		elseif (GUIDATA.mousebuttons.ispressed[id] and (not ispressednow)) then
			GUIDATA.mousebuttons.waspressed[id] = false
			GUIDATA.mousebuttons.wasreleased[id] = true
			GUIDATA.mousebuttons.waspressedpos[id] = {}
		elseif (GUIDATA.mousebuttons.ispressed[id] and ispressednow) then
			GUIDATA.mousebuttons.wasreleased[id] = false
			GUIDATA.mousebuttons.waspressed[id] = false
		end
		GUIDATA.mousebuttons.ispressed[id] = ispressednow
	end
	blockmouseclick[LEFTMOUSE] = false
	blockmouseclick[MIDDLEMOUSE] = false
	blockmouseclick[RIGHTMOUSE] = false
	unblockmouseclick[LEFTMOUSE] = false
	unblockmouseclick[MIDDLEMOUSE] = false
	unblockmouseclick[RIGHTMOUSE] = false
	--
	--------------------	
	
	BUILDCMDS,OTHERCMDS = GetCurrentCommands()
	
	for i=1,partcount do
		local part = partlist[i]
		if (part["enabled"]) then
			part[1]()
		end
	end
	
	if ((blockmouseclick[LEFTMOUSE] and (not unblockmouseclick[LEFTMOUSE]))
	or (blockmouseclick[RIGHTMOUSE] and (not unblockmouseclick[RIGHTMOUSE]))
	or (blockmouseclick[MIDDLEMOUSE] and (not unblockmouseclick[MIDDLEMOUSE]))) then
		useDefaultMouseCursor = true
	else
		useDefaultMouseCursor = false
	end

	lastvsx = vsx
	lastvsy = vsy
end

function widget:Update()
	blockmouseclick[LEFTMOUSE] = false
	blockmouseclick[MIDDLEMOUSE] = false
	blockmouseclick[RIGHTMOUSE] = false
	unblockmouseclick[LEFTMOUSE] = false
	unblockmouseclick[MIDDLEMOUSE] = false
	unblockmouseclick[RIGHTMOUSE] = false
end

function widget:IsAbove(x, y)
	if (useDefaultMouseCursor) then 
		return true
	end
	return false
end

local killIceUIOnce = false

function widget:Initialize()
    if (GUIDATA.settings["RESETHACKLOL"] ~= 2) then
		GUIDATA.movablelist = {}
		GUIDATA.expanders = {}
		GUIDATA.settings = {}
		VARS["settingschecker"] = {}
		for i, widget in ipairs(widgetHandler.widgets) do
			if (widget:GetInfo().name == 'IceUI') then
				killIceUIOnce = true -- Added for BA 6.92
				break
			end
		end
		GUIDATA.settings["RESETHACKLOL"] = 2
	end
	for i, widget in ipairs(widgetHandler.widgets) do
      if (widget:GetInfo().name == 'Old BA Layout') then
        Spring.SendCommands{"luaui disablewidget Old BA Layout"} -- Added for BA 6.92
      end
    end
    local layerlist = {}
    local layerpartlist = {}
    local files = VFS.DirList("LuaUI/Widgets/LolUI/parts/", "*.lua")

    local filelist = {}
    for _,filestring in ipairs(files) do
		local filename = string.match(filestring, '([^/\\]+)%.[^%.]+$')
		if filename then
			filelist[filename] = true
		end
    end
	for filename in pairs(filelist) do
		local partinfo,part,onunload = VFS.Include("LuaUI/Widgets/LolUI/parts/" .. filename .. ".lua")
		local layer = partinfo.layer
		if ((type(layer) == "number") and (type(part) == "function")) then
			if (type(layerpartlist[layer]) ~= "table") then
				layerpartlist[layer] = {}
			end
			local enabled = true
			if (partinfo.enabled ~= nil) then
				if (not partinfo.enabled) then
					GUIDATA.disabledparts[partinfo.name] = true
					enabled = false
				end
			end
			if (GUIDATA.disabledparts[partinfo.name]) then
				enabled = false
			end
			table.insert(layerpartlist[layer],{
				[1] = part,
				["name"] = partinfo.name, 
				["framedelay"] = partinfo.framedelay,
				["enabled"] = enabled,
				["filename"] = filename,
				["onunload"] = onunload,
			})
			layerlist[layer] = true
		end
	end
	
	partlist = {}
	partcount = 0
	for layer,_ in pairs(layerlist) do
		local layerparts = layerpartlist[layer]
		for i=1,#layerparts do
			partcount = partcount + 1
			partlist[partcount] = layerparts[i]
		end
	end
	OldMinimapGeometry = Spring.GetConfigString("MiniMapGeometry", "2 2 200 200")
end

function widget:Shutdown()
	glSlaveMiniMap(false)
	sSendCommands({
		"minimap geometry "..OldMinimapGeometry,
		"tooltip 1",
		"resbar 1",
		"info 1",
		"clock 1",
		"fps 1",
		"console 1",
	})
	
	widgetHandler:ConfigLayoutHandler(true)
	Spring.ForceLayoutUpdate()
end
