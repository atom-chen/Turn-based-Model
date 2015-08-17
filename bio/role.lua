--怪物
local baseBio = require("bio.bio")
local role = class("role",baseBio)
require("dataUse.animationDataUse")
function role:ctor(x,y,id)
	self.super.ctor(self,x,y,id)
	self.curAction = nil             --当前动作
end

function role:create(x,y,id)
	return role.new(x,y,id)
end

function  role:behit()
	-- body
end

function  role:normalAttack()
	-- body
end

function role:skillEnemy()
	-- body
end
function role:skillFriend()
	-- body
end

function role:defence()
	-- body
end

return role