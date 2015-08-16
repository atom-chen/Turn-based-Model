--怪物
local baseBio = require("bio.bio")
local monster = class("monster",baseBio)

function monster:ctor(x,y,id)
	self.super.ctor(self,x,y,id)
end

function monster:create(x,y,id)
	return monster.new(x,y,id)
end

return monster