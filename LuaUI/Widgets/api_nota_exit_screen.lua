function widget:GetInfo()
	return {
		name      = "Nota Exit Screen",
		desc      = "Need to show end screen when exited from game",
		author    = "a1983",
		date      = "01 04 2013",
		license   = "GPL v2",
		layer     = math.huge,
		handler   = true, -- used widget handlers
		enabled   = true  -- loaded by default
	}
end

local isRegistered
local isShow

local timer = 0.0
local fadeTime = 0.5

local function ShowExitScreen()

	if isRegistered then
		return
	end
	isRegistered = true
	
	local self = widgetHandler:FindWidget("Nota Exit Screen")

	function self:DrawScreen()
		w, h = Spring.GetViewGeometry()

		local ratio = w / h
		local diff43 = math.abs( ratio - 4/3 )
		local diff169 = math.abs( ratio - 16/9 )
		
		if diff43 < diff169 then
			gl.Texture( "LuaUI/Images/black-planet4x3.png" )
		else
			gl.Texture( "LuaUI/Images/black-planet16x9.png" )
		end
		
		if timer > fadeTime then
			timer = fadeTime
			isShow = true
		end
		
		local opacity = timer / fadeTime
		gl.Color( 1, 1, 1, opacity )
		gl.TexRect( 0, 0, w, h, true, false )
		gl.Texture( false )
	end

	widgetHandler.DrawScreenList = { self }
	
	function self:Update( dt )
		timer = timer + dt
		if isShow then
			Spring.SendCommands{ "quit", "quitforce" }
		end
	end
	widgetHandler.UpdateList = { self }
end

function widget:Initialize()
	if not WG.NOTA_UI then
		WG.NOTA_UI = {}
	end
	
	WG.NOTA_UI.ShowExitScreen = ShowExitScreen
end

function widget:Shutdown()
end
