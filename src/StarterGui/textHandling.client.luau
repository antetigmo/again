local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local vehicleSystemEvents = ReplicatedStorage.vehicleSystemEvents

local localPlayer = Players.LocalPlayer

local userGui = script.Parent.userGui
local directionDebug = userGui.Main.directionDebug
local dDebugDefault = directionDebug.Text

local aKey = vehicleSystemEvents.Debug.OnClientEvent:Connect(function(player, lAngle, angle)
	if player == localPlayer then
		directionDebug.Text = "Direction angle: "..tostring(angle)
	end
end)

local dKey = vehicleSystemEvents.Debug.OnClientEvent:Connect(function(player, rAngle, angle)
	if player == localPlayer then
		directionDebug.Text = "Direction angle: "..tostring(angle)
	end
end)
