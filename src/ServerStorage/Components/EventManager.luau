local eventManager = {}
eventManager.__index = eventManager
eventManager.instanceNumber = 0

function eventManager.new(object, player)
	eventManager.instanceNumber += 1
	local self = setmetatable({}, eventManager)
	-- ALL CLASSES MUST HAVE THESE \/
	self.object = object
	self.player = player
	self.name = "EventManager"
	self.instanceID = eventManager.instanceNumber
	---------------------------------------------
	
	self._topicEvent = Instance.new("BindableEvent")
	self.events = {}
	self.args = {}

	return self
end

function eventManager:Init()
	--print("eventManager initiated for class:", self.object.name)
end

function eventManager:ConnectEvent(eventName, callback)
	local function objectOnArray(array)
		if not self[array][self.object.name] then
			self[array][self.object.name] = {}
		end
	end
	
	local eventSubscription = self:SubscribeTopic(eventName, function(player, ...)
		objectOnArray("args")

		self.args[self.object.name][eventName] = {player, ...}
		print(self.args)

		callback(unpack(self.args[self.object.name][eventName]))
		warn(eventName, "event, arrived at eventManager")
	end)

	objectOnArray("events")
	self.events[self.object.name][eventName] = eventSubscription
	--print(self.events)
	
	return eventSubscription
end

function eventManager:DisconnectEvent(eventName)
	warn("--- Disconnection incoming ---")
	self.events[self.object.name][eventName]:Disconnect()
	self.events[self.object.name][eventName] = nil

	local objName = self.object.name
	warn("2 - ",eventName, "Disconnected.", eventName, "connected status is:", self.events[objName][eventName].Connected)
	warn(self.events)
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