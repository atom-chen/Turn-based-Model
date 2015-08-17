local test = class("test",function()
	return cc.Label:create()
end)

--[[
	沿给定线条移动
]]
function test:ctor()


	--启动定时器
	local function tick(dt)
		print("===========")
		self:myUpdate()
	end
	self.schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(tick, 0, false)
	self:retain()
end

function test:myUpdate()
	print("======update")
end

function test:create()
	return test.new()
end

return test

