
local _sceneManager = nil

local sceneManager = class("sceneManager",function()
	return cc.Node:create()
end)

function sceneManager:getInstance()
	if _sceneManager == nil then
		_sceneManager = sceneManager.new()
		_sceneManager:retain()
	end
	return _sceneManager
end

function sceneManager:ctor()
	--当前场景
	self.activeScene = nil

end

function sceneManager:getCurActiveScene()
	return self.activeScene
end

function sceneManager:setCurActiveScene(curScene)
	self.activeScene = curScene
end
--获取场景各个层     
--[[
	Distant_Layer = 100,    --远景层
    Near_Layer    = 200     --近景层
    MainUI_Layer  = 300,	--主ui层
    SubUI_Layer   = 400,	--副ui层           
    Gesture_Layer = 500,    --操作层
    MsgBox_Layer  = 600,    --弹出框层
    MsgText_Layer = 700,    --飘字层
]]
function sceneManager:getlayer(index)
	print("==========获取层",index)
	if self.activeScene == nil then
		return nil
	end
	local layer = nil
	if index == 1 then
		layer = self.activeScene:getDistantLayer()
	elseif index == 2 then
		layer = self.activeScene:getNearLayer()
	elseif index == 3 then
		layer = self.activeScene:getMainUILayer()
	elseif index == 4 then
		layer = self.activeScene:getSubUILayer()
	elseif index == 5 then
		layer = self.activeScene:getGestureLayer()
	elseif index == 6 then
		layer = self.activeScene:getPopLayer()
	elseif index == 7 then
		layer = self.activeScene:getFloatLayer()
	end
	return layer
end

--切换场景
function sceneManager:loadScene(sceneId)
	--主城1
	if sceneId == CityScene_1 then
		self.activeScene = require("scene.cityScene"):create()
		self:replaceScene(self.activeScene)
		--self:loadSceneResource(CityScene_1)
		--self:createControlLayer()
	elseif sceneId == FightScene_1 then
		self.activeScene = require("scene.fightScene"):create()
		self:replaceScene(self.activeScene)
		--self:loadSceneResource(CityScene_1)
		--self:createControlLayer()
	end
end

--加载控制层
function sceneManager:createControlLayer()
	if self.controlLayer == nil then
		self.controlLayer = require("control.controlLayer"):create()
	end
	local controlLayer = self.activeScene:GetGestureLayer()
	controlLayer:addChild(self.controlLayer)
end

--缓冲资源
function sceneManager:loadSceneResource(sceneId)
	local preLoadingScene = require("preLoading.preLoadScene"):create()
	self:replaceScene(preLoadingScene)
end

--场景切换
function sceneManager:replaceScene(scene)
    -- 更换场景
    if cc.Director:getInstance():getRunningScene() then 
        cc.Director:getInstance():getRunningScene():removeAllChildren()
        cc.Director:getInstance():replaceScene(scene)
    else
        cc.Director:getInstance():runWithScene(scene)
    end
end

function sceneManager:create()
end

return sceneManager