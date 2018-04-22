----------------------------------------------------------
-- NOE modules loader
-- WIKI: http://code.google.com/p/nota/wiki/NOE_module_loader
----------------------------------------------------------

-- for easier customization and porting NOE framework
-- here just list files you want include in your NOE setup
-- ! WARRNING, overwrite of default content possible!

-- FILES BELOW WILL BE INCLUDED INTO NOE --

-----------------------------------------------------------
-- VITAL MANDATORY MODULES - general tools
	include "LuaRules/Configs/noe/modules/tools/mex_finder.lua"
	include "LuaRules/Configs/noe/modules/tools/build_space_finder.lua"
	include "LuaRules/Configs/noe/modules/tools/mission_data_loader.lua"

-----------------------------------------------------------
-- OPTIONAL STUFF

-- actions --
	
-- classes ---
	include "LuaRules/Configs/noe/modules/games/nota/noe1/classes.lua"
	
-- groups --
	include "LuaRules/Configs/noe/modules/games/nota/noe1/groups.lua"

-- side ---
	include "LuaRules/Configs/noe/modules/games/nota/noe1/side.lua"
	
-- spawn ---
	include "LuaRules/Configs/noe/modules/games/nota/noe1/spawn.lua"
