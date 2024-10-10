local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage= game:GetService("ServerStorage")
local PlayersService = game:GetService("Players")

local classManager = require(ServerStorage.Components.ClassManager)

local componentFolder = ServerStorage.VehicleSys.Components
local componentsArray = {}

local vehicleSys = {}

vehicleSys.__index = vehicleSys
local modVersion = "0.0.0"

vehicleSys.instanceNumber = 0

function vehicleSys.new(player)
	vehicleSys.instanceNumber += 1 
	-- ONLY THE MAIN CLASS MUST HAVE THESE \/
	local self = setmetatable({}, vehicleSys)
	self.player = player 
	self.name = "VehicleSys"..tostring(vehicleSys.instanceNumber) 
	self.instanceID = vehicleSys.instanceNumber
	-------------------------------------------
	
	return self
end

function vehicleSys:m_Init()
	--CUSTOMS SERVICES
	local classManagerOBJ = classManager.new(self, self.player, componentFolder, nil)
	classManagerOBJ:Init()
	-------------------------------------------
	warn("------")
	warn("VehicleSys initiated, current version:" , modVersion,"; instanceID:", self.instanceID,"; player:", self.player)

	self:m_AddressEvents()

	task.spawn(function()
		task.wait(3)
		self:RefreshMainsReferences()
	end)

end

function vehicleSys:RefreshMainsReferences() -- Refresh the table mainsReferences, by __newindex in server(startVehicleSystem).
	self.mainsReferences = self.mainsReferences.serverClassManagerOBJ["mainsReferences"]
end

function vehicleSys:m_AddressEvents()
	warn("VehicleSys addressed all necessary events.")

	self.EnteredVehicle = self.Components.EventManager:ConnectEvent("Entered", function()
		
	end)

end

return vehicleSys
