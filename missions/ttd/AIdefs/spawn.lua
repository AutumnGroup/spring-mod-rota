----- mission spawn list ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

-- !! not finished --
-- ! not own spawner
-- ! need add resources start setting

newSpawnDef = {
    ["armTransporter"]         = {unit = "armatlas", class = "single"},
	["armTransporter2"]        = {unit = "armsl", class = "single"},
	["coreTransporter"]        = {unit = "corbrik", class = "single"},
	["coreTransporter2"]       = {unit = "corvalk", class = "single"},
	["coreAssaultTransporter"] = {unit = "coraat", class = "single"},
	["radar"]                  = {unit = "corvoyr", class = "single"},
	["fusion"]                 = {unit = "corfus", class = "single"},
	["mex"]                    = {unit = "armmex", class = "single"},
	-- towers --
	["lltOne"]                 = {unit = "armmllt", class = "single"},
	["lltTwo"]                 = {unit = "corfury2", class = "single"},
	["lltStatic"]              = {unit = "armllt", class = "single"},
	["rocketTower"]            = {unit = "armbox", class = "single"},
	["antiArmorTower"]         = {unit = "splinter", class = "single"},
	["flakTower"]              = {unit = "armtflak", class = "single"},
	["artileryTower"]          = {unit = "armart", class = "single"},
	["immolator"]              = {unit = "corplas", class = "single"},
	-- gaia stuff --
	["pavement"]               = {unit = "concrete3x3", class = "single"},
	["pavementBig"]            = {unit = "concrete", class = "single"},
	["airportTower"]           = {unit = "build18", class = "single"},
}

