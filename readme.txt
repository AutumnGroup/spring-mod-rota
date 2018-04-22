--- nota 1.92 ---

[nota] is a game designed for larger maps with to-scale units, fuel for airplanes, and more.
[nota] features more strategic play, more diversified unit types, and a slower tech/econ development.
[nota] games can be very quick, seeing only t1 units, or very long, ending with the appearance of incredible superweapons.

--------------------------------------------
INCLUDED
- LuaAI: Spacebugs 		- specific scenario enemy, space insect invasion (v1.6)
- LuaAI: N.O.E.    		- skirmish enemy (v1.76)
- KOTH mode        		- scenario where players fight for specific territory (v1.6)
- MISSION: TTD     		- multiplayer mission (v1.69 alpha 05) (map Throne v1 needed)
- MISSION: rom-a03 		- multiplayer mission (v1.75 alpha, no storms, no story messages yet) (map RoughShoresV6 needed)

EXPERIMENTAL
- MISSION: rom-a05 		- multiplayer mission (v1.79 alpha, no triggers, no active mobile defences) (map MountainLakeV2 needed)
- MISSION: xants-pd		- showcase mision demonstrating Ants-based pathing (map Canyon redux v01 needed)
- MISSION: xants-sort	- showcase mission demonstrating sorting of eggs by swarm inteligence of Spacebugs (map TitanDuel needed)

HOW TO USE THESE MODES? CHECK: http://nota.machys.net/gameplay

------------ CHANGELOG ---------------------

1.92

GENERAL
- increased LOS LOD
- features HP fix working again, much more HP for each wreckage
- related crushing powers increased so heavy tanks or mechs are able to crush wreckages and cheap units

UNITS
- Arm Commander moved to medium armor class and core ones to heavy armor class
- All commanders light laser speed increased 3x (610 -> 1830)
- Warp gate commanders HP increased to 200 % (5800 -> 11600)

UI
- tweaking the air area attack widget to give planes enough targets

FIXES
- improved refactored reverse to work better with old pathplanner
- fixing warriors path tile

1.91

GENERAL
- ready to spring 103.0
+ own general resource simulation, Lua fuel for airplanes
- move distances for reverse use metric increased (+100 elmos, 375 -> 475, 325 -> 425)
- subs immune to most of the weapon types not related to anti-sub fight to prevent engine bugs (exceptions: asteriod, nuke, orbital laser, mines,...) 
- transport factories no longer set to repeat on by default
+ removing old hacky reverse gadget, now using engine reverse which was implemented on our request
	- except scouts all wheeled or tracked units have reverse (!)
+ added first public autotests (and many others not exposed)
	- autotest/refuel
	- autotest/refuel-carrier
	- autotest/refuel-gunship
+ added third resource hydrocarbons
	- currently just symbolic meaning, you have almost always enough
	- produced in airfields and in carriers
	- airfield, pads and carriers increase storage
- many tiny balances changes (hitspheres tweaks, aiming points, etc.)

GRAPHIC EFFECTS
+ all jet planes get jets effects

UI
- new icons for the resources (our own from notAspace)

TECH and FACTORIES cost rebalance
- T2 Nanotower metal costs decreased 50%, buildtime tripled
- T2 Factory metal costs decreased 25%, Workertime decreased 25%
- T1 Nanotower metal cost decreased 50%, buildtime tripled
- T3 Nanotower metal cost decreased 25%, buildtime doubled
- Moho mine metal cost increased 30%, energy cost increased 70%
- Valkyrie and Skybus factory costs decreased 40%, Workertime decreased 33%
- Seaplane factory costs decreased 40%, Workertime decreased 50%
- Core stealth lab cost decreased to 675 metal, 2400 energy.

BOTS and TANKS
- Peewee
	- Range increased from 255 to 285
	- hitspheres correction (small increase)
- A.K.
	- Range increased from 260 to 295
	- hitspheres correction (small increase)
- Thud/Hammer
	- Speed lowered from 1.1 to 1.0
	- Hitpoints lowered 10%
- Sniper
	- Speed lowered from 1.1 to 0.95
	- Damage to heavy armor decreased from 38% to 26%
- Pyro
	- Flamethrower redone - more intensive longer spray 
	- in 1.25s: damage 50 x 9 (light) or damage 50 x 6 (medium, default) or damage 50 x 2 (heavy, base) with 3.5s reload (old was 17 x 9 each 0.04 with 0.9 reload)
	- in result more deadly (stable) to all light units, longer flame makes sure that shot is not lost because of unstable aim and higher the probability of fire
	- better flame effect
- Zeus
	- decreased damage vs base on 66%
- Flash tank
	- Range increased from 310 to 340
- Jethro/Crasher and Samson/Slasher
	- Flight time of missiles increased + 40 % because of altitude changes for airplanes
- Instigator
	- Range increased from 315 to 350
- Panther
	- Energy cost increased 50%
	- no boost of AA (compared to all other AA and altitude changes)
- Reaper
	- weapon range increased from 530 to 600
- Bulldog
	- weapon range increased from 550 to 570
	- rear armor penalty decreased from 1.5 to 1.3
- Indian 
	- weapon velocity increased + 20 % (400 -> 480)
	- range decreased from 500 to 480
	- damage increased from 374 to 411
	- reload time increased from 4.6 to 5.4
	- AOE decreased from 38 to 24
	- unit acceleration increased from 0.0216 to 0.03; brakerate increased
	x rear armor (1.92 -> 1.6) reverted, because current implementation decrease the side armor also, too much
- Greyhound
	- AA gun range increase from 550 to 650
- Goliath
	- rear armor penalty decreased from 1.5 to 1.3
- Triton/Crock
	- underwater speed slowdown ration decreased from 0.03 to 0.015
+ added Core Saboteur
	- It can fire while cloaked, and it shoots nuke grenades and lays nuke mines!
	- converted to Hero
+ Tracker
	- converted to Hero
- Pyro 
	- self destruct count lowered to 0.5 seconds
	- suicide explosion damage to armor lowered
- Zipper and Sprinterus
	- hitspheres width increased from 15 to 17 to be on par with AK and Peewee correction
- Razorback
	- lowered the vertical distance it can shoot
- Hermes and Horgue T2 AA
	- increased misile flight time
- Mobile Artillery
	- area of effect increased from 80 to 96 for Arm, 64 to 80 for Core
- Mobile Flak
	- reload time decreased from 0.6 to 0.5
	- air LOS increased to 1200
- Drone
	- now light armor class
	- HP increased from 1200 to 1450
	- legs can be shot out by heavy shots resulting in reduced movement
- Arm Pod
	- damage to heavy armor lowered from 38% to 28%
	
MINES and BOMBS
- Crawling Bomb
	- Crawling Bomb now Core only
	- Speed increased and now sprints for short distance when moving out of burrowed state
	- Energy cost decreased to 2254
	- Damage lowered to 1200, explosion smaller when killed instead of detonating
- Spy energy cost increased 30%
- All regular land mine energy costs and cloak costs reduced 50%; buildtimes lowered 35%
- EMP mine cost now 5780 E, 107 M
- Nuclear mine cost decreased 20%, HP increased to 280/260 for Arm/Core
- Self-destruct time for all mines, spies, and bombs decreased to 0.5 seconds

DEFENCES
- Pop-up weapons given on/off switch to control folding behavior
- Closing speed improved on pop-up weapons and Doomsday Machine/Annihilator, opening speed decreased on pop-ups
- Closed state damage resistance for pop-ups and Doomsday/Annihilator is about 3 times less effective
- Flak gun fire rate doubled, accuracy slightly decreased, static variant HP slightly increased
- Core Scrambler EMP launcher paralyzetime increased to 30, Arm Stunner EMP launcher AOE increased to 750
- Spitter/DCA MG AA gets better range according the fly alt increase (550 -> 650)
- all flaks air LOS increased to 1200
- Core base AA beam gets height mod = 2 so no longer does trouble to hight-alt flying units

AIR
- alt multipliers for all airplanes increased from 0.7 to 1 for low alt flight and from 1.5 to 2 for high alt flight
- all transports fly altitude increased from 90 to 135 for ARM and from 80 to 120 for CORE air transports
- new way of mass unload from mass air trasnports as hotfix for spring unloading bug (it is much faster than before)

- Hellfish
	- bombs burst time decreased from .4 to .025 to fit high precision bomber role better
- Toadfoot 
	- metal cost increased + 5 % (350 -> 368)
	- energy cost increased + 33 % (7160 -> 9523)
	- buildtime increased +15 % (19176 -> 22052)
- Vashp
	- hitpoints increased from 442 to 520
- Flying Wing
	- Refuel time lowered from 30 seconds to 24 seconds
- Blade
	- metal cost increased + 10 % (344 -> 378)
	- energy cost decreased - 23% (7870 -> 6060)
	- buildtime decreased - 40% (16882 -> 10129)
	- max velocity decreased from 14 to 12
- Osprey
	- weapon damage increased + 50% to air (780 -> 1170), + 12% to flying fortresses (780 -> 878)
	- weapon range increased from 600 to 800
	- max velocity decreased from 14 to 8
	- energy cost increased + 60% (12883 -> 20613)
	- buildtime increased + 60% (21294 -> 34070)

SEAPLANES
- Underwater support bases now available in construction hovercraft build menu
- Seaplane fighter and torpedo plane buildtimes increased 20%
- Sonar plane metal cost decreased 50%, energy cost decreased 65%, buildtime decreased 50%

SHIPS
- Ship damage bonus to hovercraft lowered from 50% to 20%
- Ship Speed Rebalance
	- Excalibur destroyer speed increased from 2.2 to 2.5; turnrate increased 20%
	- Crusader heavy destroyer speed increased from 1.9 to 2.2; turnrate increased 20%; HP decreased 10%
	- Core Enforcer destroyer speed increased from 2.2 to 2.4; turnrate increased 20%
	- Mandau blade patrol frigate speed increased from 2.8 to 3.0
	- Attack subs speed decreased from 2.3/2.35 to 2/2.05 for Arm and Core respectively; HP increased 30%
	- Core Executioner cruiser speed decreased from 2.2 to 2.05; cost decreased 5%
	- Arm Conquerer battlecruiser speed decreased from 1.82 to 1.56
	- Core Inquisitor batttlecruiser speed decreased from 1.96 to 1.66; cost decreased 3%
	- Arm and Core electronic warfare ship speeds increased in same proportion as their destroyer counterparts
- Vanquisher Missile cruiser cost decreased 20% (7293 M, 44184 E, 71912 buildtime -> 5834 M, 35347 E, 57530 buildtime)
- Coastal defense gun (mobile and stationary) accuracy increased 20%

FIXES
- fixed negative arguments in gl.Scissor function (GUI)
- fix "synced in unsynced" 
	- game_end_team_com.lua
	- lups_nano_spray.lua
	- unit_autotraj.lua
	- unit_explosion_spawner.lua
	- unit_holdpos.lua
	- unit_reverse.lua
	- unit_scatter.lua
	- 0fix_unit.lua
	- 0fix_bug5.lua
	- 0fix_feature.lua
	- 0fix_fuel.lua
- updated reverse gadget
- disabled unit_mex_upgrader.lua
- hitspheres fix for engine 98.0
	- Indian
	- Goliath
	- both Construction subs
