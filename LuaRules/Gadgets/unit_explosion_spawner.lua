-- $Id: unit_explosion_spawner.lua 3171 2008-11-06 09:06:29Z det $
function gadget:GetInfo()
	return {
		name = "Unit Explosion Spawner",
		desc = "Spawns units using an explosion as a trigger.",
		author = "KDR_11k (David Becker), lurker",
		date = "2007-11-18",
		license = "None",
		layer = 50,
		enabled = true
	}
end

-- synced only
if (not gadgetHandler:IsSyncedCode()) then
	return false
end

local spawn_defs_id = {}
local projectile_spawn_defs_id = {}
local createProjectileList = {}
local createList = {}
local expireList = {}
local UseUnitResource = Spring.UseUnitResource

function gadget:Initialize()
	local modOptions = Spring.GetModOptions()
		local spawn_defs_name, projectile_spawn_defs_name = VFS.Include("LuaRules/Configs/explosion_spawn_defs.lua")
		for weapon,spawn_def in pairs(spawn_defs_name) do
			if WeaponDefNames[weapon] then
				local weaponID = WeaponDefNames[weapon].id
				if UnitDefNames[spawn_def.name] then
					--Spring.Echo(spawn_def.name)
					spawn_defs_id[weaponID] = spawn_def
					Script.SetWatchWeapon(weaponID, true)
				end
			end
		end
		for weapon,projectile_spawn_def in pairs(projectile_spawn_defs_name) do
			if WeaponDefNames[weapon] then
				local weaponID = WeaponDefNames[weapon].id
				if WeaponDefNames[projectile_spawn_def.name] then
					--Spring.Echo(projectile_spawn_def.name)
					projectile_spawn_defs_id[weaponID] = projectile_spawn_def
					Script.SetWatchWeapon(weaponID, true)
				end
			end
		end

end

function gadget:Explosion(w, x, y, z, owner)
	if spawn_defs_id[w] and owner then
		if UseUnitResource(owner, "m", spawn_defs_id[w].cost) then
			if (spawn_defs_id[w].groundhit == nil) or (spawn_defs_id[w].groundhit >= y - Spring.GetGroundHeight(x,z)) then
				if (spawn_defs_id[w].gaia == 1) then
					table.insert(createList, {name = spawn_defs_id[w].name, owner = owner, x=x,y=y,z=z, expire=spawn_defs_id[w].expire, number = spawn_defs_id[w].number, gaia = 1})
				else
					table.insert(createList, {name = spawn_defs_id[w].name, owner = owner, x=x,y=y,z=z, expire=spawn_defs_id[w].expire, number = spawn_defs_id[w].number, gaia = 0})
				end
			end
			return false
		end
	end
	return false
end

function gadget:GameFrame(f)
	for i,c in pairs(createProjectileList) do
		--local u = Spring.SpawnProjectile(c.name , c.x, c.y, c.z)
		-- it no work :(
		createList[i]=nil
	end
	for i,c in pairs(createList) do
		if (c.number ~= nil) then
			for lol = 1, c.number do
				if (c.gaia == 1) then
					local u = Spring.CreateUnit(c.name , c.x, c.y, c.z, 0, Spring.GetGaiaTeamID(),_,_,_,c.owner)
					Spring.SetUnitNeutral(u, true)
			        	if (c.expire > 0) then 
			      		expireList[u] = f + c.expire * 32
            			end
				else
					local u = Spring.CreateUnit(c.name , c.x, c.y, c.z, 0, Spring.GetUnitTeam(c.owner),_,_,_,c.owner)
			        	if (c.expire > 0) then 
			      		expireList[u] = f + c.expire * 32
            			end
				end
			end
		else
			if (c.gaia == 1) then
				local u = Spring.CreateUnit(c.name , c.x, c.y, c.z, 0, Spring.GetGaiaTeamID(),_,_,_,c.owner)
				Spring.SetUnitNeutral(u, true)
			     	if (c.expire > 0) then 
			     		expireList[u] = f + c.expire * 32
            		end
			else
				local u = Spring.CreateUnit(c.name , c.x, c.y, c.z, 0, Spring.GetUnitTeam(c.owner),_,_,_,c.owner)
			     	if (c.expire > 0) then 
			     		expireList[u] = f + c.expire * 32
            		end
			end
		end
		createList[i]=nil
	end
      if ((f+6)%64<0.1) then 
		for i, e in pairs(expireList) do
			if (f > e) then
				Spring.DestroyUnit(i, true, true)
				expireList[i] = nil
			end
		end
	end
end
