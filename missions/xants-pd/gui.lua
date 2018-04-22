---------------------------------
--- NOE MISSION GRAPHIC STUFF ---
---------------------------------

local DrawGroundCircle = gl.DrawGroundCircle

function MissionStats()
	local mapXdivs     = SYNCED.mapXdivs
	local mapZdivs     = SYNCED.mapZdivs
	local mapDanger    = SYNCED.mapDanger
	local teamInfo     = SYNCED.teamInfo
	local mapDivision  = SYNCED.mapDivision
	for i=0,mapXdivs do
		for j=0,mapZdivs do
			local nummo = i*mapZdivs+j+1
			local color = "red"
			local transp = mapDanger[teamStatsNumber][nummo].antIndex / teamInfo[teamStatsNumber].mapMaxAntIndex
			--- endo of preparations, draw now
			if (transp >= 0.1) then 
				drawSquare(i*mapDivision ,j*mapDivision,transp,color)
			end
		end
	end
end