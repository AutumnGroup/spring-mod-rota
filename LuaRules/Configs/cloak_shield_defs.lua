-- $Id: cloak_shield_defs.lua 4643 2009-05-22 05:52:27Z carrepairer $
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--Modified by Evil4Zerggin

--
--  Cloak Levels
--
--  0:  disabled
--  1:  conditionally enabled, uses energy
--  2:  conditionally enabled, does no use energy
--  3:  enabled, unless stunned
--  4:  always enabled
--

-- decloakDistance: Units cloaked by the cloaker have this decloakdistance. Use false to use the unit's own decloak distance (typically 0)

local function JammerAlign(defName)
  local ud = UnitDefNames[defName]
  if (ud == nil) then return 0 end
  local jamRad = ud.jammerRadius
  return 64 * math.floor(jamRad / 64)
end

local function GetUnitDecloakDistance(defName)
  local ud = UnitDefNames[defName]
  if (ud == nil) then return 0 end
  local decloakDist = ud.decloakDistance
  return 64 * math.floor(decloakDist / 64)
end

local cloakShieldDefs = {
  darkswarmunit = {
    init = true,
    draw = true,
    energy = 0,
    maxrad = 260,
    growRate = 1024,
    shrinkRate = 1048,
    selfCloak = true,
    decloakDistance = 0,
  },
  weather_snow_storm = {
    init = true,
    draw = true,
    energy = 0,
    maxrad = 1600,
    growRate = 1024,
    shrinkRate = 1048,
    selfCloak = true,
    decloakDistance = 0,
  },
}

local uncloakables = {}

if (Spring.IsDevLuaEnabled()) then
  for name, ud in pairs(UnitDefNames) do
    if (cloakShieldDefs[name] == nil) then
      cloakShieldDefs[name] = {
        init   = false,
        energy = 1024, --v.metalCost / 10,
        draw   = true,
        minrad = 50,
        maxrad = 256,
        growRate = 256,
        shrinkRate = 1024,
        selfCloak = false,
        decloakDistance = false,
        level = 4,
      }
    end
  end
end


return cloakShieldDefs, uncloakables


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
