local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
---
local vehicleSysModule = require(ServerStorage.vehicleSys.VehicleSysModule)

Players.PlayerAdded:Connect(function(player)
	local vehicleSysModule = vehicleSysModule.new(player)
    vehicleSysModule:m_Init()
end)
