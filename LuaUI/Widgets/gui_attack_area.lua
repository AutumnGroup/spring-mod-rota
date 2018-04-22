-- used some code from spring engine and from Attack AoE widget

function widget:GetInfo()
	return {
		name      = "Attack area",
		desc      = "Press meta key, while building tower,\nto see avialable attack area.",
		author    = "a1983",
		date      = "13 01 2013",
		license   = "xxx",
		layer     = 1, 
		enabled   = true  --  loaded by default?
	}
end

----------------------------------------------------------------------------------------------------
--                                     CONSTANTS DECALRATIONS                                     --
----------------------------------------------------------------------------------------------------
local minSpread              = 0 -- weapons with this spread or less are ignored

local GAME_GRAVITY           = Game.gravity
local GAME_SPEED             = 30 -- ..\rts\Sim\Misc\GlobalConstants.h
local GAME_MAP_W, GAME_MAP_H = Game.mapSizeX, Game.mapSizeZ

local SQUARE_SIZE            = 8  -- ..\rts\Sim\Misc\GlobalConstants.h

local X, Y, Z = 1, 2, 3
local CAN_ATTACK = 4

-- CONFIG
local red   = { 1.0, 0.0, 0.0, 0.1 }
local green = { 0.0, 1.0, 0.0, 0.1 }

----------------------------------------------------------------------------------------------------
--                                     FUNCTIONS DECALRATIONS                                     --
----------------------------------------------------------------------------------------------------
local function ToBool                ( value ) end
local function Normalize             ( x, y, z ) end

local function SetupUnitDef          ( unitDefID, unitDef ) end
local function GetWeaponInfo         ( weaponDef, unitDef ) end
local function GetMouseTargetPosition() end

local function GetBallisticAreaMap   ( info, fromX, fromY, fromZ, trajectory ) end

local function GetBallisticVector    ( v, mg,
										flatLen_sq, flatLen, flatX, flatZ,
										maxH, v4, v2mg, mg2,   
										dy,   
										trajectory, 
										rang ) end
								
local function TryBallisticTarget             ( projectileSpeed, mg, quadratic,
										flatLen, 
										flatX, flatY, flatZ,
										fromX, fromY, fromZ ) end

local function GetDirectAreaMap      ( info, fromX, fromY, fromZ ) end
local function TryDirectTarget       ( vX, vY, vZ, flatLen, fromX, fromY, fromZ ) end
										
local function DrawAreaMap  () end
										
----------------------------------------------------------------------------------------------------
--                                     VARIABLES DECALRATIONS                                     --
----------------------------------------------------------------------------------------------------
local aoeDefInfo = {}
local metaPressed = false
local storage = {}
local mapUpdate = 0
local mapListGL

----------------------------------------------------------------------------------------------------
--                                        SPRING SHORTCUTS                                        --
----------------------------------------------------------------------------------------------------
local SpGetActiveCommand =   Spring.GetActiveCommand

local SpGetMouseState =      Spring.GetMouseState
local SpTraceScreenRay =     Spring.TraceScreenRay
local SpGetUnitPosition =    Spring.GetUnitPosition
local SpGetFeaturePosition = Spring.GetFeaturePosition

local SpGetGroundHeight =    Spring.GetGroundHeight

local GL_TRIANGLES =         GL.TRIANGLES
local GL_QUADS =             GL.QUADS
local glDepthTest =          gl.DepthTest
local glBeginEnd =           gl.BeginEnd
local glCreateList =         gl.CreateList
local glCallList =           gl.CallList
local glDeleteList =         gl.DeleteList
local glColor =              gl.Color
local glVertex =             gl.Vertex

----------------------------------------------------------------------------------------------------
--                                         LUA SHORTCUTS                                          --
----------------------------------------------------------------------------------------------------
local max =  math.max
local min =  math.min
local sqrt = math.sqrt


----------------------------------------------------------------------------------------------------
--                                         WIDGET CALLINS                                         --
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
function widget:Initialize()
	for unitDefID, unitDef in pairs( UnitDefs ) do
		SetupUnitDef( unitDefID, unitDef )
	end
end
----------------------------------------------------------------------------------------------------
function widget:Shutdown()
	if( mapListGL ) then
		glDeleteList( mapListGL )
	end
end
----------------------------------------------------------------------------------------------------
function widget:KeyPress( key, mods, isRepeat, label, unicode )
	metaPressed = mods.meta
end
----------------------------------------------------------------------------------------------------
function widget:KeyRelease( key, mods, label, unicode )
	metaPressed = mods.meta
	storage.map = nil
