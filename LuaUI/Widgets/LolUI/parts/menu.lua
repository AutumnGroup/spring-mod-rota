local partinfo = {
	name 	= "Part Manager",
	layer 	= 10,
	framedelay = 4,
}

local function parttoggle(i) 
	partlist[i].enabled = not partlist[i].enabled
	if (not partlist[i].enabled) then
		if (type(partlist[i].onunload) == "function") then
			partlist[i].onunload()
		end
		GUIDATA.disabledparts[partlist[i].name] = true
	else
		GUIDATA.disabledparts[partlist[i].name] = nil
	end
end

return partinfo,function ()
	local s = storePartOptions(partinfo.name,{
		fontsize = {
			v = 12,
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
	local spready = 2
	local offset = s.offset.v
	local border = s.border.v
	
	local posx = vsx/SCALERATIOX
	local posy = 80
	
	local color_background = s.color_background.v
	local color_border = s.color_border.v
	
	
	local menucolors = {
		mouseover = {1,1,1,0.1},
		pressed = {1,1,1,0.2},
		background = color_background,
		border = color_border,
	}
	
	local otherthings = {
		{
			caption = "\255\255\255\1Reset UI",
			action = function () 
				GUIDATA.movablelist = {}
				GUIDATA.expanders = {}
				GUIDATA.settings = {}
				VARS["settingschecker"] = {}
			end,
		},
		{
			caption = "\255\1\255\1Save Settings",
			action = function ()
				GUIDATA.profiles[1] = {GUIDATA.movablelist,GUIDATA.expanders,GUIDATA.settings}
			end,
		},
		{
			caption = "\255\1\255\1Load Settings",
			action = function ()
				GUIDATA.movablelist = GUIDATA.profiles[1][1]
				GUIDATA.expanders = GUIDATA.profiles[1][2]
				GUIDATA.settings = GUIDATA.profiles[1][3]
				VARS["settingschecker"] = {}
			end,
		},
	}
	
	local menu = {
		core = true,
		{
			caption = "Settings",
			action = {},
		},
		{
			caption = "Other",
			action = otherthings,
		},
	}
	
	local sizey = fontsize*(#menu)+(#menu-1)*spready
	local sizex = getStringWidth("Settings",fontsize)+2*offset
	
	local expanded
	expanded,posx,posy = drawExpander(partinfo.name,"Menu",fontsize,posx,posy,sizex-offset*2,sizey,offset,border,false,color_background,color_border,true,true)
	
	if (expanded) then
		local j=#menu[1].action
		for i=1,partcount do
			j=j+1
			local part = partlist[i]
			local name = part.name
			local partoptions = generatePartOptions(name,GUIDATA.rawoptions[name] or {})
			local color = "\255\255\255\1"
			
			if (name ~= partinfo.name) then
				color = "\255\1\255\1"
				local state = "ON"
				if (GUIDATA.disabledparts[part.name]) then
					color = "\255\255\1\1"
					state = "OFF"
				end
				
				local onoff = {
					id = "onoff",
					caption = "Status: "..color..state,
					action = function () parttoggle(i) end,
				}
				
				partoptions[1] = partoptions[1] or {}
				if (partoptions[1].id == "onoff") then
					partoptions[1] = onoff
				else
					table.insert(partoptions,1,onoff)
				end
			end
			
			local option = {
					caption = color..name,
					action = partoptions
				}
			
			if (name ~= partinfo.name) then
				menu[1].action[j] = option
			else
				table.insert(menu[1].action,1,option)
			end
		end
	
		drawMenu(partinfo.name.."_menu1",posx,posy,menu,menucolors,fontsize,spready,offset,border,partinfo.name)
	end
end
