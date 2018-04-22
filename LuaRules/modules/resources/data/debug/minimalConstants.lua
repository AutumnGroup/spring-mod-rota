-- minimal resources constants init if not customized
-- in case constants are properly customized on side of gadget, this is not used

if (constants == nil) then
	Spring.Echo("* [constants] config table was not existing, creating minimal version...")
	constants = {
		["FRAMES_IN_SECOND"] = 30,
		["RESOURCES"] = {
			["TEAM_RES_UPDATE_FREQUENCY"] = 6, -- 6x per second
			["UNIT_RES_UPDATE_FREQUENCY"] = 1, -- 1x per second
		},
	}
	Spring.Echo("* [constants] ... done")
else
	Spring.Echo("* [constants] config table exist")
	if (constants.FRAMES_IN_SECOND == nil) then Spring.Echo("* ... ERROR: constants.FRAMES_IN_SECOND is not specified") end
	if (constants.RESOURCES == nil or constants.RESOURCES.TEAM_RES_UPDATE_FREQUENCY == nil) then Spring.Echo("* ... ERROR: constants.RESOURCES.TEAM_RES_UPDATE_FREQUENCY is not specified") end
	Spring.Echo("* [constants] ... done")
end