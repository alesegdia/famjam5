
local Class         = require (LIBRARYPATH.."hump.class"	)
local constants 	= require ("constants")

require "src.entities.GameEntity"
require "src.entities.Bullet"

local shoot_points = { 10, 54, 100, 144, 192 }

Human = Class {

	cooldown = 0,
	direction = 1,
	health = constants.HUMAN_HEALTH,
	vx = constants.HUMAN_SPEED,
	numShots = 2,
	remainingShots = 0,
	timeBetweenShot = 0.2,
	nextShot = 0,
	state = "moving",
	lastShotPoint = 0,

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

	isNearShotPoint = function(self)
		for _,v in ipairs(shoot_points) do
			if v ~= self.lastShotPoint then
				if math.abs(self.pos.x - v) < 5 then
					self.lastShotPoint = v
					return true
				end
			end
		end
		return false
	end,

	step = function(self, dt)
		if self.health <= 0 then self.dead = true end
		if self.state == "shooting" then
			self.nextShot = self.nextShot - dt
			if self.nextShot <= 0 then
				self:shoot()
				self.nextShot = self.timeBetweenShot
				self.remainingShots = self.remainingShots - 1
			end
			if self.remainingShots <= 0 then
				self.state = "moving"
			end
		elseif self.state == "moving" then
			if self:isNearShotPoint() then
				self.state = "shooting"
				self.remainingShots = self.numShots
				self.nextShot = 0
			else
				if self.pos.x < constants.SQUAD_MIN_X or self.pos.x > constants.SQUAD_MAX_X then
					self.direction = self.direction * -1
				end
				self.stage.world:move(self.aabb, self.pos.x - self.anim:getWidth()/2 + self.direction * self.vx * dt, self.pos.y - self.anim:getHeight()/2, self.humanFilter)
			end
		end
	end,

	shoot = function(self)
		local bullet = Bullet( self.stage, self.pos.x, self.pos.y, constants.HUMAN_SHOOT_SPEED, constants.BULLET_HUMAN )
	end

}

Human:include(GameEntity)
