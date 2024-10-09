local serverInstance = {}
serverInstance.__index = serverInstance
serverInstance.instanceNumber = 0

function serverInstance.new(player, ...)
	serverInstance.instanceNumber += 1
	local self = setmetatable({}, serverInstance)
	local args = {...}
	
	-- ALL CLASSES MUST HAVE THESE \/
	self.player = player
	self.name = "ServerInstance"
	self.instanceID = serverInstance.instanceNumber
	---------------------------------------------
	
	return self
end

function serverInstance:Init()
	print("ServerInstance initiated for the server and for: ".. self.player)
end

function serverInstance:GetItself()
	return self
end

return serverInstance