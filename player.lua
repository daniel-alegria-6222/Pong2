local Player = {}

class_mt = {
    __call = function (self, x, y, width, height, color)
        local t = {}

        t.x = x or 0
        t.y = y or 0
        t.width = width
        t.height = height
        t.color = color
        
        t.x_vel = 0
        t.y_vel = 0

        t.screenWidth = love.graphics.getWidth()
        t.screenHeight = love.graphics.getHeight()

        --------- INSTANCE METHODS
        -- LOVE.UPDATE(DT)
        function t.update_player_pos(self, dt, vel_table)
            self.x_vel, self.y_vel = vel_table.x, vel_table.y
            --self.x = self.x + self.x_vel * dt
            self.y = self.y + self.y_vel * dt

            if self.x < 0 then self.x = 0 
            elseif self.x > self.screenWidth - self.width then
                self.x = self.screenWidth - self.width
            end

            if self.y < 0 then self.y = 0 
            elseif self.y > self.screenHeight - self.height then
                self.y = self.screenHeight - self.height
            end
        end
        --

        
        -- LOVE:DRAW()
        function t.draw(self)
            love.graphics.setColor(self.color)
            love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
        end
        --
        

        instance_mt = {
            __call = function(self) print("called instance") end
        }
        setmetatable(t, instance_mt)
        return t
    end
}

setmetatable(Player, class_mt)

return Player
