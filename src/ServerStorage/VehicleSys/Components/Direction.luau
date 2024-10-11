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
	-- Angles
	self.lAngle = nil
	self.rAngle = nil
	self.angle = nil

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
		task.wait(0.1) 	-- FIX THIS!
		ReplicatedStorage.vehicleSystemEvents.Entered:FireClient(player, self.object.car)
		--print("sended")
	end)

	self.ExitedVehicle = vehicleEventManager:ConnectEvent("ExitedVehicle", function(player)
		local directionAnimation = player.Character:FindFirstChild("DirectionAnimation")
		directionAnimation.Enabled = false
	end)

	self.Debug = ReplicatedStorage.vehicleSystemEvents.Debug.OnServerEvent:Connect(function(player, lrAngle, angle, direction)
		if direction == "Left" then
			self.lAngle = lrAngle
			ReplicatedStorage.vehicleSystemEvents.Debug:FireClient(player, player, lrAngle, angle)
			--print(self.lAngle)
		elseif direction == "Right" then
			self.rAngle = lrAngle
			ReplicatedStorage.vehicleSystemEvents.Debug:FireClient(player, player, lrAngle, angle)
			--print(self.rAngle)
		end
	end)
end

return direction