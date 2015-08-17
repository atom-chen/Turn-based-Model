--怪物
local baseBio = require("bio.bio")
local role = class("role",baseBio)
require("dataUse.animationDataUse")
function role:ctor(x,y,id)
	print("=========角色构造")
	self.super.ctor(self,x,y,id)
	self.curAction = nil             --当前动作
	self:setScale(0.8)
	--根据角色id去初始化
	self:setTexture("icon/role/head_role1.png")
	self:setPosition(cc.p(x,y))
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

--角色受伤震屏
function role:beHitShow()
	--local action = cc.MoveBy:create(0.1,cc.p(0,20))\
	local action = cc.ScaleTo:create(0.1,0.5)
	local moveBack = cc.ScaleTo:create(0.1,1)
	local seq = cc.Sequence:create(action,moveBack)
	self:runAction(cc.RepeatForever:create(seq))

	-- local action_ = cc.MoveBy:create(0.1,cc.p(0,100))
	-- --local action = cc.ScaleTo:create(0.1,0.5)
	-- local moveBack_ = action_:reverse()
	-- local seq_ = cc.Sequence:create(action_,moveBack_)
	-- self:runAction(cc.RepeatForever:create(seq_))
end

return role