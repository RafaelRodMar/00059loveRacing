require("car")

function love.load()
    --variables
    gameWidth = 640
    gameHeight = 480
    love.window.setMode(gameWidth, gameHeight, {resizable=false, vsync=false})
    love.graphics.setBackgroundColor(1,1,1) --white
	
	-- 8 checkpoints
	points = { {300, 610}, {1270,430}, {1380,2380}, {1900,2460}, {1970,1700},
						  {2550,1680}, {2560,3150}, {500, 3300} }

    cartext = love.graphics.newImage("docs/car.png")
    background = love.graphics.newImage("docs/background.png")

    -- create N cars
    N = 5
    cars = {}
    for i=0, N do
        local carx = 300 + i * 50
        local cary = 1700 + i * 80
        local carsp = 7 + i * 50
        local newCar = car:new("car", cartext, carx, cary, carsp)
        table.insert(cars, newCar)
    end

    -- set cars colors
    cars[1].color = {1,0,0,1} -- player is red
    cars[2].color = {0,1,0,1} -- green
    cars[3].color = {0,0,1,1} -- blue
    cars[4].color = {1,0,1,1} -- magenta
    cars[5].color = {0,1,1,1} -- cyan

    -- car data
    speed = 0
    angle = 0
    maxSpeed = 12.0 * 50
    acc = 0.2 * 10
    dec = 0.3 * 10
    turnSpeed = 0.08 / 25
    R = 22 -- radius

    offsetX = 0
    offsetY = 0
end

function love.update(dt)
    cars[1]:update(dt)
    for i=2, N do
        cars[i]:findTarget(dt)
    end

    --collision
    for i=1 , N do
        for j=1, N do
            while(i ~= j) do
                local dx = cars[i].posx - cars[j].posx
                local dy = cars[i].posy - cars[j].posy
                while (dx*dx+dy*dy<4*R*R) do
                    cars[i].posx = cars[i].posx + dx/10.0
                    cars[i].posy = cars[i].posy + dy/10.0
                    cars[j].posx = cars[j].posx - dx/10.0
                    cars[j].posy = cars[j].posy - dy/10.0
                    dx = cars[i].posx - cars[j].posx
                    dy = cars[i].posy - cars[j].posy
                    if (not dx and not dy) then
                        break
                    end
                end
                break
            end
        end
    end
end

function love.draw()
    love.graphics.setBackgroundColor(0.5,0.5,0.5)
    love.graphics.setColor(1,1,1)

    if (cars[1].posx > 320) then 
        offsetX = cars[1].posx - 320
    end
    if (cars[1].posy > 240) then
        offsetY = cars[1].posy - 240
    end

    love.graphics.draw(background, -offsetX, -offsetY, 0.0, 2, 2)

    for i,v in ipairs(cars) do
        v:draw()
    end

    -- Draw Debug Info
    --draw UI
    love.graphics.setColor(1,1,1)
end