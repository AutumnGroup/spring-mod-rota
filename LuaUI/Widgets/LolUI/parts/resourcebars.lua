local partinfo = {
	name 	= "Resource bars",
	layer 	= 0,
}

local function short(n,f)
	if (f == nil) then
		f = 0
	end
	if (n > 10000000) then
		return string.format("%."..f.."fm",n/1000000)
	elseif (n > 10000) then
		return string.format("%."..f.."fk",n/1000)
	else
		return string.format("%."..f.."f",n)
	end
end

local function resourcebar(posx,posy,sizex,sizey,fontsize,resource,color)
	local current,storage,pull,income,expense,share,_,_ = Spring.GetTeamResources(Spring.GetMyTeamID(),resource)
	
	local r,g,b = color[1],color[2],color[3]
	
	setAlign(LEFT, TOP)
	setPos(posx,posy)
	setSize(sizex,sizey)
	local c = 1/3.14
	setColor(color[1]*c,color[2]*c,color[3]*c,1)
	drawRectangle()
	setColor(color[1],color[2],color[3],1)
	drawBar(current,storage)
	setColor(0,0,0)
	drawBorder(1)

	setAlign(LEFT, TOP)
	setSize(sizex,sizey*2)
	setPos(posx,posy)
	if (detectMouseClick(LEFTMOUSE,true)) then
		Spring.SetShareLevel(resource,((mouseposx/SCALERATIOX-posx)/sizex))
	end

	setSize(fontsize,fontsize)
	
	setAlign(RIGHT, TOP)
	setPos(posx-5,posy)
	drawString("\255\1\255\1+"..short(income,1),true,'o')
	setPos(posx-5,posy+fontsize)
	drawString("\255\255\1\1-"..short(pull,1),true,'o')
	
	if (expense ~= pull) then
		expense = short(expense,1)
		setPos(posx-5+10+getStringWidth("(-"..expense..")",fontsize),posy+fontsize)
		drawString("\255\200\1\1(-"..expense..")",true,'o')
	end

	setAlign(MIDDLE, TOP)
	setPos(posx+sizex/2,posy+fontsize)
	drawString(short(current),true,'o')
	
	setAlign(RIGHT, TOP)
	setPos(posx+sizex,posy+fontsize)
	drawString(short(storage),true,'o')

	setAlign(MIDDLE, TOP)
	local draggerextrasizey = 4
	setPos(posx+share*sizex,posy-draggerextrasizey/2)
	setSize(sizey,sizey+draggerextrasizey)
	setColor(1,0,0,0.75)
	drawRectangle()
	setColor(0,0,0)
	drawBorder(1)
end

local function main()
	if (VARS[partinfo.name] ~= true) then
		sSendCommands({"resbar 0"})
		VARS[partinfo.name] = true
	end
	
	local s = storePartOptions(partinfo.name,{
		fontsize = {
			v = 10,
			minv = 6,
			maxv = 20,
			caption = "Fontsize"
		},
		
		offset = {
			v = 7,
			minv = 2,
			maxv = 20,
			caption = "Offset"
		},
		
		border = {
			v = 1,
			minv = 0,
			maxv = 10,
			caption = "Border"
		},
		
		sizex = {
			v = 200,
			minv = 0,
			maxv = 1280,
			caption = "Size X"
		},
		
		sizey = {
			v = 5,
			minv = 0,
			maxv = 768,
			caption = "Size Y"
		},
		
		color_background = {
			id = "special",
			v = {0,0,0,0.5},
			caption = "Color: Background",
		},
		
		color_border = {
			id = "special",
			v = {0,0,0,1},
			caption = "Color: Border",
		},
	})
	
	local fontsize = s.fontsize.v
	local spread = 98
	local offset = s.offset.v
	local border = s.border.v
	local barsizex = s.sizex.v
	local width = s.sizey.v
	--local sizex = (barsizex*2+spread*2)/2
	--local sizey = (width+2+fontsize)*2+20
	local sizex = barsizex*2+spread*2
	local sizey = width+2+fontsize
	
	local posx = 242
	local posy = 0
	
	local color_background = s.color_background.v
	local color_border = s.color_border.v
	
	local expanded
	expanded,posx,posy = drawExpander(partinfo.name,"Resourcebar",fontsize,posx,posy,sizex,sizey,offset,border,true,color_background,color_border)
	
	if (expanded) then
		resourcebar(posx+spread,posy,barsizex,width,fontsize,"metal",{1,1,1})
		resourcebar(posx+barsizex+spread*2,posy,barsizex,width,fontsize,"energy",{1,1,0})
		
		--resourcebar(posx+spread,posy,barsizex,width,fontsize,"energy",{1,1,0})
		--resourcebar(posx+spread,posy+(width+2+fontsize)+20,barsizex,width,fontsize,"metal",{1,1,1})
		
	end
end

local function onunload()
	--[[
	sSendCommands({"resbar 1"})
	--]]
	VARS[partinfo.name] = false
end

return partinfo,main,onunload
