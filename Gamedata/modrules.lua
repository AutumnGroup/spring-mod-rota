local modrules  = {
	-- experience = {
		-- experienceMult = 0,
		-- healthScale = 0,
	-- },
	fireAtDead = {
		fireAtKilled = true,
		fireAtCrashing = true,
    },
	featureLOS = {
	    featureVisibility = 2,
	},
	-- flankingBonus set at given units in nota
	-- flankingBonus = {
		-- defaultMode = 0,
	-- },
	movement = {
		allowPushingEnemyUnits = true, -- default false
		allowUnitCollisionDamage = true, -- default false
	},
	paralyze = {
		paralyzeOnMaxHealth = false,
	},
	reclaim = {
		multiReclaim = 1, -- default 0
	    reclaimMethod = 0, -- default 1
		unitMethod = 8, -- default 1
	},
	-- repair = {
		-- energyCostFactor = 0.5,
	-- },
	sensors = {   
		los = {
			losMipLevel = 2, 
			losMul = 1,
			airMipLevel = 4,
			airMul = 1,
			radarMipLevel = 2,
		},
	},
	system = {
		pathFinderSystem = 0,
		-- pathFinderUpdateRate = 0.0000002,
	},
	transportability = {
		transportGround = true, -- default true
		transportHover = false, -- default false
		transportShip = false, -- defaults false
		transportAir = false, -- default false
		targetableTransportedUnits = true, -- default false
	},
}

return modrules