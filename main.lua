Push = require 'push'
Class = require 'class'

require 'Paddle'
require 'Ball'
require 'Assets'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200
BALL_SPEED = 100
BALL_SPEED_INCREMENT = 10
BALL_SPEED_MIN = 30
BALL_SPEED_MAX = 200

function love.load()
    love.graphics.setDefaultFilter('linear', 'linear') -- Better for images
    love.window.setTitle('Tennis Pong')
    math.randomseed(os.time())

    SmallFont = love.graphics.newFont('Press_Start_2P/PressStart2P-Regular.ttf', 8)
    ScoreFont = love.graphics.newFont('Press_Start_2P/PressStart2P-Regular.ttf', 32)
    love.graphics.setFont(SmallFont)

    Push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    assets = Assets()

    Player1Score = 0
    Player2Score = 0

    Player1 = Paddle(10, 30, 5, 20)
    Player2 = Paddle(VIRTUAL_WIDTH - 15, VIRTUAL_HEIGHT - 50, 5, 20)
    Ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    servingPlayer = 1
    GameState = 'start'
end

function setBallSpeed(speed)
    BALL_SPEED = math.max(BALL_SPEED_MIN, math.min(BALL_SPEED_MAX, speed))
end

function increaseBallSpeed()
    BALL_SPEED = math.min(BALL_SPEED_MAX, BALL_SPEED + BALL_SPEED_INCREMENT)
end

function decreaseBallSpeed()
    BALL_SPEED = math.max(BALL_SPEED_MIN, BALL_SPEED - BALL_SPEED_INCREMENT)
end

function resetBallSpeed()
    BALL_SPEED = 100
end

function love.update(dt)
    if GameState == 'serve' then
        Ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            Ball.dx = math.random(BALL_SPEED + 40, BALL_SPEED + 100)
        else
            Ball.dx = -math.random(BALL_SPEED + 40, BALL_SPEED + 100)
        end

    elseif GameState == 'play' then
        if Ball:collides(Player1) then
            Ball.dx = -Ball.dx * 1.03
            Ball.x = Player1.x + 5
            Ball.dy = Ball.dy < 0 and -math.random(10, 150) or math.random(10, 150)
            assets:playSound('paddleHit')
        end

        if Ball:collides(Player2) then
            Ball.dx = -Ball.dx * 1.03
            Ball.x = Player2.x - 4
            Ball.dy = Ball.dy < 0 and -math.random(10, 150) or math.random(10, 150)
            assets:playSound('paddleHit')
        end

        if Ball.y <= 0 then
            Ball.y = 0
            Ball.dy = -Ball.dy
        end

        if Ball.y >= VIRTUAL_HEIGHT - Ball.height then
            Ball.y = VIRTUAL_HEIGHT - Ball.height
            Ball.dy = -Ball.dy
        end

        if Ball.x < 0 then
            Player2Score = Player2Score + 1
            servingPlayer = 1
            assets:playSound('score')
            if Player2Score == 10 then
                winningPlayer = 2
                GameState = 'done'
            else
                Ball:reset()
                GameState = 'serve'
            end
        end

        if Ball.x > VIRTUAL_WIDTH then
            Player1Score = Player1Score + 1
            servingPlayer = 2
            assets:playSound('score')
            if Player1Score == 10 then
                winningPlayer = 1
                GameState = 'done'
            else
                Ball:reset()
                GameState = 'serve'
            end
        end
    end

    if love.keyboard.isDown('w') then
        Player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        Player1.dy = PADDLE_SPEED
    else
        Player1.dy = 0
    end

    if love.keyboard.isDown('up') then
        Player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        Player2.dy = PADDLE_SPEED
    else
        Player2.dy = 0
    end

    if GameState == 'play' then
        Ball:update(dt)
    end

    Player1:update(dt)
    Player2:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if GameState == 'start' then
            GameState = 'serve'
        elseif GameState == 'serve' then
            GameState = 'play'
        elseif GameState == 'done' then
            Player1Score = 0
            Player2Score = 0
            Ball:reset()
            servingPlayer = winningPlayer == 1 and 2 or 1
            GameState = 'serve'
        end
    elseif key == '+' or key == '=' then
        increaseBallSpeed()
    elseif key == '-' then
        decreaseBallSpeed()
    elseif key == '0' then
        resetBallSpeed()
    end
end

function love.draw()
    Push:start()

    love.graphics.draw(assets:getImage('background'), 0, 0, 0, VIRTUAL_WIDTH / assets:getImage('background'):getWidth(), VIRTUAL_HEIGHT / assets:getImage('background'):getHeight())

    love.graphics.setFont(SmallFont)
    love.graphics.setColor(1, 1, 1, 1) 
    if GameState == 'start' then
        love.graphics.printf('Welcome to Tennis Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
    elseif GameState == 'serve' then
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!", 0, 10, VIRTUAL_WIDTH, 'center')
    elseif GameState == 'done' then
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to Restart', 0, 30, VIRTUAL_WIDTH, 'center')
    end

    love.graphics.setFont(ScoreFont)
    love.graphics.setColor(1, 1, 0, 1)
    love.graphics.print(tostring(Player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(Player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    Player1:render()
    Player2:render()
    Ball:render()

    displayFPS()
    displayBallSpeed()
    love.graphics.setColor(1, 1, 1, 1)
    Push:finish()
end

function displayFPS()
    love.graphics.setFont(SmallFont)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
    love.graphics.setColor(1, 1, 1, 1)
end

function displayBallSpeed()
    love.graphics.setFont(SmallFont)
    love.graphics.setColor(1, 1, 0, 1)
    love.graphics.print('Ball Speed: ' .. tostring(BALL_SPEED) .. ' (' .. BALL_SPEED_MIN .. '-' .. BALL_SPEED_MAX .. ')', 10, 25)
    love.graphics.print('+/- to change, 0 to reset', 10, 40)
    love.graphics.setColor(1, 1, 1, 1)
end
