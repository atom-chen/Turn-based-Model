--动作数据接口
require("config.animationConfig")
require("config.bioConfig")
local interval = 10

animationDataUse = 
{
	getAnimationById 	= nil,			--获取动作数据
	getAnimationFile    = nil,			--获取动画文件
	getAttackAnimation  = nil,			--获取攻击动作
	getSkillAnimation   = nil,			--
	getStandAnimation   = nil,			--
	getDieAnimation     = nil ,			--
	getBeHitAnimation   = nil ,			--
	getBeginIndex		= nil ,         --获取动作开始帧
	getAnimation        = nil ,
}

animationDataUse.getBeginIndex = function(id,index)
	if index > 5 or index < 0 then
		print("==========不存在此动作")
	end
	local data = animationDataUse.getAnimationById(id).animation
	local start = 0
	for i=1,index - 1 do
		start = start + data[i] * interval
	end
	
	return start
end

animationDataUse.getAnimationFile = function(id)
print("=============id",id)
	if id < 0 or id == nil then
		print("========该怪物动作文件不存在")
	end
	return animationDataUse.getAnimationById(id).filename
end

animationDataUse.getAnimationById = function(id)
print("==============getAnimationById")
	if id < 0 then
		print("========该怪物动作不存在")
	end
	return animation.animation[id]
end

animationDataUse.getAttackAnimation = function(id)
	return animationDataUse.getAnimation(id,bioAction.attack)
end
animationDataUse.getSkillAnimation = function(id)
	return animationDataUse.getAnimation(id,bioAction.skill)
end
animationDataUse.getStandAnimation = function(id)
	return animationDataUse.getAnimation(id,bioAction.stand)
end
animationDataUse.getDieAnimation = function(id)
	return animationDataUse.getAnimation(id,bioAction.die)
end
animationDataUse.getBeHitAnimation = function(id)
	return animationDataUse.getAnimation(id,bioAction.behit)
end

animationDataUse.getAnimation = function(id,actionType)
	local fileName = animationDataUse.getAnimationFile(id)
	local data = animationDataUse.getAnimationById(id).action
	local start = data[actionType][1]
	local end_ = data[actionType][2]
	print("===========开始帧结束帧:",start,end_)
	return fileName,start,end_
end


