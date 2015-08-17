--怪物普通攻击 释放技能 被攻击 死亡 站立 动作
animation =
{
	--[[
		bioAction = 
			{
				die     = 1 ,
			    behit   = 2 ,
			    attack  = 3 ,
			    skill   = 4 ,
			    stand   = 5 ,
			    defence = 6 ,
			}
	]]
	animation = 
	{
		[2001] = 
		{
			name = "",
			filename = "boss_.csb",
			action = {
						[bioAction.die] = {0,21},
						[bioAction.behit] = {30,61},
						[bioAction.attack] = {70,131},
						[bioAction.skill]  = {140,201},
						[bioAction.stand]  = {210,241},
						[bioAction.defence] = {}
					},
			-- die = {1,3},
			-- behit = {2,4},
			-- attck = {3,7},
			-- skill = {4,7},
			-- stand = {5，4},
		}
	}
}