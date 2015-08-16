local gameDataManager_ = nil

local gameDataManager = class("gameDataManager",function()
	return cc.Node:create()
end)

function gameDataManager:getInstance()
	if gameDataManager_ == nil then
		gameDataManager_ = gameDataManager.new() 
		gameDataManager_:retain()
	end
	return gameDataManager_
end

function gameDataManager:ctor()
	
end
--获取主角信息

--获取背包信息

--获取剧情信息

--获取出生点

--获取

return gameDataManager