end
----------------------------------------------------------------------------------------------------
function widget:Update()
	if( not metaPressed ) then
		return
	end
	
	if( mapUpdate > 0 ) then
		mapUpdate = 0
	else
		mapUpdate = mapUpdate + 1
		return
	end
	
	local tx, ty, tz = GetMouseTargetPosition()
	if( not tx ) then
		return
	end
	
	local _, cmd, _ = SpGetActiveCommand()
		
	if( not cmd or cmd >= 0 ) then 
		return
	end
	
	-- build command
	local buildUnitDef = UnitDefs[ -cmd ]
	local info = aoeDefInfo[ -cmd ]
	
	--Spring.Echo( buildUnitDef.name, info.type, buildUnitDef.maxHeightDif  )
	if( not info or not buildUnitDef ) then
		return
	end
	
	-- FIX ME find real weapon aim position
	local MAGIC_HEIGHT_CORRECTION = buildUnitDef.height * 0.8
	local fx, fy, fz = tx, ty + MAGIC_HEIGHT_CORRECTION, tz
	local changed = storage.unit ~= -cmd 
		or storage.fx ~= fx or storage.fy ~= fy or storage.fz ~= fz
	
	if( changed or storage.map == nil ) then
		storage = {
			updated = true,
			unit = -cmd, 
			fx = fx, fy = fy, fz = fz }

		if( info.type == "ballistic" ) then		
			storage.map = GetBallisticAreaMap( info, fx, fy, fz, info.trajectory )
					
		elseif( info.type == "direct" ) then
			--fy = ty + buildUnitDef.maxy
			storage.map = GetDirectAreaMap( info, fx, fy, fz, info.trajectory )
			
		end	
	end
end
----------------------------------------------------------------------------------------------------
function widget:DrawWorld()
	if( storage.map ) then
		DrawAreaMap()
	end
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
function Normalize( x, y, z )
	local len = sqrt( x * x + y * y + z * z )
	if( len == 0 ) then
		return nil
	else
		return x / len, y / len, z / len, len
	end
end
----------------------------------------------------------------------------------------------------
function SetupUnitDef( unitDefID, unitDef )
	if( not unitDef.weapons ) then 
		return 
	end
  
	local maxSpread = minSpread
	local maxWeaponDef
  
	for num, weapon in ipairs( unitDef.weapons ) do
		if( weapon.weaponDef ) then
			local weaponDef = WeaponDefs[ weapon.weaponDef ]
			if( weaponDef ) then
                local aoe = weaponDef.damageAreaOfEffect
				
				if( not weaponDef.isShield and not ToBool( weaponDef.interceptor ) ) then
					local currentSpread = weaponDef.range * ( weaponDef.accuracy + weaponDef.sprayAngle )
					if( aoe > maxSpread or currentSpread > maxSpread ) then
						maxSpread = max( aoe, currentSpread )
						maxWeaponDef = weaponDef
					end
				end
			end
		end
	end

	if( maxWeaponDef ) then 
		aoeDefInfo[ unitDefID ] = GetWeaponInfo( maxWeaponDef, unitDef )
	end
