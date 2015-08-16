
local gameScene = class("gameScene",function()
	return cc.Layer:create()
end)

function gameScene:ctor()

	local function onNodeEvent(event)
		if event == "cleanup" then
			print("==========cleanup")
		end
	end
    self:registerScriptHandler(onNodeEvent)

 
    print("===========场景id",InstanceScene_1)
    local img = ccui.ImageView:create()
    img:loadTexture("login/mainBack.jpg")
    img:setPosition(cc.p(480,320))
    self:addChild(img)

    local button = ccui.Button:create()
    button:setTouchEnabled(true)
    button:loadTextures("login/startButton.png","login/startButton.png","")
    button:setPosition(cc.p(480,100))
    self:addChild(button)
    local function startGameEvent(sender,eventType)
    	if eventType ==  ccui.TouchEventType.began then
    		print("=======touch begin")
    		sender:setScale(0.8)
    	end
		if eventType == ccui.TouchEventType.ended then
			sender:setScale(1)
			print("============start game")
			require("scene.sceneManager"):getInstance():loadScene(FightScene_1)
		end
	end
	button:addTouchEventListener(startGameEvent)

	local label = ccui.ImageView:create()
	label:loadTexture("login/startFont.png")
	label:setPosition(cc.p(button:getContentSize().width / 2,button:getContentSize().height / 2))
	button:addChild(label)
	print("=========")
end

function gameScene:create()
	return gameScene.new()
end

return gameScene