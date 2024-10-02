local LogManager = {}
LogManager.__index = LogManager
LogManager.instanceNumber = 0

local debugLogs = {}

function LogManager.new(object, player, ...)
	LogManager.instanceNumber += 1
	local self = setmetatable({}, LogManager)
	local args = {...}
	
	-- ALL CLASSES MUST HAVE THESE \/
	self.object = object
	self.player = player
	self.name = "LogManager"
	self.instanceID = LogManager.instanceNumber
	---------------------------------------------
	
	return self
end

function LogManager:Init()
	warn("LogManager initiated for class:", self.object.name)
end

function LogManager:Classify(textArray) -- Classify all of your's logs, and print them.
	local classifiedLogs = {
		serverInstance = {},
		vehicle = {},
		classManager = {},
		eventManager = {},
		other = {}
	}
	
	for _, log in ipairs(debugLogs) do
		if string.find(log, "ServerInstance") then
			table.insert(classifiedLogs.serverInstance, log)
		elseif string.find(log, "vehicle") then
			table.insert(classifiedLogs.vehicle, log)
		elseif string.find(log, "classManager") then
			table.insert(classifiedLogs.classManager, log)
		elseif string.find(log, "eventManager") then
			table.insert(classifiedLogs.eventManager, log)
		else
			table.insert(classifiedLogs.other, log)
		end
	end
end

function LogManager:CheckStatus(component) -- Verify if the current component is initialized correctly.
	if component.InitStatus == true then
		return print("Component:", component, component.name, "has initialized correctly, status is:", component.InitStatus)
	end
end
return LogManager