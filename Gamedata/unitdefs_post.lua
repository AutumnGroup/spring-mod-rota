--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local modOptions
if (Spring.GetModOptions) then
  modOptions = Spring.GetModOptions()
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--- spring 89.0 hitspheres bug ----
for name, ud in pairs(UnitDefs) do
	ud.collisionvolumetest = 1
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function disableunits(unitlist)
	for name, ud in pairs(UnitDefs) do
	    if (ud.buildoptions) then
	      for _, toremovename in ipairs(unitlist) do
	        for index, unitname in pairs(ud.buildoptions) do
	          if (unitname == toremovename) then
	            table.remove(ud.buildoptions, index)
	          end
	        end
	      end
	    end	
	end
end

local function tobool(val)
  local t = type(val)
  if (t == 'nil') then
    return false
  elseif (t == 'boolean') then
    return val
  elseif (t == 'number') then
    return (val ~= 0)
  elseif (t == 'string') then
    return ((val ~= '0') and (val ~= 'false'))
  end
  return false
end


if (modOptions and tobool(modOptions.stupid)) then
	--Spring.Echo('WHEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE')
	disableunits({"corbuzz", "armvulc", "corint", "armbrtha", "corsupergun"})
	for name, ud in pairs(UnitDefs) do
		local unitname = ud.unitname
	      if unitname == "corcom" then
	      	table.insert(ud.buildoptions, 1, "corint_dgun")
	      end    
		if unitname == "corcom2" then
	      	table.insert(ud.buildoptions, 1, "corint_dgun")
	      end  
		if unitname == "cor2def" then
	      	table.insert(ud.buildoptions, 1, "corint_dgun")
	      end
		if unitname == "cor2def" then
	      	table.insert(ud.buildoptions, 1, "corbuzz_ak")
	      end  
		if unitname == "corlvl2" then
	      	table.insert(ud.buildoptions, 1, "corint_dgun")
	      end
		if unitname == "corlvl2" then
	      	table.insert(ud.buildoptions, 1, "corbuzz_ak")
	      end
		if unitname == "corlvl2" then
	      	table.insert(ud.buildoptions, 1, "corsupergun_pyro")
	      end
	      if unitname == "armcom" then
	      	table.insert(ud.buildoptions, 1, "armbrtha_dgun")
	      end    
		if unitname == "armcom2" then
	      	table.insert(ud.buildoptions, 1, "armbrtha_dgun")
	      end  
		if unitname == "arm2def" then
	      	table.insert(ud.buildoptions, 1, "armbrtha_dgun")
	      end
		if unitname == "arm2def" then
	      	table.insert(ud.buildoptions, 1, "armvulc_pw")
	      end  
		if unitname == "armlvl2" then
	      	table.insert(ud.buildoptions, 1, "armbrtha_dgun")
	      end
		if unitname == "armlvl2" then
	      	table.insert(ud.buildoptions, 1, "armvulc_pw")
	      end
	end
end

if (modOptions.mission_name ~= "none" and modOptions.mission_name ~= nil) then
    local missionPostDefPath = "missions/" .. modOptions.mission_name .. "/mission_unitdefs_post.lua"
	Spring.Echo("Using mission unit defs post edit from file: " .. missionPostDefPath)
    VFS.Include(missionPostDefPath)
	RunMissionPostDefs()
end

	