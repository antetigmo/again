local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
---
local vehicleSysModule = require(ServerStorage.vehicleSys.VehicleSysModule)

local function RefreshMainReferences(table)
    for _, mainRefs in table do
        mainRefs.mainsReferences = table
    end
end

local mainsReferences = setmetatable({},{
    __newindex = function(table, key, value)
        rawset(table, key, value)
        RefreshMainReferences(table)
    end
})

Players.PlayerAdded:Connect(function(player)
	local vehicleSysModuleOBJ = vehicleSysModule.new(player)

    mainsReferences[vehicleSysModuleOBJ.player.Name] = vehicleSysModuleOBJ 
    vehicleSysModuleOBJ["mainsReferences"] = mainsReferences

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