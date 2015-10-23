--
--  Game
--

local Gamestate     = require (LIBRARYPATH.."hump.gamestate")
local gui       	= require (LIBRARYPATH.."Quickie"           )
local timer 		= require (LIBRARYPATH.."hump.timer")
local bump 			= require (LIBRARYPATH.."bump")
local tween         = timer.tween

require "src.entities.Stage"
require "src.entities.GameEntity"

Game = Gamestate.new()

local color = { 255, 255, 255, 0 }

local center = {
	x = love.graphics.getWidth() / 2,
	y = love.graphics.getHeight() / 2
}

local bigFont   = love.graphics.newFont(32)
local smallFont = love.graphics.newFont(16)
local stage 	= Stage()

function Game:enter()
	stage:clear()
	color = { 255, 255, 255, 0 }
	tween(4, color, { 255, 255, 0, 255 }, 'bounce' )
end

function Game:update( dt )
	timer.update(dt)
	stage:update(dt)
	if gui.Button{text = "Go back"} then
		timer.clear()
		Gamestate.switch(Menu)
	end
end

function Game:draw()
	love.graphics.setFont(bigFont)
	love.graphics.setColor(color)
	love.graphics.rectangle("fill", 0, 0, center.x*2, color[4])
	love.graphics.print("You lost the game.", center.x, center.y)
	love.graphics.setFont(smallFont)
	stage:draw()
	gui.core.draw()
	love.graphics.setColor({255,0,0,255})
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 50)
end
