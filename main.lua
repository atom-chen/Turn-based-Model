
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")

require "config"
require "cocos.init"

local function main()
 
 	require("config.config")
	require("public.public")

	cc.Director:getInstance():setDisplayStats(true)

	cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(960, 640, 1)
   	
   	local layer = require("GameScene"):create()
    local sceneGame =  cc.Scene:create()
    sceneGame:addChild(layer)  

   	if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(sceneGame)
    else  
        cc.Director:getInstance():runWithScene(sceneGame) 
    end 

end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
