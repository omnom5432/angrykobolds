Force = {}
--[[ a force that can act on an object, 
it can be used to knock things around

]]
function Force:new()
		local object = {
		xComp = 0,
		yComp = 0,
		length = 0,
}
	setmetatable(object, {__index = Force})
	return object

end

--forces should eventually slow down as they age
function Force:update(dt)

		self.length = self.length - 1

end

