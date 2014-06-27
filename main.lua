local director = require( "director" )

_G.imgDir = "images/"
local mainGroup = display.newGroup( )

local function main( )
	-- body

	mainGroup:insert(director.directorView)

	director:changeScene("menuPrincipal")

	return true
end

main()