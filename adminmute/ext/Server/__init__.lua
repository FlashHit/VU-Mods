class 'AdminMuting'
function AdminMuting:__init()
	print("Initializing Admin Muting")
	NetEvents:Subscribe("Mute:Player", player, self.OnMutePlayer)
	NetEvents:Subscribe("Unmute:Player", player, self.OnUnmutePlayer)
end

function AdminMuting:OnMutePlayer(player, args)
	print("redirect to mute this player:".. args[1])
	ChatManager:SendMessage("You are muted now.", PlayerManager:GetPlayerById(args[1]))
	NetEvents:Broadcast("Server:MutePlayer", args)
end

function AdminMuting:OnUnmutePlayer(player, args)
	print("redirect to unmute this player:"..args[2])
	ChatManager:SendMessage("You are unmuted now.", PlayerManager:GetPlayerById(args[2]))
	NetEvents:Broadcast("Server:UnmutePlayer", args)
end

g_AdminMuting = AdminMuting()