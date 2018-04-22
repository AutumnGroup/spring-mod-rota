--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


local devolution = (-1 > 0)


local morphDefs = {


  armnanotc = {

   {
    into = 'arm2air',
    tech = 0,
    time = 120,
    metal = 500,
    energy = 13000,
   },
   {
    into = 'arm2kbot',
    tech = 0,
    time = 120,
    metal = 500,
    energy = 13000,
   },
   {
    into = 'arm2veh',
    tech = 0,
    time = 120,
    metal = 500,
    energy = 13000,
   },
   {
    into = 'arm2def',
    tech = 0,
    time = 120,
    metal = 500,
    energy = 13000,
   },
  }, 

 corntow = {

   {
    into = 'cor2air',
    tech = 0,
    time = 120,
    metal = 500,
    energy = 13000,
   },
   {
    into = 'cor2kbot',
    tech = 0,
    time = 120,
    metal = 500,
    energy = 13000,
   },
   {
    into = 'cor2veh',
    tech = 0,
    time = 120,
    metal = 500,
    energy = 13000,
   },
   {
    into = 'cor2def',
    tech = 0,
    time = 120,
    metal = 500,
    energy = 13000,
   },
  }, 



}

--
-- Here's an example of why active configuration
-- scripts are better then static TDF files...
--

--
-- devolution, babe  (useful for testing)
--
if (devolution) then
  local devoDefs = {}
  for src,data in pairs(morphDefs) do
    devoDefs[data.into] = { into = src, time = 10, metal = 1, energy = 1 }
  end
  for src,data in pairs(devoDefs) do
    morphDefs[src] = data
  end
end


return morphDefs

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
