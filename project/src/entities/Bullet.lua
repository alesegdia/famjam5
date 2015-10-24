
local Class         = require (LIBRARYPATH.."hump.class" )
local constants 	= require ("constants")

require "src.entities.GameEntity"


Bullet = Class {
	
	init = function(self, stage, x, y, vy, faction)
		local anim
		if faction == constants.BULLET_INVADER then
			anim = newAnimation( Image.bala1x2, 1, 2, 0.2, 1 )
		else
			anim = newAnimation( Image.bala2x2, 2, 2, 0.2, 1 )
		end
		self = GameEntity.init(self, stage, x, y, anim, { isBullet = true, faction = faction }, self.step )
		assert( faction == constants.BULLET_HUMAN or faction == constants.BULLET_INVADER, "Bullet faction must be one of: BULLET_HUMAN or BULLET_INVADER" )
		self.vy = vy
	end,

	colFilter = function(item, other)
		if other.isInvader then
			if item.faction == constants.BULLET_INVADER then
				return nil
			elseif item.faction == constants.BULLET_HUMAN then
				return "cross"
			end
		elseif other.isHuman then
			if item.faction == constants.BULLET_INVADER then
				return "cross"
			elseif item.faction == constants.BULLET_HUMAN then
				return nil
			end
		elseif other.isShield then
			return "cross"
		end
	end,

	step = function(self, dt)
		local aX, aY, cols, len = self.stage.world:move(self.aabb, self.pos.x - self.anim:getWidth()/2, self.pos.y + self.vy, self.colFilter)
		for i=1,len do
			local col = cols[i]
			if col.other.isHuman and self.aabb.faction == constants.BULLET_INVADER then
				self.dead = true
				col.other.entity.health = col.other.entity.health - 1
			elseif col.other.isInvader and self.aabb.faction == constants.BULLET_HUMAN then
				self.dead = true
				col.other.entity.health = col.other.entity.health - 1
			elseif col.other.isShield then
				col.other.entity.health = col.other.entity.health - 1
				self.dead = true
			end
		end
	end
}

Bullet:include(GameEntity)
