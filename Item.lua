Item = {}

function Item:new()

	local object = {
		x = 0,
		y = 0,
		width = 5,
		height = 5,
		weight = 0,
		value = 0,
		shininess = 3,
		name = "Shiny!",
}
	setmetatable(object, {__index = Item})
	return object
end