

local Class         = require (LIBRARYPATH.."hump.class"	)

require "src.entities.GameEntity"

Invader = Class {

	init = function(self, stage, x, y, invader_anim)
		self = GameEntity.init(self, stage, x, y, invader_anim, self.step)
	end,

	step = function(self, dt)

	end

}

Invader:include(GameEntity)
