local LogManager = {}
LogManager.__index = LogManager
LogManager.instanceNumber = 0

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
    "Other"
}

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
	
	self.Logs = {}
    self.ClassifiedTags = {}
	return self
end

function LogManager:Init()
	warn("LogManager initiated for class:", self.object.name)
    self:AddClassifiedTags(nil, defaultTags)
    self:ClassifyLogs()
end

function LogManager:AddLog(log)
    table.insert(self.Logs, log)
    self:ClassifyLogs()
end

function LogManager:PrintClassifiedTags() -- Print in the console the classified logs.
    for category, logs in pairs(self.ClassifiedTags) do
        print("Logs for category:", category)
        for _, log in ipairs(logs) do
            print(log)
        end
    end
end

function LogManager:ClassifyLogs() -- Classify logs inside of self.logs into self.ClassifiedTags
    for _, log in self.Logs do
        local foundTag = false 

        for claTag, _ in self.ClassifiedTags do
            if string.find(log, claTag) then
                table.insert(self.ClassifiedTags[claTag], log)
                foundTag = true 
                break
            end  
        end

        if not foundTag then
            table.insert(self.ClassifiedTags["Other"], log)
        end     
    end

end

function LogManager:AddClassifiedTags(tag, arrayOfTags) -- Add tags to ClassifiedTags table.
    if arrayOfTags then
        for _, tagV in arrayOfTags do
            self.ClassifiedTags[tagV] = {}
        end
        return
    end
    self.ClassifiedTags[tag] = {} 
end

function LogManager:CheckStatus(component)
    if component.InitStatus == true then
        print("Component:", component.name, "has initialized correctly, status is:", component.InitStatus)
    else
        print("Component:", component.name, "has failed to initialize.")
    end
end

return LogManager