-- $Id: icontypes.lua 4585 2009-05-09 11:15:01Z google frog $
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    icontypes.lua
--  brief:   icontypes definitions
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--This file is used by engine, it's just placed here so LuaUI can access it too
--------------------------------------------------------------------------------

local icontypes = {
  default = {
    size=1.3,
    radiusadjust=1,
  },
  
  none = {
    size=0,
    radiusadjust=0,
  },

air = {
		bitmap="icons/air.tga",
		size=1.5,
		radiusadjust=false,
		distance=1,
	},
	airsmall = {
		bitmap="icons/air.tga",
		size=1,--.7
		radiusadjust=false,
		distance=.7,
	},
	airbomb = {
		bitmap="icons/airbomb.tga",
		size=1.5,
		radiusadjust=false,
		distance=1,
	},
	airbombbig = {
		bitmap="icons/airbomb.tga",
		size=2,--1.4
		radiusadjust=false,
		distance=1,
	},
	airhighalt = {
		bitmap="icons/airhighalt.tga",
		size=2.4,
		radiusadjust=false,
		distance=1,
	},
	airbombbigbig = {
		bitmap="icons/airhighalt.tga",
		size=4,
		radiusadjust=false,
		distance=1.7,
	},
	airtorp = {
		bitmap="icons/airtorp.tga",
		size=1.5,
		radiusadjust=false,
		distance=1,
	},
	airnofight = {
		bitmap="icons/airnofight.tga",
		size=1.5,
		radiusadjust=false,
		distance=1,
	},
	airnofightbig = {
		bitmap="icons/airnofight.tga",
		size=2.0,
		radiusadjust=false,
		distance=1,
	},
	airfighterbomber = {
		bitmap="icons/airmix.tga",
		size=1.5,
		radiusadjust=false,
		distance=1,
	},
	aircon = {
		bitmap="icons/conair.tga",
		size=2.0,
		radiusadjust=false,
		distance=1,
	},
	airhighscout = {
		bitmap="icons/pyramideye.tga",
		size=2.0,
		radiusadjust=false,
		distance=1,
	},
	building = {
		bitmap="icons/building.tga",
		size=1.5,
		radiusadjust=false,
		distance=1,
	},
	bigbuilding = {
		bitmap="icons/building.tga",
		size=2,
		radiusadjust=false,
		distance=1,
	},
	kbot = {
		bitmap="icons/kbot.tga",
		size=1,
		radiusadjust=false,
		distance=1,
	},
	kbotmed = {
		bitmap="icons/kbotmed.tga",
		size=1,
		radiusadjust=false,
		distance=1,
	},
	kbotmedzeus = {
		bitmap="icons/kbotmedzeus.tga",
		size=1,
		radiusadjust=false,
		distance=1,
	},
	kbotsmallsupport = {
		bitmap="icons/kbotsmallsupport.tga",
		size=1,
		radiusadjust=false,
		distance=1,
	},
	kbotbig = {
		bitmap="icons/kbotbig.tga",
		size=1.5,
		radiusadjust=false,
		distance=1,
	},
	kbothvy = {
		bitmap="icons/kbothvy.tga",
		size=1.5,
		radiusadjust=false,
		distance=1,
	},
	kbotsumo = {
		bitmap="icons/kbotsumo.tga",
		size=1.5,
		radiusadjust=false,
		distance=1,
	},
	kbotbigsam = {
		bitmap="icons/kbotbigsam.tga",
		size=1.5,
		radiusadjust=false,
		distance=1,
	},
	kbotsupport = {
		bitmap="icons/kbotsupport.tga",
		size=1.5,
		radiusadjust=false,
		distance=1,
	},
	kbotmars = {
		bitmap="icons/kbotmars.tga",
		size=1.5,
		radiusadjust=false,
		distance=1,
	},
	kbotbigstealth = {
		bitmap="icons/kbotbigstealth.tga",
		size=1.5,
		radiusadjust=false,
		distance=1,
	},
	mech = {
		bitmap="icons/mech.tga",
		size=1.5,
		radiusadjust=false,
		distance=1,
	},
	crawlb = {
		bitmap="icons/goesboom.tga",
		size=1.3,
		radiusadjust=false,
		distance=1,
	},
	tank = {
		bitmap="icons/tank.tga",
		size=1.3,
		radiusadjust=false,
		distance=1,
	},
	medtank = {
		bitmap="icons/medtank.tga",
		size=1.3,
		radiusadjust=false,
		distance=1,
	},
	stealthtank = {
		bitmap="icons/stealthtank.tga",
		size=1.3,
		radiusadjust=false,
		distance=1,
	},
	tanksupport = {
		bitmap="icons/tanksupport.tga",
		size=1.3,
		radiusadjust=false,
		distance=1,
	},
	tankarty = {
		bitmap="icons/tanksupport.tga",
		size=1.3,
		radiusadjust=false,
		distance=1,
	},
	heavytank = {
		bitmap="icons/heavytank.tga",
		size=1.5,
		radiusadjust=false,
		distance=1,
	},
	heavytanksupport = {
		bitmap="icons/heavytanksupport.tga",
		size=1.5,
		radiusadjust=false,
		distance=1,
	},
	bigtanksupport = {
		bitmap="icons/tanksupport.tga",
		size=1.75,
		radiusadjust=false,
		distance=1,
	},
	scud = {
		bitmap="icons/scud.tga",
		size=1.75,
		radiusadjust=false,
		distance=1,
	},
	watertank = {
		bitmap="icons/watertank.tga",
		size=1.5,
		radiusadjust=false,
		distance=1,
	},
	hover = {
		bitmap="icons/hover.tga",
		size=1.3,
		radiusadjust=false,
		distance=1,
	},
	hovermed = {
		bitmap="icons/hovermed.tga",
		size=1.3,
		radiusadjust=false,
		distance=1,
	},
	hoversupport = {
		bitmap="icons/hoversupport.tga",
		size=1.3,
		radiusadjust=false,
		distance=1,
	},
	hovertrans = {
		bitmap="icons/hovertrans.tga",
		size=2,
		radiusadjust=false,
		distance=1,
	},
	hoversam = {
		bitmap="icons/hoversam.tga",
		size=1.3,
		radiusadjust=false,
		distance=1,
	},
	hoverkbot = {
		bitmap="icons/hoverkbot.tga",
		size=1.3,
		radiusadjust=false,
		distance=1,
	},
	hoverkbotmed = {
		bitmap="icons/hoverkbotmed.tga",
		size=1.3,
		radiusadjust=false,
		distance=1,
	},
	antiair = {
		bitmap="icons/antiair.tga",
		size=1.1,
		radiusadjust=false,
		distance=1,
	},
	antiairbig = {
		bitmap="icons/antiair.tga",
		size=2,
		radiusadjust=false,
		distance=1,
	},
	radar = {
		bitmap="icons/radar.tga",
		size=1.5,
		radiusadjust=false,
		distance=1,
	},
	sonar = {
		bitmap="icons/sonar.tga",
		size=1.5,
		radiusadjust=false,
		distance=1,
	},
	construction = {
		bitmap="icons/construction.tga",
		size=1.5,
		radiusadjust=false,
		distance=1,
	},
	bigconstruction = {
		bitmap="icons/construction.tga",
		size=2.2,--1.5
		radiusadjust=false,
		distance=1.0,
	},
	mohoconstruction = {
		bitmap="icons/concircle.tga",
		size=2.2,--1.5
		radiusadjust=false,
		distance=1.0,
	},
	krogoth = {
		bitmap="icons/krogoth.tga",
		size=3,
		radiusadjust=false,
		distance=1.6,
	},
	pod = {
		bitmap="icons/pod.tga",
		size=3,
		radiusadjust=false,
		distance=1.4,
	},
	mblade = {
		bitmap="icons/mblade.tga",
		size=3,
		radiusadjust=false,
		distance=1.7,
	},
	destroyer = {
		bitmap="icons/ship.tga",
		size=3,
		radiusadjust=false,
		distance=1.7,
	},
	destroyer2 = {
		bitmap="icons/ship2.tga",
		size=3.2,
		radiusadjust=false,
		distance=1.7,
	},
	battlecruiser = {
		bitmap="icons/bcrus.tga",
		size=4,
		radiusadjust=false,
		distance=1.7,
	},
	corebattlecruiser = {
		bitmap="icons/corbcrus.tga",
		size=4,
		radiusadjust=false,
		distance=1.7,
	},
	cruiser = {
		bitmap="icons/crus.tga",
		size=3.5,
		radiusadjust=false,
		distance=1.7,
	},
	coraacrus = {
		bitmap="icons/coraacrus.tga",
		size=3.5,
		radiusadjust=false,
		distance=1.7,
	},
	armaacrus = {
		bitmap="icons/armaacrus.tga",
		size=3.5,
		radiusadjust=false,
		distance=1.7,
	},
	aat = {
		bitmap="icons/aat.tga",
		size=3,
		radiusadjust=false,
		distance=1.7,
	},
	sub = {
		bitmap="icons/sub.tga",
		size=3,
		radiusadjust=false,
		distance=1.3,
	},
	ewar = {
		bitmap="icons/ewar.tga",
		size=3,
		radiusadjust=false,
		distance=1.7,
	},
	mcrus = {
		bitmap="icons/mcrus.tga",
		size=3,
		radiusadjust=false,
		distance=1.7,
	},
	corhmcrus = {
		bitmap="icons/corhmcrus.tga",
		size=4,
		radiusadjust=false,
		distance=1.7,
	},
	seadragon = {
		bitmap="icons/seadragon.tga",
		size=4,
		radiusadjust=false,
		distance=2,
	},
	blackhy = {
		bitmap="icons/blackhy.tga",
		size=5,
		radiusadjust=false,
		distance=2,
	},
	carrier = {
		bitmap="icons/carrier.tga",
		size=3.9,
		radiusadjust=false,
		distance=2,
	},
	mgun = {
		bitmap="icons/mgun.tga",
		size=1,--.7
		radiusadjust=false,
		distance=.7,
	},
	star = {
		bitmap="icons/star.tga",
		size=2,
		radiusadjust=false,
		distance=1,
	},
	bigstar = {
		bitmap="icons/star.tga",
		size=3.3,
		radiusadjust=false,
		distance=1.4,
	},
	mine = {
		bitmap="icons/mine.tga",
		size=.6,
		radiusadjust=false,
		distance=.7,
	},
	nukemine = {
		bitmap="icons/nuke.tga",
		size=1.5,
		radiusadjust=false,
		distance=.7,
	},
	tower = {
		bitmap="icons/tower.tga",
		size=1.5,
		radiusadjust=false,
		distance=1,
	},
	torpedo = {
		bitmap="icons/torpedoL.tga",
		size=1.5,
		radiusadjust=false,
		distance=1,
	},
	flak = {
		bitmap="icons/flak.tga",
		size=1.5,
		radiusadjust=false,
		distance=1,
	},
	jammer = {
		bitmap="icons/jam.tga",
		size=1.5,
		radiusadjust=false,
		distance=1,
	},
	mex = {
		bitmap="icons/mex.tga",
		size=1.2,
		radiusadjust=false,
		distance=1,
	},
	moho = {
		bitmap="icons/mex.tga",
		size=1.7,
		radiusadjust=false,
		distance=1,
	},
	power = {
		bitmap="icons/power.tga",
		size=1.7,
		radiusadjust=false,
		distance=1,
	},
	mmakrsmall = {
		bitmap="icons/mmakr.tga",
		size=1.3,
		radiusadjust=false,
		distance=1,
	},
	mmakrbig = {
		bitmap="icons/mmakr.tga",
		size=1.7,
		radiusadjust=false,
		distance=1,
	},
	factory = {
		bitmap="icons/factory.tga",
		size=1.7,
		radiusadjust=false,
		distance=1,
	},
	nano1 = {
		bitmap="icons/nano1.tga",
		size=1.7,
		radiusadjust=false,
		distance=1,
	},
	nano2small = {
		bitmap="icons/nano2.tga",
		size=1.7,
		radiusadjust=false,
		distance=1,
	},
	nano2 = {
		bitmap="icons/nano2.tga",
		size=2,
		radiusadjust=false,
		distance=1.3,
	},
	landpad = {
		bitmap="icons/landpad.tga",
		size=1.5,
		radiusadjust=false,
		distance=1,
	},
	antinuke = {
		bitmap="icons/antinuke.tga",
		size=1.7,
		radiusadjust=false,
		distance=1,
	},
	nuke = {
		bitmap="icons/nuke.tga",
		size=3,
		radiusadjust=false,
		distance=1,
	},
	armbase = {
		bitmap="icons/armbase.tga",
		size=4,
		radiusadjust=false,
		distance=2,
	},
	corbase = {
		bitmap="icons/corbase.tga",
		size=4,
		radiusadjust=false,
		distance=2,
	},
	scout = {
		bitmap="icons/eye.tga",
		size=1.3,
		radiusadjust=false,
		distance=.7,
	},
	armcom = {
		bitmap="icons/arm_commander.tga",
		size=2,
		radiusadjust=false,
		distance=1,
	},
	corcom = {
		bitmap="icons/core_commander.tga",
		size=2,
		radiusadjust=false,
		distance=1,
	},
	plasmagun = {
		bitmap="icons/plasmagun.tga",
		size=2,
		radiusadjust=false,
		distance=1,
	},
	longgun = {
		bitmap="icons/longgun.tga",
		size=2,
		radiusadjust=false,
		distance=1,
	},
	lrpc = {
		bitmap="icons/lrpc.tga",
		size=2,
		radiusadjust=false,
		distance=1,
	},
	starbuild = {
		bitmap="icons/starbuild.tga",
		size=2,
		radiusadjust=false,
		distance=1,
	},
	empbuild = {
		bitmap="icons/empbuild.tga",
		size=2,
		radiusadjust=false,
		distance=1,
	},
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

return icontypes

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

