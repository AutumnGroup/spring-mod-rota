----- mission side settigns ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

newSideSettings = {
    ["xants"] = {
        ["groups"] = {
		    "betaBuffer",
        },
		["basicTools"] = {
		    {toolPurpose = "basicGroundMex", unitName = "armmex"},
		},
	},
	["mapper"] = {
        ["groups"] = {
		    "solarGuy",
        },
		["basicTools"] = {
		    {toolPurpose = "basicGroundMex", unitName = "armmex"},
		},
	},
}

for i=1,missionInfo.numberOfAnts do
    local thisList = newSideSettings.xants.groups
	newSideSettings.xants.groups[#thisList+1] = "betaWorker" .. i
end