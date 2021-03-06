--[
--The Actor class, pertaining to any moveable, collidable object in-game
--Can essentially be the base class for any collision-based object in the future
--
--TODO: Collision handling
--]

require "classes/Vector"
require "classes/inherit"

-- ** Class definition **

Actor = inherit.from(nil)

function Actor:draw()
  -- TODO: make color configurable
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
function Actor:getCornerX() return self.x - self.width/2 end
function Actor:getCornerY() return self.y - self.height end

-- Utilize camera offset to get the drawable X and Y
function Actor:getDrawableX()
  return self:getCornerX()
end
function Actor:getDrawableY()
  return self:getCornerY()
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
  }

  return self:create(instance)
end
