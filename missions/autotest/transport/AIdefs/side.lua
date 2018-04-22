----- mission side settigns ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

newSideSettings = {
    ["Attacker"] = {
        ["groups"] = { 
			"g_armatlas",
			"g_corbrik",
			"g_cmercdrag",
			"g_corbtrans",
			"g_corvalk",
			"g_corvalkii",
			"g_coraat",
			"g_armthovr",
			"g_corthovr",
        },
		["basicTools"] = {
		    {toolPurpose = "basicGroundMex", unitName = "armmex"},
		},
	},
	["Defender"] = {
        ["groups"] = {
		    --"peeweeGroup",
						
			"carrier1",
        },
		["basicTools"] = {
		    {toolPurpose = "basicGroundMex", unitName = "armmex"},
		},
	},
}