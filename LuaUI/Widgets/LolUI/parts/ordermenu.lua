local partinfo = {
	name 	= "Ordermenu",
	layer 	= 0,
}

local function main()
	if (VARS[partinfo.name] ~= true) then
		VARS.ordermenuunloaded = false
		local function dummylayouthandler(xIcons, yIcons, cmdCount, commands) --gets called on selection change
			widgetHandler.commands = commands
			widgetHandler.commands.n = cmdCount
			widgetHandler:CommandsChanged()
			local iconList = {[1337]=9001}
			return "", xIcons, yIcons, {}, {}, {}, {}, {}, {}, {}, iconList
		end
		widgetHandler:ConfigLayoutHandler(dummylayouthandler) --override default build/ordermenu
		Spring.ForceLayoutUpdate()
		VARS[partinfo.name] = true
	end
	local othercmds = OTHERCMDS
	local othercmdscount = #othercmds
	
	local s = storePartOptions(partinfo.name,{
		offset = {
			v = 5,
			minv = 2,
			maxv = 20,
			caption = "Offset"
		},
		
		iconsizex = {
			v = 50,
			minv = 10,
			maxv = 100,
			caption = "Icon size X"
		},
		
		iconsizey = {
			v = 30,
			minv = 10,
			maxv = 100,
			caption = "Icon size Y"
		},
		
		iconsx = {
			v = 4,
			minv = 3,
			maxv = 20,
			caption = "Icons X"
		},
		
		iconsy = {
			v = 4,
			minv = 1,
			maxv = 20,
			caption = "Icons Y"
		},
		
		border = {
			v = 1,
			minv = 0,
			maxv = 10,
			caption = "Border"
		},
		
		border_icon = {
			v = 1,
			minv = 0,
			maxv = 10,
			caption = "Icon Border"
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
		
		color_icon_background = {
			id = "special",
			v = {0.1,0.1,0.1,1},
			caption = "Color: Icon Background",
		},
		
		color_icon_border = {
			id = "special",
			v = {0,0,0,1},
			caption = "Color: Icon Border",
		},
	})
	
	local fontsize = 12
	local border = s.border.v
	local iconborder = s.border_icon.v
	local iconsizex = s.iconsizex.v
	local iconsizey = s.iconsizey.v
	local iconsx = s.iconsx.v
	local iconsy = s.iconsy.v
	local spreadx = 1
	local spready = spreadx
	local textmargin = 5
	local offset = s.offset.v
	
	local sizex = (iconsx)*(iconsizex)+(iconsx-1)*(spreadx)
	local sizey = (iconsizey)*(iconsy+1)+(iconsy)*(spready)
	local posx = 0
	local posy = 220
	
	local color_background = s.color_background.v
	local color_border = s.color_border.v
	local color_buttonbackground = s.color_icon_background.v
	local color_buttonborder = s.color_icon_border.v
	local color_clickhighlight = {1,1,1,0.2,1}
	local color_selectedhighlight = {1,0,0,0.3,1}
	local color_mouseoverhighlight = {1,1,1,0.2,1}
	
	local expanded
	if (othercmdscount > 0) then
		expanded,posx,posy = drawExpander(partinfo.name,"Ordermenu",fontsize,posx,posy,sizex,sizey,offset,border,true,color_background,color_border)
	end
	
	if (expanded) then
		local iconsperpage = iconsx*iconsy
		if ((VARS.ordermenupage == nil) or (VARS.ordermenu_lastothercmdcount ~= othercmdscount)) then
			VARS.ordermenupage = 1
		end
		local page = VARS.ordermenupage
		local iconposx = posx
		local iconposy = posy
		local cmd
		for index=1+(page-1)*iconsperpage,othercmdscount+1 do
			local iconstodraw = 0
			local drawnextarrow = false
			if ((index > iconsperpage*page)
			and (index<=othercmdscount)) then
				drawnextarrow = true
				iconstodraw = iconstodraw + 1
			end
			local drawprevarrow = false
			if ((page > 1)
			and ((index == iconsperpage*page+1) or (index == othercmdscount+1))) then
				drawprevarrow = true
				iconstodraw = iconstodraw + 1
			end
			if (not (drawprevarrow or drawnextarrow)) then
				iconstodraw = 1
				if (index == othercmdscount+1) then
					break
				end
			end
			
			local _,_,_,currentcmd = Spring.GetActiveCommand()
			cmd = othercmds[index]
			if (((index-(page-1)*iconsperpage) > 1) 
			and (((index-(page-1)*iconsperpage)%iconsx) == 1)) then
				iconposy = iconposy+iconsizey+spready
				iconposx = posx
			end
			
			for i=1,iconstodraw do
				setAlign(TOP, LEFT)
				setSize(iconsizex,iconsizey)
			
				if (drawprevarrow and (i==1)) then
					iconposy = posy+iconsizey*iconsy+iconsy*spready
					iconposx = posx
					setPos(iconposx,iconposy)
					if (detectMouseClick(LEFTMOUSE)) then
						page = page - 1
						VARS.ordermenupage = page
					end
				elseif ((drawnextarrow and (i==1) and (not drawprevarrow))
				or (drawnextarrow and (i==2))) then
					iconposx = iconposx+(iconsx-1)*(iconsizex+spreadx)
					setPos(iconposx,iconposy)
					if (detectMouseClick(LEFTMOUSE)) then
						page = page + 1
						VARS.ordermenupage = page
					end
				end
				setPos(iconposx,iconposy)
				
				setColor(color_buttonbackground)
				drawRectangle()
				
				if (not (drawprevarrow or drawnextarrow)) then
					if (string.sub(cmd.texture,1,1) == "#") then
						if (cmd.disabled) then
							setColor(0.5,0.5,0.5,1)
						else
							setColor(1,1,1,1)
						end
						setTexture(cmd.texture)
						drawRectangle()
						setTexture(nil)
					end
					if (detectMouseClick(LEFTMOUSE,true) or detectMouseClick(RIGHTMOUSE,true)) then
						setColor(color_clickhighlight)
						drawRectangle()
					elseif (cmd.name == currentcmd) then
						setColor(color_selectedhighlight)
						drawRectangle()
					end
				end
				if (detectMouseover()) then
					setColor(color_mouseoverhighlight)
					drawRectangle()
					setColorAlpha(1)
					if (not (drawprevarrow or drawnextarrow)) then
						VARS.tooltip_show = true
						local line = {}
						line[1] = cmd.tooltip
						VARS.tooltip_line = line
					end
				end
				setColor(color_buttonborder)
				drawBorder(iconborder)
				
				
				if (drawprevarrow and (i==1)) then
					local symbol = "  <--  "
					setAlign(MIDDLE, CENTER)
					local icontextsize = (iconsizex-textmargin)/getStringWidth(symbol,1)
					setSize(icontextsize,icontextsize)
					setPos(iconposx+iconsizex/2,iconposy+iconsizey/2)
					setColor(1,1,1,1)
					drawString(symbol)
				elseif ((drawnextarrow and (i==1) and (not drawprevarrow))
				or (drawnextarrow and (i==2))) then
					local symbol = "  -->  "
					setAlign(MIDDLE, CENTER)
					local icontextsize = (iconsizex-textmargin)/getStringWidth(symbol,1)
					setSize(icontextsize,icontextsize)
					setPos(iconposx+iconsizex/2,iconposy+iconsizey/2)
					setColor(1,1,1,1)
					drawString(symbol)
				end
			end
			
			if (drawprevarrow or drawnextarrow) then
				local symbol = "   "..page.."   "
				setAlign(MIDDLE, CENTER)
				local icontextsize = (iconsizex-textmargin)/getStringWidth(symbol,1)
				setSize(icontextsize,icontextsize)
				setPos(posx+(iconsizex+spreadx)*iconsx/2,iconposy+iconsizey/2)
				setColor(1,1,1,1)
				drawString(symbol)
				break
			end
			
			if (detectMouseClick(LEFTMOUSE) or detectMouseClick(RIGHTMOUSE)) then
				local _,_,left,_,right = Spring.GetMouseState()
				local alt,ctrl,meta,shift = Spring.GetModKeyState()
				local index = Spring.GetCmdDescIndex(cmd.id)
				if (left) then
					Spring.SetActiveCommand(index,LEFTMOUSE,left,right,alt,ctrl,meta,shift)
				end
				if (right) then
					Spring.SetActiveCommand(index,RIGHTMOUSE,left,right,alt,ctrl,meta,shift)
				end
			end
			
			local text = cmd.name
			if (cmd.type == 5) then --state cmds (fire at will, etc)
				text = cmd.params[cmd.params[1]+2] or cmd.name
				setAlign(MIDDLE, CENTER)
				local numoptions = #cmd.params-1
				local width = iconsizex*0.7
				local spread = 1
				local optionsizex = width/numoptions-spread
				
				setSize(optionsizex,5)
				for i=1,numoptions do
					setPos(
						iconposx+iconsizex/2 - width/2 + optionsizex/2 + (i-1)*(width/numoptions+spread),
						iconposy+iconsizey/2+10
						)
					
					setColorAlpha(1)
					local colorintensity = 0.75
					if (i == (cmd.params[1]+1)) then
						if (numoptions < 4) then
							if (i == 1) then
								setColor(colorintensity,0,0)
							elseif (i == 2) then
								if (numoptions == 3) then
									setColor(colorintensity,colorintensity,0)
								else
									setColor(0,colorintensity,0)
								end
							elseif (i == 3) then
								setColor(0,colorintensity,0)
							end
						else
							setColor(colorintensity,colorintensity,colorintensity)
						end
						drawRectangle()
					end
					
					setColor(0,0,0,1)
					drawBorder(1)
				end
			end
			
			setAlign(MIDDLE, CENTER)
			local icontextsize = (iconsizex-textmargin)/getStringWidth(text,1)
			setSize(icontextsize,icontextsize)
			setPos(iconposx+iconsizex/2,iconposy+iconsizey/2)
			
			setColor(1,1,1,1)
			drawString(text)
			
			iconposx = iconposx+iconsizex+spreadx
		end
	end
	
	VARS.ordermenu_lastothercmdcount = othercmdscount
end

local function onunload()
	VARS.ordermenuunloaded = true
	if (VARS.buildmenuunloaded) then
		widgetHandler:ConfigLayoutHandler(true)
		Spring.ForceLayoutUpdate()
	end
	VARS[partinfo.name] = false
end

return partinfo,main,onunload
