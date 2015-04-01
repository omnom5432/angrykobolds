Player = {}
--[[ The Player Class

this contains all the things a player needs
Right now there is only one, 
but eventually there will be one for each player in multiplayer games.
Probably.
--]]

--Constructor
function Player:new()

	local object = {
	id = 0,
	x = 0,
	y = 0,
	edgeX = 0,
	edgeY = 0,
	xSpeed = 0,
	ySpeed = 0,
	width = 20,
	height = 20,
	speed = 80,
	health = 5,
	dir = "",
	cooldown = 0,
	atkRange = 0,
	inventory = {},
	forces = {},	
	}
	setmetatable(object, {__index = Player})
	return object
end

--Controls

--Movement

function Player:moveUp()
	if (self.cooldown < 5) then
		self.ySpeed = -(self.speed)
	end
	if (self.xSpeed == 0) then
		self.dir = "Up"
	end
end

function Player:moveLeft()
	if (self.cooldown < 5) then
		self.xSpeed = -(self.speed)
	end
	if (self.ySpeed == 0) then
		self.dir = "Left"
	end
end

function Player:moveDown()
	if (self.cooldown < 5) then
		self.ySpeed = self.speed
	end
	if (self.xSpeed == 0) then
		self.dir = "Down"
	end
end

function Player:moveRight()
	if (self.cooldown < 5) then
		self.xSpeed = self.speed
	end
	if (self.ySpeed == 0) then
		self.dir = "Right"
	end
end

function Player:stop()
	self.xSpeed = 0
	self.ySpeed = 0
end

--Actions
function Player:update(dt, colliders)
	--add speed calculation based on inventory

	--cooldown is used for doing actions, so you can't spam attacks or anything
	if (self.cooldown > 0) then 
		self.cooldown = self.cooldown - 1
	end
	--limits speed on the diagonals
	--this formula was calculated using SUPER MATH and keeps the speed as equal as possible.
	if (self.xSpeed ~= 0) and (self.ySpeed ~= 0) then
		self.xSpeed = math.sqrt(self.speed * self.speed / 2) * (self.xSpeed / math.abs(self.xSpeed))
		self.ySpeed = math.sqrt(self.speed * self.speed / 2) * (self.ySpeed / math.abs(self.ySpeed))
	end
	--applies forces to the player
	for i,v in ipairs(self.forces) do
		self.xSpeed = v.xComp 
		self.ySpeed = v.yComp 
		v:update()
		if (v.length < 0) then
			table.remove(self.forces, i)
			self.xSpeed = 0
			self.ySpeed = 0
		end
	end
	--move the player
	self.x = self.x + (self.xSpeed * dt)
	self.y = self.y + (self.ySpeed * dt)
	--check collisions
	for i,v in ipairs(colliders) do
		--check if the player collides with it
		self:ResolveCollision(v.x, v.y, v.width, v.height)
	end

	if (self.x < 0) then
		self.x = 0
	end
	if (self.y < 0) then
		self.y = 0
	end
	--keep the character inside the screen
	if (self.y + self.height > love.window.getHeight()) then
		self.y = love.window.getHeight() - self.height
	end
	if (self.x + self.width > love.window.getWidth()) then
		self.x = love.window.getWidth() - self.width
	end

	--edgeX and Y represent where to draw, x and y represent the middle
	self.edgeX = self.x - self.width/2
	self.edgeY = self.y
end

function Player:attack()		
	--check if you can attack, then return an "attack" to the caller
	--the attack should contain a direction, range, and length
	attack = Attack:new()
	attack.x = self.x + self.width/2
	attack.y = self.y + self.height/2
	attack.dir = "Up"
	attack.range = 0
	attack.length = 0
	attack.width = self.width/2
	attack.height = self.height/2
	attack.owner = self.id
	if (self.cooldown < 1) then
		--prevents an attack from happening if the player has just attacked
		self.cooldown = 25
		attack.dir = self.dir
		attack.range = self.atkRange
		attack.length = self.cooldown
		--switch based on dir
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

--drop a trap on the ground
function Player:setTrap()


	if (self.cooldown < 1) then
		self.cooldown = 50
		--create trap
	end
	
end

function Player:pickup(item)

	--add the item to inventory
	table.insert(self.inventory, item)
	self.speed = self.speed * 0.9
end

function Player:drop()
	--toss an item from the inventory
	--return the item
	--remove from inventory
	if (#self.inventory > 0) then
		item = self.inventory[1]
		item.x = self.x + self.width / 2 
		item.y = self.y + self.height
		table.remove(self.inventory, 1)
		self.speed = self.speed / 0.9
		return item
	end
end

--Resolve collision with rectangle (x1, y1, w1, h1)
function Player:ResolveCollision(x1,y1,w1,h1)
	if (CheckCollision(self.x, self.y, self.width, self.height, x1,y1,w1,h1)) then
		--resolve collision
		--move the player towards whichever side is the closest
		edge = self:findEdge(x1,y1,w1,h1)
		if (edge == "Up") then	--bottom edge
			self.y = y1 + h1
		elseif (edge == "Left") then	--right edge
			self.x = x1 + w1
		elseif (edge == "Down") then	--top edge
			self.y = y1 - self.height
		elseif (edge == "Right") then	--left edge
			self.x = x1 - self.width
		end


	end
end

function Player:findEdge(x1, y1, w1, h1)
	--overlap on each edge or 0 if no overlap
	local edges = {x1 + w1 - self.x,
	self.x + self.width - x1,
	y1 + h1 - self.y,
	self.y + self.height - y1}
	edgeNames = {"Left","Right","Up", "Down"}
	local lowest = nil
	for i, v in ipairs(edges) do
		if v > 0 and (lowest == nil or v < lowest) then
			lowest = v
		end
	end
	edge = "Up"
	for i,v in ipairs(edgeNames) do
		if (lowest == edges[i]) then
			edge = v
		end
	end
	return edge
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