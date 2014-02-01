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