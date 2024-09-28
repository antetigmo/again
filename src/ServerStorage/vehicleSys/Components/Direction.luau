local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local vehicleSystemEvents = ReplicatedStorage.vehicleSystemEvents

local direction = {}
direction.__index = direction
direction.instanceNumber = 0

MAX_ANGLE = 30 
STEERING_SPEED = 6
ACKERMANN = 1.2

function direction.new(object, player, ...)
	direction.instanceNumber += 1
	local self = setmetatable({}, direction)
	local args = {...}

	-- ALL CLASSES MUST HAVE THESE \/
	self.object = object
	self.player = player
	self.name = "direction"
	self.instanceID = direction.instanceNumber
	---------------------------------------------
	
	self.Car = nil
	
	if self.Car then
		self.leftWheel = self.Car.Suspension.wheelL
		self.rightWheel = self.Car.Suspension.wheelR
		self.DEFAULT_CFRAME_LEFT = self.leftWheel.CFrame
		self.DEFAULT_CFRAME_RIGHT = self.rightWheel.CFrame
	end

	self.lAngle = 0
	self.rAngle = 0
	self.angle = 0

	self.isPressed = false

	return self
end

function direction:Init()
	print("Direction initiated for class:", self.object.name)
	self:AddressEvents()
end

function direction:AddressEvents()
	self.aKey = vehicleSystemEvents.Keyboard.OnServerEvent:Connect(function(player, input, status)	
		if player == self.player then
			if input == Enum.KeyCode.A and self.Car then
				self:CalculateDirection(input, status)
			end
		end
	end)

	self.dKey = vehicleSystemEvents.Keyboard.OnServerEvent:Connect(function(player, input, status)
		if player == self.player then
			if input == Enum.KeyCode.D and self.Car then
				self:CalculateDirection(input, status)
			end
		end
	end)

end

function direction:Left()
	local leftCFrame = self.leftWheel.CFrame
	local rightCFrame = self.rightWheel.CFrame

	if self.lAngle > -MAX_ANGLE * ACKERMANN then
		leftCFrame = leftCFrame * CFrame.Angles(0, math.rad(1*ACKERMANN), 0)
		self.leftWheel.CFrame = leftCFrame

		if self.angle < MAX_ANGLE then
			rightCFrame = rightCFrame * CFrame.Angles(0,math.rad(1),0)
			self.rightWheel.CFrame = rightCFrame
			
		end
	end	
end

function direction:Right()
	local leftCFrame = self.leftWheel.CFrame
	local rightCFrame = self.rightWheel.CFrame
	
	if self.rAngle < MAX_ANGLE * ACKERMANN then
		rightCFrame = rightCFrame * CFrame.Angles(0, math.rad((1*ACKERMANN)*-1), 0)
		self.rightWheel.CFrame = rightCFrame

		if self.angle < MAX_ANGLE then
			leftCFrame = leftCFrame * CFrame.Angles(0,math.rad(1*-1),0)
			self.leftWheel.CFrame = leftCFrame
		end
	end	
end

function direction:CalculateDirection(input, status)
	if status == "Pressed" then
		
		self.isPressed = true	

		task.spawn(function()	
			while self.isPressed do
				if input == Enum.KeyCode.A then
					self.angle -= 1				
					self.angle = math.clamp(self.angle, -MAX_ANGLE, MAX_ANGLE)
					
					self.lAngle = self.angle*ACKERMANN
					self:Left()
				elseif input == Enum.KeyCode.D then
					self.angle += 1
					self.angle = math.clamp(self.angle, -MAX_ANGLE, MAX_ANGLE)
					
					self.rAngle = self.angle*ACKERMANN
					self:Right()
				end

				task.wait(1/STEERING_SPEED^2)
				vehicleSystemEvents.Debug:FireClient(self.player, self.player, self.angle)
			end
		end)	
	else
		self:Released() 
	end
end

function direction:Released()
	self.isPressed = false
	
	self.angle = 0 
	
	self.leftWheel.CFrame = self.DEFAULT_CFRAME_LEFT
	self.rightWheel.CFrame = self.DEFAULT_CFRAME_RIGHT

	vehicleSystemEvents.Debug:FireClient(self.player, self.player, self.angle)
end

return direction