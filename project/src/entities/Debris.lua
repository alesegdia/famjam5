
local Class         = require (LIBRARYPATH.."hump.class" )
local constants 	= require ("constants")

require "src.entities.GameEntity"


Debris = Class {

	init = function( self, stage, x, y )
		local anim = newAnimation( Image.debris, 10, 10, 0.2, 1 )
		self = GameEntity.init(self, stage, x, y, anim, { isDebris = true }, self.step )
		self.vy = 15 * (love.math.random() + 0.5)
		local sentido = love.math.random()
		if sentido > 0.5 then sentido = -1 else sentido = 1 end
		self.rotvel = love.math.random() + 0.5
		self.rotvel = self.rotvel * sentido
		self.tint.b = 0
	end,

	colFilter = function(item, other)
		return nil
	end,

	step = function(self, dt)
		self.rotation = self.rotation + self.rotvel * dt
		self.stage.world:move(self.aabb, self.pos.x - self.anim:getWidth()/2, self.pos.y - self.anim:getHeight()/2+ self.vy * dt, self.colFilter)
	end
}

Debris:include(GameEntity)
