--
--  file:    cmd_factory_repeat.lua
--

function widget:GetInfo()
	return {
		name 		= "Factory Auto-Repeat",
		desc 		= "Sets new factories to Repeat on automatically",
		author 		= "TheFatController",  -- Owen Martindell
		date 		= "Mar 20, 2007",
		license 	= "GNU GPL, v2 or later",
		layer 		= 0,
		enabled 	= true  --  loaded by default?
	}
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local excludedFactories = {
	["armcsy"] = true,
	["corcsy"] = true,
	["armshltx"] = true,
	["corvalkfac"] = true,
}

function widget:Initialize()
	local _, _, spec = Spring.GetPlayerInfo(Spring.GetMyPlayerID())
	if spec then
		widgetHandler:RemoveWidget()
	return false
	end
end

function widget:UnitCreated(unitID, unitDefID, unitTeam)
	local ud = UnitDefs[unitDefID]
	if (ud and ud.isFactory and (not excludedFactories[ud.name])) then
		Spring.GiveOrderToUnit(unitID, CMD.REPEAT, { 1 }, {})
	end
end

--------------------------------------------------------------------------------
