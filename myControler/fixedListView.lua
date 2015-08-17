--[[
	静态参数
]]

local fixedListView = class("fixedListView",function()
	return cc.Label:create()
end)

--构造
function fixedListView:ctor()



	--层触摸事件
	local function onTouchBegan(touch, event)
		return self:onTouchBegan(touch, event)
	end 
	local function onTouchMoved(touch, event)
		self:onTouchMoved(touch, event)
	end
	local function onTouchCancel(touch, event)
		self:onTouchCancel(touch, event)
	end
	local function onTouchEnded(touch, event)
		self:onTouchEnded(touch, event)
	end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchCancel,cc.Handler.EVENT_TOUCH_CANCELLED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

--创建一个固定移动的listview
function fixedListView:create()
	return fixedListView.new()
end

