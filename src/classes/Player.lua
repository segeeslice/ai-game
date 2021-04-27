
require "classes/Vector"
require "classes/inherit"
require "classes/Actor"

-- ** Class definition **

Player = inherit.from(Actor)

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

  self.super.move(self, dt)
end

function Player:new(arg)
  parentInstance = self.super:new(arg)
  return setmetatable(parentInstance, { __index = self })
end
