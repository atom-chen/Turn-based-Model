--EllipticRotaryTable.lua
local EllipticRotaryTable = class("RouletteModel",
	function() return cc.Layer:create() 
end)
function EllipticRotaryTable:create(tuoyuan_a,tuoyuan_b)
	return EllipticRotaryTable.new(tuoyuan_a,tuoyuan_b)
end
function EllipticRotaryTable:ctor(tuoyuan_a,tuoyuan_b)
	self.m_Childrens             = {}
	self._nowAngle               = {}
	self.tuoyuan_a               = tuoyuan_a
	self.tuoyuan_b               = tuoyuan_b
	
	
	self._curPageIdx             = 1    --设置椭圆参数    
	self.last_pageIdx            = 0
	
	
	self._isAutoScrolling        = false--自动滚动 滑动的回滚效果   
	self._autoScrollSpeed        = 10--滚动速度（越大滚动的越慢）
	
	--变化的角度以及偏移量    
	self.m_changeAngle           = 0   
	self.m_changeOffset          = 0   
	self.m_changeNum             = 0--偏移倍数 
	self.last_pageIdx            = 0--滑动前的当前页 
	self.m_endAngle              = 0--滑动结束后 当前页的角度   
	self._touchStartLocation     = 0--触摸开始时X的位置 
	self._touchMoveStartLocation = 0--一次移动前的开始位置（用于计算偏移） 
	self._curPageIdx			 = 0--当前页面 
	
	
	self._isStopMove     = true
	self._startMoveAngle = 0
	self._strtMoveDir    = false
	self.m_slideTime     = 0
	self.SPEEDCALL     	 = 30


	local function tick(dt)
		self:update(dt)
    end

    self.schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(tick, 0, false)
    local function onNodeEvent(event)
        if "exit" == event then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
        end
    end
    self:registerScriptHandler(onNodeEvent)




	local function onTouchBegan(touch, event)
		print("begin")
		self.m_slideTime = 0
		self._touchMoveStartLocation = self:convertToNodeSpace(touch:getLocation()).x;  
		self._touchStartLocation     =self._touchMoveStartLocation; 
		self.m_endAngle              = 0--滑动前初始化当前页偏移角度    
		self._touchStartLocationY    = self:convertToNodeSpace(touch:getLocation()).y;
		return self._isStopMove;
	end
	local function onTouchMoved(touch, event)
		self:handleMoveLogic(touch:getLocation())
	end
	
	local function onTouchEnded(touch, event)
		self:handleReleaseLogic2(touch:getLocation())
		--self:handleReleaseLogic(touch:getLocation());
	end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    --listener:registerScriptHandler(onTouchCancel,cc.Handler.EVENT_TOUCH_CANCELLED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)


end




--获取权重 parm:真实角度protected:  
function  EllipticRotaryTable:getWeight(realAngle)
	--计算权重  
	local Weight = realAngle - 90
	Weight = 5 - math.abs(Weight / 45)     --除以45 取绝对值 得到中间的权值 
	if(realAngle > 180) then--/这里是处理下部分的权值    
		Weight =math.abs(Weight-1)   
		Weight =Weight+1  
	end 
	Weight = math.max(Weight,1)
	return Weight
end
--使用参数方程获取椭圆点
function EllipticRotaryTable:gettuoyuanPointAt(angle)
	local x = self.tuoyuan_a*math.cos(angle)-- + self:getPositionX()
	local y = self.tuoyuan_b*math.sin(angle)-- + self:getPositionY()
	return x,y
end
--获取当前项目的偏移角度 
function EllipticRotaryTable:getRealAngle(pageIdx)
	local realAngle = ((self._nowAngle[pageIdx]*180/math.pi))%360 --求余 且减90度  
	if realAngle<0 then
		realAngle = 360 - math.abs(realAngle)
	end 
	return realAngle
end
function EllipticRotaryTable:getAngleFromOffset(offset)
	local angle = 0
	if offset~=0 then
		angle = math.atan(offset/self.tuoyuan_b);
	end
	return angle
end
--/弧度转换到角度
function EllipticRotaryTable:radianToAngle(radian)
	 return radian * 180 / math.pi;
end
--/角度转换到弧度
function EllipticRotaryTable:angleToRadian(angle)
	 return angle * math.pi / 180; 
end
       
function EllipticRotaryTable:addElement(node)
	table.insert(self.m_Childrens,node)
	self:addChild(node)
	for i,v in ipairs(self.m_Childrens) do
		local angle = (math.pi*2)/ #self.m_Childrens * (i-1)
		local x,y = self:gettuoyuanPointAt(angle)
		
		v:setPosition(x,y)
		self._nowAngle[i] = angle

		local _an  = self:radianToAngle(angle)
		if( _an >= 269 and _an <= 271 ) then
			self._curPageIdx = i
			self.last_pageIdx = i
		end
		
		self:drawEffects(i)
	end
	--self:scrollToPage(self._curPageIdx)
end
function EllipticRotaryTable:handleMoveLogic(touchPoint)
	local offset = 0
	local moveX  = self:convertToNodeSpace(touchPoint).x
	local moveY  = self:convertToNodeSpace(touchPoint).y
	if 	moveX <= 0 and  moveY <= 0 then
		offset        = moveX - self._touchMoveStartLocation 
	elseif 	moveX <= 0 and  moveY > 0 then
		offset        = self._touchMoveStartLocation -moveX   
	elseif 	moveX > 0 and  moveY > 0 then
		offset        = self._touchMoveStartLocation -moveX 
	elseif 	moveX > 0 and  moveY <= 0 then
		offset        = moveX - self._touchMoveStartLocation 
	end

	self._touchMoveStartLocation =  moveX
	local angel = self:getAngleFromOffset(offset)
	self:movePages(angel)
