----- mission spawn list ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

-- !! not finished --
-- ! not own spawner
-- ! need add resources start setting

newSpawnDef = {

}

newSpawnThis = {

}

local counter 	= 0
local limit		= 30
local line		= 1
local squareDist= 250

for id,unitDef in pairs(UnitDefs) do
	counter 				= counter + 1
	local row				= counter % limit
	if (row == 0) then line = line + 1 end
	
	local uName 			= unitDef.name
	local tName				= "t_" .. uName
	newSpawnDef[tName] 		= {unit = uName, class = "single"}
	-- newSpawnThis[counter] 	= {name = tName, posX = row*squareDist, posZ = line*squareDist, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
end

newSpawnThis[#newSpawnThis+1] 	= {name = "t_armfark", posX = 100, posZ = 100, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armflea", posX = 100, posZ = 150, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armpw", posX = 100, posZ = 200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armrock", posX = 100, posZ = 250, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armham", posX = 100, posZ = 300, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armjeth", posX = 100, posZ = 350, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armsnipe", posX = 100, posZ = 400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armmark", posX = 100, posZ = 450, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armspy", posX = 100, posZ = 500, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armvader", posX = 100, posZ = 550, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armwar", posX = 100, posZ = 600, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armzeus", posX = 100, posZ = 650, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armfast", posX = 100, posZ = 700, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_cornecro", posX = 200, posZ = 100, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corak", posX = 200, posZ = 200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corstorm", posX = 200, posZ = 250, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corthud", posX = 200, posZ = 300, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corcrash", posX = 200, posZ = 350, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cormort", posX = 200, posZ = 400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corvoyr", posX = 200, posZ = 450, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corroach", posX = 200, posZ = 550, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cormak", posX = 200, posZ = 600, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corpyro", posX = 200, posZ = 650, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_sprint", posX = 200, posZ = 700, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

-- newSpawnThis[#newSpawnThis+1] 	= {name = "t_cortraq", posX = 300, posZ = 650, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
-- newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsabo", posX = 300, posZ = 700, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_armpod", posX = 100, posZ = 900, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armcom", posX = 250, posZ = 900, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armcom2", posX = 300, posZ = 900, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armbcom", posX = 450, posZ = 900, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corkrog", posX = 600, posZ = 900, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corcom", posX = 750, posZ = 900, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corcom2", posX = 900, posZ = 900, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_armamph", posX = 100, posZ = 1100, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armaser", posX = 100, posZ = 1200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armdrone", posX = 100, posZ = 1300, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armfido", posX = 100, posZ = 1400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armmav", posX = 100, posZ = 1500, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armodd", posX = 100, posZ = 1600, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armraz", posX = 100, posZ = 1700, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armspid", posX = 100, posZ = 1800, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_raptoriv", posX = 200, posZ = 1900, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_coramph", posX = 200, posZ = 1100, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corcan", posX = 200, posZ = 1200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corcrabe", posX = 200, posZ = 1300, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corgala", posX = 200, posZ = 1400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corhrk", posX = 200, posZ = 1500, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corspec", posX = 200, posZ = 1600, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsumo", posX = 200, posZ = 1700, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_armcv", posX = 500, posZ = 100, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armfav", posX = 500, posZ = 150, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armflash", posX = 500, posZ = 200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armstump", posX = 500, posZ = 250, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armlatnk", posX = 500, posZ = 300, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armbull", posX = 500, posZ = 350, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armsam", posX = 500, posZ = 450, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armyork", posX = 500, posZ = 500, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armseer", posX = 500, posZ = 550, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armmart", posX = 500, posZ = 600, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_avtr", posX = 500, posZ = 650, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_corcv", posX = 700, posZ = 100, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corfav", posX = 700, posZ = 150, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corgator", posX = 700, posZ = 200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corraid", posX = 700, posZ = 250, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corlevlr", posX = 700, posZ = 300, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_correap", posX = 700, posZ = 350, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corfatnk", posX = 700, posZ = 400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cormist", posX = 700, posZ = 450, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsent", posX = 700, posZ = 500, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corvrad", posX = 700, posZ = 550, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cormart", posX = 700, posZ = 600, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cordemo", posX = 700, posZ = 650, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_ahermes", posX = 500, posZ = 1100, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armarspd", posX = 500, posZ = 1200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armcroc", posX = 500, posZ = 1300, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armjam", posX = 500, posZ = 1400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armmanni", posX = 500, posZ = 1500, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armmerl", posX = 500, posZ = 1600, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armscab", posX = 500, posZ = 1700, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_grayhound", posX = 500, posZ = 1800, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_corhorg", posX = 700, posZ = 1100, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_coreter", posX = 700, posZ = 1200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corgol", posX = 700, posZ = 1300, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cormabm", posX = 700, posZ = 1400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corseal", posX = 700, posZ = 1500, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corvroc", posX = 700, posZ = 1600, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_armatlas", posX = 1200, posZ = 100, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armfig", posX = 1200, posZ = 200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armhell", posX = 1200, posZ = 300, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armlance", posX = 1200, posZ = 400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armpeep", posX = 1200, posZ = 500, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armpnix", posX = 1200, posZ = 600, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armthund", posX = 1200, posZ = 700, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armtoad", posX = 1200, posZ = 800, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_corbrik", posX = 1400, posZ = 100, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corevashp", posX = 1400, posZ = 200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corfink", posX = 1400, posZ = 300, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corhurc", posX = 1400, posZ = 400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corshad", posX = 1400, posZ = 500, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cortitan", posX = 1400, posZ = 600, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corveng", posX = 1400, posZ = 700, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_corbtrans", posX = 1200, posZ = 900, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corvalk", posX = 1300, posZ = 900, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corvalkii", posX = 1400, posZ = 900, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corff", posX = 1600, posZ = 900, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_armbrawl", posX = 1100, posZ = 1100, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armca", posX = 1200, posZ = 1100, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armangel", posX = 1200, posZ = 1200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armhawk", posX = 1200, posZ = 1300, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armwing", posX = 1200, posZ = 1400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_blade", posX = 1200, posZ = 1500, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cmercdrag", posX = 1200, posZ = 1600, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armawac", posX = 1200, posZ = 1700, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armsehak", posX = 1200, posZ = 1800, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_corca", posX = 1400, posZ = 1100, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corape", posX = 1400, posZ = 1200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corvamp", posX = 1400, posZ = 1300, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corerb", posX = 1400, posZ = 1400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corgryp", posX = 1400, posZ = 1500, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsbomb", posX = 1400, posZ = 1600, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corawac", posX = 1400, posZ = 1700, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corhunt", posX = 1400, posZ = 1800, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_armsfig", posX = 1200, posZ = 2000, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armseap", posX = 1200, posZ = 2100, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsfig", posX = 1400, posZ = 2000, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corseap", posX = 1400, posZ = 2100, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_armah", posX = 1800, posZ = 700, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armanac", posX = 1800, posZ = 800, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armasubh", posX = 1800, posZ = 900, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armhover3g", posX = 1800, posZ = 1000, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armch", posX = 1800, posZ = 1100, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armsh", posX = 1800, posZ = 1200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armthovr", posX = 1800, posZ = 1300, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_corah", posX = 2000, posZ = 700, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corasubh", posX = 2000, posZ = 800, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corch", posX = 2000, posZ = 900, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cormh", posX = 2000, posZ = 1000, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsh", posX = 2000, posZ = 1100, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsnap", posX = 2000, posZ = 1200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corthovr", posX = 2000, posZ = 1300, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_armamb", posX = 1700, posZ = 1700, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armamd", posX = 1700, posZ = 1800, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armanni", posX = 1700, posZ = 1900, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armbrtha", posX = 1700, posZ = 2000, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armcrach", posX = 1700, posZ = 2100, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armdrag", posX = 1700, posZ = 2200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armemp", posX = 1600, posZ = 2300, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armfhlt", posX = 1700, posZ = 2300, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armflak", posX = 1700, posZ = 2400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armguard", posX = 1700, posZ = 2500, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armhlt", posX = 1700, posZ = 2600, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armlaunch", posX = 1700, posZ = 2750, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armllt", posX = 1700, posZ = 2900, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armrad", posX = 1700, posZ = 3000, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armrl", posX = 1700, posZ = 3100, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armsilo", posX = 1700, posZ = 3200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armsonar", posX = 1700, posZ = 3300, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armtabi", posX = 1500, posZ = 3400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armtflak", posX = 1700, posZ = 3400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armtl", posX = 1700, posZ = 3500, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armvulc", posX = 1700, posZ = 3600, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_canon3g", posX = 1700, posZ = 3700, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armmllt", posX = 1700, posZ = 3800, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armbox", posX = 1600, posZ = 3800, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_corbuzz", posX = 1900, posZ = 1700, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cordoom", posX = 1900, posZ = 1800, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cordrag", posX = 1900, posZ = 1900, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corfhlt", posX = 1900, posZ = 2000, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corflu", posX = 1900, posZ = 2100, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corflak", posX = 2000, posZ = 2100, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corfmd", posX = 1900, posZ = 2200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corfury2", posX = 1900, posZ = 2300, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corhlt", posX = 1900, posZ = 2400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corint", posX = 1900, posZ = 2500, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corllt", posX = 1900, posZ = 2600, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corplas", posX = 1900, posZ = 2700, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corpun", posX = 1900, posZ = 2800, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corrad", posX = 1900, posZ = 2900, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corrl", posX = 1900, posZ = 3000, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsilo", posX = 1900, posZ = 3100, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsonar", posX = 1900, posZ = 3200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsupergun", posX = 1900, posZ = 3300, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cortflak", posX = 1900, posZ = 3400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cortl", posX = 1900, posZ = 3500, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cortoast", posX = 1900, posZ = 3600, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cortron", posX = 1900, posZ = 3700, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corvipe", posX = 1900, posZ = 3800, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_dca", posX = 2000, posZ = 3800, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_omega", posX = 2100, posZ = 3800, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_splinter", posX = 2200, posZ = 3800, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_arm2veh", posX = 2250, posZ = 550, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_arm2air", posX = 2350, posZ = 550, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_arm2def", posX = 2450, posZ = 550, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_arm2kbot", posX = 2550, posZ = 550, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armlvl2", posX = 2750, posZ = 550, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armnanotc", posX = 2950, posZ = 550, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_cor2air", posX = 2250, posZ = 750, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cor2def", posX = 2350, posZ = 750, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cor2kbot", posX = 2450, posZ = 750, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cor2veh", posX = 2550, posZ = 750, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corlvl2", posX = 2750, posZ = 750, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corntow", posX = 2950, posZ = 750, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_armasp", posX = 2100, posZ = 1600, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armbase", posX = 2100, posZ = 1750, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armck", posX = 2100, posZ = 1900, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armestor", posX = 2100, posZ = 2000, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armfmex", posX = 2100, posZ = 2100, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armfmkr", posX = 2100, posZ = 2200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armfus", posX = 2100, posZ = 2300, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armgeo", posX = 2100, posZ = 2400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armmakr", posX = 2100, posZ = 2500, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armmfus", posX = 2100, posZ = 2600, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armmex", posX = 2100, posZ = 2700, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armmmkr", posX = 2100, posZ = 2800, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armmoho", posX = 2100, posZ = 2900, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armmstor", posX = 2100, posZ = 3000, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armsolar", posX = 2100, posZ = 3100, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armtide", posX = 2100, posZ = 3200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armuwasp", posX = 2100, posZ = 3300, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armuwmex", posX = 2100, posZ = 3400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armwin", posX = 2100, posZ = 3500, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_corack", posX = 2250, posZ = 1600, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corasp", posX = 2250, posZ = 1700, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corbase", posX = 2250, posZ = 1850, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corestor", posX = 2250, posZ = 2000, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corfmex", posX = 2250, posZ = 2100, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corfmkr", posX = 2250, posZ = 2200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corfus", posX = 2250, posZ = 2300, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corgeo", posX = 2250, posZ = 2400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cormakr", posX = 2250, posZ = 2500, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cormex", posX = 2250, posZ = 2600, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cormfus", posX = 2250, posZ = 2700, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cormmkr", posX = 2250, posZ = 2800, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cormoho", posX = 2250, posZ = 2900, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cormstor", posX = 2250, posZ = 3000, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsolar", posX = 2250, posZ = 3100, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cortide", posX = 2250, posZ = 3200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_coruwasp", posX = 2250, posZ = 3300, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_coruwmex", posX = 2250, posZ = 3400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corwin", posX = 2250, posZ = 3500, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_herfatboy", posX = 600, posZ = 2200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_hertrapper", posX = 700, posZ = 2200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_hercleaver", posX = 800, posZ = 2200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_herjuggernaut", posX = 900, posZ = 2200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_hermarksman", posX = 1000, posZ = 2200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_herpivot", posX = 1100, posZ = 2200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_herstalwart", posX = 1200, posZ = 2200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_hersabo", posX = 1300, posZ = 2200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_bug1", posX = 700, posZ = 2800, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_bug2", posX = 800, posZ = 2800, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_bug3", posX = 900, posZ = 2800, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_bug4", posX = 1000, posZ = 2800, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_bug5", posX = 1100, posZ = 2800, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corgamma", posX = 700, posZ = 2900, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corgamma2", posX = 800, posZ = 2900, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cormonsta", posX = 1000, posZ = 2900, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cormonstab", posX = 1100, posZ = 2900, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cormonstaq", posX = 1200, posZ = 2900, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_wormy", posX = 1300, posZ = 2900, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_chickend", posX = 700, posZ = 3000, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_roost", posX = 1200, posZ = 3200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
-- newSpawnThis[#newSpawnThis+1] 	= {name = "t_roost2", posX = 2000, posZ = 2800, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
-- newSpawnThis[#newSpawnThis+1] 	= {name = "t_bugegg", posX = 2100, posZ = 2800, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_repmum", posX = 700, posZ = 3200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_pireye", posX = 800, posZ = 3200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_armmine3", posX = 1000, posZ = 3500, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armmine4", posX = 1100, posZ = 3500, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armmine5", posX = 1200, posZ = 3500, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armmine6", posX = 1300, posZ = 3500, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_cormine1", posX = 1000, posZ = 3600, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cormine2", posX = 1200, posZ = 3600, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cormine3", posX = 1300, posZ = 3600, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cormine6", posX = 1400, posZ = 3600, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cormine7", posX = 1500, posZ = 3600, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_armaap", posX = 550, posZ = 3950, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armalab", posX = 750, posZ = 3950, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armap", posX = 950, posZ = 3950, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armavp", posX = 1150, posZ = 3950, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armcsy", posX = 1350, posZ = 3950, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armhklab", posX = 1550, posZ = 3950, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armhp", posX = 1750, posZ = 3950, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armlab", posX = 1950, posZ = 3950, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armshltx", posX = 2150, posZ = 3950, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armvp", posX = 2350, posZ = 3950, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armplab", posX = 2550, posZ = 3950, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armplat", posX = 2750, posZ = 3950, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_hergate", posX = 2550, posZ = 3600, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_coraap", posX = 550, posZ = 4400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_coralab", posX = 750, posZ = 4400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corap", posX = 950, posZ = 4400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_coravp", posX = 1150, posZ = 4650, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corvp", posX = 1350, posZ = 4400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corcsy", posX = 1500, posZ = 4400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corgant", posX = 1750, posZ = 4400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corhp", posX = 1950, posZ = 4400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corlab", posX = 1950, posZ = 4150, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corplat", posX = 2350, posZ = 4400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corslab", posX = 2550, posZ = 4400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corvalkfac", posX = 2750, posZ = 4400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corplab", posX = 2950, posZ = 4400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armfff", posX = 3150, posZ = 4400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_armaacrus", posX = 4000, posZ = 1000, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armacsub", posX = 4000, posZ = 1400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armbcrus", posX = 4000, posZ = 1800, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armcarry", posX = 4000, posZ = 2200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armcrus", posX = 4000, posZ = 2600, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armewar", posX = 4000, posZ = 3000, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armexcal", posX = 4000, posZ = 3400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armexcal2", posX = 4000, posZ = 3800, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armmcrus", posX = 4000, posZ = 4200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_armtib", posX = 4000, posZ = 4600, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_aseadragon", posX = 4000, posZ = 5000, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

newSpawnThis[#newSpawnThis+1] 	= {name = "t_coraacrus", posX = 4200, posZ = 1000, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_coraat", posX = 4200, posZ = 1400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_coracsub", posX = 4200, posZ = 1800, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corbcrus", posX = 4200, posZ = 2200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corblackhy", posX = 4200, posZ = 2600, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corcarry", posX = 4200, posZ = 3000, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corcrus", posX = 4200, posZ = 3400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cordest", posX = 4200, posZ = 3800, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corewar", posX = 4200, posZ = 4200, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corhmcrus", posX = 4200, posZ = 4600, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_cormblade", posX = 4200, posZ = 5000, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corsub", posX = 4200, posZ = 5400, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

-- features
-- newSpawnThis[#newSpawnThis+1] 	= {name = "t_containermetal", posX = 3800, posZ = 1000, facing = "s", teamName = "player1", checkType = "none", gameTime = 0}

-- technical enemy
newSpawnThis[#newSpawnThis+1] 	= {name = "t_pireye", posX = 8000, posZ = 8000, facing = "s", teamName = "defaultMissionAI", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_corfus", posX = 7500, posZ = 7500, facing = "s", teamName = "defaultMissionAI", checkType = "none", gameTime = 0}
newSpawnThis[#newSpawnThis+1] 	= {name = "t_coreter", posX = 7700, posZ = 7700, facing = "s", teamName = "defaultMissionAI", checkType = "none", gameTime = 0}


function NewSpawner()
    --Spring.Echo("N.O.E. mission_spawner: mission spawner works, but its empty")
end