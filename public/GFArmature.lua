function GFPlayerArmature()
	print("===========i am globel function")
end

function GFArmPlayFirstAnim(armature,armaturePath,headId,bodyId,weaponId)
    --取得动画名
    local armatureName = GFGetArmatureName(armaturePath)
    if armatureName==nil then
        return false
    end

    armatureName = armatureName.."_"..headId.."_"..bodyId.."_"..weaponId
    --初始化armature
    --if armature.__myLastArmatureName ~=armatureName then
    armature:init(armatureName)
    --armature.__myLastArmatureName = armatureName
    --end
    --取得所有动画
    local animation = armature:getAnimation()
    if animation==nil then
        print("in GFArmaturePlayAction: animation is nil!")
        return false
    end    
    animation:playWithIndex(0)
 
    -- --保存对碰撞骨骼的引用
    -- armature._beHitBoneList = GFGetBeHitBones(armature)
    -- armature._hitBoneList = GFGetHitBones(armature)
    -- --默认不显示碰撞区域图
    -- GFSetEditerColliderVisible(armature,g_bIsShowEditerCollider)
    --GFSetEditerColliderVisible1111(armature,g_bIsShowEditerCollider1)
    return true
end    
   
---
-- 设置骨骼动画对象的碰撞区是否显示
-- @param armature 骨骼动画对象
-- @param bool visible
function GFSetEditerColliderVisible(armature,visible)
    print("============display")
    --受击
    local boneDic = armature._beHitBoneList
    if boneDic ~= nil then
        for key,bone in pairs(boneDic) do
            local DDList = bone:getDisplayManager():getDecorativeDisplayList()
            if visible == true then
                for i,v in pairs(DDList or {}) do
                    v:getDisplay():setVisible(true)
                    v:getDisplay():updateTransform()
                end
            else
                for i,v in pairs(DDList or {}) do
                    v:getDisplay():setVisible(false)
                    v:getDisplay():updateTransform()
                end
            end
        end
    end

    --攻击
    local boneDic = armature._hitBoneList
    if boneDic ~= nil then
        for key,bone in pairs(boneDic) do
            local DDList = bone:getDisplayManager():getDecorativeDisplayList()
            if visible == true then
                for i,v in pairs(DDList or {}) do
                    v:getDisplay():setVisible(true)
                end
            else
                for i,v in pairs(DDList or {}) do
                    v:getDisplay():setVisible(false)
                end
            end
        end
    end
 
    local boneDic = armature:getBoneDic()
    if boneDic.main then
        local DDList = boneDic["main"]:getDisplayManager():getDecorativeDisplayList()
        for i,v in pairs(DDList or {}) do
            v:getDisplay():setVisible(visible)
        end
    end 
    if boneDic.touch then
        local DDList = boneDic["touch"]:getDisplayManager():getDecorativeDisplayList()
        for i,v in pairs(DDList or {}) do
            v:getDisplay():setVisible(visible)
        end
    end
    if boneDic.barrier then
        local DDList = boneDic["barrier"]:getDisplayManager():getDecorativeDisplayList()
        for i,v in pairs(DDList or {}) do
            v:getDisplay():setVisible(visible)
        end
    end
end

---
-- 取得骨骼动画对象受击骨骼
-- @param armature 骨骼动画对象
-- @return 成功返回骨骼动画对象受击骨骼列表，失败返回nil
function GFGetBeHitBones(armature)
    print("======behit")
    if armature==nil then
        print("in GFGetBeHitRangeList: armature is nil!")
        return nil
    end

    local boneDic = armature:getBoneDic()
    --从beHit1开始
    if boneDic.beHit1 ~= nil then
        local beHitBoneList = {}
        local temp = "beHit"
        local i = 0
        repeat
            i = i+1
            if boneDic[temp..i]~=nil then
                local bone = boneDic[temp..i]
                --beHitBoneList[temp..i] = bone
                table.insert(beHitBoneList,bone)
            else
                return beHitBoneList
            end
        until false
    else
        return nil
    end
end


---
-- 取得骨骼动画对象攻击骨骼
-- @param armature 骨骼动画对象
-- @return 成功返回骨骼动画对象攻击骨骼列表，失败返回nil
function GFGetHitBones(armature)
    print("======hit")
    if armature==nil then
        print("in GFGetBeHitRangeList: armature is nil!")
        return nil
    end

    local boneDic = armature:getBoneDic()
    pprint(boneDic,"boneDic")
    local hitBoneList = nil
    for key,bone in  pairs(boneDic) do
        print("==========="..bone:getName())
        if string.find(bone:getName(),'hit') ~= nil then
            hitBoneList = hitBoneList or {}
            --hitBoneList[bone:getName()] = bone
            table.insert(hitBoneList,bone)
        end
    end
    pprint(hitBoneList,"hitBoneList")
    return hitBoneList
--[[
    --从hit1开始
    if boneDic.hit1 ~= nil then
        local hitBoneList = {}
        local temp = "hit"
        local i = 0
        repeat
            i = i+1
            if boneDic[temp..i]~=nil then
                local bone = boneDic[temp..i]
                hitBoneList[temp..i] = bone
            else
                return hitBoneList
            end
        until false
    else
        return nil
    end
    ]]
end