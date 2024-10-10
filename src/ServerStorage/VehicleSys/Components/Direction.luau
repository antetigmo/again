local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage= game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")
local StarterPlayer = game:GetService("StarterPlayer")
-----------------

local direction = {}
direction.__index = direction
direction.instanceNumber = 0

function direction.new(object, player, instance)
	direction.instanceNumber += 1
	local self = setmetatable({}, direction)
	-- ALL CLASSES MUST HAVE THESE \/
	self.object = object
	self.player = player
	self.name = "Direction"
	self.instanceID = direction.instanceNumber
    self.initStatus = false
	---------------------------------------------

    self.actualInstance = instance
	return self
end

function direction:Init()
    --CUSTOMS SERVICES
    local ClassManager = require(ServerStorage.Components.ClassManager)
	local classManagerOBJ = ClassManager.new(self, self.player, ServerStorage.VehicleSys.Components, nil)
	classManagerOBJ:Init()
	-------------------------------------------
	self.Components.LogManager:AddLog("Direction initiated for class: " .. tostring(self.object.name))

	self:AddressEvents()
end

function direction:AddressEvents()
    local vehicleEventManager = self.object.Components.EventManager	

	self.EnteredVehicle = vehicleEventManager:ConnectEvent("EnteredVehicle", function(player)
		local directionAnimation = player.Character:FindFirstChild("DirectionAnimation")
		directionAnimation.Enabled = true
		ReplicatedStorage.vehicleSystemEvents.Entered:FireClient(player, self.object.car)
	end)

	self.ExitedVehicle = vehicleEventManager:ConnectEvent("ExitedVehicle", function(player)
		local directionAnimation = player.Character:FindFirstChild("DirectionAnimation")
		directionAnimation.Enabled = false
	end)
end

return direction