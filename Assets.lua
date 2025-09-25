Assets = Class{}

function Assets:init()
    self.images = {}
    self.sounds = {}
    self:loadAssets()
end

function Assets:loadAssets()
    self.images.background = love.graphics.newImage('assets/table.jpg')
    self.images.paddle = love.graphics.newImage('assets/pad.jpg')
    self:createSounds()
end

function Assets:createSounds()
    local sampleRate = 44100
    local duration = 0.1

    local paddleHitData = love.sound.newSoundData(sampleRate * duration, sampleRate, 16, 1)
    for i = 0, paddleHitData:getSampleCount() - 1 do
        local t = i / sampleRate
        local frequency = 800
        local amplitude = 0.3 * math.exp(-t * 10)
        local sample = amplitude * math.sin(2 * math.pi * frequency * t)
        paddleHitData:setSample(i, sample)
    end
    self.sounds.paddleHit = love.audio.newSource(paddleHitData)

    local scoreData = love.sound.newSoundData(sampleRate * 0.3, sampleRate, 16, 1)
    for i = 0, scoreData:getSampleCount() - 1 do
        local t = i / sampleRate
        local frequency = 200 + t * 400
        local amplitude = 0.4 * math.exp(-t * 3)
        local sample = amplitude * math.sin(2 * math.pi * frequency * t)
        scoreData:setSample(i, sample)
    end
    self.sounds.score = love.audio.newSource(scoreData)
    
    self.sounds.paddleHit:setVolume(0.5)
    self.sounds.score:setVolume(0.5)
end

function Assets:getImage(name)
    return self.images[name]
end

function Assets:playSound(name)
    if self.sounds[name] then
        self.sounds[name]:stop()
        self.sounds[name]:play()
    end
end
