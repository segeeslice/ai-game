require "classes/Player"

-- ** Global Definitions **
PLAYER = Player:new()

-- ** Love callbacks **

function love.load()
  love.window.setMode(0, 0, {
    resizable = true,
    minwidth = 800,
    minheight = 600
  })
  math.randomseed(os.time())

  love.resize(love.graphics.getDimensions())
end

-- Width & height aren't default love variables, but this
-- allows for less function calls as opposed to getDimensions()
function love.resize(w, h)
  love.window.width, love.window.height = w, h
end

-- World is a grid, currently the size of the window
function love.draw()
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
  inc = 32

  love.graphics.setLineWidth(3)
  love.graphics.setColor(.35, .35, .35)

  x = 0
  while x < w do
    love.graphics.line(x, 0, x, h)
    x = x + inc
  end

  y = 0
  while y < h do
    love.graphics.line(0, y, w, y)
    y = y + inc
  end
end
