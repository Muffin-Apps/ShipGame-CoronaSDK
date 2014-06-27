module(..., package.seeall )

function new(  )
	-- body
	local widget = require( "widget" )

	math.randomseed( system.getTimer( ) )

	-- Groups
	local localGroup = display.newGroup( )
	local backgroundGroup = display.newGroup( )
	local enemiesGroup = display.newGroup( )

	-- Layers
	local background
	local middleBackground
	local beforeBackground
	local hideMiddleBackground
	local hideBeforeBackground
	local spritePlayer
	local enemy
	local timerEnemy

	-- state var
	local speedMiddleBackground = 1
	local speedBeforeBackground = 4
	local lowerLimit = display.contentCenterX-display.contentWidth
	local upperLimit = display.contentCenterX+display.contentWidth
	local posInic = { X = 0, Y = 0 }
	local radius = 23.5

	--function Listener
	local function moveImage( event )
		-- body
		local speed

		for i=1,backgroundGroup.numChildren do
			if (backgroundGroup[i].name ~= "player") then
				if (backgroundGroup[i].name == "middle") then
					speed = speedMiddleBackground
				else 
					speed = speedBeforeBackground
				end

				backgroundGroup[i].x = backgroundGroup[i].x - speed;

				if(backgroundGroup[i].x < lowerLimit) then
					backgroundGroup[i].x = upperLimit
				end
			end
		end
		return true
	end

	local function endGame(  )
		-- body
		Runtime:removeEventListener( "enterFrame", moveImage )
		transition.cancel( )

		timer.cancel( timerEnemy )

		local rectangle = display.newRoundedRect( display.contentCenterX, display.contentCenterY, 500, 300, 10 )
		rectangle:setFillColor( 0.8 )
		rectangle.alpha = 0.8
		localGroup:insert( rectangle )

		local textEnd = display.newText( "Fin del juego", display.contentCenterX, display.contentCenterY-100, native.systemFontBold, 50 )
        textEnd:setFillColor( 20, 0, 0 )

		
		local function goMenu( event )
			-- body
			if event.phase == "ended" or event.phase == "cancelled" then
				display.getCurrentStage():setFocus(nil)
				director:changeScene("menuPrincipal")
			end
		end

		local finalize = widget.newButton{
			width = 300,
        	height = 130,
    		defaultFile = imgDir.."button.png",
    		label = "Menu Principal",
    		labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 210 } },
    		fontSize = 25,
    		onEvent = goMenu
		}

		finalize.x = display.contentCenterX
		finalize.y = display.contentCenterY+20
		localGroup:insert( finalize )
		--display.getCurrentStage():setFocus(finalize)
	end

	local function explosion( index )
		-- body

		transition.cancel( enemiesGroup[index] )

		local options = {
   			width = 133.5,
   			height = 134,
   			numFrames = 11
		}
	
		local sheet = graphics.newImageSheet( imgDir.."explosion.png", options )
		local sequenceData = { name = "explosion", start=1, count=11, time=1000, loopCount=1, loopDirection = "forward" }
		local spriteExplosion = display.newSprite( sheet, sequenceData )
	
		spriteExplosion.x = enemiesGroup[index].x
		spriteExplosion.y = enemiesGroup[index].y
		spriteExplosion:play( )
		localGroup:insert( spriteExplosion )

		enemiesGroup[index]:removeSelf( )
		enemiesGroup[index] = nil

		endGame()
	end

	local function checkCollision()
		for i=1,enemiesGroup.numChildren do
			if (enemiesGroup[i]) then
				local dx = spritePlayer.x - enemiesGroup[i].x
      			local dy = spritePlayer.y - enemiesGroup[i].y

      			distance = math.sqrt( dx*dx + dy*dy )
      			objectSize = spritePlayer.contentWidth/2 + enemiesGroup[i].contentWidth/2

      			if ( distance < objectSize ) then
      				explosion(i)
      			end
			end
		end
	end

	local function playerControl( event )
		-- body
		local dx 
		local dy

		if (event.phase == "began") then
			display.getCurrentStage():setFocus(event.target)

			posInic.X = event.x
			posInic.Y = event.y
		elseif (event.phase == "moved") then

			dx = event.x - posInic.X
			dy = event.y - posInic.Y

			spritePlayer:translate( dx, dy )

			checkCollision()

			posInic.X = event.x
			posInic.Y = event.y
		elseif (event.phase=='ended' or event.phase == "cancelled" ) then  
  			display.getCurrentStage():setFocus(nil)
  		end

		return true
	end

	local function createEnemy( event )
		-- body
		local function remove( obj )
			-- body
			enemiesGroup:remove( obj )
			obj:removeSelf( )
			obj = nil
		end

		local optionsEnemy = {
   			width = 47,
   			height = 61,
   			numFrames = 8
		}
	
		local enemySheet = graphics.newImageSheet( imgDir.."mineAnimation.png", optionsEnemy )
		local sequenceDataEnemy = { name = "mine", start=1, count=8, time=1000, loopCount=0, loopDirection = "forward" }
		local spriteEnemy = display.newSprite( enemySheet, sequenceDataEnemy )
		
		spriteEnemy.x = display.contentWidth
		spriteEnemy.y = math.random( display.contentCenterY-100, display.contentCenterY+140)
		spriteEnemy.name = "enemy"
		spriteEnemy:play( )
		enemiesGroup:insert( spriteEnemy )
		
		transition.to( spriteEnemy, {time=10000, x=0, y=spriteEnemy.y , onComplete=remove})	
	end

	background = display.newImageRect( imgDir.."mainbackground.png", display.contentWidth, display.contentHeight )
	background.x = display.contentCenterX ; background.y = display.contentCenterY
	background:addEventListener( "touch", playerControl )
	localGroup:insert(background)

	middleBackground = display.newImageRect( imgDir.."bgLayer1.png", display.contentWidth+10, display.contentHeight )
	middleBackground.x = display.contentCenterX ; middleBackground.y = display.contentCenterY
	middleBackground.name = "middle"
	backgroundGroup:insert( middleBackground )

	hideMiddleBackground = display.newImageRect( imgDir.."bgLayer1.png", display.contentWidth, display.contentHeight )
	hideMiddleBackground.x = upperLimit ; hideMiddleBackground.y = display.contentCenterY
	hideMiddleBackground.name = "middle"
	backgroundGroup:insert( hideMiddleBackground )

	local options = {
   		width = 115,
   		height = 69,
   		numFrames = 8
	}
	local playerSheet = graphics.newImageSheet( imgDir.."playerAnimation.png", options )
	local sequenceData = { name = "player", start=1, count=8, time=1000, loopCount=0, loopDirection = "forward" }
	spritePlayer = display.newSprite( playerSheet, sequenceData )
	spritePlayer.x = display.contentCenterX/2 
	spritePlayer.y = display.contentCenterY
	spritePlayer.name = "player"
	spritePlayer:play( )
	backgroundGroup:insert( spritePlayer )	

	beforeBackground = display.newImageRect( imgDir.."bgLayer2.png", display.contentWidth+10, display.contentHeight )
	beforeBackground.x = display.contentCenterX ; beforeBackground.y = display.contentCenterY
	beforeBackground.name = "before"
	backgroundGroup:insert( beforeBackground )

	hideBeforeBackground = display.newImageRect( imgDir.."bgLayer2.png", display.contentWidth, display.contentHeight )
	hideBeforeBackground.x = upperLimit ; hideBeforeBackground.y = display.contentCenterY
	hideBeforeBackground.name = "before"
	backgroundGroup:insert( hideBeforeBackground )
	
	localGroup:insert( backgroundGroup )

	-- Create enemies
	timerEnemy = timer.performWithDelay( math.random( 1000, 3000), createEnemy, 0 )

	Runtime:addEventListener( "enterFrame", moveImage )

	return localGroup
end