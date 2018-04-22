----- mission spirits settigns ------
----- more about: http://springrts.com/phpbb/viewtopic.php?f=55&t=28259

local spGetUnitPosition	= Spring.GetUnitPosition

newPlan = {
    
}

newSpiritDef = {
    ["tankers"] = function(groupID,teamNumber,mode)
		-- use pathCleanerPlan
		plan.pathCleaner(groupID,teamNumber)
	end,
}