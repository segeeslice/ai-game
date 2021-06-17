--[
--The Actor class, pertaining to any moveable, object in-game
--Can essentially be the base class for any on-screen object in the future
--
--TODO: Collision handling
--]

require "classes/Vector"
require "classes/inherit"

-- ** Class definition **

Actor = inherit.from(nil)

-- _CollidableActors = {}

-- function Actor.ProcessCollisions()
--   -- Temp
--   print(table.getn(_CollidableActors))
-- end

function Actor:draw()
  love.graphics.setColor(unpack(self.color))
  love.graphics.rectangle('fill',
                          self:getDrawableX(),
                          self:getDrawableY(),
                          self.width,
                          self.height)
end

-- Move based on the actor's current velocity and speed
function Actor:move(dt)
  self.x = self.x + self.velocity.x * self.speed * dt
  self.y = self.y + self.velocity.y * self.speed * dt
end

--[[
  Actor XY coordinates based at the center of the player's feet, for
  (hopefully) easier calculations

  e.g.
  _____
  |   |
  |   |
  --X--

  These methods convert back to corner mode for use in drawing
--]]
function Actor:getLeftX() return self.x - self.width/2 end
function Actor:getRightX() return self.x + self.width/2 end
function Actor:getTopY() return self.y - self.height end
function Actor:getBottomY() return self.y end

-- Utilize camera offset to get the drawable X and Y
function Actor:getDrawableX()
  return self:getLeftX()
end
function Actor:getDrawableY()
  return self:getTopY()
end

function Actor:checkCollides(x, y)
  return (
    x > self:getLeftX() and
    x < self:getRightX() and
    y > self:getTopY() and
    y < self:getBottomY())
end

function Actor:new(arg)
  arg = arg or {}

  local instance = {
    x = arg.x or 0,
    y = arg.y or 0,
    color = arg.color or { .4, .4, 1 },
    width = arg.width or CONFIG.unitSize,
    height = arg.height or CONFIG.unitSize * 2,
    speed = arg.speed or CONFIG.unitSize * 4, -- Units/sec
    velocity = Vector:new(),
    allowCollision = arg.allowCollision == nil and false or arg.allowCollision,
  }

  return self:create(instance)
end
