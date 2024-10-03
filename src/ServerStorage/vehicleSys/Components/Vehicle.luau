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

	classManagerOBJ:AddSpecificComponent(self.car, nil, vehicle.componentsArray)
	classManagerOBJ:AddSpecificComponent(self.car.Seat, "Button", nil)

	self.Components.LogManager:AddLog("Vehicle initiated for vehicle: " .. self.car.Name .. " and for class: " ..self.object.name)
	--print(self.Components.LogManager)
end


return vehicle