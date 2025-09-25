Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dx = math.random(2) == 1 and BALL_SPEED or -BALL_SPEED
    self.dy = math.random(-60, 60)
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dx = math.random(2) == 1 and BALL_SPEED or -BALL_SPEED
    self.dy = math.random(-50, 50)
end

function Ball:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle('fill', self.x + self.width/2, self.y + self.height/2, self.width/2)
    
    -- Add tennis ball line
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.arc('line', self.x + self.width/2, self.y + self.height/2, self.width/2, 0, math.pi)
    love.graphics.line(self.x, self.y + self.height/2, self.x + self.width, self.y + self.height/2)
    
    love.graphics.setColor(1, 1, 1, 1)
end

function Ball:collides(paddle)
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end

    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end
    return true
end