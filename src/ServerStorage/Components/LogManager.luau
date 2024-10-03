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
	
	self.logs = {}
	return self
end

function LogManager:Init()
	warn("LogManager initiated for class:", self.object.name)
end

function LogManager:AddLog(log)
    table.insert(self.logs, log)
end

function LogManager:Classify()
    local classifiedLogs = {
        serverInstance = {},
        vehicle = {},
        classManager = {},
        eventManager = {},
        other = {}
    }

    for _, log in ipairs(self.logs) do
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

    for category, logs in pairs(classifiedLogs) do
        print("Logs for category:", category)
        for _, log in ipairs(logs) do
            print(log)
        end
    end

	print(classifiedLogs)
end

function LogManager:CheckStatus(component)
    if component.InitStatus == true then
        print("Component:", component.name, "has initialized correctly, status is:", component.InitStatus)
    else
        print("Component:", component.name, "has failed to initialize.")
    end
end
return LogManager