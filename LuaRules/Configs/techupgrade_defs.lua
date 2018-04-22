--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local TechTree = {
	Techs = {
		ArmAirTech = {
			Builders	= { 'armap', },
			Unit		= 'armpnix',
			Conditions	= { ArmT2AirCounter = 1, }
		},
		ArmKBotTech = {
			Builders	= { 'armlab', },
			Unit		= 'armwar',	
			Conditions	= { ArmT2KbotCounter = 1, }
		},
		ArmVehicleTech	= {
			Builders	= { 'armvp', },
			Unit		= 'armbull',	
			Conditions	= { ArmT2VehCounter = 1, }
		},
		CoreAirTech = {
			Builders	= { 'corap', },
			Unit		= 'corhurc',	
			Conditions	= { CorT2AirCounter = 1, }
		},
		CoreKBotTech = {
			Builders	= { 'corlab', },
			Unit		= 'cormak',	
			Conditions	= { CorT2KbotCounter = 1, }
		},
		CoreVehicleTech = {
			Builders	= { 'corvp', },
			Unit		= 'corfatnk',	
			Conditions	= { CorT2VehCounter = 1, }
		},
		ArmConstructT1Tech = {
			Builders	= { 'armcv', 'armfarc', 'armch' },
			Unit		= 'armnanotc',
			Conditions	= { T1FactoryCounter = 0, } -- counterName1 = requiredValue1, counterName2 = requiredValue2, ...
		},
		CorConstructT1Tech = {
			Builders	= { 'corcv', 'corck', 'corch' },
			Unit		= 'corntow',
			Conditions	= { T1FactoryCounter = 0, } -- counterName1 = requiredValue1, counterName2 = requiredValue2, ...
		},

	},
	Counters = {
		ArmT2AirCounter = {
			counterType = 'unitExist',	-- currently not used
			arm2air = { 1, -1 },		-- techUnit = { whenCreatedAddValue, whenDestroyedAddValue }
			armlvl2 = { 1, -1 },
		},
		ArmT2VehCounter = {
			counterType = 'unitExist',
			arm2veh = { 1, -1 },
			armlvl2 = { 1, -1 },
		},
		ArmT2KbotCounter = {
			counterType = 'unitExist',
			arm2kbot = { 1, -1 },
			armlvl2 =  { 1, -1 },
		},
		CorT2AirCounter = {
			counterType = 'unitExist',
			cor2air = { 1, -1 },
			corlvl2 = { 1, -1 },
		},
		CorT2VehCounter = {
			counterType = 'unitExist',
			cor2veh = { 1, -1 },
			corlvl2 = { 1, -1 },
		},
		CorT2KbotCounter = {
			counterType = 'unitExist',
			cor2kbot = { 1, -1 },
			corlvl2 =  { 1, -1 },
		},
		T1FactoryCounter = {
			counterType = 'unitExist',
			armap	= { 1, 0 },
			armlab	= { 1, 0 },
			armvp	= { 1, 0 },
			armhp	= { 1, 0 },
			armcsy	= { 3, 0 },
			corap	= { 1, 0 },
			corlab	= { 1, 0 },
			corvp	= { 1, 0 },
			corhp	= { 1, 0 },
			corcsy	= { 3, 0 },
		},
		
	}
}

return TechTree

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
