local eventManager = {}
eventManager.__index = eventManager
eventManager.instanceNumber = 0

function eventManager.new(object, player)
	eventManager.instanceNumber += 1
	local self = setmetatable({}, eventManager)
	-- ALL CLASSES MUST HAVE THESE \/
	self.object = object
	self.player = player
	self.name = "eventManager"
	self.instanceID = eventManager.instanceNumber
	---------------------------------------------

	self._topicEvent = Instance.new("BindableEvent")
	self.events = {}
	self.args = {}

	return self
end

function eventManager:Init()
	warn("eventManager initiated.")
end

function eventManager:ConnectEvent(eventName, callback)
	local eventSubscription = self.object:m_SubscribeTopic(eventName, function(player, ...)
		if player == self.object.player then
			self.args[eventName] = {player, ...}

			callback(self.args[eventName][1], self.args[eventName][2], self.args[eventName][3])
			print(eventName, "2 - event, arrived at eventManager")
		end
	end)

	self.events[eventName] = eventSubscription

	return eventSubscription
end

function eventManager:DisconnectEvent(eventName)
	warn("--- Disconnection incoming ---")
	self.events[eventName]:Disconnect()

	warn("2 - ",eventName, "Disconnected.", eventName, "connected status is:", self.events[eventName].Connected)
	warn(self.events)
end

function eventManager:ResetEvent(eventName)
	self:DisconnectEvent(eventName)
	self:ConnectEvent(eventName)
end

--function eventManager:DisconnectAll()

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