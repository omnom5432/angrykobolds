require "Player"
require "Enemy"
require "Item"
require "Attack"
require "Force"
require "AnAL"

function love.load()
	--make a new player object 
	g = love.graphics
	playerImg = g.newImage("kobold.png")
	enemyImg = g.newImage("Chicken.png")
	enemyAnim = newAnimation(enemyImg, 22, 22, 0.1, 0)
	playerColor = {255, 0 , 128}
	enemyColor = {0, 255, 128}
	itemColor = {128, 0, 255}
	p = Player:new()

	p.x = 300
	p.y = 300
	p.width = 40
	p.height = playerImg:getHeight()
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
		enemies[i].atkRange = 30
		--enemies[i].mood = "Curious"
		enemies[i].id = i
	end

	items = {}
	for i = 1, 10 do
		temp = Item:new()
		temp.x = math.random(800)
		temp.y = math.random(600)
		items[i] = temp
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

	p:update(dt, enemies)
		--each enemy thinks
	for i,v in ipairs(enemies) do

		temp = v:think(p.x + p.width/2, p.y + p.height/2)
		if (temp) then
			--add attack
			table.insert(attacks, temp)
		end
		v:update(dt, p.x, p.y, p.width, p.height)
	end
	--resolve attacks
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
				if (v.owner == 0) then
					
					vv.health = vv.health - 1
					vv.mood = "Scared"
					table.insert(vv.forces, v:getKnockback())
					table.remove(attacks, i)
					if (vv.health < 0) then
						table.remove(enemies, ii)
					end
				end
			end
		end
		if (CheckCollision(v.x, v.y, v.width, v.height, p.x, p.y, p.width, p.height)) then
			if (v.owner ~= p.id) then
				table.insert(p.forces, v:getKnockback())
				
				table.remove(attacks, i)

			end

		end
	end

	--update animations
	enemyAnim:update(dt)
end

function love.keyreleased(key)
	--stop moving
	if (key == "right") or (key == "left") or (key == "up") or (key == "down") then
		p:stop()
	end
	--attack
	if (key == "x") then
				--check collision with items
		temp = false
		for i,v in ipairs(items) do
			if (CheckCollision(v.x, v.y, v.width, v.height, p.x, p.y, p.width, p.height)) then
				p:pickup(v)
				table.remove(items, i)
				temp = true
				--check if enemies can see you
				--if yes, anger them.
				for i,v in ipairs(enemies) do
					v:aggro(p.x, p.y)
				end
			end
		end
		if (not temp) then
			table.insert(attacks, p:attack())
			p:stop()
		end
	end
	--place trap
	if (key == "c") then
		p:setTrap()
	end
	--drop
	if (key == "v") then
		temp = p:drop()
		if (temp) then
			table.insert(items, temp)
		end
	end
	--quit
	if key == "escape" then
		love.event.quit()
	end
end

function love.draw()
	--[[draw the player at their location
	g.setColor(playerColor)
	g.rectangle("fill", p.x, p.y, p.width, p.height)
	--]]

	--g.setColor(enemyColor)
	for i,v in ipairs(enemies) do
		--g.rectangle("fill", v.x, v.y, v.width, v.height)
		enemyAnim:draw(v.x, v.y)

		g.print(v.dir..v.cooldown..v.mood, v.x, v.y-15)
	end

	g.setColor(itemColor)
	for i,v in ipairs(items) do
		g.rectangle("fill", v.x, v.y, v.width, v.height)
	end
		---[[draw the attack hitbox (debug only)
	g.setColor(255,255,255,255)
	for i,v in ipairs(attacks) do
		g.print(v.owner, v.x, v.y-15)
		g.rectangle("fill", v.x, v.y, v.width, v.height)
	end
	--]]
	g.draw(playerImg, p.edgeX, p.edgeY)
	g.rectangle("line", p.x, p.y, p.width, p.height)
	g.print("Player State: "..p.dir, 5, 20)
	g.print("speed "..math.floor(p.xSpeed)..", "..math.floor(p.ySpeed))
	g.print("cooldown"..p.cooldown, 100, 0)
	
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