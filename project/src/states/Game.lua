--
--  Game
--

local Gamestate     = require (LIBRARYPATH.."hump.gamestate")
local gui       	= require (LIBRARYPATH.."Quickie"           )
local timer 		= require (LIBRARYPATH.."hump.timer")
local tween         = timer.tween
local camera 		= require (LIBRARYPATH.."hump.camera")
local bump 			= require (LIBRARYPATH.."bump")

require "src.entities.Stage"
require "src.entities.GameEntity"
require "src.entities.Squad"

Game = Gamestate.new()


-- MISC -------------------
local color = { 255, 255, 255, 0 }

local center = {
	x = love.graphics.getWidth() / 2,
	y = love.graphics.getHeight() / 2
}

local scale = 4

local bigFont   = love.graphics.newFont(32)
local smallFont = love.graphics.newFont(16)


-- GAME -------------------
local world 	= bump.newWorld(8)
local stage 	= Stage(world)
local cam 		= camera.new(0,0,1,0)
local squad 	= {}


function Game:enter()
	stage:clear()
	squad = Squad(stage, 6, 6)
	color = { 255, 255, 255, 0 }
	cam:move(center.x/scale, center.y/scale)
	cam:zoom(scale)
end

function Game:update( dt )
	timer.update(dt)
	stage:update(dt)
end

function Game:draw()
	cam:draw( function()
		stage:draw()
	end )
	gui.core.draw()
	love.graphics.setColor({255,0,0,255})
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 50)
end
