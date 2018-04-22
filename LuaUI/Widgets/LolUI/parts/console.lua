local partinfo = {
	name 	= "Console",
	layer 	= 0,
}

local function handleoverflow(lines,sizex)
	local j=0
	local tempbuffer = {}
	for i=1,#lines do
		local line = lines[i]
		local msg = line.text
		local size = line.size
		local count = 0
		while (getStringWidth(msg,size) > sizex) do
			local msglen = string.len(msg)
			for x=1,msglen do
				if (getStringWidth(string.sub(msg,1,x+1),size) > sizex) then
					j=j+1
					tempbuffer[j] = copytable(line)
					tempbuffer[j].text = string.sub(msg,1,x)
					tempbuffer[j].part = count
					msg = string.sub(msg,x+1)
					break
				end
			end
			count = count+1
		end
		j=j+1
		tempbuffer[j] = copytable(line)
		tempbuffer[j].text = msg
		tempbuffer[j].part = count
	end
	return tempbuffer
end

local function fliporderoflines(lines)
	local tempbuffer = {}
	local temp = {}
	local c = 0
	for i=1,#lines do
		local line = lines[i]
		local id = line.id
		local nextid
		if (i~=#lines) then
			nextid = lines[i+1].id
		end
		if (id==nextid) then
			table.insert(temp,line)
		else
			c=c+1
			tempbuffer[#lines+1-c] = line
			for j=1,#temp do
				c=c+1
				tempbuffer[#lines+1-c] = temp[#temp+1-j]
			end
			temp = {}
		end
	end
	return tempbuffer
end

local function getlinesbytype(msgtypes,lines)
	local tempbuffer = {}
	local j=0
	for i=1,#lines do
		if (msgtypes[lines[i].msgtype]) then
			j=j+1
			tempbuffer[j] = lines[i]
		end
	end
	return tempbuffer
end

local function colorifylines(lines)
	local tempbuffer = {}
	for i=1,#lines do
		local line = lines[i]
		local msg = line.text
		local size = line.size
		local colors = line.colors
		local prefixlen = line.prefixlen
		local part = line.part
		local count = 0
		for i=1,#colors do
			local pos = colors[i][1]+count*4+prefixlen
			if (part > 0) then
				pos = pos - string.len(msg)
			end
			if (pos < 1) then
				msg = colors[#colors][2]..msg
				break
			end
			local color = colors[i][2]
			local lside = string.sub(msg,1,pos-1)
			local rside = string.sub(msg,pos)
			msg = lside..color..rside
			count = count + 1
		end
		line.text = msg
		tempbuffer[i] = line
	end
	return tempbuffer
end

local function getsizeyoflines(lines,spready,maxframeage)
	local sizey = 0
	for i=1,#lines do
		local frame = lines[i].frame
		if ((frame+maxframeage) > sGetGameFrame()) then
			local size = lines[i].size
			if (i~=#lines) then
				sizey = sizey + spready
			end
			sizey = sizey + size
		end
	end
	return sizey
end

local function filterlines(lines,playernames)
	local lastid
	local tempbuffer = {}
	for i=1,#lines do
		local line = lines[i]
		local msg = line.text
		
		if (playernames[string.sub(msg,2,(string.find(msg,"> ") or 1)-1)] ~= nil) then
			line.msgtype = "playermessage"
			line.playername = string.sub(msg,2,string.find(msg,"> ")-1)
			line.message = string.sub(msg,string.len(line.playername)+4)
			
			
		elseif (playernames[string.sub(msg,2,(string.find(msg,"] ") or 1)-1)] ~= nil) then
			line.msgtype = "spectatormessage"
			line.playername = string.sub(msg,2,string.find(msg,"] ")-1)
			line.message = string.sub(msg,string.len(line.playername)+4)
		elseif (playernames[string.sub(msg,2,(string.find(msg,"(replay)") or 3)-3)] ~= nil) then
			line.msgtype = "spectatormessage"
			line.playername = string.sub(msg,2,string.find(msg,"(replay)")-3)
			line.message = string.sub(msg,string.len(line.playername)+13)
			
		elseif (playernames[string.sub(msg,1,(string.find(msg," added point: ") or 1)-1)] ~= nil) then
			line.msgtype = "playerpoint"
			line.playername = string.sub(msg,1,string.find(msg," added point: ")-1)
			line.message = string.sub(msg,string.len(line.playername.." added point: ")+1)
			
		elseif (string.sub(msg,1,1) == ">") then
			line.msgtype = "gamemessage"
			line.message = string.sub(msg,3)
			
		else	
			line.msgtype = "other"
		end
		tempbuffer[i] = line
	end
	return tempbuffer
end

local function displaylines(totalsize,lines,posx,posy,spready,maxframeage)
	setAlign(TOP,LEFT)
	for i=1,#lines do
		local line = lines[#lines+1-i]
		local msg = line.text
		local size = line.size
		local frame = line.frame
		if ((frame+maxframeage) > sGetGameFrame()) then
			totalsize = totalsize-size
			if (totalsize+1 < 0) then
				break
			end
			setSize(size,size)
			if ((line.part == 0) and (line.outlinehack ~= nil)) then
				local playername = line.outlinehack[1]
				local playercolor = line.outlinehack[2]
				local x = string.sub(msg,string.len(playername)+1+4+line.prefixlen)
				setPos(posx,posy+totalsize)
				drawString(line.prefix,true,'o')
				setPos(posx+getStringWidth(line.prefix,size),posy+totalsize)
				drawString(playercolor..playername,true,'O')
				setPos(posx+getStringWidth(line.prefix..playername,size),posy+totalsize)
				drawString(x,true,'o')
			else
				setPos(posx,posy+totalsize)
				drawString(msg,true,'o')
			end
			totalsize = totalsize - spready
		end
	end
end

local function finaldraw(t,expandedbydefault,backgroundcolor,bordercolor)
	t.sizey = getsizeyoflines(t.buffer,t.spready,t.maxframeage)
	t.minsizey = (t.fontsize+t.spready)*t.minlines
	t.maxsizey = (t.fontsize+t.spready)*t.maxlines
	if (t.sizey < t.minsizey) then
		t.sizey = t.minsizey
	elseif (t.sizey > t.maxsizey) then
		t.sizey = t.maxsizey
	end
	if (t.sizey > 0) then
		t.expanded,t.posx,t.posy = drawExpander(partinfo.name..t.caption,t.caption,t.captionfontsize,t.posx,t.posy,t.sizex,t.sizey,t.offset,t.border,expandedbydefault,backgroundcolor,bordercolor,false)
		if (t.expanded) then
			displaylines(t.sizey,t.buffer,t.posx,t.posy,t.spready,t.maxframeage)
		end
	end
end

local function main()
	if (VARS[partinfo.name] ~= true) then
		sSendCommands({"console 0"})
		VARS[partinfo.name] = true
	end
	
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
		
		maxframeage = {
			v = 15,
			minv = 1,
			maxv = 120,
			caption = "Message timer"
		},
		
		sizex = {
			v = 600,
			minv = 0,
			maxv = 1280,
			caption = "Size X"
		},
		
		color_background = {
			id = "special",
			v = {0,0,0,0.1},
			caption = "Color: Background",
		},
		
		color_border = {
			id = "special",
			v = {0,0,0,1},
			caption = "Color: Border",
		},
	})
	
	
	local color_background = s.color_background.v
	local color_border = s.color_border.v
	
	local color_specname = "\255\255\255\1"
	local color_misctext = "\255\255\255\255"
	local color_allytext = "\255\1\255\1"
	local color_otherallytext = "\255\255\128\128"
	local color_spectext = "\255\255\255\1"
	local color_othertext = "\255\200\200\200"
	local color_gametext = "\255\100\255\255"
	
	local chat = {
		types = {["playermessage"]=1,["spectatormessage"]=1,["playerpoint"]=1,["other"]=1,["gamemessage"]=1},
		fontsize = s.fontsize.v,
		posx = 240,
		--posy = 6+console.posy+(console.maxlines*console.fontsize)+console.spready*(console.maxlines-1)+2*console.offset,
		posy = 40,
		minlines = 1,
		maxlines = 10,
		sizex = s.sizex.v,
		caption = "Console",
		captionfontsize = 12,
		offset = s.offset.v,
		border = s.border.v,
		spready = 2,
		maxframeage = s.maxframeage.v*30,
	}
	
	
	--[[local console = {
		types = {},
		fontsize = 12,
		posx = 240,
		posy = 40,
		minlines = 0,
		maxlines = 6,
		sizex = 600,
		caption = "Console",
		captionfontsize = 10,
		offset = 5,
		border = 2,
		spready = 2,
		maxframeage = 15*30,
	}]]
	
	local maxframeage = s.maxframeage.v*30
	
	local linebuffer = {}
	if (VARS[partinfo.name.."_lastconsolecount"] ~= #CONSOLEBUFFER) then
		local linecount = 0
		local lastmsg = ""
		local lastmsgcount = 1
		for i=1,#CONSOLEBUFFER do
			local line = CONSOLEBUFFER[#CONSOLEBUFFER-i+1]   --line[1] = text, line[2] = frame
			if ((line[2]+maxframeage) > sGetGameFrame()) then
				local msg = line[1]
				if (lastmsg == msg) then
					lastmsgcount = lastmsgcount + 1
				else
					lastmsgcount = 1
					linecount = linecount + 1
				end
				linebuffer[linecount] = {["text"] = msg,["n"] = lastmsgcount, ["id"] = #CONSOLEBUFFER-i+1, ["frame"] = line[2]}
				lastmsg = msg
			else
				break
			end
		end
		
		local myallyteamid = Spring.GetMyAllyTeamID()
		local playerroster = Spring.GetPlayerRoster()
		local playercount = #playerroster
		local playernames = {}
		for i=1,playercount do
			playernames[playerroster[i][1]] = {playerroster[i][4],playerroster[i][5],playerroster[i][3]}
		end
		
		linebuffer = filterlines(linebuffer,playernames)
		
		----parse lines
		local lastid
		for i=1,#linebuffer do
			local line = linebuffer[i]
			local msgtype = line.msgtype
			local text = line.text
			local id = line.id
			local n = line.n
			
			local size = chat.fontsize
			local colors = {{1,color_othertext}}
			
			if (msgtype == "playermessage") then
				local playername = line.playername
				local message = line.message
				
				local r,g,b,a = Spring.GetTeamColor(playernames[playername][3])

				local playercolor =  convertColor(r,g,b)
				local brightness = getColorBrightness(r,g,b)
				if (brightness < 100) then
					line.outlinehack = {playername,playercolor}
				end
				
				color = color_misctext
				if (string.find(message,"Allies: ") == 1) then
					message = string.sub(message,9)
					if (playernames[playername][1] == myallyteamid) then
						color = color_allytext
					else
						color = color_otherallytext
					end
				elseif (string.find(message,"Spectators: ") == 1) then
					message = string.sub(message,13)
					color = color_spectext
				end
				
				text = playername..": "..message
				size = chat.fontsize
				colors = {
					{1,playercolor},
					{string.len(playername)+1,color_misctext},
					{string.len(playername)+2,color},
				}
			elseif (msgtype == "spectatormessage") then
				local playername = line.playername
				local message = line.message
				
				playercolor = color_specname
				color = color_misctext
				if (string.find(message,"Allies: ") == 1) then
					message = string.sub(message,9)
					color = color_spectext
				elseif (string.find(message,"Spectators: ") == 1) then
					message = string.sub(message,13)
					color = color_spectext
				end
				playername = "(s) "..playername
				text = playername..": "..message
				
				size = chat.fontsize
				colors = {
					{1,playercolor},
					{string.len(playername)+1,color_misctext},
					{string.len(playername)+2,color},
				}
			elseif (msgtype == "playerpoint") then
				local playername = line.playername
				local message = line.message
				
				local spectator = 1
				if (playernames[playername] ~= nil) then
					spectator = playernames[playername][2]
				end
				local playercolor = color_specname
				if (spectator == 0) then
					local r,g,b,a = Spring.GetTeamColor(playernames[playername][3])
					playercolor =  convertColor(r,g,b)
					
					local brightness = getColorBrightness(r,g,b)
					if (brightness < 100) then
						line.outlinehack = {playername,playercolor}
					end
				end
				if (spectator == 1) then
					playername = "(s) "..playername
				end
				
				if (spectator == 1) then
					color = color_spectext
				elseif (playernames[playername][1] == myallyteamid) then
					color = color_allytext
				else
					color = color_otherallytext
				end
				
				text = playername.." * "..message
				
				size = chat.fontsize
				colors = {
					{1,playercolor},
					{string.len(playername)+1,color_misctext},
					{string.len(playername)+3,color},
				}
			elseif (msgtype == "gamemessage") then
				local message = line.message
				text = "> "..message
				size = chat.fontsize
				colors = {
					{1,color_gametext},
				}
			end
			
			
			local prefix = ""
			if ((n > 1) and (id ~= lastid)) then
				prefix = n.."x "
			end
			local prefixlen = string.len(prefix)
			
			line.text = prefix..text --prefix with number of repetitions
			line.prefix = prefix
			line.prefixlen = prefixlen
			line.size = size
			line.colors = colors
			
			linebuffer[i] = line
			lastid = id
		end
		--------
		
		--[[
		console.buffer = getlinesbytype(console.types,linebuffer)
		console.buffer = handleoverflow(console.buffer,console.sizex)
		console.buffer = colorifylines(console.buffer)
		console.buffer = fliporderoflines(console.buffer)
		VARS[partinfo.name.."_console_buffer"] = console.buffer
		--]]
		
		chat.buffer = getlinesbytype(chat.types,linebuffer)
		chat.buffer = handleoverflow(chat.buffer,chat.sizex)
		chat.buffer = colorifylines(chat.buffer)
		chat.buffer = fliporderoflines(chat.buffer)
		VARS[partinfo.name.."_chat_buffer"] = chat.buffer
	end
	VARS[partinfo.name.."_lastconsolecount"] = #CONSOLEBUFFER
	
	--console.buffer = VARS[partinfo.name.."_console_buffer"]
	--finaldraw(console)
	
	chat.buffer = VARS[partinfo.name.."_chat_buffer"]
	finaldraw(chat,true,color_background,color_border)
end

local function onunload()
	--
	sSendCommands({"console 1"})
	--]]
	VARS[partinfo.name] = false
end

return partinfo,main,onunload
