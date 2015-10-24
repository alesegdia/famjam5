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


-- MISC -------------------
local color = { 255, 255, 255, 0 }

local center = {
	x = love.graphics.getWidth() / 2,
	y = love.graphics.getHeight() / 2
}

local scale = 4

local bigFont   = love.graphics.newFont("space_invaders.ttf", 32)
local smallFont = love.graphics.newFont("space_invaders.ttf", 16)


-- GAME -------------------
local world 	= bump.newWorld(8)
local stage 	= Stage(world)
local cam 		= camera.new(0,0,1,0)
local squad 	= {}
local human 	= {}
local starsfield = Starsfield()


function Game:enter()
	stage:clear()
	squad = Squad(stage, 6, 6)
	human = Human(stage)
	Shield( stage, 22, 20 )
	Shield( stage, 66, 20 )
	Shield( stage, 110, 20 )
	Shield( stage, 154, 20 )
	color = { 255, 255, 255, 0 }
	cam:move(center.x/scale, center.y/scale)
	cam:zoom(scale)
end

local checkInvaderOverMouse = function(x,y)
	x, y = cam:worldCoords( x, y )
	local items, len = world:queryPoint( x, y, function(item) return item.isInvader end )
	if len ~= 0 then
		local invader = items[len].entity
		invader:shoot()
	end
end

local mousePressed = false
function Game:mousepressed()
	mousePressed = true
	checkInvaderOverMouse( love.mouse.getX(), love.mouse.getY() )
end

function Game:mousereleased()
	mousePressed = false
end

function Game:mousemoved()
	if mousePressed then
		checkInvaderOverMouse( love.mouse.getX(), love.mouse.getY() )
	end
end

function Game:update( dt )
	starsfield:update(dt)
	timer.update(dt)
	squad:step(dt)
	stage:update(dt)
end

function drawHumanHealth( x, y, full_bar_size )
	local current_bar_size = human.health * full_bar_size / constants.HUMAN_HEALTH
	love.graphics.setColor(0, 255, 0, 255)
	love.graphics.rectangle("fill", x, y, current_bar_size, 2)
end

function drawGUI()
	drawHumanHealth( 8, 3, 184 )
end

function Game:draw()
	cam:draw( function()
		starsfield:draw()
		stage:draw()
		drawGUI()
	end )
	gui.core.draw()
	love.graphics.setColor({255,0,0,255})
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 50)
end
