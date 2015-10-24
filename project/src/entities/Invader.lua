

local Class         = require (LIBRARYPATH.."hump.class"	)
local constants 	= require ("constants")

require "src.entities.GameEntity"
require "src.entities.Bullet"

Invader = Class {

	cooldown = 0,
	health = 1,

	init = function(self, stage, x, y, invader_anim)
		self = GameEntity.init(self, stage, x, y, invader_anim, { isInvader = true }, self.step)
	end,

	step = function(self, dt)
		self.dead = self.health <= 0
		if self.cooldown > 0 then self.cooldown = self.cooldown - dt end
		self.tint.r = self.cooldown * 255 / constants.INVADER_COOLDOWN
		if self.tint.r < 0 then self.tint.r = 0 end
	end,

	shoot = function(self)
		if self.cooldown <= 0 then
			self.cooldown = constants.INVADER_COOLDOWN
			local bullet = Bullet( self.stage, self.pos.x, self.pos.y, -constants.INVADER_SHOOT_SPEED, constants.BULLET_INVADER )
		end
	end

}

Invader:include(GameEntity)
