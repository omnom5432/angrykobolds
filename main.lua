require "Player"
require "Enemy"

function love.load()
	--make a new player object 
	g = love.graphics
	playerColor = {255, 0 , 128}
	enemyColor = {0, 255, 128}
	p = Player:new()

	p.x = 300
	p.y = 300
	p.speed = 80
	p.cooldown = 0
	p.atkRange = 15
	attacks = {}

	enemies = {}
	for i=1,5 do
		enemies[i] = Enemy:new()
		enemies[i].x = 100 * i
		enemies[i].y = 100
		enemies[i].health = 3
		enemies[i].speed = 50
		enemies[i].width = 20
		enemies[i].height = 20
		enemies[i].sightRange = 200
		enemies[i].mood = "Curious"
	end
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
		--only keep attacks for the length of them
		--check collisions with other things

		--2 attacks hitting each other could be parrys?
		for ii,vv in ipairs(enemies) do
			if (CheckCollision(v.x, v.y, v.width, v.height, vv.x, vv.y, vv.width, vv.height)) then
				table.remove(attacks, i)
				vv.health = vv.health - 1
				vv.mood = "Scared"
				if (vv.health < 0) then
					table.remove(enemies, ii)
				end
			end
		end

	end
	--each enemy thinks
	for i,v in ipairs(enemies) do
		v:think(p.x, p.y)
		v:update(dt)
	end
end

function love.keyreleased(key)
	if (key == "right") or (key == "left") or (key == "up") or (key == "down") then
		p:stop()
	end
	if (key == "x") then
		table.insert(attacks, p:attack())
		p:stop()
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
	g.print("speed "..math.floor(p.xSpeed)..", "..math.floor(p.ySpeed))
	g.print("cooldown"..p.cooldown, 100, 0)
	
	g.setColor(enemyColor)
	for i,v in ipairs(enemies) do
		g.rectangle("fill", v.x, v.y, v.width, v.height)
		g.print(v.dir..v.mood, v.x, v.y-15)
	end
		--draw the attack hitbox (debug only)
	g.setColor(255,255,255,255)
	for i,v in ipairs(attacks) do
		g.rectangle("fill", v.x, v.y, v.width, v.height)
	end
end

-- Collision detection function.
-- Returns true if two boxes overlap, false if they don't
-- x1,y1 are the left-top coords of the first box, while w1,h1 are its width and height
-- x2,y2,w2 & h2 are the same, but for the second box
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
	return x1 < x2+w2 and
		x2 < x1+w1 and
		y1 < y2+h2 and
		y2 < y1+h1
end