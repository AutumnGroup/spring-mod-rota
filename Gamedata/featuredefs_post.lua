------------------------------------------------
-- set some mass for features without def.file


for id, fd in pairs(FeatureDefs) do
	fd.mass = fd.mass or 500
	if fd.damage ~= nil then
		fd.damage = fd.damage * 18
	end
end






	