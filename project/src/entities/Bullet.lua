
local Class         = require (LIBRARYPATH.."hump.class" )
local constants 	= require ("constants")

require "src.entities.GameEntity"


Bullet = Class {
	
	init = function(self, stage, x, y, vy, faction)
		local anim = newAnimation( Image.bala1x2, 1, 2, 0.2, 1 )
		print(stage)
		self = GameEntity.init(self, stage, x, y, anim, { isBullet = true, faction = faction }, self.step )
		print("SPAWN!")
		assert( faction == constants.BULLET_HUMAN or faction == constants.BULLET_INVADER, "Bullet faction must be one of: BULLET_HUMAN or BULLET_INVADER" )
		self.vy = vy
	end,

	colFilter = function(item, other)
		if other.isInvader then return nil end
	end,

	step = function(self, dt)
		local aX, aY, cols, len = self.stage.world:move(self.aabb, self.pos.x - self.anim:getWidth()/2, self.pos.y + self.vy, self.colFilter)
		for i=1,len do
			local col = cols[i]
			if col.other.isHuman then
				self.dead = true
			end
		end
	end
}

Bullet:include(GameEntity)