- fixed UnitPieceLight.lua - happens in small resolution (<1px results for some functions which doesn't accept zero values)
- fixed nanotowers not always being available in construction menu
- fixed bombers dropping an extra bombload on empty fuel
- fixed a bug where emp weapons got stuck repeatedly detonating
- all other hundreds of fixes listed in: https://trello.com/c/WTe3FedS/

v1.82

GENERAL 
!! second iteration of sphere changes, partly affected by engine upgrade, party fixing small spheres of air
- ready to Spring 95, 96
- improved spawn script, now all skirmish AIs take better spots

GROUND
- Indian turn rate increased (299 -> 375), so now between Bulldog (300) and Stumpy (450)
- Indian turret turn rate increased +50 % (50 -> 75), so now between Bulldog (50) and Stumpy (90)
- walking mines Invader and Roach gets +25 % move speed (1.1 -> 1.375)
- +10 % shoot range of AA mg guns of Spitter, DCA, Grayhound and all Ships MGs (500 -> 550) and Razorback (650 -> 715)
x Warrior and H.A.K. back in Light armor class
x Splinter dmg to buildings reverted back (smaller, 690 -> 460)

AIR
! generally bigger spheres of air so flaks are much more effective against air, especially bombers
- flying fortress missiles repulsor fixed (still temporary solution)

WIDGETS
+ "Air ground area attack" widget! Wet dream of many players done.
- speed-up of healthbars widget

FIXES
- fix rocket ships rockets for both ARM/CORE - AvoidFeature = true
- fix colors of Flash/Peewee/Brawler smg for new engine version
- fix spawning skirmish AI towers on same spot

v1.80

- just sync re-release
+ bug egg model + texture + deffile

v1.79

GENERAL
!! killed old global sphere change gadgets, just one global gadget now, as most as possible values set via UnitDefs
!! new spheres setup for features - if "_dead", it gets parent unit values, if "_heap", it gets low tile sphere
! dead reclaim is linear now, no steps, units reclaim stay by steps
! pop-up weapons now get 10x bigger damage resistance when folded then before
! static and mobile antinukes, advanced metal makers and closeable factories of both sides gets 4x bigger damage resistance when closed, solars 2x bigger then before (=> 6x total)
! all features get 5x more hitpoints
- default burn time increased (450 -> 600)
- lower resolution for LOS of all units, much lower for airplanes (anti LOS-draw-lag setting)
- chain reaction killing of units in case of TeamCommDeath
+ MT support enabled
+ new icon for NOTA
+ new unit Cleaver
+ new unit Fatboy
+ new unit Juggernaut
+ new unit Marksman
+ new unit Pivot
+ new unit Stalwart
+ new unit Trapper

AIR
! all refuel times tripled
! repair rate of airpads and carriers decreased by 75 % (800 -> 200) and airfields by 33 % (300 -> 200)
+ Brawler back in game! with 66 % of its old fuel (180 -> 120), increased health by +2/3 (420 -> 660) and fly altitude +50 % (100 -> 150)
- Lancet/Titan gets +40 % range for torpedoes (550 -> 770)
- Phoenix gets another +12 bombs (+50 %, 24 -> 36), Hurricane gets +24 bombs (+100 %, 24 -> 48) but bigger spread (2000 -> 5000) and faster burst (.13 -> .0975), all bombs get +100 % area of effect (36 -> 72) and +33 % dmg (115/92/51 -> 153/122/68)
- Black Lily gets one strong bomb instead of two weaker (dmg doubles, blast range doubles), better sound and blast effect
- rest air-bombs has generaly 150% area of effect to compensate smaller hitspheres of targets and preserve old balance (Hellfish, Vashp, Wing, Centurion, Thunder, Shadow)
- Tornado/Voodoo (seaplanes fighters) price decreased by 10 % (metal 191/186 -> 172/167, energy 6433/6654 -> 5790/5989)
- Tornado/Voodoo and Hawk/Vamp get flares (salvo 1, reload 0.1, effeciency 0.7, delay 0.1)
- Hawk/Vamp - HP lowered to 75 % (450/440 -> 338/330), stay stealth but cloak cost increased 4x (7 -> 28) and its default OFF
- Angel accelaration lowered by 50 % (1 -> 0.5)

GROUND
- Indian +20 % acceleration (0.018 -> 0.0216)
- Indian -20 % (weaker) rear armor (1.6 -> 1.92 = 160% recieved dmg -> 192% recieved dmg)
- Indian +10 % damage (340 -> 374)
- Panther build time increased +15 % (4453 -> 5121 = 0:22 -> 0:25)
- Bulldog +10 % fire range (500 -> 550) and bigger mass (2000 -> 2500)
- Bulldog build time lowered on 75 % (14661 -> 10995), which means 73 -> 54 seconds with full resources income (35 for Indian, 42 for Goliath)
- fat tanks (Reaper, Bulldog, Goliath) able to crush cheap tech1, Krogoth, Pod and Bug Queen are able to crush all tech1
- Grayhound shoot range decreased (800 -> 675) and price decreased by 20 % (M: 577 -> 462, E: 3805 -> 3044)
- Fido shoot range decreased (750 -> 625) and price decreased by 20 % (M: 308 -> 246, E: 3056 -> 2445)
- Pod health increased by +50 % (8248 -> 12372)
- Zeus and Panther energy weapon collide no more with allied units
- Pyro, Zeus, Warrior, H.A.K. moved to Medium armor class where they should belong (from crazy places they were before)

SHIPS
- Conquistador all weapons damage lowered -20 % (500 -> 400 for each)

DEFENCES
- Viper (pop-up laser) added on buildlist of Tech2 Defence expansion
- Splinter (core sabot transportable tower) damage increased (460 -> 690) and fixed basic default dmg

GAME FIXES
- fix - true final reverse gadget fix and its spedup
- fix - T1 transport was able to transport Penetrator
- fix - increased mass of MARS to stop moving when heavy bombers are refueled
- fix - moving dead features (hit by weapons)
- fix - subs firing backwards, now shooting angle is 120°
- fix - fuel lost when unit completed (+ engine fix managed from Spring 95.0+)
- fix - toad VS commtower and some ships not firing
- fix - Black Hydra laser killing friendly ships

GUI and WIDGETS
- ToadFoot loopback attack now default ON, for rest stay defualt OFF, speedup of widget
+ cmd_air_fly_default widget added, to satisfy Godde and Danil, all fighters and Toadfoot stay flying with no orders
+ projectile lights widget for another Danil's satisfaction
+ special healthbars above Boss units and MCs, big healthbar for bug Queen
+ tank armor UI widget added
+ new textures around minimap + 5 new view buttons
+ primary target/cancel primary target commands added + new cursor
- no autorepeat for shipyards
- no ranks for all units with special healthbars
- gfx - shockwave particle effect for flak removed
- fix - players names above commanders and MCs again
- fix + new look - customformations2 (thx to PixelOfDeath)
- fix - stockpile widget work again
- fix - rejoin progress widget killed

NOE
+ new math functions for NOE
+ added "noSpirit" for testing purposes in spirit library
+ added support for spawning features in missions (updated spawner, mission data loader and unit pos exporter tool)
- fix - for testing builds of engine
- fix - NOE now reload mexmap and buildmap properly on notAmap

SPACEBUGS
! huge NOE-like speed-up, which results in non-laggy gameplay even with engine 94.1, including late game
+ buildpics for all spacebugs and their stuff
- flying bugs again not "stealth", again visible on radar
- Montro Gamma (basic flying bug) is able to load units
- Montro Alpha (basic warrior bug) is able to reclaim, build, repair, etc.
- Montro Alpha is able to climb all hills, its true bug now!
- Crawler (Dust bug) crush strenght increased, crush almost all tech1 robots (50 -> 350)
- Spacebugs Queen size and HP increased ~ +100 %
- fix - dust cloud emitter cannot be attacked now
- fix - Dust bug (Crawler) main weapon attack fixed
- fix - chickends blocking big bugs in hive

KOTH
- better game-end gadget with slow destroying of units of team which lost the game
- fix - warrning messages for KOTH gong sounds

MISSIONS
- startscript for Spacebugs singleplayer fixed
+ NEW MISSION - xants-sort - added mission showing clever spacebugs sorting eggs (beta, demo)
+ NEW MISSION - rom-a05 - Thor's mission on Thor's map (alpha)

SPRING ENGINE 95.0 UPDATE
+ armors lualization
- all colors off weapons converted into RGB notation
- fix - cylinderTargetting -> cylinderTargeting
- fix - old .builder, .isCommander,... tags replaced or removed
- fix - backward compatibility of armors lualization

v1.76

- fix - bombers (spring 94.1, killing "manualBombSettings" parameter), true working bombers, including carpet bombers and flying fortress
- fix - long console content (=> was crash)
- fix - much smaller hitsphere for ARM Pod, a bit smaller hitspheres for Triton, Grayhound, Bulldog, Reaper, Crock
- fix - Grayhound AA gun cannot attack ground now
- fix - added missing commands icons - Jump and Teleport
- fix - noe_sprits.lua (random function in mexes builder)
- fix - huge increase of heatmapping for ships (0.8,200) and small increase of it for tanks (0.2,30)

v1.75

GAME
+ added notAicon in game (for taskbar)
- Triton is now radar stealth, its energy cost is increased by 33 % (2900 -> 3857) and buildtime increased by 20 % (6112 -> 7334)
- Samson/Slasher AA missiles damage rethink (Samson 145 -> 3x66 split 0.3, Slasher 145 -> 2x88 split 0.5)
- Slasher's LOS enhanced (+20 %) (400 -> 480) and HP enhanced (+20 %) (650 -> 786)
- AA missile range of Panther lowered (700 -> 650)
- crawling bombs buildtime reduced by 40 % (8000 -> 4800 for Invader, 8900 -> 5340 for Roach)
- radarEmitHeight higher (20 -> 80 for CORE radar, 20 -> 75 for ARM radar)
- all ships LOS and radar emit heights added (all were default 20, now 50 for destroyer class, 70 for cruisers and carriers class, 90 for flagships)
- +33 % for radar range of both electronic war ships Scrambler/Blotter (2500 -> 3325)
- 150% build range for all commanders (128 -> 192)
- underwater platform added in buildlist of hover constructors for both sides
- loopback attack possible for all AAA units (A-fighters, sea A-fighters, AA-fighters, Interceptors), but theres a new widget that select the default behavior for plane
- Black Lily loose 6 bombs (8 -> 2), +100% bigger area effect of bombs (74 -> 150), 400% damage for each bomb to all targets (380 -> 1520)
- Firebat napalm bombs have slower drop (=> bigger area off effect)
- advanced bombers Phoenix/Hurricane becoming carpet bombers - gets +18 bombs (4x, 6 -> 24), but 50% damage for each bomb and energy price of bombers +50 %
- Thunder/Shadow and Phoenix/Hurricane do less damage to medium armor and much lesser to heavy armor (230,230,230 -> 230,184,103 for basic bombers, half for advanced ones) 
- again changed the hitsphere of both dragon-teeths (20/20/20 -> 30/20/30)
- fix - collide/avoid friendly unit for ground weapon of CORE tower = false
- fix - spawner fix for game launch without lobby
- fix - floating mexes and metal makers tags (MaxSlope,MaxWaterDepth)
- fix - multiple bombs throwing fixed for Hellfish, Vashp, Flying Wing, Black Lily, Firebat
- fix - a bit buring units in napalm
- fix - tanks reverse (spring 94.1)

UI and WIDGETS
+ New chili based Nota UI = gui_chili_nota_ui.lua minimap, selection bar, build/order bar, resource bar
+ Grab Chili Epic menu, Chili tooltip integrate it to NotaUI
+ Add gui_tactical_grid.lua (default OFF)
+ Add gui_tactical_select.lua
+ Add cmd_air_loopback_default.lua
- Renamed ui_ron_taunts.lua > api_ron_taunts.lua
- Renamed gui_radar_view_on.lua > map_radar_view_on.lua
- Turn off default RedUI except console
- Changed unit_healthbars.lua = added fuel bar, remove feature health (slowdowns )
- repaired end-order patrol for clever_gathering_point
- killed anti-spam for game taunts
- fixed LOS and RadarView from start for Specs (OFF for them by default now)
- ON default - unit_improved_metal_maker.lua
- OFF default - gui_tactical_grid.lua 
- ON default - cmd_fac_holdposition.lua
- ON default - unit_smart_area_reclaim.lua
- ON default - cmd_factory_repeat.lua

NOE
+ added "secret" terraform parameter (its executed when game starts, so its hidden for players who have not LOS on that place)
+ added recalculation of metal map for notAmap
+ NOE events (NOE conditions + NOE actions) now executed better way, possible to have custom number of parameters for custom number of conditions and actions
+ NOE tasks added - noe_tasks.lua/tasks.lua and task table to describe groups mission tasks
+ NOE map added - noe_map.lua/map.lua introduced
+ all groupDefinitions have now own default values
+ new groupDef parameters - "factories", "taskName"
- huge fixes and in group changer
+ missionInfo, missionKnowledge, etc.. introduced
+ initGroup structure introduced
- BigMove - dependant groups use rotation of their leaders now
- activity checking in RunSpirits function (spirits of not active groups are not executed, override notSleeper)
! fix of those bloody unit counters! :) (pepe is noob)
- fix for GetPositionOfGroup(groupID)
+++++ MANY MANY plans, spririts, conditions, events, actions added (tens of such things)

