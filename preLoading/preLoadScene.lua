
local SceneClass = require("scene.baseScene")

local preLoadingScene = class("preLoading",SceneClass)

function preLoadingScene:create()
    local scene = preLoadingScene.new()
    return scene
end

function preLoadingScene:ctor()
    self.super.ctor(self)
    self.promptLabel = nil
    self:createUI()
end

function preLoadingScene:createUI()
    self.promptLabel = cc.Label:createWithSystemFont("资源读取:0%","Helvetica",30)
	self.promptLabel:setPosition(480,320)

    self:GetWinUILayer():addChild(self.promptLabel)
end

function preLoadingScene:updateUI(percent)
    if self.promptLabel then
        local prompt = string.format("资源读取:%d%%",100*percent)
        self.promptLabel:setString(prompt)
    end
end

return preLoadingScene