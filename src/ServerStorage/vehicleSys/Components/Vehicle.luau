local ServerStorage= game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")

local ClassManager = require(ServerStorage.Components.ClassManager)
local componentFolder = ServerStorage.vehicleSys.Components

local vehicle = {}
vehicle.__index = vehicle
vehicle.instanceNumber = 0

vehicle.componentsArray = {"Engine", "Chassi", "Direction", "Suspension", "EnterVehicle"}
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
	---------------------------------------------

	self.car = args[1] 

	return self
end

function vehicle:Init()
	--CUSTOMS SERVICES
	local classManagerOBJ = ClassManager.new(self, self.player, componentFolder, nil)
	classManagerOBJ:Init()
	-------------------------------------------

	classManagerOBJ:AddSpecificComponent(self.car, nil, vehicle.componentsArray)	-- WARN
	classManagerOBJ:AddSpecificComponent(self.car.Seat, "Button", nil)
	self.Button = self.Components.Button[self.instanceID] -- Find a better way to index instead of self.instanceID.
	

	self.Components.LogManager:AddLog("Vehicle initiated for vehicle: " .. self.car.Name .. " and for class: " ..self.object.name)
	self:AddressEvents()
end

function vehicle:AddressEvents()
	self.Pressed = self.Button.Prompt.Triggered:Connect(function(playerWhoTriggered) -- WARN
        self.Components.LogManager:AddLog("Prompt triggered." .. tostring(self))

        local serverInstance = self:GetServerInstance()
        self.Components.EnterVehicle[self.instanceID]:Enter(playerWhoTriggered) -- Find a better way to index instead of self.instanceID.
    end)
end

function vehicle:GetServerInstance() -- Gets the ServerInstance table by looking at object
	local serverInstance = self.object
	return serverInstance
end

return vehicle