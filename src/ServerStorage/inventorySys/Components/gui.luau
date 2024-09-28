local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local inventorySystemEvents = ReplicatedStorage.inventorySystemEvents
local ClientToServer = inventorySystemEvents.ClickInventory

local guiHandler = {}
guiHandler.__index = guiHandler
guiHandler.instanceNumber = 0

local versionN = "1.0.0"

function guiHandler.new(object, player)
	guiHandler.instanceNumber += 1
	local self = setmetatable({}, guiHandler)
	-- ALL CLASSES MUST HAVE THESE \/
	self.object = object
	self.player = player
	self.name = "guiHandler"
	self.instanceID = guiHandler.instanceNumber
	-------------------------------------------

	self.eventManager = self.object.Components.ClassComponents.eventManager
	
	self.actualInventory = {}

	return self
end

function guiHandler:Init()
	warn("guiHandler initiated")
	
	self.inventoryUi = self.player.PlayerGui:WaitForChild("inventoryUi")
	self.player.CharacterAdded:Connect(function()
		self.inventoryUi = self.player.PlayerGui.inventoryUi
		self.slots = self:AddressSlots()
	end)
	
	self:AddressEvents()
	local initialPressedEvent = self:CreatePressedEvent()

	self.slots = self:AddressSlots()
end

function guiHandler:CreatePressedEvent()
	local pressedEvent = self.eventManager:ConnectEvent("Pressed", function(player, item, instanceID)
		self.PressedCallback(player, item, instanceID)
	end)
	warn("Pressed event created by eventManager.")
	return pressedEvent
end

function guiHandler:AddressEvents()
	self.PressedCallback = function(player, item, instanceID)
		if player == self.player then
			self.actualItemInstanceID = instanceID
			self:SetItemOnInventory(item)
		end
	end

	self.MouseClickedConnection = ClientToServer.OnServerEvent:Connect(function(player, slot)
		if player == self.player then
			self:OnMouseClicked(player, slot)
		end
	end)
end

function guiHandler:AddressSlots()
	local slotsChildren = self.inventoryUi.Main.ScrollingFrame:GetChildren()
	local amountOfSlots = {}
	local index = 0

	for _, slot in pairs(slotsChildren) do
		if slot:IsA("Frame") then
			index +=1
			amountOfSlots[index] = {slot}
		end
	end

	return amountOfSlots
end

function guiHandler:CheckAvailableFrame()
	for i, availableSlot in ipairs(self.slots) do
		if not availableSlot[1]:FindFirstChildWhichIsA("ImageLabel") then
			print("slot is empty, assigning item to slot:", i, availableSlot)

			local data = {availableSlot[1], i}
			return data
		end
	end
end

function guiHandler:SetItemOnInventory(item)
	local slotData = self:CheckAvailableFrame()
	local itemIcon = item.Icon:Clone()
	slotData.instanceID = self.actualItemInstanceID
	slotData.item = item
	itemIcon.Parent = slotData[1]

	self.actualInventory[tostring(slotData[1])] = slotData
end

function guiHandler:RemoveItemFromInventory(item, slot)
	self.actualInventory[slot.Name] = nil
end

function guiHandler:OnMouseClicked(player, slot)
	if slot:FindFirstChildWhichIsA("ImageLabel") then
		local actualSlotOnInventory = self.actualInventory[tostring(slot.Name)]
		local instanceID = actualSlotOnInventory.instanceID
		local itemObject = actualSlotOnInventory.item
		local componentItem = self.object.Components.item[instanceID]

		self.object:m_SetItem(player, itemObject)
		componentItem:CreateHandle(itemObject)

		slot.Icon:Destroy()
		self:RemoveItemFromInventory(itemObject, slot)
		print("Slot clicked", slot)
		self.object:m_PublishTopic("SlotClicked", player, slot, self.instanceID)
	else
		--print("no item to click")
		return nil
	end
end

warn("Gui version:", versionN)

return guiHandler