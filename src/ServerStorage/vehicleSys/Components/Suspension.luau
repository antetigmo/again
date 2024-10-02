local RunService = game:GetService("RunService")

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
	self.name = "suspension"
	self.instanceID = suspension.instanceNumber
	---------------------------------------------
	
	self.Car = args[1] 
	
	return self
end

function suspension:Init()
	print("Suspension initiated for class:", self.object.name)
	
	--self:CreateAllViewers()

	task.wait(2)
	
	task.spawn(function()
		while true do
			local delta = RunService.Heartbeat:Wait()

			local chassi = self.Car.Chassi 
			local weight = chassi.AssemblyMass * workspace.Gravity

			--chassi:ApplyImpulse(Vector3.new(0, (weight * delta)*1.02, 0)) 
		end
	end)
end

function suspension:CreateRaycast(origin) -- Creates a raycast from the origin
	local rayOrigin = origin  - Vector3.new(0,3,0)
	local rayDirection = Vector3.new(0, -10, 0)
	
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {script.Parent}
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	
	local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
	return raycastResult
end

function suspension:CreateCylinderViewer(origin)
	local rayOrigin = origin  - Vector3.new(0,3,0)

	--- CYLINDER PART
	local cylinder = game.Workspace.Laser:Clone()
	cylinder.Position = rayOrigin
	cylinder.Parent = workspace
end

function suspension:CreateAllViewers()
	self.AllWheels = {}
	
	--- ADDRESS ALL VEHICLE WHEELS TO THE ALLWHEELS ARRAY
	local supensionFolder = self.Car.Suspension:GetChildren()
	for i, v in supensionFolder do
		table.insert(self.AllWheels, v)
		self:CreateCylinderViewer(v.Position)
	end
	-----------------------------------------------------
end

return suspension





--1, 4, 4 tamanho da roda