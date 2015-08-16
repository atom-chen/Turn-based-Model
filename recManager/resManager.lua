---
-- 资源管理模块
-- @module resManager
-- @author Mars
-- @copyright usugame
--
require "Cocos2d"

local _resManagerInstance = nil

--资源文件类型
local e_fileType = {
    json = 1,
    plist = 2,
    image = 3,
}

local c_preLoadPerFileNum = 20 --预加载每次加载的文件数量

local resManager = class("resManager",function()
    return cc.Node:create()
end)

--获取实例
function resManager:getInstance()

    if _resManagerInstance==nil then
        _resManagerInstance = resManager.new()
        _resManagerInstance:retain()
    end
    return _resManagerInstance
end

function resManager:ctor()
    self.loadedList = {}                --已加载的资源表,格式:[fileKey] = {ctype,bForever=ture/false,}
    self.preWaitList = {}               --预加载等待加载队列,格式:[index] = {path(str格式),headId,bodyId,weaponId,bForever}
    self.preLoadingCallBack = nil       --预加载时外部进度条回调函数,参数0~1,1表示完成
    self.preLoadedFileCount = 0         --预加载时已加载的文件计数
    self.preLoadTotalFileNum = 0        --预加载的文件总数

    self.asyncWaitList = {}             --异步加载等待加载队列,格式:[int] = {paths(table格式),headId,bodyId,weaponId,finishCallBack(完成回调),loadedCount,(已加载的数量)}
    self.asyncBeRunning = false         --是否正在运行异步加载

    --注册循环定时器
    local function tempLoop(dt)
        self:loopUpdate(dt)
    end
    self.schedulerId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(tempLoop, 0, false)

    --注册事件回调
    local function onEvent(event)
        self:onNodeEvent(event)
    end
    self:registerScriptHandler(onEvent)
end

--开始预加载
--@waitList 格式:[int] = {path,headId,bodyId,weaponId,bForever},顺序数组
function resManager:startPreLoading(waitList,callBack)
    self.preWaitList = waitList
    self.preLoadingCallBack = callBack
    self.preLoadedFileCount = 0
    self.preLoadTotalFileNum = #waitList
end

--加入需要异步加载的资源
--@paths 资源路径列表，顺序数组格式
--@headId 头部皮肤id
--@bodyId 身体id
--@weaponId 武器id
--@finshiCallBack 本table加载完成回调
function resManager:addAsyncLoading(paths,headId,bodyId,weaponId,finishCallBack)
    local async = {
        paths = paths,
        headId = headId,
        bodyId = bodyId,
        weaponId = weaponId,
        finishCallBack = finishCallBack,
        loadedCount = 0,
    }

    table.insert(asyncWaitList,async)
end

--异步加载的回调
function resManager:asyncLoadingCallBack()
    local tag = self.asyncWaitList[1]
    if tag then
        tag.loadedCount = tag.loadedCount + 1
        if tag.loadedCount==#tag.paths then
            tag.finishCallBack()
            table.remove(self.asyncWaitList,1)
            self.asyncBeRunning=false
        end
    else
        print("error:asyncLoadingCallBack asyncWaitList is empty!")
    end 
end

--每帧检测异步加载队列
function resManager:runAsyncLoading()
    local tag = self.asyncWaitList[1]
    if self.asyncBeRunning==false and tag~=nil then
        if #tag.paths>0 then
            local function asyncCallBack()
                self:asyncLoadingCallBack()
            end

            for i,v in ipairs(tag.paths) do
                ccs.ArmatureDataManager:getInstance():addDataFromFileAsync(v,tag.headId,tag.bodyId,tag.weaponId,asyncCallBack)
            end
            self.asyncBeRunning = true
        else
            tag.finishCallBack()
            table.remove(self.asyncWaitList,1)
            self.asyncBeRunning=false

            print("error:runAsyncLoading asyncWaitList[1].paths is empty!")
        end
    end
end

--[[
--暂时废弃!!!!
--清楚资源缓存
function resManager:purgeCachedData()
    print("resManager purgeCachedData")
    for k,v in pairs(self.loadedList) do
        if not v.bForever then
            if v.ctype==e_fileType.json then
                self:removeJson(k)
            elseif v.ctype==e_fileType.plist then
                self:removePlist(k)
            elseif v.ctype==e_fileType.image then
                self:removeImage(k)
            end
        end
    end
end
]]

function resManager:onNodeEvent()
    if "cleanup" == event then --销毁回调
        if self.schedulerId then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerId)
        end
    end
end

function resManager:loopUpdate(dt)
    if self.preLoadedFileCount < self.preLoadTotalFileNum then
        local count = 0
        for i=#self.preWaitList,1,-1 do
            local v = self.preWaitList[i]
            self:loadOneFile(v.path,v.headId,v.bodyId,v.weaponId,v.bForever)
            count = count + 1
            table.remove(self.preWaitList)
            if count==c_preLoadPerFileNum then
                break
            end
        end
        --更新计数
        self.preLoadedFileCount = self.preLoadedFileCount + count
        self.preLoadingCallBack(self.preLoadedFileCount/self.preLoadTotalFileNum)
    end

    --运行异步加载
    self:runAsyncLoading()
end

function resManager:loadOneFile(path,headId,bodyId,weaponId,bForever)
    if bForever==nil then bForever = false end
    --lua里‘.’需要转移符‘%.’
    local startPos = FGUtilStringFindLast(path,"%.")
    if startPos then
        local str = string.sub(path,startPos)
        if str==".json" or str==".ExportJson" then
            self:loadJson(path,headId,bodyId,weaponId,bForever)    
        elseif str==".plist" then
            self:loadPlist(path,bForever)
        --elseif str==".png" or str==".jpg" or str==".ccz" then
        else
            self:loadImage(path,bForever)
        end
    else
        print("error: resManager:loadOneFile path is erro!! path=",path)
    end
end

function resManager:loadJson(path,headId,bodyId,weaponId,bForever)
    local fileKey = path.."_"..headId.."_"..bodyId.."_"..weaponId
    --if self.loadedList[fileKey]==nil then
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(path,headId,bodyId,weaponId)
        self.loadedList[fileKey] = {
            ctype = e_fileType.json,
            bForever = false,
        }
    --end
end

function resManager:removeJson(key)
    if self.loadedList[key]~=nil then
        ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(key)
        self.loadedList[key] = nil
        print("removeJson key=",key)
    end
end

function resManager:loadPlist(path,bForever)
    --if self.loadedList[path]==nil then
        cc.SpriteFrameCache:getInstance():addSpriteFramesWithFile(path)
        self.loadedList[path] = {
            ctype = e_fileType.plist,
            bForever = false,
        }
    --end
end

function resManager:removePlist(key)
    if self.loadedList[key]~=nil then
        cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile(key)
        self.loadedList[key] = nil
    end
end

function resManager:loadImage(path,bForever)
    --if self.loadedList[path]==nil then
        cc.TextureCache:getInstance():addImage(path)
        self.loadedList[path] = {
            ctype = e_fileType.image,
            bForever = false,
        }
    --end
end

function resManager:removeImage(key)
    if self.loadedList[key]~=nil then
        cc.TextureCache:getInstance():removeTextureForKey(key)
        self.loadedList[key] = nil
    end
end


return  resManager

