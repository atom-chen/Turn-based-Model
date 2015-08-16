local messgaeManager_ = nil

local messageManager = class("messagemanager",function()
	return cc.Node:create()
end)

function messageManager:getInstance()
	if messageManager_ == nil then
		messageManager_ = messageManager.new()
		messageManager_:retain() 
	end
	return messageManager_
end

function messageManager:ctor()
	--消息队列
	self.messageList = {}
	--消息监听者
	self.listenerList = {}
end

--分发消息
function messageManager:divMessage()
	for k,listener in pairs(self.listenerList) do
		listener:recMessage(prot)
	end
end
--接收消息
function messageManager:recMessage(prot)
	table.insert(self.messageList, prot)
end
--删除消息
function messageManager:deleteMessage()
	table.remove(self.messageList,1)
end
function messageManager:getMessageList()
	return self.messageList
end

return messageManager