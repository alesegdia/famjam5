

local Class         = require (LIBRARYPATH.."hump.class"	)
local vector 		= require (LIBRARYPATH.."hump.vector")
local constants 	= require ("constants")

require "src.entities.Invader"

local MAX_Y = 140
local MAX_X = 200

Starsfield = Class {

	stars = {},

	init = function(self)
		for k=1,3 do
			for i=1,(4-k)*10 do
				table.insert( self.stars, { index = k, y = love.math.random(0,MAX_Y), x = love.math.random(0,MAX_X) } )
			end
		end
	end,

	update = function(self, dt)
		for _,v in ipairs(self.stars) do
			v.y = v.y + v.index * 0.5
			if v.y > MAX_Y then
				v.x = love.math.random(0,MAX_X)
				v.y = 0
			end
		end
	end,

	draw = function(self)
		for _,v in ipairs(self.stars) do
			love.graphics.setColor(255,255,255,192 - 64 * (3-v.index))
			love.graphics.rectangle("fill", v.x, v.y, v.index * 0.3, v.index * 0.3)
		end
	end

}
