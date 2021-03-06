require "classes/Player"
require "classes/static/Camera"

-- ** Global Definitions **
PLAYER = nil
CONFIG = {
  unitSize = 32, -- Number of pixels in one game "unit"
  windowUnitWidth = 16, -- Number of units to keep the game screen wide
  windowUnitHeight = 8, -- ^ but height
  scale = 1, -- Scale for all drawn pixels
}

ACTORS = {}

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
  ACTOR1 = Actor:new()
  ACTORS = {PLAYER, ACTOR1}
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

  love.window.scaledWidth = love.window.width / CONFIG.scale
  love.window.scaledHeight = love.window.height / CONFIG.scale
end

-- World is a grid, currently the size of the window
function love.draw()
  love.graphics.scale(CONFIG.scale, CONFIG.scale)

  -- Define offset of all graphics, controlling our "Camera"
  -- Not sure why these need to be negative...
  love.graphics.translate(-Camera.offset.x, -Camera.offset.y)

  drawGrid()
  for i, actor in ipairs(ACTORS) do
    actor:draw()
  end
end

function love.update(dt)
  PLAYER:move(dt)
  Camera:moveEased(PLAYER.x, PLAYER.y, dt)
end

-- ** Util methods **

function drawGrid()
  w = love.window.width
  h = love.window.height

  love.graphics.setLineWidth(3)
  love.graphics.setColor(.35, .35, .35)

  -- x = -Camera.offset.x
  x = 0
  while x < w do
    love.graphics.line(x, 0, x, h)
    x = x + CONFIG.unitSize
  end

  -- y = -Camera.offset.y
  y = 0
  while y < h do
    love.graphics.line(0, y, w, y)
    y = y + CONFIG.unitSize
  end
end

