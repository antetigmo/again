local directionAnimation = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vehicleSystemEvents = ReplicatedStorage.vehicleSystemEvents

-- Constants
MAX_ANGLE = 30 
STEERING_SPEED = 6
ACKERMANN = 1.2

local localScript = script
local leftWheel
local rightWheel
local DEFAULT_CFRAME_LEFT
local DEFAULT_CFRAME_RIGHT

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Angles
local lAngle = 0
local rAngle = 0
local angle = 0

-- Flag
local isPressed = false

vehicleSystemEvents.Entered.OnClientEvent:Connect(function(car)
    leftWheel = car.Suspension.wheelL
    rightWheel = car.Suspension.wheelR
    DEFAULT_CFRAME_LEFT = leftWheel.CFrame
    DEFAULT_CFRAME_RIGHT = rightWheel.CFrame

    vehicleSystemEvents.Keyboard.Event:Connect(function(input, status)
        if input == Enum.KeyCode.A or input == Enum.KeyCode.D then
            directionAnimation.CalculateDirection(input, status)
        end
    end)
end)

function directionAnimation.Left()
    local leftCFrame = leftWheel.CFrame
    local rightCFrame = rightWheel.CFrame

    if lAngle > -MAX_ANGLE * ACKERMANN then
        leftCFrame = leftCFrame * CFrame.Angles(0, math.rad(1 * ACKERMANN), 0)
        leftWheel.CFrame = leftCFrame

        if angle < MAX_ANGLE then
            rightCFrame = rightCFrame * CFrame.Angles(0, math.rad(1), 0)
            rightWheel.CFrame = rightCFrame
        end
    end
end

function directionAnimation.Right()
    local leftCFrame = leftWheel.CFrame
    local rightCFrame = rightWheel.CFrame

    if rAngle < MAX_ANGLE * ACKERMANN then
        rightCFrame = rightCFrame * CFrame.Angles(0, math.rad((1 * ACKERMANN) * -1), 0)
        rightWheel.CFrame = rightCFrame

        if angle < MAX_ANGLE then
            leftCFrame = leftCFrame * CFrame.Angles(0, math.rad(1 * -1), 0)
            leftWheel.CFrame = leftCFrame
        end
    end
end

function directionAnimation.CalculateDirection(input, status)
    if status == "Pressed" then
        isPressed = true

        task.spawn(function()
            while isPressed do
                if input == Enum.KeyCode.A then
                    angle = math.clamp(angle - 1, -MAX_ANGLE, MAX_ANGLE)
                    lAngle = angle * ACKERMANN
                    directionAnimation.Left()
                elseif input == Enum.KeyCode.D then
                    angle = math.clamp(angle + 1, -MAX_ANGLE, MAX_ANGLE)
                    rAngle = angle * ACKERMANN
                    directionAnimation.Right()
                end

                task.wait(1 / STEERING_SPEED ^ 2)
            end
        end)
    else
        directionAnimation.Released()
    end
end

function directionAnimation.Released()
    isPressed = false
    angle = 0

    if leftWheel and rightWheel then
        leftWheel.CFrame = DEFAULT_CFRAME_LEFT
        rightWheel.CFrame = DEFAULT_CFRAME_RIGHT
    end
end

