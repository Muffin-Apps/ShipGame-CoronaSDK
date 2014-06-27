module(..., package.seeall )

function new(  )
	-- body
	local widget = require( "widget" )
	local localGroup = display.newGroup( )

	--function Listener
	local function startEvent( event )
		-- body
		if (event.phase == "ended" or event.phase == "cancelled") then
    		director:changeScene("juego")   	
       	end
	end
	
	--object display
	local background = display.newImageRect( imgDir.."background.jpg", 1280, 800 )
	background.x = display.contentCenterX ; background.y = display.contentCenterY
	localGroup:insert( background )

	local start = widget.newButton{
		width = 500,
        height = 130,
		x = display.contentCenterX,
		y = display.contentCenterY,
		id = "start",
		defaultFile = imgDir.. "button.png",
    	label = "Iniciar Partida",
    	labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 210 } },
    	fontSize = 30,
    	onEvent = startEvent
	}
	localGroup:insert(start)

	return localGroup
end