MISSION: rom-a03
+ first tasks
+ many spirits completed
+ full trigger map made
+ transport paths completed
+ air attacks
+ gadget checkers for transports added
+ first random taunt reactions added
+ tank raiders!
+ airdrops!
+ combinder airstrikes!

v1.72a

GAME
+ added widget camera_smoothcam.lua (= smooth zoom)
+ added widget map_external_grid.lua (= grid instead of water as background)
+ created new widget gui_radar_view_on.lua that enables radar view at start of the game
+ created cool widget that make formations on gathering points (for units comming from factory)
- widget Factory Auto-Repeat sets repeat on just created factories, not finished ones
- sonar range enhanced +10 % (1276 -> 1400)
- seismic signature for all subs working now (0 -> 2)
- modrules - gaia features ONLY are visible without "exploring" them (before: all were seen)
- strange secondary tracks behind small commander (armcom2/corcom2) are history
- changed hitsphere of dragon teeths (both) and Shika
- fix - again smaller spheres for planes (14x14) to avoid crawling mine unload bug and not loosing airbus from view
- fix of Toadfoot - weapon targetting tolerance lowered (3000 -> 500), changed max altitude (220 -> 440), possible button highAlt/lowAlt, (btw sure 0% missfire with HOLD FIRE)

SPACEBUGS
- jamming effect of dust cloud of Dust Bug lowered (1400 -> 400)

NOE
+ NOE conditions added (LuaRules/Configs/noe/noe_conditions.lua)
+ NOE events added (LuaRules/Configs/noe/noe_events.lua)
+ NOE actions added (LuaRules/Configs/noe/noe_actions.lua)
+ NOE terraforming added (LuaRules/Configs/noe/noe_terraform.lua)
- mission_data_loader updated for conditions, events, actions and terraforming
- added "spawLessPlayersDontSpawn" in spawnEdit library - function, that in mission looks at all planed spawns and if some slot for player is not used -> those spawns are not executed
- setting amount of resources for all games with NOE in unit_noe.lua/noe_side.lua and mission settings.lua
- fix - loader bad debug condition
- new conditions in conditions library
+ widget "mission editor" that generates the code for noe use


MISSIONS
- all working missions equiped with conditions, events and actions files
- fix all .ini map setting (SpecMapName -> MapName) to be coherent with Nota :: Lobby
- fixed when mission doesnt have specified start resources (aiDefs/side.lua)

MISSION: sbugs-normal
- fixed start_script.txt

new MISSION: rom-a03
- all files prepared
- weather_snow_storm added!

v1.71

GAME
- Zeus/Pyro gets + 10% HP (975 -> 1075, 620 -> 680)
- fix - Vashp sphere added into list of planes with big sphere
- fix - unitdefs_post.lua SPissue killed ;)

NOE
- NOE spawner fixed, now place the unit in height on given place, not in Y = 0
+ xAnt mapping!

MISSIONS
- all missions prepared for lobby Single Player (TTD and Spacbugs .ini)
- media files, icons, descriptions for 3 missions
- file for using gadgets from unit_noe.lua - gadgets.lua
- file for own work with debug GUI - gui.lua 

NEW SP mission: Spacebugs
- made and prepared the Single Player version of normal Spacebugs (need map Talus)

NEW SP mission: xAnts pathing demo 
- one NOE tools promo showing pathing algorithm of ants (need map Canyon_Redux-v01)

v1.70

v1.70c (stable public release => 1.70)
GAME
- killed heightMod lowering the AA shootdistance of:
    - Jethro/Crasher, Samson/Slasher, Hermes/Horgue, Crabe (1.1 -> 1.0)
    - Defender/Pulverizer, Panther (1.3 -> 1.0)
	- Swatter/Slinger (1.4 -> 1.0)
	- not AA weapons of - Peewee, Bulldog, Pyro , Spider, Anaconda/Snapper (1.1 -> 1.0), Maverick (1.3 -> 1.0)
	=> dont worry, no big change, we are back before engine change fixes, basic AA now works good as before (yes, it was weak a bit in last two versions)
	=> ship AA range handicaps stay
NOE
- groupDefs
    - forgotten usage of class "lessDangerousGroundUnits" for antiground planes groups
	- some "lightAttacker" groups of light bots are now "cleaner"s
	- all small ak's groups are cleaners <- raiders spirit
    - many small changes in spirits, numbers, status and preference numbers
	- panther group is "cleaner" now
- functions
    - ChooseClosestTargetGivenClass() with parameter class=="all" choose from all targets in list
    - the same function break and return target if its closer then 1000 and dont look for others
	- ChooseClosestSpot() is now using the learning feature of previous function ChooseMexSpot()
    - RealBufferJob() gets PrepareFirstUnit(secondGroup.groupED) before every try to transfer to prevent returning to "new leader's pos"
- spirits
    - new spirit "cleaner" derivated from "lightAttacker"
	- "artileryCommander" now stop only leader unit, not full group, when enemy in range
    - "cloacked-raider" is more like "cleaner", then "raider"
- formations
    - leader of main attack formation gets better position a bit behind the lines
    - added "standardLineZig" to replace "standardLine2nd" formation as secondary formation, all three (main, zig-version, 2nd) generated from +1 place, because save pos for leader
	- again main formation changed (previouse move of the leader was not good)
    - "artyLine" get bigger X-scale (50->70)
    - "swarm" and "cirlce" gets lower constrainLevel (swarm 4->2, circle 16->2)
- fix
    - killed debug message about sleeping group
	
v1.70b
GAME
- fix - twice bigger build range for FARK to avoid repeating "tries" to build a building (60->128, now the same like Necro)
- fix - hellfish added in list of planes with big default spheres -> lowered 
NOE
- general
    - new table isStaticTargetClass[className] (part of finishing of targeting tool), added in init part
- groups
    - new group "stumpy-raider"  
- classes
    - every class of targets gets "static" = true/false value (for use in targets list)	
- spirits
    - targeting for "raiders" and "cloacked-raiders" is changed to new one =>
    => dependable on static value unit attacking group (attacking_by_BigMove) asks for position or not
    - lowered distance of "lightAttackers" from target - 200->100
- plans
    - tech2 expansions have endplan patroling hardcoded

v1.70a
GAME
- fix - Avengers ground units chasing bug
- fix - refueling model collision bug (Spring 91.0) for Lancet, Titan and Firebat
- fix - Osprey's main gun and Flying Wing's MG cannot be forced to attack ground
- speedup of model spheres fixgadget
NOE
- general
    - bigger groups of builders, lower transfer counts for these groups
	- lrpc's (Bertha/Intimidator) and blueLeaser weapons (Annihilator/Doomsday machine) added to Defence Tech2 nod buildlist
	- the annoying message about units there were not in any group is killed
	- more simple, slower and stupid expansion algorithm ;) for eco bots => new function ChooseClosestSpot(teamNumber,kind,posX,posZ) instead of current ChooseMexSpot(teamNumber,kind))
	- new table isStaticTargetClass[className] (part of finishing of targeting tool), added in init part
- formations
    - new formation "circle"
- functions
    - more simple, slower and stupid expansion algorithm ;) for eco bots => 
    => new function ChooseClosestSpot(teamNumber,kind,posX,posZ) instead of current ChooseMexSpot(teamNumber,kind))
    - few testing code lines in GlobalVarSet (testing which unit is member of which group)
- groupDefs
    - added new guard groups for safe expanding and conquering the territory for both sides
    - bigger transfer numbers for eco guards groups
    - first eco bot is not battlegroup assister, but mex builder (becouse transfer numbers changed a bit)
    - added expTowers class to some other attack groups
    - enhanced rocko group (bigger) and added the equivalent one to CORe (doesnt had antiarmor group yet)
- spirits
    - new spirits "builderDefender" - 8 light bots guarding eco group
    - new spirit "invisible-raider" for snipers, at least! :)
    - new spirit "heavySupportLine" boosting the role of rocket bots against armor spam (simply derivated from secondary line)
    - upgraded "support-line" and "artileryCommander" spirit on planned levels (better copy move of the leader, stop arty when enemy close,...)
    - main tank dont attack factory when weak, look for metal target
    - added part of missing code in "lightAttacker" (more in fix chapter)
- classes
    - new class - lessDangerousGroundUnits - containing all fat armored units (as targets for antiground air)
- fixes
    - additional units in eco groups now dont stay at base (only 1st unit was doing something)
    - forgotten choosing from list of targets at "lightAttacker" and "raider" spirit added (old code killed), so attackers choose more targets now
	- fixed start game sleeping of AI if not enough mexes around tower
	- fixed energy stall if AI have to big metal income
	- fixed some old mistakes and copleted missing code in "supportLine", "raider" and other spirits

v1.69

v1.69c (stable public release => 1.69)
GAME
- fixed model radius for some transports again (mass transports were not working still)
MISSIONS
- TTD: rebalanced spawn times

v1.69b
GAME
- lualization of Gamedata/icontypes.tdf -> icontypes.lua
- unit_comm_nametags.lua widget repaired
- bigger spread for mass airtransports (unloadSpread: 1->3)
- fixed model radius of air-transports (Spring 91.0 bugfix) so load/unload works fine again
MISSIONS
- TTD: bulldog tank added into enemy spawner

v1.69a
GAME
- Eagle and Vulture (radar planes) have radar ON when built by default
- dragon teeth models of both main sides are a bit bigger (before: 1/2 of OTA/BA teeth, current: 3/4 of OTA/BA teeth) and their mass changed from 49 => 1600
- CORE tower AA beam now shoots only lowVTOLs, too, as ARM missile one does.
- experimental: heatmapping ON (low level) for most of the types of units to avoid "grouping" in one path
- EMP paralyzation effect now appear when current health of unit is reached, not when the maxHealth reached as was before (default)
- reclaiming works more gradual now - you get resources not at the end, but after every 1/4 of reclaim, for features and dead units works the same
- lualization of modrules.tdf -> modrules.lua
- fixed 34 bad yard unit definitions
- fixed 2 old names of targeting class
- old player_killed messages working again (f.ex.: "Team 1 (danil_kalina) has been terminated")
- "pirates" and "spacebugs" startoptions removed (pirates subproject abandoned, only pirates mission will be created, spacebugs mode can be played by adding Spacebugs AI)
NOE and MISSIONS
- added support for missions and NOE AI modifications
- NOE: enhanced build decisions for late games
+ NEW MISSION: TTD (Transportable Tower Defence) - alpha test

v1.681

- fixed underwater move bug of Triton/Crock
- speed of underwater move of all commanders, walking mines and underwater tanks adjusted, hard to say how much, but the move is now recognizable (depthmod=0.03)

v1.68 

