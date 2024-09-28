local transmission = {}
transmission.__index = transmission
transmission.instanceNumber = 0

function transmission.new(object, player, ...)
	transmission.instanceNumber += 1
	local self = setmetatable({}, transmission)
	local args = {...}
	
	-- ALL CLASSES MUST HAVE THESE \/
	self.object = object
	self.player = player
	self.name = "transmission"
	self.instanceID = transmission.instanceNumber
	---------------------------------------------

	self.car = args[1]
	
	return self
end

function transmission:Init()
	print("Transmission initiated for class:", self.object.name)
end

return transmission