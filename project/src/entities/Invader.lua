

local Class         = require (LIBRARYPATH.."hump.class"	)
local constants 	= require ("constants")

require "src.entities.GameEntity"
require "src.entities.Bullet"
require "src.entities.Debris"

local xsFont= love.graphics.newFont("space_invaders.ttf", 8)

local shootsfx = love.audio.newSource("sfx/disparo.ogg")

local choquesfx = love.audio.newSource("sfx/choqueH.ogg")

Invader = Class {

	cooldown = 0,
	health = 1,

	init = function(self, stage, x, y, invader_anim)
		self.attached = true
		self = GameEntity.init(self, stage, x, y, invader_anim, { isInvader = true }, self.step)
		self.state = "attached"
		self.maxCool = constants.INVADER_COOLDOWN
	end,

	step = function(self, dt)
		self.dead = self.health <= 0
		if self.cooldown > 0 then self.cooldown = self.cooldown - dt end
		-- self.tint.r = self.cooldown * 255 / constants.INVADER_COOLDOWN
		-- if self.tint.r < 0 then self.tint.r = 0 end

		if self.state == "launching" then
			local delta = self.launchTarget.pos - self.pos
			delta:normalize_inplace()
			local filter = function(item, other)
				if not other.isHuman then
					return nil
				else
					return "cross"
				end
			end
			local ax, ay, cols, len = self.stage.world:move(self.aabb, self.pos.x - self.anim:getWidth()/2 + delta.x * 0.5, self.pos.y - self.anim:getHeight()/2 + delta.y * 0.5, filter)
			local didDebris = false
			for i=1,len do
				local col = cols[i]
				if col.other.isHuman then
					CAM_SHAKE = 10
					choquesfx:setPitch(1.5)
					choquesfx:stop()
					choquesfx:play()
					didDebris = true
					self.health = 0
					col.other.entity.health = col.other.entity.health - 2
					if col.other.entity.health <= 0 then GAME_SCORE = GAME_SCORE + constants.SCORE_KILL_HUMAN end
				end
			end
			if didDebris then
				Debris(self.stage, self.pos.x, self.pos.y)
			end
		end
	end,

	draw = function(self)
		GameEntity.draw(self)
		if self.cooldown > 0 then
			local alfa = 128 + self.cooldown * 128 / self.maxCool
			love.graphics.setColor(255,0,0,alfa)
			love.graphics.setFont(xsFont)
			local sizebar = self.cooldown * 5 / self.maxCool
			love.graphics.rectangle("fill", self.pos.x - sizebar/2, self.pos.y, sizebar, 2)
		end
	end,

	shoot = function(self)
		if self.cooldown <= 0 then
			shootsfx:stop()
			shootsfx:play()
			self.cooldown = self.maxCool
			local bullet = Bullet( self.stage, self.pos.x, self.pos.y, -constants.INVADER_SHOOT_SPEED, constants.BULLET_INVADER )
		end
	end,

	launch = function(self, human)
		self.attached = false
		self.launchTarget = human
		self.state = "launching"
	end

}

Invader:include(GameEntity)
