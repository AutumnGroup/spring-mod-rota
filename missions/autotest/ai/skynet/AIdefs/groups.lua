----- mission groups settigns ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

newGroupDef = {
	-- tank buffer --
	["workersBuffer"] 	= {size = 100, unit = "bug1", spirit = "bugBuffer", transfer = 1, status = {0,2,4,8}, source = "Veh1", dependance = false},
}

for i=1, 50 do
	newGroupDef["worker"..i] = {size = 2, unit = "bug1", spirit = "worker", transfer = 1, status = {0,0,0,1}, taskName = "WorkAround", targetClasses = {}, source = "Veh1", dependance = false}
end