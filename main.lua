local cron = require("libs/cron/cron")

local speech = {
    "01234567890 ",
    "Hello world! ",
    "Lee smells ",
    "Bastion sux ",
    "I don't know about angels, but it's fear that gives men wings. ",
    "One thing you can count on: You push a man too far, and sooner or later he'll start pushing back. ",
    "In the land of the blind, the one-eyed man is king. ",
    "They were all dead. The final gunshot was an exclamation mark on everything that had led to this point. I released my finger from the trigger, and it was over. "
}

local sounds = {}
local soundTimer = nil

local currentChar = 1
local currentLine = 1
local prevSound = nil
local toStop = false

local function sayCharacter()
    if not speech[currentLine] then
        return
    end

    local line = speech[currentLine]
    local character = string.upper(string.sub(line, currentChar, currentChar))

    if prevSound then
        sounds[prevSound]:stop()
    end

    if sounds[character..".ogg"] then
        love.audio.play(sounds[character..".ogg"])
        prevSound = character..".ogg"
    else
        prevSound = nil
    end

    currentChar = currentChar + 1

    if #speech[currentLine] < currentChar then
        currentChar = 1
        currentLine = currentLine + 1
    end
end

function love.load()
    for i, file in ipairs(love.filesystem.getDirectoryItems("sounds")) do
        sounds[file] = love.audio.newSource("sounds/"..file, "static")
        sounds[file]:setPitch(3)
    end

    soundTimer = cron.every(0.1, sayCharacter)
end

function love.update(dt)
    soundTimer:update(dt)
end

function love.draw()
    if not speech[currentLine] then
        return
    end

    local string = string.sub(speech[currentLine], 1, currentChar - 1)
    love.graphics.printf(string, 0, 0, love.graphics:getWidth(), "center")
end
