

local Gamestate = require( LIBRARYPATH.."hump.gamestate"    )
local constants 	= require ("constants")

MidStage = Gamestate.new()

local bigFont   = love.graphics.newFont("space_invaders.ttf", 32)

function MidStage:enter()

end

function MidStage:update()
	if love.keyboard.isDown("return") then
		Gamestate.switch(Game)
	end
end

local dist = function(x1, y1, x2, y2)
	local xx = x1-x2
	local yy = y1-y2
	return math.sqrt( xx * xx + yy * yy )
end

function MidStage:mousepressed(mx, my, button)
	for x=1,6 do
		for y=1,6 do
			local xx = 24 + x * 20 + 4
			local yy = 20 + y * 10 + 4
			if dist(mx, my, xx*4, yy*4) < 5*4 then
				print("click ", x, y)
				local inv = INVADERS_LAYOUT[x][y]
				if inv.isPresent then
					if inv.level == 1 and GAME_SCORE - constants.COST_UPGRADE_INVADER1 >= 0 then
						inv.level = inv.level + 1
						GAME_SCORE = GAME_SCORE - constants.COST_UPGRADE_INVADER1
					elseif inv.level == 2 and GAME_SCORE - constants.COST_UPGRADE_INVADER2 >= 0 then
						inv.level = inv.level + 1
						GAME_SCORE = GAME_SCORE - constants.COST_UPGRADE_INVADER2
					end
				elseif GAME_SCORE - constants.COST_CREATE_INVADER >= 0 then
					GAME_SCORE = GAME_SCORE - constants.COST_CREATE_INVADER
					inv.isPresent = true
					inv.level = 1
				end
			end
		end
	end
end

local center = {
        x = love.graphics.getWidth()/2,
        y = love.graphics.getHeight()/2,
    }

local theQuad = love.graphics.newQuad(0, 0, 8, 8, 16, 8)
function MidStage:draw()
	love.graphics.setColor(255,255,255,255)
	love.graphics.setFont(bigFont)
	love.graphics.printf("GO WASTE SOME POINTS!".. "", 0, 64, center.x * 2, "center")
	love.graphics.printf(GAME_SCORE .. "", 0, 450, center.x * 2, "center")
	for x=1,6 do
		for y=1,6 do
			local inv
			local invader = INVADERS_LAYOUT[x][y]
			love.graphics.setColor(255,255,255,255)
			local xx = 24 + x * 20
			local yy = 20 + y * 10
			if not INVADERS_LAYOUT[x][y].isPresent then
				love.graphics.draw(Image.invaderslot, xx*4, yy*4, 0, 4, 4)
			else
				if y == 1 then inv = Image.i1
				elseif y == 2 then inv = Image.i2
				elseif y == 3 then inv = Image.i3
				elseif y == 4 then inv = Image.i4
				elseif y == 5 then inv = Image.i5
				elseif y == 6 then inv = Image.i6
				end
				if invader.level == 1 then
					love.graphics.setColor(0, 255, 255, 255)
				elseif invader.level == 2 then
					love.graphics.setColor(0, 192, 192, 255)
				elseif invader.level == 3 then
					love.graphics.setColor(0, 128, 128, 255)
				end

				love.graphics.draw( inv, theQuad, xx * 4, yy * 4, 0, 4, 4)
			end
		end
	end
end
