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

local bigFont   = love.graphics.newFont(32)
local smallFont = love.graphics.newFont(16)


-- GAME -------------------
local world 	= bump.newWorld(8)
local stage 	= Stage(world)
local cam 		= camera.new(0,0,1,0)
local squad 	= Squad()


local function makeInvader1( x, y )
	local invader1_anim = newAnimation( Image.invader1, 8, 8, 0.2, 1 )
	return makeInvader( invader1_anim, x, y )
end

function makeInvader( anim, x, y )
	return GameEntity( stage, x, y, anim,
		function()
			-- logica del invader aqui
		end
	)
end

function Game:enter()
	stage:clear()
	makeInvader1( 10, 10 )
	color = { 255, 255, 255, 0 }
	tween(4, color, { 255, 255, 0, 255 }, 'bounce' )
	cam:zoom(4)
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
	cam:draw( function()
		stage:draw()
	end )
	gui.core.draw()
	love.graphics.setColor({255,0,0,255})
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 50)
end
