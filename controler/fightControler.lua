local fightControler_ = nil

local fightControler = class("fightControler",function()
	return cc.Node:create()
end)

function fightControler:getInstance()
	if fightControler_ == nil then
		fightControler_ = fightControler.new()
		fightControler_:retain()
	end
	return fightControler_
end

function fightControler:ctor()
	--战斗状态
	self.fightState = -1
	--战斗动作顺序
	self.fightSchedule = {}
end
--进入战斗
function fightControler:enterFight()
	self.fightState = 0
	self:beAttack()
end

--处理偷袭
function fightControler:beAttack()
	if flag == true then
		
	end
	self:startFight()
end
--开始战斗
function fightControler:startFight()
	--
	self.fightState = 1
end
--播放战斗过程
function fightControler:fightPlay()
	self.fightState = 2
	local actionList = self:getActionSchedlue()
	for k,v in pairs(actionList) do
		
	end
end
function fightControler:playFightAnimation(action)
	local bioA = action.bioA
	local bioB = action.bioB
	local type_ = self:isActionType(action.bioAId, action.bioBId)
	--角色辅助角色
	if type_ == 1 then
		--释放技能

		--使用道具
	--怪物辅助怪物
	elseif type_ == 2 then
	
	--人物攻击怪物
	elseif type_ == 3 then
	
	--怪物攻击人物
	elseif type_ == 4 then
		--怪物普通攻击
		if action.actionType == Attack then
			self:monsterAttack(bioA,bioB)
		--怪物释放技能
		elseif action.actionType == Skill then
			
		end
	end
	--角色治疗
end
function  fightControler:isActionType(bioA,bioB)

	local twoRole = 1
	local twoMonster = 2
	local roleMonster = 3
	local monsterRole = 4

	local isRole = bioA:getId() < 1000
	local isMonster = bioB:getId() > 1000
	if isRole and ~isMonster  then
		return 1
	elseif ~isRole and isMonster then
		return 2
	elseif isRole and isMonster then
		return 3
	elseif ~isRole and ~isMonster then
		return 4
	end
end
--战斗结束
function fightControler:endFight()
	self.fightState = 3
end

--获取动作顺序
function fightControler:getActionSchedlue()
	
end
----比较怪物和人物攻击速度，排序动作
function fightControler:sortAction()

end
function fightControler:getMonsterAction()

end

--[[
	攻击攻击	
]]
--怪物普通攻击
function fightControler:monsterAttack(monster,role)
	--怪物播放普通攻击动画
	local monsterId = require("monster.monsterManager"):getInstance():getMonsterStaticId(monster.id)
	monster:playAction(monsterId,bioState.attack,nil,false)
	--人物受击
	print("=============你受到怪物攻击，表现")
	--人物扣血
	print("=============你失去了99999hp")
	--弹字
	print("=============-9999")
	--战斗说明
	print("=============你收到怪物攻击，损失了9999hp")
end


--监听消息 
function fightControler:recMessage(prot)
	if prot == "tiem end" then
		print("战斗结束===========")
	end
end

return fightControler
