

local Class         = require (LIBRARYPATH.."hump.class" )
local constants 	= require ("constants")

require "src.entities.GameEntity"


Shield = Class {
	
	health = constants.SHIELD_HEALTH,

	init = function(self, stage, x, y)
		local shield_anim = newAnimation( Image.defense, 24, 12, 0, 1 )
		shield_anim:addFrame( 0, 0, 24, 12, 0.2 )
		shield_anim:addFrame( 24, 0, 24, 12, 0.2 )
		shield_anim:addFrame( 24*2, 0, 24, 12, 0.2 )
		shield_anim:addFrame( 24*3, 0, 24, 12, 0.2 )
		shield_anim:addFrame( 24*4, 0, 24, 12, 0.2 )
		shield_anim:addFrame( 24*5, 0, 24, 12, 0.2 )
		shield_anim:addFrame( 24*6, 0, 24, 12, 0.2 )
		shield_anim:addFrame( 24*7, 0, 24, 12, 0.2 )
		self = GameEntity.init(self, stage, x, y, shield_anim, { isShield = true }, self.step )
	end,

	step = function(self, dt)
		self.tint.g = self.health * 255 / constants.SHIELD_HEALTH
		self.tint.b = self.health * 255 / constants.SHIELD_HEALTH
		self.tint.r = (255 - self.tint.g) / 2 + self.tint.g
		if self.health <= 0 then self.dead = true end
		local selected_anim_index = math.ceil(9 * self.health / constants.SHIELD_HEALTH)
		if selected_anim_index == 0 then selected_anim_index = 1 end
		assert( selected_anim_index > 0 and selected_anim_index <= 9, "Invalid shield anim index" )
		self.anim:seek(selected_anim_index)
	end
}

Shield:include(GameEntity)
