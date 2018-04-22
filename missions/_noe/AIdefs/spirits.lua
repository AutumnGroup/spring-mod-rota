--------------------------------------------------------------
-- notAtree v.0061-0004-0012
--------------------------------------------------------------

if (not moduleInfo) then moduleInfo = {} end
moduleInfo = {
	dataType	= "notAtree",
	author		= "PepeAmpere",
	created		= "unknown",
	description = "testTree",
	version 	= "0061-0004-0012",
	license 	= "notAlicense",  -- http://nota.machys.net/
}

include "missions/_noe/AIdefs/functions/test.lua" 

newPlan = {} 

newSpiritDef = {
	["killer"] = function(groupID, teamNumber, mode, taskLevel)
		-- this is killer, root of the function

        -- INIT
		if (AreEnemyAround(groupID, 1000)) then
		-- is enemy around me? => Yes
			local posX, posY, posZ = GetEnemyPosition(groupID)
			Move(groupID, posX, posY, posZ)
		else
		-- is enemy around me? => No
			return
		end
	end,
	["fight"] = function(groupID, teamNumber, mode, taskLevel)
		-- this is fight, root of the function

        -- INIT
		-- this root has no child node
	end,
}


