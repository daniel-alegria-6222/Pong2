

local Ball = require("ball")
local Players = require("players")

-- RELATED FUNCTIONS
function loveRGB(r,g,b,a)
   return {r/225, g/225, b/225, a}
end

-- CONSTANS
local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()
local screenBackground = loveRGB(225,225,225)
local color1 = loveRGB(34,139,34)
local color2 = loveRGB(128,0,0)

------ LOVE SPECIFIC
-- FIRST
function love.load()

   -- FPS CAP
   min_dt = 1/60
   next_time =love.timer.getTime()
   
   -- Load some stuff
   radious = 50
   const = 20
   x, y = radious, screenHeight - radious - const

   velocity = 700
   local r = 50
   Players:add(1, r, color1, "left")
   Players:add(2, r, color2, "right")

   ball = Ball(20, 500, loveRGB(65,105,225))

   font_big = love.graphics.newFont(30)
   
   
end

-- SECOND
function love.update(dt)
   next_time = next_time + min_dt -- FPS CAP


   ball.Sound:update()
   ball:update_ball_pos(dt)
   ball:check_ball_collision(Players.players, dt)

   -- Players:update(dt) 
end

--
function love.touchpressed(id, x, y, dx, dy, pressure)
   Players:love_touchpressed(x,y, id) 
end

function love.touchmoved(id, x, y, dx, dy, pressure)
   Players:love_touchmoved(x,y, dx,dy, id)
   
end

function love.touchreleased(id, x, y, dx, dy, pressure)
   Players:love_touchreleased(id)

end

-- THIRD
function love.draw()
   
   love.graphics.setBackgroundColor(screenBackground)
   
   -- Each pixel touched by the circle will have its stencil value set to 1. The rest will be 0.
   
   Players:draw()
   
   ball:draw()
   
   -- Points
   love.graphics.setColor(color1[1]/2, color1[2]/2, color1[3]/2)
   love.graphics.setFont(font_big)
   love.graphics.print(tostring(ball.left_points), screenWidth/2 - 50, 25)

   love.graphics.setColor(color2[1]/2, color2[2]/2, color2[3]/2)
   love.graphics.setFont(font_big)
   love.graphics.print(tostring(ball.right_points), screenWidth/2 + 50, 25)
   --

   love.graphics.line(0,30,love.graphics.getWidth(),30)
   love.graphics.line(30,0,30,love.graphics.getHeight())

   --------
   j=0
   for i, player in ipairs(Players.players) do
      love.graphics.setColor(unpack(player.col))
      j = j + 30
      love.graphics.print(player.vel.x, 30, j)
      j = j + 30
      love.graphics.print(player.vel.y, 30, j)
   end

   -- FPS CAP
   local cur_time = love.timer.getTime()
   if next_time <= cur_time then return end
   love.timer.sleep(next_time - cur_time)

end