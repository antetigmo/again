local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage= game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")
-----------------
local ClassManager = require(ServerStorage.Components.ClassManager)

local engine = {}
engine.__index = engine
engine.instanceNumber = 0

function engine.new(object, player, ...)
	engine.instanceNumber += 1
	local self = setmetatable({}, engine)
	local args = {...}
	
	-- ALL CLASSES MUST HAVE THESE \/
	self.object = object
	self.player = player
	self.name = "Engine"
	self.instanceID = engine.instanceNumber
	---------------------------------------------
	
	self.car = args[1] 

	return self
end

function engine:Init()
	--CUSTOMS SERVICES
	local classManagerOBJ = ClassManager.new(self, self.player, ServerStorage.vehicleSys.Components, nil)
	classManagerOBJ:Init()
	-------------------------------------------

	self.Components.LogManager:AddLog("Engine initiated for class: " .. self.object.name)
end

return engine