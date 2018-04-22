local partinfo = {
	name 	= "FPS / Clock",
	layer 	= 0,
	framedelay = 4,
}

local function main()
	if (VARS[partinfo.name] ~= true) then
		sSendCommands({
			"clock 0",
			"fps 0",
		})
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
			v = 5,
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
		
		color_background = {
			id = "special",
			v = {0,0,0,0.3},
			caption = "Color: Background",
		},
		
		color_border = {
			id = "special",
			v = {0,0,0,1},
			caption = "Color: Border",
		},
	})
	
	local fontsize = s.fontsize.v
	local offset = s.offset.v
	local border = s.border.v
	local color_background = s.color_background.v
	local color_border = s.color_border.v
	
	local fps,clockline
	local gametime = Spring.GetGameSeconds()
	local hours = (gametime-gametime%3600)/3600
	local minutes = ((gametime-hours*3600)-(gametime-hours*3600)%60)/60
	local seconds = gametime-hours*3600-minutes*60
	minutes = string.format("%.2i",minutes)
	hours = string.format("%.2i",hours)
	seconds = string.format("%.2i",seconds)
	
	fps = Spring.GetFPS()
	clockline = hours..":"..minutes..":"..seconds
	--[[local clocksize = getStringWidth(clockline,fontsize)
	local fpssize = getStringWidth(fps,fontsize)
	
	local sizex = clocksize
	if (sizex < fpssize) then
		sizex = fpssize
	end
	--]]
	local sizey = fontsize*2+1
	local sizex = 60
	
	local posx = vsx/SCALERATIOX
	local posy = 40
	
	local expanded
	expanded,posx,posy = drawExpander(partinfo.name,"Clock",fontsize,posx,posy,sizex,sizey,offset,border,true,color_background,color_border)
	
	if (expanded) then
		setAlign(RIGHT,TOP)
		setSize(fontsize,fontsize)
		setPos(posx+sizex,posy)
		drawString("\255\255\255\255"..clockline,true,'o')
		setPos(posx+sizex,posy+fontsize+1)
		drawString("\255\255\255\1"..fps,true,'o')
	end
end

local function onunload()
	--[[
	sSendCommands({
		"clock 1",
		"fps 1",
	})
	--]]
	VARS[partinfo.name] = false
end

return partinfo,main,onunload
