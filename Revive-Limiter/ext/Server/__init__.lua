class 'ReviveLimiter'

function ReviveLimiter:__init()
	print("Initializing ReviveLimiter")
	NetEvents:Subscribe("Player:ForceDead", player, self.OnForceDead)
end

function ReviveLimiter:OnForceDead(player)
	player.corpse:ForceDead()
end

g_reviveLimiter = ReviveLimiter()
