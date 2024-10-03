local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage= game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")
-----------------
local ClassManager = require(ServerStorage.Components.ClassManager)
local componentsArray = {"EventManager"}

local button = {}
button.__index = button
button.instanceNumber = 0

function button.new(object, player, instance)        --- Creates a proximity prompt for the instance
	button.instanceNumber += 1
	local self = setmetatable({}, button)
	-- ALL CLASSES MUST HAVE THESE \/
	self.object = object
	self.player = player
	self.name = "Button"
	self.instanceID = button.instanceNumber
    self.InitStatus = false
	---------------------------------------------

    self.EventManager = self.object.Components.eventManager
    self.actualInstance = instance
	return self
end

function button:Init()
    --CUSTOMS SERVICES
	local classManagerOBJ = ClassManager.new(self, self.player, ServerStorage.vehicleSys.Components, nil)
	classManagerOBJ:Init()
	-------------------------------------------
    self:CreatePrompt(self.actualInstance)
    self:AddressEvents()

    self.Components.LogManager:AddLog("Button initiated for class: " .. tostring(self.object.name))
    
    self.InitStatus = true
end

function button:AddressEvents()
    self.Pressed = self.Prompt.Triggered:Connect(function(playerWhoTriggered)
        print("Prompt triggered.", self)
        self.EventManager:PublishTopic("Pressed", playerWhoTriggered, self.actualInstance, self.instanceID)
    end)
end

function button:CreatePrompt(instance)
    local prompt = Instance.new("ProximityPrompt")
    prompt.HoldDuration = 1
    prompt.Parent = instance
    --
    self.Prompt = prompt

    print("Created a ProximityPrompt for instance:", instance)

    return prompt
end

return button