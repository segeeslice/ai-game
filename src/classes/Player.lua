--[
--An Actor specifically for the player-controlled character
--Acts as any other actor but additionally captures keyboard inputs
--
--TODO: Could probably be made static?
--TODO: Generalize player keys in an easily configurable way
--]

require "classes/Vector"
require "classes/inherit"
require "classes/Actor"

-- ** Class definition **

Player = inherit.from(Actor)

function Player:move(dt)
  self.velocity:reset()

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
  arg = arg or {}

  local instance = {
    color = arg.color or { .8, .2, .2 },
    width = arg.width or CONFIG.unitSize,
    height = arg.height or CONFIG.unitSize * 2,
    speed = arg.speed or CONFIG.unitSize * 4, -- Units/sec
  }

  parentInstance = self.super:new(instance)
  return setmetatable(parentInstance, { __index = self })
end
