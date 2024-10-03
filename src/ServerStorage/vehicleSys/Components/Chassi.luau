local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage= game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")
-----------------
local ClassManager = require(ServerStorage.Components.ClassManager)

local Chassi = {}
Chassi.__index = Chassi
Chassi.instanceNumber = 0

function Chassi.new(object, player, ...)
	Chassi.instanceNumber += 1
	local self = setmetatable({}, Chassi)
	local args = {...}
	
	-- ALL CLASSES MUST HAVE THESE \/
	self.object = object
	self.player = player
	self.name = "Chassi"
	self.instanceID = Chassi.instanceNumber
	---------------------------------------------
	
	self.car = args[1] 

	return self
end

function Chassi:Init()
	--CUSTOMS SERVICES
	local classManagerOBJ = ClassManager.new(self, self.player, ServerStorage.vehicleSys.Components, nil)
	classManagerOBJ:Init()
	-------------------------------------------

	self.Components.LogManager:AddLog("Chassi initiated for class: " .. self.object.name)
end

return Chassi