local game = { }
local board = {}
function SetUpGrid()
    board = {
        { '', '', '' },
        { '', '', '' },
        { '', '', '' }
    }
end

local players = { 'X', 'O' }
local title, gameover, available = { }, { }, { }
local currentPlayer
local width, height

local trans, shakeDuration, shakeMagnitude = 0, -1, 0

function game.load(game)
    SetUpGrid()

    title.font = game.fonts[1]
    title.text = "Tic-Tac-Toe"
    title.color = { 0 / 255, 100 / 255, 0 / 255, 1 }

    gameover.font = game.fonts[1]
    gameover.text = "%player% won the game"
    gameover.color = { 0 / 255, 100 / 255, 0 / 255, 1 }

    click_sound = love.audio.newSource(game.sounds.click)
    click_sound:setVolume(.5)

    error_sound = love.audio.newSource(game.sounds.click)
    error_sound:setVolume(.5)

    width, height = love.graphics.getDimensions()
    math.randomseed(os.clock())
    currentPlayer = players[math.random(#players)]
    for j = 1, #board do
        for i = 1, #board[j] do
            available[#available + 1] = { i, j }
        end
    end
end

function game.draw(dt)
    --printTitle()

    -- Screen Shake Animation:
    if (trans < shakeDuration) then
        math.randomseed(os.clock())
        local dx = math.random(-shakeMagnitude, shakeMagnitude)
        local dy = math.random(-shakeMagnitude, shakeMagnitude)
        love.graphics.translate(dx, dy)
    end

    local w = width / 3
    local h = height / 3
    love.graphics.setLineWidth(1)
    love.graphics.setColor(255 / 255, 50 / 255, 0 / 255, 1)
    love.graphics.line(w, 0, w, height);
    love.graphics.line(w * 2, 0, w * 2, height);
    love.graphics.line(0, h, width, h);
    love.graphics.line(0, h * 2, width, h * 2);

    for j = 1, #board do
        for i = 1, #board[j] do

            local xr = w / 4
            local xOff, yOff = 360, 260
            local x = w * i + (w / 2 - xOff)
            local y = h * j + (h / 2 - yOff)
            local spot = board[i][j]
            if (spot == players[1]) then
                love.graphics.setColor(34 / 255, 139 / 255, 34 / 255, 1)
                love.graphics.line(x - xr, y - xr, x + xr, y + xr)
                love.graphics.line(x + xr, y - xr, x - xr, y + xr)
            elseif (spot == players[2]) then
                love.graphics.setColor(0 / 255, 191 / 255, 255 / 255, 1)
                love.graphics.circle('line', x, y, xr)
            end
        end
    end

    local result = checkWinner();
    if (result ~= nil) then

        if (result == 'tie') then
            gameover.text = "TIE"
        else
            gameover.text = string.gsub(gameover.text, "%%player%%", result)
        end
        love.graphics.setColor(unpack(gameover.color))
        local strWidth = gameover.font:getWidth(gameover.text)
        local t = centerText(gameover, strWidth, gameover.font)
        love.graphics.print(gameover.text, t.w, t.h - 250, 0, 1, 1, t.strW, t.fontH)
    end
end

function game.update(dt)
    -- Screen Shake Animation:
    if (trans < shakeDuration) then
        trans = trans + dt
    end
end

function equals3(a, b, c)
    return (a == b and b == c and a ~= '')
end

function checkWinner()
    local winner = nil

    -- horizontal
    for i = 1, 3 do
        if (equals3(board[i][1], board[i][2], board[i][3])) then
            winner = board[i][1]
        end
    end

    -- Vertical
    for i = 1, 3 do
        if (equals3(board[1][i], board[2][i], board[3][i])) then
            winner = board[1][i]
        end
    end

    -- diagonal
    if (equals3(board[1][1], board[2][2], board[3][3])) then
        winner = board[1][1]
    end
    if (equals3(board[3][1], board[2][2], board[1][3])) then
        winner = board[3][1]
    end

    local picked = 0
    for _, index in pairs(available) do
        if (index == "picked") then
            picked = picked + 1
        end
    end

    if (winner == nil and picked == #available) then
        return 'tie'
    else
        return winner
    end
end

function love.mousepressed(x, y, button, isTouch)
    local mx, my = love.mouse.getPosition()
    local w, h = width / 3, height / 3
    for j = 1, #board do
        for i = 1, #board[j] do
            local x = w * i + (w / 2 - 360)
            local y = h * j + (h / 2 - 260)
            if intersecting(mx, my, x, y, 120) then
                if (board[i][j] ~= players[1]) and (board[i][j] ~= players[2]) then
                    board[i][j] = currentPlayer
                    click_sound:play()

                    for k = 1, #available do
                        if (available[k] ~= {}) then
                            if available[k][1] == j and available[k][2] == i then
                                available[k] = "picked"
                            end
                        end
                    end

                    if currentPlayer == "X" then
                        currentPlayer = "O"
                    else
                        currentPlayer = "X"
                    end
                else
                    cameraShake(0.6, 2.5)
                end
            end
        end
    end
end

function game.keypressed(key)
    if (key == 'escape') then
        love.event.push('quit')
    elseif (key == "r") then
        Reset()
    end
end

function Reset()
    SetUpGrid()
    math.randomseed(os.clock())
    currentPlayer = players[math.random(#players)]
    available = {}
    for j = 1, 3 do
        for i = 1, 3 do
            available[#available + 1] = { j, i }
        end
    end
end

function printTitle()
    love.graphics.setFont(title.font)
    love.graphics.setColor(unpack(title.color))
    local strWidth = title.font:getWidth(title.text)
    local t = centerText(title, strWidth, title.font)
    love.graphics.print(title.text, t.w, t.h - 290, 0, 1, 1, t.strW, t.fontH)
end

function centerText(str, strW, font)
    return {
        w = width / 2,
        h = height / 2,
        strW = math.floor(strW / 2),
        fontH = math.floor(font:getHeight() / 2),
    }
end

function intersecting(x1, y1, x2, y2, r)
    local x, y = (x1 - x2), (y1 - y2)
    local dist = math.sqrt(x ^ 2 + y ^ 2)
    if (dist <= r) then
        return true
    end
    return false
end

function cameraShake(duration, magnitude)
    error_sound:play()
    trans, shakeDuration, shakeMagnitude = 0, duration or 1, magnitude or 5
end

return game
