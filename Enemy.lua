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
function Enemy:new()

	local object = {
		x = 0,
		y = 0,
		xSpeed = 0,
		ySpeed = 0,
		speed = 0,
		width = 0,
		height = 0,
		direction = "",
		health = 0,
		mood = "Happy",
		cooldown = 0,
		atkRange = 0,
		sightRange = 0,
}
	setmetatable(object, {__index = Enemy})
	return object
end

--acts based on how close the player is
--this can potentially be refactored into only being called when the player is close enough
function Enemy:think(playerx, playery)
	--rev up those pythagorean theorems
	distance = math.sqrt((self.x - playerx)^2 + (self.y - playery)^2)
	if (distance <= self.sightRange) then
		--act based on mood
		
	end
end