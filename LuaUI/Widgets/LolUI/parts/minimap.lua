local partinfo = {
	name 	= "Minimap",
	layer 	= 0,
}

local function main()
	if (VARS[partinfo.name] ~= true) then
		VARS.OldMinimapGeometry = Spring.GetConfigString("MiniMapGeometry", "2 2 200 200")
		glSlaveMiniMap(true)
		VARS[partinfo.name] = true
	end
	
	local s = storePartOptions(partinfo.name,{
		offset = {
			v = 4,
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
			caption = "MaxSize X"
		},
		
		sizey = {
			v = 200,
			minv = 0,
			maxv = 768,
			caption = "MaxSize Y"
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
	
	local fontsize = 12
	local border = s.border.v
	local offset = s.offset.v
	local sizex = s.sizex.v
	local sizey = s.sizey.v
	
	local posx = 0
	local posy = 0
	
	local color_background = s.color_background.v
	local color_border = s.color_border.v
	
	setAlign(TOP, LEFT)
	if (Game.mapX > Game.mapY) then
		sizey = sizey*Game.mapY/Game.mapX
	elseif (Game.mapX < Game.mapY) then
		sizex = sizex*Game.mapX/Game.mapY
	end
	
	local expanded
	expanded,posx,posy = drawExpander(partinfo.name,"Minimap",fontsize,posx,posy,sizex,sizey,offset,border,true,color_background,color_border)
	
	if (expanded) then
		setPos(posx,posy)
		setSize(sizex,sizey)
		drawMinimap()
		makeClickUnblocker()
		
		setPos(posx-1,posy-1)
		setSize(sizex+2,sizey+2)
		setColor(0,0,0)
		drawBorder(1)
	end
end

local function onunload()
	glSlaveMiniMap(false)
	sSendCommands({"minimap geometry "..VARS.OldMinimapGeometry})
	VARS[partinfo.name] = false
end 

return partinfo,main,onunload
