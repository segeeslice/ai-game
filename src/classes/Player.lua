
require "classes/Vector"

-- ** Class definition **

Player = {}

function Player:draw()
  love.graphics.setColor(.8, .2, .2)
  love.graphics.rectangle('fill',
                          self:getDrawableX(),
                          self:getDrawableY(),
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

--[[
  Player XY coordinates based at the center of the player's feet, for
  (hopefully) easier calculations

  e.g.
  _____
  |   |
  |   |
  --X--

  These methods convert back to corner mode for use in drawing
--]]
function Player:getCornerX() return self.x - self.width/2 end
function Player:getCornerY() return self.y - self.height end

-- Utilize camera offset to get the drawable X and Y
function Player:getDrawableX()
  return self:getCornerX() - CONFIG.camera.xOffset
end
function Player:getDrawableY()
  return self:getCornerY() - CONFIG.camera.yOffset
end

function Player:new(arg)
  arg = arg or {}

  local p = {
    x = arg.x or 0,
    y = arg.y or 0,
    width = CONFIG.unitSize,
    height = CONFIG.unitSize * 2,
    speed = CONFIG.unitSize * 4, -- Units/sec
    velocity = Vector:new()
  }

  return setmetatable(p, { __index = self })
end
