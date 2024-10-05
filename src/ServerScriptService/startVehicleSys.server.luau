local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
---
local vehicleSysModule = require(ServerStorage.vehicleSys.VehicleSysModule)
local mainsReferences = {}

local metaTable = setmetatable({}, mainsReferences)

Players.PlayerAdded:Connect(function(player)
	local vehicleSysModuleOBJ = vehicleSysModule.new(player)

    mainsReferences[vehicleSysModuleOBJ.player.Name] = vehicleSysModuleOBJ 
    vehicleSysModuleOBJ["mainsReference"] = mainsReferences

    vehicleSysModuleOBJ:m_Init()

end)

local ServerInstance = require(ServerStorage.Components.ServerInstance)
local ClassManager = require(ServerStorage.Components.ClassManager)

local serverInstanceOBJ = ServerInstance.new("serverInstance")
serverInstanceOBJ:Init()

local serverClassManager = ClassManager.new(serverInstanceOBJ, "ServerClassManager", ServerStorage.vehicleSys.Components, nil)
serverClassManager:Init()

serverInstanceOBJ["mainsReferences"] = mainsReferences
mainsReferences[serverClassManager.player] = serverClassManager


serverClassManager:AddComponents(game.Workspace.SomeCar)
serverClassManager:AddComponents(game.Workspace.SomeCar2)
serverClassManager:AddComponents(game.Workspace.TestPart)