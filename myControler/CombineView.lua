--CombineView.lua



local CombineView = class("CombineView",
	function() return cc.Layer:create() 
end)

function CombineView:create(viewSize,dataSource,totalPage,currentPage)
	return CombineView.new(viewSize,dataSource,totalPage,currentPage)
end
function CombineView:ctor(viewSize,dataSource,totalPage,currentPage)
	self.m_tableViews = {}	
	self.m_tolalPage = totalPage
	self.m_currentPage = currentPage or 0
	self.m_currentPage = math.min(self.m_tolalPage-1,self.m_currentPage)
	self.m_currentPage = math.max(0,self.m_currentPage)
	self.m_dataSource = dataSource
	self.m_viewSize = viewSize
	self:setContentSize(viewSize)

	self.m_firstPoint = cc.p(0,0)
	self.m_offset = cc.p(0,0)
	self.m_vertical = false
	self.m_horizontal = false


	

	local x = ccui.Layout:create()
	--x:setBackGroundImage("scale_2.png")
	--x:setBackGroundImageScale9Enabled(true)
	x:setClippingEnabled(true)
	x:setContentSize(viewSize)
	x:setAnchorPoint(0,0)
	x:setPosition(0,0)
	self:addChild(x)
	self.m_clipping = x	


	local pContainer = cc.Layer:create() 
	pContainer:setContentSize(cc.size(viewSize.width*self.m_tolalPage,viewSize.height))
	pContainer:setAnchorPoint(0,0)
	pContainer:setPosition(0,0)
	x:addChild(pContainer)
	self.m_container = pContainer


	
	for i=1,totalPage do
		local tab = cc.TableView:create(viewSize)
		--tab:initWithViewSize(viewSize)
		tab.index = i-1
		--tab:autorelease()
		tab:setDelegate()
		tab:ignoreAnchorPointForPosition(false)
		tab:setPosition(viewSize.width/2+viewSize.width*(i-1),viewSize.height/2)
		tab:setAnchorPoint(0.5,0.5)
		tab:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    	tab:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
		
		
		table.insert(self.m_tableViews,tab)

		local function numberOfCellsInTableView(tab)
			return self.m_dataSource:numberOfCellsInTableView(tab,tab.index)
		end
		local function tableCellSizeForIndex(tab,idx)
			return self.m_dataSource:tableCellSizeForIndex(tab,idx,tab.index)
		end

		local  function tableCellAtIndex(tab,idx)
			print("tableCellAtIndex",idx)
			return self.m_dataSource:tableCellAtIndex(tab,idx,tab.index)
		end

		local function tableCellTouched(tab,cell)
			if self.m_dataSource.tableCellTouched then
				return self.m_dataSource:tableCellTouched(tab,cell)
			end
		end
		local  function scrollViewDidScroll(tab)
			if self.m_dataSource.scrollViewDidScroll then
				return self.m_dataSource:scrollViewDidScroll(tab)
			end
		end
		local  function scrollViewDidZoom(tab)
		end
	 
		tab:registerScriptHandler(scrollViewDidScroll,cc.SCROLLVIEW_SCRIPT_SCROLL)
	    --tab:registerScriptHandler(scrollViewDidZoom,cc.SCROLLVIEW_SCRIPT_ZOOM)
	    tab:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
	    tab:registerScriptHandler(tableCellSizeForIndex,cc.TABLECELL_SIZE_FOR_INDEX)
	    tab:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
	    tab:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
	    tab:reloadData()
	    pContainer:addChild(tab)

	    
	end

	local function onTouchBegan(touch, event)
		self.m_firstPoint = touch:getLocation()
		self.m_offset.x,self.m_offset.y = self.m_container:getPosition()
		local x = - self:getAnchorPoint().x*self:getContentSize().width
		local y = - self:getAnchorPoint().y*self:getContentSize().height	
		local rect = cc.rect(0,0,self:getContentSize().width,self:getContentSize().height)
    	local ret = cc.rectContainsPoint(rect,self:convertTouchToNodeSpace(touch))
    	return ret

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

   

   
    local function onNodeEvent(event)
        if "exit" == event then
            self:setTick(false)
        elseif "enter" == event then
        	self:setTick(true)
        end
    end
    self:registerScriptHandler(onNodeEvent)

