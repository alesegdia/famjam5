
local Class         = require (LIBRARYPATH.."hump.class"	)

require "src.entities.Entity"
require (LIBRARYPATH.."AnAL")

GameEntity = Class {
	init = function(self, stage, x, y, anim, controller)
		self = Entity.init(self, stage, x, y)
		self.controller = controller or nil
		self.anim = anim
		self.aabb = {}
		self.stage.world:add( self.aabb, 0, 0, self.anim:getWidth(), self.anim:getHeight() )
		self.rotation = 0
		return self
	end,
	update = function(self,dt)
		if self.anim ~= nil then self.anim:update(dt) end
		if self.controller ~= nil then self.controller(self, dt) end
	end,
	draw = function(self)
		love.graphics.setColor({255,255,255,255})
		if self.anim ~= nil then
			self.anim:draw(self.pos.x,self.pos.y, self.rotation, 1, 1, self.anim.fw/2, self.anim.fh/2)
		end
	end
}

GameEntity:include(Entity)