v1.68f (stable public release => 1.68)
GAME
- spring 89.0 fix (hitspheres bug)
- accuracy of mobile flaks (Phalanx/Sentry) lowered (1850->2200)
- all AIs now choose random position in ally box, minimaly 1000 from border of map, if possible (so no need for set start positions before game now)
- updated list of leaders in game_end_team_com.lua, so now start commanders (weaker versions) are taken as leader units, too
- added 2 commanders to unit_marker widget
- added widgets to gamefile from notapack:
    - cmd_fac_holdposition.lua
    - cmd_factory_repeat.lua
    - cmd_factoryqmanager.lua
    - cmd_stall_assist.lua
    - gui_advplayerslist.lua
    - gui_ally_cursors.lua
    - gui_build_costs.lua
    - gui_buildspacing.lua
    - gui_easyFacing.lua
    - gui_point_tracker.lua
    - gui_reclaiminfov099.lua
    - gui_selbuttons.lua
    - gui_unit_stats.lua
    - gui_xp.lua
    - snd_volume_osd.lua
    - unit_allySelectedUnits.lua
    - unit_comm_nametags.lua
    - unit_ghostRadar.lua
    - unit_smart_area_reclaim.lua
    - unit_stockpile.lua
    - ui_ron_taunts.lua   (renamed)
NOE
- AI more use energy storages (after fusions)
- AI dont need too much metal in storage for teching or making additional factories (9/10->8/10)
- antiground air likes more defence buildings

v1.68e
GAME
- Jethro/Crasher, Samson/Slasher, Hermes/Horgue heightMod handicaps lowered (1.2->1.1), = a bit longer shoot distance
- Defender/Pulverizer heightMod handicaps balanced to the same value
- accuracy of static flaks (Flakker/Cobra) lowered (200->600)
- ship AA/SAM rockets gets heightMod = 1.1 handicap => less effective a bit
- ship flaks get back accuracy atribute (with old value) => so more incaccurate
NOE
- AI knows air and def tech2 expansions, build airfighters, wings, napalms and nukes
- main battlegroup uses using more AA and advanced AA
- main tank attack brigade is using the same "keep formation" procedures as other groups now => tanks attacking in (own) formations, too
- many new battlegroups
- more airpads when AI goes air
- air using target attacking again
- AI knows mohobuilder and upgrades mines

v1.68d
NOE
- AI knows ground tech2
- AI knows storages, llts and plasma batteries
- AI knows some late game special attack
- some speedups are default ON, some calculated automaticly
- many new battlegroups

v1.68c
GAME
- repaired critical bug in Team Com End script
NOE
- some additional battlegroups

v1.68b
GAME
- Centurion (flying fortress) have smaller hitsphere, now 2/9 (22,22%) of old one
- Undertow and Sinker (anti-sub hovers) have longer range for torpedoes (420 -> 590) - (subs have still 550, destroyers 630)
- Tracker mincloakdistance set on 0 (25 -> 0) (easier planting bombs)
- Team Com End option working again (gadget added) + mobile commanders counted, too, as leading units that are needed to be destroyed
NOE
- many fixes of AI
- massive speedup of mapping (so more AIs on bigger maps possible)
- new tactical groups
- AI has first defence groups that patrol around base
- not random acquiring metal spots now, much clever territory capture algorithm now
- noe now can accept given units or dont become mad when share units
- AI has own metal maker widget (simple version)
- difference between ARM and CORE is much bigger now (in strategy)
- enhanced late game behavior (bigger groups, usage of surpluses of production, better behavior of big groups)

v1.68a
GAME 
- Lancet and Titan (torpedo bombers) haver smaller hitspheres, now 7/18 (39%) of old ones
- 10x bigger brake rate for construction hovers of both main sides (from 0.006 to 0.06 and from 0.008 to 0.08)
- spacebugs Alpha montro (bug1), Delta Montro (bug2), Ultra Montro (bug3), Fatso Montro (bug4), Dust Bug (bug5) and Plasma bug (wormy) + Spore Tower and Hive are no longer affected by EMP weapons, becouse they not consist of metal and have no electronic parts, flying bugs are still affected becouse EMP jam their navigation system and montrobugs are affected becouse they consist of electronic parts (+ added own armor classes for all bugs and weapons using them)
- partly fixed startup lag, all possible speedups added, the problem is in model (other start units doesnt make such problems)
- fixed gui_attack_aoe.lua agian
- fixed Arm Command Tower force attack ground with AA weapon instead of antiground one
- fixed Plasma bug using his plasma flak against ground targets
- fixed Greyhoud weapons shooting bad targets
- fixed ground unit chasing for Avenger
- fixed force attack ground for Hawk, Vamp, 
NOE AI alpha version here:
[+] FEATURES
- independent agent system, commanding struncture (group, supergroup, brain)
- modules - formations, groups, spirit programs can be easily redefined
- more then 10 formations
- speedable
- inteligent building system (buildmapping)
- strategic mapping
- graphic debug mode
[-] KNOWN ISSUES, NOT FINISHED FEATURES
!! AI is not fair, knows everything
! no difference between EASY, MEDIUM, HARD yet
! up to 16x16 map, max 3 AIs in 3 different is possible to have on map (with all speedups ON), bigger amount of AIs lag... 28x28 map can run with 2 AIs
! no advanced tactics for all attack groups (advanced things not implemented), they are able only gather and attack in one choosen formation, only main Thud/Hammer battlegroup is able to do some advanced things
! no use of tech2 now
! not possible play on map, that have not classic metal spots
! no big difference in tactics of ARM and CORE (expect snipers, morties, levelers) and some group counts
! only two clone brains Thor (CORE), Cake (ARM), very few special features implemented yet, no special tactics yet, Morphdog planed too
! not metalmaker controler now
! buildSpots are choosen quite clever, but no spacing around geo spots and factories (mexes spots ok)
! NOE AI is not able to start in the middle of the sea, needs some dry land around
! not using users def files for creating own AIs setup
! not using, not finished Spectator learing widget

v1.67

- completely changed hitsphears of all planes
- changed hitsphears of both shipyards - elipsoid => box
- 50% reduction of dmg recived by hovers from torpedoes attacks
- fix - Samurai added into hovertank armor class

v1.67a - not public
- +20% front armor for heavy tanks (Repaer, Goliath, Bulldog), +10% front armor for all light and medium tanks
- heightmod 1.1 handicap for Delta Montro (bug2) and Spore tower AA. Delta Montro is unable to shoot high attitude planes and def burrow have big problems with it now
- finished speedups for spacebugs
- fixed some AA that was able to be force to attack ground (Equalizer, Panther, Hermes, Horgue, Swatter, Slinger) 
- fixed Jethro and Phalanx chasing ground units bug 
- fixed spacebugs Queen crushing own Hives and Spore towers and Commtowers
- fixes spacebugs Queen was able to forceattack ground with AA missile

v1.667
- stable public release

v1.667c - not public
- fixed Razorback, COREbase shooting with AA to ground
- changed description of core_sonar
v1.667b - not public
- pod teleport and commander jumpjet repaired and gui for them repaired too
- changed description of Fatso Montro (bug4), Plasma worm (wormy) and Spore Tower
v1.667a - not public
. only fix for new engine version (87)
- fixed - guardian/punisher, ambusher/toaster, annihilator not shooting Air (NEVER)
- Demolisher/Avatar prefere ships when choosing target now
- fixed gui_attack_aoe.lua in game folder
? maybe fixed lups_shockwaves.lua
- spacebugs working again

v1.666d - not public
- fixed - Splinter/Box-of-Death, Storm/Rocko, Omega/Perforator, BBertha dont shoot Air now (NEVER)
- Omega/Peroforator prefere ships when choosing target now
- fixed - Defender shoot only air enemies now
- all supercannons get avoidfeature tag (=0 - such as should be as default (?))
v1.666c - not public
- fixed hitsphere of Avatar and Demolisher
- fixed all AA shooting ground with ordered attack (thx Godde to figure that bug), tens of edits, so some some bugs can stay there!
- movement type of bots set back until some permanent fix is found
- fixed static flak shooting ground units
- a lot of unit ground fight units are now able to shoot low altitude planes again, but the very good guys in such job get some heightMod handicap (Maverick, Tracker, AntiarmorARM guys, Indian, Spider, Pyro, Rocko/Storm, Stumpy, Bulldog)
- jethro/crashers and their vehicle versions with smaller handicap again
v1.666b - not public
- changed description of Box-of-Death
- some other speedups at spacebugs
- changed movement type for small bots (TEMPORARY)
- a bit longer shoot distance for jethro/crashers + and their vehicle versions
- Shadow AA shooting bug fixed
v1.666a - not public (bad mod description)
. only fix for new engine version (86)
- better behavior of bombers at napalm bombing - the move waypoint after attack waypoint control the way of napalm strike as it was usuall before
- gui_startradius.lua repaired, so dont sometimes put itself accidentaly off
- megafix of all AA and A-G weapons (120+ edits of OnlyTargetCategory and height of weap. shooting range - so pls report every bug, possibile you find any)
- changed description of Floating MM
- fixed target finding for spacebugs

v1.665
. only fix for new engine version
- sounds listed in 1.664 - killed warning messages by converting wavs
- queen_AI pathfinding repaired, working now
- massive speedup of bugAI /not so massive as planned, but still host can feel it :/

v1.664
. only fix for new engine version
- stereo sounds for spacebugs replaced with mono-ones
   - spit.wav
   - splat.wav
   - TRexRoar.wav
   - electronhit.wav
   - gong_friendlyhill.wav
   - gond_enemyhill.wav
- spacebugs hive visible on all maps
- spacebug movement type repaired at bug1,2,3,4,5

v1.663
. only fix for new engine version

- OLD morphing bug fixed
- added some missing textures
- stereo arm_MMaker explosion replaced with mono one

v1.662

. only fix for new engine version
- fixed game_end (now you need to kill all units in team, classic team comm end will be in next version)
- added - team_platters.lua (set: not active)

v1.661 

. only fix for new engine version
- added - new version of unit_healthbars.lua
	- new version of minimap_startbox.lua
	- added pepes update of unit_marker.lua (NOTA friendly now, v1.42)
- spacebugs mod fixed, now its possible to play it
- bug2 reload weapon time fixed
- bombers bombs spread fixed

v1.66

-Hellfish cost increased 20%; Bomb area of effect decreased 20%; damage to ships decreased 10%
-Toadfoot hitpoints decreased 15%
-Vashp hitpoints decreased 15%
-Napalm bomber cost increased 10%
-Flying Wing cost increased 10%
-Stationary Flak gun accuracy significantly improved, but ability to hit fast moving targets lowered
-Strategic bomber hitsphere size increased
-Flying Fortress hitpoints increased from 5800 to 8000
-Razorback's ability to lead moving targets improved
-Crusader destroyer cost increased 5%; hitbox size increased; gun accuracy decreased; turnrate increased
-Excalibur and Enforcer destroyer turnrate increased
-Black Hydra wiggly behavior fixed; hitbox size increased to fix problem where some weapons were shooting over it
-EMP Mine area of effect greatly increased; it also jams radar in the area it was detonated; cost increased
-Increased the build distance on all construction units
-Zeus has new icon
-In spacebugs, the bugs now have a squad of spitters defending hives in the early game
-Spitters appear sooner on Insane difficulty

v1.65

-Peewee, A.K. hitpoints increased 30%; speed decreased 15%; damage to armor decreased
-Medium tank accuracy, area of effect increased; range increased from 420 to 450; speed decreased 10%; Damage to armor lowered to 80% medium, 50% heavy
-Thud, Hammer reload time increased 10%
-Flash range increased to 310; Damage to light units and buildings decreased 15%
-Mobile artillery damage to armor lowered from 80% medium, 50% heavy to 60% medium, 35% heavy
-Arm railgun cruiser reload time increased 10%
-Core Osprey Interceptor firepower improved
-Arm Blade Interceptor firepower slightly improved
-Anti-sub hovercraft speed increased about 7%
-Arm Pod range decreased from 850 to 800
-Arm Flea size increased 20%
-Spacebug Insane difficulty made slightly easier (can still be made harder by adding extra bots)

v1.64

