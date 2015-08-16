local messageManager = require("message.messageManager"):getInstance()

--发送消息
function sendMessage(prot)
	messgaeManager:recMessage(prot)	
end

--发送使用物品消息
function sendUseItemMessage(roleId,itemId)
	print("=============使用物品")
	local prot = {}
	prot.type = Bag
	prot.roleId = roleId
	prot.itemId = itemId
	sendMessage(prot)
end

function sendAttackMessage(roleId,monsterId)
	print("============攻击")
	local prot = {}
	prot.type = Attack
	prot.roleId = roleId
	prot.monsterId = monsterId
	sendMessage(prot)
end

function sendDefenceMessage(roleId)
	print("============防御")
	local prot = {}
	prot.type = Defence
	prot.roleId = roleId
	sendMessage(prot)
end

function sendSkillMessage(roleId,,skillId)
	print("============释放技能")
	local prot = {}
	prot.type = Bag
	prot.roleId = roleId
	prot.monsterId = monsterId
	prot.skillId = skillId
	sendMessage(prot)
end