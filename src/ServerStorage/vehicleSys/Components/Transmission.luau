local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage= game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")
-----------------
local ClassManager = require(ServerStorage.Components.ClassManager)


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
	self.name = "Transmission"
	self.instanceID = transmission.instanceNumber
	---------------------------------------------

	self.car = args[1]
	
	return self
end

function transmission:Init()
	--CUSTOMS SERVICES
	local classManagerOBJ = ClassManager.new(self, self.player, ServerStorage.vehicleSys.Components, nil)
	classManagerOBJ:Init()
	-------------------------------------------

	self.Components.LogManager:AddLog("Transmission initiated for class: " .. self.object.name)
end

return transmission