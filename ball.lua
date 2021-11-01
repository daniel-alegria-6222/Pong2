local Ball = {}

class_mt = {
    __call = function (self, x, y, radius, x_vel, color)
        local t = {}
        local Vector = require("vector")
        local Sound = require("sound")
        
        t.x0 = x or 0
        t.y0 = y or 0
        t.x = x or 0
        t.y = y or 0
        t.radius = radius
        
        local ac_dir_table = {1, -1}
        math.randomseed(os.time())
        local sign = ac_dir_table[math.random(1,2)]
        t.vel_y0 = 0 
        t.vel_x0 = x_vel * sign -- 1 or -1
        t.h_acc = 2 * sign
        t.const_num = 0.001306 * sign
        
        t.color = color
        
        t.left_points = 0
        t.right_points = 0
        
        t.screenWidth = love.graphics.getWidth()
        t.screenHeight = love.graphics.getHeight()
        
        -- SOUND EFFECTS
        Sound:init("player_coll", "sfx/player_collision.wav", "static")
        Sound:init("point_made", "sfx/point_made.wav", "static")
        Sound:init(
            "wall_coll", 
            {"sfx/wall_collision.wav", "sfx/wall_collision2.wav", "sfx/wall_collision3.wav"},
             "static"
        )


        --------- INSTANCE METHODS
        -- LOVE.UPDATE(DT)

        function t.update_ball_pos(self, dt, left_player, right_player)
            Sound:update() -- And update Sound
            self.vel_x0 = self.vel_x0 + self.h_acc * dt
            self.x = self.x + self.vel_x0*dt + t.const_num * dt^2
            self.y = self.y + self.vel_y0 * dt
            
            local a = (self.x + self.radius > left_player.x)
            local b = (self.x - self.radius < left_player.x + left_player.width)
            local c = (self.y + self.radius > left_player.y)
            local d = (self.y - self.radius < left_player.y + left_player.height)
            
            local e = (self.x + self.radius > right_player.x)
            local f = (self.x - self.radius < right_player.x + right_player.width)
            local g = (self.y + self.radius > right_player.y)
            local h = (self.y - self.radius < right_player.y + right_player.height)
            
            -- local left_vel_vector = Vector()
            -- local right_vel_vector = Vector()
            math.randomseed(os.time())
            
            -- X VELOCITY AND POS
            if a and b and c and d then
                Sound:play("player_coll", "sfx", 0.7)
                self.x = left_player.x + left_player.width + self.radius
                self.vel_x0 = -self.vel_x0
                self.h_acc = -self.h_acc
                self.const_num = -self.const_num
                --
                self.vel_y0 = self.vel_y0 + left_player.y_vel
                
            elseif e and f and g and h then
                Sound:play("player_coll", "sfx", 0.7)
                self.x = right_player.x - self.radius
                self.vel_x0 = -self.vel_x0
                self.h_acc = -self.h_acc
                self.const_num = -self.const_num
                --
                self.vel_y0 = self.vel_y0 + right_player.y_vel
            end
            
            if self.x < 0 then
                Sound:play("point_made", "sfx", 1)
                self.x, self.y = self.x0, self.y0
                self.vel_x0 = -self.vel_x0
                self.vel_y0 = 0
                self.h_acc = -self.h_acc
                self.const_num = -self.const_num
                self.right_points = self.right_points + 1
            elseif self.x > self.screenWidth - self.radius then
                Sound:play("point_made", "sfx", 1)
                self.x, self.y = self.x0, self.y0
                self.vel_x0 = -self.vel_x0
                self.vel_y0 = 0
                self.h_acc = -self.h_acc
                self.const_num = -self.const_num
                self.left_points = self.left_points + 1
            end
            
            -- Y VELOCITY AND POS
            
            if self.y < 0 then 
                Sound:play("wall_coll", "sfx", 0.7)
                self.vel_y0 = -self.vel_y0
            elseif self.y > self.screenHeight - self.radius then
                Sound:play("wall_coll", "sfx", 0.7)
                self.vel_y0 = -self.vel_y0
            end
            
        end
        --
        
        
        -- LOVE:DRAW()
        function t.draw(self)
            love.graphics.setColor(self.color)
            love.graphics.circle("fill", self.x, self.y, self.radius, 100)
        end
        --
        

        instance_mt = {
            __call = function(self) print("called instance") end
        }
        setmetatable(t, instance_mt)
        return t
    end
}

setmetatable(Ball, class_mt)

return Ball
