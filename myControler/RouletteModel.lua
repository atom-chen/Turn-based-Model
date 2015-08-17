--RouletteModel.lua

local RouletteModel = class("RouletteModel",function()
return cc.Layer:create() end)


function RouletteModel:ctor(radius,singelAngle)
	self._mRadius = radius
	self._mSingleAngle = singelAngle
	self._mEleNum = 0
	self._mSelIndex = 0
	self._mEleSize= 0
	self._mEles = {}
	self._mDir = true
	self._isStop = true
	
	self.m_touchWidth = 100
	self.m_touchHeight = 100


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
  
    local _zp = cc.Sprite:create()
	_zp:setAnchorPoint(0.5,0.5)
	_zp:setPosition(-radius,0)
	self._mZp = _zp
	self:addChild(_zp)
	self:setAnchorPoint(0.5,0.5)

	

	local function tick()
		self:updateaaa()
    end

    self.schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(tick, 0, false)
    local function onNodeEvent(event)
        if "exit" == event then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
        end
    end
    self:registerScriptHandler(onNodeEvent)

    
end
function RouletteModel:create(radius,singelAngle)
	return RouletteModel.new(radius,singelAngle)
end

function RouletteModel:onTouchBegan(touch, event)
	local pos = touch:getLocation()
	local x = - self:getAnchorPoint().x*self:getContentSize().width
	local y = - self:getAnchorPoint().y*self:getContentSize().height
	local pn = self:convertToNodeSpace(pos)
	local rect = cc.rect(x,y,self:getContentSize().width,self:getContentSize().height)
    local ret = cc.rectContainsPoint(rect,self:convertTouchToNodeSpace(touch))
	if ret then
		self._isStop = false
		self._mZp:stopAllActions()
		self.m_touchMovePrePos = pos
		self.m_touchbeganPos = touch:getLocation()
	end
	return ret
end
function RouletteModel:onTouchMoved(touch, event)
	 local location = touch:getLocation()
	 local offsetY = location.y - self.m_touchMovePrePos.y
	 
	 self.m_touchMovePrePos.y = location.y

	 local dir = location.y - self.m_touchbeganPos.y
	 if dir >0 then
	 	self._mDir  = false
	 else
	 	self._mDir = true
	 end

	 self:_moveRolet(offsetY)
end
function RouletteModel:onTouchCancel(touch, event)
	self:_autoStop()
end
function RouletteModel:onTouchEnded(touch, event)
	self:_autoStop()
end


function RouletteModel:_autoStop()
	local _sA = self._mSelIndex * self._mSingleAngle
	local a1 = cc.RotateTo:create(0.1,_sA)
	local a2 = function()
		--self._isStop = true
	end
	local a3 = cc.CallFunc:create(a2)
	local a4 = cc.Sequence:create(a1,a3)
	self._mZp:runAction(a4)
end



function RouletteModel:addRouletteElement(imagefile)
	local ele = cc.Sprite:create("item_0001.png")
	ele:setAnchorPoint(cc.p(0.5,0.5))
	local p = {}
	p.ele = ele
	
	table.insert(self._mEles,p)
	local cx,cy = self:getPosition()
	local _offAngle = self._mEleNum * self._mSingleAngle
	py = self._mRadius * math.sin(math.rad(_offAngle)) 
	px = self._mRadius * math.cos(math.rad(_offAngle))
	ele:setPosition(px,py)


	self._mZp:addChild(ele)
	self._mEleNum = self._mEleNum + 1
	
	
	self:_updateElementtAngel()
end

function RouletteModel:updateaaa()
	self:_updateElementtAngel()
end



--设置初始指向 1 开始
function RouletteModel:setCurElement(num)
	if tonumber(num) == nil then return end
	if num < 1 then return end
	if num > self._mEleNum  then return end
	self._mSelIndex = num-1
	local _offAngle =  (num-1) * self._mSingleAngle
	self:_updateAngel(_offAngle)
end

function RouletteModel:_updateAngel(offAngle)
	local _cA = self._mZp:getRotation()
	_cA = _cA + offAngle

	_cA = math.max(_cA,-self._mSingleAngle)
	_cA = math.min(_cA,self._mEleNum*self._mSingleAngle)
	self._mZp:setRotation(_cA)
	self:_updateElementtAngel()
end


function RouletteModel:_updateElementtAngel()
	local _cA = self._mZp:getRotation()
	for i,v in ipairs(self._mEles) do
		local _angle = - i * self._mSingleAngle + _cA
		local _angle = -  _cA
		v.ele:setRotation(_angle)
	end
end

function RouletteModel:_moveRolet(offsetY)
	local _offAngle = self:_calculateOffSetAngle(offsetY)
	self:_calculateStopElement()
	self:_updateAngel(_offAngle)
end

function RouletteModel:_calculateOffSetAngle(offsetY)
	local _offAngle = 180 * math.abs(offsetY) / (math.pi * self._mRadius )
	if offsetY > 0 then 	
		_offAngle = - _offAngle
		
	end
	return _offAngle
end
function RouletteModel:_calculateStopElement()
	local stopIndex = 0
	local _cA = self._mZp:getRotation()
	if _cA > 0 then
		if self._mDir == false then--shun
			stopIndex = math.floor(_cA/self._mSingleAngle)
		else
			stopIndex = math.ceil(_cA/self._mSingleAngle)
		end
	end
	stopIndex = math.min(stopIndex,self._mEleNum-1)
	stopIndex = math.max(stopIndex,0)
	if self._mSelIndex ~= stopIndex then
		self._mSelIndex = stopIndex
		
		if self._mSwithCall then
			self._mSwithCall(self)
		end
	end
end

function RouletteModel:addSwithEventListener(callBack)
	self._mSwithCall = callBack
end

return RouletteModel