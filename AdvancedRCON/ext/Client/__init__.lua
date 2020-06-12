class 'TextChatModeration'

function TextChatModeration:__init()
	print("Initializing TextChatModeration")
	
	self:RegisterVars()
	
	self:RegisterEvents()
end

function TextChatModeration:RegisterVars()
	self.textChatModerationList = {  }
	self.textChatModerationMode = "free"
end

function TextChatModeration:RegisterEvents()
	Hooks:Install('ClientChatManager:IncomingMessage', 1, self, self.OnCreateChatMessage)
	NetEvents:Subscribe("Server:GetTextChatModerationList", function(args)
		self.textChatModerationList = args
	end)
	NetEvents:Subscribe("Server:AddPlayer", function(args)
		table.insert(self.textChatModerationList, args[1])
	end)
	NetEvents:Subscribe("Server:RemovePlayer", function(args)
		table.remove(self.textChatModerationList, args[1])
	end)
	NetEvents:Subscribe("Server:OverWritePlayer", function(args)
		self.textChatModerationList[args[1]] = args[2]
	end)
	NetEvents:Subscribe("Server:ClearList", function(args)
		self.textChatModerationList = { }
	end)
	NetEvents:Subscribe("Server:LoadList", function(args)
		self.textChatModerationList = args
	end)
	NetEvents:Subscribe("Server:TextChatModerationMode", function(args)
		self.textChatModerationMode = args[1]
	end)
end
		
function TextChatModeration:OnCreateChatMessage(hook, message, playerId, recipientMask, channelId, isSenderDead)
	isVoice = false
	isAdmin = false
	player = PlayerManager:GetPlayerById(playerId)
	for _,textChatModerationListPlayer in pairs(self.textChatModerationList) do
		if textChatModerationListPlayer == "muted:"..player.name and channelId~= 4 then
			hook:Return()
		elseif textChatModerationListPlayer == "admin:"..player.name and channelId~= 4 then
			isAdmin = true
			break
		elseif textChatModerationListPlayer == "voice:"..player.name and channelId~= 4 then
			isVoice = true
			break
		end
	end
	if self.textChatModerationMode == "moderated" then
		if isVoice == false and isAdmin == false then
			hook:Return()
		end
	elseif self.textChatModerationMode == "muted" then
		if isAdmin == false then
			hook:Return()
		end
	end
end

g_TextChatModeration = TextChatModeration()