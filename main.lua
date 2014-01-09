require "Player"

function love.load()
	--make a new player object 
	g = love.graphics
	playerColor = {255, 0 , 128}

	p = Player:new()

	p.x = 300
	p.y = 300
	p.speed = 80
	p.cooldown = 0
	p.atkRange = 15
	attacks = {}

end

function love.update(dt)
	--check which keys are pressed and move the player accordingly
	if love.keyboard.isDown("up") then
		p:moveUp()
	end

	if love.keyboard.isDown("left") then
		p:moveLeft()
	end

	if love.keyboard.isDown("right") then
		p:moveRight()
	end

	if love.keyboard.isDown("down") then
		p:moveDown()
	end

	p:update(dt)

	for i,v in ipairs(attacks) do
		v.length = v.length - 1
		if (v.length < 0) then
			table.remove(attacks, i)
		end

	end
end

function love.keyreleased(key)
	if (key == "right") or (key == "left") or (key == "up") or (key == "down") then
		p:stop()
	end
	if (key == "x") then
		table.insert(attacks, p:attack())
	end
	if key == "escape" then
      love.event.quit()
   end
end

function love.draw()
	--draw the player at their location
	g.setColor(playerColor)
	g.rectangle("fill", p.x, p.y, p.width, p.height)
	g.print("Player State: "..p.state, 5, 20)
	g.print("speed "..p.xSpeed..", "..p.ySpeed)
	g.print("cooldown"..p.cooldown, 100, 0)
	g.setColor(255,255,255,255)
	for i,v in ipairs(attacks) do

		g.rectangle("fill", v.x, v.y, 2, 2)
	end
end