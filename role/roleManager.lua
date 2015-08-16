local roleManager_ = nil

local roleManager = class("roleManager",function()
	return cc.Node:create()
end)

function roleManager:getInstance()
	if roleManager_ == nil then
		roleManager_ = roleManager.new() 
		roleManager_:retain()
	end
	return roleManager_
end

function roleManager:ctor()
	--当前怪物组
	self.roleList = {}
end
--初始化主角
function roleManager:getRoleList()
	return self.roleList
end
--获取当前战斗中的主角
--@id 动态id
function roleManager:getCurRoleById(id)
	if id < 0 or id == nil then
		print("===============并没有此角色")
	end
	
	return self.roleList[id]
end

return roleManager
