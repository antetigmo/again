local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage= game:GetService("ServerStorage")
local PlayersService = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")

local classManager = {}

classManager.__index = classManager
local modVersion = "0.0.0"

classManager.instanceNumber = 0

function classManager.new(object, player, componentFolder, componentArray)
	classManager.instanceNumber += 1	-- object main, player, componentFolder, specific array.
	local self = setmetatable({}, classManager)
	-- ALL CLASSES MUST HAVE THESE \/
	self.object = object
	self.player = player
	self.name = "classManager"
	self.instanceID = classManager.instanceNumber
	---------------------------------------------

	self.object.Components = {}
	self.object.Components[self.name] = self
	
	self.componentFolder = componentFolder
	self.classComponentsFolder = ServerStorage.Components
	self.componentsArray = componentArray
	
	return self
end

function classManager:Init()
	warn("classManager initiated for class:", self.object.name)

	self:LoadComponents()
end

function classManager:LoadComponents() -- USED ONLY FOR THE CLASS
	if not self.componentsArray then
		return warn("There is no components to iterate, or it's a component class not a main class one.")	
	end
	for _, component in self.componentsArray do

		local Components = self.object.Components

		local compModule = require(self.classComponentsFolder:FindFirstChild(component))
		local newComp = compModule.new(self.object, self.player)
		newComp:Init()

		Components[newComp.name] = {}
		Components[newComp.name] = newComp
	end
end

function classManager:AddAll(instanceFolder, tag) -- ADD ALL COMPONENTS TO THE DESIRED PART IF IT HAVE THE TAG.
	local instancesArray = instanceFolder.getChildren()
	if not instanceFolder then
		return print("No instance folder, AddAll didn't worked.")
	end
	
	for _, instance in instancesArray do
		if CollectionService:HasTag(instance, tag) then
			self:AddComponents(instance)
			warn("Creating components for instance:", instance)
		end
	end
end

function classManager:AddComponents(instance)    -- ADD ALL COMPONENTS THAT THE INSTANCE HAS TAGGED.
	for _, tag in CollectionService:GetTags(instance) do
		local component = self.componentFolder:FindFirstChild(tag)
		if component then
			self:CreateComponent(instance, component)
		end
	end	
end

function classManager:AddSpecificComponent(instance, component, componentArray)
	if not componentArray then					 -- ADD ANY SPECIFIC COMPONENT, OR AN SPECIFIC ARRAY.
		local actualComponent = self.componentFolder:FindFirstChild(component)
		self:CreateComponent(instance, actualComponent)
		return
	end
	
	for _, tag in componentArray do
		local component = self.componentFolder:FindFirstChild(tag)
		if component then
			self:CreateComponent(instance, component)
		end
	end
end

function classManager:CreateComponent(instance, componentScript, ...) -- CREATE AND INIT A COMPONENT
	local compModule = require(componentScript)						  -- ALSO ADDRESS IN OBJ ARRAY
	local newComp = compModule.new(self.object, self.player, instance)

	if self.object.Components[newComp.name] then
		table.insert(self.object.Components[newComp.name], newComp.instanceID, newComp)
	else
		self.object.Components[newComp.name] = {}
		table.insert(self.object.Components[newComp.name], newComp.instanceID, newComp)
	end

	newComp:Init()

	warn("Component", newComp.name, "created for instance:",instance)
end

function classManager:GetComponent(componentsArray, name, instanceID)
	if self.object.Components[name] then
		return self.object.Components[name][instanceID]
	else
		warn("Component not found")
		return nil
	end
end


return classManager
