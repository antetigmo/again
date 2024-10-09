local serverInstance = {}
serverInstance.__index = serverInstance
serverInstance.instanceNumber = 0

function serverInstance.new(player, ...)
	serverInstance.instanceNumber += 1
	local self = setmetatable({}, serverInstance)
	local Args = {...}
	
	-- ALL CLASSES MUST HAVE THESE \/
	self.Player = player
	self.Name = "ServerInstance"
	self.InstanceID = serverInstance.instanceNumber
	---------------------------------------------
	
	return self
end

function serverInstance:Init()
	print("ServerInstance initiated for the server as a singletonISH.")
end

function serverInstance:GetItself()
	return self
end

return serverInstance