
local Class         = require (LIBRARYPATH.."hump.class"	)
local NOT_INVADER = 0xDEADBEEF

require "src.entities.Invader"


Squad = Class{

	invaders = {},

	init = function(self, stage, slots_x, slots_y)
		self.stage = stage

		-- create empty array of invaders
		for x = 1, slots_x do
			self.invaders[x] = {}
			for y = 1, slots_y do
				self.invaders[x][y] = self:makeInvader1(x * 20, y * 10)
			end
		end
	end,
	
	addInvader = function( self, invader )
		table.insert( self.invaders, invader )
	end,

	makeInvader1 = function ( self, x, y )
		local invader1_anim = newAnimation( Image.invader1, 8, 8, 0.2, 1 )
		return Invader( self.stage, x, y, invader1_anim )
	end,
	
	canMoveHorizontal = function( self, x )
		for _,invader in self.invaders do
			-- local aX, aY, cols, len = world:check(
		end
	end
	
}
