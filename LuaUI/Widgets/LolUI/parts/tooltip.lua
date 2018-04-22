local partinfo = {
	name 	= "Tooltip",
	layer 	= 0,
	framedelay = 4,
}

local function getunitowner(unitID)
	local teamID = Spring.GetUnitTeam(unitID)
	local playerlist = Spring.GetPlayerList(teamID)
	for i=1,#playerlist do
		local owner,_,spectator = Spring.GetPlayerInfo(playerlist[i])
		if (not spectator) then
			return owner
		end
	end
	return ""
end

local function unitinfolines(units)
	local totalhealth,totalmaxhealth = 0,0
	local totalexperience = 0
	local totalmmake,totalmuse,totalemake,totaleuse = 0,0,0,0
	local totalmcost,totalecost = 0,0
	local unitdef,unitid
	local unitscount = #units
	for i=1,unitscount do
		unitid = units[i]
		unitdef = UnitDefs[Spring.GetUnitDefID(unitid)]
		if (unitdef ~= nil) then
			local health,maxhealth = Spring.GetUnitHealth(unitid)
			local experience = Spring.GetUnitExperience(unitid)
			local mmake,muse,emake,euse = Spring.GetUnitResources(unitid)
			local mcost = unitdef.metalCost
			local ecost = unitdef.energyCost
			totalhealth = (health or 0) + totalhealth
			totalmaxhealth = (maxhealth or 0) + totalmaxhealth
			totalexperience = (experience or 0) + totalexperience
			totalmmake = (mmake or 0) + totalmmake
			totalmuse = (muse or 0) + totalmuse
			totalemake = (emake or 0) + totalemake
			totaleuse = (euse or 0) + totaleuse
			totalmcost = (mcost or 0) + totalmcost
			totalecost = (ecost or 0) + totalecost
		end
	end
	totalexperience = totalexperience/unitscount
	totalhealth = string.format("%i", totalhealth)
	totalmaxhealth = string.format("%i", totalmaxhealth)
	totalexperience = string.format("%.2f", totalexperience)
	totalmmake = "\255\1\255\1"..string.format("%.1f", totalmmake)
	totalmuse = "\255\255\1\1"..string.format("%.1f", totalmuse)
	totalemake = "\255\1\255\1"..string.format("%.1f", totalemake)
	totaleuse = "\255\255\1\1"..string.format("%.1f", totaleuse)
	
	local c = "\255\255\255\255"
	
	local lines = {}
	
	if (unitdef ~= nil) then
		lines[1] = "Units   "..unitscount
		lines[2] = "Health   "..totalhealth.." / "..totalmaxhealth
		lines[3] = "Experience   "..totalexperience.."    Cost   "..totalmcost.."m "..totalecost.."e"
		lines[4] = c.."Metal   "..totalmmake..c.." / "..totalmuse..c.."    Energy   "..totalemake..c.." / "..totaleuse
		if (unitscount == 1) then
			local suffix = "'s"
			local owner = getunitowner(unitid)
			if (string.sub(owner,-1,-1) == "s") then
				suffix = "'"
			end
			owner = owner..suffix
			lines[1] = "\255\255\255\1"..owner.." "..c..unitdef.humanName.." - "..unitdef.tooltip
			if (unitdef.maxWeaponRange > 0) then
				lines[3] = lines[3].."    Range   "..unitdef.maxWeaponRange
			end
		end
	end
	
	return lines
end

local function drawtooltiplines(lines,posx,posy,spready,fontsize)
	setAlign(TOP,LEFT)
	setSize(fontsize,fontsize)
	for i=1,4 do
		if (lines[i] ~= nil) then
			setPos(posx,posy+(fontsize+spready)*(i-1))
			drawString(lines[i],true,'o')
		end
	end
end

