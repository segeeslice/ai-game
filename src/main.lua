require "classes/Player"
require "utils"

-- ** Global Definitions **
PLAYER = nil
CONFIG = {
  unitSize = 32, -- Number of pixels in one game "unit"
  windowUnitWidth = 16, -- Number of units to keep the game screen wide
  windowUnitHeight = 8, -- ^ but height
  scale = 1, -- Scale for all drawn pixels
  camera = {
    xOffset = 0,
    yOffset = 0,
    easing = {
      DURATION = 1.2,
      maxDistPx = 200
    }
  }
}

-- ** Love callbacks **

function love.load()
  love.window.setMode(0, 0, {
    resizable = true,
    minwidth = 800,
    minheight = 600
  })
  math.randomseed(os.time())

  -- Manually trigger resize callback to initialize values
  love.resize(love.graphics.getDimensions())

  PLAYER = Player:new()
end

-- Width & height aren't default love variables, but this
-- allows for less function calls as opposed to getDimensions()
function love.resize(w, h)
  love.window.width, love.window.height = w, h

  -- Try to keep the width consistent automatically. Could probably be
  -- configured via an option later
  -- (windowUnitWidth) units/window = (window width) px/window / (unitSize) px/unit / (scale)
  -- scale = (window width) px/window / (unitSize) px/unit / (windowUnitWidth) units/window
  local wScale = w / CONFIG.unitSize / CONFIG.windowUnitWidth
  local hScale = h / CONFIG.unitSize / CONFIG.windowUnitHeight

  if (wScale <= hScale) then
    CONFIG.scale = wScale
  else
    CONFIG.scale = hScale
  end
end

-- World is a grid, currently the size of the window
function love.draw()
  love.graphics.scale(CONFIG.scale, CONFIG.scale)
  drawGrid()
  PLAYER:draw()
end

function love.update(dt)
  PLAYER:move(dt)
  -- TODO: Smoother camera transition via separate function
  CONFIG.camera.xOffset, CONFIG.camera.yOffset = getEasedCameraOffsets(PLAYER.x,
                                                                       PLAYER.y,
                                                                       CONFIG.camera.xOffset,
                                                                       CONFIG.camera.yOffset,
                                                                       dt)
end

-- ** Util methods **

function drawGrid()
  w = love.window.width
  h = love.window.height

  love.graphics.setLineWidth(3)
  love.graphics.setColor(.35, .35, .35)

  x = -CONFIG.camera.xOffset
  while x < w do
    love.graphics.line(x, 0, x, h)
    x = x + CONFIG.unitSize
  end

  y = -CONFIG.camera.yOffset
  while y < h do
    love.graphics.line(0, y, w, y)
    y = y + CONFIG.unitSize
  end
end

-- Get the x, y offsets to shift all items in order to center on given x, y
function getCameraOffsets(x, y)
  local scaledWidth, scaledHeight = getScaledWindowDimensions()
  -- TODO: Could store the /2 variables for higher efficiency
  local xOffset = x - scaledWidth/ 2
  local yOffset = y - scaledHeight / 2

  return xOffset, yOffset
end

-- Like getCameraOffsets, but use an easing method to not instantly snap into place
function getEasedCameraOffsets(x, y, oldXOffset, oldYOffset, dt)
  -- Find current X on ease graph
  local xOffset, yOffset = getCameraOffsets(x, y)
  local easedXOffset = _getEaseOffset(xOffset, oldXOffset, dt)
  local easedYOffset = _getEaseOffset(yOffset, oldYOffset, dt)

  return easedXOffset, easedYOffset
end

function _getEaseOffset (newCoord, oldCoord, dt)
  local dist = oldCoord - newCoord

  -- Find the current Y ease graph value
  -- Pertains to 0-1 distance from new point, where 1 is the largest possible distance
  local adjustedDist = math.abs(dist) / CONFIG.camera.easing.maxDistPx

  -- Use Y to get the X ease graph value
  -- Pertains to 0-1 animation progress, where 1 is animation finish
  local animProgress = easeMethodInverse(adjustedDist)

  -- Apply time change to the animation to find the next animation progress
  local nextAnimProgress = animProgress + dt / CONFIG.camera.easing.DURATION

  -- Apply the animation progress (X) to get the new distance (Y) from the coord
  -- Convert back to pixels by re-incorporating the max PX
  local easedDist = easeMethod(nextAnimProgress) * CONFIG.camera.easing.maxDistPx

  return newCoord + easedDist * (dist >= 0 and 1 or -1)
end

-- y = (1 - x)^4
function easeMethod (x)
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
function easeMethodInverse (y)
  if y >= 1 then
    return 0
  elseif y <= 0 then
    return 1
  else
    return 1 - utils.nRoot(y, 4)
  end
end


function getScaledWindowDimensions ()
  local scaledWidth = love.window.width / CONFIG.scale
  local scaledHeight = love.window.height / CONFIG.scale
  return scaledWidth, scaledHeight
end