end
--获取当前页 0～total -1
function CombineView:getCurrentPage()
	return self.m_currentPage
end
--设置横向停止回调
function CombineView:setPageStopCallBack(func)
	self.m_pagechangeCall = func
end

function CombineView:setTick(state)
	local function tick(dt)
		--self:update(dt)
    end
	if state then
		if not self.schedulerID then
			self.schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(tick, 0, false)
		end
	else
		if self.schedulerID then
			cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
            self.schedulerID = nil
        end
	end
end
function CombineView:setContentOffset(offset,isAnimated)
	if isAnimated then
		self:setContentOffsetInDuration(offset,0.15)
	else
		self.m_container:setPosition(offset)
	end
end

function CombineView:setContentOffsetInDuration(offset,dt)
	local a = cc.MoveTo:create(dt,offset)
	local call = function()
		for k,v in pairs(self.m_tableViews) do 
			local x = v:minContainerOffset()
			v:setContentOffset(x)

			
		end
		print("我是第几页：",self.m_currentPage)
		if self.m_pagechangeCall then
			self.m_pagechangeCall(self)
		end
	end
	local b = cc.CallFunc:create(call)
	local c = cc.Sequence:create(a,b)
	self.m_container:runAction(c)
end

function CombineView:onTouchMoved(touch)
	local movePoint = touch:getLocation()
	local distance = movePoint.x - self.m_firstPoint.x
	if ((distance > 0 and self.m_currentPage <=0 ) or (distance < 0 and self.m_currentPage >= #self.m_tableViews-1)) then
		return
	end
	
	if math.abs(movePoint.y - self.m_firstPoint.y)/math.abs(distance) > 0.7 or self.m_vertical then
		if (not self.m_horizontal) then
			self.m_vertical = true
		end
		return 
	else
		if (not self.m_vertical) then
			self.m_horizontal = true
		end
	end
	if (self.m_horizontal) then
		self:SetTouch(false)
	end
	--self.m_scrollView:setContentOffset(cc.p(distance + self.m_offset.x,0))
	self:setContentOffset(cc.p(distance + self.m_offset.x,0))
end
function  CombineView:onTouchEnded(touch)
	local endPoint = touch:getLocation()
	local distance = endPoint.x - self.m_firstPoint.x
	local  flag = false
	if math.abs(distance) < 60 then
		flag = true
		if distance < 0 then
			self.m_currentPage = self.m_currentPage - 1
		elseif distance > 0 then
			self.m_currentPage = self.m_currentPage + 1
		end
	end
	
	if (self.m_vertical) then
		self.m_vertical = false
		if (flag) then
			if (distance > 0) then
				self.m_currentPage = self.m_currentPage - 1
			elseif (distance < 0) then
				self.m_currentPage = self.m_currentPage + 1
			end
		end
		return 
	else
		self:SetTouch(true)
	end

	self:adjustScrollView(distance)
	self.m_horizontal = false
end


function CombineView:SetTouch(isTouched)
	 for i,v in ipairs(self.m_tableViews) do
	 	v:setTouchEnabled(isTouched)
	 end
end



function CombineView:adjustScrollView(offset)
	if offset < 0 then
		self.m_currentPage = self.m_currentPage + 1
	elseif offset > 0 then
		self.m_currentPage = self.m_currentPage - 1
	end
	
	self.m_currentPage = math.min(self.m_tolalPage-1,self.m_currentPage)
	self.m_currentPage = math.max(0,self.m_currentPage)
	local adjustPoint = cc.p(-self.m_viewSize.width * self.m_currentPage,0)
	--self.m_scrollView:setContentOffsetInDuration(adjustPoint,0.1)
	self:setContentOffsetInDuration(adjustPoint,0.15)
end








return CombineView