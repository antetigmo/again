local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage= game:GetService("ServerStorage")
local PlayersService = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")

local classManager = {}
classManager.__index = classManager
classManager.instanceNumber = 0

function classManager.new(object, player, componentFolder, componentArray)
	classManager.instanceNumber += 1	
	local self = setmetatable({}, classManager)
	-- ALL CLASSES MUST HAVE THESE \/
	self.object = object
	self.player = player
	self.name = "ClassManager"
	self.instanceID = classManager.instanceNumber
	---------------------------------------------

	self.object.Components = {}
	self.object.Components[self.name] = self
	
	self.componentFolder = componentFolder	-- Folder where the class components are.
	self.componentsArray = componentArray -- An array to the created class spawn with components.
	self.gComponents = ServerStorage.GComponents
	
	return self
end

function classManager:Init()
	self:LoadComponents({"EventManager", "LogManager"})

	local LogManager = require(ServerStorage.Components.LogManager)
	self.logManagerOBJ = LogManager.new(self, self.name)
	self.logManagerOBJ:Init()
	self.logManagerOBJ:AddLog("ClassManager initiated for class: " .. self.object.name)

end

function classManager:LoadComponents(specificComponent) -- Load a component class, speciFicComponent can be an array.
	if self.componentsArray then -- componentsArray is an array that you specify, to load components in that array.
		for _, component in self.componentsArray do
			if component then
				local Components = self.object.Components
				local compModule = require(ServerStorage.Components:FindFirstChild(component))
				local newComp = compModule.new(self.object, self.player)
				newComp:Init()
	
				Components[newComp.name] = newComp
			else
				self.logManagerOBJ:AddLog("Component: "..tostring(component).." doesn't exist, ClassManager DEBUG.")	
			end
		end
	end
	
	if specificComponent then
		for _, component in specificComponent do
			if component then
				local Components = self.object.Components

				local compModule = require(ServerStorage.Components:FindFirstChild(component))
				local newComp = compModule.new(self.object, self.player)
				newComp:Init()

				Components[newComp.name] = {}
				Components[newComp.name] = newComp
			else
				self.logManagerOBJ:AddLog("Component: "..tostring(component).." doesn't exist, ClassManager DEBUG.")
			end	
		end
	end
end

function classManager:AddComponents(instance)    -- Add all components, that the instance has tagged.
	for _, tag in CollectionService:GetTags(instance) do
		local component = self.componentFolder:FindFirstChild(tag)
		if component then
			self:CreateComponent(instance, component)
		else
			self.logManagerOBJ:AddLog("Component: "..tostring(component).." doesn't exist, ClassManager DEBUG.")	
		end
	end	
end


-- AddSpecificComponet adds any specific component, a specific array, or a globalComponent a instance.
-- WARN, componentArray, and gComponents must be an array.

function classManager:AddSpecificComponent(instance, component, componentArray, gComponents)
	if component then
		local actualComponent = self.componentFolder:FindFirstChild(component)
		if actualComponent then
			self:CreateComponent(instance, actualComponent)
		else
			self.logManagerOBJ:AddLog("Component: "..tostring(component).." doesn't exist, ClassManager DEBUG.")
		end
	end
	if componentArray then
		for _, tag in componentArray do
			local component = self.componentFolder:FindFirstChild(tag)
			if component then
				self:CreateComponent(instance, component)
			else
				self.logManagerOBJ:AddLog("Component: "..tostring(component).." doesn't exist, ClassManager DEBUG.")	
			end
		end
	end
	if gComponents then
		for _, component in gComponents do
			local component = self.gComponents:FindFirstChild(component)
			if component then
				self:CreateComponent(instance, component)
			else
				self.logManagerOBJ:AddLog("Component: "..tostring(component).." doesn't exist, ClassManager DEBUG.")	
			end
		end
	end
end

function classManager:CreateComponent(instance, componentScript, ...) -- Create and init a component.
	local compModule = require(componentScript)						  -- Also address it on the component/object.
	local newComp = compModule.new(self.object, self.player, instance)

	if self.object.Components[newComp.name] then
		table.insert(self.object.Components[newComp.name], newComp.instanceID, newComp)
	else
		self.object.Components[newComp.name] = {}
		table.insert(self.object.Components[newComp.name], newComp.instanceID, newComp)
	end

	newComp:Init()
	
	self.logManagerOBJ:AddLog("Component " .. newComp.name ..  " created for instance: " .. tostring(instance))
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
