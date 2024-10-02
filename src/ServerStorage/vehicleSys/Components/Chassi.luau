local chassi = {}
chassi.__index = chassi
chassi.instanceNumber = 0

function chassi.new(object, player)
	chassi.instanceNumber += 1
	local self = setmetatable({}, chassi)
	-- ALL CLASSES MUST HAVE THESE \/
	self.object = object
	self.player = player
	self.name = "Chassi"
	self.instanceID = chassi.instanceNumber
	---------------------------------------------

	return self
end

function chassi:Init()
	print("Chassi initiated for class:", self.object.name)
end

return chassi