-Spacebugs changes- including new bug types, new queen behavior
-Hammer climbing ability increased from 30 to 34
-Vashp rocket range and area of effect decreased
-Toadfoot rocket area of effect decreased
-Spy kbot cost decreased 30%; cloak cost decreased
-Zeus range increased from 280 to 310; area of effect increased
-Panther range increased from 240 to 280; area of effect increased
-Flash range increased from 285 to 295
-Vashp and Toadfoot rocket damage to ships decreased 15%
-Torpedo Bomber damage decreased 15%; speed decreased 15%; metal cost increased 10%; energy cost + buildtime decreased 15%
-Mandau Blade Patrol Ship max speed increased from 2.6 to 2.8
-Fixed sonar not working on Anti-Sub Hovercraft
-Fixed Core Anti-Air Cruiser not shooting properly
-Fixed Mandau Blade AA not shooting

v1.634

-Fixed oversized unit hitspheres
-Fixed floating metal extractor hitbox location
-Mobile artillery turret turn rate lowered
-Pelican metal and energy cost increased 5%

v1.633

-Turned off heatmapping pathfinding
-Fixed a bug with Pod teleport
-Core battleship hitbox fixed
-Fixed machinegun AA firing at aircraft out of range

v1.632

-Updated gadgets to work with Spring 0.82
-Zipper/Sprinteur energy cost increased
-Increased Sonar Station Sonar Range by 10%; Passive range by 33%
-Mandau Blade can now turn off its radar

v1.631

-Fixed a bug with Toad machinegun

v1.63

-Added "Mandau Blade" Patrol Frigate for Core. Light and fast, it is equipped with two short range rocket launchers and an AA machinegun
-Added "Crusader" Heavy Destroyer for Arm. Ideal for long range ship engagements, it also carries formidable anti-air
-Core destroyer scaled up; cost increased 30%; hitpoints increased to 3700; rear gun range increased to 840
-Arm destroyer now has two plasma guns with 820 range; flak replaced by machineguns
-Commander in commander mode now builds stationary laser tower and flak 
-High altitude aircraft now have the option of flying at low altitude
-Fighters can now fly at high altitude; line of sight decreased to 500
-Pod can now teleport; weapon changed to a fast firing laser
-Pelican cost increased 10%
-Nixer Rocket hovercraft damage to ships increased
-Ship wreckage metal values lowered to 25% of initial cost
-Fast attack kbot energy cost decreased 33%
-Dominator range decreased from 1050 to 1000
-Zeus speed increased 10%
-Decreased firing angle on vashp long range missiles
-Toadfoot fuel decreased to 300
-Interceptor buildtime decreased 25%
-Flying Wing turnrate increased
-Flying Wing laser range increased from 650 to 725
-Amphibious tank underwater move speed increased to 75% of full speed
-Crawling bombs are now stealth
-Spy kbot no longer decloaks if it bumps into a unit
-Lowered scout plane cruise altitude
-Removed brawler and rapier gunships
-Fixed a bug where core commander couldn't shoot his laser

v1.62

-Commander and Base mode replaced with Commander mode. Commander in this mode has cheap cloaking but limited build tree.
-Peewee, AK, and HAK speed increased 10%
-Galacticus cost and buildtime decreased 20%; range decreased from 1500 to 1250; rate of fire decreased 20%; Secondary gun damage decreased 25%
-Oddity cost decreased 20%; range decreased from 1500 to 1250; rate of fire decreased 20%
-Penetrator cost and buildtime decreased 35%; damage decreased 35%; Laser uses 17% less energy
-Kbot and hovercraft AA reload time and damage decreased
-Improved firing angles for Missile AA trucks and hovercraft
-Mobile flak damage slightly increased but accuracy slightly decreased
-Hellfish accuracy against moving targets improved
-Hellfish reargun damage and accuracy lowered
-Hammer/Thud damage to buildings and hovercraft decreased 10%
-Thud and Sniper climbing ability lowered from 38 to 34 (regular kbots are 30)
-Spy kbot cost and buildtime decreased 20%
-Pelican rocket damage increased 33%
-Increased dmg/sec of crabe, panther, and pelican anti-air
-Goliath speed increased 5%
-Maverick and Drone weapons now do reduced damage to armor on the same scale as thuds/hammers
-Maverick energy cost decreased 25%; metal cost decreased 15%; buildtime decreased 25%
-Drone cost and buildtime decreased 15%
-Razorback cost and buildtime decreased 5%
-Horgue Speed increased
-Can range increased from 360 to 400; reload time increased 11%
-Stunner and Scramjam missiles now create a jamming effect in the area where they hit
-Core Carrier now has anti-nukes
-Anti-nukes launch sooner against incoming missiles
-Core cruiser cost and buildtime decreased 10%
-Talwar energy cost and buildtime decreased 15%
-Arm cruiser energy cost increased 5%
-Battlecruiser cost and buildtime increased 5%
-Coastal Defense Guns now prioritize ships over other targets
-EMP Mine cost and buildtime decreased 40%
-Nuke Mine no longer automatically detonates. Use Ctrl-D to detonate it.
-Lasers no longer try to shoot through wreckage
-Changed Greyhound machinegun sound effect
-Increased Spacebug Queen mass so it won't be knocked by explosions
-Added RedUI. LolUI is still included but turned off by default. Don't enable both at once. Added autoquit and pause screen widgets

v1.61

-Added new buildpics. Credits to Umrug and mTm for all resource buildings, factories, and Core air.
-Changed the order of buildlists to be more consistent
-Sub turnrate and speed dramatically improved
-Sub torpedo guidance decreased; they can be dodged by faster, smaller ships like destroyers
-Sub torpedo range decreased from 700 to 550
-Sub anti-sub torpedo velocity and guidance improved
-Sub icon distance decreased
-Destroyer torpedoes no longer launch in volleys, but reload twice as fast, have slightly higher velocity, and do 28% more damage to most units(except subs)
-Destroyer sonar range decreased from 630 to 580
-Core destroyer hitpoints increased 3%
-Arm destroyer main cannon accuracy decreased
-Arm battlecruiser buildtime increased 25%
-Core battlecruiser buildtime increased 15%
-Core cruiser buildtime decreased 5%
-Core battleship speed increased slightly
-Ship wreckage metal values decreased from 50% to 30% of initial cost
-Anti-sub hover torpedo range, velocity slightly increased
-Flying wing laser range decreased from 800 to 650
-T2 AA truck metal and energy cost decreased 10%; reload time decreased 5%
-Mobile artillery no longer shoots at air
-Lowered the distance behind a unit where giving a move order will activate reverse

v1.60

-Added Team Commander Ends mod option. An ally team is defeated when all of its command towers have been destroyed. Enabled by default.
-Added No Share mod option. Disallows sharing units or resources to enemy teams. Enabled by default.
-Hellfish accuracy against moving targets improved; fuel increased.
-Units don't damage themselves anymore when firing at point blank range
-Skybus and Valkyrie II cost decreased 10%
-Tracker speed increased 7%
-Crawling Bomb speed increased 10%
-Jammer ship jamming range increased from 500 to 550
-Missile tower reload time decreased 5%
-Nuclear Missile damage to command towers doubled
-Strategic Bomber damage to command towers decreased 20%
-Air-to-air missiles have a lower start velocity
-Stealth fighter maneuverability increased
-Seaplane fighter maneuverability increased and reload time decreased significantly, but now fires missiles individually
-Hovertank spin speed increased significantly; Samurai spin speed increased slightly
-Leveler turret spin rate decreased 20%
-Thunder/Shadow machine gun accuracy slightly decreased
-Floating Metal Extractor hitpoints increased 30%

v1.59

-Strategic Bomber accuracy increased significantly; area of effect and damage decreased
-Mobile artilllery accuracy increased; low trajectory range raised to 950
-Tech 2 nanotowers can now build their corresponding tech 1 lab
-Kbot lab hitpoints decreased 15%
-Added lolUI, allymousecursor, and ETA widgets; Updated Custom Formations

v1.58

-Bulldog, indian, warrior, HAK, phoenix, and hurricane all now built at tech 1 rather than tech 2 labs.
	They become available to build once you (or a teammate of the same faction) have the tech 2 nanotower of the type(tank, kbot, or air) to which they belong
-Tech 2 nanotower energy cost and buildtime increased
-Advanced factory metal cost decreased by about 200
-Moho mine energy cost increased 20%
-Bulldog hitpoints lowered from 2800 to 2500
-Warrior speed, range increased
-HAK range increased
-Rocket Kbot hitpoints slightly increased
-Fixed some problems with beam weapons not firing, not doing full damage

v1.57

-Added Alchemist's king of the hill game mode to NOTA.  Set the hill by giving an extra start box.
	Any ground unit can take control of the hill, but to claim time on the hill you must have exclusive control.
-Got rid of dependencies for OTA content.  All content is now included in the mod
-Integrated spacebugs into NOTA as a mod option
-Light plasma (hammer/thud) now does 70% damage to medium armor instead of 65% from before
-Core Tracker bombs area of effect increased to 350.  Damage increased to 2000.  They now take 2 minutes to build each.
-Increased damage for side and rear hits to most tanks
-Fixed some problems with collisions on the underwater seaplane platforms
-Fixed transportable turrets
-Increased reverse speed for tanks
-Lowered buildtime for spy kbots
-Lowered annihilator cost
-Lowered reload time for lvl1 anti-air kbots (crasher and jethro)

v1.56

-Added Brik Light Air Transport for CORE
-Kbot autoheal time decreased
-Tanks can now drive in reverse
-Radars detect cloaked units as blips instead of decloaking them
-Immolators and pyro deaths no longer set units on fire
-decreased fido range from 800 to 740
-grayhound hp reduced by 200
-Bombs and Artillery given gravity constants.  No longer affected by map gravity.

v1.551-2
-Fixed lua errors

v1.55

-All active radar units now reveal their location to any enemy radars covering that area
-Added Covert Ops Center for CORE, which builds the Tracker infiltration kbot
-Tracker model changed; can now plant remote bombs; laser range reduced
-Sniper cost decreased; range and damage to armor decreased; can now fire without decloaking
-Arm Spy kbot now built at tech 1 kbot lab; Self destructs in an EMP blast
-Units can now be set on fire by certain weapons such as napalm
-Nuclear missile area of effect increased
-Arm Commander is now light armor; jumpjet reload time increased
-Flak cost decreased
-Valkyrie acceleration increased
-Fixed problems with lasers having trouble hitting flash
-Added some new visual and sound effects

v1.54

-Fixed script errors
-Fixed a bug that prevented shipyards from building when a floating mex was nearby
-Energy Storage buildtime decreased 50%
-Hammer and Thud buildtime increased 4%
-Mobile coastal gun hitpoints increased 10%; buildtime decreased 5%
-Stationary coastal gun hitpoints increased 5%
-Oddity accuracy decreased
-Thunder and Shadow accuracy slightly increased
-Arm Battlecruiser speed decreased 5%
-Dragon's Teeth metal cost reduced
-Flea buildtime decreased 20%
-Updated customformations, area of effect widgets, and added advplayerlist widget

v1.53

-Hammer, Thud, and Morty damage to armor increased
-Rocket Kbot damage increased 3%
-Changed Maverick autoheal, cost
-Strategic Bomber accuracy increased, damage decreased
-Decreased Energy Storage metal cost to 120
-Core Valkyrie Transports are now heavy lifters and built at the transport factory
-Core truck now built at vehicle plant, and can't refuel aircraft anymore
-Destroyer speed slightly increased
-Fusion hitpoints increased by 200
-Heavy Fusion hitpoints increased by 1000
-Vashp firepower decreased 2.5%


v1.52

-Fixed transportable turrets not being transportable
-Ships and Vehicles now move as they turn
-Maverick builds 30% faster, energy cost lowered
-Raptor builds slower, energy cost increased
-Added Start radius and autotrajectory back in
-Removed aircraft fuel widget since it is no longer needed in Spring 0.77b4


