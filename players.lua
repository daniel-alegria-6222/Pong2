local Players = {

    players = {},
    screenWidth = love.graphics.getWidth(),
    screenHeight = love.graphics.getHeight(),
    
    add = function (self, num, radius, color, side)
        self.players[num] = {
            rad=radius,
            col=color,
            side=side,
            id=nil, x=nil, y=nil,
            mass = math.pi * radius^2,
            vel={x=0, y=0},
        }
    end,

    whichSide = function(self, x)
        if x < self.screenWidth/2 then return "left" else return "right" end
    end,

    -- LOVE.UPDATE(DT)
    update = function(self, dt)
        for i,player in ipairs(self.players) do
            player.vel = {x=player.vel.x*dt, y=player.vel.y*dt}
        end
    end,

    love_touchpressed = function(self, x, y, id)
        for i,player in ipairs(self.players) do
            if (player.id == nil) and (player.side == self:whichSide(x)) then
                player.id = id
                player.x = x
                player.y = y
                player.vel = {x=0, y=0}
                break
            end
        end
    end,
    
    love_touchmoved = function(self, x, y, dx, dy, id)
        for i,player in ipairs(self.players) do
            if player.id ~= id  then goto continue end
            if player.side ~= self:whichSide(x) then player.id = nil end
            
            player.x = x
            player.y = y
            player.vel = {x=dx, y=dy}
            
            ::continue::
        end
    end,
    
    love_touchreleased = function(self, id)
        for i,player in ipairs(self.players) do
            if player.id == id then player.id = nil end
            player.vel = {x=0, y=0}
        end
    end,
    --
    
    -- LOVE:DRAW()
    draw = function(self)
        for i,player in ipairs(self.players) do
            if not player.id then goto continue end
            love.graphics.setColor(player.col)
            love.graphics.circle("fill", player.x, player.y, player.rad, 50)
            ::continue::
        end
    end,
}

return Players
