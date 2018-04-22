--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "projectile_jammer",
    desc      = "True guided missiles deflector",
    author    = "PepeAmpere",
    date      = "Nov 20, 2013",
    license   = "notAlicense",
    layer     = 0,
    enabled   = false  --  loaded by default?
  }
end

if (gadgetHandler:IsSyncedCode()) then

	local deflectorUnits = {}
	local deflectorWeapons = {}

	-- local deflectorUnitNames = {
		-- ["corff"] = 1,
	-- }
	-- local deflectorWeaponsNames = {
		-- ["guidedmissilejammer"] = 1,
	-- }

	function gadget:AllowWeaponInterceptTarget(interceptorUnitID, interceptorWeaponID, targetProjectileID)
		Spring.Echo("i would like to try it")
	end
	
	-- function gadget:ProjectileCreated(proID, proOwnerID, weaponDefID)
		-- Spring.Echo("Yes, i was created")
	-- end 

	-- function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
		-- local ud = UnitDefs[unitDefID]
		-- if(deflectorUnitNames[ud.name] ~= nil) then
			-- deflectorUnits[#deflectorUnits + 1] = unitID
		-- end
	-- end

	function gadget:Initialize()    
		-- for id,unitDef in pairs(UnitDefs) do
			-- local uName = unitDef.name
			-- if (uName == "corff") then
				-- flyingFortUnitDefID = unitDef.id
			-- end
		-- end
		for id,weaponDef in pairs(WeaponDefs) do
			local wName = weaponDef.name
			if (wName == "amd_rocket") then
				--Spring.Echo("yeah")
				--Script.GetWatchWeapon(weaponDef.id)
				Script.SetWatchWeapon(weaponDef.id,true)
			end
		end
	end

end