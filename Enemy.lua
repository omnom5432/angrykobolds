Enemy = {}
--[[Enemy Class
the basic class for Enemies, 
this will get inherited by specific types of enemies. 
Probably.
--]]
--Constructor
function Enemy:new()

	local object = {
		x = 0
		y = 0
		xSpeed = 0
		ySpeed = 0
		speed = 0
		direction = ""
		health = 0
		mood = ""
		cooldown = 0
		atkRange = 0
}
	setmetatable(object, {__index = Enemy})
	return object
end
