
local baseScene = require("scene.baseScene")

local fightScene = class("fightScene",baseScene)

--主城
function fightScene:ctor()
    self.super.ctor(self,FightScene_1)
    self:createDistantView()
    self:createNearView()
    self:createMonster()
    self:createRole()
    self:createHandle()
end

--远景
function fightScene:createDistantView()
    --远景层
    --local distantLayer = self:getDistantLayer()
    local bgLayer = ccui.ImageView:create()
    self.bgLayer = bgLayer
    bgLayer:loadTexture("scene/fight/fight_bg_1.png")
    bgLayer:setAnchorPoint(cc.p(0.5,0.5))
    bgLayer:setPosition(cc.p(480,320))
    self.distantLayer:addChild(bgLayer,1) 
end
--近景
function fightScene:createNearView()
   
end

--创建怪物
function fightScene:createMonster()
    local function callback()
        print("========callback")
    end
    local monster = require("bio.monster"):create(480,320,1001)
    self.monster =  monster
    self.mainLayer:addChild(monster)
    monster:playAction(2001,5,callback,true)
end

--创建主角
function fightScene:createRole()

end

--创建操作
function fightScene:createHandle()
    print("==================node1")

    local node = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("myLayer.csb")  --ccs.GUIReader:getInstance():widgetFromBinaryFile("Layer.csb") 
    self.gestureLayer:addChild(node)
    -- local root = node:getChildByName("Panel_1")   
    -- --local panel1 = ccui.Helper:seekWidgetByName(root, "Panel_1")
    -- local panel = ccui.Helper:seekWidgetByName(root, "Panel_2")
    -- --local panel = ccui.Helper:seekWidgetByName(root, "CheckBox_540")
    -- local button_1 = ccui.Helper:seekWidgetByName(panel, "Button_1")
    -- local button_2 = ccui.Helper:seekWidgetByName(panel, "Button_2")
    -- local button_3 = ccui.Helper:seekWidgetByName(panel, "Button_3")
    -- local button_4 = ccui.Helper:seekWidgetByName(panel, "Button_4")
    -- local button_5 = ccui.Helper:seekWidgetByName(panel, "Button_5")
    -- print("==================node2")
    -- local function  pressEvent1(sender,event)
    --     if event == ccui.TouchEventType.ended then
    --         print("==================按钮按下")
    --        local action = {}
    --         action.actionType = Attack
    --         action.bioA = self.monster
    --         action.bio2Id = bio2Id
    --         action.actionId = 0
    --         require("controler.fightControler"):getInstance():monsterAttack(self.monster,nil)
    --     end
    -- end

    -- button_1:addTouchEventListener(pressEvent1)
    -- local function  pressEvent2(sender,event)
    --     if event == ccui.TouchEventType.ended then
    --         print("==================按钮按下")
    --     end
    -- end
    -- button_2:addTouchEventListener(pressEvent2)

    -- local function  pressEvent3(sender,event)
    --     if event == ccui.TouchEventType.ended then
    --         print("==================按钮按下")
    --     end
    -- end
    -- button_3:addTouchEventListener(pressEvent3)

    -- local function  pressEvent4(sender,event)
    --     if event == ccui.TouchEventType.ended then
    --         print("==================按钮按下")
    --     end
    -- end
    -- button_4:addTouchEventListener(pressEvent4)

    -- local function  pressEvent5(sender,event)
    --     if event == ccui.TouchEventType.ended then
    --         print("==================按钮按下")
    --     end
    -- end
    -- button_5:addTouchEventListener(pressEvent5)

    
end

function fightScene:create()
    return fightScene.new()
end

return fightScene