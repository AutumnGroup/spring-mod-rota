local partinfo = {
	name 	= "Playerlist",
	layer 	= 0,
}

local function main()
	if (VARS[partinfo.name] ~= true) then
		sSendCommands({"info 0"})
		VARS[partinfo.name] = true
	end
	local playerroster = Spring.GetPlayerRoster()

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
	local spready = 2
	local offset = s.offset.v
	local border = s.border.v
	local sizey = (fontsize)*(#playerroster)+(spready)*(#playerroster-1)
	local sizex = getStringWidth("WWWWWWWWWWW100%99999",fontsize)+2*fontsize+5
	
	local posx = vsx/SCALERATIOX
	local posy = vsy/SCALERATIOY
	
	local color_background = s.color_background.v
	local color_border = s.color_border.v
	
	local expanded
	expanded,posx,posy = drawExpander(partinfo.name,"Playerlist",fontsize,posx,posy,sizex,sizey,offset,border,true,color_background,color_border)
	
	if (expanded) then
		local myallyteamid = Spring.GetMyAllyTeamID()
		local linecount = 0
		for index,player in ipairs(playerroster) do
			linecount = linecount + 1
			local lineposy = posy+(linecount-1)*(fontsize+spready)
			local name = player[1]
			local playerID = player[2]
			local teamID = player[3]
			local allyTeamID = player[4]
			local spectator = player[5]
			local cpuUsage = player[6]
			local pingTime = player[7]
			local r,g,b,a = Spring.GetTeamColor(teamID)
			
			setAlign(TOP, LEFT)
			setPos(posx,lineposy)
			setSize(sizex,fontsize)
			setColor(1,1,1,0.1)
			if (detectMouseClick(LEFTMOUSE,true) or detectMouseClick(RIGHTMOUSE,true)) then
				setColor(1,1,1,0.2)
			end
			if (detectMouseover()) then
				drawRectangle()
			end
			if (detectMouseClick(LEFTMOUSE)) then
				Spring.SendCommands({
					"chatall",
					"pastetext /w "..name.." >",
				})
			end
			if (detectMouseClick(RIGHTMOUSE)) then
				if (spectator == 0) then
					Spring.SendCommands({
						"specteam "..teamID,
					})
				end
			end
			
			local c = "\255\255\255\1"
			if ((allyTeamID == myallyteamid) and (spectator == 0)) then
				c = "\255\1\255\1"
			elseif ((allyTeamID ~= myallyteamid) and (spectator == 0)) then
				c = "\255\255\128\128"
			else
				--teamID = "(s)"
			end
			teamID = c..teamID
			
			cpuUsage = tonumber(string.format("%i",cpuUsage*100))
			if (cpuUsage < 0) then
				cpuUsage = 0
			elseif (cpuUsage > 999) then
				cpuUsage = 999
			end
			c = "\255\1\255\1"
			if (cpuUsage > 70) then
				c = "\255\255\1\1"
			elseif (cpuUsage > 40) then
				c = "\255\255\255\1"
			end
			cpuUsage = c..cpuUsage.."%"
			
			
			pingTime = tonumber(string.format("%i",pingTime*1000))
			if (pingTime > 99999) then
				pingTime = 99999
			elseif (pingTime < -9999) then
				pingTime = -9999
			end
			c = "\255\1\255\1"
			if (pingTime > 1200) then
				c = "\255\255\1\1"
			elseif (pingTime > 600) then
				c = "\255\255\255\1"
			end
			pingTime = c..pingTime
			
			local playercolor = "\255\255\255\255"
			local outline = 'o'
			if (spectator == 0) then
				playercolor =  convertColor(r,g,b)
				
				local brightness = getColorBrightness(r,g,b)
				if (brightness < 100) then
					outline = 'O'
				end
			end
			name = playercolor..name
			
			setAlign(TOP,LEFT)
			setSize(fontsize,fontsize)
			setPos(posx,lineposy)
			drawString(teamID,true,'o')
			
			setPos(posx+fontsize*2+5,lineposy)
			drawString(name,true,outline)
			
			setAlign(TOP,RIGHT)
			setPos(posx+sizex,lineposy)
			drawString(pingTime,true,'o')
			
			setPos(posx+sizex-5*fontsize,lineposy)
			drawString(cpuUsage,true,'o')
		end
	end
end

local function onunload()
	--[[
	sSendCommands({"info 1"})
	--]]
	VARS[partinfo.name] = false
end

return partinfo,main,onunload
