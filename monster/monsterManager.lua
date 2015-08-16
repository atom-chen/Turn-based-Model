local monsterManager_ = nil

local monsterManager = class("monsterManager",function()
	return cc.Node:create()
end)

function monsterManager:getInstance()
	if monsterManager_ == nil then
		monsterManager_ = monsterManager.new() 
		monsterManager_:retain()
	end
	return monsterManager_
end

function monsterManager:ctor()
	--当前怪物组
	self.monsterList = {}
end

function monsterManager:initMonsterList()
	--根据场景id去初始化怪物
end
--获取怪物动作
--@动作数据格式
--@objectA  	对象A
--@objectB 	 	对象B
--@type    	 	动作类型	
--@id      	 	指向动作id
function monsterManager:monsterAttack()
	
end

function monsterManager:getMonsterList()
	return self.monsterList
end
--获取当前战斗中的怪物
--@id动态id
function monsterManager:getCurMonsterById(id)
	for k,v in ipairs(self.monsterList) do
		if v.id == id then
			return v
		end
	end
	print("===============并没有此怪物")
	return nil
end

--获取怪物的静态id
--@id怪物动态id
function monsterManager:getMonsterStaticId(id)
	local monster = self:getCurMonsterById(id)
	return monster.id
end

return monsterManager
