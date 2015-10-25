
local Class         = require (LIBRARYPATH.."hump.class"	)
local constants 	= require ("constants")

require "src.entities.GameEntity"
require "src.entities.Bullet"

local shoot_points = { 10, 54, 100, 144, 196 }

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
	maxhealth = 10,

	init = function( self, stage )
		local img
		if LEVEL == 0 then img = Image.human end
		if LEVEL == 1 then img = Image.human2 end
		if LEVEL == 2 then img = Image.human3 end
		local anim = newAnimation( img, 12, 8, 0.5, 2 )
		anim:addFrame( 0, 0, 12, 8, 0.5 )
		anim:addFrame( 12, 0, 12, 8, 0.5 )
		self = GameEntity.init(self, stage, constants.HUMAN_START_X, constants.HUMAN_START_Y, anim, { isHuman = true }, self.step)
		if LEVEL == 0 then
			self.health = constants.LEVEL1_HUMAN_HEALTH
			self.maxhealth = constants.LEVEL1_HUMAN_HEALTH
			self.numShots = constants.LEVEL1_HUMAN_SHOOTS
			self.vx = constants.LEVEL1_HUMAN_SPEED
			self.timeBetweenShot = constants.LEVEL1_HUMAN_COOLDOWN
		end
		if LEVEL == 1 then
			self.health = constants.LEVEL2_HUMAN_HEALTH
			self.maxhealth = constants.LEVEL2_HUMAN_HEALTH
			self.numShots = constants.LEVEL2_HUMAN_SHOOTS
			self.vx = constants.LEVEL2_HUMAN_SPEED
			self.timeBetweenShot = constants.LEVEL2_HUMAN_COOLDOWN
		end
		if LEVEL == 2 then
			self.health = constants.LEVEL3_HUMAN_HEALTH
			self.maxhealth = constants.LEVEL3_HUMAN_HEALTH
			self.numShots = constants.LEVEL3_HUMAN_SHOOTS
			self.vx = constants.LEVEL3_HUMAN_SPEED
			self.timeBetweenShot = constants.LEVEL3_HUMAN_COOLDOWN
		end
		self.damaged = 0

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
		if self.damaged > 0 then
			self.tint.g = 255 - 255 * self.damaged
			self.tint.b = 255 - 255 * self.damaged
			self.damaged = self.damaged - dt
		else
			self.tint.g = 255
			self.tint.b = 255
			self.tint.r = 255
		end
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
				if self.pos.x < constants.SQUAD_MIN_X then
					self.stage.world:move(self.aabb, constants.SQUAD_MIN_X, self.pos.y - self.anim:getHeight()/2, self.humanFilter)
				end
				if self.pos.x > constants.SQUAD_MAX_X then
					self.stage.world:move(self.aabb, constants.SQUAD_MAX_X, self.pos.y - self.anim:getHeight()/2, self.humanFilter)
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
