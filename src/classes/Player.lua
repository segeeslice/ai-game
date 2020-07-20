--[[
  Class that defines the player character. Coordinates based at the center of the
  player's feet, for (hopefully) easier calculations later on.

  e.g.
  _____
  |   |
  |   |
  --X--
--]]

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
  xMove, yMove = 0, 0

  if (love.keyboard.isDown('left')) then
    print('left')
    xMove = xMove - 1
  end
  if (love.keyboard.isDown('right')) then
    print('right')
    xMove = xMove + 1
  end

  if (love.keyboard.isDown('up')) then
    print('up')
    yMove = yMove - 1
  end
  if (love.keyboard.isDown('down')) then
    print('down')
    yMove = yMove + 1
  end

  print(dt)
  print(self.x, self.y)

  -- TODO: Normalize via vector
  self.x = self.x + xMove * self.speed * dt
  self.y = self.y + yMove * self.speed * dt
end

function Player:new(arg)
  arg = arg or {}

  local p = {
    x = arg.x or 0,
    y = arg.y or 0,
    width = 32,
    height = 64,
    speed = 128 -- Units/sec
  }

  return setmetatable(p, { __index = self })
end
