local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage= game:GetService("ServerStorage")
local PlayersService = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")

local ClientToServer = nil
local inventorySystemEvents = ReplicatedStorage.inventorySystemEvents
local ServerToClient = inventorySystemEvents.ServerToClient
local ServerToServer = inventorySystemEvents.ServerToServer

local item = {}
item.__index = item
item.instanceNumber = 0

item.itemsActive = {}

MAX_OF_ITEMS = 9

function item.new(object, itemObject)
	item.instanceNumber += 1
	local self = setmetatable({}, item)
	-- ALL CLASSES MUST HAVE THESE \/
	self.object = object
	self.itemObject = itemObject
	self.name = "item"
	self.instanceID = item.instanceNumber
	-------------------------------------

	self.eventManager = self.object.Components.ClassComponents.eventManager
	self._topicEvent = Instance.new("BindableEvent")
	self.guiComponent = self.object.Components.ClassComponents.guiHandler[1]
	self.icon = self.itemObject:FindFirstChildWhichIsA("ImageLabel")

	return self
end

function item:Init()
	self:CreatePrompt(self.itemObject)
	self:AddressEvents()
end

function item:AddressEvents()
	self.Pressed = self.Prompt.Triggered:Connect(function(player)
		warn("Prompt triggered/pressed.")

		self:Press(player, self.itemObject)
		self.object:m_PublishTopic("Pressed", player, self.itemObject, self.instanceID)
	end)	

	self.Equipped = self.itemObject.Equipped:Connect(function()
		local player = PlayersService:GetPlayerFromCharacter(self.itemObject.Parent) or nil
		if player == self.object.player then
			self.object.currentItemEquipped = {self.itemObject, self}
		end
	end)

	self.Unequipped = self.itemObject.Unequipped:Connect(function()
		local player = self.itemObject.Parent.Parent
		if player == self.object.player then
			self.object.currentItemEquipped = {nil, self}
		end
	end)

	self.ItemDropped = self:SubscribeTopic("itemDropped", function(player, item)
		if self.itemsActive[player.Name][1] == player then
			self:DestroyHandle(item)
			self.Prompt.Enabled = true
			self.object.currentItemEquipped = {nil, self}

			print("2 - Player:", player, "dropped:", item)
		end
	end)
end

function item:CreatePrompt(item)
	local Prompt = item.Plane.Attachment:FindFirstChildWhichIsA("ProximityPrompt") or Instance.new("ProximityPrompt")
	Prompt.HoldDuration = 0.5
	Prompt.Parent = item.Plane.Attachment
	self.Prompt = Prompt

	return self.Prompt
end

function item:CreateHandle(item)
	local Handle = item:FindFirstChild("Handle") or Instance.new("Part")
	Handle.Size = Vector3.new(1, 1, 1)
	Handle.Parent = item
	Handle.Name = "Handle"
	Handle.Anchored = false
	Handle.CanCollide = false
	Handle.Transparency = 1

	Handle.Position = item.Plane.Position
	item.WeldConstraint.Enabled = true
	item.WeldConstraint.Part0 = item.Plane
	item.WeldConstraint.Part1 = Handle
	item.Plane.CanCollide = false

	return Handle
end

function item:DestroyHandle(item)
	local Handle = item:FindFirstChild("Handle")
	if Handle then
		item.Plane.CanCollide = true
		Handle:Destroy()
	else
		warn("Handle doesn't exist anymore.")
	end
end

function item:Press(player, itemObject)
	if player == self.object.player then
		self.Prompt.Enabled = false
		self.itemObject.Parent = player

		self:AssignToItemsActive(player, itemObject)
	end	
end

function item:AssignToItemsActive(player, item)
	if not self.itemsActive[player.name] then
		self.itemsActive[player.Name] = {player, item}
	else
		table.insert(self.itemsActive[player.Name], item)
		print(self.itemsActive)
	end
end

function item:RemoveFromItemsActive(player, item)
	local itemIndex = table.find(self.itemsActive[player.Name], item)
	table.remove(self.itemsActive[player.Name], itemIndex)
end

function item:PublishTopic(topicName, player, ...)
	self._topicEvent:Fire(topicName, player, ...)	
end

function item:SubscribeTopic(topicName, callBack)
	local connection = self._topicEvent.Event:Connect(function(name, player, ...)
		if name == topicName then
			callBack(player, ...)
		end
	end)
	return connection
end

return item