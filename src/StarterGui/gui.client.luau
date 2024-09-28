local ReplicatedStorage = game:GetService("ReplicatedStorage")

local inventorySystemEvents = ReplicatedStorage.inventorySystemEvents
local ClientToServer = inventorySystemEvents.ClickInventory

local inventoryUi = script.Parent.inventoryUi

function AddressSlots()
	local slotsChildren = inventoryUi.Main.ScrollingFrame:GetChildren()
	local amountOfSlots = {}
	local index = 0

	for _, slot in pairs(slotsChildren) do
		if slot:IsA("Frame") then
			index +=1
			amountOfSlots[index] = {
				event = slot.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						ClientToServer:FireServer(slot, amountOfSlots)
						--print(slot, "onClient")
					end
				end),
				slot,
			}
		end
	end

	return amountOfSlots
end

AddressSlots()

