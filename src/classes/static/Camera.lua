-- Static class for the Camera functionality; only intended to be one instance
-- Drawable items intended to use this to decide all drawable offsets

require "classes/Vector"

Camera = {
  offset = {
    x = 0,
    y = 0
  },
  easing = {
    duration = 1.2,
    maxDistPx = 200
  }
}

-- ** Public API **

function Camera:move(x, y)
  self.offset.x, self.offset.y = self:_getOffsetsAt(x, y)
end

function Camera:moveEased(x, y, dt)
  self.offset.x, self.offset.y =  self:_getEasedOffsetsAt(x, y, dt)
end

function Camera:getMousePosition(scale)
  rawMouseX, rawMouseY = love.mouse.getPosition()
  return rawMouseX / scale + self.offset.x,
         rawMouseY / scale + self.offset.y
end

-- ** Private Utility Methods **

-- Get a single eased offset coordinate
function Camera:_getEasedCoord (newCoord, oldCoord, dt)
  local dist = oldCoord - newCoord

  -- Find the current Y ease graph value
  -- Pertains to 0-1 distance from new point, where 1 is the largest possible distance
  local adjustedDist = math.abs(dist) / self.easing.maxDistPx

  -- Use Y to get the X ease graph value
  -- Pertains to 0-1 animation progress, where 1 is animation finish
  local animProgress = self:_easeMethodInverse(adjustedDist)

  -- Apply time change to the animation to find the next animation progress
  local nextAnimProgress = animProgress + dt / self.easing.duration

  -- Apply the animation progress (X) to get the new distance (Y) from the coord
  -- Convert back to pixels by re-incorporating the max PX
  local easedDist = self:_easeMethod(nextAnimProgress) * self.easing.maxDistPx

  return newCoord + easedDist * (dist >= 0 and 1 or -1)
end

-- Get the x, y offsets to shift all items in order to center on given x, y
function Camera:_getOffsetsAt(x, y)
  -- TODO: Could store the /2 variables for higher efficiency
  local xOffset = x - love.window.scaledWidth / 2
  local yOffset = y - love.window.scaledHeight / 2

  return xOffset, yOffset
end

function Camera:_getEasedOffsetsAt(x, y, dt)
  -- Find current X on ease graph
  local xOffset, yOffset = self:_getOffsetsAt(x, y)
  local easedXOffset = self:_getEasedCoord(xOffset, self.offset.x, dt)
  local easedYOffset = self:_getEasedCoord(yOffset, self.offset.y, dt)

  return easedXOffset, easedYOffset
end

-- y = (1 - x)^4
-- y = distance to real coord, 0 = no distance, 1 = max distance
-- x = animation progress, 0 = beginning, 1 = end
function Camera:_easeMethod (x)
  if x >= 1 then
    return 0
  elseif x <= 0 then
    return 1
  else
    return math.pow(1 - x, 4)
  end
end

-- y = (1 - x)^4
-- (4th root y) = 1 - x
-- x = 1 - (4th root y)
function Camera:_easeMethodInverse (y)
  if y >= 1 then
    return 0
  elseif y <= 0 then
    return 1
  else
    return 1 - utils.nRoot(y, 4)
  end
end

