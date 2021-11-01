local JoyStick = {}

class_mt = {
    __call = function(self, x, y, radious, max_vel, color)
        local t = {}
        local Vector = require("vector")

        t.x = x
        t.y = y
        t.max_vel = max_vel
        t.r1 = radious 
        t.r2 = 9 * radious / 20
        
        t.rgb = {}
        
        t.sec_surf_color = {}
        t.jointCirc = {radious = 12 * t.r2 / 20, color = {}, coors = {x=t.x, y=t.y}}
        
        for k,v in pairs(color) do
            t.sec_surf_color[k] =  (6*v / 6) / 2 --dark
            t.jointCirc.color[k] = (9*v / 6) / 2  --medium
            t.rgb[k] = (10*v / 6) / 2             --light
        end
        
        t.rgba = {t.rgb[1], t.rgb[2], t.rgb[3], 0.3}
        
        t.diagonal = radious / math.sqrt(2)
        t.max_displacement = t.r1 - t.r2
        t.touch_reach_len = 5 * t.max_displacement

        --------- INSTANCE METHODS        

        function t.is_reachable(self, x, y)
            local D = Vector(self.x, self.y, x, y)
            if D.displacement < self.touch_reach_len then
                return true
            else
                return false
            end
        end

        
        -- LOVE.UPDATE(DT)
        function t.love_touchpressed(self, x, y, id)
            if self:is_reachable(x,y) then
                self.touch_id = id
            end
        end
        
        t.paddle_x, t.paddle_y = t.x, t.y
        t.current_velocity = {x=0, y=0}
        function t.love_touchmoved(self, x, y, id)
            if self.touch_id ~= id then
                return
            end

            local joy_vel = Vector(self.x, self.y, x, y)
    
            if (joy_vel.displacement <= self.max_displacement) then
                -- pos of main two joystick parts
                self.current_velocity.x = self.max_vel * (joy_vel.dx / self.max_displacement)
                self.current_velocity.y = self.max_vel * (joy_vel.dy / self.max_displacement)
                self.paddle_x, self.paddle_y = x, y
                -- pos of two secondary joystick parts
                self.jointCirc.coors.x = self.x + self.jointCirc.radious * (joy_vel.dx / t.r2)
                self.jointCirc.coors.y = self.y + self.jointCirc.radious * (joy_vel.dy / t.r2)
                
            elseif (joy_vel.displacement < self.touch_reach_len) then
                -- pos of main two joystick parts
                self.current_velocity.x = self.max_vel * (joy_vel.dx / joy_vel.displacement) 
                self.current_velocity.y = self.max_vel * (joy_vel.dy / joy_vel.displacement)
                self.paddle_x = self.x + self.max_displacement * (joy_vel.dx / joy_vel.displacement)
                self.paddle_y = self.y + self.max_displacement * (joy_vel.dy / joy_vel.displacement)
                -- pos of two secondary joystick parts
                self.jointCirc.coors.x = self.x + self.jointCirc.radious * (joy_vel.dx / joy_vel.displacement)
                self.jointCirc.coors.y = self.y + self.jointCirc.radious * (joy_vel.dy / joy_vel.displacement)
                
            else
                -- pos of main two joystick parts
                self.current_velocity.x, self.current_velocity.y = 0,0
                self.paddle_x, self.paddle_y = self.x, self.y
                -- pos of two secondary joystick parts
                self.jointCirc.coors.x, self.jointCirc.coors.y = self.x, self.y
    
            end
        end

        function t.love_touchreleased(self, x, y)
            if self:is_reachable(x,y) then
                self.current_velocity.x, self.current_velocity.y = 0,0
                self.paddle_x, self.paddle_y = self.x, self.y
                self.jointCirc.coors = {x=self.x, y=self.y}
            end
        end
        --

        -- LOVE:DRAW()
        function t.draw(self)
            love.graphics.stencil(function()
                -- Draw a small circle as a stencil. This will be the hole.
                love.graphics.setColor(0,0,0,1) -- "transparent" separation
                love.graphics.circle("fill", self.x, self.y, 11 * self.r1 / 20, 100)
            end,
            "replace", 1)
       
            -- Configure the stencil test to only allow rendering on pixels whose stencil value is equal to 0.
            -- This will end up being every pixel *except* ones that were touched by the circle drawn as a stencil.
            love.graphics.setStencilTest("equal", 0)
            
            love.graphics.setColor(self.rgba) -- the main base surface
            love.graphics.circle("fill", self.x, self.y, self.r1, 100)
            -- love.graphics.circle("line", self.x, self.y, self.r1)
            love.graphics.setStencilTest()
            
            ---- "transparent" lines across base surface
            -- love.graphics.setColor()
            -- love.graphics.line(self.x + t.diagonal, self.y + t.diagonal, self.x - t.diagonal, self.y - t.diagonal)
            -- love.graphics.line(self.x + t.diagonal, self.y - t.diagonal, self.x - t.diagonal, self.y + t.diagonal)
            

            love.graphics.setColor(self.sec_surf_color) -- secondary base surface
            love.graphics.circle("fill", self.x, self.y, 7 * self.r1 / 20, 100)

            love.graphics.setColor(self.jointCirc.color) -- joint circle
            love.graphics.circle("fill", self.jointCirc.coors.x, self.jointCirc.coors.y, self.jointCirc.radious, 100)

            love.graphics.setColor(self.rgb) -- main paddle circle
            love.graphics.circle("fill", self.paddle_x, self.paddle_y, self.r2, 100)
            -- love.graphics.setColor(0,0,0)
            -- love.graphics.circle("line", self.paddle_x, self.paddle_y, self.r2, 100)

        end
        --
        

        instance_mt = {
            __call = function(self) print("called instance") end
        }
        setmetatable(t, instance_mt)
        return t
    end
}

setmetatable(JoyStick, class_mt)

return JoyStick
