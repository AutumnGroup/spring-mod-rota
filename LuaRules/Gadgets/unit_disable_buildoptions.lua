-- $Id: unit_disable_buildoptions.lua 4456 2009-04-20 13:23:49Z google frog $
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name	= "Enable / Disable Buildoptions",
		desc	= "Disables wind if wind is too low, units if waterdepth is not appropriate. Allow tech.",
		author	= "quantum",
		date	= "May 11, 2008",
		license = "GNU GPL, v2 or later",
		layer	= 0,
		enabled	= true	-- loaded by default?
	}
end

--------------------------------------------------------------------------------
-- Config
--------------------------------------------------------------------------------

local breakEvenWind = 0.91

--------------------------------------------------------------------------------
-- Work only in synced mode
--------------------------------------------------------------------------------
if( not gadgetHandler:IsSyncedCode() ) then
	return false
end
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Spring speedups
--------------------------------------------------------------------------------

local SPFindUnitCmdDesc =	Spring.FindUnitCmdDesc
local SPEditUnitCmdDesc =	Spring.EditUnitCmdDesc

local SPGetRealBuildQueue =	Spring.GetRealBuildQueue

local SPGetAllUnits =		Spring.GetAllUnits
local SPGetUnitDefId =		Spring.GetUnitDefID
local SPGetUnitAllyTeam =	Spring.GetUnitAllyTeam

--------------------------------------------------------------------------------
-- Local variables
--------------------------------------------------------------------------------
local alwaysDisableTable = {}
local alwaysHideTable    = {}

local techDefinition = {}
local counterDefinition = {}

local techByCounter = {}
local counterByUnit	= {}

local techByBuilder = {}

local counterByAlly	= {}
local buildersById = {}
--------------------------------------------------------------------------------
--========================= HELPERS DECLARATIONS =============================--
--------------------------------------------------------------------------------
local increaseIndex = 1
local decreaseIndex = 2

local UpdateCounters

local UpdateBuilder
local UpdateBuildersByTech

local EnableBuildButtons
local DisableBuildButtons
local HideBuildButtons

local CheckCondition

--------------------------------------------------------------------------------
--============================== GADGET CALLINS ==============================--
--------------------------------------------------------------------------------
function gadget:Initialize()
	
	-- disable wind generators on maps without wind
	local options = Spring.GetModOptions()
	local windMax = tonumber( options and options.maxwind or -1 )
	windMax = ( windMax >= 0 ) and windMax or Game.windMax * 0.1
	
	if( windMax < breakEvenWind ) then
		table.insert( alwaysDisableTable, { UnitDefNames["armwin"].id, "Unit disabled: Wind is too weak on that map.", } )
		table.insert( alwaysDisableTable, { UnitDefNames["corwin"].id, "Unit disabled: Wind is too weak on that map.", } )
	end
	
	local techFile = "LuaRules/Configs/techupgrade_defs.lua"
	if( not VFS.FileExists( techFile ) ) then
		gadgetHandler:RemoveGadget()
		return
	end
	
	-- initialize tech and counter definitions
	local definitions = VFS.Include( techFile )
	
	counterDefinition = definitions.Counters
	for counterName, counterInfo in pairs( counterDefinition ) do
		-- prepare dictionary to access to tech by counter name
		techByCounter[ counterName ] = {}
		
		-- create dictionary to access to counter by tech unit name
		for unitName, _ in pairs( counterInfo ) do
			if( not counterByUnit[ unitName ] ) then
				counterByUnit[ unitName ] = {}
			end
			table.insert( counterByUnit[ unitName ], counterName )
		end
	end
	
	techDefinition = definitions.Techs
	for techName, techInfo in pairs( techDefinition ) do
		-- create dictionary to access to tech by builder unit
		local builders = techInfo.Builders
		for i = 1, #builders do
			local builderName = builders[ i ]
			if( not techByBuilder[ builderName ] ) then
				techByBuilder[ builderName ] = {}
			end
			table.insert( techByBuilder[ builderName ], techName )
		end
		
		-- fill dictionary to access to tech by counter name
		local conditions = techInfo.Conditions
		for counterName, requiredValue in pairs( conditions ) do
			table.insert( techByCounter[ counterName ], techName )			
		end
	end
	
	-- create dictionary of counter value to access current counter value by ally and counter name
	local allyTeamList = Spring.GetAllyTeamList()
	for _, allyId in ipairs( allyTeamList ) do
		counterByAlly[ allyId ] = {}
		for counterName, _ in pairs( counterDefinition ) do
			counterByAlly[ allyId ][ counterName ] = 0
		end
	end
