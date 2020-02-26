-- Game Title: Tic-Tac-Toe
-- A 2D video game written in the Lua Programming Language with Love2D Framework.
-- Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
-- Special credits to Enrique García Cota for love-loader v2.0.3 (utility library).

local loadingState = require 'Lib/loadingState'
local playingState = require 'Game/game'
local currentState = nil

local game = { images = {}, sounds = {}, fonts = {} }

local function loadingFinished()
    currentState = playingState
    currentState.load(game)
end

function love.load()

    local cursor = love.mouse.newCursor("Media/Images/cursor.png")
    love.mouse.setCursor(cursor)

    -- Detect native desktop resolution and set window mode to fullscreen:
    --local ww, wh = love.window.getDesktopDimensions()
    --love.window.setMode(ww, wh, {
    --    fullscreen = true,
    --    vsync = true,
    --    centered = true
    --})

    currentState = loadingState
    currentState.load(game, loadingFinished)
end

function love.draw()
    currentState.draw(game)
end

function love.update(dt)
    currentState.update(dt)
end

function love.keypressed(key)
    if key == 'escape' then
        local func = love.event.quit or love.event.push
        func('q')
    end
    if currentState.keypressed then
        currentState.keypressed(key)
    end
end
