require "classes/Player"

-- ** Global Definitions **
PLAYER = nil
CONFIG = {
  unitSize = 32, -- Number of pixels in one game "unit"
  windowUnitWidth = 16, -- Number of units to keep the game screen wide
  windowUnitHeight = 8, -- ^ but height
  scale = 1, -- Scale for all drawn pixels
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
end

-- ** Util methods **

function drawGrid()
  w = love.window.width
  h = love.window.height

  love.graphics.setLineWidth(3)
  love.graphics.setColor(.35, .35, .35)

  x = 0
  while x < w do
    love.graphics.line(x, 0, x, h)
    x = x + CONFIG.unitSize
  end

  y = 0
  while y < h do
    love.graphics.line(0, y, w, y)
    y = y + CONFIG.unitSize
  end
end
