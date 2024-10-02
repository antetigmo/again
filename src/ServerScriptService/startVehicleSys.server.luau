local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
---
local vehicleSysModule = require(ServerStorage.vehicleSys.VehicleSysModule)
local mainReferences = {}


Players.PlayerAdded:Connect(function(player)
	local vehicleSysModuleOBJ = vehicleSysModule.new(player)
    vehicleSysModuleOBJ:m_Init()
    
    table.insert(mainReferences, vehicleSysModuleOBJ)
    print(mainReferences)
end)

local classComponents = {"EventManager"}

local ServerInstance = require(ServerStorage.Components.ServerInstance)
local ClassManager = require(ServerStorage.Components.ClassManager)

local serverInstanceOBJ = ServerInstance.new("serverInstance")
serverInstanceOBJ:Init()

local serverClassManager = ClassManager.new(serverInstanceOBJ, "ServerClassManager", ServerStorage.vehicleSys.Components, classComponents)
serverClassManager:Init()

serverClassManager:AddComponents(game.Workspace.SomeCar)
serverClassManager:AddComponents(game.Workspace.SomeCar2)
serverClassManager:AddComponents(game.Workspace.TestPart)