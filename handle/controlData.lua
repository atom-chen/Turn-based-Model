
local _controlData = nil

local controlData = class("controlData",function()
	return cc.Node:create()
end)

function controlData:getInstance()
	if _controlData == nil then
		_controlData = controlData.new()
		_controlData:retain()
	end
	return _controlData
end

function controlData:ctor()
	--触点一状态
	self.state1 = -1
	--触点二状态
	self.state2 = -1
	--触点一位置
	self.ps1 = -1
	--触点二位置
	self.ps2 = -1
	--人物状态
	self.roleState = -1

end

function controlData:getcontrolState()
	return self.state1,self.state2,self.ps1,self.ps2
end

function controlData:getcontrolState(state1,state2,ps1,ps2)
	self.state1 = state1
	self.state2 = state2 
	self.ps1 = ps1
	self.ps2 = ps2
end

--根据两点触摸判断人物状态
function controlData:getRoleState()
	local s1 = self.state1
	local s2 = self.state2
	--单点触碰
	if self.state2 == -1 then
		--
		if s1 == 2 then
			print("=============移动")

		end

	--多点触碰
	elseif conditions then
		--todo
	end
end

function controlData:getRoleMoveDirection()

end

function controlData:create()
	return controlData.new()
end

return controlData