end
--------------------------------------------------------------------------------
function gadget:UnitCreated( unitID, unitDefID, teamID )
	local unitName = UnitDefs[ unitDefID ].name
	local allyTeam = SPGetUnitAllyTeam( unitID )
	
	-- Update buildlist if new builder created
	local isBuilder = techByBuilder[ unitName ]
	if( isBuilder ) then
		buildersById[ unitID ] = { unitName, allyTeam, teamID }
		UpdateBuilder( unitID, unitName, allyTeam )
	end
	
	-- Disable persistent disabled units
	local disableTable = {}
	for unitDefId, tooltip in ipairs( alwaysDisableTable ) do
		disableTable[ unitDefId ] = tooltip
	end
	DisableBuildButtons( unitID, disableTable )
	
	-- Hide persistent hided units
	for _, unitDefId in ipairs( alwaysHideTable ) do
		HideBuildButtons( unitID, unitDefId )
	end	
end
--------------------------------------------------------------------------------
function gadget:UnitFinished( unitID, unitDefID, teamID )
	local unitName = UnitDefs[ unitDefID ].name
	local allyTeam = SPGetUnitAllyTeam( unitID )
	
	-- Tech building built
	if( counterByUnit[ unitName ] ) then
		UpdateCounters( unitName, allyTeam, increaseIndex )
	end
end
--------------------------------------------------------------------------------
function gadget:UnitDestroyed( unitID, unitDefID, teamID )
	local unitName = UnitDefs[ unitDefID ].name
	local allyTeam = SPGetUnitAllyTeam( unitID )

	local isBuilder = techByBuilder[ unitName ]
	if( isBuilder ) then
		buildersById[ unitID ] = nil
	end
	
	-- Tech building destroyed
	if( counterByUnit[ unitName ] ) then
		UpdateCounters( unitName, allyTeam, decreaseIndex )
	end
end
--------------------------------------------------------------------------------
function gadget:UnitGiven( unitID, unitDefID, teamID, fromTeamID )
	-- Given builders also should be checked
	local _, _, _, _, _, fromAllyTeam = Spring.GetTeamInfo( fromTeamID )
	local _, _, _, _, _, toAllyTeam   = Spring.GetTeamInfo( teamID )
	if( fromAllyTeam == toAllyTeam ) then
		return
	end
	
	local unitName = UnitDefs[ unitDefID ].name
	
	if( counterByUnit[ unitName ] ) then
		UpdateCounters( unitName, fromAllyTeam, decreaseIndex )

		-- because when unit will be completed, UnitCreated callins called
		local _, _, _, _, buildProgress = Spring.GetUnitHealth( unitID )
		if( buildProgress == 1 ) then
			UpdateCounters( unitName, toAllyTeam, increaseIndex )
		end
	end
end
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--================================== HELPERS =================================--
--------------------------------------------------------------------------------
UpdateCounters = function( techBuildingName, allyTeam, deltaIndex )

	-- for every counter affected by unit update its value
	local counters = counterByUnit[ techBuildingName ]
	for i = 1, #counters do
		local counterName = counters[ i ]
		
		local delta = counterDefinition[ counterName ][ techBuildingName ][ deltaIndex ]
		counterByAlly[ allyTeam ][ counterName ] = counterByAlly[ allyTeam ][ counterName ] + delta
		
		-- update every tech affected by counter
		UpdateBuildersByTech( techByCounter[ counterName ], allyTeam )
	end
