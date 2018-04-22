function widget:GetInfo()
	return {
	name      = "LoIUI",
	desc      = "LoIUI",
	author    = "Regret",
	date      = "Mar 25, 2009",
	license   = "CC/PD",
	layer     = 9001,
	handler   = true,
	enabled   = false  --  loaded by default?
	}
end

include("Widgets/LolUI/core.lua")

--created Mar 25, 2009
--last change Apr 27, 2009