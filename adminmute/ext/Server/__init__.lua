class 'AdminMute'

function AdminMute:__init()
	print("Initializing Admin Muting")
	
	self:RegisterVars()
	
	self:RegisterEvents()
end

function AdminMute:RegisterVars()
	self.mutedPlayers = { }

end

function AdminMute:RegisterEvents()
	Events:Subscribe('Player:Authenticated', function(player)
		NetEvents:Broadcast("Server:GetMutedPlayers", self.mutedPlayers)
	end)
	
	NetEvents:Subscribe("Mute:Player", function(player, args)
		table.insert(self.mutedPlayers, args[1])
		ChatManager:SendMessage("You got muted by admin.", PlayerManager:GetPlayerByName(args[1]))
		NetEvents:Broadcast("Server:MutePlayer", args)
	end)
	NetEvents:Subscribe("Unmute:Player", function(player, args)
		table.remove(self.mutedPlayers, args[1])
		ChatManager:SendMessage("You got unmuted.", PlayerManager:GetPlayerByName(args[2]))
		NetEvents:Broadcast("Server:UnmutePlayer", args)
	end)
end

g_AdminMute = AdminMute()