end
--------------------------------------------------------------------------------
UpdateBuildersByTech = function( techs, allyTeam )
	local nameIndex = 1
	local allyIndex  = 2
	local teamIndex  = 3
	
	-- for each teach check all builders
	for i = 1, #techs do
		local techName = techs[ i ]
		local builders = techDefinition[ techName ].Builders

		for unitId, info in pairs( buildersById ) do
			-- if builder exist and in our ally team
			if( info and ( info[ allyIndex ] == allyTeam ) ) then	
				-- and builder one of builders affected by tech
				local unitName = info[ nameIndex ]
				for i = 1, #builders do
					local builderName = builders[ i ]
					if( unitName == builderName ) then
						-- update its build list
						UpdateBuilder( unitId, builderName, allyTeam )
					end
				end
			end
		end
	end
end
--------------------------------------------------------------------------------
UpdateBuilder = function( builderId, builderName, allyTeam )

	local enableTable = {}
	local disableTable = {}

	local techs = techByBuilder[ builderName ]
	-- check conditions for each tech and build list of enabled and disabled units
	for i = 1, #techs do
		local techName = techs[ i ]
		local unitDefId = UnitDefNames[ techDefinition[ techName ].Unit ].id
		if( CheckCondition( techDefinition[ techName ].Conditions, allyTeam ) ) then
			table.insert( enableTable, { unitDefId } )
		else
			table.insert( disableTable, { unitDefId } )
		end
	end
	
	-- update build list
	DisableBuildButtons( builderId, disableTable )
	EnableBuildButtons( builderId, enableTable )
end
--------------------------------------------------------------------------------
CheckCondition = function( conditions, allyTeam )
	for counterName, requiredValue in pairs( conditions ) do
		if( counterByAlly[ allyTeam ][ counterName ] < requiredValue ) then
			return false
		end
	end
	
	return true
end
--------------------------------------------------------------------------------
EnableBuildButtons = function( builderId, enableTable )
	for _, enable in ipairs( enableTable ) do
		local cmdId = SPFindUnitCmdDesc( builderId, -enable[ 1 ] )
		if( cmdId ) then
			local cmdProperties = { disabled = false }
			SPEditUnitCmdDesc( builderId, cmdId, cmdProperties )
		end
	end
end
--------------------------------------------------------------------------------
DisableBuildButtons = function( builderId, disableTable )
	for _, disable in ipairs( disableTable ) do
		-- disable unit building
		local disableUnitDefId = disable[ 1 ]
		local cmdId = SPFindUnitCmdDesc( builderId, -disableUnitDefId )
		if( cmdId ) then
			local cmdProperties = { disabled = true }
			local tooltip = disable[ 2 ]
			if( tooltip ~= nil ) then
				cmdProperties[ "tooltip" ] = tooltip
			end
			SPEditUnitCmdDesc( builderId, cmdId, cmdProperties )
		end
		
		-- cancel ordered disabled units
		local buildQueue = SPGetRealBuildQueue( builderId )
		if( buildQueue ~= nil ) then
			for _, buildOrder in ipairs( buildQueue ) do
				--first key value pair in build rder
				local unitDefID, count = next( buildOrder, nil )
				if( unitDefID == disableUnitDefId ) then
					-- simulate Shift + Ctrl + Right Mouse click ( cancel building of 100 units per click )
					local numberClicks = math.floor( count / 100 ) + 1
					for i = 1, numberClicks do
						Spring.GiveOrderToUnit( builderId, -disableUnitDefId, {}, {"right", "ctrl", "shift",} )
					end
				end
			end
	  	end 
	end
end
--------------------------------------------------------------------------------
HideBuildButtons = function( builderId, hideId )
	local cmdId = SPFindUnitCmdDesc( builderId, -hideId )
	if( cmdId ) then
		local cmdProperties = { hidden = true }
		SPEditUnitCmdDesc( builderId, cmdId, cmdProperties )
	end
end
--------------------------------------------------------------------------------



-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

