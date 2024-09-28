local engine = {}
engine.__index = engine
engine.instanceNumber = 0

function engine.new(object, player, ...)
	engine.instanceNumber += 1
	local self = setmetatable({}, engine)
	local args = {...}
	
	-- ALL CLASSES MUST HAVE THESE \/
	self.object = object
	self.player = player
	self.name = "engine"
	self.instanceID = engine.instanceNumber
	---------------------------------------------
	
	self.car = args[1] 

	return self
end

function engine:Init()
	print("Engine initiated for class:", self.object.name)
end

return engine