end

function EllipticRotaryTable:handleReleaseLogic2( touchPoint )
	if (self.m_slideTime <= 0.016)then return end
	local  totalDis = self:convertToNodeSpace(touchPoint).x - self._touchStartLocation
	local ty  = self:convertToNodeSpace(touchPoint).y
	if totalDis >= 0 and ty >= 0 then
		self._strtMoveDir =true
	elseif  totalDis >= 0 and ty < 0 then
		self._strtMoveDir =false
	elseif  totalDis < 0 and ty >= 0 then
		self._strtMoveDir =false
	else
		self._strtMoveDir =true
	end	
	local sp =  16*math.abs(totalDis/(self.m_slideTime*1000))
	print("sssssssssss速度",sp)
	if sp > self.SPEEDCALL and self.m_callBack then
		self.m_callBack(self)
	end


end
function EllipticRotaryTable:setMoveHandle(fun)
	self.m_callBack = fun
end

function EllipticRotaryTable:handleReleaseLogic(touchPoint)
	local pageCount = #self.m_Childrens
	local width = 360 / (pageCount * 2)--偏移角度临界值
	local angle = self:radianToAngle(self.m_endAngle)
	local p = math.floor(angle / width)
	if p < 0 then
		if (p%2 ~=0) then
			p = (p-1)/2
		else
			p = p/2
		end
	else
		if (p%2 ~=0) then
			p = (p+1)/2
		else
			p = p/2
		end
	end

	self._curPageIdx = (self._curPageIdx - p ) % pageCount
	if self._curPageIdx <= 0 then
		self._curPageIdx = self._curPageIdx+pageCount--7
		
	end
	self:scrollToPage(self._curPageIdx)
end
function EllipticRotaryTable:movePages(panyi_angle,m_changeNum)
	self.m_changeNum = m_changeNum or -1
	local length = #self.m_Childrens
	for i,v in ipairs(self.m_Childrens) do
		--总角度 偏移角      
		self._nowAngle[i]  = self._nowAngle[i] + panyi_angle
		if (i == self._curPageIdx)then
			self.m_endAngle = self.m_endAngle + panyi_angle
		end
		local x,y = self:gettuoyuanPointAt(self._nowAngle[i])
		v:setPosition(x,y)
		self:drawEffects(i)
	end
end

function EllipticRotaryTable:startMove(idx)
	if not self._isStopMove  then return end
	self._isStopMove= false
	
	local realAngle = self:getRealAngle(idx)
	--math.randomseed(os.time())  
	local beishu = math.random(4,8)
	beishu = 90 * beishu

	if self._strtMoveDir then
		realAngle = realAngle - beishu
		self._startMoveAngle = -beishu 
	else
		realAngle = realAngle + beishu
		self._startMoveAngle = beishu 
	end 
	realAngle = realAngle%360
	if realAngle<0 then
		realAngle = 360 - math.abs(realAngle)
	end 
	
	local offs = 270 - realAngle
	if self._strtMoveDir then
		self._startMoveAngle = self._startMoveAngle +  offs
	else
		self._startMoveAngle = self._startMoveAngle +  offs
	end 
end




function EllipticRotaryTable:drawEffects(idx)
	local realAngle = self:getRealAngle(idx)
	local Weight = self:getWeight(realAngle)
	self.m_Childrens[idx]:setLocalZOrder(#self.m_Childrens + 2 - math.abs(Weight))
end
function EllipticRotaryTable:update(dt)
	-- if self._isAutoScrolling then
	-- 	local realAngle = self:getRealAngle(self._curPageIdx)
	-- 	if(realAngle <= 271.0 and realAngle >= 269) then
	-- 		self.last_pageIdx = self._curPageIdx
	-- 		self._isAutoScrolling = false
	-- 	end
		
	-- 	self:movePages(self.m_changeAngle,self.m_changeNum)
	-- 	self.m_changeNum = self.m_changeNum - 1
	-- end

	self.m_slideTime = self.m_slideTime + dt	
	if not self._isStopMove then
		
		if (self._startMoveAngle > 0 and self._strtMoveDir ==false)  then
			local Speed = 8
			if self._startMoveAngle <= Speed then
				Speed = self._startMoveAngle
				Speed =math.max(0,Speed)	
			end
			local sp = self:angleToRadian(Speed)
			self:movePages(sp)
			self._startMoveAngle = self._startMoveAngle - Speed
		elseif (self._startMoveAngle < 0 and self._strtMoveDir ==true) then
			local Speed = -8
			if self._startMoveAngle >= Speed then
				Speed = self._startMoveAngle
				Speed =math.min(0,Speed)	
			end
			local sp = self:angleToRadian(Speed)
			self:movePages(sp)
			self._startMoveAngle = self._startMoveAngle - Speed

		else
			self._isStopMove = true
			self._startMoveAngle = 0
		end
	end


end
function EllipticRotaryTable:scrollToPage(idx)
	self._isAutoScrolling = true
	self._autoScrollSpeed = 10
	self.m_changeAngle = 270 - self:getRealAngle(self._curPageIdx)--//270 - 滑动页面当前角度（这是相对偏移的角度）   
	self.m_changeAngle = self:angleToRadian(self.m_changeAngle)--角度转弧度  
	self.m_changeOffset = self.tuoyuan_b * math.tan(self.m_changeAngle)
	self.m_changeOffset =self.m_changeOffset /self._autoScrollSpeed
	self.m_changeAngle = self.m_changeAngle/self._autoScrollSpeed
end


  
return EllipticRotaryTable

