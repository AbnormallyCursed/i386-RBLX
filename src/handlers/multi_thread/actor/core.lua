-- Heftig_HD
--!native

local self
local actor = script:GetActor()
script = nil
actor:BindToMessage(0x01, function(func, ...)
	func(self, ...)
end)
actor:BindToMessageParallel(0x02, function(func, ...)
	func(self, ...)
end)
actor = nil
return function(array)
	self = array
end