v1.51

-Fixed various problems caused by Spring 0.77
-Added a quick fix widget to help aircraft return to base for fuel since that behavior is broken in 0.77. Most of the time bombers will behave as they used to, but sometimes they will still get stuck
attacking with no fuel, in which case giving a stop command will often get them to return to base.
-Added improved hitboxes for buildings and ships
-Strategic Bombers now drop much heavier bombs
-Heavy Strategic Bomber hitpoints and cost increased
-Cruiser accuracy decreased
-Minimum water depth for cruisers and larger ships increased
-start radius and autotrajectory removed since they do not work in 0.77


v1.50

-Base Constructors can now upgrade into level 2 constructors
-Hammer/Thud/Morty light plasma weapons now do 60% to medium armor and 36% to heavy; previously 50% medium and 30% heavy
-Rocket Kbot metal and energy cost decreased 5%
-Sonar Plane sonar range increased 40%
-Destroyer torpedo and sonar range increased 5%
-Necro energy cost decreased 10%; Fark energy cost decreased 5%
-Nuclear Cannon area of effect and damage increased
-RaptorIV buildtime increased 50%
-Maverick buildtime decreased 18%
-SPY kbot cloak now costs only 20 energy/second
-Core Truck can now carry 7 infantry kbots
-Added Attack AoE Widget

v1.49

-Fixed a bug that caused morties to be stuck in high trajectory mode
-Added ability to turn off mobile artillery auto-switching trajectory
-Panther tank cost reverted to pre-1.48 value
-Fido hitpoints reduced 10%
-Buildtime on stealth fighters decreased 15%
-Buildtime decreased 5% on Blade interceptors; 10% on Osprey interceptors
-Buildtime on heavy strategic bombers decreased 5%
-ScramJam stun damage increased
-Fleas cost 50% more metal, hp increased slightly

v 1.48

-Added "ScramJam" Electronic Scrambler Missile Launcher for CORE. It delivers a mild EMP blast over a wide area - useful for temporarily knocking out detection equipment on radar units
	(cloaked unit detection remains disabled until all paralyze damage has worn off)
-Flashes, Instigators, and Panthers now have medium armor
-Flash and Instigator hitpoints reduced 25%; Panther lightning gun fires 30% slower, more expensive
-Hammer/Thud/Morty light plasma weapons now do 50% to medium armor and 30% to heavy; previously 66% medium and 40% heavy
-Light laser tower range increased from 560 to 600
-Mobile Artillery automatically switches trajectories; accuracy increased in high trajectory
-Hovertanks and Samurai now strafe sideways; Hovertanks can reverse, samurai cannot
-Medium Tank accuracy when moving increased
-Hellfish fuel increased
-Added a Scatter Button to quickly spread out units
-EMP area of effect increased
-Bertha accuracy decreased a bit
-Mobile flak buildtime decreased 20%; Samson/Slasher buildtime increased 10%
-Features no longer prevent units from shooting if they're in the line of fire
-Pressing Ctrl-C now selects the Command Center

v 1.47

-Morty Speed decreased 20%, hitpoints decreased 15%
-Talwar Assault Transport cost decreased 20%
-Hovercraft Transport hitpoints increased 40%
-Increased Indian cost slightly
-re-added sniper hit sound
-Fixed a bug that caused game to freeze

v 1.46

-Added "Indian" Medium Assault Tank for CORE
-Added jumpjets for the ARM Commander
-Added refuel button for aircraft
-Hammer/Thud/Morty light plasma weapons now do 66% to medium armor and 40% to heavy; previously 100% medium and 50% heavy
-Metal Extractor Platform cost decreased 50%
-Samurai accuracy decreased
-Sniper weapon type changed to projectile laser; 75% damage to heavy armor and buildings; 700 range; 15 second reload time
-All Aircraft cost increased 2%
-Hellfish speed decreased
-Torpedo Bomber buildtime decreased 10%
-Blade firepower decreased 5%
-Maverick autoheal begins instantly; autoheal rate increased
-Sprinter and zipper range slightly decreased
-Tracker and Stealth Bomber decloak radius decreased
-Dragonfly price cut from last version rolled back from 30% to 10%
-Dragon's Teeth metal and energy cost decreased 40%
-Added Command Tower Start Radius, Improved Metal Maker, and Transport AI Widgets


v 1.45

-Snipers are always stealth again
-Hellfish drop two bombs again
-Dragonfly Transport 30% cheaper
-Vashps less effective vs. air transports
-Avenger and Freedom Fighter LOS reduced
-Toadfoot LOS slightly increased
-Core shipyard now has resource storage
-Sprinter and Marky kbots are now always upright


v 1.44

-Added "Tracker" Infiltrator Kbot for CORE
-Added Spy kbot for ARM
-Added Battle Commander for Arm
-Added Floating Metal Extractors, built by bases and hovercraft
-Added Deployment and Commander Start mod options
-Commanders are now built at a warp gate
-Units with radar can now detect cloaked units at medium-to-close range
-Pelicans much faster in water; AA improved; laser damage/sec reduced; hp slightly reduced
-Gimps can climb slopes; damage/sec significantly increased; hp slightly reduced; now medium armor
-Nuclear Missile Silo metal cost and buildtime reduced 50%
-Cruiser, Battlecruiser, and Battleship overall firepower decreased 5%
-Missile Ship range decreased from 2600 to 2400; minimum range slightly decreased
-Bulldog firepower significantly increased
-Sniper damage, reload time decreased; not stealth when moving; decloak radius decreased
-Morty death explosion size reduced
-Mobile Artillery have much more range while in high trajectory mode; fire larger plasma shells
-Rocket Box damage to heavy armor decreased to 50%
-Hellfish drop a single powerful bomb instead of two
-Arm Drone firepower decreased
-Arm Spider range, speed increased
-Moho Engineers are now all terrain
-Moho Mine metal cost decreased 30%
-Tidal Generator metal cost increased 15%
-Radar Tower cost increased 20%
-LLT laser velocity increased ~100%
-Machine Gun velocity increased 43%
-Vulcan and Buzzsaw cost decreased 30%
-Vulcan energy cost to fire decreased 50%
-Black Lilly decloak radius decreased; does not decloak to fire; buildtime increased
-Stealth Fighter decloak radius decreased
-Toadfoot damage to ships lowered 25%
-Flying Wing hitpoints increased 5%; damage to buildings and ships increased ~7%
-Torpedo Bomber cost reduced 5%
-Commanders are now stealth while cloaked
-Heavy unit death explosion less deadly to other heavies.
-Crawling Bomb and landmine cost decreased
-Viper hitpoints slightly reduced
-Maverick autoheal improved
-Greyhound flank damage reduced
-Flea weapon changed back to regular laser
-Core Truck cheaper
-Flak slightly more accurate
-Fixed build menus loading slow
-Changed aircraft buildpictures to make numbers easier to see
-Fixed solar collectors showing up as idle builders

v 1.43

-All Mobile AA damage or reload time slightly improved
-Flak accuracy improved
-Collision turned back on for fighters; they won't stack on top of each other anymore
-Heavy Bombers can now be killed by direct flak hits setting an engine on fire
-The Advanced Missile Systems on Core AA cruiser and carrier can now shoot at high altitude planes
-Core AA cruiser and carrier cost slightly increased
-Heavy Bomber AA accuracy slightly improved
-Sniper accuracy and damage to light armor increased
-Cruiser auto-heal slightly decreased
-Mobile anti-ship guns are now transportable by only heavy transports
-Flak turret turnrate reduced
-Command Centers can build floating metal makers
-Removed annoying unit halting sounds

v 1.42

-Heavy Bomber Buildtime increased, Machine gun damage reduced 50%
-Krogoth hitpoints reduced and missiles are now anti-air only, but its handcannons are more powerful
-Air Transports no longer try to land on airpads
-Crawling Bombs can't burrow underwater anymore
-Sonar planes no longer use fuel
-Mobile light laser tower cost reduced
-Pinocchio metal cost reduced 30%
-Annihilator cost slightly increased
-Arm battlecruiser speed decreased 4%
-Sub torpedo velocity slightly increased
-Fixed goliath smoking when being built
-Valkyrie II Factory doesn't spin when building

v 1.41

-Added "Angel" High Altitude Spy Plane for ARM
-Added factories at tech level 1 for the skybus and valkyrie II infantry transports
-Skybus has two machine guns to defend itself with
-Autoheal increased for all infantry kbots
-Ship-to-Hovercraft damage decreased
-Construction hovercraft, light hovercraft, and hovertank speed increased
-Artillery hovercraft hitpoints increased
-Cruiser range decreased
-Missile ship damage to ships reduced
-Advanced Aircraft Plant buildspeed lowered
-Advanced Strategic Bomber buildtime lowered
-Hellfish do a bit more damage to ships
-Black Lilly now decloaks only for a moment when dropping bombs
-Improved Blade Interceptor aiming with guns, removed missile
-Fast Attack Kbots build faster, cost slightly less energy
-EMP missiles travel faster, do more EMP damage
-Crawling bomb cost decreased
-Panther speed increased
-Annihilator hitpoints increased
-Fuel for gunships increased
-pyro slightly improved
-increased reload time on merls and diplomats
-Arm Anti-Air Cruiser turret turnrate increased
-Fixed diplomat rockets falling short of target
-Fixed factory production speed gadget

v 1.40

