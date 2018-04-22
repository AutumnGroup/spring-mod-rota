
--FIXME: use this table until state tooltip detection is fixed
local tooltips = {
	priority = "Priority: Set construction priority (low, normal, high)",
	retreat = "Retreat: Retreat to closest retreat point at 30/60/90% of health (right-click to disable)",
	landat = "Repair level: set the HP % at which this aircraft will go to a repair pad (0, 30, 50, 80)",
	factoryGuard = "Auto Assist: Newly built constructors automatically assist their factory",
	diveBomb = "Dive bomb (never; target under shield; any target; always (including moving))",
	
	fireState = "Fire State: Sets under what conditions a unit will fire without an explicit attack order (never, when attacked, always)",
	moveState = "Move State: Sets how far out of its way a unit will move to attack enemies",
	["repeat"] = "Repeat: if on the unit will continously push finished orders to the end of its order queue",
}

-- temporary include from commmand constants
-- CMD_SCATTER
VFS.Include("LuaRules/Configs/commandsIDs.lua")

-- Command overrides. State commands by default expect array of textures, one for each state.
-- You can specify texture, text,tooltip, color
local commandsDir = 'LuaUI/Widgets/notAchili/notaUI/images/commands/'
local imageDir = commandsDir .. 'bold/'
local statesDir = commandsDir .. 'states/'

local overrides = {
	[CMD.ATTACK]	= { texture = imageDir .. 'attack.png', },
	[CMD.STOP]		= { texture = imageDir .. 'cancel.png', },
	[CMD.FIGHT]		= { texture = imageDir .. 'fight.png', },
	[CMD.GUARD]		= { texture = imageDir .. 'guard.png', },
	[CMD.MOVE]		= {	texture = imageDir .. 'move.png', },
	[CMD.PATROL]	= {	texture = imageDir .. 'patrol.png',	},
	[CMD.WAIT]		= {	texture = imageDir .. 'wait.png', },
	
	[CMD.REPAIR]	= {	texture = imageDir .. 'repair.png' },
	[CMD.RECLAIM]	= {	texture = imageDir .. 'reclaim.png' },
	[CMD.RESURRECT] = { texture = imageDir .. 'resurrect.png' },
	[CMD.DGUN]		= { texture = imageDir .. 'dgun.png' },
	[CMD.RESTORE]	= { texture = imageDir .. 'restore.png' },
	[CMD.CAPTURE]	= { texture = imageDir .. 'capture.png' },
	
	[CMD_UNIT_SET_TARGET] = { texture = imageDir .. 'settarget.png' },
	[CMD_UNIT_CANCEL_TARGET]	= { texture = imageDir .. 'canceltarget.png' },

	[CMD_UPGRADEMEX]= { texture = imageDir .. 'upgrademex.png' },
	[CMD_SCATTER]	= { texture = imageDir .. 'scatter.png' },

	[CMD.LOAD_UNITS]	= { texture = imageDir .. 'load.png' },
	[CMD.UNLOAD_UNITS]	= { texture = imageDir .. 'unload.png' },
	[CMD.AREA_ATTACK]	= { texture = imageDir .. 'areaattack.png', },
	[CMD_REFUEL]		= { texture = imageDir .. 'rearm.png', },
		
	[CMD_JUMP]		= { text = 'Jump', texture = imageDir .. 'jump.png' },
	[CMD_TELEPORT]	= { text = 'Teleport', texture = imageDir .. 'jump.png' },
	
	[CMD.ONOFF]		= { texture = { statesDir .. 'off.png', statesDir .. 'on.png' }, text='' },
	[CMD.REPEAT]	= { texture = { statesDir .. 'repeat_off.png', statesDir .. 'repeat_on.png' }, text='' },
	[CMD.CLOAK]		= { texture = { statesDir .. 'cloak_off.png', statesDir .. 'cloak_on.png'}, text ='' },

	[CMD_BUILDSPEED]	= { texture = { statesDir .. 'wrench_25.png', statesDir .. 'wrench_50.png', statesDir .. 'wrench_75.png', statesDir .. 'wrench_100.png' }, text='', tooltip = tooltips.priority },
	[CMD.MOVE_STATE]	= { texture = { statesDir .. 'move_hold.png', statesDir .. 'move_engage.png', statesDir .. 'move_roam.png' }, text='' },
	[CMD.FIRE_STATE]	= { texture = { statesDir .. 'fire_hold.png', statesDir .. 'fire_return.png', statesDir .. 'fire_atwill.png' }, text='' },
	[CMD.TRAJECTORY]	= { texture = { statesDir .. 'traj_low.png', statesDir .. 'traj_high.png', }, text='' },
	[CMD_AUTOTRAJ]		= { texture = { statesDir .. 'autotraj_off.png', statesDir .. 'autotraj_on.png', }, text='' },
	
	[CMD.IDLEMODE]		= { texture = { statesDir .. 'fly_on.png', statesDir .. 'fly_off.png', }, text='' },
	[CMD_ALTITUDE]		= { texture = { statesDir .. 'altitude_low.png', statesDir .. 'altitude_high.png', }, text='' },
	[CMD.AUTOREPAIRLEVEL] = { texture = { statesDir .. 'landat_off.png', statesDir .. 'landat_30.png', statesDir .. 'landat_50.png', statesDir .. 'landat_80.png', }, text='' },
	
	[CMD_AUTOMEX]		= { texture = { statesDir .. 'automex_off.png', statesDir .. 'automex_on.png', }, text='' },
}

return overrides