local function main()
	if (VARS[partinfo.name] ~= true) then
		sSendCommands({"tooltip 0"})
		VARS[partinfo.name] = true
	end
	
	local s = storePartOptions(partinfo.name,{
		fontsize = {
			v = 10,
			minv = 6,
			maxv = 20,
			caption = "Fontsize"
		},
		
		offset = {
			v = 5,
			minv = 2,
			maxv = 20,
			caption = "Offset"
		},
		
		border = {
			v = 1,
			minv = 0,
			maxv = 10,
			caption = "Border"
		},
		
		sizex = {
			v = 400,
			minv = 0,
			maxv = 1280,
			caption = "MinSize"
		},
		
		color_background = {
			id = "special",
			v = {0,0,0,0.3},
			caption = "Color: Background",
		},
		
		color_border = {
			id = "special",
			v = {0,0,0,1},
			caption = "Color: Border",
		},
	})
	
	local fontsize = s.fontsize.v
	local spready = 2
	local offset = s.offset.v
	local border = s.border.v
	local sizex = s.sizex.v
	local sizey = (spready+fontsize)*4
	local color_background = s.color_background.v
	local color_border = s.color_border.v
	
	local posx = 0
	local posy = DRAWBOARDY
	local lines = {}
	

	if (VARS.tooltip_show ~= true) then
		local unitcount = Spring.GetSelectedUnitsCount()
		local pointedobject,pointeddata = Spring.TraceScreenRay(mouseposx,mouseposy,false,true) -- get mouse pointed coordinates
		if (pointedobject ~= nil) then --aiming at something other than sky
			if (pointedobject == "unit") then
				lines = unitinfolines({pointeddata})
				
			elseif (pointedobject == "feature") then
				local RemainingMetal,_,RemainingEnergy = Spring.GetFeatureResources(pointeddata)
				local featurename = FeatureDefs[Spring.GetFeatureDefID(pointeddata)].tooltip
				RemainingMetal = string.format("%i", RemainingMetal)
				RemainingEnergy = string.format("%i", RemainingEnergy)
				lines[1] = featurename
				local c = "\255\1\255\1"
				if (tonumber(RemainingMetal) < 0) then
					c = "\255\255\1\1"
				end
				lines[2] = "\255\255\255\255Metal  "..c..RemainingMetal
				c = "\255\1\255\1"
				if (tonumber(RemainingEnergy) < 0) then
					c = "\255\255\1\1"
				end
				lines[2] = lines[2].."\255\255\255\255    Energy  "..c..RemainingEnergy
				
			elseif (pointedobject == "ground") then
				if (unitcount == 0) then
					local groundposx = pointeddata[1]
					local groundposy = pointeddata[3]
					groundposx = string.format("%i", groundposx)
					groundposy = string.format("%i", groundposy)
					local groundheight  = Spring.GetGroundHeight(groundposx,groundposy)
					local _,groundmetal,groundhardness = Spring.GetGroundInfo(groundposx,groundposy)
					groundmetal = string.format("%.1f", groundmetal)
					groundheight = string.format("%i", groundheight)
					lines[1] = "Pos   "..groundposx.."  "..groundposy.."    Elevation   "..groundheight
					lines[2] = "Hardness   "..groundhardness.."    Metal   "..groundmetal
				else
					lines = unitinfolines(Spring.GetSelectedUnits())
				end
			end
		else
			if (unitcount > 0) then
				lines = unitinfolines(Spring.GetSelectedUnits())
			end
		end
	else
		local tooltiplines = VARS.tooltip_line
		VARS.tooltip_line = nil
		VARS.tooltip_show = false
		if (#tooltiplines == 1) then
			local i = 1
			for oneline in tooltiplines[i]:gmatch("([^\n]*)\n?") do
				lines[i] = oneline
				i = i + 1
			end
		else
			lines = tooltiplines
		end
	end
	
	for i=1,4 do
		if (lines[i] ~= nil) then
			local linesize = getStringWidth(lines[i],fontsize)
			if (linesize > sizex) then
				sizex = linesize
			end
		end
	end
	
	
	local expanded
	expanded,posx,posy = drawExpander(partinfo.name,"Tooltip",fontsize,posx,posy,sizex,sizey,offset,border,true,color_background,color_border,false)
	
	if (expanded) then
		drawtooltiplines(lines,posx,posy,spready,fontsize)
	end
end

local function onunload()
	--[[
	sSendCommands({"tooltip 1"})
	--]]
	VARS[partinfo.name] = false
end

return partinfo,main,onunload