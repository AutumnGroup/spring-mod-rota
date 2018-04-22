----- mission groups settigns ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

newGroupDef = {
	-- tank buffer --
	["tankBuffer"] 	= {size = 30, unit = "armstump", spirit = "vehBuffer", transfer = 15, status = {0,2,4,8}, source = "Veh1", dependance = false},
	-- tank squad --
	["Tankers1"] 	= {size = 28, unit = "armstump", spirit = "tankers", transfer = 4, status = {6,12,22,26}, taskName = "TankCircuit", targetClasses = {}, source = "Veh1", dependance = false},
}