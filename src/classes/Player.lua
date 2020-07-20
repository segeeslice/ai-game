--[[
  Class that defines the player character. Coordinates based at the center of the
  player's feet, for (hopefully) easier calculations later on.

  e.g.
  _____
  |   |
  |   |
  --X--
--]]

require "classes/Vector"

-- ** Class definition **

Player = {}

function Player:draw()
  love.graphics.setColor(.8, .2, .2)
  -- print(self.x, self.y, self.width, self.height)
  love.graphics.rectangle('fill',
                          self.x - self.width/2,
                          self.y - self.height,
                          self.width,
                          self.height)
end

function Player:move(dt)
  self.velocity:reset()

  -- TODO: Generalize player keys in a configurable way
  if (love.keyboard.isDown('left')) then
    self.velocity.x = self.velocity.x - 1
  end
  if (love.keyboard.isDown('right')) then
    self.velocity.x = self.velocity.x + 1
  end

  if (love.keyboard.isDown('up')) then
    self.velocity.y = self.velocity.y - 1
  end
  if (love.keyboard.isDown('down')) then
    self.velocity.y = self.velocity.y  + 1
  end

  self.velocity:normalize()

  self.x = self.x + self.velocity.x * self.speed * dt
  self.y = self.y + self.velocity.y * self.speed * dt
end

function Player:new(arg)
  arg = arg or {}

  local p = {
    x = arg.x or 0,
    y = arg.y or 0,
    width = 32,
    height = 64,
    speed = 128, -- Units/sec
    velocity = Vector:new()
  }

  return setmetatable(p, { __index = self })
end