end
----------------------------------------------------------------------------------------------------
function GetWeaponInfo( weaponDef, unitDef )

	local result

	local weaponType  = weaponDef.type
	local scatter     = weaponDef.accuracy + weaponDef.sprayAngle
	
	if( weaponDef.cylinderTargeting >= 100 ) then
		result = {
			type = "orbital",
			scatter = scatter }
		
	elseif( weaponType == "Cannon" ) then
		local customParams = weaponDef.customParams

		result = {
			type = "ballistic",
			scatter = scatter, 
			v = weaponDef.projectilespeed,
			range = weaponDef.range,
			mygravity = weaponDef.myGravity or g,
			trajectory = weaponDef.highTrajectory == 0 and 1 or -1 }
		
		local v, mg = result.v, result.mygravity
		result.maxH = v * v / mg
		result.v4   = v * v * v * v
		result.v2mg = 2 * v * v * mg
		result.mg2  = mg * mg
		result.quadratic = 0.5 * mg / ( v * v )
			
	elseif( weaponType == "MissileLauncher" ) then
		local turnRate = weaponDef.tracks and weaponDef.turnRate or 0

		if( weaponDef.wobble > turnRate * 1.4 ) then
			if( weaponDef.customParams.weaponvelocity ) then
				scatter =( weaponDef.wobble - weaponDef.turnRate ) * 
							( weaponDef.customParams.weaponvelocity ) * 16
			else
				scatter =( weaponDef.wobble - weaponDef.turnRate ) * 
							( weaponDef.projectilespeed * GAME_SPEED ) * GAME_SPEED
			end
			local rangeScatter = ( 8 * weaponDef.wobble - weaponDef.turnRate )
			result = {
				type = "wobble",
				scatter = scatter,
				rangeScatter = rangeScatter,
				range = weaponDef.range }
			
		elseif( weaponDef.wobble > turnRate ) then
			if( weaponDef.customParams.weaponvelocity ) then
				scatter = ( weaponDef.wobble - weaponDef.turnRate ) * 
							( weaponDef.customParams.weaponvelocity ) * 16
			else
				scatter = ( weaponDef.wobble - weaponDef.turnRate ) * 
							( weaponDef.projectilespeed * GAME_SPEED ) * 16
			end
			result = {
				type = "wobble", 
				scatter = scatter }
			
		elseif( weaponDef.tracks ) then
			result = {
				type = "tracking" }
			
		else
			result = {
				type = "direct", 
				scatter = scatter, 
				range = weaponDef.range }
			
		end
			
	elseif( weaponType == "AircraftBomb" ) then
		result = {
			type = "dropped",
			scatter = scatter,
			v = unitDef.speed,
			h = unitDef.wantedHeight,
			salvoSize = weaponDef.salvoSize,
			salvoDelay = weaponDef.salvoDelay }
		
	elseif( weaponType == "StarburstLauncher" ) then
		if( weaponDef.tracks ) then
			result = { type = "tracking" }
		else
			result = { type = "cruise" }
		end
		
	elseif( weaponType == "TorpedoLauncher" ) then
		if( weaponDef.tracks ) then
			result = { type = "tracking" }
		else
			result = { type = "direct", scatter = scatter, range = weaponDef.range }
		end
		
	elseif( weaponType == "Flame" or weaponDef.noExplode ) then
		result = {	type = "noexplode", range = weaponDef.range }
	else
		result = {	type = "direct", scatter = scatter,	range = weaponDef.range }
	end
	
	result.aoe         = weaponDef.impactOnly and 0 or weaponDef.damageAreaOfEffect
	result.cost        = unitDef.cost
	result.mobile      = unitDef.speed > 0
	result.waterWeapon = weaponDef.waterWeapon
	result.ee          = weaponDef.edgeEffectiveness
	
	return result
end
----------------------------------------------------------------------------------------------------
function ToBool( value )
	return value and value ~= 0 and value ~= "false"
