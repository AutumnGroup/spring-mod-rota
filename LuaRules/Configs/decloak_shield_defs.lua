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
  armseer = {
    init   = true,
    draw   = true,
    energy = 3,
    maxrad = 900,
    growRate   = 51,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 800,
    piece="dish",
  },
  armmark = {
    init   = true,
    draw   = true,
    energy = 3,
    maxrad = 900,
    growRate   = 51,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 800,
    piece="head",
  },
  armrad = {
    init   = true,
    draw   = true,
    energy = 5,
    maxrad = 1000,
    growRate   = 51,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 900,
    piece="dish",
  },
  armawac = {
    init   = true,
    draw   = true,
    energy = 5,
    maxrad = 1100,
    growRate   = 51,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 1000,
    piece="radar",
  },
  corvrad = {
    init   = true,
    draw   = true,
    energy = 3,
    maxrad = 900,
    growRate   = 51,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 800,
    piece="dish",
  },
  corvoyr = {
    init   = true,
    draw   = true,
    energy = 3,
    maxrad = 900,
    growRate   = 52,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 800,
    piece="dish1",
  },
  corrad = {
    init   = true,
    draw   = true,
    energy = 5,
    maxrad = 1000,
    growRate   = 52,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 900,
    piece="dish",
  },
  corawac = {
    init   = true,
    draw   = true,
    energy = 5,
    maxrad = 1100,
    growRate   = 52,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 1000,
    piece="radar",
  },
  armexcal = {
    init   = true,
    draw   = true,
    energy = 3,
    maxrad = 625,
    growRate   = 52,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 575,
    piece="radar",
  },
  armexcal2 = {
    init   = true,
    draw   = true,
    energy = 3,
    maxrad = 625,
    growRate   = 52,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 575,
    piece="radar",
  },
  armmcrus = {
    init   = true,
    draw   = true,
    energy = 3,
    maxrad = 625,
    growRate   = 52,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 575,
    piece="radar",
  },
  armcrus = {
    init   = true,
    draw   = true,
    energy = 3,
    maxrad = 625,
    growRate   = 52,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 575,
    piece="radar",
  },
  armaacrus = {
    init   = true,
    draw   = true,
    energy = 3,
    maxrad = 625,
    growRate   = 52,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 575,
    piece="radar",
  },
  armbcrus = {
    init   = true,
    draw   = true,
    energy = 3,
    maxrad = 625,
    growRate   = 52,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 575,
    piece="radar2",
  },
  armewar = {
    init   = true,
    draw   = true,
    energy = 5,
    maxrad = 1000,
    growRate   = 52,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 900,
    piece="radar",
  },
  armcarry = {
    init   = true,
    draw   = true,
    energy = 3,
    maxrad = 625,
    growRate   = 52,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 575,
    piece="radar",
  },
  aseadragon = {
    init   = true,
    draw   = true,
    energy = 3,
    maxrad = 625,
    growRate   = 52,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 575,
    piece="radar",
  },
  cordest = {
    init   = true,
    draw   = true,
    energy = 3,
    maxrad = 625,
    growRate   = 52,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 575,
    piece="radar",
  },
  cormblade = {
    init   = true,
    draw   = true,
    energy = 3,
    maxrad = 500,
    growRate   = 52,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 500,
    piece="radar",
  },
  corcrus = {
    init   = true,
    draw   = true,
    energy = 3,
    maxrad = 625,
    growRate   = 52,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 575,
    piece="radar",
  },
  coraacrus = {
    init   = true,
    draw   = true,
    energy = 3,
    maxrad = 625,
    growRate   = 52,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 575,
    piece="radar",
  },
  corhmcrus = {
    init   = true,
    draw   = true,
    energy = 3,
    maxrad = 625,
    growRate   = 52,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 575,
    piece="str2",
  },
  corcarry = {
    init   = true,
    draw   = true,
    energy = 3,
    maxrad = 625,
    growRate   = 52,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 575,
    piece="radar",
  },
  corewar = {
    init   = true,
    draw   = true,
    energy = 5,
    maxrad = 1000,
    growRate   = 52,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 900,
    piece="radar",
  },
  corbcrus = {
    init   = true,
    draw   = true,
    energy = 3,
    maxrad = 625,
    growRate   = 52,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 575,
    piece="radar",
  },
  corblackhy = {
    init   = true,
    draw   = true,
    energy = 3,
    maxrad = 625,
    growRate   = 52,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 575,
    piece="radar",
  },
  armpod = {
    init   = true,
    draw   = true,
    energy = 3,
    maxrad = 375,
    growRate   = 52,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 350,
    piece="radar",
  },
  corhorg = {
    init   = true,
    draw   = true,
    energy = 3,
    maxrad = 600,
    growRate   = 52,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 680,
    piece="radar",
  },
  armanni = {
    init   = true,
    draw   = true,
    energy = 3,
    maxrad = 450,
    growRate   = 52,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 400,
    piece="radar",
  },
  armcom = {
    init   = true,
    draw   = true,
    energy = 3,
    maxrad = 500,
    growRate   = 52,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 500,
    piece="head",
  },
  corcom = {
    init   = true,
    draw   = true,
    energy = 3,
    maxrad = 500,
    growRate   = 52,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 500,
    piece="head",
  },
  armcom2 = {
    init   = true,
    draw   = true,
    energy = 3,
    maxrad = 500,
    growRate   = 52,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 500,
    piece="head",
  },
  corcom2 = {
    init   = true,
    draw   = true,
    energy = 3,
    maxrad = 500,
    growRate   = 52,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 500,
    piece="head",
  }, 
  armbcom = {
    init   = true,
    draw   = true,
    energy = 3,
    maxrad = 400,
    growRate   = 52,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 400,
    piece="head",
  },
  wormy = {
    init   = true,
    draw   = true,
    energy = 3,
    maxrad = 1800,
    growRate   = 512,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 550,
  },
  cormonsta = {
    init   = true,
    draw   = true,
    energy = 3,
    maxrad = 750,
    growRate   = 512,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 750,
    piece="radar",
  },
  cormonstaq = {
    init   = true,
    draw   = true,
    energy = 3,
    maxrad = 800,
    growRate   = 512,
    shrinkRate = 2048,
    selfCloak = false,
    decloakDistance = 800,
    piece="radar",
  },
}


local uncloakables = {
}


--[[
for k,v in pairs(UnitDefNames) do
  if (v.isBuilding) then
    uncloakables[k] = true
  end
end
--]]


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
