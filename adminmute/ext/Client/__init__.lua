class 'AdminMuting'

function AdminMuting:__init()
	print("Initializing Admin Muting")
	
	self:RegisterVars()
	
	self:RegisterEvents()
end

function AdminMuting:RegisterVars()
	self.mutedPlayers = { }
	self.playerFound = false
	self.playerAlreadyMuted = false
	self.playerName = nil
	self.isAdmin = false
	self.admins = {"voteban_flash", "Flash_Hit"}

	for _,admin in pairs(self.admins) do
		if PlayerManager:GetLocalPlayer().name == admin then
			self.isAdmin = true
		end
	end
end

function AdminMuting:RegisterEvents()
	Hooks:Install('ClientChatManager:IncomingMessage', 1, self, self.OnCreateChatMessage)
	NetEvents:Subscribe("Server:GetMutedPlayers", function(args)
		print(args[1])
		self.mutedPlayers = args
		print(self.mutedPlayers[1])
	end)
	if self.isAdmin == true then
		local admincommand = Console:Register('player', 'Admin Muting Player.', function(args)
			self.playerName = nil
			for _,player in pairs(PlayerManager:GetPlayers()) do
				if player.name == args[1] then
					self.playerFound = true
					self.playerName = player.name
				end
			end
			if self.playerFound == true then
				self.playerFound = false
				for _,mutedPlayer in pairs(self.mutedPlayers) do
					if mutedPlayer == self.playerName then	
						self.playerAlreadyMuted = true
					end
				end
				if args[2] == "true" then
					if self.playerAlreadyMuted == false then
						local sendMuting = { }
						table.insert(sendMuting, self.playerName)
						NetEvents:Send("Mute:Player", sendMuting)
						return ('Player '..args[1].. " muted.")
					elseif self.playerAlreadyMuted == true then
						self.playerAlreadyMuted = false
						return ('Player '..args[1].. " is already muted.")
					end
				elseif args[2] == "false" then
					if self.playerAlreadyMuted == true then
						for i,mutedPlayer in pairs(self.mutedPlayers) do
							if mutedPlayer == self.playerName then
								sendUnmuting = {}
								sendUnmuting[1] = i
								sendUnmuting[2] = mutedPlayer
								NetEvents:Send("Unmute:Player", sendUnmuting)
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
		local thelist = Console:Register('list', 'Lists muted players.', function(args)
			for _,i in pairs(self.mutedPlayers) do
				return (i)
			end
		end)
	end
		
	NetEvents:Subscribe("Server:MutePlayer", function(args)
		table.insert(self.mutedPlayers, args[1])
	end)
	NetEvents:Subscribe("Server:UnmutePlayer", function(args)
		table.remove(self.mutedPlayers, args[1])
	end)
end
		
function AdminMuting:OnCreateChatMessage(hook, message, playerId, recipientMask, channelId, isSenderDead)
	player = PlayerManager:GetPlayerById(playerId)
	for _,mutedPlayer in pairs(self.mutedPlayers) do
		if mutedPlayer == player.name and channelId~= 4 then
			hook:Return()
		end
	end
end

g_AdminMuting = AdminMuting()
