----------------------------------------------------------------------------------------------------
--                                        TACTICAL SELETION                                       --
--              Widget remember last unit groups getted orders, show them on the map,             --
--                                   and allow fast select them                                   --
----------------------------------------------------------------------------------------------------
function widget:GetInfo()
	return {
		name      = "TacticalSelection",
		desc      = "Tactical Selection Tool",
		author    = "a1983",
		date      = "21 12 2012",
		license   = "xxx",
		layer     = math.huge,
		--handler   = true, -- used widget handlers
		enabled   = true  -- loaded by default
	}
end
----------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------
--                          Shortcut to used global functions to speedup                          --
----------------------------------------------------------------------------------------------------
local glPushMatrix	= gl.PushMatrix
local glPopMatrix	= gl.PopMatrix
local glTranslate	= gl.Translate

local glColor	= gl.Color
local glRect	= gl.Rect
local glTexRect	= gl.TexRect
local glTexture	= gl.Texture
local glText	= gl.Text

local SpGetSelectedUnitsCount	= Spring.GetSelectedUnitsCount
local SpGetSelectedUnits		= Spring.GetSelectedUnits

--local SpGetUnitPosition		= Spring.GetUnitPosition

local SpWorldToScreenCoords		= Spring.WorldToScreenCoords

local SpGetUnitViewPosition		= Spring.GetUnitViewPosition

local SpGetCameraPosition		= Spring.GetCameraPosition

local SpGetUnitDefID			= Spring.GetUnitDefID

local unitDefs					= UnitDefs

local math_ceil = math.ceil

local table_insert = table.insert
local table_remove = table.remove
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
--                                        Local constants                                         --
----------------------------------------------------------------------------------------------------
local minUnitInGroup = 2
local maxGroupCount = 10

local fontSize = 12

local minViewGroupY = 5000

local textureBegin = ":n:LuaUI/Images/TacticalSelect/"

local pressedColor	= { 1.0, 1.0, 1.0, 1.0 }
local hoverColor	= { 1.0, 1.0, 1.0, 0.9 }
local normalColor	= { 1.0, 1.0, 1.0, 0.7 }

local icons = {
	small = {
		size = 24,
		half = 24 / 2,
		distance = ( 24 / 2 ) * ( 24 / 2 ),
		textureBlack = textureBegin .. "circle_black_24.png",
		textureGrey  = textureBegin .. "circle_grey_24.png"
	},
	medium = {
		size = 32,
		half = 32 / 2,
		distance = ( 32/ 2 ) * ( 32 / 2 ),
		textureBlack = textureBegin .. "circle_black_32.png",
		textureGrey  = textureBegin .. "circle_grey_32.png"
	}
}

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
--                                        Local variables                                         --
----------------------------------------------------------------------------------------------------
local mouseHover, mousePress
local currentGroup = 1
local showGroups

local groups = {}
local groupByUnit = {}
local selectedGroup, pressedGroup
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
--                                        Local functions                                         --
----------------------------------------------------------------------------------------------------
local AppendGroup
local RemoveUnitFromGroups
local UpdateGroupIconSize
local GroupEqual
local ExistGroup
local UpdateGroupMarkerPosition

