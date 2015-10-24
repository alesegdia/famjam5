
local Class         = require (LIBRARYPATH.."hump.class"	)
local constants 	= require ("constants")

require "src.entities.GameEntity"
require "src.entities.Bullet"

Human = Class {

	cooldown = 0,
	direction = 1,
	health = constants.HUMAN_HEALTH,
	vx = constants.HUMAN_SPEED,

	init = function( self, stage )
		local anim = newAnimation( Image.human, 12, 8, 0.5, 2 )
		anim:addFrame( 0, 0, 12, 8, 0.5 )
		anim:addFrame( 12, 0, 12, 8, 0.5 )
		self = GameEntity.init(self, stage, constants.HUMAN_START_X, constants.HUMAN_START_Y, anim, { isHuman = true }, self.step)
	end,

	humanFilter = function(item, other)
		if other.isBullet then
			local bullet = other.entity
			if bullet.faction == constants.BULLET_HUMAN then
				return nil
			end
		end
	end,

	step = function(self, dt)
		if self.pos.x < constants.SQUAD_MIN_X or self.pos.x > constants.SQUAD_MAX_X then
			self.direction = self.direction * -1
		end
		self.stage.world:move(self.aabb, self.pos.x - self.anim:getWidth()/2 + self.direction * self.vx, self.pos.y - self.anim:getHeight()/2, self.humanFilter)
	end,

	shoot = function(self)
		if self.cooldown <= 0 then
			self.cooldown = constants.HUMAN_COOLDOWN
			local bullet = Bullet( self.stage, self.pos.x, self.pos.y, 4, constants.BULLET_HUMAN )
		end
	end

}

Human:include(GameEntity)
