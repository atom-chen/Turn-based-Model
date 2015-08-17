--ScrollMenu.lua




local ScrollMenu = class("ScrollMenu",
	function() return cc.Layer:create() 
end)
---- --菜单的缩小比例 最小的比例是1-MENU_SCALE
ScrollMenu.MENU_SCALE = 0.3
-- --ScrollMenu.PI = math.acos(-1)

--菜单的倾斜度 最多为45
ScrollMenu.MENU_ASLOPE = 60

ScrollMenu__CALC_A = 1.5

--动画运行时间
ScrollMenu.ANIMATION_DURATION= 0.3

-- --菜单项的大小与屏幕的比例，当然可以通过setContentSize设置  
-- ScrollMenu__CONTENT_SIZE_SCALE=2/3

--菜单项长度与菜单长度比例
ScrollMenu.ITEM_SIZE_SCALE = 1/2


--//calcFunction(x) 为 x/(x+a),其中a为常数  
local function calcFunction(index,width)
    return width*index / (math.abs(index) + ScrollMenu__CALC_A);  
end


function ScrollMenu:create(w,h)
	return ScrollMenu.new(w,h)
end
function ScrollMenu:ctor(w,h)
	self._items = {}

	self._index = 3
	self._lastIndex = self._index
	self._selectedItem = nil

	self:ignoreAnchorPointForPosition(false)
	self:setPosition(480,320)
	self:setAnchorPoint(0.5,0.5)
	self:setContentSize(w or 480,h or 640)
	local function onTouchBegan(touch, event)
		return self:onTouchBegan(touch)
	end
	local function onTouchMoved(touch, event)
		self:onTouchMoved(touch)
	end
	
	local function onTouchEnded(touch, event)
		self:onTouchEnded(touch)
	end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    --listener:registerScriptHandler(onTouchCancel,cc.Handler.EVENT_TOUCH_CANCELLED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)



end


function ScrollMenu:onTouchBegan(touch, event)
	for i,v in ipairs(self._items) do
		v:stopAllActions()
	end
	if (self._selectedItem)  then
		self._selectedItem:unselected()
	end
    local pos =  self:convertToNodeSpace(touch:getLocation()) 
    local size = self:getContentSize()
    local rect =cc.rect(0,0,size.width,size.height)
    return cc.rectContainsPoint(rect,pos)

end
function ScrollMenu:onTouchMoved(touch)
	local xDelta = touch:getDelta().x
	
	local size = self:getContentSize()
	self._lastIndex = self._index
	self._index = self._index -xDelta/(size.width/ScrollMenu.ITEM_SIZE_SCALE)
	self:updatePosition()
end
function  ScrollMenu:onTouchEnded(touch)
	local size = self:getContentSize()
	local xDelta=touch:getLocation().x - touch:getStartLocation().x
	self:rectify(xDelta>0)
	if ( math.abs(xDelta)<size.width/24 and self._selectedItem) then
		self._selectedItem:activate()
	end
	self:updatePositionWithAnimation()
end
function ScrollMenu:rectify(forward)
	local index = self:getIndex()
	index = math.max(index,0)
	index = math.min(index,#self._items-1)
	if forward then
		--index = index + 0.4
		index = math.floor(index)
	else
		--index = index + 0.6
		index = math.ceil(index)
	end
	
	self:setIndex(index)
end



--MenuItem
function ScrollMenu:addMenuItem(item)
	item:setPosition(self:getContentSize().width/2,self:getContentSize().height/2)
	self:addChild(item)
	table.insert(self._items,item)
	--self:reset()
	self:updatePosition()
	if not self.xxxxx then
		local x = ccui.Layout:create()
		x:setBackGroundImage("scale_2.png")
		x:setBackGroundImageScale9Enabled(true)
		x:setContentSize(self:getContentSize())
		--self:addChild(x)
		self.xxxxx = x
	end
end

function ScrollMenu:reset()
	self._lastIndex = 0  
    self._index = 0
end

function ScrollMenu:updatePositionWithAnimation()
	local menuSize = self:getContentSize()
	for i,v in ipairs(self._items) do
		v:stopAllActions()
	end
	for i,v in ipairs(self._items) do
		v:setLocalZOrder(-math.abs(i-1-self._index)*100)
		local x = calcFunction(i-1-self._index,menuSize.width/2)
		local moveTo = cc.MoveTo:create(ScrollMenu.ANIMATION_DURATION,cc.p(menuSize.width/2+x,menuSize.height/2))
		v:runAction(moveTo)
		local scaleTo = cc.ScaleTo:create(ScrollMenu.ANIMATION_DURATION,(1-math.abs(calcFunction(i-1-self._index,ScrollMenu.MENU_SCALE))))
		v:runAction(scaleTo)
		--设置倾斜， 
		--local orbit1 = cc.OrbitCamera:create(ScrollMenu.ANIMATION_DURATION,1,0,calcFunction(i-self._lastIndex,ScrollMenu.MENU_ASLOPE),calcFunction(i-self,_lastIndex,ScrollMenu.MENU_ASLOPE)-calcFunction(i-self._index,ScrollMenu.MENU_ASLOPE),0,0)
		--v:runAction(orbit1)
	end
	local function actionEndCallBack()
		self._selectedItem = self:getCurrentItem();  
    	if (self._selectedItem)  then
       	 	self._selectedItem:selected();
		end
	end
	cc.Director:getInstance():getScheduler():scheduleScriptFunc(actionEndCallBack,0,true)
	--self:scheduleOnce(actionEndCallBack,ScrollMenu.ANIMATION_DURATION)
end
function ScrollMenu:updatePosition( ... )
	local menuSize = self:getContentSize()
	for i,v in ipairs(self._items) do
		local x = calcFunction(i-1-self._index,menuSize.width/2)
		--设置位置  
		v:setPosition(menuSize.width/2+x,menuSize.height/2)
		--设置zOrder,即绘制顺序  -
		v:setLocalZOrder(-math.abs(i-1-self._index)*100)
		--//设置伸缩比例  
		v:setScale(1-math.abs(calcFunction(i-1-self._index,ScrollMenu.MENU_SCALE)))
		--设置倾斜， 
		--local orbit1 =cc.OrbitCamera:create(0,1,0,calcFunction(i-self._lastIndex,ScrollMenu.MENU_ASLOPE),calcFunction(i-self,_lastIndex,ScrollMenu.MENU_ASLOPE)-calcFunction(i-self._index,ScrollMenu.MENU_ASLOPE),0,0)
		--v:runAction(orbit1)
	end

end



function ScrollMenu:setIndex(index)
 	self._lastIndex = self._index
 	self._index = index
 end 
function ScrollMenu:getIndex()
	return self._index
end

function ScrollMenu:getCurrentItem( )
  	return self._items[self._index]
end  
   



return ScrollMenu