
local fightScene = class("fightScene", function()
	return cc.Scene:create()
end)

function fightScene:ctor()
	local layer = cc.Layer:create()
	--背景
	local backGround = ccui.ImageView:create("fightBg.png")
	backGround:setPosition(cc.p(400,240))
	backGround:setScale(1.5)
	--人物状态

	--怪物状态
	local monster = cc.Sprite:create("monster/monster_1.png")
	monster:setPosition(cc.p(400,240))

	local animation = cc.Animation:create()
    for i = 1, 4 do
        animation:addSpriteFrameWithFile(string.format("monster/monster_%d.png",i))
    end
    animation:setDelayPerUnit(0.3)
    animation:setRestoreOriginalFrame(true)
    local action = cc.Animate:create(animation)


    --技能
    local node1 = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("attack.csb") 
    -- cc.CSLoader:createNode("attack.csb")
    local action1 = cc.CSLoader:createTimeline("attack.csb")
    node1:runAction(action1)
    action1:gotoFrameAndPlay(0,false)

    local function onFrameEvent1(frame)
    	node1:removeFromParent()
    	print("=========")
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        print("====:",str)
        if str == "1" then
           print("=====")
        end
    end

    action1:setFrameEventCallFunc(onFrameEvent1)

    --node:setScale(0.2)
    node1:setPosition(cc.p(400,240))

    self:addChild(node1,100) 

    local node2 = cc.CSLoader:createNode("fire.csb")
    local action2 = cc.CSLoader:createTimeline("fire.csb")
    node2:runAction(action2)
    action2:gotoFrameAndPlay(0,false)

    local function onFrameEvent2(frame)
    	node2:removeFromParent()
    	print("=========") 
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        print("====:",str)
        if str == "1" then
           print("=====")
        end
    end

    action2:setFrameEventCallFunc(onFrameEvent2)

    node2:setPosition(cc.p(400,240))

    self:addChild(node2,1)


    monster:runAction(cc.RepeatForever:create(action))
	--操作

	self:addChild(backGround)
	self:addChild(monster)

end

function fightScene:create()
	return fightScene.new()
end

return fightScene