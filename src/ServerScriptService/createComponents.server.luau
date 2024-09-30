local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage= game:GetService("ServerStorage")
local PlayersService = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")

local componentsArray = {"EventManager"}						-- THIS SCRIPT, CREATE COMPONENTS FOR THE SERVER
local componentFolder = ServerStorage.vehicleSys.Components
local classComponentsFolder = ServerStorage.Components

local serverArray = {}
serverArray.Components = {}

serverArray.name = "ServerComponents"

function LoadComponents() -- USED ONLY FOR THE CLASS
	if not componentsArray then
		return warn("There is no components to iterate, no componentsArray.")	
	end
	for _, component in componentsArray do

		local Components = serverArray.Components

		local compModule = require(classComponentsFolder:FindFirstChild(component))
		local newComp = compModule.new()
		newComp:Init()

		Components[newComp.name] = {}
		Components[newComp.name] = newComp
	end
end

--function AddAll(instanceFolder, tag) -- ADD ALL COMPONENTS TO THE DESIRED PART IF IT HAVE THE TAG
--local instancesArray = instanceFolder.getChildren()
--if not instanceFolder then
--	return print("No instance folder, AddAll didn't worked.")
--end

--	for _, instance in instancesArray do
--	if CollectionService:HasTag(instance, tag) then
--		AddComponents(instance)
--		warn("Creating components for instance:", instance)
--	end
--end
--end

function AddComponents(instance)    -- ADD ALL COMPONENTS THAT THE INSTANCE HAS TAGGED
	for _, tag in CollectionService:GetTags(instance) do
		local component = componentFolder:FindFirstChild(tag)
		if component then
			CreateComponent(instance, component)
		end
	end	
end

function CreateComponent(instance, componentScript, ...)
	local compModule = require(componentScript)
	local newComp = compModule.new(serverArray, "SERVER", instance)

	if serverArray.Components[newComp.name] then
		table.insert(serverArray.Components[newComp.name], newComp.instanceID, newComp)
	else
		serverArray.Components[newComp.name] = {}
		table.insert(serverArray.Components[newComp.name], newComp.instanceID, newComp)
	end

	newComp:Init()

	warn("Component", newComp.name, "created for instance:",instance)
end

function GetComponent(componentsArray, name, instanceID)
	if serverArray.Components[name] then
		return serverArray.Components[name][instanceID]
	else
		warn("Component not found")
		return nil
	end
end


function Init()
	warn("classManager initiated for [-SERVER-].")

	AddComponents(game.Workspace.SomeCar)
	AddComponents(game.Workspace.SomeCar2)
	AddComponents(game.Workspace.TestPart)

	print(serverArray)
end

Init()