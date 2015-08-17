
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
    local monster = require("bio.monster"):create(480,320,2001)
    self.monster =  monster
    self.mainLayer:addChild(monster)
    monster:stand()
end

--创建主角
function fightScene:createRole()
    local role = require("bio.role"):create(480,580)
    role:beHitShow()
    self.mainLayer:addChild(role,200)
end

--创建操作
function fightScene:createHandle()
    print("==================node1")    

    local node = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("handle.csb")  --ccs.GUIReader:getInstance():widgetFromBinaryFile("Layer.csb") 
    self.gestureLayer:addChild(node)
    local root = node:getChildByName("Panel_1")   
    --local panel1 = ccui.Helper:seekWidgetByName(root, "Panel_1")
    local panel = ccui.Helper:seekWidgetByName(root, "Panel_2")
    --local panel = ccui.Helper:seekWidgetByName(root, "CheckBox_540")
    local button_1 = ccui.Helper:seekWidgetByName(panel, "Button_1")
    local button_2 = ccui.Helper:seekWidgetByName(panel, "Button_2")
    local button_3 = ccui.Helper:seekWidgetByName(panel, "Button_3")
    local button_4 = ccui.Helper:seekWidgetByName(panel, "Button_4")
    local button_5 = ccui.Helper:seekWidgetByName(panel, "Button_5")
    print("==================node2")
    local function  pressEvent1(sender,event)
        if event == ccui.TouchEventType.ended then
            print("==================按钮按下")
            local function callback()
                print("========执行站立")
                self.monster:stand()
            end
            self.monster:attack(callback)
        end
    end

    button_1:addTouchEventListener(pressEvent1)
    local function  pressEvent2(sender,event)
        if event == ccui.TouchEventType.ended then
            print("==================按钮按下")
            local function callback()
                print("========释放技能")
                self.monster:stand()
                self.monster:skillToAttack(5002)
            end
            self.monster:skill(callback)
        end
    end
    button_2:addTouchEventListener(pressEvent2)

    local function  pressEvent3(sender,event)
        if event == ccui.TouchEventType.ended then
            print("==================按钮按下")
            local function callback()
                print("========执行站立")
                self.monster:stand()
            end
            self.monster:behit(callback)
        end
    end
    button_3:addTouchEventListener(pressEvent3)

    local function  pressEvent4(sender,event)
        if event == ccui.TouchEventType.ended then
            print("==================按钮按下")
            local function callback()
                print("========执行站立")
                self.monster:stand()
            end
            self.monster:die(callback)
        end
    end
    button_4:addTouchEventListener(pressEvent4)

    local function  pressEvent5(sender,event)
        if event == ccui.TouchEventType.ended then
            print("==================按钮按下")
            local function callback()
                print("========执行站立")
                self.monster:stand()
            end
            self.monster:attack(callback)
        end
    end
    button_5:addTouchEventListener(pressEvent5)

    
end

function fightScene:create()
    return fightScene.new()
end

return fightScene