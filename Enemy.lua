Enemy = {}
--[[Enemy Class
the basic class for Enemies, 
this will get inherited by specific types of enemies. 
Probably.

moods are for AI
"Angry" will attack players if they can see them
"Scared" will run away from players if they can see them
"Happy" will ignore players and do whatever it is bad guys do
--]]
--Constructor
function Enemy:new(i)

	local object = {
		id = i,
		x = 0,
		y = 0,
		xSpeed = 0,
		ySpeed = 0,
		speed = 0,
		width = 0,
		height = 0,
		dir = "",
		health = 0,
		mood = "Happy",
		cooldown = 0,
		atkRange = 0,
		sightRange = 0,
		changeDir = 0,
		forces = {},
}
	setmetatable(object, {__index = Enemy})
	return object
end

--acts based on how close the player is
function Enemy:think(playerx, playery)
	--rev up those pythagorean theorems
	distance = math.sqrt((self.x - playerx)^2 + (self.y - playery)^2)
	if (self.mood == "Curious") then
		--wander around and explore
		if (self.changeDir < 1) then
			self:stop()
			self.changeDir = math.random(200)
			direction = math.random(6)
			if (direction <= 2) then
				self:moveRight()
			elseif (direction <= 3) then
				self:moveUp()
			elseif (direction <= 4) then
				self:moveLeft()
			elseif(direction <= 5) then
				self:moveDown()
			end
		end
		self.changeDir = self.changeDir - 1
	-- these only get done if the enemy can see the player.
	elseif (distance <= self.sightRange) then
		--act based on mood

		if (self.mood == "Scared") then
			--run away from player
			if (playerx < self.x) then 
				self:moveRight() 
			else
				self:moveLeft()
			end

			if (playery > self.y) then
				self:moveUp()
			else
				self:moveDown()
			end

		elseif (self.mood == "Angry") then
			--move towards player menacingly
			if (distance <= self.atkRange) then
				if (self.cooldown <= 0) then
					return self:attack()
				end
			end

			if (self.x - playerx < -self.atkRange) then 
				self:moveRight()
			elseif (self.x - playerx > self.atkRange) then
				self:moveLeft()
			end
			if (self.y - playery > self.atkRange) then
				self:moveUp()
			elseif (self.y - playery < -self.atkRange) then
				self:moveDown()
			end

		end
	else
		self:stop()
	end
end

function Enemy:update(dt)
	
	if (self.cooldown > 0) then 
		self.cooldown = self.cooldown - 1
	end
	--this assumes that everyone moves at TOP SPEED at all times, and is so that you can't go faster if you move diagonally,
	if (self.xSpeed ~= 0) and (self.ySpeed ~= 0) then
		self.xSpeed = math.sqrt(self.speed * self.speed / 2) * (self.xSpeed / math.abs(self.xSpeed))
		self.ySpeed = math.sqrt(self.speed * self.speed / 2) * (self.ySpeed / math.abs(self.ySpeed))
	end
	for i,v in ipairs(self.forces) do
		self.xSpeed = v.xComp
		self.ySpeed = v.yComp
		v:update()
		if (v.length < 0) then
			table.remove(self.forces, i)
		end
	end
	self.x = self.x + (self.xSpeed * dt)
	self.y = self.y + (self.ySpeed * dt)
	if (self.x < 0) then
		self.x = 0
	end
	if (self.y < 0) then
		self.y = 0
	end
	if (self.y + self.height > love.window.getHeight()) then
		self.y = love.window.getHeight() - self.height
	end
	if (self.x + self.width > love.window.getWidth()) then
		self.x = love.window.getWidth() - self.width
	end
end

function Enemy:aggro(px, py)
		distance = math.sqrt((self.x - px)^2 + (self.y - py)^2)
		if (distance <= self.sightRange) then
			self.mood = "Angry"
		end

end
--Movement
function Enemy:moveUp()
if (self.cooldown < 5) then
	self.ySpeed = -(self.speed)
end
self.dir = "Up"
end

function Enemy:moveLeft()
if (self.cooldown < 5) then
	self.xSpeed = -(self.speed)
end
self.dir = "Left"
end

function Enemy:moveDown()
if (self.cooldown < 5) then
	self.ySpeed = self.speed
end
self.dir = "Down"
end

function Enemy:moveRight()
if (self.cooldown < 5) then
	self.xSpeed = self.speed
end
self.dir = "Right"
end

function Enemy:stop()
self.xSpeed = 0
self.ySpeed = 0
end

function Enemy:attack()
--check if you can attack, then return an "attack" to the caller
	--the attack should contain a direction, range, and length
	attack = Attack:new()
	attack.x = self.x + (self.width/2)
	attack.y = self.y + (self.height/2)
	attack.dir = "Up"
	attack.range = 0
	attack.length = 0
	attack.width = self.width/2
	attack.height = self.height/2
	attack.owner = self.id
	if (self.cooldown < 1) then
		--prevents an attack from happening if the player has just attacked
		self.cooldown = 50
		attack.dir = self.dir
		attack.range = self.atkRange
		attack.length = self.cooldown
		--switch based on state
		if (attack.dir == "Up") then
			attack.x = attack.x-(attack.width/2)
			attack.height = attack.height + attack.range
			attack.y = attack.y - attack.height
		elseif (attack.dir == "Left") then
			attack.y = attack.y - (attack.width/2)
			attack.width = attack.width + attack.range
			attack.x = attack.x - attack.width
		elseif (attack.dir == "Down") then
			attack.x = attack.x-(attack.width/2)
			attack.height = attack.height + attack.range
		elseif (attack.dir == "Right") then
			attack.y = attack.y - (attack.width/2)
			attack.width = attack.width + attack.range
		end

		--calculate the rectangle's x, y, width, height for the attack

	end
		return attack

end
