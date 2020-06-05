class 'MutingPlayers'

function MutingPlayers:__init()
	print("Initializing MutingPlayers")
	
	self:RegisterVars()
	
	self:RegisterEvents()
end

function MutingPlayers:RegisterVars()
	self.channelIds = { ["Admin"] = 4, ["All"] = 0, ["Team"] = 1, ["Squad"] = 2 }
	self.channelFound = false
	self.channelAlreadyMuted = false
	self.channelId = nil
	self.mutedPlayers = { }
	self.mutedChannels = { }
	self.playerFound = false
	self.playerAlreadyMuted = false
	self.playerId = nil
end

function MutingPlayers:RegisterEvents()
	Hooks:Install('ClientChatManager:IncomingMessage', 1, self, self.OnCreateChatMessage)
	local command = Console:Register('player', 'Muting Player.', function(args)
		self.playerId = nil
		for _,player in pairs(PlayerManager:GetPlayers()) do
			if player.name == args[1] then
				self.playerFound = true
				self.playerId = player.id
			end
		end
		if self.playerFound == true then
			self.playerFound = false
			for _,mutedPlayer in pairs(self.mutedPlayers) do
				if mutedPlayer == self.playerId then	
					self.playerAlreadyMuted = true
				end
			end
			if args[2] == "true" then
				if self.playerAlreadyMuted == false then
					table.insert(self.mutedPlayers, self.playerId)
					return ('Player '..args[1].. " muted.")
				elseif self.playerAlreadyMuted == true then
					self.playerAlreadyMuted = false
					return ('Player '..args[1].. " is already muted.")
				end
			elseif args[2] == "false" then
				if self.playerAlreadyMuted == true then
					for i,mutedPlayer in pairs(self.mutedPlayers) do
						if mutedPlayer == self.playerId then	
							table.remove(self.mutedPlayers, i)
						end
					end
					self.playerAlreadyMuted = false
					return ('Player '..args[1].. " is now unmuted.")
				elseif self.playerAlreadyMuted == false then
					return ('Player '..args[1].. " was not muted.")
				end
			else
				return ('<mute.player> <playerName> <true/false>')
			end
		else
			return ('Player '..args[1].. " not found.")
		end
	end)
	
	Hooks:Install('ClientChatManager:IncomingMessage', 1, self, self.OnCreateChatMessage)
	local commands = Console:Register('channel', 'Muting Channel.', function(args)
		self.channelId = nil
		for channelName,channelId in pairs(self.channelIds) do
			if channelName == args[1] then
				self.channelFound = true
				self.channelId = channelId
			end
		end
		if self.channelFound == true then
			self.channelFound = false
			for _,mutedChannel in pairs(self.mutedChannels) do
				if mutedChannel == self.channelId then	
					self.channelAlreadyMuted = true
				end
			end
			if args[2] == "true" then
				if self.channelAlreadyMuted == false then
					table.insert(self.mutedChannels, self.channelId)
					return ('Channel '..args[1].. " muted.")
				elseif self.channelAlreadyMuted == true then
					self.channelAlreadyMuted = false
					return ('Channel '..args[1].. " is already muted.")
				end
			elseif args[2] == "false" then
				if self.channelAlreadyMuted == true then
					for i,mutedChannel in pairs(self.mutedChannels) do
						if mutedChannel == self.channelId then	
							table.remove(self.mutedChannels, i)
						end
					end
					self.channelAlreadyMuted = false
					return ('Channel '..args[1].. " is now unmuted.")
				elseif self.channelAlreadyMuted == false then
					return ('Channel '..args[1].. " was not muted.")
				end
			else
				return ('<mute.channel> <channelName> <true/false>')
			end
		else
			return ('Channel '..args[1].. " not found.")
		end
	end)
end

function MutingPlayers:OnCreateChatMessage(hook, message, playerId, recipientMask, channelId, isSenderDead)
	for _,mutedPlayer in pairs(self.mutedPlayers) do
		if mutedPlayer == playerId then
			hook:Return()
		end
	end
	for _,mutedChannel in pairs(self.mutedChannels) do
		if mutedChannel == channelId then
			print("this line")
			hook:Return()
		end
	end
	
end


g_mutingPlayers = MutingPlayers()

