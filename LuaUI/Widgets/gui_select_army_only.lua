function widget:GetInfo()
	return {
		name      = "Select army only",
		desc      = "If area select is used and if at least 1 non-builder non-building unit in a selection, all builders deselected",
		author    = "PepeAmpere",
		date      = "2nd July, 2013",
		license   = "notAlicense",
		layer     = 2,
		enabled   = true --  loaded by default?
	}
end

local listOfBuilders = {
	"armfark",
	"armcv",
	"armca",
	"armch",
	"armacsub",
	"cornecro",
	"corcv",
	"corca",
	"corch",
	"coracsub",	
}
local listOfCrawlingMines = {
	"armvader",
	"corroach",
}
local nonArmyUnit = {}

local spGetSelectedUnits 		= Spring.GetSelectedUnits
local spGetSelectedUnitsSorted 	= Spring.GetSelectedUnitsSorted
local spSelectUnitArray 		= Spring.SelectUnitArray

function widget:Initialize()
	for i=1,#listOfBuilders do
		nonArmyUnit[listOfBuilders[i]] = true		
	end
	
	for i=1,#listOfCrawlingMines do
		nonArmyUnit[listOfCrawlingMines[i]] = true			
	end	
	
	for i=1,10000 do
		if (UnitDefs[i] == nil) then
			break
		else
			local ud = UnitDefs[i]
			if (ud.isBuilding) then
				nonArmyUnit[ud.name] = true
			end
		end
	end
end

-- function widget:MousePress()
	-- Spring.Echo("Imma pressed!")
	-- return false
-- end

-- function widget:MouseRelease()
	-- Spring.Echo("Imma released!")
	-- return false
-- end

-- function widget:CommandsChanged( id, params, options )
-- end

function widget:SelectionChanged(selectedUnits)
	Spring.Echo("something changed")
	-- local listOfSelectedUnits = spGetSelectedUnits()
	if ((not selectedUnits) or (not selectedUnits[1])) then return end

	local sortedSelection = spGetSelectedUnitsSorted()
	local newSelection = {}
	local newSelectionCounter = 0
	local thisSelectionArmyCounter = 0
	local thisSelectionOtherCounter	= 0		
	
	for k,v in pairs(sortedSelection) do
		local ud = UnitDefs[k]
		local lineOfUnits = v
		local isArmy = true
		
		if (nonArmyUnit[ud.name] == nil) then
			isArmy = false
		end
		
		if (isArmy) then
			thisSelectionArmyCounter = thisSelectionArmyCounter + #lineOfUnits
			for i=1, #lineOfUnits do
				newSelectionCounter = newSelectionCounter + 1
				newSelection[newSelectionCounter] = lineOfUnits[i]
			end
		else
			thisSelectionOtherCounter = thisSelectionOtherCounter + #lineOfUnits
		end
		
	end
	
	if ((thisSelectionArmyCounter > 0) and (thisSelectionOtherCounter > 0)) then
		spSelectUnitArray(newSelection)
	end
	
	return
end



