----- mission groups settigns ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

newGroupDef = {
    ["betaBuffer"]    = {size = 1000, unit = "bug2", spirit = "botBuffer", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Hive", dependance = false},
	["solarGuy"]      = {size = 1000, unit = "armsolar", spirit = "building", transfer = 1, status = {0}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Hive", dependance = false},
}

for i=1,missionInfo.numberOfAnts do
    newGroupDef["betaWorker" .. i] = {size = 1, unit = "bug2", spirit = "worker", transfer = 1, status = {0,1,1,1}, preference = {0,0,0,0,0,0,0}, targetClasses = {}, source = "Hive", dependance = false}
end