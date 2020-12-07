local admins = {}

local confirmThisCommand = nil
local targetPlayer = nil
local p_Seconds = nil
local p_Minutes = nil
local chatDelay, chatMessage, chatTargetName = 0.0, nil, nil
local reason = nil

function string:split(sep)
	local sep, fields = sep or ":", {}
	local pattern = string.format("([^%s]+)", sep)
	self:gsub(pattern, function(c) fields[#fields+1] = c end)
	return fields
end

function findMatch(message, adminPlayer)
	for _,s_Player in pairs(PlayerManager:GetPlayers()) do
		if string.find(string.lower(s_Player.name), string.lower(message)) ~= nil then
			targetPlayer = s_Player.name
			break
		end
	end
	if targetPlayer ~= nil and targetPlayer == message then
		confirmed = true
		return targetPlayer, true
	elseif targetPlayer ~= nil then
		return targetPlayer, false
	else
		return nil, nil
	end
end

Events:Subscribe('GameAdmin:Player', function(playerName, abilitities)
	admins[playerName] = abilitities
end)

Events:Subscribe('GameAdmin:Clear', function()
	admins = {}
end)

Events:Subscribe('Player:Chat', function(player, recipientMask, message)
	if message == '' or player == nil then
		return
	end

	print('Chat: ' .. message)
	-- lowerkey the message
	message = message:lower()
	
	-- split the message into parts
	local s_Parts = message:split(' ')
	
	-- check if the first key is not a "!"
	if s_Parts[1]:sub(1,1) ~= "!" then
		return
	end
	-- only if it starts with "!" we go on
	
	-- return if the player is no admin
	if admins[player.name] == nil then
		chatDelay, chatMessage, chatTargetName = 0.3, "You are no admin.", player.name
		return
	end
	
	if s_Parts[1] == '!say' then
		local adminMessage = ""
		for i,part in pairs(s_Parts) do
			if i ~= 1 then
				adminMessage = adminMessage .. part .. " "
			end
		end
		chatDelay, chatMessage, chatTargetName = 0.3, adminMessage, nil
	end
	
	if s_Parts[1] == '!yell' then
		local adminMessage = ""
		for i,part in pairs(s_Parts) do
			if i ~= 1 then
				adminMessage = adminMessage .. part .. " "
			end
		end
		local duration = 5
		if tonumber(s_Parts[#s_Parts]) ~= nil then
			duration = tonumber(s_Parts[#s_Parts])
		end
		ChatManager:Yell(adminMessage, duration)
	end
	
	if s_Parts[1] == '!restart' then
		if admins[player.name].canUseMapFunctions == nil or admins[player.name].canUseMapFunctions == false then
			chatDelay, chatMessage, chatTargetName = 0.3, "You can't use !restart.", player.name
			return
		end
		RCON:SendCommand('mapList.restartRound')
	end
	
	if s_Parts[1] == '!nextlevel' then
		if admins[player.name].canUseMapFunctions == nil or admins[player.name].canUseMapFunctions == false then
			chatDelay, chatMessage, chatTargetName = 0.3, "You can't use !restart.", player.name
			return
		end
		RCON:SendCommand('mapList.runNextRound')
	end
	
	if s_Parts[1] == '!endround' then
		if admins[player.name].canUseMapFunctions == nil or admins[player.name].canUseMapFunctions == false then
			chatDelay, chatMessage, chatTargetName = 0.3, "You can't use !restart.", player.name
			return
		end
		if s_Parts[2] == nil then
			chatDelay, chatMessage, chatTargetName = 0.3, "You need to define the winning team ID.", player.name
		end
		if s_Parts[2] == "1" then
			RCON:SendCommand('mapList.endRound', {"1"})
		elseif s_Parts[2] == "2" then
			RCON:SendCommand('mapList.endRound', {"2"})
		elseif s_Parts[2] == "3" and SharedUtils:GetCurrentGameMode() == "SquadDeathMatch0" then
			RCON:SendCommand('mapList.endRound', {"3"})
		elseif s_Parts[2] == "4" and SharedUtils:GetCurrentGameMode() == "SquadDeathMatch0" then
			RCON:SendCommand('mapList.endRound', {"4"})
		else
			chatDelay, chatMessage, chatTargetName = 0.3, "You defined an invalid team ID.", player.name
		end
	end
	
	if s_Parts[1] == '!kill' then
		if admins[player.name].canKillPlayers == nil or admins[player.name].canKillPlayers == false then
			chatDelay, chatMessage, chatTargetName = 0.3, "You can't kill players.", player.name
			return
		end
		targetPlayer, confirmed = findMatch(s_Parts[2], player)
		if targetPlayer ~= nil then
			if s_Parts[3] ~= nil then
				reason = ""
				for i=3, #s_Parts do
					reason = reason .. s_Parts[i] .. " "
				end
			else
				reason = nil
			end
			if confirmed == false then
				confirmThisCommand = "kill"
				chatDelay, chatMessage, chatTargetName = 0.3, "Did you mean " .. targetPlayer .. "?", player.name
			else	
				Kill(player.name)
			end
		else
			chatDelay, chatMessage, chatTargetName = 0.3, "No matching player found.", player.name
		end
	end
	
	if s_Parts[1] == '!kick' then
		if admins[player.name].canKickPlayers == nil or admins[player.name].canKickPlayers == false then
			chatDelay, chatMessage, chatTargetName = 0.3, "You can't kick players.", player.name
			return
		end
		targetPlayer, confirmed = findMatch(s_Parts[2], player)
		if targetPlayer ~= nil then
			if s_Parts[3] ~= nil then
				reason = ""
				for i=3, #s_Parts do
					reason = reason .. s_Parts[i] .. " "
				end
			else
				reason = nil
			end
			if confirmed == false then
				confirmThisCommand = "kick"
				chatDelay, chatMessage, chatTargetName = 0.3, "Did you mean " .. targetPlayer .. "?", player.name
			else	
				Kick(player.name)
			end
		else
			chatDelay, chatMessage, chatTargetName = 0.3, "No matching player found.", player.name
		end
	end
	
	if s_Parts[1] == '!tban' then
		if admins[player.name].canTemporaryBanPlayers == nil or admins[player.name].canTemporaryBanPlayers == false then
			chatDelay, chatMessage, chatTargetName = 0.3, "You can't tban players.", player.name
			return
		end
		if tonumber(s_Parts[3]) == nil then
			chatDelay, chatMessage, chatTargetName = 0.3, "You need to define a ban duration in minutes.", player.name
			return
		end
		targetPlayer, confirmed = findMatch(s_Parts[2], player)
		if targetPlayer ~= nil then
			p_Seconds = s_Parts[3] * 60
			p_Minutes = s_Parts[3]
			if s_Parts[4] ~= nil then
				reason = ""
				for i=4, #s_Parts do
					reason = reason .. s_Parts[i] .. " "
				end
			else
				reason = nil
			end
			if confirmed == false then
				confirmThisCommand = "tban"
				chatDelay, chatMessage, chatTargetName = 0.3, "Did you mean " .. targetPlayer .. "?", player.name
			else	
				Tban(player.name)
			end
		else
			chatDelay, chatMessage, chatTargetName = 0.3, "No matching player found.", player.name
		end
	end

	if s_Parts[1] == '!ban' then
		if admins[player.name].canPermanentlyBanPlayers == nil or admins[player.name].canPermanentlyBanPlayers == false then
			chatDelay, chatMessage, chatTargetName = 0.3, "You can't ban players.", player.name
			return
		end
		targetPlayer, confirmed = findMatch(s_Parts[2], player)
		if targetPlayer ~= nil then
			if s_Parts[3] ~= nil then
				reason = ""
				for i=3, #s_Parts do
					reason = reason .. s_Parts[i] .. " "
				end
			else
				reason = nil
			end
			if confirmed == false then
				confirmThisCommand = "ban"
				chatDelay, chatMessage, chatTargetName = 0.3, "Did you mean " .. targetPlayer .. "?", player.name
			else	
				Ban(player.name)
			end
		else
			chatDelay, chatMessage, chatTargetName = 0.3, "No matching player found.", player.name
		end
	end
	
	if s_Parts[1] == '!fmove' or s_Parts[1] == '!move' then
		if admins[player.name].canMovePlayers == nil or admins[player.name].canMovePlayers == false then
			chatDelay, chatMessage, chatTargetName = 0.3, "You can't force move players.", player.name
			return
		end
		targetPlayer, confirmed = findMatch(s_Parts[2], player)
		if targetPlayer ~= nil then
			if s_Parts[3] ~= nil then
				reason = ""
				for i=3, #s_Parts do
					reason = reason .. s_Parts[i] .. " "
				end
			else
				reason = nil
			end
			if confirmed == false then
				confirmThisCommand = "fmove"
				chatDelay, chatMessage, chatTargetName = 0.3, "Did you mean " .. targetPlayer .. "?", player.name
			else	
				Fmove(player.name)
			end
		else
			chatDelay, chatMessage, chatTargetName = 0.3, "No matching player found.", player.name
		end
	end
	
	if s_Parts[1] == '!yes' and targetPlayer ~= nil and confirmThisCommand ~= nil then
		if confirmThisCommand == "kill" then
			if admins[player.name].canKillPlayers == nil or admins[player.name].canKillPlayers == false then
				chatDelay, chatMessage, chatTargetName = 0.3, "You can't kill players.", player.name
				return
			end
			Kill(player.name)
		elseif confirmThisCommand == "kick" then
			if admins[player.name].canKickPlayers == nil or admins[player.name].canKickPlayers == false then
				chatDelay, chatMessage, chatTargetName = 0.3, "You can't kick players.", player.name
				return
			end
			Kick(player.name)
		elseif confirmThisCommand == "tban" then
			if admins[player.name].canTemporaryBanPlayers == nil or admins[player.name].canTemporaryBanPlayers == false then
				chatDelay, chatMessage, chatTargetName = 0.3, "You can't tban players.", player.name
				return
			end
			Tban(player.name)
		elseif confirmThisCommand == "ban" then
			if admins[player.name].canPermanentlyBanPlayers == nil or admins[player.name].canPermanentlyBanPlayers == false then
				chatDelay, chatMessage, chatTargetName = 0.3, "You can't ban players.", player.name
				return
			end
			Ban(player.name)
		elseif confirmThisCommand == "fmove" then
			if admins[player.name].canMovePlayers == nil or admins[player.name].canMovePlayers == false then
				chatDelay, chatMessage, chatTargetName = 0.3, "You can't force move players.", player.name
				return
			end
			Fmove(player.name)
		end
	end
end)

Events:Subscribe('Engine:Update', function(deltaTime, simulationDeltaTime)
	if 0.0 < chatDelay then
		chatDelay = chatDelay - deltaTime
		if chatDelay < 0.0 then
			if chatTargetName ~= nil then
				ChatManager:SendMessage(chatMessage, PlayerManager:GetPlayerByName(chatTargetName))
			else
				ChatManager:SendMessage(chatMessage)
			end
		end
	end
end)

function Kill(admin)
	local success = false
	if targetPlayer ~= nil then
		targetPlayer = PlayerManager:GetPlayerByName(targetPlayer)
	end
	if targetPlayer == nil then
		chatDelay, chatMessage, chatTargetName = 0.3, "No matching player found.", admin
		return
	end
	if targetPlayer.soldier ~= nil then 
		success = true
		RCON:SendCommand("admin.killPlayer", {targetPlayer.name})
		--targetPlayer.soldier:ForceDead()
	elseif targetPlayer.corpse ~= nil and targetPlayer.corpse.isDead == false then
		success = true
		targetPlayer.corpse:ForceDead()
	else
		chatDelay, chatMessage, chatTargetName = 0.3, "Player is already dead.", admin
	end
	if success == true then
		chatDelay, chatMessage, chatTargetName = 0.3, targetPlayer.name .. " got killed.", admin
		if reason == nil then
			ChatManager:SendMessage("You got killed by " .. admin .. ".", targetPlayer)
		else
			ChatManager:SendMessage("You got killed by " .. admin .. " for: " .. reason, targetPlayer)
			reason = nil
		end
	end
	targetPlayer = nil
	confirmed = nil
	confirmThisCommand = nil
end

function Kick(admin)
	local success = false
	if targetPlayer ~= nil then
		targetPlayer = PlayerManager:GetPlayerByName(targetPlayer)
	end
	if targetPlayer == nil then
		chatDelay, chatMessage, chatTargetName = 0.3, "No matching player found.", admin
		return
	end
	if reason == nil then
		targetPlayer:Kick()
	else
		targetPlayer:Kick(reason)
		reason = nil
	end
	chatDelay, chatMessage, chatTargetName = 0.3, targetPlayer.name .. " got kicked.", admin
	
	targetPlayer = nil
	confirmed = nil
	confirmThisCommand = nil
end

function Tban(admin)
	local success = false
	if targetPlayer ~= nil then
		targetPlayer = PlayerManager:GetPlayerByName(targetPlayer)
	end
	if targetPlayer == nil then
		chatDelay, chatMessage, chatTargetName = 0.3, "No matching player found.", admin
		return
	end
	if reason == nil then
		targetPlayer:BanTemporarily(p_Seconds)
	else
		targetPlayer:BanTemporarily(p_Seconds, reason)
		reason = nil
	end
	chatDelay, chatMessage, chatTargetName = 0.3, targetPlayer.name .. " got temporarily banned for " .. p_Minutes .. " Minutes.", admin
	
	targetPlayer = nil
	confirmed = nil
	confirmThisCommand = nil
	
	p_Seconds = nil
	p_Minutes = nil
end

function Ban(admin)
	local success = false
	if targetPlayer ~= nil then
		targetPlayer = PlayerManager:GetPlayerByName(targetPlayer)
	end
	if targetPlayer == nil then
		chatDelay, chatMessage, chatTargetName = 0.3, "No matching player found.", admin
		return
	end
	if reason == nil then
		targetPlayer:Ban()
	else
		targetPlayer:Ban(reason)
		reason = nil
	end
	chatDelay, chatMessage, chatTargetName = 0.3, targetPlayer.name .. " got banned.", admin
	
	targetPlayer = nil
	confirmed = nil
	confirmThisCommand = nil
end

function Fmove(admin)
	local success = false
	if targetPlayer ~= nil then
		targetPlayer = PlayerManager:GetPlayerByName(targetPlayer)
	end
	if targetPlayer == nil then
		chatDelay, chatMessage, chatTargetName = 0.3, "No matching player found.", admin
		return
	end
	if SharedUtils:GetCurrentGameMode() ~= "SquadDeathMatch0" then
		if targetPlayer.teamId == 1 then
			RCON:SendCommand("admin.movePlayer", {targetPlayer.name, "2", "1", "true"})
			chatDelay, chatMessage, chatTargetName = 0.3, targetPlayer.name .. " got moved to RU.", admin
			if reason == nil then
				ChatManager:SendMessage("You got moved to RU by " .. admin .. ".", targetPlayer)
			else
				ChatManager:SendMessage("You got moved to RU by " .. admin .. " for: " .. reason, targetPlayer)
				reason = nil
			end
		else
			RCON:SendCommand("admin.movePlayer", {targetPlayer.name, "1", "1", "true"})
			chatDelay, chatMessage, chatTargetName = 0.3, targetPlayer.name .. " got moved to US.", admin
			if reason == nil then
				ChatManager:SendMessage("You got moved to US by " .. admin .. ".", targetPlayer)
			else
				ChatManager:SendMessage("You got moved to US by " .. admin .. " for: " .. reason, targetPlayer)
				reason = nil
			end
		end
	else
		if targetPlayer.teamId == 1 then
			RCON:SendCommand("admin.movePlayer", {targetPlayer.name, "2", "1", "true"})
			chatDelay, chatMessage, chatTargetName = 0.3, targetPlayer.name .. " got moved to Bravo.", admin
			if reason == nil then
				ChatManager:SendMessage("You got moved to Bravo by " .. admin .. ".", targetPlayer)
			else
				ChatManager:SendMessage("You got moved to Bravo by " .. admin .. " for: " .. reason, targetPlayer)
				reason = nil
			end
		elseif targetPlayer.teamId == 2 then
			RCON:SendCommand("admin.movePlayer", {targetPlayer.name, "3", "1", "true"})
			chatDelay, chatMessage, chatTargetName = 0.3, targetPlayer.name .. " got moved to Charlie.", admin
			if reason == nil then
				ChatManager:SendMessage("You got moved to Charlie by " .. admin .. ".", targetPlayer)
			else
				ChatManager:SendMessage("You got moved to Charlie by " .. admin .. " for: " .. reason, targetPlayer)
				reason = nil
			end
		elseif targetPlayer.teamId == 3 then
			RCON:SendCommand("admin.movePlayer", {targetPlayer.name, "4", "1", "true"})
			chatDelay, chatMessage, chatTargetName = 0.3, targetPlayer.name .. " got moved to Delta.", admin
			if reason == nil then
				ChatManager:SendMessage("You got moved to Delta by " .. admin .. ".", targetPlayer)
			else
				ChatManager:SendMessage("You got moved to Delta by " .. admin .. " for: " .. reason, targetPlayer)
				reason = nil
			end
		elseif targetPlayer.teamId == 4 then
			RCON:SendCommand("admin.movePlayer", {targetPlayer.name, "1", "1", "true"})
			chatDelay, chatMessage, chatTargetName = 0.3, targetPlayer.name .. " got moved to Alpha.", admin
			if reason == nil then
				ChatManager:SendMessage("You got moved to Alpha by " .. admin .. ".", targetPlayer)
			else
				ChatManager:SendMessage("You got moved to Alpha by " .. admin .. " for: " .. reason, targetPlayer)
				reason = nil
			end
		end
	end
	
	targetPlayer = nil
	confirmed = nil
	confirmThisCommand = nil
end