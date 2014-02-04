Attack = {}

function Attack:new()

	local object = {
		x = 0,
		y = 0,
		width = 5,
		height = 5,
		length = 0,
		range = 0,
		dir = "Up",
		damage = 0,
		knockback = 150,
		owner = 0,
}
	setmetatable(object, {__index = Attack})
	return object
end

function Attack:getKnockback()

	--calculate direction
	--return force
	temp = Force:new()
	dist = self.knockback
	temp.length = 5;
			if (self.dir == "Up") then
				temp.yComp = -dist
		elseif (self.dir == "Left") then
				temp.xComp = -dist
		elseif (self.dir == "Down") then
				temp.yComp = dist
		elseif (self.dir == "Right") then
				temp.xComp = dist
		end

		return temp
end