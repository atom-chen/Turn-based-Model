
local baseScene = require("scene.baseScene")

local cityScene = class("cityScene", baseScene)

--主城
function cityScene:ctor()
	self.super.ctor(self,CityScene_1)
	local sceneLayer = self:GetSceneLayer()
	--远景层
	local bgLayer = ccui.ImageView:create()
	self.bgLayer = bgLayer
	bgLayer:loadTexture("scene/city/house_1_2.jpg")
	bgLayer:setAnchorPoint(cc.p(0.5,0.5))
	bgLayer:setPosition(cc.p(480,320))
	sceneLayer:addChild(bgLayer,1)
	--近景层
	local cityLayer = ccui.ImageView:create()
	self.cityLayer = cityLayer
	cityLayer:loadTexture("scene/city/house_1_1.png")
	cityLayer:setAnchorPoint(cc.p(0.5,0.5))
	cityLayer:setPosition(cc.p(480,320))
	sceneLayer:addChild(cityLayer,100)

	--GFPlayerArmature()
	self:createNpc()
end

function cityScene:createNpc() 
	local path = "armatureRes/role_1_run.ExportJson"
	local armName = "role_1_run"
	--读取动画文件
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(path)
	--通过名字
	local npcArmature = self:createArmature()
	self:addChild(npcArmature,200)
	npcArmature:init(armName)
    --armature.__myLastArmatureName = armatureName
    --end
    --取得所有动画
    local animation = npcArmature:getAnimation()
    if animation==nil then
        print("in GFArmaturePlayAction: animation is nil!")
        return false 
    end
    animation:playWithIndex(0) 
     --保存对碰撞骨骼的引用
    --npcArmature._beHitBoneList = GFGetBeHitBones(npcArmature)
    --npcArmature._hitBoneList = GFGetHitBones(npcArmature)

    -- local count = npcArmature:getBoneCount()
    -- print("==========骨骼数量",count)
    local bone = npcArmature:getBoneDic()
    
    -- local bone1 = npcArmature:getBoneDic("body")
    -- local bone2 = npcArmature:getBoneDic("touch")
    -- local bone3 = npcArmature:getBoneDic("main")
    pprint(bone,"=============guge")
    -- if bone.main then
    --     print("==========main")
    -- end
    -- pprint(bone["main"],"==================1")
    --bone["main"]:setVisible(false) 
    --local DDList = bone["behit1"]:getDisplayManager():getDecorativeDisplayList()
    local bone2 = npcArmature:getBone("main")
    --local DDList = bone2:getDisplayManager():getBoundingBox()
    local DDList = bone["main"]:getDisplayManager():getDecorativeDisplayList()
    --bone2:getDisplayManager():setVisible(false)
    --print("======1",DDList.x)
    --print("======2",DDList.y)
    pprint(DDList,"==================1")
    print("=======",#DDList)
    
    for i,v in pairs(DDList or {}) do
        print("=======",i)
     end
    -- pprint(bone.main,"===================2")
    -- pprint(bone["touch"],"================3")
    -- for key,b in pairs(bone) do 
    -- 	print("XXX___",key,b:getName());
    -- end
    -- pprint(bone1,"=========骨骼main1") 
    -- pprint(bone2,"=========骨骼body2")
    -- pprint(bone3,"=========骨骼touch3")
    --pprint(bone.touch,"============")
    -- if bone.touch then
    -- 	print("true")
    --     local DDList = bone["touch"]:getDisplayManager():getDecorativeDisplayList()
    --     for i,v in pairs(DDList or {}) do
    --         v:getDisplay():setVisible(visible)
    --     end
    -- end
    GFSetEditerColliderVisible(npcArmature,false)
end

--创建骨骼动画
function cityScene:createArmature()
	print("================create armature")
    local armatureObj = ccs.Armature:create()
    armatureObj:setPosition(480,320)
    armatureObj:setAnchorPoint(0,0)
    return armatureObj
end

function cityScene:create()
	return cityScene.new()
end

return cityScene