--
--  Menu
--

local Gamestate = require( LIBRARYPATH.."hump.gamestate"    )
local gui       = require( LIBRARYPATH.."Quickie"           )

local bigFont   = love.graphics.newFont("space_invaders.ttf", 32)
local smallFont = love.graphics.newFont("space_invaders.ttf", 16)

Menu = Gamestate.new()

local center = {
        x = love.graphics.getWidth()/2,
        y = love.graphics.getHeight()/2,
    }

local selected = 0

function Menu:enter()
	love.keyboard.setKeyRepeat(false)
	theme:stop()
	LEVEL = 0
	menutheme:stop()
	menutheme:play()
end

local prev_s = false
local prev_a = false
local prev_space = false

local tutorial = true
local options = { "start", "instructions", "tutorial:" }

function Menu:update()
	local just_s = love.keyboard.isDown("s")
	local just_a = love.keyboard.isDown("w")
	local just_space = love.keyboard.isDown(" ")

	if just_s and not prev_s then
		prev_s = true
		selected = selected + 1
		if selected > 2 then selected = 0 end
	end
	if not just_s then prev_s = false end

	if just_a and not prev_a then
		prev_a = true
		selected = selected - 1
		if selected < 0 then selected = 2 end
	end
	if not just_a then prev_a = false end

	if just_space and not prev_space then
		prev_space = true
		if selected == 0 then
			INVADERS_LAYOUT = nil
			Gamestate.switch(Game)
		elseif selected == 1 then
			config_story()
			Gamestate.switch(TextScreen)
		elseif selected == 2 then
			tutorial = not tutorial
		end
	end
	if not just_space then prev_space = false end
end


function Menu:draw()
	love.graphics.setFont(bigFont)
	love.graphics.printf("SREDA VNIECAPS", 0, 64, center.x * 2, "center")

	love.graphics.setFont(smallFont)
	local i = 0
	for _,v in ipairs(options) do
		if i == selected then
			love.graphics.setColor(255,255,255,255)
		else
			love.graphics.setColor(255,255,255,128)
		end
		local s = v
		if i == 2 then
			if tutorial then s = s .. " on"
			else s = s .. " off" end
		end
		love.graphics.printf(s, 0, 412 + i * 24, center.x * 2, "center")
		love.graphics.setColor(255,255,255,255)
		i = i + 1
	end
end

function Menu:keypressed(key, code)
    gui.keyboard.pressed(key, code)
end
