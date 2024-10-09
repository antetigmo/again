local classCreator = {}
classCreator.__index = classCreator

function classCreator.new(name, ...)
	local self = setmetatable({}, classCreator)
	local args = {...}

	self.player = nil
	self.name = nil
	self.instanceID = nil
	
	return self
end

function classCreator:SetPlayer(player)
    self.player = player
end

function classCreator:GetPlayer()
    return self.player
end

function classCreator:SetName(name)
    self.name = name    
end

function classCreator:GetName()
    return self.name
end

function classCreator:SetMetaTable(metatable)

end



return classCreator