end
----------------------------------------------------------------------------------------------------
function GetMouseTargetPosition()
	local mx, my = SpGetMouseState()
	local mouseTargetType, mouseTarget = SpTraceScreenRay(mx, my)

	if( mouseTargetType == "ground" ) then
		return mouseTarget[ 1 ], mouseTarget[ 2 ], mouseTarget[ 3 ]
	elseif( mouseTargetType == "unit" ) then
		return SpGetUnitPosition( mouseTarget )
	elseif( mouseTargetType == "feature" ) then
		return SpGetFeaturePosition( mouseTarget )
	else
		return nil
	end
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
-- ballistics
----------------------------------------------------------------------------------------------------
function GetBallisticAreaMap( info, fromX, fromY, fromZ, trajectory )

	local v, mg, range = info.v, info.mygravity, info.range
	local maxH, v4, v2mg, mg2 = info.maxH, info.v4, info.v2mg, info.mg2
	local quadratic = info.quadratic
	
	local r2 = range * range
	
	local step = SQUARE_SIZE * range * 0.004 -- 8 for range 2000
	
	local map = {}
	
	for x = -range, range, step do
		local x2 = x * x
		local tx = x + fromX
		if( tx > 0 and tx < GAME_MAP_W ) then
		
			for z = -range, range, step do
				local tz = z + fromZ
				local flatLen_sq = x2 + z * z
				
				if( flatLen_sq < r2 
					and tz > 0 and tz < GAME_MAP_H ) then			
					
					local ty = SpGetGroundHeight( tx, tz )
					local dy = ty - fromY
					
					local flatLen = sqrt( flatLen_sq )
					local flatX, flatZ = x / flatLen, z / flatLen
					
					local flatY
			  
					local d_sq = flatLen_sq + dy * dy
				  
					if( d_sq > 0 ) then					  
						
						local root1 = v4 - v2mg * dy - mg2 * flatLen_sq
						if( root1 > 0 ) then			  
							
							local root2 = 2 * flatLen_sq * d_sq * ( v * v - mg * dy - trajectory * sqrt( root1 ) )
							if( root2 > 0 ) then							  
								local vr = sqrt( root2 )/( 2 * d_sq )

								local bx = flatX * vr
								local bz = flatZ * vr
								local by = ( vr == 0 ) and v or vr * dy / flatLen + flatLen * mg / ( 2 * vr )

								local len = sqrt( bx * bx + by * by + bz * bz )
								
								flatY = by / len
							end
						end
					end
					
					local canAttack = flatY and TryBallisticTarget( v, mg, quadratic, 
							flatLen, 
							flatX, flatY, flatZ,
							fromX, fromY, fromZ )

					map[ #map + 1 ] = { tx, ty, tz, canAttack }
				end
			end
			
		end
	end
	
	map.step = step
	
	return map
end
----------------------------------------------------------------------------------------------------
function TryBallisticTarget( projectileSpeed, mg, quadratic,
						flatLen, 
						flatX, flatY, flatZ,
						fromX, fromY, fromZ )
	
	local posX, posY, posZ
	
	--local vertices = {}
	for cur = 0, flatLen, SQUARE_SIZE do
		posX, posZ = fromX + flatX * cur, fromZ + flatZ * cur;
		posY = fromY + ( flatY - quadratic * cur ) * cur;

		--if( SpGetSmoothMeshHeight( posX, posZ ) > posY ) then
		if( SpGetGroundHeight( posX, posZ ) > posY ) then
			--glBeginEnd( GL.LINE_STRIP, VertexList, vertices )
			return false
		end
		
		--vertices[ #vertices + 1 ] = { posX, posY, posZ }
	end
	--glBeginEnd( GL.LINE_STRIP, VertexList, vertices )
	
	return true
end
----------------------------------------------------------------------------------------------------
-- direct
----------------------------------------------------------------------------------------------------
--local vertices
function GetDirectAreaMap( info, fromX, fromY, fromZ )
	local range = info.range	
	local r2 = range * range
	
	local step = SQUARE_SIZE * range * 0.004 -- 8 for range 2000
	
	local map = {}
	vertices = {}
	for x = -range, range, step do
		local x2 = x * x
		local tx = x + fromX
		if( tx > 0 and tx < GAME_MAP_W ) then
		
			for z = -range, range, step do
				local tz = z + fromZ
				local flatLen_sq = x2 + z * z
				
				if( flatLen_sq < r2 
					and tz > 0 and tz < GAME_MAP_H ) then			
					
					local ty = SpGetGroundHeight( tx, tz )
					local dy = ty - fromY + 10
					
					local flatLen = sqrt( flatLen_sq )
					local vX, vY, vZ = x / flatLen, dy / flatLen, z / flatLen		
					
					local canAttack = TryDirectTarget( vX, vY, vZ, flatLen, fromX, fromY, fromZ )

					map[ #map + 1 ] = { tx, ty, tz, canAttack }
				end
			end
		end
	end
	
	map.step = step
	
	return map
end

----------------------------------------------------------------------------------------------------
function TryDirectTarget( vX, vY, vZ, flatLen, fromX, fromY, fromZ )
	
	local posX, posY, posZ = fromX, fromY, fromZ
	local vStepX, vStepY, vStepZ = vX * SQUARE_SIZE, vY * SQUARE_SIZE, vZ * SQUARE_SIZE
	
	for i = 1, flatLen, SQUARE_SIZE do
		posX, posY, posZ = posX + vStepX, posY + vStepY, posZ + vStepZ;

		--vertices[ #vertices + 1 ] = { posX, posY, posZ }
		
		if( SpGetGroundHeight( posX, posZ ) > posY ) then
			return false
		end
		
	end
	
	return true
end
----------------------------------------------------------------------------------------------------
-- DRAWING
----------------------------------------------------------------------------------------------------
function DrawAreaMap()
	--[[
	glBeginEnd( GL.LINE_STRIP, function( vertices )
			for i = 1, #vertices do
				glVertex( vertices[ i ][ 1 ], vertices[ i ][ 2 ], vertices[ i ][ 3 ] )
			end
		end, vertices )
	--]]

	local function DrawImpl()
		local map = storage.map
		local step = map.step

		glBeginEnd( GL_QUADS, function( map )
			for i = 1, #map do
				local pos = map[ i ]
				glColor( pos[ CAN_ATTACK ] and green or red )
				local l, r = pos[ X ] - step, pos[ X ] + step
				local b, t = pos[ Z ] - step, pos[ Z ] + step
				local y = pos[ Y ]
				
				glVertex( l, y, b )
				glVertex( l, y, t )
				glVertex( r, y, t )
				glVertex( r, y, b )
			end
		end, map )
	end
	
	if( storage.updated ) then
		if( mapListGL ) then
			glDeleteList( mapListGL )
		end
		
		storage.updated = false
		mapListGL = glCreateList( DrawImpl )
	end
	
	glDepthTest( false )
	
	glCallList( mapListGL )
	
	glDepthTest( true )
end
----------------------------------------------------------------------------------------------------