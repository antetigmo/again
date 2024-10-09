local logManager = {}
logManager.__index = logManager
logManager.InstanceNumber = 0

local DefaultTags = {
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
	self.Object = object
	self.Player = player
	self.Name = "LogManager"
	self.InstanceID = logManager.InstanceNumber
	---------------------------------------------
	
	self.Logs = {}
    self.ClassifiedTags = {}
	return self
end

function logManager:Init()
    self:AddClassifiedTags(nil, DefaultTags)

    if self.ClassifiedTags == nil then task.wait() end
    self:ClassifyAllLogs()

    self:AddLog("logManager initiated for class:", self.Object.Name)
end

function logManager:AddLog(log)
    table.insert(self.Logs, log)
    self:ClassifyLog(log)
end

function logManager:PrintClassifiedTags() -- Print in the console the classified logs.
    for category, logs in self.ClassifiedTags do
        print("Logs for category:", category)
        for _, log in ipairs(logs) do
            print(log)
        end
    end
end

function logManager:ClassifyAllLogs() -- Classify all logs inside of self.logs into self.ClassifiedTags.
    for _, log in self.Logs do
        self:ClassifyLog(log)
    end
end

function logManager:ClassifyLog(log) -- Classify a log inside of self.logs into self.ClassifiedTags.
    local foundTag = false 

    for _, logs in self.ClassifiedTags do    -- Check if the log is already in self.ClassifiedTags.
        for _, existingLog in logs do               -- If it is, then return.
            if existingLog == log then
                return
            end
        end
    end

    for claTag, _ in self.ClassifiedTags do    -- Check if the log has a classified tag(word) in self.ClassifiedTags.
        if string.find(log, claTag) then       -- If it has then the insert and loop is broke.
            table.insert(self.ClassifiedTags[claTag], log)
            foundTag = true 
            break
        end  
    end

    if not foundTag then                       -- If the a claTag was not found on the log, then add it to "Other"
        table.insert(self.ClassifiedTags["Other"], log)
    end     
end

function logManager:AddClassifiedTags(tag, arrayOfTags) -- Add tags to ClassifiedTags table.
    if arrayOfTags then
        for _, tagV in arrayOfTags do
            self.ClassifiedTags[tagV] = {}
        end
        return
    end
    self.ClassifiedTags[tag] = {} 
end

function logManager:CheckStatus(component)
    if component.InitStatus == true then
        print("Component:", component.Name, "has initialized correctly, status is:", component.InitStatus)
    else
        print("Component:", component.Name, "has failed to initialize.")
    end
end

return logManager