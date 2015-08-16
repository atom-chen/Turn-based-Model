
local bio = class("bio",function()
         return cc.Sprite:create()
end)

function bio:ctor()

end

function bio:ctor(dyId,staticId,bLeader,name,level,x,y,state,headSkinId,bodySkinId,weaponSkinId,armatureRes,properties,skillBar,nameHeight,haloEffectId,templetHSId,bShowBlood,enterWayId,enterTime,direction)
    print("bio:ctor_dyId=",dyId,"staticId=",staticId,"name=",name,"self=",type(self),"x,y=",x,y,"headSkin,bodySkin,weaponSkin=",headSkinId,bodySkinId,weaponSkinId,"armatureId=",armatureResId,"enterTime=",enterTime)
    if direction==nil then direction = bioDirectionType.right end
    --****************属性***********************
    --数据相关
    self.properties = properties or     --一系列属性table
    {
        hp                =   1,                    -- 血量 当前
        mp                =   1,                    -- 魔法 当前
        atk               =   1,                    -- 物理攻击
        def               =   1,                    -- 物理防御
        hit               =   1,                    -- 命中值
        crit              =   1,                    -- 暴击值
        critDamage        =   1,                    -- 暴击时的伤害倍率 (小数，字符串格式)
        speedWalkVx       =   1,                    -- 行走 单位秒内移动的像素
        hpMax             =   1,                    -- 血量上限
        mpMax             =   1,                    -- 魔法上限
        faction           =   1,                    -- 1友方 2敌方 3中立 
        atkDamage         =   1,                    --物理伤害
        dizzy             =   0,                    --晕
        wide              =   0,                    --狂暴
        shield            =   0,                    --护盾
        invincible        =   0,                    --无敌
        vampire           =   0,                    --吸血
        minFloatDamage    =   0,                    --伤害浮动下限
        maxFloatDamage    =   0,                    --伤害浮动上限
        tyrant            =   0,                    --霸体

    }

    self.dyId = dyId                                --人物动态id
    self.staticId = staticId                        --人物静态id
    self.bLeader = bLeader                          --是否为主角
    self.name = name                                --人物名称
    self.level = level
    self.orgPos = cc.p(x,y)                         --人物初始坐标Point
    self.armatureResList = armatureRes                       --动画资源，有number和table两种格式，tab格式:{hp比例@armatureId#}
    --self.armatureResId = self:selectArmatureResIdOnHp()      --人物动画资源id
    self.headSkinId = headSkinId or 0
    self.bodySkinId = bodySkinId or 0
    self.weaponSkinId = weaponSkinId or 0
    self.orgSkillBar = skillBar                     --人物技能栏,[技能栏id]={skillId,...}
    --self.threatQueue = threatQueue:create(self)     --仇恨队列模块对象
    self.comboObj = nil                             --comboAttack的对象,lua类
    self.skillObj = nil                             --释放技能时候的技能管理对象，最多只有一个

    self.armatureName = nil                         --资源名字
    self.nameHeight = nameHeight or 0               --名字高度
    self.HSId = templetHSId                         --硬直模板id
    self.sceneLandHeight = 200                      --场景陆地高，即人物站在地面时的高度，ps：目前无用
    self.armatureObj = nil
    self.shadowObj = nil                            --阴影
    self.haloObj = nil                              --光圈对象
    self.bloodObj = nil
     
    self.buffs = {}                                 --buff列表,[buffId] = {id,duration,count,icon,armature,posX,posY}

    self.state = state                              --人物状态
    self.direction = bioDirectionType.right       --面朝方向，1-左边，2-右边
    --self.moveDirection = g_bioMoveDirType.onward    --移动方向
    --self.xMoveState = g_bioStateType.standing       --x轴移动状态，包括走，跑，站立
    self.presetDirection = nil                      --预设的人物朝向，攻击动作结束后要根据该值调整朝向,nil时表示没有
    self.attackOrderQue = {}                        --攻击指令队列,格式{order,dir}
    self.speedJumpVy = 400                          --人物跳跃y速度
    self.speedJumpAy = -1300                        --跳跃加速度
    --self.speedBeStrikeFlyVy = 400                 --人物被击飞时的x速度
    self.speedBeStrikeFlyAy = -1200                 --击飞状态下的加速度
    --self.speedBeHitVx = 80                        --人物受击时的x速度
    self.jumpHeight = 230                           --惹怒跳起的高度
    self.lyingFlyHeight = 50                        --躺飞的高度
    self.lyingFlyLength = 220                       --躺飞的长度
    self.speedLyingFlyAy = -1600                    --躺飞的加速度
    self.deathHeight = 90                           --死亡的抛物线高度
    self.deathLength = 130                          --死亡的抛物线长度
    self.speedDeathAy = -1800                       --死亡时从空中掉下的加速度
    self.bDeathFinish = false                       --是否完成死亡动画，即完成死亡抛物线落地
    self.vx = 0
    self.vy = 0
    self.ax = 0                                     --x轴加速度
    self.ay = 0                                     --y轴加速度
    self.passiveMoveTime = 0                        --人物被动移动的时间
    self.autoMoveTime = 0
    self.arriveDesCallBack = nil                    --抵达目的地时的回调
    --self.moveDisx = 0                             --人物需要移动的x距离
    --self.moveDisy = 0                             --人物需要移动的y距离
    self.bAttackAnimOver = false                    --攻击动画是否播放完毕
    self.schedulerId = nil                          --loopUpdate的定时器id
    self.enterSceneSchedulerId = nil                --进入场景的定时器
    self.autoRemoveSchedulerId = nil                --自动删除定时器

    self.sceneManagement=nil                        --场景管理类
    --self.bChangStateByServer = false                --是否由服务器改变状态


    --********************************************
    self:setPosition(x,y)

    --注册接收协议
    GFRecAddDataListioner(self)

    --注册循环定时器
    local function tempLoop(dt)
        self:loopUpdate(dt)
    end
    self.schedulerId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(tempLoop, 0, false)

    --注册事件回调
    local function onNodeEvent(event)
        self:onNodeEvent(event)
    end
    self:registerScriptHandler(onNodeEvent)

    --播放初始状态动画
    self:playNewAnimation()
    --self:setDirection(direction)
    --self:createShadow()
    --self:createHalo(haloEffectId)
    if bShowBlood then
        self:createBlood()
    end
    --self:createCombo()

    -- --入场景时间
    -- if enterTime and enterTime>0 then
    --     local function tempEnterScene()
    --         self:enterScene()
    --     end
    --     self:setVisible(false)
    --     self.enterSceneSchedulerId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(tempEnterScene, enterTime, false) 
    -- end

end

--生物循环刷新
function bio:loopUpdate()

end

--节点退出事件
function bio:onNodeEvent(event)

end

--创建血条
function bio:createBlood()

end 

--播放动画
function bio:playNewAnimation(skillId)
    local x,y =self:getBodyPosition()
    self:setPosition(x,y)
    --draw
    self:stopAllActions()

    local state=self.state
    --若死亡且处于抛物线运动时,用击飞的动画,直到落地用回死亡动画
    if state==g_bioStateType.death and not self.bDeathFinish then
        state = g_bioStateType.beHit
    end
    --根据状态校正Y轴坐标
    if state==g_bioStateType.standing or state==g_bioStateType.walking or state==g_bioStateType.beHit or state==g_bioStateType.lyingFloor or state==g_bioStateType.death or state==g_bioStateType.standUp then
        self:setPositionY(self.orgPos.y)
    end

    self:createArmature()
    if skillId then
        --通过技能id播放攻击动画
        GFPlayBioSkill(self.armatureObj,skillId,self.headSkinId,self.bodySkinId,self.weaponSkinId)
    else
        --通过状态播放动画
        GFArmaturePlayAction(self.armatureObj,self.armatureResId,state,self.headSkinId,self.bodySkinId,self.weaponSkinId)
    end


    self:correctionPosition()
    self:updateShadow()
    self:updateHalo()
    self:updateBuffAndDot()
    self:updateBlood()
    self:restorePresetDirection()


    -- --动画监听回调
    -- --整体动画回调
    -- --@param owner 所属者
    -- --@param movementType 1-非循环动画播放结束,2-循环动画每次动画播放结束
    -- --@param movementId 动画标识str
    -- local function onAnimationMovementEvent(owner,movementType,movementId)
    --     if movementType==1 then
    --         if self.bLeader then
    --             print("movementEvent,movementType=",movementType,"movementId=",movementId,"dyId=",self.dyId,"bioState=",self.state)
    --         end
    --         if self.state==g_bioStateType.attackReady or self.state==g_bioStateType.attacking or self.state==g_bioStateType.attackEnd or self.state==g_bioStateType.jumpAttackReady or self.state==g_bioStateType.jumpAttacking or self.state==g_bioStateType.jumpAttackEnd or self.state==g_bioStateType.standUp then

    --                 self.bAttackAnimOver = true
    --                 if self.state==g_bioStateType.standUp then
    --                     --起身状态完成后变成站立动画
    --                     self:enterNextState(g_bioStateType.standing)
    --                 else
    --                     self:finishSkill()
    --                     if self.state==g_bioStateType.jumpAttackEnd then
    --                         local x,y = self:getBodyPosition()
    --                         if y-self.orgPos.y>10 then
    --                             self:enterNextState(g_bioStateType.jumpDown)
    --                         else
    --                             self:restoreXMoveState()
    --                         end
    --                     else
    --                         --attakEnd状态时强制转换成陆地状态
    --                         self:setPositionY(self.orgPos.y)
    --                         self:restoreXMoveState()
    --                     end
    --                     --self:clearOrderQue()
    --                 end

    --         end
    --     end
    -- end
    -- self.armatureObj:getAnimation():setMovementEventCallFunc(onAnimationMovementEvent)

    -- --骨骼动画关键帧回调
    -- --@param bone 骨骼动画
    -- --@param eventName 事件tag
    -- --@param originFrameIndex 预定的触发事件的帧数
    -- --@param currentFrameIndex 实际触发时的帧数，特殊情况下由丢帧引起的实际触发帧数大于预定帧数
    -- local function onBoneFrameEvent(bone,eventName,originFrameIndex,currentFrameIndex)
    --     if self.bLeader then
    --         print("frameEvent,eventName=",eventName,",dyId=",self.dyId,"bioState=",self.state)
    --     end
    --     if self.state==g_bioStateType.attackReady or self.state==g_bioStateType.attacking or self.state==g_bioStateType.jumpAttackReady or self.state==g_bioStateType.jumpAttacking then
    --         local names = FGUtilStringSplit(eventName,"+")

    --         for i,name in ipairs(names) do
    --             if name=="attacking" then
    --                 self:enterNextState(g_bioStateType.attacking)
    --             elseif name=="attackEnd" then
    --                 print("nextFrameFunc,dyId=",self.dyId)
    --                 self:enterNextState(g_bioStateType.attackEnd)
    --                 self:runNextAttackOrder()
    --                 --[[
    --                 --下帧回调
    --                 local function nextFrameFunc()
    --                     print("nextFrameFunc,dyId=",self.dyId)
    --                     self:enterNextState(g_bioStateType.attackEnd)
    --                     self:runNextAttackOrder()

    --                     if self.onceSchedulerIds[2] then
    --                         cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.onceSchedulerIds[2])
    --                     end
    --                 end

    --                 if self.onceSchedulerIds[2] then
    --                     cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.onceSchedulerIds[2])
    --                 end
    --                 self.onceSchedulerIds[2] = cc.Director:getInstance():getScheduler():scheduleScriptFunc(nextFrameFunc, 0, false)
    --                 ]]
    --             elseif name=="jumpAttacking" then
    --                 self:enterNextState(g_bioStateType.jumpAttacking)
    --             elseif name=="jumpAttackEnd" then
    --                 self:enterNextState(g_bioStateType.jumpAttackEnd)
    --                 self:runNextAttackOrder()
    --             else
    --             --通知技能那边的事件
    --                 if self.skillObj~=nil then
    --                     self.skillObj:eventHandler(bone,name,originFrameIndex,currentFrameIndex)
    --                 end
    --             end
    --         end

    --     end
    -- end
    -- self.armatureObj:getAnimation():setFrameEventCallFunc(onBoneFrameEvent)

end

return bio