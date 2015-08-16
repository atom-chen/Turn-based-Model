--怪物
local baseBio = require("bio.bio")
local monster = class("monster",baseBio)
require("dataUse.animationDataUse")
function monster:ctor(x,y,id)
	self.super.ctor(self,x,y,id)
	self.curAction = nil             --当前动作
end

function monster:create(x,y,id)
	return monster.new(x,y,id)
end
--怪物攻击
--@callback动作做完的回调
--@
function monster:attack(callback)
	--停止当前动作 
	if self.curAction ~= nil then
		self.curAction:removeFromParent()
	end
	local fileName,startFrame,endFrame = animationDataUse.getAttackAnimation(self:getId())
	playAniamationOnce(self,fileName,startFrame,endFrame,callback,0,0)
end
--怪物站立
function monster:stand(callback)
	print("position====",self:getPosition()) 
	local fileName,startFrame,endFrame = animationDataUse.getStandAnimation(self:getId())
	self.curAction = playAniamationForever(self,fileName,startFrame,endFrame,0,0)
end
--怪物被击
function monster:behit(callback)
	--停止当前动作 
	if self.curAction ~= nil then
		self.curAction:removeFromParent()
	end
	local fileName,startFrame,endFrame = animationDataUse.getBeHitAnimation(self:getId())
	playAniamationOnce(self,fileName,startFrame,endFrame,callback,0,0)
end
--怪物释放技能
function monster:skill(callback)
	--停止当前动作 
	if self.curAction ~= nil then
		self.curAction:removeFromParent()
	end
	local fileName,startFrame,endFrame = animationDataUse.getSkillAnimation(self:getId())
	playAniamationOnce(self,fileName,startFrame,endFrame,callback,0,0)
end
--怪物死亡
function monster:die(callback)
	--停止当前动作 
	if self.curAction ~= nil then
		self.curAction:removeFromParent()
	end
	local fileName,startFrame,endFrame = animationDataUse.getDieAnimation(self:getId())
	playAniamationOnce(self,fileName,startFrame,endFrame,callback,0,0)
end
--获取怪物动作动画文件名以及帧


return monster