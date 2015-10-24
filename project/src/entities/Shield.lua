

local Class         = require (LIBRARYPATH.."hump.class" )
local constants 	= require ("constants")

require "src.entities.GameEntity"

local shield_anims = {}
shield_anims[1] = newAnimation( Image.defense, 10, 5, 0.2, 1 )
shield_anims[2] = newAnimation( Image.defense, 10, 5, 0.2, 1 )
shield_anims[3] = newAnimation( Image.defense, 10, 5, 0.2, 1 )
shield_anims[4] = newAnimation( Image.defense, 10, 5, 0.2, 1 )

Shield = Class {
	
	health = constants.SHIELD_HEALTH,

	init = function(self, stage, x, y)
		self = GameEntity(self, stage, x, y, shield_anim_1, self.step )
	end,

	step = function(self, dt)
		if self.health <= 0 then self.dead = true end
		local selected_anim_index = math.ceil(4 * self.health / constants.SHIELD_HEALTH)
		assert( selected_anim_index > 0 and selected_anim_index <= 4, "Invalid shield anim index" )
		self.anim = shields_anim[selected_anim_index]
	end
}
