local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage= game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")

local ClassManager = require(ServerStorage.Components.ClassManager)
local componentFolder = ServerStorage.VehicleSys.Components

local vehicle = {}
vehicle.__index = vehicle
vehicle.instanceNumber = 0

vehicle.componentsArray = {"Engine", "Chassi", "Direction", "Suspension"}
vehicle.classComponents = {"EventManager"}

function vehicle.new(object, player, ...)
	vehicle.instanceNumber += 1
	local self = setmetatable({}, vehicle)
	local args = {...}

	-- ALL CLASSES MUST HAVE THESE \/
	self.object = object
	self.player = player
	self.name = "Vehicle"
	self.instanceID = vehicle.instanceNumber
	self.initStatus = false
	---------------------------------------------

	self.serverInstance = self:GetServerInstance()
	self.car = args[1] 

	return self
end

function vehicle:Init()
	--CUSTOMS SERVICES
	local classManagerOBJ = ClassManager.new(self, self.player, componentFolder, nil)
	classManagerOBJ:Init()
	-------------------------------------------

	classManagerOBJ:AddSpecificComponent(self.car, nil, vehicle.componentsArray)	-- WARN
	classManagerOBJ:AddSpecificComponent(self:GetSeat(), nil, nil, {"Button"})
	self.Button = self.Components.Button[self.instanceID] -- Find a better way to index instead of self.instanceID.
	self.Button:GetPrompt().RequiresLineOfSight = false
	

	self.Components.LogManager:AddLog("Vehicle initiated for vehicle: " .. self.car.Name .. " and for class: " ..self.object.name)
	self:AddressEvents()
end

function vehicle:AddressEvents()
	self.Pressed = self.Button:GetPrompt().Triggered:Connect(function(playerWhoTriggered) -- WARN
		self.Button:GetPrompt().Enabled = false
       	self:EnterVehicle(playerWhoTriggered)
    end)

	self.EnteredVehicle = self.Components.EventManager:ConnectEvent("EnteredVehicle", function(player)
		local playerEventManager = self.serverInstance.mainsReferences[player.Name].Components.EventManager
		playerEventManager:PublishTopic("EnteredVehicle")
	end)

	self.ExitedVehicle = ReplicatedStorage.vehicleSystemEvents.ExitVehicle.OnServerEvent:Connect(function(player, input)
		if input == Enum.KeyCode.Space then
			if player == self.currentPlayer then
				self:ExitVehicle(player)
			end
		end
	end)
end

function vehicle:EnterVehicle(player)
	self.currentPlayer = player
	self:GetSeat():Sit(player.Character:FindFirstChildWhichIsA("Humanoid"))

	for _, part in player.Character:GetDescendants() do
		if part:IsA("BasePart") or part:IsA("Decal") and part.Name ~= "HumanoidRootPart" then
			part.Transparency = 1
		end
	end

	self.Components.EventManager:PublishTopic("EnteredVehicle", player)
end

function vehicle:ExitVehicle(player)
	self.currentPlayer = nil
	self.Button:GetPrompt().Enabled = true
	for _, part in player.Character:GetDescendants() do
		if part:IsA("BasePart") or part:IsA("Decal") and part.Name ~= "HumanoidRootPart" then
			part.Transparency = 0
		end
	end

	local seatWeld = self:GetSeat():FindFirstChild("SeatWeld")
	if seatWeld then
		self:GetSeat():FindFirstChild("SeatWeld"):Destroy()
	end

	self.Components.EventManager:PublishTopic("ExitedVehicle", player)
end

function vehicle:GetSeat()
	return self.car.Seat
end

function vehicle:GetServerInstance() -- Gets the ServerInstance table by looking at object
	local serverInstance = self.object
	return serverInstance
end

return vehicle