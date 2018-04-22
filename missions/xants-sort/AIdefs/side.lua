----- mission side settigns ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

newSideSettings = {
    ["trasporters"] = {
        ["groups"] = {
		    "sorter1",
        },
		["basicTools"] = {
		    {toolPurpose = "basicGroundMex", unitName = "armmex"},
		},
	},
	["eggs1"] = {
        ["groups"] = {
		    "eggs",
        },
		["basicTools"] = {
		    {toolPurpose = "basicGroundMex", unitName = "armmex"},
		},
	},
	["eggs2"] = {
        ["groups"] = {
		    "eggs",
        },
		["basicTools"] = {
		    {toolPurpose = "basicGroundMex", unitName = "armmex"},
		},
	},
	["eggs3"] = {
        ["groups"] = {
		    "eggs",
        },
		["basicTools"] = {
		    {toolPurpose = "basicGroundMex", unitName = "armmex"},
		},
	},
	["eggs4"] = {
        ["groups"] = {
		    "eggs",
        },
		["basicTools"] = {
		    {toolPurpose = "basicGroundMex", unitName = "armmex"},
		},
	},
}

for i=1, missionInfo.numberOfBugs do
	local newName = "sorter" .. i
	newSideSettings["trasporters"]["groups"][i] = newName
end