-Metal output increased across the board (from 75% to 85% of BA's values)
-Fusion Power Plants available at level 1; they cost about 1300 metal and produce 300 energy. Heavy Fusion Power Plants assume the role previously held by regular fusions.
-Factories can no longer be assisted; max buildspeed of most factories increased
-Added button that changes factory production rate
-All wreckages now give back only 50% of the original cost
-Added Wasp Light Carrier for ARM. It is relatively inexpensive, with six airpads and decent flak defense.
-Added Shamshir Strike Carrier for CORE. It can refuel up to nine aircraft at once, and has a single cruiser plasma gun, an advanced long range anti-air missile system, and plenty of flak.
-Added Skybus Infantry Transport for ARM. It is built by lvl 2 kbot, air, and advanced nanotowers, and can carry a full squad of infantry kbots.
-Added Valkyrie Mk II Light Infantry Transport for CORE.
-Added HAK Advanced Infantry Kbot for CORE.
-Added Razorback Anti-Air Mech for ARM. It is fast enough to keep up with Raptors, and comes equipped with two high-powered mini-guns that are extremely deadly to low-flying aircraft
-Strategic bombers have much greater hitpoints, but are more expensive and drop less accurate bombs
-Shadows and Thunders now come equipped with tailguns
-Strategic Bombers can fly on top of each other so they don't get in each other's way on bombing runs
-Flak fires slower, but does more damage per shot
-Shadows and Thunders may take critical hits resulting in an engine fire and a premature death
-Shipyard cost reduced 40%
-Destroyers scaled down in size, range, hitpoints; they now cost only about 1300 metal, and are about equal to a group of six or seven hovertanks/hoverartillery
-Attack Sub cost reduced by about 30%
-Torpedoes on anti-sub hovercraft and cruiser now kill subs in two hits
-Stealth fighters can now cloak
-Stealth bombers can also cloak, cost and buildtime increased.
-Vulcan, Buzzsaw, and Nuclear Cannon cost decreased
-Vulcan and Buzzsaw range increased
-Tanks now take more damage from rear or side hits and slightly less from frontal hits
-Nuclear missiles now launch vertically from silos
-Stunner EMP missiles have much more range, can be blocked by anti-nukes
-Nanotower metal cost reduced to 1200; energy and buildtime remain the same
-Nanotower repair rate decreased 50%
-Necro resurrection speed decreased 50%
-Command Center more resistant to bombs
-Napalm bombers do somewhat more damage to buildings and ships
-Kbot lab cost reduced
-Solar Collectors and Geothermals cost less energy
-Maximum Slope for all buildings increased
-Radar Towers now use 20 energy when on
-Fleas have a different laser with more damage but less range
-Flying Fortress buildtime increased
-Reload time on Flying Fortress bombs increased
-Heavy tank buildtime increased
-Stealth bomber buildtime increased
-Transportable turrets are now automatically set to hold position
-Toadfoot now set to loopback attack by default
-Fixed problem with certain units not firing
-Added new model for goliath
-Added LUA widgets: custom formations, buildbar, healthbars, and more


v 1.32

-Zeus, sniper, pyro, morty, fast attack kbots, and crawling bombs are all now built at the level 1 kbot 
 lab, cost and effectiveness adjusted accordingly.
-Missile ship and Rocket truck missiles have a minimum range and are no longer guided, but are more powerful 
 and are not affected by jammers
-Snipers automatically cloak when standing still.
-Crawling bombs can now burrow into the ground.
-Core freaker replaced by the Sprinteur, an armored fast attack kbot
-Arm Pods cost 40% more metal, but can now heal friendly units
-Warriors are now an advanced infantry kbot
-Mobile radar is now level 1
-stealth fighter hitpoints increased
-Removed bladewings
-Removed level 1 radar jammers
-fixed targetting problems on galacticus.

v 1.31

-spring .75 fixes
---fixed airpads
---fixed bombers
---fixed rocket trucks
-Raptor IV's can become crippled if hit by a powerful weapon
-Blade interceptor gun damage increased 30%
-Core interceptor now has a single very powerful laser weapon
-Gala's and Oddities cost less
-Rocket truck reload time decreased
-Amphibious tanks have slightly more range, but do less damage to heavy armor. 
-Sub torpedoes are now guided
-Subs no longer chase land units
-Anti-sub hovercraft doesn't kill itself on land anymore
-Cruiser anti-sub range reduced
-Mavericks no longer anti-armor, autoheal improved
-Cans put in heavy armor class
-Core supergun has a scattershot weapon
-Ship autoheal takes less time to kick in, but is slightly slower
-Nanotower reclaim speed 1/3 of default value
-Bases can't capture anymore
-Nuclear explosions changed to be less laggy
-Collision Spheres on some units adjusted
-Enemy units no longer transportable
-Gauss/railgun projectiles changed
-Some buildpics improved

v 1.30

-New weapon and explosion effects
	-many all new fx
	-animations borrowed out of CA
	-Thank you CA we love you
-Naval combat overhaul:
	-added cruisers and anti-air cruisers
	-destroyers scaled down, made cheaper
	-autoheal on all ships greatly increased
	-ship wreckage now gives only 50% of original cost
	-electronic warfare ships can jam radar
	-subs now have guided anti-sub torpedoes
	-sub torpedo velocity increased
	-Arm missile destroyer cost reduced
	-capital ship energy cost increased
	-seaplane platform 40% cheaper, workertime increased
	-seaplane torpedo turnrate increased, kills subs in one pass
	-sonar plane now built at seaplane platform
	-bertha/intimidator bonus damage to ships eliminated
	-Anti-sub hovercraft faster
- Economy
	-Metal extractor output increased - produces 75% of BA
	-Moho mines cost more, but produce more - 75% of BA
	-Metal maker output increased

-Flying Wing cost increased 35%
-Lvl 2 anti-air and missile tower firepower increased
-Zeus is much cheaper
-Warrior slower, more HP, and cheaper
-Pyro cheaper
-pelican given rockets
-Fast attack bots cost less metal, more E, and higher buildtime
-Krogoth can walk underwater
-Leveler cost increased 5%
-Mobile artillery reload time increased 6%
-anti-ship gun blast radius reduced
-Commander cost majorly reduced
-Heavy laser tower cost decreased
-fighters no longer killed by bomber death explosions
-snipers no longer shoot at air
-core crawling bomb no longer cloakable
-Stealth bomber no longer has flares

-- v1.22

--Seaplane Platforms fixed
--Added Anti-Sub Hovercraft
--Subs smaller, cheaper, and faster
--Dragons teeth smaller, can be built anywere again.
--Sonar can now be built by construction subs + hovers, and is more expensive
--Torpedo Launchers can be built by construction subs + hovers

------v1.21
-Added "Talwar" Amphibious Assault Transport for Core
-Added "Black Lily" Stealth Bomber for Core
-Added Commanders. They are a powerful late game unit that can build defenses anywhere.
-Added "Osprey" Heavy Interceptor for Core.
-Added level 1 mini radar jammers. Their primary purpose is to jam guided ballistic missiles. Regular jammers moved
 back to level 2.
-Added Core truck ground transport/mobile airpad. Built at the advanced vehicle plant.
-New weapon effects for many of the weapons, including plasma weapons, napalm, and nukes.
-Core Dominator Rocket Kbot changed back to a normal artillery role (instead of having guided ballistic missiles).
-Plasma battery cost reduced by 10%
-Rocket kbot firepower increased by 10%
-Hammer/Thud Artillery kbot firepower increased by 10%
-Construction sub repair/reclaim speed reduced
-Seaplane platforms now built on ocean floor
-new unit icons added

----v1.2

-Added seaplanes. They are faster and lighter than normal planes, ideal for hit and run attacks. They can be 
  repaired and refueled at special underwater support stations built by the construction sub.
-Heavy tank balance reworked to prevent late game spamming. They are now more vulnerable to aircraft and anti-armor 
  weapons like rockets, gauss cannons, and high energy lasers.
-Level 2 Vehicle Rocket Launchers now fire long range ballistic missiles similar to those on missile ships. These 
  units are somewhat similar to mobile anti-ship guns in terms of size, cost, and other stats, but have greater 
  range and near-perfect accuracy, making them perfect for picking apart enemy defenses. Like ship missiles, they 
  can be jammed by radar jammers and electronic warfare ships.
-Units with heavy armor (includes heavy tanks, cans, sumos, crabes, etc.) are more resistant to lighter weapons, as 
  well as high-area-of-effect, low damage weapons such as light artillery and plasma cannons.
-Most Kbots are substantially more cost-effective. Changes include:
	-infantry kbot HP increased by 15%
	-rocket kbot damage slightly increased
	-thud/hammer dps increased by 20%
	-anti-air kbot cost decreased
-Sonar ranges on most units including subs, destroyers, and airborne sonar have been decreased.
-Attack subs now have the ability to passively detect moving ships outside of their sonar range. 
-Stealth fighter flare efficiency, reload time improved; they now have a 60% chance of dodging any incoming missiles.
-Arm Spider and Drone now built at the Kbot factory
-Flash given significent firepower increase, especially against light units.
-Moho mines cost less metal, but more energy.
-Metal extractor hitpoints reduced; strategic bombers can now destroy them in one pass.
-Plasma weapons do increased damage to light units and buildings.
-Hellfish cost increased by 15%
-Flying Wing laser damage increased by 20%
-Brawler accuracy, damage to light units increased
-Gunship hitpoints reduced by about 12%
-antinuke effectiveness reduced; launching 3 nukes simultaneously is now enough to get one through.
-Core Black Hydra Battleship damage slightly increased, cost slightly decreased.
-Panther cost decreased by 5%, buildtime decreased greatly (it was much higher than it should have been)
-hovertanks no longer lose accuracy when moving
-air scout radar range reduced
-bladewing cost slightly reduced
-Seahook heavy lifter added for Core level 2 transport
-new unit icons for certain defenses like lrpc's and doomsday machines/annihilators
-planes now land directly on airpads, rather than in the air above them
-various small visual fixes

----v1.11

-added specialized level 2 construction towers- they give a player access to advanced resource 
buildings earlier in the game and one type of level 2 factory of player's choice.
-Arm Panther stealth tanks and Core Reaper heavy tanks now level 1, cost and effectiveness 
adjusted accordingly
-New unit icons for scouts and toadfoot fighter-bombers
-vehicle radar jammers now level 1
-increased toadfoot energy cost, buildtime, rocket weapon fuel usage
-Scout cars faster, better at scouting, laser damage decreased
-bulldog, reaper firepower increased by 20%
-Maverick cost increased, hp slightly lowered
-decreased Monstros Pod range to 1000
-small increase in hovertank hitpoints
-hovercraft artillery are faster
-hovercraft transports can now carry up to 15 units
-increased advanced level 2 constructor cost by 10%
-decreased pop-up cannon cost by 10%
-moho mine cost increased
-removed Core Cougar mech and Arm Pit Viper artillery mech
-core sentry mobile flak now has correct wreckage model
-core battlecruiser wreckage size corrected
-airpad collision spheres fixed
-nanotower build ranges corrected after fix in .74b2
-flying fortress will no longer try to land on repair pads
-Core moho constructor slope tolerance fixed
-some wreckage metal values fixed

-----------------


Introduction to NOTA, by Totbuae

===================================
So, you wanna give NOTA a try, huh?
===================================
This is intended to be an introductory guide to those with an OTA-like background who are willing to give NOTA a try.  Please keep in mind that the N in NOTA means "Not" and it's not just a saying.  NOTA doesn't play much like OTA or any OTA-like mod so some of the strategies/tactics you're used to will not work here.  I'll do my best to explain clearly and briefly how things are different in NOTA so that adapting to this new way of waging war doesn't end up with you becoming a casualty.

=====================================
What the... ?  Where's the commander?
=====================================
In normal NOTA game mode you don't start with a commander, you start with a command building*.  The command building, being a building, is not mobile but it has a long build radius and its build list is roughly equivalent to that of a T1 const KBOT/vehicle/VTOL from OTA plus a few waterborne structures.  Lastly, the command building is moderately armed against both ground and air units which means your early base is adequately protected against small raids (five or less early PeeWees/Flashes aren't going to accomplish much but ten or twenty might if you don't have any other defenses).

* There's a game mode under the mod options tab in the TASClient lobby which allows you to start with the command building and the commander.  Other than that, you can get a commander by building a warp gate from the T3 base expansion tower (more on those later) and warping him in.  This latter one is different from the one you can opt to start with, it has a more extensive build list (it can even build Timmy/Bertha).

===========================================
Ok, ok, so no commander... What next, then?
===========================================
Two solars and two mexes are a good start.  NOTA econ is similar to OTA econ; you've got your solars, mexes*, windgens**, metal makers, geos, floating mexes, floating metal makers, tidals, e-storage and m-storage.  Metal extraction and energy production levels are also similar to OTA (a solar will produce 20e, a geo will produce 250e, metal makers use 60e to produce 0.6m and so forth).  One notable difference from Absolute Annihilation descendants is that there aren't any advanced solars in NOTA, instead you have access to the standard fusion reactor from the start.  NOTA fusions are cheaper and quicker to build but they also produce less energy (only 350e but don't worry, you get better fusions at T2).

* NOTA mexes are a little bit more resistant to damage than OTA mexes.
** NOTA windgens don't chain explode as badly as in AA descendants.

===========================================
Fair enough but econ never won any battles.
===========================================
Or so you say. :P

==========================================================================
Ha, ha, very funny.  What I meant is, should I go KBOTs or vehicles first?
==========================================================================
That question has much deeper ramifications in NOTA than in most other mods.  The reason behind this is that KBOTs and vehicles are much more different than in OTA or any AA descendants.  Like in most other mods, KBOTs can climb steeper hills than vehicles and vehicles are in general faster and tougher than KBOTs.  Unlike most other mods, though, the differences don't stop there.

KBOTs will give you the most bang for the buck if we define bang to mean firepower.  NOTA KBOTs are smaller size-wise than OTA KBOTs which means you can concentrate a lot of firepower in a small area (four PeeWees occupy about as much space as one Stumpy).  KBOTs in general also have excellent self repair (a badly damaged Hammer, for example, can get back to top shape if it stays away from combat for about forty seconds).  The combination of easily affordable firepower and good self repair makes KBOTs very useful for holding ground.  Finally, KBOTs can afford to move around more in combat compared to vehicles (you'll see why on the paragraph about vehicles).

Why on Earth would you want to use vehicles, then?  Simple reason, NOTA KBOTs are V-E-R-Y S-L-O-W*.  Forget about running past defenses with PeeWees and blowing up stuff or using them to catch up to those Flashes that got past your front line, it ain't gonna happen.  KBOTs' slow speed makes them vulnerable to static defenses which outrange them (there are KBOTs which can safely take out statics from range).  Also, slow speed combined with small size makes KBOTs doubly vulnerable to large area of effect weapons such as artillery (what Levelers** do to KBOTs can only be described as obscene) and close air support VTOLs.  Their last drawback is that KBOTs don't have any means to attack high altitude VTOLs (I'll explain later, in the paragraph about aircraft) or ships.  Special infantry transports which can lift twenty Rocko/Hammer sized KBOTs at once were introduced to help mitigate their lack of mobility on large maps.

As stated before, vehicles are on average faster and tougher than KBOTs.  Tanks in particular will take reduced damage from the front compared to the rear and sides.  Because of this, tanks are better used to charge up to defensive lines (of either statics or mobile units) but not past them (which would expose their weaker rear armor).  The vehicle plant also grants access to mobile flak vehicles (flak is the only ground anti-air defense that can shoot at high altitude VTOLs), mobile artillery (T1 arty is mean in NOTA, it outranges statics by a fair amount and has good splash damage) and mobile anti-ship guns (just wait 'till I talk about ships, ok).  All in all, vehicles have better assault options than KBOTs and should be used when you're ready to go knocking on your opponent's door.

* There are fast assault KBOTs (Zipper for Arm and the Core counterpart, the Sprinteurs) which move at about Flash speed.
** Levelers aren't artillery, they're self propelled field guns but they do outrange most KBOTs.

========================================
And just what are "high altitude VTOLs"?
========================================
Glad you asked.  Air power is one of the aspects which most evidently sets NOTA apart from OTA or any AA descendants (another one being navy).  As expected, the VTOLs' greatest asset is their mobility, they're fast and unaffected by terrain.  NOTA VTOLs can be classified in two categories: high and low altitude.

High altitude VTOLs fly too high to be attacked by most ground anti-air defenses*.  T1 strategic bombers (Thunder/Shadow), T2 strategic bombers (Phoenix/Hurricane), T2 stealth bombers (Black Lilly, Core only), T2 high-speed spy planes (Archangel, Arm only), T2 radar planes (Eagle/Vulture) and T3 flying fortresses (Centurion, yes, you guessed it, Core only) are all high altitude.  Against these high flying menaces your best bet are fighters/interceptors and ground flak to a lesser extent.  The remaining VTOLs are low altitude and can be attacked by all ground anti-air units.

While on the subject of VTOLs, the ones in NOTA have fuel which is used up when they move or launch ordnance (the next version of spring is supposed to have separate ammo and fuel).  Due to this, VTOLs cannot remain on station indefinitely and will have to return to base to rearm/refuel.  Air repair pads are available from the start and each T1 aircraft plant has one integrated air repair pad to help get you started.

On a more tactical/strategic note, NOTA VTOLs are evil.  Ground attack aircraft are the bane of all ground units (even anti-air) and can reduce a whole contingent of tanks to scrap metal in mere seconds.  Strategic bombers will give you no-end grief as they take out your factories with near impunity.  If your opponent goes air you have to at least get some fighters up unless you have the resources to invest heavily on ground anti-air (don't forget to get some flak as well).

Now, before you start complaining, ground anti-air is not useless.  It's more of a deterrent, i.e., without it your other ground forces can be pounded by air with impunity, with it you at least make your opponent lose some aircraft for every airstrike.  Ground anti-air also helps your fighters maintain air superiority over the territory you control.

It's not, however, all fun and games in the VTOL camp.  The VOTLs' extra dose of pwnage is balanced by the fact that you don't get construction aircrafts until T2.  Yes, you read that right, there's no construction aircraft in the T1 aircraft plant build list.  The aircraft plant, however, does grant access to air transports which have an added value in NOTA because they can move transportable turrets around.

* A missile tower (Defender/Pulverizer) built on top of a tall enough hill will be able to shoot at high altitude VTOLs if the surrounding terrain is low.

====================================
What's so different about NOTA navy?
====================================
For starters, the 3D models are different.  They look a lot shipier and less like the glorified armed yachts from OTA.  Ships are also armed to the teeth (the "lowly" destroyer has 7 weapons:  two plasma cannons, two flak cannons, two torpedo launchers and an anti-air missile).  Furthermore, ship mounted plasma cannons are artillery cannons, the have very good range and area of effect.  There's also only one shipyard (there's no advanced shipyard) which builds all ships, from the destroyer to the battleship.

Unlike OTA and other mods, ships rule the seas.  While you can hold destroyers and maybe cruisers at bay for a little while through the cunning use hovers, torpedo bombers and anti-ship guns, it's just a matter of time before the bigger ships show up and wreck all your stuff.  Considering this, it's imperative that you get ships of your own if the map has any significant amount of water.  If you decide to forgo ships in such a type of map then it's vital that you find and destroy the opponent's shipyard as soon as possible.

By the way, anti-ship guns (also called coastal defense guns) are a special type of medium range plasma cannon that do extra damage to ships.  There are two versions:  a static one and a mobile one built by the T1 vehicle plant.  These guns are a little bit inaccurate and must achieve direct hits to do any damage (they have a very small area of effect) so they're not very well suited to attack anything smaller than ships.

===================================================================================================
You mentioned something else I wanted to ask about, what was it?... Right, "transportable turrets"?
===================================================================================================
Also unique to NOTA (for the time being) are transportable turrets.  Air transports can move these around and so can hover transports (you can also FPS a unit and push them around, but that only works for minor adjustments).  They're a convenient way to provide support for your mobile units when the front lines start to shift.  You can also try to sneak some into undefended enemy territory to cause some havoc.

There are four types of transportables.  Two are common to both Arm and Core:  transportable light laser turrets and transportable flak turrets.  The other one is exclusive to Arm forces, it's a transportable rocket launcher; the Box-o-Death (tm) spews ballistic rockets non-stop with good range.  The last one is the Core only transportable sabot tower, the Splinter, which fires anti-tank darts.

===========================================================================================
Ah, I see.  Why would I need those, though?  Couldn't I just build regular turrets instead?
===========================================================================================
Base expansion is another aspect where NOTA greatly differs from OTA and any OTA-like mods.  Construction KBOTs/vehicles/VTOLs only have a very basic build list.  They cannot build factories or advanced defenses, they can only build some basic economy buildings (solars, geos, windgens, mexes, metal makers), some basic defenses (transportable LLTs, anti-air machineguns/chainguns, dragon's teeth* and land mines**) and radar.  Construction hovercraft can also build some sea-based versions of those basic structures.

In order to expand, mobile constructors can also build base expansion towers (Level 1 Base constructors) which are unarmed versions of the command building with a little shorter build range and a little less build power but with the same build list.  These are a little pricey and deciding when and where to build one is a very important strategic decision.  The added step of building base expansion towers is the reason why NOTA is called "Mobility Focused Warfare" (your mobile units will see a lot more action than in other mods because your static defenses are unlikely to be in the front lines).

* DTs are smaller in NOTA, they're meant to serve as obstacles for mobile units not as protection for defenses.
** There aren't any dedicated minelayer units in NOTA, construction units double as minelayers.

==========================================================================
Wait, if mobile constructors cannot build factories then how do I tech up?
==========================================================================
The command building and the base expansion towers build two types of constructors which allow you to tech up:  Level 2 Constructors and Advanced Constructors.  Level 2 Constructors come in four varieties:  Kbot, Tank, Air and Def.

The first three (Kbot, Tank and Air) allow you to build the corresponding advanced factory (Adv KBOT Lab, Adv Vehicle Plant and Adv Aircraft Plant).  The defense one gives access to advanced defensive structures:  pop-up plasma cannons (Ambusher/Toaster), BLODs (Annihilator/Doomsday Machine), EMP missile launchers (Stunner, Arm only), nukes (Retaliator/Silencer), LRPCs (Big Bertha/Intimidator), RFLRPCs (Vulcan/Buzzsaw) and long range nuclear cannons (Tabitha/Influence).

All Level 2 Constructors also allow you to upgrade your economy by providing access to Heavy Fusion Reactors, Moho Metal Makers and Moho Engineers (Moho Engineers are really big construction KBOTs which are responsible for building Moho Mines).  To round up the package, all Level 2 Constructors also have access to a small selection of T1 defensive*, utility** and economy*** structures.

The Advanced Constructors build EVERYTHING all of the four Level 2 Constructors can plus NOTA's T3 structures.  At T3 the Core gets the warp gate (warps in the commander****), the Krogoth gantry (I wonder what this might do? :P), the Anti-gravity hangar (builds flying fortresses) and the Pinocchio (I won't ruin the surprise, just build one and see what it does).  Not to be outdone, the Arm also gets the warp gate (there's a little surprise waiting for you here, also) plus the Pod Factory (builds Montros Pods which are the Arm's answer to the Kroggies) and the orbital laser (C&C GDI's Ion Cannon, anyone?).

* LLTs, HLTs, MRPCs, coastal defense guns, missile towers, flak cannons and anti-nukes
** Radar towers and air repair pads
*** T1 fusion reactors
**** You can only have one active commander at a time (if you lose it, you can warp in another one).

================================
This really is nothing like OTA.
================================
I told you so, right from the start.

====================================================
Yeah, I guess you did.  Anything else I should know?
====================================================
Just a few things, actually.  First and foremost is that you CANNOT assist factories in NOTA*.  However, there's little need for that since NOTA factories build faster than their OTA counterparts.  In fact, NOTA factories are so efficient that there's an option to slow them down to 75%, 50% and 25% of their maximum output (you'll see a button which displays "100%" on the left panel when you select a factory, repeatedly clicking it will cycle through the four possible values) so that they don't choke your early economy.

Also gone from NOTA are starburst rockets.  These weapon systems are very limited because they cannot hit moving targets; this has been corrected in NOTA by replacing them with ballistic missiles which can more effectively engage mobile units.

Another thing you'll notice is that in NOTA weapon ranges are a little bit longer than in OTA (for example, the EMG of an OTA PeeWee has a range of ~180, the EMG of a NOTA PeeWee has a range of 255).  On a related note, there aren't any advanced radar towers in NOTA because a NOTA basic radar tower has a radar coverage much larger than a OTA ADVANCED radar tower.  NOTA radars can also detect cloaked units that get too close.

Finally, anti-nukes are T1 in NOTA and they have a rather large umbrella of protection (so now you don't have any excuse for getting nuked unprepared).

* Look at it this way, in most other mods your factory isn't really "ready" until you have around six construction units guarding and assisting it; NOTA completely eliminates this second step (and if you really, really, really need to spam then you can always build more factories).

============
Is that all?
============
Yep, for now at least.  Remember that this is just an introductory guide meant to explain the differences between NOTA and OTA/AA descendants.  I didn't go and wasn't planning to go into any tactics, strategies or unit analysis for NOTA (maybe later, in another document).  There's another guide made by 123v which does offer some pointers about how to play NOTA effectively; it's a good read and you might consider going over that one as well.


-------------------------------------------------------------------


Units from...

- Terror Maps and Units -
- TA Arsenal Network -
- Cypernetic Concept Industries -
- TA Research and Development -
- TA-Power -
- I-TAZ -
- Arm and Core unit Training -
- M3g -
- TA forever -
- Complete Annihilation -
- Mutual Assured Destruction TA -
- Creation Matrix Units -
- Core Prime -
- Shensi Design -
- TA-Designers -

Thanks to Smoth's effects package for the weapon effects used by the osprey interceptor.
Many other FX from Complete Annihilation
Warp effect modified from Evolution RTS's fusion glow effect
Buildpics for all resource buildings, factories, and Core air by Umrug and mTm.

mod by thor and cake. loadscreens by quanto
