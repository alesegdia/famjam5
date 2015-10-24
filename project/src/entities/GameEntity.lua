
local Class         = require (LIBRARYPATH.."hump.class"	)

require "src.entities.Entity"
require (LIBRARYPATH.."AnAL")

GameEntity = Class {
	init = function(self, stage, x, y, anim, aabb, controller)
		self = Entity.init(self, stage, x, y)
		self.controller = controller or nil
		self.anim = anim
		self.aabb = aabb
		self.aabb.entity = self
		self.stage.world:add( self.aabb, x, y, self.anim:getWidth(), self.anim:getHeight() )
		self.rotation = 0
		return self
	end,
	update = function(self,dt)
		local x, y, w, h = self.stage.world:getRect(self.aabb)
		self.pos.x = x + w/2
		self.pos.y = y + h/2
		if self.anim ~= nil then self.anim:update(dt) end
		if self.controller ~= nil then self.controller(self, dt) end
	end,
	draw = function(self)
		love.graphics.setColor({255,255,255,255})
		if self.anim ~= nil then
			self.anim:draw(self.pos.x,self.pos.y, self.rotation, 1, 1, self.anim.fw/2, self.anim.fh/2)
		end
		if self.aabb ~= nil then
			local x, y, w, h = self.stage.world:getRect(self.aabb)
			love.graphics.setColor(255, 255, 255, 255)
			love.graphics.rectangle("line", x, y, w, h)
			love.graphics.setColor(255, 0, 0, 128)
			love.graphics.rectangle("fill", x, y, w, h)
		end
	end
}

GameEntity:include(Entity)
