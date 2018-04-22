-- here we:
-- * create unit data structures
-- * init them by reading UnitDefs

-- constant prefixes
prefixes = {
	NAME_CUSTOM_RESOURCE = "name_custom_resource",
	PRICE_CUSTOM_RESOURCE = "price_custom_resource",
	INCOME_UNIT_CUSTOM_RESOURCE = "income_unit_custom_resource",
	INCOME_TEAM_CUSTOM_RESOURCE = "income_team_custom_resource",
	RESOURCE_ADDED_UNIT_CUSTOM_RESOURCE = "resource_added_unit_custom_resource",
	RESOURCE_ADDED_TEAM_CUSTOM_RESOURCE = "resource_added_team_custom_resource",
	RESOURCE_LOST_UNIT_CUSTOM_RESOURCE = "resource_lost_unit_custom_resource",
	RESOURCE_LOST_TEAM_CUSTOM_RESOURCE = "resource_lost_team_custom_resource",
	CONSUMPTION_UNIT_CUSTOM_RESOURCE = "consumption_unit_custom_resource",
	CONSUMPTION_TEAM_CUSTOM_RESOURCE = "consumption_team_custom_resource",
	STORAGE_UNIT_CUSTOM_RESOURCE = "storage_unit_custom_resource",
	STORAGE_TEAM_CUSTOM_RESOURCE = "storage_team_custom_resource",
	TEAM_TO_UNIT_TRANSFER_RATE_CUSTOM_RESOURCE = "team_to_unit_transfer_rate_custom_resource",
	UNIT_TO_TEAM_TRANSFER_RATE_CUSTOM_RESOURCE = "unit_to_team_transfer_rate_custom_resource",
}
valueKeys = {
	NAME_CUSTOM_RESOURCE = "name",
	PRICE_CUSTOM_RESOURCE = "price",
	INCOME_UNIT_CUSTOM_RESOURCE = "incomeUnit",
	INCOME_TEAM_CUSTOM_RESOURCE = "incomeTeam",
	RESOURCE_ADDED_UNIT_CUSTOM_RESOURCE = "resourceAddedUnit",
	RESOURCE_ADDED_TEAM_CUSTOM_RESOURCE = "resourceAddedTeam",
	RESOURCE_LOST_UNIT_CUSTOM_RESOURCE = "resourceLostUnit",
	RESOURCE_LOST_TEAM_CUSTOM_RESOURCE = "resourceLostTeam",
	CONSUMPTION_UNIT_CUSTOM_RESOURCE = "consumptionUnit",
	CONSUMPTION_TEAM_CUSTOM_RESOURCE = "consumptionTeam",
	STORAGE_UNIT_CUSTOM_RESOURCE = "storageUnit",
	STORAGE_TEAM_CUSTOM_RESOURCE = "storageTeam",
	TEAM_TO_UNIT_TRANSFER_RATE_CUSTOM_RESOURCE = "teamToUnitTransferRate",
	UNIT_TO_TEAM_TRANSFER_RATE_CUSTOM_RESOURCE = "unitToTeamTransferRate",
}
valueTypes = {
	NAME_CUSTOM_RESOURCE = "string",
	PRICE_CUSTOM_RESOURCE = "number",
	INCOME_UNIT_CUSTOM_RESOURCE = "number",
	INCOME_TEAM_CUSTOM_RESOURCE = "number",
	RESOURCE_ADDED_UNIT_CUSTOM_RESOURCE = "number",
	RESOURCE_ADDED_TEAM_CUSTOM_RESOURCE = "number",
	RESOURCE_LOST_UNIT_CUSTOM_RESOURCE = "number",
	RESOURCE_LOST_TEAM_CUSTOM_RESOURCE = "number",
	CONSUMPTION_UNIT_CUSTOM_RESOURCE = "number",
	CONSUMPTION_TEAM_CUSTOM_RESOURCE = "number",
	STORAGE_UNIT_CUSTOM_RESOURCE = "number",
	STORAGE_TEAM_CUSTOM_RESOURCE = "number",
	TEAM_TO_UNIT_TRANSFER_RATE_CUSTOM_RESOURCE = "number",
	UNIT_TO_TEAM_TRANSFER_RATE_CUSTOM_RESOURCE = "number",
}

-- GLOBAL STRUCTURES expected in other modules
Spring.Echo("* [unitsInit] creating data structures...")

-- mapping
fromDefIDToNameTable = {} 
fromNameToDefIDTable = {}
fromIDToName = {} -- just unitDef name

-- personal resources of units
unitResourcesData = {}

-- resource defs per unitDef
if (resourcesPerUnitName == nil) then 
	resourcesPerUnitName = {}
	Spring.Echo("* [unitsInit][resourcesPerUnitName] config table was not customized, creating clean new one from UnitDefs...")
else
	Spring.Echo("* [unitsInit][resourcesPerUnitName] config table was customized, updating it from UnitDefs customParams...")
end

-- load resources setup from UnitDefs
for i=1, #UnitDefs do
	local unitName = UnitDefs[i].name
	fromDefIDToNameTable[i] = unitName
	fromNameToDefIDTable[unitName] = i
	
	if (resourcesPerUnitName[unitName] == nil) then -- if there are no data for given unit, create new table
		resourcesPerUnitName[unitName] = {}
	end
	
	local customStuff = UnitDefs[i].customParams
	if (customStuff ~= nil) then
		for c=1, 100 do -- random big number ;), i hate while
			local resourceNameKey = prefixes.NAME_CUSTOM_RESOURCE .. c
			local resourceName = UnitDefs[i].customParams[resourceNameKey]
			if (resourceName ~= nil) then -- only if defined
				local valuesForRes = {}
				for key, name in pairs(prefixes) do
					local valueName = name .. c
					if (UnitDefs[i].customParams[valueName] ~= nil) then  -- map things from definition file to table with custom keys
						if (valueTypes[key] == "number") then
							valuesForRes[valueKeys[key]] = tonumber(UnitDefs[i].customParams[valueName])
						else
							valuesForRes[valueKeys[key]] = UnitDefs[i].customParams[valueName]
						end
					else
						Spring.Echo("CUSTOM RESOURCES WARNING: missing expected customParam [" .. valueName .. "]")
					end
				end
				resourcesPerUnitName[unitName][resourceName] = valuesForRes
				
				-- send message to all listenning gadgets and widgets
				sendCustomMessage.resources_unitDefResourceData(i, resourceName, valuesForRes)
				
				-- init debug
				-- Spring.Echo("Def data for unit [" .. unitName .. "], resource [" .. resourceName .. "]")
				-- for name, value in pairs(valuesForRes) do
					-- Spring.Echo("......", name, value)
				-- end
			else  -- if not defined, we leave the cycle
				break
			end
		end
	end
end

Spring.Echo("* [unitsInit] ... done")
