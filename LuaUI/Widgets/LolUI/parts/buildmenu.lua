local partinfo = {
	name 	= "Buildmenu",
	layer 	= 0,
}

local function main()
	if (VARS[partinfo.name] ~= true) then --on part load
		VARS.buildmenuunloaded = false
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
	local buildcmds = BUILDCMDS
	local buildcmdscount = #buildcmds
	
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
		
		iconsizex = {
			v = 50,
			minv = 10,
			maxv = 100,
			caption = "Icon size X"
		},
		
		iconsizey = {
			v = 35,
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
			v = 7,
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
	
	local iconsizex = s.iconsizex.v
	local iconsizey = s.iconsizey.v
	local iconsx = s.iconsx.v
	local iconsy = s.iconsy.v
	local spreadx = 1
	local spready = spreadx
	local offset = s.offset.v
	local fontsize = s.fontsize.v
	local border = s.border.v
	local iconborder = s.border_icon.v

	local sizex = (iconsx)*(iconsizex)+(iconsx-1)*(spreadx)
	local sizey = (iconsy+1)*(iconsizey)+(iconsy)*(spready)
	local posx = 0
	local posy = 390+sizey+offset
	
	local color_background = s.color_background.v
	local color_border = s.color_border.v
	local color_buttonbackground = s.color_icon_background.v
	local color_buttonborder = s.color_icon_border.v
	local color_clickhighlight = {1,1,1,0.2,1}
	local color_selectedhighlight = {1,0,0,0.3,1}
	local color_mouseoverhighlight = {1,1,1,0.2,1}
	
	local expanded
	if (buildcmdscount > 0) then
		expanded,posx,posy = drawExpander(partinfo.name,"Buildmenu",fontsize,posx,posy,sizex,sizey,offset,border,true,color_background,color_border)
	end
	
	if (expanded) then
		local iconposx = posx
		local iconposy = posy
		
		local iconsperpage = iconsx*iconsy
		if ((VARS.buildmenupage == nil) or (VARS.buildmenu_lastcmdcount ~= buildcmdscount)) then
			VARS.buildmenupage = 1
		end
		local page = VARS.buildmenupage
		
		local cmd
		for index=1+(page-1)*iconsperpage,buildcmdscount+1 do
			local iconstodraw = 0
			local drawnextarrow = false
			if ((index > iconsperpage*page)
			and (index<=buildcmdscount)) then
				drawnextarrow = true
				iconstodraw = iconstodraw + 1
			end
			local drawprevarrow = false
			if ((page > 1)
			and ((index == iconsperpage*page+1) or (index == buildcmdscount+1))) then
				drawprevarrow = true
				iconstodraw = iconstodraw + 1
			end
			if (not (drawprevarrow or drawnextarrow)) then
				iconstodraw = 1
				if (index == buildcmdscount+1) then
					break
				end
			end
			
			local _,_,_,currentcmd = Spring.GetActiveCommand()
			cmd = buildcmds[index]
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
						VARS.buildmenupage = page
					end
				elseif ((drawnextarrow and (i==1) and (not drawprevarrow))
				or (drawnextarrow and (i==2))) then
					iconposx = iconposx+(iconsx-1)*(iconsizex+spreadx)
					setPos(iconposx,iconposy)
					if (detectMouseClick(LEFTMOUSE)) then
						page = page + 1
						VARS.buildmenupage = page
					end
				end
				setPos(iconposx,iconposy)

				setColor(color_buttonbackground)
				drawRectangle()
				if (not (drawprevarrow or drawnextarrow)) then
					if (cmd.disabled) then
						setColor(0.5,0.5,0.5,1)
					else
						setColor(1,1,1,1)
					end
					--setTexture(":anl:unitpics/"..UnitDefNames[cmd.name].buildpicname)
					setTexture("#"..cmd.id*-1)   -- cmd.id*-1  == unitdefid
					drawRectangle()
					setTexture(nil)
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
						local unitdef = UnitDefs[cmd.id*-1]
						local mcost = unitdef.metalCost
						local ecost = unitdef.energyCost
						local btime = unitdef.buildTime
						local health = unitdef.health
						local maxweaponrange = unitdef.maxWeaponRange
						local line = {}
						line[1] = unitdef.humanName.." - "..unitdef.tooltip
						if (maxweaponrange > 0) then
							line[2] = "Health   "..health.."    Range   "..maxweaponrange
						else
							line[2] = "Health   "..health
						end
						line[3] = "Cost   "..mcost.."m "..ecost.."e"
						line[4] = "Buildtime   "..btime
						VARS.tooltip_line = line
					end
				end
				setColor(color_buttonborder)
				drawBorder(iconborder)
				
				if (drawprevarrow and (i==1)) then
					local symbol = "  <--  "
					setAlign(MIDDLE, CENTER)
					local icontextsize = (iconsizex)/getStringWidth(symbol,1)
					setSize(icontextsize,icontextsize)
					setPos(iconposx+iconsizex/2,iconposy+iconsizey/2)
					setColor(1,1,1,1)
					drawString(symbol)
				elseif ((drawnextarrow and (i==1) and (not drawprevarrow))
				or (drawnextarrow and (i==2))) then
					local symbol = "  -->  "
					setAlign(MIDDLE, CENTER)
					local icontextsize = (iconsizex)/getStringWidth(symbol,1)
					setSize(icontextsize,icontextsize)
					setPos(iconposx+iconsizex/2,iconposy+iconsizey/2)
					setColor(1,1,1,1)
					drawString(symbol)
				end
			end
			
			if (drawprevarrow or drawnextarrow) then
				local symbol = "   "..page.."   "
				setAlign(MIDDLE, CENTER)
				local icontextsize = (iconsizex)/getStringWidth(symbol,1)
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
			
			setAlign(LEFT, BOTTOM)
			setPos(iconposx+2,iconposy+iconsizey-2)
			setSize(fontsize,fontsize)
			setColor(1,1,1,1)
			drawString(cmd.params[1])
			
			iconposx = iconposx+iconsizex+spreadx
		end
	end
	VARS.buildmenu_lastcmdcount = buildcmdscount
end

local function onunload()
	VARS.buildmenuunloaded = true
	if (VARS.ordermenuunloaded) then
		widgetHandler:ConfigLayoutHandler(true)
		Spring.ForceLayoutUpdate()
	end
	VARS[partinfo.name] = false
end

return partinfo,main,onunload