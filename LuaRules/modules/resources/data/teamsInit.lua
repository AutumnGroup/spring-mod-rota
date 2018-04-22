-- here we:
-- * create team data structures based on number of playing teams
Spring.Echo("* [teamsInit] creating data structures...")

teamResourcesData = {}
teamNameToTeamID = {}
resourcesNameToIndex = {}
resourcesIndexToName = {}

-- create template for each team + make mapping for indexes
for i=1, #resourcesTypes do
	resourcesNameToIndex[resourcesTypes[i].name] = i
	resourcesIndexToName[i] = resourcesTypes[i].name
end

-- create structure where all team custom resources data are stored
teamList = Spring.GetTeamList()
for i=1, #teamList do
	local teamName = GetTeamNameFromID(teamList[i])
	teamResourcesData[teamName] = {}
	teamNameToTeamID[teamName] = teamList[i]
	for r=1, #resourcesTypes do
		teamResourcesData[teamName][r] = {
			storage = resourcesTypes[r].defaultStored,
			storageSize = resourcesTypes[r].defaultStorageSize,
			lastIncome = resourcesTypes[r].defaultIncome,
			lastConsumption = resourcesTypes[r].defaultConsumption,
		}
	end
end

Spring.Echo("* [teamsInit] ... done")
