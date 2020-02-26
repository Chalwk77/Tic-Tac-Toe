local game = { }
local board = {
    { 'X', 'X', 'X' },
    { 'O', 'O', 'O' },
    { 'X', 'X', 'X' }
}

local players = { ["X"] = "X", ["O"] = "O" }
local available = {}
local currentPlayer
local width, height

function game.load(game)
    width, height = love.graphics.getDimensions()
    currentPlayer = players[math.random(#players)]
    for j = 1, 3 do
        for i = 1, 3 do
            available[#available + 1] = { i, j }
        end
    end
end

function game.draw(dt)
    local w = width / 3
    local h = height / 3
    love.graphics.setLineWidth(1)
    love.graphics.setColor(255 / 255, 50 / 255, 0 / 255, 1)
    love.graphics.line(w, 0, w, height)
    love.graphics.line(w * 2, 0, w * 2, height)
    love.graphics.line(0, h, width, h)
    love.graphics.line(0, h * 2, width, h * 2)
    for j = 1, 3 do
        for i = 1, 3 do
            local x = w * i + w / 2
            local y = h * j + h / 2
            local xr = w / 4
            local spot = board[i][j]
            if (spot == players["X"]) then
                love.graphics.setColor(34 / 255, 139 / 255, 34 / 255, 1)
                love.graphics.line(x - xr, y - xr, x + xr, y + xr)
                love.graphics.line(x + xr, y - xr, x - xr, y + xr)
            elseif (spot == players["O"]) then
                love.graphics.setColor(0 / 255, 191 / 255, 255 / 255, 1)
                love.graphics.circle('line', x, y, xr)
            end
        end
    end
    nextTurn()
end

function game.update(dt)

end

function nextTurn()
    local num = math.random(#available)
    local spot = available[num]

    if (spot ~= "filled") then
        local i = spot[1]
        local j = spot[2]
        board[i][j] = players[currentPlayer]
        for _, v in pairs(players) do
            if (currentPlayer ~= v) then
                currentPlayer = v
            end
        end
    end
    available[num] = "filled"
end

function love.mousepressed(x, y, button, isTouch)
    nextTurn()
end

function game.keypressed(key)
    if (key == 'escape') then
        love.event.push('quit')
    end
end

return game
