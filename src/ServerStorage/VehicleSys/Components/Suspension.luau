local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage= game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")
-----------------
local ClassManager = require(ServerStorage.Components.ClassManager)

local suspension = {}
suspension.__index = suspension
suspension.instanceNumber = 0

function suspension.new(object, player, ...)
	suspension.instanceNumber += 1
	local self = setmetatable({}, suspension)
	local args = {...}
	
	-- ALL CLASSES MUST HAVE THESE \/
	self.object = object
	self.player = player
	self.name = "Suspension"
	self.instanceID = suspension.instanceNumber
	self.initStatus = false
	---------------------------------------------
	
	self.car = args[1] 
	self.wheelL = self.car.Suspension.wheelL
	self.wheelR = self.car.Suspension.wheelR
	self.rearLWheel = self.car.Suspension.rearLWheel
	self.rearRWheel = self.car.Suspension.rearLWheel

	return self
end

function suspension:Init()
	--CUSTOMS SERVICES
	local classManagerOBJ = ClassManager.new(self, self.player, ServerStorage.VehicleSys.Components, nil)
	classManagerOBJ:Init()
	-------------------------------------------
	self.Components.LogManager:AddLog("Suspension initiated for class: " .. self.object.name)
	self:CreateAllViewers()



	task.spawn(function()
		while true do
			local delta = RunService.Heartbeat:Wait()

			local chassi = self.car.Chassi 
			local weight = chassi.AssemblyMass * workspace.Gravity
			for _, wheel in self.car.Suspension:GetChildren() do
				self:IsTouchingGround(wheel)
			end

			--chassi:ApplyImpulse(Vector3.new(0, (weight * delta)*1.02, 0)) 
		end
	end)

	--self:CreateCylinderViewer(self.car.Chassi.position + Vector3.new(0,-self.car.Chassi.Size.Y,0))
	--self:CreateAllViewers()
end


function Update() -- Runs every frame.
	
end
RunService.Heartbeat:Connect(Update)

function suspension:IsTouchingGround(part) -- Check if the part is touching the floor.
	local raycast = self:CreateRaycast(part.Position, Vector3.new(0,(-part.Size.Y/2),0))
		if raycast then
			print(raycast.Material)
			--local cylinder = self:CreateCylinderViewer(part.Position + Vector3.new(0,-part.Size.Y,0), part)
			--local pos = cylinder.Position - Vector3.new(0,(-part.Size.Y/2),0)
	
		return raycast
	end
end

function suspension:CreateRaycast(origin, startPos) -- Creates a raycast from the origin
	local rayOrigin = (origin + (startPos)) or origin
	local rayDirection = Vector3.new(0, -10, 0)

	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {self.Parent}
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	
	local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
	if raycastResult then
		--print("Instance:", raycastResult.Instance)
		--print("Position:", raycastResult.Position)
		--print("Distance:", raycastResult.Distance)
		--print("Material:", raycastResult.Material)
		--print("Normal:", raycastResult.Normal)
	else
		warn("No raycast result!")
	end
	return raycastResult
end

function suspension:CreateCylinderViewer(origin, parent)
	--- CYLINDER PART
	local cylinder = game.Workspace.Laser:Clone()
	cylinder.CanCollide = false
	cylinder.Position = origin
	cylinder.Parent = parent or workspace
	cylinder.Color = Color3.new(1, 0, 0)
	return cylinder
end

function suspension:CreateAllViewers() -- Create viewers for all wheels, debug
	local supensionFolder = self.car.Suspension:GetChildren()
	for _, wheels in supensionFolder do
		self:CreateCylinderViewer(wheels.Position + Vector3.new(0,-wheels.Size.Y+0.5,0))
	end
end

return suspension


--if self.car.Name == "SomeCar2" then
	--print(rayOrigin.y)
--end
--1, 4, 4 tamanho da roda