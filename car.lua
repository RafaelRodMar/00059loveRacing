car = {}

car_mt = { __index = car }

function car:new(name, tex, x, y, sp)
    local entity = {}
    setmetatable(entity, car_mt)
    
    entity.name = name
    entity.texture = tex
    entity.posx = x
    entity.posy = y
    entity.speed = sp
    entity.angle = 0.0
    entity.n = 1
    entity.color = {1,1,1,1}

    return entity
end

function car:update(dt)

    --car movement
    if (love.keyboard.isDown('up') and self.speed < maxSpeed) then
        if (self.speed < 0) then
            self.speed = self.speed + dec
        else
            self.speed = self.speed + acc
        end
    end

    if (love.keyboard.isDown('down') and self.speed > -maxSpeed) then
        if (self.speed > 0) then
            self.speed = self.speed - dec
        else
            self.speed = self.speed - acc
        end
    end

    if (not love.keyboard.isDown('up') and not love.keyboard.isDown('down')) then
        if (self.speed - dec > 0) then
            self.speed = self.speed - dec
        else 
            if (self.speed + dec < 0) then
                self.speed = self.speed + dec
            else
                self.speed = 0
            end
        end
    end

    if (love.keyboard.isDown('right') and self.speed ~= 0) then self.angle = self.angle + turnSpeed * self.speed/maxSpeed end
    if (love.keyboard.isDown('left') and self.speed ~= 0) then self.angle = self.angle - turnSpeed * self.speed/maxSpeed end

    self.posx = self.posx + math.sin(self.angle) * self.speed * dt
    self.posy = self.posy - math.cos(self.angle) * self.speed * dt
end

function car:findTarget(dt)
    local tx= points[self.n][1]
    local ty= points[self.n][2]
    local beta = self.angle - math.atan2(tx - self.posx,-ty + self.posy)
    if math.sin(beta)<0 then
        self.angle = self.angle + 0.005 * self.speed * dt
    else 
        self.angle = self.angle - 0.005 * self.speed * dt
    end

    if ((self.posx - tx)*(self.posx - tx)+(self.posy - ty)*(self.posy - ty) < 25*25) then 
        self.n = (self.n + 1) % 9 -- 8 checkpoints (from 1 to 8)
        if self.n == 0 then self.n = 1 end
    end

    self.posx = self.posx + math.sin(self.angle) * self.speed * dt
    self.posy = self.posy - math.cos(self.angle) * self.speed * dt
end

function car:draw()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.texture, self.posx - offsetX, self.posy - offsetY, self.angle, 1, 1, 22, 22) -- scale 1, rotation anchor point 22,22
end
