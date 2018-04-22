GADGET_NAME = "unit_air_fuelWeapons"

function gadget:GetInfo()
	return {
		name 		= GADGET_NAME,
		desc 		= "Control air units weapons fire consuming fuel",
		author 		= "PepeAmpere",
		date 		= "2016/04/03",
		license 	= "notAlicense",
		layer 		= 1,
		enabled 	= true
	}
end

-- synced only
if (not gadgetHandler:IsSyncedCode()) then
	return false
end

-- get madatory module operators
include("LuaRules/modules.lua") -- modules table
include(modules.attach.data.path .. modules.attach.data.head) -- attach lib module

-- get other madatory dependencies
attach.Module(modules, "message")

-- attach message sender config
attach.File("LuaRules/modules/resources/data/api/messageSender.lua") -- source of mode change request message
-- attach custom reciever for our needs
attach.File("LuaRules/modules/resources/config/api/messageReceiverFuelWeaponsGadget.lua") -- functions reacting on received messages

-- short solution
-- !! To Be replaced!, later defined by unit which carries them
local listOfWeaponsNames = {}
local sourceListOfWeaponsNames = {
	"ARMVTOL_MISSILE", -- armfig
	"ARM_HELL_BOMB", -- armhell
	"ARMAIR_TORPEDO", -- armlance, armseap
	"ARMADVBOMB", -- armpnix
	"ARMBOMB", -- armthund
	"ARF_ROCKET", "TOAD_MISSILE", -- armtoad,
	"ARMVTOL_ADVMISSILE", "ARMVTOL_ADVMISSILE2", -- armhawk
	"WING_BOMB", "WING_LASER", -- armwing
	"VTOL_MCANNON", -- blade
	"VTOL_EMG", -- armbrawl
	"SVTOL_MISSILE", "SVTOL_MISSILE2", -- armsfig
	"ARMSEAP_TORPEDO",  -- armseap
	
	"CRF_ROCKET", "CRF_ROCKET2", "CRF_ROCKET3", "CRF_ROCKET4", "CRF_ROCKET5",  -- corevashp
	"CORADVBOMB", -- corhurc
	"CORBOMB", -- corshad
	"CORAIR_TORPEDO", -- cortitan
	"CORVTOL_MISSILE", -- corveng
	"VTOL_ROCKET", "VTOL_ROCKET2", -- corape
	"NAPALM_BOMB", -- corerb
	"GRYP_CANNON", -- corgryp
	"COR_SBOMB", -- corsbomb
	"CORVTOL_ADVMISSILE", "CORVTOL_ADVMISSILE2" -- corvamp
}

for i=1, #sourceListOfWeaponsNames do
	listOfWeaponsNames[string.lower(sourceListOfWeaponsNames[i])] = true
end

fuelWeaponDefs = {}
weaponNameToID = {}
for id, defData in pairs(WeaponDefs) do
	local weaponName = defData.name
	weaponNameToID[weaponName] = id
	if (listOfWeaponsNames[weaponName] ~= nil) then
		Script.SetWatchWeapon(weaponNameToID[weaponName], true)
		local salvoSize = defData.salvoSize
		local projectiles = defData.projectiles
		local beamTime
		if (salvoSize == nil) then salvoSize = 1 end
		if (projectiles == nil) then projectiles = 1 end
		local finalProjectiles = projectiles * salvoSize
		
		if (defData.type  == "BeamLaser") then -- special fix for beam weapons
			beamTime = defData.beamtime -- emmiting "projectile" for needs of our gadget every frame
			if (beamTime == nil) then beamTime = 1 else beamTime = math.ceil(beamTime * 30) end  -- multiply it by number of frames in second
			finalProjectiles = finalProjectiles * beamTime
		end
		Spring.Echo(weaponName, id, defData.type, tonumber(finalProjectiles), tonumber(defData.customParams.custom_resource_consumption_amount1), math.ceil(defData.customParams.custom_resource_consumption_amount1/finalProjectiles), "|" , salvoSize, projectiles, beamTime)
		
		fuelWeaponDefs[weaponName] = {
			projectiles = tonumber(finalProjectiles),
			cost = tonumber(defData.customParams.custom_resource_consumption_amount1), -- superhardcoded :)
			perCall = math.ceil(defData.customParams.custom_resource_consumption_amount1/finalProjectiles),
		}
	end
end

local SpringSetUnitWeaponState = Spring.SetUnitWeaponState
local SpringGetUnitDefID = Spring.GetUnitDefID
local SpringGetProjectileName = Spring.GetProjectileName
local ConsumptionRequest = sendCustomMessage.resources_unitResourceConsumptionRequest
local weaponsSleep = {}

function SetReloadToWeaponsUsingFuel(unitID, unitDefID, reload)
	local weapons = UnitDefs[unitDefID].weapons
	for w=1, #weapons do
		if (listOfWeaponsNames[WeaponDefs[weapons[w].weaponDef].name] ~= nil) then
			SpringSetUnitWeaponState(unitID, w, "reloadState", reload)
		end
	end
end
function LockAllWeaponsUsingFuel(unitID, unitDefID)
	SetReloadToWeaponsUsingFuel(unitID, unitDefID, Spring.GetGameFrame()+999)
end
function UnlockAllWeaponsUsingFuel(unitID, unitDefID)
	SetReloadToWeaponsUsingFuel(unitID, unitDefID, Spring.GetGameFrame())
end

-- PERFORMANCE RISK, has to be optimized later
function gadget:ProjectileCreated(projectileID, projectileOwnerUnitID, projectileDefID)	
	local weaponName = SpringGetProjectileName(projectileID)
	
	-- speedup code
	if (fuelWeaponDefs[weaponName] ~= nil) then
		-- Spring.Echo(fuelWeaponDefs[weaponName].perCall)
		local projectiles = fuelWeaponDefs[weaponName].projectiles
		if (projectiles == 1) then
			ConsumptionRequest(projectileOwnerUnitID, SpringGetUnitDefID(projectileOwnerUnitID), "hydrocarbons", fuelWeaponDefs[weaponName].cost) -- !! hardcoded hydrocarbons
		else -- performance speedup for burst and beam weapons
			local weaponUniqueName = projectileOwnerUnitID .. weaponName
			if (weaponsSleep[weaponUniqueName] == nil or weaponsSleep[weaponUniqueName] == 0) then
				weaponsSleep[weaponUniqueName] = projectiles - 1
			elseif (weaponsSleep[weaponUniqueName] == 1) then -- send refuel message once last projectile spawned
				ConsumptionRequest(projectileOwnerUnitID, SpringGetUnitDefID(projectileOwnerUnitID), "hydrocarbons", fuelWeaponDefs[weaponName].cost)
				weaponsSleep[weaponUniqueName] = weaponsSleep[weaponUniqueName] - 1
			else
				weaponsSleep[weaponUniqueName] = weaponsSleep[weaponUniqueName] - 1 -- one projectile solved
			end
		end
	end

	
	-- no speedup code
	-- if (fuelWeaponDefs[weaponName] ~= nil) then
		-- ConsumptionRequest(projectileOwnerUnitID, SpringGetUnitDefID(projectileOwnerUnitID), "hydrocarbons", fuelWeaponDefs[weaponName].perCall) -- !! hardcoded hydrocarbons
	-- end
end

function gadget:RecvLuaMsg(msg, playerID)
	message.Receive(msg, playerID) -- using messageReceiver data structure
end