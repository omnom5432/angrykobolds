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
		owner = 0,
}
	setmetatable(object, {__index = Attack})
	return object
end