local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
---
local vehicleSysModule = require(ServerStorage.VehicleSys.VehicleSysModule)

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

local serverInstanceOBJ = require(ServerStorage.Components.ServerInstance).new("VehicleSysServer")
serverInstanceOBJ:Init()

local serverClassManagerOBJ = require(ServerStorage.Components.ClassManager).new(serverInstanceOBJ, "serverClassManagerOBJ", ServerStorage.VehicleSys.Components, nil)
serverClassManagerOBJ:Init()

serverInstanceOBJ["mainsReferences"] = mainsReferences

mainsReferences[serverClassManagerOBJ.player] = serverClassManagerOBJ


serverClassManagerOBJ:AddComponents(game.Workspace.SomeCar)
serverClassManagerOBJ:AddComponents(game.Workspace.SomeCar2)
serverClassManagerOBJ:AddComponents(game.Workspace.TestPart)