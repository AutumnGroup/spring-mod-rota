----- mission side settigns ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

local newGroups = {}
for i=1, 50 do
	newGroups[#newGroups + 1] = "worker"..i
end

newSideSettings = {
    ["HumanInsect"] = {
        ["groups"] = newGroups,
		["basicTools"] = {
		    {toolPurpose = "basicGroundMex", unitName = "armmex"},
		},
	},
}