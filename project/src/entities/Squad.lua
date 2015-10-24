
local Class         = require (LIBRARYPATH.."hump.class"	)
local vector 		= require (LIBRARYPATH.."hump.vector")
local constants 	= require ("constants")
local NOT_INVADER = 0xDEADBEEF

require "src.entities.Invader"


Squad = Class{

	invaders = {},

	nextDown = constants.SQUAD_TIME_TO_DOWN,

	init = function(self, stage, slots_x, slots_y)
		self.stage = stage
		self.position = vector.new(0,0)

		-- create empty array of invaders
		for x = 1, slots_x do
			self.invaders[x] = {}
			for y = 1, slots_y do
				self.invaders[x][y] = self:makeInvader1(x * 20, y * 10)
			end
		end
	end,

	step = function(self, dt)
		
		self.nextDown = self.nextDown - dt
		if self.nextDown <= 0 then
			self.nextDown = constants.SQUAD_TIME_TO_DOWN
			self:moveBlockDown()
		end


		if love.keyboard.isDown("a") then
			self:moveHorizontal(-1)
		elseif love.keyboard.isDown("d") then
			self:moveHorizontal(1)
		end
	end,

	moveBlockDown = function(self)
		local filter = function(item, other)
		end
		for _,invader_row in ipairs(self.invaders) do
			for _,invader in ipairs(invader_row) do
				local x, y = self.stage.world:getRect(invader.aabb)
				self.stage.world:move(invader.aabb, x, y + constants.SQUAD_DOWN_DISTANCE, filter)
			end
		end
	end,
	
	addInvader = function( self, invader )
		table.insert( self.invaders, invader )
	end,

	move = function(self, direction, quantity)
		assert( math.abs(direction) == 1, "Direction must be 1 or -1" )
		local movement = direction * quantity
	end,

	makeInvader1 = function ( self, x, y )
		local invader1_anim = newAnimation( Image.invader1, 8, 8, 0.2, 1 )
		return Invader( self.stage, x, y, invader1_anim )
	end,

	invaderFilter = function (item, other)
		if other.isBullet then
			if other.entity.faction == constants.BULLET_INVADER then
				return nil
			end
		end
	end,

	moveHorizontal = function( self, dx )
		local filter = function(item, other)
			if 		other.isInvader 	then return "cross"
			elseif 	other.isBleh 		then return "touch"
			else return nil
			end
		end
		if self:canMoveHorizontal( dx ) then
			for _,invader_row in ipairs(self.invaders) do
				for _,invader in ipairs(invader_row) do
					local x, y = self.stage.world:getRect(invader.aabb)
					self.stage.world:move(invader.aabb, x + dx, y, self.invaderFilter)
				end
			end
		end
	end,
	
	canMoveHorizontal = function( self, dx )
		local canMove = true
		for _,invader_row in ipairs(self.invaders) do
			for _,invader in ipairs(invader_row) do
				local newpos = invader.pos.x + dx
				if newpos < constants.SQUAD_MIN_X or newpos > constants.SQUAD_MAX_X then
					canMove = false
					break
				end
			end
		end
		return canMove
	end
	
}