newSpawnThis = {
    --- TIME: 0 ---
    --- players transporters ---
    {name = "armTransporter", posX = 6000, posZ = 5500, facing = "n", teamName = "player1", checkType = "single", checkName = "device1", gameTime = 0},
	{name = "coreTransporter", posX = 6100, posZ = 5600, facing = "n", teamName = "player2", checkType = "single", checkName = "device2", gameTime = 0},
	{name = "armTransporter", posX = 5900, posZ = 5400, facing = "n", teamName = "player3", checkType = "single", checkName = "device3", gameTime = 0},
	{name = "coreTransporter2", posX = 6100, posZ = 5400, facing = "n", teamName = "player4", checkType = "single", checkName = "device4", gameTime = 0},
	{name = "armTransporter2", posX = 5900, posZ = 5600, facing = "n", teamName = "player5", checkType = "single", checkName = "device5", gameTime = 0},
	{name = "coreTransporter", posX = 6000, posZ = 5600, facing = "n", teamName = "player6", checkType = "single", checkName = "device6", gameTime = 0},
	{name = "armTransporter", posX = 6000, posZ = 5400, facing = "n", teamName = "player7", checkType = "single", checkName = "device7", gameTime = 0},
	{name = "coreTransporter", posX = 6100, posZ = 5500, facing = "n", teamName = "player8", checkType = "single", checkName = "device8", gameTime = 0},
	{name = "coreTransporter2", posX = 5900, posZ = 5500, facing = "n", teamName = "player9", checkType = "single", checkName = "device9", gameTime = 0},
	--- base base ---
    {name = "radar", posX = 6800, posZ = 6600, facing = "n", teamName = "player1", checkType = "group", checkName = "radars", gameTime = 0},
	{name = "pavement", posX = 6800, posZ = 6600, facing = "n", teamName = "gaia", checkType = "none", gameTime = 0},
	{name = "radar", posX = 6800, posZ = 7000, facing = "n", teamName = "player2", checkType = "group", checkName = "radars", gameTime = 0},
	{name = "pavement", posX = 6800, posZ = 7000, facing = "n", teamName = "gaia", checkType = "none", gameTime = 0},
	{name = "radar", posX = 6600, posZ = 6800, facing = "n", teamName = "player3", checkType = "group", checkName = "radars", gameTime = 0},
	{name = "pavement", posX = 6600, posZ = 6800, facing = "n", teamName = "gaia", checkType = "none", gameTime = 0},
	{name = "radar", posX = 7000, posZ = 6800, facing = "n", teamName = "player4", checkType = "group", checkName = "radars", gameTime = 0},
	{name = "pavement", posX = 7000, posZ = 6800, facing = "n", teamName = "gaia", checkType = "none", gameTime = 0},
	{name = "fusion", posX = 6360, posZ = 5890, facing = "n", teamName = "player1", checkType = "single", checkName = "keyEnergy", gameTime = 0},
	-- mexes --
	{name = "mex", posX = 3995, posZ = 5533, facing = "n", teamName = "player1", checkType = "none", gameTime = 0},
	--- players towers ---
	--{name = "pavementBig", posX = 7200, posZ = 7200, facing = "n", teamName = "gaia", checkType = "none", gameTime = 0},
	-- static
	-- 2nd level
	{name = "lltStatic", posX = 3761, posZ = 4052, facing = "n", teamName = "player1", checkType = "none", gameTime = 0},
	{name = "lltStatic", posX = 4437, posZ = 3312, facing = "n", teamName = "player2", checkType = "none", gameTime = 0},
	{name = "lltStatic", posX = 6900, posZ = 2673, facing = "n", teamName = "player3", checkType = "none", gameTime = 0},
	{name = "lltStatic", posX = 7836, posZ = 3334, facing = "n", teamName = "player4", checkType = "none", gameTime = 0},
	{name = "lltStatic", posX = 9116, posZ = 5389, facing = "n", teamName = "player5", checkType = "none", gameTime = 0},
	{name = "lltStatic", posX = 9160, posZ = 6687, facing = "n", teamName = "player6", checkType = "none", gameTime = 0},
	{name = "lltStatic", posX = 7061, posZ = 8579, facing = "n", teamName = "player7", checkType = "none", gameTime = 0},
	{name = "lltStatic", posX = 6163, posZ = 8685, facing = "n", teamName = "player8", checkType = "none", gameTime = 0},
	{name = "lltStatic", posX = 3850, posZ = 7596, facing = "n", teamName = "player9", checkType = "none", gameTime = 0},
	{name = "lltStatic", posX = 3431, posZ = 6630, facing = "n", teamName = "player1", checkType = "none", gameTime = 0},
	
	{name = "immolator", posX = 4153, posZ = 3727, facing = "n", teamName = "player1", checkType = "none", gameTime = 0},
	{name = "immolator", posX = 7437, posZ = 3049, facing = "n", teamName = "player2", checkType = "none", gameTime = 0},
	{name = "immolator", posX = 8953, posZ = 6120, facing = "n", teamName = "player3", checkType = "none", gameTime = 0},
	{name = "immolator", posX = 6606, posZ = 8635, facing = "n", teamName = "player4", checkType = "none", gameTime = 0},
	{name = "immolator", posX = 3714, posZ = 7051, facing = "n", teamName = "player5", checkType = "none", gameTime = 0},
	
	{name = "armMGAA3x", posX = 5567, posZ = 2561, facing = "n", teamName = "player1", checkType = "none", gameTime = 0},
	{name = "armMGAA3x", posX = 9069, posZ = 4377, facing = "n", teamName = "player2", checkType = "none", gameTime = 0},
	{name = "armMGAA3x", posX = 8642, posZ = 8183, facing = "n", teamName = "player3", checkType = "none", gameTime = 0},
	{name = "armMGAA3x", posX = 4800, posZ = 8863, facing = "n", teamName = "player4", checkType = "none", gameTime = 0},
	{name = "armMGAA3x", posX = 2773, posZ = 5201, facing = "n", teamName = "player5", checkType = "none", gameTime = 0},
	-- 1st level --
    {name = "armLltDragged", posX = 5058, posZ = 5069, facing = "n", teamName = "player1", checkType = "none", gameTime = 0},
	{name = "armLltDragged", posX = 5700, posZ = 4651, facing = "n", teamName = "player2", checkType = "none", gameTime = 0},
	{name = "armLltDragged", posX = 7448, posZ = 5107, facing = "n", teamName = "player3", checkType = "none", gameTime = 0},
	{name = "armLltDragged", posX = 7412, posZ = 5883, facing = "n", teamName = "player4", checkType = "none", gameTime = 0},
	{name = "armLltDragged", posX = 5114, posZ = 6505, facing = "n", teamName = "player5", checkType = "none", gameTime = 0},
	{name = "armLltDragged", posX = 5852, posZ = 6891, facing = "n", teamName = "player6", checkType = "none", gameTime = 0},

	{name = "lltStatic", posX = 7410, posZ = 7992, facing = "n", teamName = "player7", checkType = "none", gameTime = 0},
	{name = "lltStatic", posX = 3851, posZ = 6388, facing = "n", teamName = "player8", checkType = "none", gameTime = 0},
	{name = "lltStatic", posX = 7451, posZ = 3522, facing = "n", teamName = "player9", checkType = "none", gameTime = 0},
	-- mobile
	{name = "lltTwo", posX = 4400, posZ = 5900, facing = "n", teamName = "player1", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "pavement", posX = 4400, posZ = 5900, facing = "n", teamName = "gaia", checkType = "none", gameTime = 0},
	{name = "lltTwo", posX = 4500, posZ = 5900, facing = "n", teamName = "player2", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "pavement", posX = 4500, posZ = 5900, facing = "n", teamName = "gaia", checkType = "none", gameTime = 0},
	{name = "lltTwo", posX = 4600, posZ = 5900, facing = "n", teamName = "player3", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "pavement", posX = 4600, posZ = 5900, facing = "n", teamName = "gaia", checkType = "none", gameTime = 0},
	{name = "lltTwo", posX = 4400, posZ = 6000, facing = "n", teamName = "player4", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "pavement", posX = 4400, posZ = 6000, facing = "n", teamName = "gaia", checkType = "none", gameTime = 0},
	{name = "lltTwo", posX = 4500, posZ = 6000, facing = "n", teamName = "player5", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "pavement", posX = 4500, posZ = 6000, facing = "n", teamName = "gaia", checkType = "none", gameTime = 0},
	{name = "lltTwo", posX = 4600, posZ = 6000, facing = "n", teamName = "player6", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "pavement", posX = 4600, posZ = 6000, facing = "n", teamName = "gaia", checkType = "none", gameTime = 0},
	{name = "lltTwo", posX = 4400, posZ = 6100, facing = "n", teamName = "player7", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "pavement", posX = 4400, posZ = 6100, facing = "n", teamName = "gaia", checkType = "none", gameTime = 0},
	{name = "lltTwo", posX = 4500, posZ = 6100, facing = "n", teamName = "player8", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "pavement", posX = 4500, posZ = 6100, facing = "n", teamName = "gaia", checkType = "none", gameTime = 0},
	{name = "lltTwo", posX = 4600, posZ = 6100, facing = "n", teamName = "player9", checkType = "group", checkName = "towers", gameTime = 0},	
	{name = "pavement", posX = 4600, posZ = 6100, facing = "n", teamName = "gaia", checkType = "none", gameTime = 0},
	
	{name = "rocketTower", posX = 6600, posZ = 4200, facing = "n", teamName = "player1", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "pavement", posX = 6600, posZ = 4200, facing = "n", teamName = "gaia", checkType = "none", gameTime = 0},
	{name = "rocketTower", posX = 6700, posZ = 4200, facing = "n", teamName = "player2", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "pavement", posX = 6700, posZ = 4200, facing = "n", teamName = "gaia", checkType = "none", gameTime = 0},
	{name = "rocketTower", posX = 6800, posZ = 4200, facing = "n", teamName = "player3", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "pavement", posX = 6800, posZ = 4200, facing = "n", teamName = "gaia", checkType = "none", gameTime = 0},
	{name = "rocketTower", posX = 6600, posZ = 4300, facing = "n", teamName = "player4", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "pavement", posX = 6600, posZ = 4300, facing = "n", teamName = "gaia", checkType = "none", gameTime = 0},
	{name = "rocketTower", posX = 6700, posZ = 4300, facing = "n", teamName = "player5", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "pavement", posX = 6700, posZ = 4300, facing = "n", teamName = "gaia", checkType = "none", gameTime = 0},
	{name = "rocketTower", posX = 6800, posZ = 4300, facing = "n", teamName = "player6", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "pavement", posX = 6800, posZ = 4300, facing = "n", teamName = "gaia", checkType = "none", gameTime = 0},
	{name = "rocketTower", posX = 6600, posZ = 4400, facing = "n", teamName = "player7", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "pavement", posX = 6600, posZ = 4400, facing = "n", teamName = "gaia", checkType = "none", gameTime = 0},
	{name = "rocketTower", posX = 6700, posZ = 4400, facing = "n", teamName = "player8", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "pavement", posX = 6700, posZ = 4400, facing = "n", teamName = "gaia", checkType = "none", gameTime = 0},
	{name = "rocketTower", posX = 6800, posZ = 4400, facing = "n", teamName = "player9", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "pavement", posX = 6800, posZ = 4400, facing = "n", teamName = "gaia", checkType = "none", gameTime = 0},
	
	{name = "antiArmorTower", posX = 5000, posZ = 5273, facing = "n", teamName = "player1", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "antiArmorTower", posX = 5639, posZ = 5078, facing = "n", teamName = "player2", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "antiArmorTower", posX = 6025, posZ = 4597, facing = "n", teamName = "player3", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "antiArmorTower", posX = 7310, posZ = 4913, facing = "n", teamName = "player4", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "antiArmorTower", posX = 7026, posZ = 5570, facing = "n", teamName = "player5", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "antiArmorTower", posX = 7371, posZ = 6089, facing = "n", teamName = "player6", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "antiArmorTower", posX = 6068, posZ = 6813, facing = "n", teamName = "player7", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "antiArmorTower", posX = 5634, posZ = 6460, facing = "n", teamName = "player8", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "antiArmorTower", posX = 4948, posZ = 6437, facing = "n", teamName = "player9", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "flakTower", posX = 3776, posZ = 5522, facing = "n", teamName = "player1", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "flakTower", posX = 3970, posZ = 6266, facing = "n", teamName = "player2", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "flakTower", posX = 4287, posZ = 5165, facing = "n", teamName = "player3", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "flakTower", posX = 6382, posZ = 3664, facing = "n", teamName = "player4", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "flakTower", posX = 7301, posZ = 3747, facing = "n", teamName = "player5", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "flakTower", posX = 7345, posZ = 4471, facing = "n", teamName = "player6", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "flakTower", posX = 7047, posZ = 7770, facing = "n", teamName = "player7", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "flakTower", posX = 6584, posZ = 7043, facing = "n", teamName = "player8", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "flakTower", posX = 7521, posZ = 6759, facing = "n", teamName = "player9", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "artileryTower", posX = 5544, posZ = 5618, facing = "n", teamName = "player1", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "artileryTower", posX = 5692, posZ = 5793, facing = "n", teamName = "player2", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "artileryTower", posX = 5494, posZ = 5838, facing = "n", teamName = "player3", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "artileryTower", posX = 6211, posZ = 4991, facing = "n", teamName = "player4", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "artileryTower", posX = 6051, posZ = 5076, facing = "n", teamName = "player5", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "artileryTower", posX = 6245, posZ = 5165, facing = "n", teamName = "player6", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "artileryTower", posX = 6502, posZ = 6052, facing = "n", teamName = "player7", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "artileryTower", posX = 6487, posZ = 5814, facing = "n", teamName = "player8", checkType = "group", checkName = "towers", gameTime = 0},
	{name = "artileryTower", posX = 6297, posZ = 5983, facing = "n", teamName = "player9", checkType = "group", checkName = "towers", gameTime = 0},
	--- attackers stuff ---
	{name = "coreAssaultTransporter", posX = 2700, posZ = 1400, facing = "s", teamName = "nastyAttacker", checkType = "group", checkName = "ships", gameTime = 0},
	{name = "coreAssaultTransporter", posX = 8400, posZ = 500, facing = "s", teamName = "nastyAttacker", checkType = "group", checkName = "ships", gameTime = 0},
	{name = "coreAssaultTransporter", posX = 11400, posZ = 3800, facing = "s", teamName = "nastyAttacker", checkType = "group", checkName = "ships", gameTime = 0},
	{name = "coreAssaultTransporter", posX = 11300, posZ = 9600, facing = "s", teamName = "nastyAttacker", checkType = "group", checkName = "ships", gameTime = 0},
	{name = "coreAssaultTransporter", posX = 7000, posZ = 11800, facing = "s", teamName = "nastyAttacker", checkType = "group", checkName = "ships", gameTime = 0},
	{name = "coreAssaultTransporter", posX = 2100, posZ = 10000, facing = "n", teamName = "nastyAttacker", checkType = "group", checkName = "ships", gameTime = 0},
	{name = "coreAssaultTransporter", posX = 600, posZ = 4400, facing = "n", teamName = "nastyAttacker", checkType = "group", checkName = "ships", gameTime = 0},
	--- first wave ---
	{name = "peeweeGang", posX = 1633, posZ = 3133, facing = "n", teamName = "nastyAttacker", checkType = "none", gameTime = 0},
	{name = "peeweeGang", posX = 5143, posZ = 1072, facing = "n", teamName = "nastyAttacker", checkType = "none", gameTime = 0},
	{name = "peeweeGang", posX = 9612, posZ = 2388, facing = "n", teamName = "nastyAttacker", checkType = "none", gameTime = 0},
	{name = "peeweeGang", posX = 10923, posZ = 6791, facing = "n", teamName = "nastyAttacker", checkType = "none", gameTime = 0},
	{name = "peeweeGang", posX = 9028, posZ = 10887, facing = "n", teamName = "nastyAttacker", checkType = "none", gameTime = 0},
	{name = "peeweeGang", posX = 4747, posZ = 11080, facing = "n", teamName = "nastyAttacker", checkType = "none", gameTime = 0},
	{name = "peeweeGang", posX = 1400, posZ = 7764, facing = "n", teamName = "nastyAttacker", checkType = "none", gameTime = 0},
	--- second wave ---
	{name = "peeweeGang", posX = 1633, posZ = 3133, facing = "n", teamName = "nastyAttacker", checkType = "none", gameTime = 60},
	{name = "peeweeGang", posX = 5143, posZ = 1072, facing = "n", teamName = "nastyAttacker", checkType = "none", gameTime = 60},
	{name = "peeweeGang", posX = 9612, posZ = 2388, facing = "n", teamName = "nastyAttacker", checkType = "none", gameTime = 60},
	{name = "peeweeGang", posX = 10923, posZ = 6791, facing = "n", teamName = "nastyAttacker", checkType = "none", gameTime = 60},
	{name = "peeweeGang", posX = 9028, posZ = 10887, facing = "n", teamName = "nastyAttacker", checkType = "none", gameTime = 60},
	{name = "peeweeGang", posX = 4747, posZ = 11080, facing = "n", teamName = "nastyAttacker", checkType = "none", gameTime = 60},
	{name = "peeweeGang", posX = 1400, posZ = 7764, facing = "n", teamName = "nastyAttacker", checkType = "none", gameTime = 60},
	--- half boss ---
	--- end boss ---
}

function NewSpawner()
    -- Spring.Echo("N.O.E. mission_spawner: mission spawner works, but its empty")
	spawnEdit["spawnLessPlayersTransfer"]()
end