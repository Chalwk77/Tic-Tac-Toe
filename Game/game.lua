local game = { }
local board = {
    { '', '', '' },
    { '', '', '' },
    { '', '', '' }
}

local players = { 'X', 'O' }
local title = {}
local available = {}
local currentPlayer
local width, height

function game.load(game)

    title.font = game.fonts[1]
    title.text = "Tic-Tac-Toe"
    title.color = { 0 / 255, 100 / 255, 0 / 255, 1 }

    width, height = love.graphics.getDimensions()
    currentPlayer = players[math.random(#players)]
    for j = 1, 3 do
        for i = 1, 3 do
            available[#available + 1] = { i, j }
        end
    end
end

function game.draw(dt)
    printTitle()

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
            local x = w * i + w / 2 - 360
            local y = h * j + h / 2 - 260
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
            print("TIE")
        else
            print(result)
        end
    else
        nextTurn();
    end
end

function game.update(dt)

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

    -- Diagonal
    if (equals3(board[1][1], board[2][2], board[3][3])) then
        winner = board[1][1]
    end
    if (equals3(board[3][1], board[2][2], board[1][3])) then
        winner = board[3][1]
    end

    if (winner == nil and #available == 0) then
        return 'tie'
    else
        return winner
    end
end

function nextTurn()
    local num = math.random(#available)
    local spot = available[num]
    while (spot ~= "filled") do
        local i = spot[1]
        local j = spot[2]
        board[i][j] = currentPlayer
        if currentPlayer == "X" then
            currentPlayer = "O"
        else
            currentPlayer = "X"
        end
        available[num] = "filled"
        break
    end
end

function love.mousepressed(x, y, button, isTouch)
    nextTurn()
end

function game.keypressed(key)
    if (key == 'escape') then
        love.event.push('quit')
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

return game
