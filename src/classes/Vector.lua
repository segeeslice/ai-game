--{
--Vector
--  x = Num
--  y = Num
--
--  new{x (opt), y(opt)}
--}

require "utils"

Vector = {}

function Vector:reset()
  self.x = 0
  self.y = 0
end

function Vector:divide (scalar)
  self.x = self.x / scalar
  self.y = self.y / scalar
end

function Vector:getMagnitude ()
  return math.sqrt(math.pow(self.x, 2), math.pow(self.y, 2))
end

function Vector:scaleToMagnitude (val)
  local mag = self:getMagnitude()
  if mag > 0 then
    self.x = self.x / mag * val
    self.y = self.y / mag * val
   end
end

function Vector:normalize ()
  self:scaleToMagnitude(1)
end

function Vector:new (arg)
  arg = arg or {}

  local vect = {
    x = arg.x or 0,
    y = arg.y or 0
  }

  return setmetatable(vect, { __index = self })
end
