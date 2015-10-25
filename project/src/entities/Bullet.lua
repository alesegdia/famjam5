
local Class         = require (LIBRARYPATH.."hump.class" )
local constants 	= require ("constants")

require "src.entities.GameEntity"


local explosfx = love.audio.newSource("sfx/explosion.ogg")
local chocasfx = love.audio.newSource("sfx/choca.ogg")
local choquesfx = love.audio.newSource("sfx/choqueH.ogg")

Bullet = Class {
	
	init = function(self, stage, x, y, vy, faction)
		local anim
		if faction == constants.BULLET_INVADER then
			anim = newAnimation( Image.bala1x2, 2, 4, 0.2, 1 )
		else
			anim = newAnimation( Image.bala2x2, 2, 2, 0.2, 1 )
		end
		self = GameEntity.init(self, stage, x, y, anim, { isBullet = true, faction = faction }, self.step )
		assert( faction == constants.BULLET_HUMAN or faction == constants.BULLET_INVADER, "Bullet faction must be one of: BULLET_HUMAN or BULLET_INVADER" )
		self.vy = vy
		self.time = 0
	end,

	colFilter = function(item, other)
		if other.isInvader then
			if item.faction == constants.BULLET_INVADER then
				return nil
			elseif item.faction == constants.BULLET_HUMAN then
				CAM_SHAKE = 5
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
		self.time = self.time + dt
		if self.time > 10 then
			self.dead = true
		end
		local aX, aY, cols, len = self.stage.world:move(self.aabb, self.pos.x - self.anim:getWidth()/2, self.pos.y - self.anim:getHeight()/2+ self.vy * dt, self.colFilter)
		for i=1,len do
			local col = cols[i]
			if col.other.isHuman and self.aabb.faction == constants.BULLET_INVADER then
				explosfx:stop()
				explosfx:play()
				col.other.entity.damaged = 0.5
				CAM_SHAKE = 5
				GAME_SCORE = GAME_SCORE + constants.SCORE_HIT_HUMAN
				self.dead = true
				col.other.entity.health = col.other.entity.health - 1
				if col.other.entity.health <= 0 then GAME_SCORE = GAME_SCORE + constants.SCORE_KILL_HUMAN end
			elseif col.other.isInvader and self.aabb.faction == constants.BULLET_HUMAN then
				choquesfx:setPitch(0.5)
				choquesfx:stop()
				choquesfx:play()
				self.dead = true
				col.other.entity.health = col.other.entity.health - 1
			elseif col.other.isShield then
				choquesfx:setPitch(1)
				choquesfx:stop()
				choquesfx:play()
				GAME_SCORE = GAME_SCORE + constants.SCORE_HIT_SHIELD
				col.other.entity.health = col.other.entity.health - 1
				self.dead = true
				if col.other.entity.health <= 0 then GAME_SCORE = GAME_SCORE + constants.SCORE_BREAK_SHIELD end
			end
		end
	end
}

Bullet:include(GameEntity)
