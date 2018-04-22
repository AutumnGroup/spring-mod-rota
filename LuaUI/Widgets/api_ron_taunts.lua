--------------------------------------------------------------------------------
--  author:  PepeAmpere
--	sounds:  Rise of Nations taunts + RoN Babel pack
--	SORRY TO ALL CODE SENSTIVE PEOPLE, this was first widget of PepeAmpere and the code is horrible, he knows /remake is planned, but theres no time/
--------------------------------------------------------------------------------
function widget:GetInfo()
  return {
    name      = "RoN Taunts",
    desc      = "v 1.005 Enable communication via Rise of Nations taunts",
    author    = "PepeAmpere",
    date      = "Dec 18, 2011",
    license   = "No licence",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

---- CHANGELOG
---- 1.005
-- killed antispam
---- 1.004
-- added support for new nota pack folder structure
---- 1.003
-- small changes in .ini file
---- 1.002
-- taunts moved to LuaUI folder
---- 1.001
-- some small repairs, one misscoding fixed
-- antispam default number 2=>3
---- 1.000 
---------------------------------------------------------------------------------

local SpPlaySoundFile	  = Spring.PlaySoundFile
local SpStopSoundStream	  = Spring.StopSoundStream
local SpGetMyTeamID		  = Spring.GetMyTeamID
local SpSendLuaRulesMsg   = Spring.SendLuaRulesMsg
local SpSendCommands      = Spring.SendCommands
-- local glGetTextWidth      = gl.GetTextWidth
local SpEcho              = Spring.Echo
local superplayer         = Spring.GetPlayerInfo(Spring.GetLocalPlayerID())

local lastLines           = {"", "", "", "", ""}
local lastNames           = {"", "", "", "", ""}
local lastKeys            = {"-1", "-1", "-1", "-1"}
local lastTaunt           = ""
local TAUNT_PREFIX_PATTERNS		= {"%("}
local TAUNT_POSTFIX_PATTERNS	= {"%)"}

local basePath             = "LuaUI/Taunts/"
local inibasePath          = "taunts.ini"
local tauntsFiles          = {}
local tauntsMessages       = {}

local iniPath              = basePath .. inibasePath

local sendkey              = 266     -- default key numDEL for sending taunts
local keyTable             = {k256=0, k257=1, k258=2, k259=3, k260=4, k261=5, k262=6, k263=7, k264=8, k265=9, k48=0, k49=1, k50=2, k51=3, k52=4, k53=5, k54=6, k55=7, k56=8, k57=9}
-- this hash table is is using k<number> becouse using <number> as hashkey is forbidden

-- tauntsFiles[1]       = "notalobby/_taunts/victoryismine-3.ogg"
-- local filename       = "victoryismine-3.ogg"

---------------------------------------------------------------------------------
local function playTaunt(number)
    -- debug -- SpEcho ("I want to write file with path: ", number, " ini path: ", iniPath) 
	local Nnumber = tonumber(number)
    if ((Nnumber ~= nil) and (Nnumber >= 1) and (Nnumber <= 999)) then
	    Nnumber = math.floor(Nnumber)
	    SpPlaySoundFile(tauntsFiles[Nnumber])
		-- debug -- SpEcho ("I want to write file with path: ", tauntsFiles[number], " ini path: ", iniPath)
	end
	-- if (number == "(73) Victory is mine!") then
	--    SpPlaySoundFile(taunt0073,0.5)
	-- end
end

local function sayTaunt(name,number)
    -- debug -- SpEcho ("I want to write file with path: ", number, " ini path: ", iniPath) 
	local Nnumber = tonumber(number)
    if ((Nnumber ~= nil) and (Nnumber >= 1) and (Nnumber <= 999)) then
	    Nnumber = math.floor(Nnumber)
	    SpSendCommands("say \(" .. Nnumber .. "\) " .. tauntsMessages[math.floor(Nnumber)])
		-- (\<" .. name .. "\> \(" .. Nnumber .. "\) " .. tauntsMessages[math.floor(Nnumber)])
		-- debug -- SpEcho ("I want to write file with path: ", tauntsFiles[number], " ini path: ", iniPath)
	end
	-- if (number == "(73) Victory is mine!") then
	--    SpPlaySoundFile(taunt0073,0.5)
	-- end
end


local function getPlayerName(playerMessage)
    if (string.find(playerMessage, " ") ~= nil) then
		return (string.sub(playerMessage, 1, string.find(playerMessage, "%s")))
    else
	    -- no match found
	    return ""
	end
end

local function getTauntNumber(playerMessage)
	local i1 = string.find(playerMessage, TAUNT_PREFIX_PATTERNS[1])
	local i2 = string.find(playerMessage, TAUNT_POSTFIX_PATTERNS[1])

	if (i1 ~= nil and i2 ~= nil) then
		-- taunt code
		return (string.sub(playerMessage, i1 + 1, i2 - 1))
	end

	-- no match found
	return ""
end


function gameStarted(String,End)
   return End=='' or string.sub(String,-string.len(End))==End
end

function widget:AddConsoleLine(line)
	if (string.len(line) > 0) then
	
		--ignore duplicate messages
		if (line == lastLines[1]) then
			return -- drop duplicate messages
		end
		
		-- getting players name
		local playerName = getPlayerName(line)
		local playerMessages = 0
		
	    -- antispam
		for i = 5, 2, -1 do
			lastLines[i] = lastLines[i-1]  -- not needed now, but later it will be maybe
			lastNames[i] = lastNames[i-1]
			if (lastNames[i] == playerName) then
			    playerMessages = playerMessages + 1
			end
        end
		lastLines[1] = line
		lastNames[1] = playerName
		
		if (string.sub(line,5,8) == "Pepe") then  -- pepe is NEVER the spammer :)
		    playerMessages = 0
		end
		-- end of first part of antispam
		
		local playerTaunt = getTauntNumber(line)
		
		-- stops all doubletaunts
		if (playerTaunt == lastTaunt) then
		    return
		else
		    lastTaunt = playerTaunt
		end
	
		if (playerTaunt == "") then
		    lastNames[1] = "" -- if player does not try to use taunts, his name is cleared from history of taunt users.
			--- debug --- SpEcho ("nothing less then it was not taunt .......?")
			--- for i = 5, 1, -1 do
			---	SpEcho ("nothing less then list of noobs .................... " .. lastNames[i])
			--- end
		elseif (tonumber(playerTaunt) == 0) then  -- for laptop noobs ;) setting SPACE as sending key
		    if (string.sub(playerName,2,string.len(playerName)-2) == superplayer) then  -- condition to change keys only for player that wants it
				if (sendkey == 266) then
			        sendkey = 32   -- SPACE
				    -- debug SpEcho ("names - " .. string.sub(playerName,2,string.len(playerName)-2) .. superplayer .. " - names")
                else
			        sendkey = 266  -- numDEL
				end
            end			
		else
		    -- debug -- SpEcho (playerTaunt.." - taunt")
			
			-- begin of second part of antispam
		    -- if (playerMessages >= 3) then
			    -- return -- dont serve to guy that have 3 or more taunt-messages in last 5 messages history
		    -- end
		    -- end of second part of antispam
			
			playTaunt(playerTaunt)
			-- debug sayTaunt(playerName,playerTaunt)
		end
	end -- starter condition end
