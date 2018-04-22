local moduleInfo = {
	name 	= "heroesCommandsDefs",
	desc	= "List all new custom commands definitions related to heroes", 
	author 	= "PepeAmpere", -- based on tsp_actions.lua from OTE
	date 	= "2015/08/07",
	license = "notAlicense",
}

-- we load that from shared folder to prevent overriding
include 'LuaRules/Configs/commandsIDs.lua'

local newCommandDefs = {
	["PlantNukeMine"] = {
		abilityDefName = "PlantNukeMine",
		desc = {
			id 		= CMD_PLANTBOMB,
			type 	= CMDTYPE.ICON,
			name 	= '',
			texture = "LuaUI/Widgets/notAchili/notaUI/images/commands/bold/plantmine.png",
			cursor 	= 'Plant Bomb',
			action 	= 'Plant Bomb',
			tooltip = 'Plant Nuclear Mine',
			params 	= {'Plant Bomb'},
		}
	},
	["PlantEMPMinefield"] = {
		abilityDefName = "PlantEMPMinefield",
		desc = {
			id 		= CMD_PLANTMINEFIELD,
			type 	= CMDTYPE.ICON,
			name 	= '',
			texture = "LuaUI/Widgets/notAchili/notaUI/images/commands/bold/plantminefield.png",
			cursor 	= 'Plant Minefield',
			action 	= 'Plant Minefield',
			tooltip = 'Plant EMP Trap',
			params 	= {'Plant Minefield'},
		},
	},
}

-- END OF MODULE DEFINITIONS --

-- update global tables 
if (commandDefs == nil) then commandDefs = {} end
for k,v in pairs(newCommandDefs) do
	if (commandDefs[k] ~= nil) then Spring.Echo("NOTIFICATION: Attempt to rewrite global table in module [" .. moduleInfo.name ..  "] - key: " .. k) end
	commandDefs[k] = v 
end