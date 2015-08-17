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

function sendSkillMessage(roleId,skillId)
	print("============释放技能")
	local prot = {}
	prot.type = Bag
	prot.roleId = roleId
	prot.monsterId = monsterId
	prot.skillId = skillId
	sendMessage(prot)
end

--播放一次性动画
function playAniamationOnce(target,fileName,startFrame,endFrame,callback,x,y,isRemove_)
	local isRemove = true
	if not isRemove_ then
		isRemove = false
	end
	print("=============fileName",fileName)
	print("--------------s e frame",startFrame,endFrame)
	local node = cc.CSLoader:createNode(fileName)
    local action = cc.CSLoader:createTimeline(fileName)
    node:runAction(action)
    action:gotoFrameAndPlay(startFrame,endFrame,false)

    node:setPosition(x,y)
    target:addChild(node)
    
	print("===============callback1")
	local function onFrameEvent(frame)
		print("===============callback2")
		if isRemove then
			node:removeFromParent()
		end
		if callback ~= nil then
			callback()
		end
    	
	end
	action:setFrameEventCallFunc(onFrameEvent)
     
end

--播放永久性动画
function playAniamationForever(target,fileName,startFrame,endFrame,x,y)
	print("=============fileName",fileName)
	print("--------------s e frame",startFrame,endFrame)
	local node = cc.CSLoader:createNode(fileName)
    local action = cc.CSLoader:createTimeline(fileName)
    node:runAction(action)
    action:gotoFrameAndPlay(startFrame,endFrame,true)
    node:setPosition(x,y)
    target:addChild(node)
    return node
end