end

function widget:KeyPress(key, mods, isRepeat)
    if ((key >=256 and key <= 265) or (key >=48 and key <= 57)) then
	    local lastK = keyTable["k" .. key]
		-- debug SpEcho (key) 
		-- SpEcho ("k" .. key)
		for i = 4, 2, -1 do
			lastKeys[i] = lastKeys[i-1]          -- moving last keys in list of 4 last keys
        end 
		lastKeys[1] = lastK
	elseif (key == sendkey) then
	    for i = 4, 2, -1 do
			lastKeys[i] = lastKeys[i-1]
        end
        lastKeys[1] = -1
	else
	    lastKeys[1] = -2
	end
	-- SpEcho (key)
end

function widget:KeyRelease(key)
    if (key == sendkey) then
	    if (tonumber(lastKeys[1]) ~= -1) then
		    return -- when someone is holding sendingkey for long time
		else
		    if (tonumber(lastKeys[2]) <= -1) then
			    return -- when there are two sendingkeys in history or when some stupid key before
			else
			    local thatNumber = tonumber(lastKeys[2])
				if (tonumber(lastKeys[3]) <= -1) then
				    sayTaunt(superplayer,thatNumber)
					return  -- exucute taunt 1-9
				else
				    thatNumber = thatNumber + 10*tonumber(lastKeys[3])
					if (tonumber(lastKeys[4]) <= -1) then
				        sayTaunt(superplayer,thatNumber)
					    return  -- exucute taunt 10-99
				    else
					    thatNumber = thatNumber + 100*tonumber(lastKeys[4])
						sayTaunt(superplayer,thatNumber)
						return  -- exucute taunt 100-999
					end
				end
			end
		end
	end
end

local function FileExist(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end


local function preparePaths ()
    local widgetNumber = 0
	if (FileExist(iniPath)) then
		for iniline in io.lines(iniPath) do 
			if (string.sub(iniline,1,1) == "[") then
				-- widgetNumber = string.sub(iniline,2,2)
			elseif (string.sub(iniline,1,3) == "key") then
				widgetNumber = string.sub(iniline,5)
				-- debug -- SpEcho ("LINE ", widgetNumber)
			elseif (string.sub(iniline,1,7) == "message") then
				table.insert(tauntsMessages, string.sub(iniline,10,-2))
			elseif (string.sub(iniline,1,4) == "file") then
				table.insert(tauntsFiles, basePath .. string.sub(iniline,6))
				-- debug SpEcho ("test", tauntsFiles[tonumber(widgetNumber)])
			else
			-- debug --- table.insert(tauntsFiles, "../notalobby/_taunts/yes-3.ogg")
			-- debug --- SpEcho ("test path ", tauntsFiles[1])
			end		
		end
		--Spring.Echo("Ron Taunts: using primary path")
	else
	    Spring.Echo("Ron Taunts: .ini file not found")
	    widgetHandler:RemoveWidget()
	end
end

function widget:Initialize()
	
	preparePaths()

    -- for i = 1, 100 do
    -- table.insert(tauntsFiles, basePath .. filename);
    -- end
end

