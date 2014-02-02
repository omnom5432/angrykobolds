Entity = {}

--[[base class for anything doing moving.
this should get inherited and have its methods added too. 
--]]

function Entity:new(i)
	
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
		cooldown = 0,
		atkRange = 0,
		forces = {},
	}
	setmetatable(object, {__index = Entity})
	return object
end

--calculate speed and other vectors
function Entity:update(dt)

	--cooldown is used when the Entity can't move
	if (self.cooldown > 0) then 
		self.cooldown = self.cooldown - 1
	end
	--limit speed when moving along diagonal
	if (self.xSpeed ~= 0) and (self.ySpeed ~= 0) then
		self.xSpeed = math.sqrt(self.speed * self.speed / 2) * (self.xSpeed / math.abs(self.xSpeed))
		self.ySpeed = math.sqrt(self.speed * self.speed / 2) * (self.ySpeed / math.abs(self.ySpeed))
	end

	--apply forces
	for i,v in ipairs(self.forces) do
		self.xSpeed = self.xSpeed + v.xComp
		self.ySpeed = self.ySpeed + v.yComp
		v.length = v.length - 1
		if (v.length < 0) then
			table.remove(self.forces, i)
		end
	end

	--update position
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

--Movement
function Entity:moveUp()
if (self.cooldown < 5) then
	self.ySpeed = -(self.speed)
end
self.state = "Up"
end

function Entity:moveLeft()
if (self.cooldown < 5) then
	self.xSpeed = -(self.speed)
end
self.state = "Left"
end

function Entity:moveDown()
if (self.cooldown < 5) then
	self.ySpeed = self.speed
end
self.state = "Down"
end

function Entity:moveRight()
if (self.cooldown < 5) then
	self.xSpeed = self.speed
end
self.state = "Right"
end

function Entity:stop()
self.xSpeed = 0
self.ySpeed = 0
end