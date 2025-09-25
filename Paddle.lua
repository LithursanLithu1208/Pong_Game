Paddle = Class{}

function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
end

function Paddle:update(dt)
    self.y = self.y + self.dy * dt

    if self.y < 0 then
        self.y = 0
    elseif self.y > VIRTUAL_HEIGHT - self.height then
        self.y = VIRTUAL_HEIGHT - self.height
    end
end

function Paddle:render()
    love.graphics.draw(assets:getImage('paddle'), self.x, self.y, 0, self.width / assets:getImage('paddle'):getWidth(), self.height / assets:getImage('paddle'):getHeight())
end
