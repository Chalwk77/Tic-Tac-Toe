local loader = require 'Lib/love-loader'
local loadingState = {}

local function drawLoadingBar()
    if (loader.loadedCount < loader.resourceCount) then
        -- draw splash screen
    end
end

function loadingState.load(game, finishCallback)
    print("Assets are loading...")

    ------------------- Preload Static Images:
    -- Back Button:
    loader.newImage(game.images, 1, 'Media/Images/return-92x90.png')
    -- Pause Button:
    loader.newImage(game.images, 2, 'Media/Images/pause-92-90.png')

    ------------------- Preload Audio Files:
    loader.newSoundData(game.sounds, 'error', 'Media/Sounds/error.wav')
    loader.newSoundData(game.sounds, 'click', 'Media/Sounds/click.mp3')

    ------------------- Preload Fonts:
    -- Menu Title:
    loader.newFont(game.fonts, 1, 'Assets/Fonts/arial.ttf', 34)
    loader.load(finishCallback, print)
end

function loadingState.draw()
    drawLoadingBar()
end

function loadingState.update(dt)
    loader.update()
end

return loadingState
