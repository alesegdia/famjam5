
local Class         = require (LIBRARYPATH.."hump.class"	)

Squad = Class{

	invaders = {},

	init = function(self)
	end,
	
	addInvader = function( self, invader )
		table.insert( self.invaders, invader )
	end,
	
	canMoveHorizontal = function( self, x )
		for _,invader in self.invaders do
			-- local aX, aY, cols, len = world:check(
		end
	end
	
}
