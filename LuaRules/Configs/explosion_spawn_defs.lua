-- $Id: explosion_spawn_defs.lua 3255 2008-11-20 13:41:10Z kingraptor $
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--Lists post-processing weapon names and the units to spawn when they go off

local spawn_defs = {
	corbuzz_ak   = {name = "corak", cost = 0, expire = 0},
	armvulc_pw = {name = "armpw", cost=0, expire=0},
	cor_supergun_pyro = {name = "corpyro", cost=0, expire=0},
	cortron_weapon = {name = "scramerunit", number=1, cost=0, expire=30, gaia=1, groundhit = 1000},
	armemp_weapon = {name = "emperunit", number=1, cost=0, expire=30, gaia=1, groundhit=600},
	arm_empmine = {name = "emperunit", number=1, cost=0, expire=25, gaia=1, groundhit=600},
	high_bugasteroidbeacon = {name = "spawner_rockstorm", number = 1, cost = 0, expire = 10, gaia=1, groundhit=250},
	darkswarm = {name = "darkswarmunit", number = 1, cost = 0, expire = 14, gaia=0, groundhit=250},
}

local projectile_spawn_defs = {
	--dragonbugdie = {name = "bugbomb", speed = 50},
}

return spawn_defs, projectile_spawn_defs
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
