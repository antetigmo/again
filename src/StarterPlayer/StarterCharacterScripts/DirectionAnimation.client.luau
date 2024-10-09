local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage= game:GetService("ServerStorage")
local StarterGui = game:GetService("StarterGui")

local vehicleSystemEvents = ReplicatedStorage.vehicleSystemEvents

MAX_ANGLE = 30 
STEERING_SPEED = 6
ACKERMANN = 1.2

player = player
name = "Direction"---

local car = nil
vehicleSystemEvents.Debug.OnClientEvent:Connect(function(actualCar)
    car =  actualCar
end)   

local leftWheel = car.Suspension.wheelL
local rightWheel = car.Suspension.wheelR
local DEFAULT_CFRAME_LEFT = leftWheel.CFrame
local DEFAULT_CFRAME_RIGHT = rightWheel.CFrame

local lAngle = 0
local rAngle = 0
local angle = 0

local isPressed = false


local aKey = vehicleSystemEvents.Keyboard.OnServerEvent:Connect(function(player, input, status)	
	if input == Enum.KeyCode.A then
		CalculateDirection(input, status)
	end
end)
    
local dKey = vehicleSystemEvents.Keyboard.OnServerEvent:Connect(function(player, input, status)
	if input == Enum.KeyCode.D then
		CalculateDirection(input, status)
	end
end)

function Left()
	local leftCFrame = leftWheel.CFrame
	local rightCFrame = rightWheel.CFrame

	if lAngle > -MAX_ANGLE * ACKERMANN then
		leftCFrame = leftCFrame * CFrame.Angles(0, math.rad(1*ACKERMANN), 0)
		leftWheel.CFrame = leftCFrame

		if angle < MAX_ANGLE then
			rightCFrame = rightCFrame * CFrame.Angles(0,math.rad(1),0)
			rightWheel.CFrame = rightCFrame
			
		end
	end	
end

function Right()
	local leftCFrame = leftWheel.CFrame
	local rightCFrame = rightWheel.CFrame
	
	if rAngle < MAX_ANGLE * ACKERMANN then
		rightCFrame = rightCFrame * CFrame.Angles(0, math.rad((1*ACKERMANN)*-1), 0)
		rightWheel.CFrame = rightCFrame

		if angle < MAX_ANGLE then
			leftCFrame = leftCFrame * CFrame.Angles(0,math.rad(1*-1),0)
			leftWheel.CFrame = leftCFrame
		end
	end	
end

function CalculateDirection(input, status)
	if status == "Pressed" then
		
		isPressed = true	

		task.spawn(function()	
			while isPressed do
				if input == Enum.KeyCode.A then
					angle -= 1				
					angle = math.clamp(angle, -MAX_ANGLE, MAX_ANGLE)
					
					lAngle = angle*ACKERMANN
					Left()
				elseif input == Enum.KeyCode.D then
					angle += 1
					angle = math.clamp(angle, -MAX_ANGLE, MAX_ANGLE)
					
					rAngle = angle*ACKERMANN
					Right()
				end

				task.wait(1/STEERING_SPEED^2)
			end
		end)	
	else
		Released() 
	end
end

function Released()
	isPressed = false
	
	angle = 0 
	
	leftWheel.CFrame = DEFAULT_CFRAME_LEFT
	rightWheel.CFrame = DEFAULT_CFRAME_RIGHT
end
