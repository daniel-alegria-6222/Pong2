

local Ball = require("ball")
local Player = require("player")
local JoyStick = require("joystick")

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
   radious = 50
   const = 20
   x, y = radious, screenHeight - radious - const

   velocity = 700

   left_joystick = JoyStick(x + const, y, radious, velocity, color1)
   right_joystick = JoyStick(screenWidth - x - const, y, radious, velocity, color2)

   left_player = Player(30, screenHeight/2 - 50, 30, 100, color1)
   right_player = Player(screenWidth - 30 - 30, screenHeight/2 -50, 30, 100, color2)

   ball = Ball(screenWidth/2, screenHeight/2, 20, 500, loveRGB(65,105,225))

   font_big = love.graphics.newFont(30)
   
   
end

-- SECOND
function love.update(dt)
   left_player:update_player_pos(dt, left_joystick.current_velocity)
   right_player:update_player_pos(dt, right_joystick.current_velocity)
   -- ball:check_player_collision()
   ball:update_ball_pos(dt, left_player, right_player)
end

--
function love.touchpressed(id, x, y, dx, dy, pressure)
   left_joystick:love_touchpressed(x,y,id) 
   right_joystick:love_touchpressed(x,y,id)
end

function love.touchmoved(id, x, y, dx, dy, pressure)
   left_joystick:love_touchmoved(x,y,id)
   right_joystick:love_touchmoved(x,y,id)
   
end

function love.touchreleased(id, x, y, dx, dy, pressure)
   left_joystick:love_touchreleased(x,y)
   right_joystick:love_touchreleased(x,y)

end

-- THIRD
function love.draw()
   
   love.graphics.setBackgroundColor(screenBackground)
   
   -- Each pixel touched by the circle will have its stencil value set to 1. The rest will be 0.
   
   left_player:draw()
   right_player:draw()
   
   left_joystick:draw()
   right_joystick:draw()
   
   ball:draw()
   
   -- Points
   love.graphics.setColor(color1[1]/2, color1[2]/2, color1[3]/2)
   love.graphics.setFont(font_big)
   love.graphics.print(tostring(ball.left_points), screenWidth/2 - 50, 40)

   love.graphics.setColor(color2[1]/2, color2[2]/2, color2[3]/2)
   love.graphics.setFont(font_big)
   love.graphics.print(tostring(ball.right_points), screenWidth/2 + 50, 40)
   --

end