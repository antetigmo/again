local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage= game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")
-----------------
local ClassManager = require(ServerStorage.Components.ClassManager)
local componentsArray = {"EventManager"}

local EnterVehicle = {}
EnterVehicle.__index = EnterVehicle
EnterVehicle.instanceNumber = 0

function EnterVehicle.new(object, player, ...)
	EnterVehicle.instanceNumber += 1
	local self = setmetatable({}, EnterVehicle)
	local args = {...}
	
	-- ALL CLASSES MUST HAVE THESE \/
	self.object = object
	self.player = player
	self.name = "EnterVehicle"
	self.instanceID = EnterVehicle.instanceNumber
	---------------------------------------------
	
    self.EventManager = self.object.Components.eventManager
	self.car = args[1]
	self.Seat = self.car.Seat 

	return self
end

function EnterVehicle:Init()
	print("EnterVehicle initiated for class:", self.object.name)
    --CUSTOMS SERVICES
	local classManagerOBJ = ClassManager.new(self, self.player, ServerStorage.vehicleSys.Components, nil)
	classManagerOBJ:Init()
	-------------------------------------------

	self:AddressEvents()
end

function EnterVehicle:AddressEvents()
	--self.Entered = self:CreateEnteredEvent()
end

function EnterVehicle:CreateEnteredEvent()
	local Entered = self.EventManager:ConnectEvent("Pressed", function(player)
		self:Enter(player)
	end)

	return Entered
end

function EnterVehicle:Enter(player) -- Enter/sit in the vehicle.
	if player == self.player then
		print("Player is player.", player, self.player)
	end
end


return EnterVehicle