----------------------------------------------------------------------------------------------------
--                                         WIDGET CALLLINS                                        --
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
function widget:CommandNotify( id, params, options )
	if( SpGetSelectedUnitsCount() < minUnitInGroup ) then
		return
	end

	local group = SpGetSelectedUnits()
	if( not ExistGroup( group ) ) then
		-- remove unit, that has speed == 0
		local index = 0
		local normalizedGroup = {}
		for i = 1, #group do
			local unitId = group[ i ]
			local speed = unitDefs[ SpGetUnitDefID( unitId ) ].speed
			if( speed > 0 ) then
				index = index + 1
				normalizedGroup[ index ] = unitId
			end
		end

		if( #normalizedGroup >= minUnitInGroup ) then
			AppendGroup( normalizedGroup )
		end
	end
end

----------------------------------------------------------------------------------------------------
local timer, updateIntervalSec = 0, 0.1
function widget:Update( dt )
	if( timer > updateIntervalSec ) then
		dt = 0

		for i = 1, maxGroupCount do
			UpdateGroupMarkerPosition( groups[ i ] )
		end

		local currentGroup
		local id = ExistGroup( SpGetSelectedUnits() )
		if( id ) then
			currentGroup = groups[ id ]
			currentGroup.selected = true
		end

		if( selectedGroup ) then
			if( currentGroup ~= selectedGroup ) then
				selectedGroup.selected = false
			end
		end

		selectedGroup = currentGroup

		local _, y = SpGetCameraPosition()
		showGroups = y > minViewGroupY
	else
		timer = timer + dt
	end
end

----------------------------------------------------------------------------------------------------
function widget:DrawScreen()
	if not showGroups then
		return
	end

	for i = 1, maxGroupCount do
		local group = groups[ i ]
		if( group ) then
			local icon = group.icon
			local halfIcon = icon.half
			local iconSize = icon.size

			glPushMatrix()
				glTranslate( group.x - halfIcon, group.y - halfIcon, 0 )

				glTexture( group.selected and icon.textureBlack or icon.textureGrey )

				if( group.pressed ) then
					glColor( pressedColor )
				elseif( group.hover ) then
					glColor( hoverColor )
				else
					glColor( normalColor )
				end
				glTexRect( iconSize, iconSize, 0, 0, true, true )
				glTexture( false )

				--glRect( iconSize, iconSize, 0, 0 )

				glColor( group.selected and { 1, 1, 1, 1 } or { 0, 0, 0, 1 } )
				glText( #group, halfIcon, halfIcon, fontSize, "cv" )
			glPopMatrix()
		end
	end
end

----------------------------------------------------------------------------------------------------
function widget:IsAbove( x, y )

	if not showGroups then
		return
	end

	for i = maxGroupCount, 1, -1 do
		local group = groups[ i ]
		if( group ) then
			local dx, dy = group.x - x, group.y - y
			if( ( dx * dx + dy * dy ) < group.distance ) then
				group.hover = true
				return true
			end

			group.hover = false
		end
	end

	return false
end

----------------------------------------------------------------------------------------------------
function widget:MousePress( x, y, mouseButton )

	if not showGroups then
		return
	end

	for i = maxGroupCount, 1, -1 do
		local group = groups[ i ]
		if( group and group.hover ) then
			if( not group.pressed ) then
				group.pressed = true
				pressedGroup = group
			end
			return true
		end
	end

	return false
end

----------------------------------------------------------------------------------------------------
function widget:MouseRelease( x, y, mouseButton )

	if( pressedGroup ) then
		if( selectedGroup ) then
			selectedGroup.selected = false
		end

		selectedGroup = pressedGroup
		selectedGroup.selected = true

		Spring.SelectUnitArray( pressedGroup )
		pressedGroup.pressed = false
	end
end

----------------------------------------------------------------------------------------------------
function widget:UnitDestroyed( unitID )
	RemoveUnitFromGroups( unitID )
end

----------------------------------------------------------------------------------------------------
AppendGroup = function( group )
	if( currentGroup == maxGroupCount ) then
		currentGroup = 1
	else
		currentGroup = currentGroup + 1
	end

	if( selectedGroup ) then
		selectedGroup.selected = false
	end

	group.selected = true
	selectedGroup = group

	-- remove current group units from others groups
	for i = 1, #group do
		local checkUnit = group[ i ]

		RemoveUnitFromGroups( checkUnit )
		groupByUnit[ checkUnit ] = currentGroup
	end

	UpdateGroupIconSize( group )

	UpdateGroupMarkerPosition( group )
	groups[ currentGroup ] = group
end

----------------------------------------------------------------------------------------------------
RemoveUnitFromGroups = function( unitId )
	local index = groupByUnit[ unitId ]
	if( index ) then
		groupByUnit[ unitId ] = nil
		local group = groups[ index ]

		if( group ) then
			if( #group == minUnitInGroup ) then
				groups[ index ] = nil
			else
				for i = 1, #group do
					if( group[ i ] == unitId ) then
						table_remove( group, i )
						UpdateGroupIconSize( group )
						return
					end
				end
			end
		end
	end
end

----------------------------------------------------------------------------------------------------
UpdateGroupIconSize = function( group )

	local unitsCount = #group

	if( unitsCount < 100 ) then
		group.icon = icons.small
	else
		group.icon = icons.medium
	end

	group.distance = group.icon.distance
end

----------------------------------------------------------------------------------------------------
GroupEqual = function( rawGroup, group )
	if( not group ) then
		return false
	end

	if( #rawGroup ~= #group ) then
		return false
	end

	for i = 1, #rawGroup do
		if( rawGroup[ i ] ~= group[ i ] ) then
			return false
		end
	end

	return true
end

----------------------------------------------------------------------------------------------------
ExistGroup = function( rawGroup )
	for i = 1, maxGroupCount do
		if( GroupEqual( rawGroup, groups[ i ] ) ) then
			return i
		end
	end
end

----------------------------------------------------------------------------------------------------
UpdateGroupMarkerPosition = function( group )
	if( group ) then
		local startIndex
		local minX, minY, minZ
		local maxX, maxY, maxZ

		for unitIndex = 1, #group do
			local unitX, unitY, unitZ = SpGetUnitViewPosition( group[ 1 ], true )
			if unitX then
				minX, minY, minZ = unitX, unitY, unitZ
				maxX, maxY, maxZ = unitX, unitY, unitZ
				startIndex = unitIndex
				break
			end
		end

		if not startIndex then
			return
		end

		for unitIndex = startIndex, #group do
			local unitId = group[ unitIndex ]
			if( unitId ) then
				unitX, unitY, unitZ = SpGetUnitViewPosition( unitId, true )

				if( unitX ) then
					if( unitX < minX ) then
						minX = unitX
					elseif( unitX > maxX ) then
						maxX = unitX
					end

					if( unitY < minY ) then
						minY = unitY
					elseif( unitY > maxY ) then
						maxY = unitY
					end

					if( unitZ < minZ ) then
						minZ = unitZ
					elseif( unitZ > maxZ ) then
						maxZ = unitZ
					end
				end
			end
		end

		local screenMinX, screenMinY, screenMaxX, screenMaxY
		screenMinX, screenMinY = SpWorldToScreenCoords( minX, minY, minZ )
		screenMaxX, screenMaxY = SpWorldToScreenCoords( maxX, maxY, maxZ )

		group.x = math_ceil( ( screenMinX + screenMaxX ) / 2 )
		group.y = math_ceil( ( screenMinY + screenMaxY ) / 2 )
	end
end
----------------------------------------------------------------------------------------------------
