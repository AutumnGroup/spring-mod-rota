-- we do this all for "resourcesPerUnitName" table which exist in a file where from is this procedure included
-- this is fuel specific solution, as trasfer solution between completelly customized resource and engine supported fuel

PAD_STORAGE = 500
AIRFIELD_STORAGE_MULT = 4
ARM_CARRIER_STORAGE_MULT = AIRFIELD_STORAGE_MULT * 2
CORE_CARRIER_STORAGE_MULT = AIRFIELD_STORAGE_MULT * 3

FUEL_INCOME_UNIT = 6
CARRIER_INCOME_MULT = 2

SMALL_ADD_MULT = 0.25
BIG_ADD_MULT = 0.25

AIRPAD_TRANSFER_RATE = 20
AIRFIELD_PAD_TRANSFER_RATE = 30
CARRIER_PAD_TRANSFER_RATE = 25

-- for pre-load
if (resourcesPerUnitName == nil) then resourcesPerUnitName = {} end

-- specific for fuel (hydrocarbons)
for i=1, #UnitDefs do
	local unitName = UnitDefs[i].name
	local fuel = UnitDefs[i].maxFuel
	if (resourcesPerUnitName[unitName] == nil) then resourcesPerUnitName[unitName] = {} end
	
	-- airplanes 
	-- !valid for Spring 100.0 and older
	if (fuel ~= nil and fuel > 0) then
		resourcesPerUnitName[unitName]["hydrocarbons"] = {
			name = "hydrocarbons",
			price = 0,
			incomeUnit = 0,
			incomeTeam = 0,
			resourceAddedUnit = 0,
			resourceAddedTeam = 0,
			resourceLostUnit = 0,
			resourceLostTeam = 0,
			consumptionUnit = 1,
			consumptionTeam = 0,
			storageUnit = fuel,
			storageTeam = 0,
			teamToUnitTransferRate = AIRPLANE_RECEIVE_RATE,
			unitToTeamTransferRate = AIRPLANE_RECEIVE_RATE,
		}
	end
	-- static pads + mobile pad + uwpad
	if (unitName == "armasp" or unitName == "corasp" or unitName == "armarspd" or unitName == "armuwasp" or unitName == "coruwasp") then
		resourcesPerUnitName[unitName]["hydrocarbons"] = {
			name = "hydrocarbons",
			price = 0,
			incomeUnit = 0,
			incomeTeam = 0,
			resourceAddedUnit = 0,
			resourceAddedTeam = math.floor(PAD_STORAGE * SMALL_ADD_MULT),
			resourceLostUnit = 0,
			resourceLostTeam = 0,
			consumptionUnit = 0,
			consumptionTeam = 0,
			storageUnit = 0,
			storageTeam = PAD_STORAGE,
			teamToUnitTransferRate = AIRPAD_TRANSFER_RATE,
			unitToTeamTransferRate = AIRPAD_TRANSFER_RATE,
		}
	end
	-- airfields
	if (unitName == "armap" or unitName == "corap") then
		resourcesPerUnitName[unitName]["hydrocarbons"] = {
			name = "hydrocarbons",
			price = 0,
			incomeUnit = 0,
			incomeTeam = FUEL_INCOME_UNIT,
			resourceAddedUnit = 0,
			resourceAddedTeam = math.floor(PAD_STORAGE * AIRFIELD_STORAGE_MULT * BIG_ADD_MULT),
			resourceLostUnit = 0,
			resourceLostTeam = 0,
			consumptionUnit = 0,
			consumptionTeam = 0,
			storageUnit = 0,
			storageTeam = PAD_STORAGE * AIRFIELD_STORAGE_MULT,
			teamToUnitTransferRate = AIRFIELD_PAD_TRANSFER_RATE,
			unitToTeamTransferRate = AIRFIELD_PAD_TRANSFER_RATE,
		}
	end
	-- carriers
	if (unitName == "armcarry") then
		resourcesPerUnitName[unitName]["hydrocarbons"] = {
			name = "hydrocarbons",
			price = 0,
			incomeUnit = 0,
			incomeTeam = FUEL_INCOME_UNIT * CARRIER_INCOME_MULT,
			resourceAddedUnit = 0,
			resourceAddedTeam = math.floor(PAD_STORAGE * ARM_CARRIER_STORAGE_MULT * SMALL_ADD_MULT),
			resourceLostUnit = 0,
			resourceLostTeam = 0,
			consumptionUnit = 0,
			consumptionTeam = 0,
			storageUnit = 0,
			storageTeam = PAD_STORAGE * ARM_CARRIER_STORAGE_MULT,
			teamToUnitTransferRate = CARRIER_PAD_TRANSFER_RATE,
			unitToTeamTransferRate = CARRIER_PAD_TRANSFER_RATE,
		}
	end
	if (unitName == "corcarry") then
		resourcesPerUnitName[unitName]["hydrocarbons"] = {
			name = "hydrocarbons",
			price = 0,
			incomeUnit = 0,
			incomeTeam = FUEL_INCOME_UNIT * CARRIER_INCOME_MULT,
			resourceAddedUnit = 0,
			resourceAddedTeam = math.floor(PAD_STORAGE * CORE_CARRIER_STORAGE_MULT * SMALL_ADD_MULT),
			resourceLostUnit = 0,
			resourceLostTeam = 0,
			consumptionUnit = 0,
			consumptionTeam = 0,
			storageUnit = 0,
			storageTeam = PAD_STORAGE * CORE_CARRIER_STORAGE_MULT,
			teamToUnitTransferRate = CARRIER_PAD_TRANSFER_RATE,
			unitToTeamTransferRate = CARRIER_PAD_TRANSFER_RATE,
		}
	end
	-- other ships
	if (unitName == "coraat" or unitName == "corcrus") then
		resourcesPerUnitName[unitName]["hydrocarbons"] = {
			name = "hydrocarbons",
			price = 0,
			incomeUnit = 0,
			incomeTeam = 0,
			resourceAddedUnit = 0,
			resourceAddedTeam = 0,
			resourceLostUnit = 0,
			resourceLostTeam = 0,
			consumptionUnit = 0,
			consumptionTeam = 0,
			storageUnit = 0,
			storageTeam = PAD_STORAGE * 2,
			teamToUnitTransferRate = AIRPAD_TRANSFER_RATE,
			unitToTeamTransferRate = AIRPAD_TRANSFER_RATE,
		}
	end
end