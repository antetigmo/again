local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
---
local inventoryModule = require(ServerStorage.InventorySys.InventorySysModule)

Players.PlayerAdded:Connect(function(player)
	local inventoryObj = inventoryModule.new(player)
    inventoryObj:m_Init()
end)
