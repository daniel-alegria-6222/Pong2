local Vector = {}


class_mt = {
    fun = function()
    end,

    __call = function (self, x0, y0, xf, yf)
        local t = {}

        t.x0 = x0
        t.y0 = y0
        t.xf = xf
        t.yf = yf

        t.dx = t.xf - t.x0 
        t.dy = t.yf - t.y0 

        t.displacement = math.sqrt(t.dx^2 + t.dy^2) 
        

        --------- INSTANCE METHODS
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

setmetatable(Vector, class_mt)

return Vector