
local Class         = require (LIBRARYPATH.."hump.class"	)
local vector 		= require (LIBRARYPATH.."hump.vector")
local constants 	= require ("constants")
local NOT_INVADER = 0xDEADBEEF

require "src.entities.Invader"


Squad = Class{

	invaders = {},

	nextDown = constants.SQUAD_TIME_TO_DOWN,

	createInvaderAtSlot = function(self, x, y)
		local img
		if y == 1 then img = Image.i1 end
		if y == 2 then img = Image.i2 end
		if y == 3 then img = Image.i3 end
		if y == 4 then img = Image.i4 end
		if y == 5 then img = Image.i5 end
		if y == 6 then img = Image.i6 end
		self.invaders[x][y] = self:makeInvaderN(x * 20, 78 + y * 10, img)
	end,

	init = function(self, stage, slots_x, slots_y, layout)
		self.stage = stage
		self.position = vector.new(0,0)
		self.slots_x = slots_x
		self.slots_y = slots_y
		self.invaders = {}
		self.height = 0

		for x = 1, slots_x do
			self.invaders[x] = {}
			for y = 1, slots_y do
				self:createInvaderAtSlot(x, y)
				self.invaders[x][y].level = 1
				self.invaders[x][y].levelshot = 1
				if layout ~= nil then
					if not layout[x][y].isPresent then
						self.invaders[x][y].dead = true
					else
						self.invaders[x][y].level = layout[x][y].level
						self.invaders[x][y].levelshot = layout[x][y].levelshot
					end
				end
				self.invaders[x][y].tint.g = 255
				if self.invaders[x][y].level == 3 then
					self.invaders[x][y].tint.b = 255
					self.invaders[x][y].health = 6
				end
				if self.invaders[x][y].level == 2 then
					self.invaders[x][y].tint.b = 128
					self.invaders[x][y].health = 3
				end
				if self.invaders[x][y].level == 1 then
					self.invaders[x][y].tint.b = 0
					self.invaders[x][y].health = 1
				end
				if self.invaders[x][y].levelshot == 3 then
					self.invaders[x][y].tint.r = 255
					self.invaders[x][y].maxCool = 0.5
				end
				if self.invaders[x][y].levelshot == 2 then
					self.invaders[x][y].tint.r = 128
					self.invaders[x][y].maxCool = 2
				end
				if self.invaders[x][y].levelshot == 1 then
					self.invaders[x][y].tint.r = 0
					self.invaders[x][y].maxCool = 4
				end
				local sum = self.invaders[x][y].level + self.invaders[x][y].levelshot
				self.invaders[x][y].tint.g = 255 - 255/6 * sum
			end
		end
	end,

	hasReached = function(self)
		local didSelect = false
		local lastRow = 0
		for y=1,6 do
			local any = false
			for x=1,6 do
				if not self.invaders[x][y].dead then
					any = true
					break
				end
			end
			if not any and not didSelect then
				lastRow = y
			end
		end

		return self.height >= 6 + lastRow
	end,

	numInvaders = function(self)
		local num_invaders = 0
		for _,invader_row in ipairs(self.invaders) do
			for _,invader in ipairs(invader_row) do
				if not invader.dead then
					num_invaders = num_invaders + 1
				end
			end
		end
		return num_invaders
	end,

	createLayout = function(self)
		local layout = {}
		local i = 0
		for x = 1, self.slots_x do
			layout[x] = {}
			for y = 1, self.slots_y do
				layout[x][y] = {
					level = self.invaders[x][y].level,
					levelshot = self.invaders[x][y].levelshot,
					isPresent = self.invaders[x][y] and not self.invaders[x][y].dead
				}
			end
		end
		return layout
	end,

	step = function(self, dt)

		self.nextDown = self.nextDown - dt
		if self.nextDown <= 0 then
			self.nextDown = constants.SQUAD_TIME_TO_DOWN
			self:moveBlockDown()
		end


		local mod = (128-16)/36 * (37 - self:numInvaders()) + constants.SQUAD_SPEED
		if love.keyboard.isDown("a") then
			self:moveHorizontal(-1 * mod * dt )
		elseif love.keyboard.isDown("d") then
			self:moveHorizontal(1 * mod * dt)
		end
	end,

	moveBlockDown = function(self)
		local filter = function(item, other)
		end
		for _,invader_row in ipairs(self.invaders) do
			for _,invader in ipairs(invader_row) do
				if not invader.dead then
					local x, y = self.stage.world:getRect(invader.aabb)
					self.stage.world:move(invader.aabb, x, y - constants.SQUAD_DOWN_DISTANCE, filter)
				end
			end
		end
		self.height = self.height + 1
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

	makeInvaderN = function ( self, x, y, img )
		local invader1_anim = newAnimation( img, 8, 8, 0.2, 2 )
		invader1_anim:addFrame( 0, 0, 8, 8, 0.2 )
		invader1_anim:addFrame( 8, 0, 8, 8, 0.2 )
		local inv = Invader( self.stage, x, y, invader1_anim )
		inv.squad = self
		return inv
	end,

	invaderFilter = function (item, other)
		if other.isBullet then
			if other.entity.faction == constants.BULLET_INVADER then
				return nil
			end
		end
	end,

	moveHorizontal = function( self, dx )
		if self:canMoveHorizontal( dx ) then
			for _,invader_row in ipairs(self.invaders) do
				for _,invader in ipairs(invader_row) do
					if not invader.dead and invader.attached then
						local x, y = self.stage.world:getRect(invader.aabb)
						self.stage.world:move(invader.aabb, x + dx, y, self.invaderFilter)
					end
				end
			end
		end
	end,
	
	canMoveHorizontal = function( self, dx )
		local canMove = true
		for _,invader_row in ipairs(self.invaders) do
			for _,invader in ipairs(invader_row) do
				if not invader.dead and invader.attached then
					local newpos = invader.pos.x + dx
					if newpos < constants.SQUAD_MIN_X or newpos > constants.SQUAD_MAX_X then
						canMove = false
						break
					end
				end
			end
		end
		return canMove
	end
	
}
