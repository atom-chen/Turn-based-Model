
-- Scene Order List --层级关系
local Order_List = {
    Distant_Layer = 100,    --远景层
    Near_Layer    = 200,    --近景层
    MainUI_Layer  = 300,	--主ui层
    SubUI_Layer   = 400,	--副ui层           
    Gesture_Layer = 500,    --操作层
    MsgBox_Layer  = 600,    --弹出框层
    MsgText_Layer = 700,    --飘字层
} 

local baseScene = class("baseScene",function()
	return cc.Scene:create()
end)

function baseScene:ctor(sceneId)
    --print("==========baseScene init()")
    self.sceneId = sceneId
	self:InitLayers()
    --self.sceneType = praSceneType	-- 1战斗场景，2村庄场景 ,3地图场景  
end

-- 初始化各层
function baseScene:InitLayers()
	
    --远景层
    local layer = cc.Layer:create()
    self:addChild(layer, Order_List.Distant_Layer)
    self.distantLayer = layer

    --近景层
    local layer = cc.Layer:create()
    self:addChild(layer, Order_List.Near_Layer)
    self.nearLayer = layer

    --主ui层
    local layer = cc.Layer:create()
    self:addChild(layer, Order_List.MainUI_Layer)
    self.mainLayer = layer

    --副ui层    
    local layer = cc.Layer:create()
    self:addChild(layer, Order_List.SubUI_Layer)
    self.subLayer = layer

    --操作层
    local layer = cc.Layer:create()
    self:addChild(layer, Order_List.Gesture_Layer)
    self.gestureLayer = layer

    --弹出框层
    local layer = cc.Layer:create()
    self:addChild(layer, Order_List.MsgBox_Layer)
    self.popLayer = layer

    --飘字层
    local layer = cc.Layer:create()
    self:addChild(layer, Order_List.MsgText_Layer)
    self.floatLayer = layer

end

--获取场景id
function baseScene:getSceneID()
    return self.sceneId
end

-- 获取远景层
function baseScene:getDistantLayer()
    if self.distantLayer then
        return self.distantLayer
    end
    return nil
end

---
-- 获取近景层
function baseScene:getNearLayer()
    if self.nearLayer then
        return self.nearLayer
    end
    return nil
end

---
-- 获取主ui
function baseScene:getMainUILayer()
    if self.mainLayer then
        return self.mainLayer
    end
    return nil
end

---
-- 获取副ui
function baseScene:getSubUILayer()
    if self.subLayer then 
        return self.subLayer
    end
    return nil
end

---
-- 获取操作层
function baseScene:getGestureLayer()
    if self.gestureLayer then
        return self.gestureLayer
    end
    return nil
end

---
-- 获取弹出框层
function baseScene:getPopLayer()
    if self.popLayer then
        return self.popLayer
    end
    return nil
end

---
-- 获取飘字层
function baseScene:getFloatLayer()
    if self.floatLayer then
        return self.floatLayer
    end
    return nil
end


function baseScene:create()
	return baseScene.new()
end

return baseScene