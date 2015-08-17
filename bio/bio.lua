require("config.bioConfig")
--生物父类
local bio = class("bio",function()
	return cc.Sprite:create()
end)
--@x,y  	生物位置
--@id       静态id
--@type     类型  暂时没卵用
function bio:ctor(x,y,id,type)
	self:setPosition(cc.p(x,y))
	self.id = id 					--静态id
	self.type = type
	local function onNodeEvent(event)
        if event == "cleanup" then
            print("cleanup")
        end
    end
    self:registerScriptHandler(onNodeEvent) 
end
function bio:create()

end

--释放技能
function bio:releaseSkill(skillId,callback,x,y)
	require("dataUse.skillDatause")
	local target = require("scene.sceneManager"):getInstance():getlayer(SubUI_Layer)
	local skillData = animationDataUse.getSkillAnimation(skillId)
	playAniamationOnce(target,skillData,callback,x,y)
end

-- -
--生物执行动作
--获取怪物动作
--@动作数据格式
--@bio1Id  	对象A
--@bio2Id 	 	对象B
--@actionType    	 	动作类型	
--@actionId      	 	指向动作id
function bio:action(bio1Id,bio2Id,actionType,actionId)
	print("============action")
	local action = {}
	action.actionType = actionType
	action.bio1Id = bio1Id
	action.bio2Id = bio2Id
	action.actionId = actionId
	sendMessage(action)
end
function  bio:getId()
	return self.id
end
function bio:getType()
end
return bio

--释放动作
-- --@animationId 动画id
-- --@ationId     动作类型
-- function bio:playAction(animationId , actionType ,callback,isLoop)
-- 	require("dataUse.animationDataUse")
-- 	local fileName = animationDataUse.getAnimationFile(animationId)
-- 	print("==========fileName",fileName)
-- 	local startFrame = 0
-- 	local endFrame = 0
-- 	if actionType == bioState.die then

-- 	elseif actionType == bioState.behit then

-- 	elseif actionType == bioState.attack then
-- 		startFrame,endFrame = animationDataUse.getAttackAnimation(animationId)
-- 	elseif actionType == bioState.skill then

-- 	elseif actionType == bioState.stand then
-- 		startFrame,endFrame = animationDataUse.getStandAnimation(animationId)
-- 	end

-- 	self:runAction_(fileName,startFrame,endFrame,callback,isLoop)

-- end
-- --执行动画
-- function bio:runAction_(fileName,startFrame,endFrame,callback,isLoop)
	
-- 	local loop = false
-- 	if isLoop then
-- 		loop = true
-- 	end
-- 	print("----------11",startFrame,endFrame)
-- 	local node = cc.CSLoader:createNode(fileName)
--     local action = cc.CSLoader:createTimeline(fileName)
--     node:runAction(action)
--     action:gotoFrameAndPlay(startFrame,endFrame,loop)

--     node:setScale(0.6)
--     print("=======怪物位置",self:getPosition())
--     print("=======屏幕大小",cc.Director:getInstance():getWinSize().width,cc.Director:getInstance():getWinSize().height)
--     node:setPosition(self:getContentSize().width / 2,self:getContentSize().height / 2)
--     self:addChild(node)

--     local function onFrameEvent(frame)
--         print("==========动画播放完")
--         if callback ~= nil then
--         	callback()
--         end
--     end
--     if callback ~= nil then
--     	action:setFrameEventCallFunc(onFrameEvent)
--     end
    
-- end