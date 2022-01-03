local Ball = {}

class_mt = {
    __call = function (self, radius, x_vel, color)
        local t = {}
        local Vector = require("vector")
        t.Sound = require("sound")
        
        local sign_table = {1, -1}
        math.randomseed(os.time())
        local sign = sign_table[math.random(1,2)]

        t.screenWidth = love.graphics.getWidth()
        t.screenHeight = love.graphics.getHeight()


        t.x = t.screenWidth/2 + sign*100
        t.y = t.screenHeight/2
        t.radius = radius
        
        t.mass = math.pi * radius^2
        t.vel= {x=0, y=0}
        
        t.color = color
        
        t.left_points = 0
        t.right_points = 0
        
        
        -- self.Sound EFFECTS
        t.Sound:init("player_coll", "sfx/player_collision.wav", "static")
        t.Sound:init("point_made", "sfx/point_made.wav", "static")
        t.Sound:init(
            "wall_coll", 
            {"sfx/wall_collision.wav", "sfx/wall_collision2.wav", "sfx/wall_collision3.wav"},
             "static"
        )


        function sign(x)
            if x < 0 then return -1 else return 1 end
        end
        
        --------- INSTANCE METHODS
        -- LOVE.UPDATE(DT)

        function t.check_ball_collision(self, players, dt)
            for i, player in ipairs(players) do
                if not player.id then goto continue end
                
                local dx = ball.x - player.x
                local dy = ball.y - player.y
                local d = math.sqrt( dx^2 + dy^2 )
                local dist_mod = (self.radius + player.rad)
                
                if d < dist_mod  then
                    local dist_ang = math.atan2(dy, dx)
                    local player_vel_mod = math.sqrt(player.vel.x^2 + player.vel.y^2)

                    self.Sound:play("player_coll", "sfx", 0.7)
                    self.x = player.x + dist_mod*math.cos(dist_ang)
                    self.y = player.y + dist_mod*math.sin(dist_ang)
                    local newVelX = player_vel_mod*math.cos(dist_ang)
                    local newVelY = player_vel_mod*math.sin(dist_ang)
                    self.vel.x = (newVelX*self.mass)/player.mass
                    self.vel.y = (newVelY*self.mass)/player.mass
                end

                ::continue::
            end
        end

        function t.update_ball_pos(self, dt)
            self.x = self.x + self.vel.x * dt 
            self.y = self.y + self.vel.y * dt

            if self.x - self.radius < 0 then
                self.Sound:play("point_made", "sfx", 1)
                self.x, self.y = self.screenWidth/2 - 100, self.screenHeight/2
                self.vel = {x=0, y=0}
                self.right_points = self.right_points + 1
            elseif self.x + self.radius > self.screenWidth then
                self.Sound:play("point_made", "sfx", 1)
                self.x, self.y = self.screenWidth/2 + 100, self.screenHeight/2
                self.vel = {x=0, y=0}
                self.left_points = self.left_points + 1
            end

            if self.y - self.radius < 0 then 
                self.Sound:play("wall_coll", "sfx", 0.7)
                self.y = self.radius
                self.vel.y = -self.vel.y
            elseif self.y + self.radius > self.screenHeight then
                self.Sound:play("wall_coll", "sfx", 0.7)
                self.y = self.screenHeight - self.radius
                self.vel.y = -self.vel.y
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
