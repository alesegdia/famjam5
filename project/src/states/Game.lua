--
--  Game
--

local Gamestate     = require (LIBRARYPATH.."hump.gamestate")
local gui       	= require (LIBRARYPATH.."Quickie"           )
local timer 		= require (LIBRARYPATH.."hump.timer")
local tween         = timer.tween
local camera 		= require (LIBRARYPATH.."hump.camera")
local bump 			= require (LIBRARYPATH.."bump")
local constants 	= require ("constants")

require "src.entities.Stage"
require "src.entities.GameEntity"
require "src.entities.Squad"
require "src.entities.Human"
require "src.entities.Starsfield"

Game = Gamestate.new()

CAM_SHAKE = 0


-- MISC -------------------
local color = { 255, 255, 255, 0 }

local center = {
	x = love.graphics.getWidth() / 2,
	y = love.graphics.getHeight() / 2
}

local scale = 4

local bigFont   = love.graphics.newFont("space_invaders.ttf", 32)
local smallFont = love.graphics.newFont("space_invaders.ttf", 16)
local xsFont= love.graphics.newFont("space_invaders.ttf", 8)

local pwupsfx = love.audio.newSource("sfx/power.ogg")

-- GAME -------------------
local world 	= bump.newWorld(8)
local stage 	= Stage(world)
local cam 		= camera.new(0,0,1,0)
local squad 	= {}
local human 	= {}
local starsfield = Starsfield()

INVADERS_LAYOUT = nil
LEVEL = 0

function Game:enter()
	stage:clear()
	menutheme:stop()
	theme:stop()
	theme:play()
	if INVADERS_LAYOUT == nil then
		squad = Squad(stage, 6, 6)
	else
		squad = Squad(stage, 6, 6, INVADERS_LAYOUT)
	end
	human = Human(stage)
	Shield( stage, 22, 20 )
	Shield( stage, 66, 20 )
	Shield( stage, 110, 20 )
	Shield( stage, 154, 20 )
	color = { 255, 255, 255, 0 }
	cam:place(center.x/scale, center.y/scale)
	cam:zoomTo(scale)
end

local checkInvaderOverMouse = function(x,y,button,checkdebris)
	button = button or "l"
	x, y = cam:worldCoords( x, y )
	--local items, len = world:queryPoint( x, y, function(item) return item.isInvader or item.isDebris end )
	local items, len = world:queryRect( x-8, y-8, 16, 16, function(item) return item.isInvader or item.isDebris end )
	if len ~= 0 then
		if items[len].isInvader then
			local invader = items[len].entity
			if button == "l" then
				invader:shoot()
			elseif button == "r" then
				invader:launch(human)
			end
		elseif items[len].isDebris then
			if checkdebris then
				pwupsfx:stop()
				pwupsfx:play()
				items[len].entity.dead = true
				GAME_SCORE = GAME_SCORE + 1000
			end
		end
	end
end

local mousePressed = false
function Game:mousepressed(x, y, button)
	mousePressed = true
	checkInvaderOverMouse( love.mouse.getX(), love.mouse.getY(), button, true )
end

function Game:mousereleased()
	mousePressed = false
end

function Game:mousemoved()
	if mousePressed then
		checkInvaderOverMouse( love.mouse.getX(), love.mouse.getY(), nil)
	end
end

function Game:update( dt )
	starsfield:update(dt)
	timer.update(dt)
	squad:step(dt)
	stage:update(dt)

	-- end game
	if LEVEL >= 3 then
		config_win()
		Gamestate.switch(TextScreen)
	end

	-- human dies
	if human.health <= 0 then
		INVADERS_LAYOUT = squad:createLayout()
		LEVEL = LEVEL + 1
		if LEVEL < 3 then
			Gamestate.switch(MidStage)
		else
			config_win()
			Gamestate.switch(TextScreen)
		end
	end

	-- no more invaders
	if squad:numInvaders() == 0 then
		config_humanwin()
		Gamestate.switch(TextScreen)
	end

	-- reach condition
	if squad.height >= 6 then
		config_reach()
		Gamestate.switch(TextScreen)
	end

	if CAM_SHAKE > 0 then
		CAM_SHAKE = CAM_SHAKE - dt * 20
	end
	if CAM_SHAKE < 0 then CAM_SHAKE = 0 end

end

function drawHumanHealth( x, y, full_bar_size )
	if human.maxhealth then
		local t = human.maxhealth
		if t == 0 then t = 1 end
		local current_bar_size = human.health * full_bar_size / t
		love.graphics.setColor(255, 0, 0, 255)
		love.graphics.rectangle("fill", x, y, current_bar_size, 2)
	end
end

function drawGUI()
	drawHumanHealth( 8, 3, 184 )
	love.graphics.setColor(255,255,255,255)
	love.graphics.setFont(xsFont)
	love.graphics.print("SCORE: " .. GAME_SCORE, 2, 140)
end

function Game:draw()
	local cx, cy
	cx = love.math.random() * CAM_SHAKE 
	cy = love.math.random() * CAM_SHAKE
	cam:place(cx + center.x/scale, cy + center.y/scale)
	cam:zoomTo(scale)
	cam:draw( function()
		starsfield:draw()
		stage:draw()
		drawGUI()
	end )
	gui.core.draw()
	-- love.graphics.setColor({255,0,0,255})
	-- love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 50)
end

--[[
-- 		matar humano:         100 000
-- 		acertar humano:           100
-- 		acertar escudo:            10
-- 		romper escudo:            100
-- 		crear invader:        -50 000
-- 		mejora invader 1:      -1 000
-- 		mejora invader 2:      -2 000
]]--
