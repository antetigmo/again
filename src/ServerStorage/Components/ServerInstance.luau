local serverInstance = {}
serverInstance.__index = serverInstance
serverInstance.instanceNumber = 0

function serverInstance.new(player, ...)
	serverInstance.instanceNumber += 1
	local self = setmetatable({}, serverInstance)
	local args = {...}
	
	-- ALL CLASSES MUST HAVE THESE \/
	self.player = player
	self.name = "serverinstance"
	self.instanceID = serverInstance.instanceNumber
	---------------------------------------------
	
	return self
end

function serverInstance:Init()
	print("ServerInstance initiated for the server as a singletonISH.")
end

return serverInstance