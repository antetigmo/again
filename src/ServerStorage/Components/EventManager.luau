local eventManager = {}
eventManager.__index = eventManager
eventManager.InstanceNumber = 0

function eventManager.new(object, player)
	eventManager.InstanceNumber += 1
	local self = setmetatable({}, eventManager)
	-- ALL CLASSES MUST HAVE THESE \/
	self.Object = object
	self.Player = player
	self.Name = "EventManager"
	self.InstanceID = eventManager.InstanceNumber
	---------------------------------------------
	
	self._topicEvent = Instance.new("BindableEvent")
	self.Events = {}
	self.Args = {}

	return self
end

function eventManager:Init()
	--warn("eventManager initiated for class:", self.Object.name)
end

function eventManager:ConnectEvent(eventName, callback)
	local function ObjectOnArray(array)
		if not self[array][self.Object.Name] then
			self[array][self.Object.Name] = {}
		end
	end
	
	local eventSubscription = self:SubscribeTopic(eventName, function(player, ...)
		ObjectOnArray("Args")

		self.Args[self.Object.Name][eventName] = {player, ...}
		print(self.Args)

		callback(unpack(self.Args[self.Object.Name][eventName]))
		warn(eventName, "event, arrived at eventManager")
	end)

	ObjectOnArray("events")
	self.Events[self.Object.Name][eventName] = eventSubscription
	--print(self.Events)
	
	return eventSubscription
end

function eventManager:DisconnectEvent(eventName)
	warn("--- Disconnection incoming ---")
	self.Events[self.Object.Name][eventName]:Disconnect()
	self.Events[self.Object.Name][eventName] = nil

	local objName = self.Object.Name
	warn("2 - ",eventName, "Disconnected.", eventName, "connected status is:", self.Events[objName][eventName].Connected)
	warn(self.Events)
end

function eventManager:ResetEvent(eventName)
	self:DisconnectEvent(eventName)
	self:ConnectEvent(eventName)
end

--function eventManager:DisconnectAll() -- Disconnect all events

--end

function eventManager:PublishTopic(topicName, player, ...)
	self._topicEvent:Fire(topicName, player, ...)	
	print("Published topic: " .. topicName)
end

function eventManager:SubscribeTopic(topicName, callBack)
	local connection = self._topicEvent.Event:Connect(function(name, player, ...)
		if name == topicName then
			callBack(player, ...)
		end
	end)
	return connection
end

return eventManager