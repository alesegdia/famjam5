

local Gamestate = require( LIBRARYPATH.."hump.gamestate"    )
local gui       = require( LIBRARYPATH.."Quickie"           )

local bigFont   = love.graphics.newFont("space_invaders.ttf", 32)
local midFont   = love.graphics.newFont("space_invaders.ttf", 20)
local smallFont = love.graphics.newFont("space_invaders.ttf", 16)

config_story = function()
	IS_MIRROR = false
	TEXT_SCREEN_TITLE = "CLASSIFIED REPORT NO. 0451"
	TEXT_SCREEN_MID = "DEPARTMENT OF DEFENSE\nOF THE SEPARATED STATES OF AFRICASIA"
	TEXT_SCREEN_TXT =
		"humans have improvised a control device in order to override invader squad's " ..
		"AI and make its annihilation easier. The only drawback is this "..
		"device does not work on earth atmosphere, so the operation must be concluded " ..
		"before invader squad reaches earth.\n\nInstructions are clear. Assume control of "..
		"invaders squad, keep it" ..
		" at easy shot for human defenses and for god's sake... don't shoot.\n\nGood luck, soldier."
end

IS_MIRROR = false

config_win = function()
	IS_MIRROR = true
	TEXT_SCREEN_TITLE = "FMSK MWER"
	TEXT_SCREEN_MID = "APSKROKN AH KROJN STRW VFSR"
	TEXT_SCREEN_TXT = "FKNSR CMNDR SHPRD KRISHJ PQWIER KM KNI LMAO SKIRJTA\n"..
	"PREKSA LOLOL JRKSKA FRNETAI KRMA DFRESIKU. KGNSHTR!\n\nMKHRA: " .. GAME_SCORE
end

config_reach = function()
	TEXT_SCREEN_TITLE = "GAME OVER"
	TEXT_SCREEN_MID = "Invader squad reached earth. There's no hope"
	TEXT_SCREEN_TXT = "SCORE: " .. GAME_SCORE
end

config_humanwin = function()
	IS_MIRROR = false
	TEXT_SCREEN_TITLE = "GAME OVER"
	TEXT_SCREEN_MID = "Congratulations soldier! you did it!"
	TEXT_SCREEN_TXT = "Anyway, you made them score " .. GAME_SCORE
end

config_instructions = function()
	IS_MIRROR = false
	TEXT_SCREEN_TITLE = "INSTRUCTIONS"
	TEXT_SCREEN_MID = "\n\n\n\n\n\na/s - movement\nleft click - shoot/capture debris\nright click - launch invader"
	TEXT_SCREEN_TXT = ""
end

TEXT_SCREEN_TITLE = ""
TEXT_SCREEN_MID = ""
TEXT_SCREEN_TXT = ""

TextScreen = Gamestate.new()

local center = {
        x = love.graphics.getWidth()/2,
        y = love.graphics.getHeight()/2,
    }


function TextScreen:enter()
end


local pwupsfx = love.audio.newSource("sfx/power.ogg")

local prev_space =true 
function TextScreen:update()
	local just_space = love.keyboard.isDown("space")
	if just_space and not prev_space then
		prev_space = true
		pwupsfx:stop()
		pwupsfx:play()
		Gamestate.switch(Menu)
	end
	if not just_space then prev_space = false end
end


function TextScreen:draw()
	love.graphics.setColor(255,255,255,255)
	love.graphics.setFont(bigFont)
	if IS_MIRROR then
		love.graphics.push()
		love.graphics.scale(1,-1)
		love.graphics.translate(0,-600)
	end
	love.graphics.printf(TEXT_SCREEN_TITLE, 0, 64, center.x * 2, "center")

	love.graphics.setFont(midFont)
	love.graphics.printf(TEXT_SCREEN_MID, center.x * 0.125, 132, center.x * 1.75, "center")

	love.graphics.setFont(smallFont)
	love.graphics.printf(TEXT_SCREEN_TXT, center.x * 0.125, 224, center.x * 1.75, "center")

	if IS_MIRROR then
		love.graphics.pop()
	end
end

function TextScreen:keypressed(key, code)
end
