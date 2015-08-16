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
	
	return animationDataUse.getAnimationById(id).filename
end

animationDataUse.getAnimationById = function(id)
	if id < 0 then
		print("========该怪物动作不存在")
	end
	return animation.animation[id]
end

animationDataUse.getAttackAnimation = function(id)
	return animationDataUse.getAnimation(id,bioState.attack)
end
animationDataUse.getSkillAnimation = function(id)
	return animationDataUse.getAnimation(id,bioState.skill)
end
animationDataUse.getStandAnimation = function(id)
	return animationDataUse.getAnimation(id,bioState.stand)
end
animationDataUse.getDieAnimation = function(id)
	return animationDataUse.getAnimation(id,bioState.die)
end
animationDataUse.getBeHitAnimation = function(id)
	return animationDataUse.getAnimation(id,bioState.behit)
end

animationDataUse.getAnimation = function(id,actionType)
	local data = animationDataUse.getAnimationById(id).animation
	local start = animationDataUse.getBeginIndex(id,actionType)
	local end_ = start + data[actionType] * interval
	print("===========开始帧结束帧:",start,end_)
	return start,end_
end


