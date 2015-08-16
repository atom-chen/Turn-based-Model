
local control = class("control",function()
	return cc.Layer:create()
end)

local controlData = require("contro.controlData"):getInstance()

function control:ctor()

	self.controlState1 = -1   
	self.controlState1 = -2 

	self.controlLastPs1 = nil
	self.controlLastPs2 = nil
	
	self.controlCurPs1 = nil
	self.controlCurPs2 = nil

	print("==========hellow")

	local function onTouchesBegan(touches, event)
		return self:onTouchesBegan(touches, event)
	end

	local function onTouchesMoved(touches, event)
		self:onTouchesMoved(touches, event)
	end

    local function onTouchesCanceled(touches, event)
        self:onTouchesCanceled(touches, event)
    end

	local function onTouchesEnded(touches, event)
		self:onTouchesEnded(touches, event)
	end

	local listener = cc.EventListenerTouchAllAtOnce:create()
	listener:registerScriptHandler(onTouchesBegan, cc.Handler.EVENT_TOUCHES_BEGAN)
	listener:registerScriptHandler(onTouchesMoved, cc.Handler.EVENT_TOUCHES_MOVED)
	listener:registerScriptHandler(onTouchesCanceled, cc.Handler.EVENT_TOUCHES_CANCELLED)
	listener:registerScriptHandler(onTouchesEnded, cc.Handler.EVENT_TOUCHES_ENDED)
	local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

	-- local listener = cc.EventListenerTouchOneByOne:create()
 --    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
 --    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
 --    local eventDispatcher = menuLayer:getEventDispatcher()
 --    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, menuLayer)

	-- local img = ccui.ImageView:create("scene/city/house_1_2.jpg")
	-- img:setPosition(cc.p(480,320))
	-- self:addChild(img)
	
end

function control:create()
	return control.new()
end

function control:onTouchesBegan(touches, event)

	local touchA = touches[1]
	local touchB = touches[2]

	self.controlState1 = 1
	self.controlLastPs1 = self.controlCurPs1
	self.controlCurPs1 = touchA:getLocation()

	if touchB ~= nil then
		self.controlState2 = 1
		self.controlLastPs2 = self.controlCurPs2
		self.controlCurPs2 = touchB:getLocation() 
	end

	return true
end

--获取按钮状态以及位置
function control:getState()
	return self.controlState1,self.controlState2,self.controlPs1,self.controlPs2
end

function control:onTouchesMoved(touches, event)
	local touchA = touches[1]
	local touchB = touches[2]

	self.controlState1 = 2
	self.controlLastPs1 = self.controlCurPs1
	self.controlCurPs1 = touchA:getLocation()

	if touchB ~= nil then
		self.controlState2 = 2
		self.controlLastPs2 = self.controlCurPs2
		self.controlCurPs2 = touchB:getLocation()
	end
end

function control:onTouchesCanceled(touches, event)
	print("==========touchMove")
	local pos = touches[1]:getLocation()
	print("=======位置",pos.x,pos.y)
end

function control:onTouchesEnded(touches, event)
	print("==========touchEnded")
	local pos = touches[1]:getLocation()
	print("=======位置",pos.x,pos.y)
end

return control 