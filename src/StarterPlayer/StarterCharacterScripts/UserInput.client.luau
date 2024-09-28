local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local inventorySystemEvents = ReplicatedStorage.inventorySystemEvents
local vehicleSystemEvents = ReplicatedStorage.vehicleSystemEvents

UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Backspace then
		inventorySystemEvents.ClientToServer:FireServer()
	end
end)

UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.A then
		vehicleSystemEvents.Keyboard:FireServer(input.KeyCode, "Pressed")
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.D then
		vehicleSystemEvents.Keyboard:FireServer(input.KeyCode, "Released")
	end
end)