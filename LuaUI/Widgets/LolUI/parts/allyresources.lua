local partinfo = {
	name 	= "Ally Resources",
	layer 	= 0,
}

local mathMin = math.min

local function resourcebar(teamid,resource,color,posx,posy,sizex,sizey)
	local current,storage,_,_,_,share = Spring.GetTeamResources(teamid,resource)
	local r,g,b = color[1],color[2],color[3]
	setAlign(LEFT, TOP)
	setPos(posx,posy)
	setSize(sizex,sizey)
	setColorAlpha(1)
	
	local c = 1/3.14
	setColor(color[1]*c,color[2]*c,color[3]*c)
	
	local lCur, lMax = Spring.GetTeamResources(Spring.GetMyTeamID(), resource)
	local sDiv = 100
	if (resource == "metal") then sDiv = 250 end
	local sharerate = mathMin(mathMin(storage-current,mathMin((lMax/sDiv),(storage/sDiv))),lCur) --copypaste from TheFatController
	
	if (detectMouseClick(LEFTMOUSE,true)) then
		if (VARS.allyresourcesshareframe == nil) then
			VARS.allyresourcesshareframe = 0
		end
		if (VARS.allyresourcesshareframe ~= CURRENTGAMEFRAME) then
			if (sharerate > 0) then
				Spring.ShareResources(teamid,resource,sharerate)
				current = current + sharerate
			end
			VARS.allyresourcesshareframe = Spring.GetGameFrame()
		end
		setColor(0.8,0,0)
	end
	drawRectangle()
	
	setColor(color[1],color[2],color[3])
	drawBar(current,storage)
	setColor(0,0,0)
	drawBorder(1)
	
	
	setAlign(MIDDLE, TOP)
	setPos(posx+share*sizex,posy)
	setSize(2,sizey)
	setColor(1,0,0,0.75)
	drawRectangle()
	
	setPos(posx+share*sizex,posy-1)
	setSize(2+2,sizey+2)
	setColor(0,0,0)
	drawBorder(1)
end

local function main()
	local playerroster = Spring.GetPlayerRoster()
	local myallyid = Spring.GetLocalAllyTeamID()
	local count = 0
	local allies = {}
	for index,player in ipairs(playerroster) do
		local name = player[1]
		local teamID = player[3]
		local allyTeamID = player[4]
		local spectator = player[5]
		if ((Spring.GetMyTeamID() ~= teamID) and(spectator == 0) and (myallyid == allyTeamID)) then
			count = count + 1
			allies[count] = {[1] = teamID, [2] = name}
		end
	end

	local s = storePartOptions(partinfo.name,{
		fontsize = {
			v = 12,
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
			v = 80,
			minv = 0,
			maxv = 1280,
			caption = "Size X"
		},
		
		sizey = {
			v = 7,
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
	local spready = 6
	local offset = s.offset.v
	local border = s.border.v
	local barsizex = s.sizex.v
	local barsizey = s.sizey.v
	local sizex = barsizex+barsizey*2+5
	local sizey = count*(barsizey*2)+(count-1)*spready
	
	local posx = vsx/SCALERATIOX
	local posy = 250
	
	local color_background = s.color_background.v
	local color_border = s.color_border.v
	
	local drawnameofteamid = nil
	if (count > 0) then
		local expanded
		expanded,posx,posy = drawExpander(partinfo.name,"AllyBars",fontsize,posx,posy,sizex,sizey,offset,border,true,color_background,color_border)
		
		if (expanded) then
			
			for i=1,count do
				local teamID = allies[i][1]
				local r,g,b,a = Spring.GetTeamColor(teamID)
				
				resourcebar(teamID,"energy",{1,1,0},posx+barsizey*2+5,posy+(i-1)*(barsizey*2+spready),barsizex,barsizey)
				resourcebar(teamID,"metal",{1,1,1},posx+barsizey*2+5,posy+(i-1)*(barsizey*2+spready)+barsizey+1,barsizex,barsizey)
				
				setColorAlpha(1)
				setAlign(TOP, LEFT)
				setSize(barsizey*2,barsizey*2)
				setColor(r,g,b)
				setPos(posx,posy+(i-1)*(barsizey*2+spready))
				drawRectangle()
				setColor(0,0,0)
				drawBorder(1)
				
				setPos(posx,posy+(i-1)*(barsizey*2+spready))
				setSize(sizex,barsizey*2)
				if (detectMouseover()) then
					drawnameofteamid = teamID
				end
			end
		end
	end
	
	if (drawnameofteamid ~= nil) then
		local teamID = drawnameofteamid
		local playerlist = Spring.GetPlayerList(teamID)
		local playername = "unnamed"
		for i=1,#playerlist do
			local name,_,spectator = Spring.GetPlayerInfo(playerlist[i])
			if (not spectator) then
				playername = name
				break
			end
		end
	
		local x = 20
		local mposx = mouseposx
		local mposy = vsy - mouseposy
		setAlign(TOP, RIGHT)
		if (mposx < x+getStringWidth(playername,fontsize)) then
			setAlign(TOP, LEFT)
			x = -x
		end
		
		local r,g,b,a = Spring.GetTeamColor(teamID)
		local playercolor = convertColor(r,g,b)
		
		local outline = 'o'
		local brightness = getColorBrightness(r,g,b)
		if (brightness < 100) then
			outline = 'O'
		end
		
		local mcur,mstore = Spring.GetTeamResources(teamID,"metal")
		local ecur,estore = Spring.GetTeamResources(teamID,"energy")
		
		setPos(mposx-x,mposy)
		setSize(fontsize,fontsize)
		drawString(playercolor..playername,true,outline)
	end
end

local function onunload()
end

return partinfo,main,onunload