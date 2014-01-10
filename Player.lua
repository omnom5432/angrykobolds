Player = {}


--Constructor
function Player:new()

	local object = {
	x = 0,
	y = 0,
	xSpeed = 0,
	ySpeed = 0,
	width = 20,
	height = 20,
	speed = 80,
	health = 5,
	state = "",
	cooldown = 0,
	atkRange = 0,
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
self.state = "Up"
end

function Player:moveLeft()
if (self.cooldown < 5) then
	self.xSpeed = -(self.speed)
end
self.state = "Left"
end

function Player:moveDown()
if (self.cooldown < 5) then
	self.ySpeed = self.speed
end
self.state = "Down"
end

function Player:moveRight()
if (self.cooldown < 5) then
	self.xSpeed = self.speed
end
self.state = "Right"
end

function Player:stop()
self.xSpeed = 0
self.ySpeed = 0
end
--Actions
function Player:update(dt)
	
	if (self.cooldown > 0) then 
		self.cooldown = self.cooldown - 1
	end

	self.x = self.x + (self.xSpeed * dt)
	self.y = self.y + (self.ySpeed * dt)

end

function Player:attack()		
--check if you can attack, then return an "attack" to the caller
--the attack should contain a direction, range, and length
attack = {}
attack.x = self.x + (self.width/2)
attack.y = self.y + (self.height/2)
attack.dir = "Up"
attack.range = 0
attack.length = 0
attack.width = self.width/2
attack.height = self.height/2
if (self.cooldown < 1) then
	--prevents an attack from happening if the player has just attacked
	self.cooldown = 50
	attack.dir = self.state
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