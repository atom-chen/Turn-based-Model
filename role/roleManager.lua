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

function roleManager:getRoleList()
	return self.roleList
end
--获取当前战斗中的怪物
function roleManager:getCurRoleById(id)
	for k,v in ipairs(self.roleList) do
		if v.id == id then
			return v
		end
	end
	print("===============并没有此角色")
	return nil
end

return roleManager
