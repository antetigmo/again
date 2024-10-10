local logManager = {}
logManager.__index = logManager
logManager.InstanceNumber = 0

local defaultTags = {
    "ClassManager",
    "EventManager",
    "ServerInstance",
    "Vehicle",
    "Button",
    "EnterVehicle",
    "Suspension",
    "Transmission",
    "Engine",
    "Direction",
    "Chassi",
    "LogManager",
    "Other"
}

function logManager.new(object, player, ...)
	logManager.InstanceNumber += 1
	local self = setmetatable({}, logManager)
	local args = {...}
	
	-- ALL CLASSES MUST HAVE THESE \/
	self.object = object
	self.player = player
	self.name = "LogManager"
	self.instanceID = logManager.InstanceNumber
	---------------------------------------------
	
	self.logs = {}
    self.classifiedTags = {}
	return self
end

function logManager:Init()
    self:AddclassifiedTags(nil, defaultTags)

    if self.classifiedTags == nil then task.wait() end
    self:ClassifyAllLogs()

    self:AddLog("LogManager initiated for class: " .. self.object.name)
end

function logManager:AddLog(log)
    table.insert(self.logs, log)
    self:ClassifyLog(log)
end

function logManager:ShowLogs() -- Print in the console the classified logs.
    warn(self.object.name, "Called for ShowLogs.")
    for category, logs in pairs(self.classifiedTags) do
        if #logs > 0 then
            print("Logs for category:", category)
            local logArray = {}
        
            for _, log in ipairs(logs) do
                table.insert(logArray, log)
            end
            print(logArray)
        end
    end
end

function logManager:ClassifyAllLogs() -- Classify all logs inside of self.logs into self.classifiedTags.
    for _, log in self.logs do
        self:ClassifyLog(log)
    end
end

function logManager:ClassifyLog(log) -- Classify a log inside of self.logs into self.classifiedTags.
    local foundTag = false 

    for _, logs in self.classifiedTags do    -- Check if the log is already in self.classifiedTags.
        for _, existingLog in logs do               -- If it is, then return.
            if existingLog == log then
                return
            end
        end
    end

    for claTag, _ in self.classifiedTags do    -- Check if the log has a classified tag(word) in self.classifiedTags.
        if string.find(log, claTag) then       -- If it has then the insert and loop is broke.
            table.insert(self.classifiedTags[claTag], log)
            foundTag = true 
            break
        end  
    end

    if not foundTag then                       -- If the a claTag was not found on the log, then add it to "Other"
        table.insert(self.classifiedTags["Other"], log)
    end     
end

function logManager:AddclassifiedTags(tag, arrayOfTags) -- Add tags to classifiedTags table.
    if arrayOfTags then
        for _, tagV in arrayOfTags do
            self.classifiedTags[tagV] = {}
        end
        return
    end
    self.classifiedTags[tag] = {} 
end

function logManager:CheckStatus(component)
    if component.InitStatus == true then
        print("Component:", component.name, "has initialized correctly, status is:", component.initStatus)
    else
        print("Component:", component.name, "has failed to initialize.")
    end
end

return logManager