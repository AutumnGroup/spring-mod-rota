----- mission groups settigns ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

newGroupDef = {
    ["eggs"] = {size = 100, unit = "bugegg", spirit = "noSpirit", transfer = 100, status = {0,0,0,1}, source = "bug", dependance = false},
}

for i=1, missionInfo.numberOfBugs do
	local newName = "sorter" .. i
	newGroupDef[newName] = {size = 1, unit = "corgamma", spirit = "bugTransporter", transfer = 1, status = {0,0,0,1}, source = "bug", dependance = false}
end
