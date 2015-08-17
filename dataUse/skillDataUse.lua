--动作数据接口
require("staticData.skill")

skillDataUse = 
{
	getSkillName 			= nil,	    	--获取技能名
	getSkillData	 		= nil,			--获取角色技能数据
	getSkillAnimation   	= nil,			--获取技能动画的文件 执行帧
}

skillDataUse.getSkillData = function(id)
	if id < 5000 or id > 6000 or id == nil then
		print("=========技能id错误",id)
		return 
	end
	return skill[id]
end

skillDataUse.getSkillAnimation = function(id)
	local skillData = skillDataUse.getSkillData(id)
	return skillData.filename,skillData.frame[1],skillData.frame[2]
end
skillDataUse.getSkillName = function(id)
	local skillData = skillDataUse.getSkillData(id)
	return skillData.name
end