local DebugManager = {}
DebugManager.__index = DebugManager
DebugManager.instanceNumber = 0

function DebugManager.new(object, player, ...)
	DebugManager.instanceNumber += 1
	local self = setmetatable({}, DebugManager)
	local args = {...}
	
	-- ALL CLASSES MUST HAVE THESE \/
	self.object = object
	self.player = player
	self.name = "debugmanager"
	self.instanceID = DebugManager.instanceNumber
	---------------------------------------------

	self.car = args[1]
	
	return self
end

function DebugManager:Init()
	print("DebugManager initiated for class:", self.object.name)
end

return DebugManager