
--  Custom Options Definition Table format

--  NOTES:
--  - using an enumerated table lets you specify the options order

--
--  These keywords must be lowercase for LuaParser to read them.
--
--  key:      the string used in the script.txt
--  name:     the displayed name
--  desc:     the description (could be used as a tooltip)
--  type:     the option type
--  def:      the default value
--  min:      minimum value for number options
--  max:      maximum value for number options
--  step:     quantization step, aligned to the def value
--  maxlen:   the maximum string length for string options
--  items:    array of item strings for list options
--  scope:    'all', 'player', 'team', 'allyteam'      <<< not supported yet >>>
--

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  Example ModOptions.lua 
--

local options = {
  {
       key="nota",
       name="NOTA Options",
       desc="NOTA Options",
       type="section",
  },
  {
       key="spacebugs",
       name="Spacebug Options",
       desc="Spacebug Options",
       type="section",
  },
  -- {
       -- key="pirates",
       -- name="Pirates Options",
       -- desc="Pirates Options",
       -- type="section",
  -- },
  {
       key="noe",
       name="N.O.E.",
       desc="Not Ordinary Enemies AI Section",
       type="section",
  },
  -- {
       -- key="nota-tv",
       -- name="NOTA TV",
       -- desc="Dots wars record of the match",
       -- type="section",
  -- },
  {
    key    = "mission_name",
    name   = "Mission",
    desc   = "Mission selection",
    type   = "string",
    def    = "none",
    section="nota",
  },
  {
    key="startoptions",
    name="Game Modes",
    desc="Change the game mode",
    type="list",
    def="normal",
    section="nota",
    items={
		{key="normal", name="Normal", desc="Normal game mode"},
		{key="comstart", name="Commander", desc="Start with a Commander"},
		{key="koth", name="King of the Hill", desc="Control the hill for a set amount of time to win"},
		--{key="spacebugs", name="Spacebugs", desc="Bugs from space!"},
		--{key="pirates", name="Pirates", desc="Bloody pirates of Uranus_5!"},
		{key="noe", name="N.O.E. AI debug", desc="AI graphic debug mode for N.O.E. AI."},
    }
  },
  {
    key    = "mo_noshare",
    name   = "No Sharing To Enemies",
    desc   = "Prevents players from giving units or resources to enemies",
    type   = "bool",
    def    = true,
    section= "nota",
  },
  {
    key    = "stupid",
    name   = "Stupid Shit",
    desc   = "Peewee vulcans!  Long Range DGUN cannons!  The Pyro Delivery System!",
    type   = "bool",
    section= "nota",
    def = false,
  },
  {
    key="hilltime",
    name="Hill control time",
    desc="Set how long a team has to control the hill for (in minutes)",
    type="number",
    def=8,
    min=3,
    max=30,
    step=1.0,
    section="nota",
  },
  {
    key    = "mo_queentime",
    name   = "Queen Arrival Time",
    desc   = "In minutes. Queen will spawn after given time.",
    type   = "number",
    def    = 40,
    min    = 1,
    max    = 100,
    step   = 1, -- quantization is aligned to the def value
    section="spacebugs",
  },
  {
    key    = "mo_maxburrows",
    name   = "Max. Burrows",
    desc   = "Maximum number of burrows on map.",
    type   = "number",
    def    = 40,
    min    = 1,
    max    = 60,
    step   = 1, -- quantization is aligned to the def value
    section="spacebugs",
  },
  -- {
    -- key    = "piratetime",
    -- name   = "Korsair arrival time",
    -- desc   = "In minutes. Main Pirate Battleship arrive",
    -- type   = "number",
    -- def    = 40,
    -- min    = 1,
    -- max    = 100,
    -- step   = 1, -- quantization is aligned to the def value
    -- section="pirates",
  -- },
  -- {
    -- key    = "maxships",
    -- name   = "Max. ships",
    -- desc   = "Maximum number of pirate ships on the map",
    -- type   = "number",
    -- def    = 40,
    -- min    = 1,
    -- max    = 60,
    -- step   = 1, -- quantization is aligned to the def value
    -- section="pirates",
  -- },
  {
    key    = "noe_mapping",
    name   = "N.O.E. mapping lenght",
    desc   = "How many times more time will be used for mapping (for bigger maps is needed bigger number)",
    type   = "number",
    def    = 1,
    min    = 0.5,
    max    = 4.0,
    step   = 0.5, -- quantization is aligned to the def value
    section="noe",
  },
  {
    key    = "noe_many_ais_mapping",
    name   = "N.O.E. many AIs mapping split",
    desc   = "If you have many AIs on big map (18x18+), its better to split the mapping into more steps. Otherways, its not needed",
    type   = "bool",
    def    = true,
    section="noe",
  },
  {
    key    = "noe_thinking_split",
    name   = "N.O.E. thinking split",
    desc   = "How much frames are needed for executing the orders (bigger values - eats less CPU work - so use bigger if many AIs in game.. but AI thinks a bit slower)",
    type   = "number",
    def    = 8,
    min    = 4,
    max    = 32,
    step   = 1, -- quantization is aligned to the def value
    section="noe",
  },
  -- {
    -- key    = "tv_online",
    -- name   = "Make record",
    -- desc   = "ON/OFF NOTA TV",
    -- type   = "bool",
    -- def    = false,
    -- section="nota-tv",
  -- },
  -- {
    -- key    = "frame_split",
    -- name   = "Frames split",
    -- desc   = "Every X frames take an info about unit positions (more info = more smooth move of video but slower play)",
    -- type   = "number",
    -- def    = 60,
    -- min    = 30,
    -- max    = 120,
    -- step   = 10, -- quantization is aligned to the def value
    -- section="nota-tv",
  -- },
  -- {
    -- key    = "speedup",
    -- name   = "Video SpeedUp",
    -- desc   = "How much fast the output video should show the match",
    -- type   = "number",
    -- def    = 6,
    -- min    = 2,
    -- max    = 24,
    -- step   = 1, -- quantization is aligned to the def value
    -- section="nota-tv",
  -- },
  -- {
    -- key    = "shift",
    -- name   = "Match info Shift",
    -- desc   = "How many seconds should be shown the info about players and match",
    -- type   = "number",
    -- def    = 7,
    -- min    = 5,
    -- max    = 9,
    -- step   = 1, -- quantization is aligned to the def value
    -- section="nota-tv",
  -- },
}

return options

