class 'AdvancedRCON'

function AdvancedRCON:__init()
	print("Initializing AdvancedRCON")
	self:RegisterVars()
	self:RegisterEvents()
	self:RegisterCommands()
end

function string:split(sep)
   local sep, fields = sep or " ", {}
   local pattern = string.format("([^%s]+)", sep)
   self:gsub(pattern, function(c) fields[#fields+1] = c end)
   return fields
end

function AdvancedRCON:RegisterVars()

	self.recipientMask = "none"
	self.team = "none"
	self.squad = "none"
	
	self.textChatModerationList = { }
	self.playerFound = false
	self.playerAlreadyMuted = false
	self.playerAlreadyAdmin = false
	self.playerAlreadyVoice = false
	self.playerAlreadyInList = false
	self.playerName = nil
	self.textChatModerationMode = "free"
	self.index = nil
	self.chatSettings = nil
	
	self.eventHandles = {} 
	
	self.eventNames = {
		["onRevive"] = "Player:ManDownRevived",
		["onLevelLoaded"] = "Level:Loaded",
		["onCapture"] = "CapturePoint:Captured",
		["onCapturePointLost"] = "CapturePoint:Lost",
		["onEngineInit"] = "Engine:Init",
		["onAuthenticated"] = "Player:Authenticated",
		["onChangingWeapon"] = "Player:ChangingWeapon",
		["onChat"] = "Player:Chat",
		["onCreated"] = "Player:Created",
		["onDestroyed"] = "Player:Destroyed",
		["onEnteredCapturePoint"] = "Player:EnteredCapturePoint",
		["onInstantSuicide"] = "Player:InstantSuicide",
		["onJoining"] = "Player:Joining",
		["onKickedFromSquad"] = "Player:KickedFromSquad",
		["onKilled"] = "Player:Killed",
		["onKitPickup"] = "Player:KitPickup",
		["onLeft"] = "Player:Left",
		["onReload"] = "Player:Reload",
		["onRespawn"] = "Player:Respawn",
		["onResupply"] = "Player:Resupply",
		["onReviveAccepted"] = "Player:ReviveAccepted",
		["onReviveRefused"] = "Player:ReviveRefused",
		["onSetSquad"] = "Player:SetSquad",
		["onSetSquadLeader"] = "Player:SetSquadLeader",
		["onSpawnAtVehicle"] = "Player:SpawnAtVehicle",
		["onSpawnOnPlayer"] = "Player:SpawnOnPlayer",
		["onSpawnOnSelectedSpawnPoint"] = "Player:SpawnOnSelectedSpawnPoint",
		["onSquadChange"] = "Player:SquadChange",
		["onSuppressedEnemy"] = "Player:SuppressedEnemy",
		["onTeamChange"] = "Player:TeamChange",
		["onUpdate"] = "Player:Update",
		["onUpdateInput"] = "Player:UpdateInput",
		["onRoundOver"] = "Server:RoundOver",
		["onRoundReset"] = "Server:RoundReset",
		["onHealthAction"] = "Soldier:HealthAction",
		["onManDown"] = "Soldier:ManDown",
		["onPrePhysicsUpdate"] = "Soldier:PrePhysicsUpdate",
		["onDamage"] = "Vehicle:Damage",
		["onVehicleDestroyed"] = "Vehicle:Destroyed",
		["onDisabled"] = "Vehicle:Disabled",
		["onEnter"] = "Vehicle:Enter",
		["onExit"] = "Vehicle:Exit",
		["onSpawnDone"] = "Vehicle:SpawnDone",
		["onUnspawn"] = "Vehicle:Unspawn"
	}
	
	self.eventFunctions = {
		["Player:ManDownRevived"] = self.OnRevive,
		["Level:Loaded"] = self.OnLevelLoadedVU,
		["CapturePoint:Captured"] = self.OnCapture,
		["CapturePoint:Lost"] = self.OnCapturePointLost,
		["Engine:Init"] = self.OnEngineInit,
		["Player:Authenticated"] = self.OnPlayerAuthenticated,
		["Player:ChangingWeapon"] = self.OnPlayerChangingWeapon,
		["Player:Chat"] = self.OnChat,
		["Player:Created"] = self.OnCreated,
		["Player:Destroyed"] = self.OnDestroyed,
		["Player:EnteredCapturePoint"] = self.OnEnteredCapturePoint,
		["Player:InstantSuicide"] = self.OnInstantSuicide,
		["Player:Joining"] = self.OnJoining,
		["Player:KickedFromSquad"] = self.OnKickedFromSquad,
		["Player:Killed"] = self.OnKilled,
		["Player:KitPickup"] = self.OnKitPickup,
		["Player:Left"] = self.OnLeft,
		["Player:Reload"] = self.OnReload,
		["Player:Respawn"] = self.OnRespawn,
		["Player:Resupply"] = self.OnResupply,
		["Player:ReviveAccepted"] = self.OnReviveAccepted,
		["Player:ReviveRefused"] = self.OnReviveRefused,
		["Player:SetSquad"] = self.OnSetSquad,
		["Player:SetSquadLeader"] = self.OnSetSquadLeader,
		["Player:SpawnAtVehicle"] = self.OnSpawnAtVehicle,
		["Player:SpawnOnPlayer"] = self.OnSpawnOnPlayer,
		["Player:SpawnOnSelectedSpawnPoint"] = self.OnSpawnOnSelectedSpawnPoint,
		["Player:SquadChange"] = self.OnSquadChange,
		["Player:SuppressedEnemy"] = self.OnSuppressedEnemy,
		["Player:TeamChange"] = self.OnTeamChange,
		["Player:Update"] = self.OnUpdate,
		["Player:UpdateInput"] = self.OnUpdateInput,
		["Server:RoundOver"] = self.OnRoundOver,
		["Server:RoundReset"] = self.OnRoundReset,
		["Soldier:HealthAction"] = self.OnHealthAction,
		["Soldier:ManDown"] = self.OnManDown,
		["Soldier:PrePhysicsUpdate"] = self.OnPrePhysicsUpdate,
		["Vehicle:Damage"] = self.OnVehicleDamage,
		["Vehicle:Destroyed"] = self.OnVehicleDestroyed,
		["Vehicle:Disabled"] = self.OnVehicleDisabled,
		["Vehicle:Enter"] = self.OnVehicleEnter,
		["Vehicle:Exit"] = self.OnVehicleExit,
		["Vehicle:SpawnDone"] = self.OnVehicleSpawnDone,
		["Vehicle:Unspawn"] = self.OnVehicleUnspawn
	}
	
	self.hookNames = {
		["onEntityFactoryCreate"] = "EntityFactory:Create",
		["onEntityFactoryCreateFromBlueprint"] = "EntityFactory:CreateFromBlueprint",
		["onFindBestSquad"] = "Player:FindBestSquad",
		["onRequestJoin"] = "Player:RequestJoin",
		["onSelectTeam"] = "Player:SelectTeam",
		["onServerSuppressEnemies"] = "Server:SuppressEnemies",
		["onSoldierDamage"] = "Soldier:Damage",
	}
	
	self.hookFunctions = {
		["onEntityFactoryCreate"] = self.OnEntityFactoryCreate,
		["onEntityFactoryCreateFromBlueprint"] = self.OnEntityFactoryCreateFromBlueprint,
		["onFindBestSquad"] = self.OnPlayerFindBestSquad,
		["onRequestJoin"] = self.OnPlayerRequestJoin,
		["onSelectTeam"] = self.OnPlayerSelectTeam,
		["onServerSuppressEnemies"] = self.OnServerSuppressEnemies,
		["onSoldierDamage"] = self.OnSoldierDamage,
	}
	
	self.cumulateTime = 0
	self.playerUpdate = 30
end

function AdvancedRCON:RegisterCommands()
	RCON:RegisterCommand('admin.forceKillPlayer', RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		found = false
		for _,k_Player in pairs(PlayerManager:GetPlayers()) do
			if k_Player.name == args[1] then
				if k_Player.soldier~= nil and k_Player.soldier.isAlive == true then
					RCON:SendCommand("admin.killPlayer", {k_Player.name})
					found = true
				elseif k_Player.corpse ~= nil and k_Player.corpse.isDead == false then
					k_Player.corpse:ForceDead()
					found = true
				else
					return { 'SoldierAlreadyDead' }
				end
				break
			end
		end
		if found == true then
			return { 'OK' }
		else
			return { 'InvalidPlayerName' }
		end
	end)
	RCON:RegisterCommand('player.isRevivable', RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		p_found = false
		isRevivable = "false"
		for _,k_Player in pairs(PlayerManager:GetPlayers()) do
			if k_Player.name == args[1] then
				p_found = true
				if k_Player.corpse ~= nil and k_Player.corpse.isAlive == false then
					if k_Player.corpse.isDead == true then
						isRevivable = "false"
					else
						isRevivable = "true"
					end
				end
				break
			end
		end
		if p_found == true then
			return { 'OK', isRevivable}
		else
			return { 'InvalidPlayerName' }
		end
	end)
	RCON:RegisterCommand('player.isDead', RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		pla_found = false
		isDead = "false"
		for _,k_Player in pairs(PlayerManager:GetPlayers()) do
			if k_Player.name == args[1] then
				pla_found = true
				if k_Player.corpse == nil and k_Player.soldier == nil then
					isDead = "true"
				elseif k_Player.corpse ~= nil and k_Player.corpse.isDead == true then
					isDead = "true"
				end
				break
			end
		end
		if pla_found == true then
			return { 'OK', isDead}
		else
			return { 'InvalidPlayerName' }
		end
	end)
	RCON:RegisterCommand('admin.teamSwitchPlayer', RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		pl_found = false
		for _,k_Player in pairs(PlayerManager:GetPlayers()) do
			if k_Player.name == args[1] then
				pl_found = true
				if k_Player.teamId == TeamId.Team1 then
					k_Player.teamId = TeamId.Team2
				elseif k_Player.teamId == TeamId.Team2 then
					k_Player.teamId = TeamId.Team1
				end
				break
			end
		end
		if pl_found == true then
			return { 'OK' }
		else
			return { 'InvalidPlayerName' }
		end
	end)
	RCON:RegisterCommand('currentLevel', RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		if SharedUtils:GetLevelName() ~=nil then
			return { 'OK ', SharedUtils:GetLevelName():gsub(".+/.+/","") }
		else
			return { 'LevelNotFound' }
		end
	end)
	RCON:RegisterCommand("textChatModerationList.addPlayer", RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		self.playerName = nil
		self.playerAlreadyInList = false
		self.playerAlreadyAdmin = false
		self.playerAlreadyMuted = false
		self.playerAlreadyVoice = false
		self.index = nil
		self.playerFound = false
		if args[1] == "muted" then	
			if args[2] ~= nil then	
				self.playerName = args[2]	
				for index,mutedPlayer in pairs(self.textChatModerationList) do
					if mutedPlayer:gsub(".+:","") == self.playerName then	
						self.playerAlreadyInList = true
						self.index = index
						if mutedPlayer:gsub("(.*):.*$","%1") == "muted" then
							self.playerAlreadyMuted = true
						else
							self.playerAlreadyMuted = false
						end
					end
					
				end
				if self.playerAlreadyInList == false then
					table.insert(self.textChatModerationList, "muted:"..self.playerName)
					local sendMuted = {}
					sendMuted[1] = "muted:"..self.playerName
					NetEvents:Broadcast("Server:AddPlayer", sendMuted)
					return {'OK',args[1], args[2]}
				elseif self.playerAlreadyInList == true then
					if self.playerAlreadyMuted == true then
						return {'PlayerAlreadyMuted'}
					elseif self.playerAlreadyMuted == false then
						self.textChatModerationList[self.index] = "muted:"..self.playerName
						local sendMuted = {}
						sendMuted[1] = self.index
						sendMuted[2] = "muted:"..self.playerName
						NetEvents:Broadcast("Server:OverWritePlayer", sendMuted)
						return {'OK'}
					end
				end
			else
				return {'InvalidArguments'}
			end
		elseif args[1] == "admin" then	
			if args[2] ~= nil then	
				self.playerName = args[2]	
				for index,adminPlayer in pairs(self.textChatModerationList) do
					if adminPlayer:gsub(".+:","") == self.playerName then	
						self.playerAlreadyInList = true
						self.index = index
						if adminPlayer:gsub("(.*):.*$","%1") == "admin" then
							self.playerAlreadyAdmin = true
						else
							self.playerAlreadyAdmin = false
						end
					end
					
				end
				if self.playerAlreadyInList == false then
					table.insert(self.textChatModerationList, "admin:"..self.playerName)
					local sendAdmin = {}
					sendAdmin[1] = "admin:"..self.playerName
					NetEvents:Broadcast("Server:AddPlayer", sendAdmin)
					return {'OK',args[1], args[2]}
				elseif self.playerAlreadyInList == true then
					if self.playerAlreadyAdmin == true then
						return {'PlayerAlreadyAdmin'}
					elseif self.playerAlreadyAdmin == false then
						self.textChatModerationList[self.index] = "admin:"..self.playerName
						local sendAdmin = {}
						sendAdmin[1] = self.index
						sendAdmin[2] = "admin:"..self.playerName
						NetEvents:Broadcast("Server:OverWritePlayer", sendAdmin)
						return {'OK'}
					end
				end
			else
				return {'InvalidArguments'}
			end
		elseif args[1] == "voice" then	
			if args[2] ~= nil then	
				self.playerName = args[2]
				for index,voicePlayer in pairs(self.textChatModerationList) do
					if voicePlayer:gsub(".+:","") == self.playerName then	
						self.playerAlreadyInList = true
						self.index = index
						if voicePlayer:gsub("(.*):.*$","%1") == "voice" then
							self.playerAlreadyVoice = true
						else
							self.playerAlreadyVoice = false
						end
					end
					
				end
				if self.playerAlreadyInList == false then
					table.insert(self.textChatModerationList, "voice:"..self.playerName)
					local sendVoice = {}
					sendVoice[1] = "voice:"..self.playerName
					NetEvents:Broadcast("Server:AddPlayer", sendVoice)
					return {'OK',args[1], args[2]}
				elseif self.playerAlreadyInList == true then
					if self.playerAlreadyVoice == true then
						return {'PlayerAlreadyVoice'}
					elseif self.playerAlreadyVoice == false then
						self.textChatModerationList[self.index] = "voice:"..self.playerName
						local sendVoice = {}
						sendVoice[1] = self.index
						sendVoice[2] = "voice:"..self.playerName
						NetEvents:Broadcast("Server:OverWritePlayer", sendVoice)
						return {'OK'}
					end
				end
			else
				return {'InvalidArguments'}
			end
		elseif args[1] == "normal" then	
			if args[2] ~= nil then	
				self.playerName = args[2]
				for index,normalPlayer in pairs(self.textChatModerationList) do
					if normalPlayer:gsub(".+:","") == self.playerName then	
						self.playerAlreadyInList = true
						self.index = index
					end	
				end
				if self.playerAlreadyInList == true then
					table.remove(self.textChatModerationList, self.index)
					local sendNormal = {}
					sendNormal[1] = self.index
					NetEvents:Broadcast("Server:RemovePlayer", sendNormal)
					return {'OK'}
				else
					return {'OK'}
				end
			end
		else
			return {'InvalidArguments'}
		end
	end)
	RCON:RegisterCommand("textChatModerationList.removePlayer", RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		self.playerName = nil
		self.index = nil
		self.playerFound = false
		self.playerAlreadyInList = false
		self.playerName = args[1]
		for index,textChatPlayer in pairs(self.textChatModerationList) do
			if textChatPlayer:gsub(".+:","") == self.playerName then	
				self.playerAlreadyInList = true
				self.index = index
			end
		end
		if self.playerAlreadyInList == true then
			table.remove(self.textChatModerationList, self.index)
			local sendTextChatPlayer = {}
			sendTextChatPlayer[1] = self.index
			sendTextChatPlayer[2] = self.playerName
			NetEvents:Broadcast("Server:RemovePlayer", sendTextChatPlayer)
			return {'OK', args[2]}
		elseif self.playerAlreadyInList == false then
			return {'PlayerNotInList'}
		end
	end)
	local skipNext = false
	RCON:RegisterCommand("textChatModerationList.list", RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		if skipNext == false then
			listMutedPlayers = {'OK', 0}
			length = 0
			local parts = nil
			for _,mutedPlayer in pairs(self.textChatModerationList) do
				parts = mutedPlayer:split(':')
				table.insert(listMutedPlayers, parts[1])
				table.insert(listMutedPlayers, parts[2])
				length = length + 1
			end
			listMutedPlayers[2] = tostring(length)
			if length > 0 then
				skipNext = true
			end
			return listMutedPlayers
		else
			skipNext = false
			return {'OK', '0'}
		end
	end)
	RCON:RegisterCommand("textChatModerationList.clear", RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		self.textChatModerationList = { }
		NetEvents:Broadcast("Server:ClearList")
		return {'OK'}
	end)
	RCON:RegisterCommand("textChatModerationList.load", RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		self.textChatModerationList = require("TextChatModerationList")
		NetEvents:Broadcast("Server:LoadList", self.textChatModerationList)
		return {'OK'}
	end)
	RCON:RegisterCommand("vars.textChatModerationMode", RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		if args[1] ~= nil then
			if args[1] == "free" then
				self.textChatModerationMode = "free"
				sendMode = {}
				sendMode[1] = "free"
				NetEvents:Broadcast("Server:TextChatModerationMode", sendMode)
				return {'OK', self.textChatModerationMode}
			elseif args[1] == "moderated" then
				self.textChatModerationMode = "moderated"
				sendMode = {}
				sendMode[1] = "moderated"
				NetEvents:Broadcast("Server:TextChatModerationMode", sendMode)
				return {'OK', self.textChatModerationMode}
			elseif args[1] == "muted" then
				self.textChatModerationMode = "muted"
				sendMode = {}
				sendMode[1] = "muted"
				NetEvents:Broadcast("Server:TextChatModerationMode", sendMode)
				return {'OK', self.textChatModerationMode}
			else
				return {'InvalidArguments'}
			end
		else
			return {'OK', self.textChatModerationMode}
		end
	end)
	RCON:RegisterCommand("vars.textChatSpamTriggerCount", RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		if args[1] ~= nil then
			if tonumber(args[1]) == math.floor(tonumber(args[1])) and tonumber(args[1])>= 0 then
				AntiSpamConfig(self.chatSettings.antiSpam).detectionIntervalMaxMessageCount = tonumber(args[1])
				return {'OK', tostring(AntiSpamConfig(self.chatSettings.antiSpam).detectionIntervalMaxMessageCount)}
			else
				return {'InvalidArguments'}
			end
		else
			return {'OK', tostring(AntiSpamConfig(self.chatSettings.antiSpam).detectionIntervalMaxMessageCount)}
		end
	end)
	RCON:RegisterCommand("vars.textChatSpamDetectionTime", RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		if args[1] ~= nil then	
			if tonumber(args[1]) ~= nil and tonumber(args[1])>= 0 then
				AntiSpamConfig(self.chatSettings.antiSpam).detectionInterval = tonumber(args[1])
				return {'OK', tostring(AntiSpamConfig(self.chatSettings.antiSpam).detectionInterval):gsub("(.*)%..*$","%1")}
			else
				return {'InvalidArguments'}
			end	
		else
			return {'OK', tostring(AntiSpamConfig(self.chatSettings.antiSpam).detectionInterval):gsub("(.*)%..*$","%1")}
		end
	end)
	RCON:RegisterCommand("vars.textChatSpamCoolDownTime", RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		if args[1] ~= nil then
			if tonumber(args[1]) == math.floor(tonumber(args[1])) and tonumber(args[1])>= 0 then
				AntiSpamConfig(self.chatSettings.antiSpam).secondsBlocked = tonumber(args[1])
				return {'OK', tostring(AntiSpamConfig(self.chatSettings.antiSpam).secondsBlocked)}
			else
				return {'InvalidArguments'}
			end
		else
			return {'OK', tostring(AntiSpamConfig(self.chatSettings.antiSpam).secondsBlocked)}
		end	
	end)
end

function AdvancedRCON:RegisterEvents()
	RCON:RegisterCommand('vu.Event', RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
		local eventString = args[1]
		if self.eventNames[eventString] == "Player:Update" then
			if args[2] == "true"  then
				if self.eventHandles[eventString] == nil then
					self.eventHandles[eventString] = Events:Subscribe(self.eventNames[eventString], self, self.eventFunctions[self.eventNames[eventString]])
				end
				if args[3] ~= nil and tonumber(args[3]) ~= nil then
					self.playerUpdate = tonumber(args[3])
				end
				return { 'OK ' .. args[2] .. ' ' .. tostring(self.playerUpdate)}
			elseif args[2] == "false" then
				if self.eventHandles[eventString] ~= nil then
					self.eventHandles[eventString]:Unsubscribe()
					self.eventHandles[eventString] = nil
				end
				self.playerUpdate = 30
				return { 'OK ' .. args[2]}
			elseif args[2] == nil then
				if self.eventHandles[eventString] == nil then
					return { 'OK ' .. "false"}
				else
					return { 'OK ' .. "true " .. tostring(self.playerUpdate)}
				end
			else
				return { 'InvalidArguments' }
			end
		elseif self.eventNames[eventString] == nil then
			if self.hookNames[eventString] == nil then
				return { 'InvalidArguments' }
			else
				if args[2] == "true" then
					if self.eventHandles[eventString] == nil then
						self.eventHandles[eventString] = Hooks:Install(self.hookNames[eventString], 999, self, self.hookFunctions[eventString])
					end
					return { 'OK '.. args[2] }
				elseif args[2] == "false" then
					if self.eventHandles[eventString] ~= nil then
						self.eventHandles[eventString]:Uninstall()
						self.eventHandles[eventString] = nil
					end
					return { 'OK '.. args[2] }
				elseif args[2] == nil then
					if self.eventHandles[eventString] == nil then
						return { 'OK ' .. "false"}
					else
						return { 'OK ' .. "true"}
					end
				else
					return { 'InvalidArguments' }
				end
			end
		else
			if args[2] == "true" then
				if self.eventHandles[eventString] == nil then
					self.eventHandles[eventString] = Events:Subscribe(self.eventNames[eventString], self, self.eventFunctions[self.eventNames[eventString]])
				end
				return { 'OK '.. args[2] }
			elseif args[2] == "false" then
				if self.eventHandles[eventString] ~= nil then
					self.eventHandles[eventString]:Unsubscribe()
					self.eventHandles[eventString] = nil
				end
				return { 'OK '.. args[2] }
			elseif args[2] == nil then
				if self.eventHandles[eventString] == nil then
					return { 'OK ' .. "false"}
				else
					return { 'OK ' .. "true"}
				end
			else
				return { 'InvalidArguments' }
			end
		end
	end)
	partitionLoaded = Events:Subscribe('Partition:Loaded', function(partition)
		for _,instance in pairs(partition.instances) do
			if instance.instanceGuid ==  Guid("EF70882D-F9A1-4E43-A09D-120B6BAA7502") then 
				self.chatSettings = ChatSettings(instance)
				self.chatSettings:MakeWritable()
				break
			end
		end
	--	partitionLoaded:Unsubscribe()
	end)
	Events:Subscribe('Player:Authenticated', function(player)
		NetEvents:SendTo("Server:GetTextChatModerationList", player, self.textChatModerationList)
	end)
end

function AdvancedRCON:OnRevive(p_Player, p_Reviver, p_isAdrenalineRevive)
	RCON:TriggerEvent("player.onRevive",{p_Player.name, p_Reviver.name, tostring(p_isAdrenalineRevive)})
	-- example: "player.onRevive J4nssent Flash_Hit false"
end

function AdvancedRCON:OnLevelLoadedVU(levelName, gameMode, round, roundsPerMap)
	RCON:TriggerEvent("vu.onLevelLoaded",{levelName, gameMode, tostring(round), tostring(roundsPerMap)})
	-- example: "vu.onLevelLoaded MP_001 Conquest 1 2"
end

function AdvancedRCON:OnCapture(p_CapturePoint)
	cpcentity = CapturePointEntity(p_CapturePoint)
	RCON:TriggerEvent("capturePoint.onCapture",{cpcentity.name, tostring(cpcentity.team)})
	-- example: "capturePoint.onCaptured ID_H_US_C 1"
end

function AdvancedRCON:OnCapturePointLost(p_CapturePoint)
	cplentity = CapturePointEntity(p_CapturePoint)
	RCON:TriggerEvent("capturePoint.onLost",{cplentity.name, tostring(cpcentity.previousOwner)})
	-- example: "capturePoint.onLost ID_H_US_C 1"
end

function AdvancedRCON:OnEngineInit()
	RCON:TriggerEvent("server.onEngineInit")
	-- example: "server.onEngineInit"
end

function AdvancedRCON:OnPlayerAuthenticated(p_Player)
	RCON:TriggerEvent("vu.onAuthenticated",{p_Player.name, string.lower(tostring(p_Player.guid):gsub("-","")), string.lower(tostring(p_Player.accountGuid):gsub("-","")), p_Player.ip})
	-- example: "vu.onAuthenticated Flash_Hit auiwdauwhiaduhaidw auiwhdaiuadwiuhawdiuhdiuw 192.192.192.192"
end

function AdvancedRCON:OnPlayerChangingWeapon(p_Player)
	RCON:TriggerEvent("player.onChangingWeapon",{p_Player.name, tostring(p_Player.teamId), p_Player.soldier.weaponsComponent.currentWeapon.name:gsub(".+/.+/","")})
	-- example: "player.onChangingWeapon Flash_Hit 1 AKS74u"
end

function AdvancedRCON:OnChat(p_Player, p_RecipientMask, p_Message)
	if p_RecipientMask > 1000000000000 then
		self.recipientMask = "all"
		self.team = "0"
		self.squad = "0"
	elseif p_RecipientMask == 1 then
		self.recipientMask = "team"
		self.team = "1"
		self.squad = "0"
	elseif p_RecipientMask == 2 then
		self.recipientMask = "team"
		self.team = "2"
		self.squad = "0"
	elseif p_RecipientMask >= 83 and p_RecipientMask <= 115 then
		self.recipientMask = "squad"
		self.team = "2"
		self.squad = tostring(p_RecipientMask - 83)
	elseif p_RecipientMask >= 50 and p_RecipientMask <= 82 then
		self.recipientMask = "squad"
		self.team = "1"
		self.squad = tostring(p_RecipientMask - 50)
	end
	RCON:TriggerEvent("vu.onChat",{p_Player.name, self.recipientMask, self.team, self.squad, p_Message})
	-- example: "vu.onChat Flash_Hit 1 Hello World!"
end 

function AdvancedRCON:OnCreated(p_Player)
	RCON:TriggerEvent("player.onCreated",{p_Player.name})
	-- example: "player.onCreated Flash_Hit"
end 

function AdvancedRCON:OnDestroyed(p_Player)
	RCON:TriggerEvent("player.onDestroyed",{p_Player.name})
	-- example: "player.onDestroyed Flash_Hit"
end 

function AdvancedRCON:OnEnteredCapturePoint(p_Player, p_CapturePoint)
	ecpentity = CapturePointEntity(p_CapturePoint)
	RCON:TriggerEvent("player.onEnteredCapturePoint",{p_Player.name, tostring(p_Player.teamId), ecpentity.name}) 
	-- example: "player.onEnteredCapturePoint Flash_Hit 1 ID_H_US_C"
end 

function AdvancedRCON:OnInstantSuicide(p_Player)
	RCON:TriggerEvent("player.onInstantSuicide",{p_Player.name, tostring(p_Player.teamId)})
	-- example: "player.onInstantSuicide Flash_Hit 1"
end 

function AdvancedRCON:OnJoining(name, playerGuid, ipAddress, accountGuid)
	RCON:TriggerEvent("player.onJoining",{name, string.lower(tostring(playerGuid):gsub("-","")), ipAddress, string.lower(tostring(accountGuid):gsub("-",""))})
	-- example: "player.onJoining Flash_Hit agwwabwabawbbwawa 19.19.19.19 agwwabwabawbbwawa"
end 

function AdvancedRCON:OnKickedFromSquad(p_Player, p_Squad)
	for _,k_Player in pairs(PlayerManager:GetPlayers()) do
		if k_Player.isSquadLeader == true and k_Player.squadId == p_Squad then
			p_SquadKicker = k_Player
			break
		end
	end
	RCON:TriggerEvent("player.onKickedFromSquad",{p_Player.name, tostring(p_Player.teamId), tostring(p_Squad), p_SquadKicker.name})
	-- example: "player.onKickedFromSquad Flash_Hit 2 1 J4nssent"
end 

function AdvancedRCON:OnKilled(player, inflictor, position, weapon, isRoadKill, isHeadShot, wasVictimInReviveState, info)
	RCON:TriggerEvent("player.onKilled",{player.name, inflictor.name, tostring(position.x), tostring(position.y), tostring(position.z), weapon, tostring(isRoadKill), tostring(isHeadShot), tostring(wasVictimInReviveState), tostring(inflictor.soldier.worldTransform.trans.x), tostring(inflictor.soldier.worldTransform.trans.y), tostring(inflictor.soldier.worldTransform.trans.z)})
	-- example: "player.onKilled J4nssent Flash_Hit 5.123544 -84.946486 100.564631 AN94_Abakan false true false 10.123544 -85.946486 105.564631"
end 

function AdvancedRCON:OnKitPickup(player, p_NewCustomization)
	local args = { player.name, tostring(player.teamId) }
    if tostring(player.soldier.weaponsComponent.weapons[1]) ~= nil and tostring(player.soldier.weaponsComponent.weapons[1]) ~= "nil"  and tostring(player.soldier.weaponsComponent.weapons[1].name) ~= nil then
		args[3] = player.soldier.weaponsComponent.weapons[1].name:gsub(".+/.+/","") 
	else
		args[3] = "NoPrimary"
	end
	if tostring(player.soldier.weaponsComponent.weapons[2]) ~= nil and tostring(player.soldier.weaponsComponent.weapons[2]) ~= "nil"  and tostring(player.soldier.weaponsComponent.weapons[2].name) ~= nil then
		args[4] = player.soldier.weaponsComponent.weapons[2].name:gsub(".+/.+/","") 
	else
		args[4] = "NoSecondary"
	end
	if tostring(player.soldier.weaponsComponent.weapons[3]) ~= nil and tostring(player.soldier.weaponsComponent.weapons[3]) ~= "nil"  and tostring(player.soldier.weaponsComponent.weapons[3].name) ~= nil then
		args[5] = player.soldier.weaponsComponent.weapons[3].name:gsub(".+/.+/","")
	elseif tostring(player.soldier.weaponsComponent.weapons[5]) ~= nil and tostring(player.soldier.weaponsComponent.weapons[5]) ~= "nil"  and tostring(player.soldier.weaponsComponent.weapons[5].name) ~= nil then
		args[5] = player.soldier.weaponsComponent.weapons[5].name:gsub(".+/.+/","")
	else
		args[5] = "NoGadget1"
	end
	if tostring(player.soldier.weaponsComponent.weapons[6]) ~= nil and tostring(player.soldier.weaponsComponent.weapons[6]) ~= "nil"  and tostring(player.soldier.weaponsComponent.weapons[6].name) ~= nil then
		args[6] = player.soldier.weaponsComponent.weapons[6].name:gsub(".+/.+/","") 
	else
		args[6] = "NoGadget2"
	end
	if tostring(player.soldier.weaponsComponent.weapons[7]) ~= nil and tostring(player.soldier.weaponsComponent.weapons[7]) ~= "nil"  and tostring(player.soldier.weaponsComponent.weapons[7].name) ~= nil then
		args[7] = player.soldier.weaponsComponent.weapons[7].name:gsub(".+/.+/","") 
	else
		args[7] = "NoGrenade"
	end
	if tostring(player.soldier.weaponsComponent.weapons[8]) ~= nil and tostring(player.soldier.weaponsComponent.weapons[8]) ~= "nil"  and tostring(player.soldier.weaponsComponent.weapons[8].name) ~= nil then
		args[8] = player.soldier.weaponsComponent.weapons[8].name:gsub(".+/.+/","") 
	else
		args[8] = "NoKnife"
	end
    RCON:TriggerEvent("player.onKitPickup", args)
    -- example: "player.onKitPickup  Flash_Hit 1 M27IAR M9 NoGadget1 C4 M67 Knife_RazorBlade"
end

function AdvancedRCON:OnLeft(p_Player)
	RCON:TriggerEvent("player.onLeft",{p_Player.name, tostring(p_Player.teamId)})
	-- example: "player.onLeft Flash_Hit 1"
end 

function AdvancedRCON:OnReload(p_Player, weaponName, position)
	RCON:TriggerEvent("player.onReload",{p_Player.name, weaponName, tostring(position.x), tostring(position.y), tostring(position.z)})
	-- example: "player.onReload Flash_Hit AN94_Abakan 50.000331 75.535435 -2.432984"
end 

function AdvancedRCON:OnRespawn(player)
	local args = { player.name, tostring(player.teamId) }
    args[3] = SoldierWeaponUnlockAsset(player.weapons[1]).debugUnlockId
    args[4] = SoldierWeaponUnlockAsset(player.weapons[2]).debugUnlockId
    args[5] = player.weapons[3] and SoldierWeaponUnlockAsset(player.weapons[3]).debugUnlockId or (player.weapons[5] and SoldierWeaponUnlockAsset(player.weapons[5]).debugUnlockId or "NoGadget1")
    args[6] = player.weapons[6] and SoldierWeaponUnlockAsset(player.weapons[6]).debugUnlockId or "NoGadget2"
    args[7] = SoldierWeaponUnlockAsset(player.weapons[7]).debugUnlockId
    args[8] = SoldierWeaponUnlockAsset(player.weapons[8]).debugUnlockId
	args[9] = tostring(player.soldier.worldTransform.trans.x)
	args[10] = tostring(player.soldier.worldTransform.trans.y)
	args[11] = tostring(player.soldier.worldTransform.trans.z)
	RCON:TriggerEvent("player.onRespawn", args)
	-- example: "player.onRespawn Flash_Hit 1 U_SAIGA_20K U_Taurus44 U_Medkit NoGadget2 U_M67 U_Knife_Razor 89.959342956543 74.02335357666 145.6960144043"
end 

function AdvancedRCON:OnResupply(player, givenMagsCount, supplier)
	RCON:TriggerEvent("player.onResupply",{player.name, tostring(givenMagsCount), supplier.name})
	-- example: "player.onResupply Flash_Hit 1 J4nssent"
end 

function AdvancedRCON:OnReviveAccepted(player, reviver)
	RCON:TriggerEvent("player.onReviveAccepted",{player.name, reviver.name})
	-- example: "player.onReviveAccepted Flash_Hit J4nssent"
end 

function AdvancedRCON:OnReviveRefused(player)
	RCON:TriggerEvent("player.onReviveRefused",{player.name, tostring(player.teamId)})
	-- example: "player.onReviveRefused Flash_Hit 1"
end 

function AdvancedRCON:OnSetSquad(player, squad)
	if player ~= nil then
		RCON:TriggerEvent("player.onSetSquad",{player.name, tostring(player.teamId), tostring(squad)})
	end
	-- example: "player.onSetSquad Flash_Hit 1 1"
end 

function AdvancedRCON:OnSetSquadLeader(player)
	RCON:TriggerEvent("player.onSetSquadLeader",{player.name, tostring(player.teamId), tostring(player.squadId)})
	-- example: "player.onSetSquadLeader Flash_Hit 1 1"
end 

function AdvancedRCON:OnSpawnAtVehicle(player, vehicle)
	vehiclename = VehicleEntityData(vehicle.data).controllableType:gsub(".+/.+/","")
	RCON:TriggerEvent("player.onSpawnAtVehicle",{player.name, vehiclename})
	-- example: "player.onSpawnAtVehicle Flash_Hit F16"
end 

function AdvancedRCON:OnSpawnOnPlayer(player, playerToSpawnOn)
	RCON:TriggerEvent("player.onSpawnOnPlayer",{player.name, playerToSpawnOn.name, tostring(player.teamId), tostring(player.squadId)})
	-- example: "player.onSpawnOnPlayer Flash_Hit J4nssent 2 1"
end 

function AdvancedRCON:OnSpawnOnSelectedSpawnPoint(player)
    RCON:TriggerEvent("player.onSpawnOnSelectedSpawnPoint", { player.name, tostring(player.teamId), tostring(player.soldier.worldTransform.trans.x), tostring(player.soldier.worldTransform.trans.y), tostring(player.soldier.worldTransform.trans.z) })
    -- example: "player.onSpawnOnSelectedSpawnPoint Flash_Hit 1 89.959342956543 74.02335357666 145.6960144043"
end

function AdvancedRCON:OnSquadChange(player, squad)
	RCON:TriggerEvent("vu.onSquadChange",{player.name, tostring(player.teamId) ,tostring(squad)})
	-- example: "vu.onSquadChange Flash_Hit 2 1"
end 

function AdvancedRCON:OnSuppressedEnemy(player, enemy)
	RCON:TriggerEvent("player.onSuppressedEnemy",{player.name, enemy.name})
	-- example: "player.onSuppressedEnemy Flash_Hit J4nssent"
end 

function AdvancedRCON:OnTeamChange(player, team, squad)
	RCON:TriggerEvent("vu.onTeamChange",{player.name, tostring(team), tostring(squad)})
	-- example: "vu.onTeamChange Flash_Hit 2 1"
end 

function AdvancedRCON:OnUpdate(player, deltaTime)
	self.cumulateTime = self.cumulateTime + deltaTime
	if self.cumulateTime >= self.playerUpdate then
		self.cumulateTime = 0
		args = {
			player.name,
			tostring(player.id),
			tostring(player.onlineId), 
			string.lower(tostring(player.guid):gsub("-","")), 
			string.lower(tostring(player.accountGuid):gsub("-","")), 
			player.ip, 
			tostring(player.ping), 
			tostring(player.alive), 
			tostring(player.isSquadLeader), 
			tostring(player.isSquadPrivate), 
			tostring(player.hasSoldier), 
			tostring(player.teamId), 
			tostring(player.squadId), 
			tostring(player.isAllowedToSpawn), 
			tostring(player.score), 
			tostring(player.kills), 
			tostring(player.deaths), 
		}
		if player.soldier ~= nil then
			args[18] = player.weapons[1] and SoldierWeaponUnlockAsset(player.weapons[1]).debugUnlockId or "NoPrimary"
			args[19] = player.weapons[2] and SoldierWeaponUnlockAsset(player.weapons[2]).debugUnlockId or "NoSecondary"
			args[20] = player.weapons[3] and SoldierWeaponUnlockAsset(player.weapons[3]).debugUnlockId or (player.weapons[5] and SoldierWeaponUnlockAsset(player.weapons[5]).debugUnlockId or "NoGadget1")
			args[21] = player.weapons[6] and SoldierWeaponUnlockAsset(player.weapons[6]).debugUnlockId or "NoGadget2"
			args[22] = player.weapons[7] and SoldierWeaponUnlockAsset(player.weapons[7]).debugUnlockId or "NoGrenade"
			args[23] = player.weapons[8] and SoldierWeaponUnlockAsset(player.weapons[8]).debugUnlockId or "NoKnife"
			args[24] = tostring(player.soldier.worldTransform.trans.x)
			args[25] = tostring(player.soldier.worldTransform.trans.y)
			args[26] = tostring(player.soldier.worldTransform.trans.z)
			args[27] = tostring(player.soldier.health)
			args[28] = tostring(player.soldier.isDead)
		else
			args[18] = "NoPrimary"
			args[19] = "NoSecondary"
			args[20] = "NoGadget1"
			args[21] = "NoGadget2"
			args[22] = "NoGrenade"
			args[23] = "NoKnife"
			args[24] = "0"
			args[25] = "0"
			args[26] = "0"
			args[27] = "0"
			if player.corpse ~= nil then	
				args[28] = tostring(player.corpse.isDead)
			else
				args[28] = "true"
			end
		end
		args[29] = tostring(self.cumulateTime)
		RCON:TriggerEvent("player.onUpdate", args)
		-- example: "player.onUpdate Flash_Hit 0 55555 auiwdauwhiaduhaidw auiwhdaiuadwiuhawdiuhdiuw 192.192.192.192 0 true true false true 1 1 true 0 U_AN94 U_M9 U_Medkit U_Defib U_M67 U_Knife_Razor 88.772033691406 73.844879150391 145.65452575684 100.0 false 5.0000002607703"
	end
end 

function AdvancedRCON:OnUpdateInput(player, deltaTime)
	RCON:TriggerEvent("player.onUpdateInput",{player.name, tostring(deltaTime)})
	-- example: "player.onUpdateInput Flash_Hit 1.000000"
end 

function AdvancedRCON:OnRoundOver(roundTime, winningTeam)
	RCON:TriggerEvent("vu.onRoundOver",{tostring(roundTime), tostring(winningTeam)})
	-- example: "vu.onRoundOver 1200.841796875 1"
end 

function AdvancedRCON:OnRoundReset()
	RCON:TriggerEvent("server.onRoundReset",{})
	-- example: "server.onRoundReset"
end 

function AdvancedRCON:OnHealthAction(soldier, action)
	for _,playerdown in pairs(PlayerManager:GetPlayers()) do
		if playerdown.corpse == soldier then
			thisplayer = playerdown
			break
		end
	end
	if thisplayer ~= nil then
		RCON:TriggerEvent("soldier.onHealthAction",{thisplayer.name, tostring(action)})
	else 
		RCON:TriggerEvent("soldier.onHealthAction",{soldier.player.name, tostring(action)})	
	end
	thisplayer = nil
	-- example: "soldier.onHealthAction Flash_Hit 8"
end 

function AdvancedRCON:OnManDown(soldier, inflictor)
	for _,playermandown in pairs(PlayerManager:GetPlayers()) do
		if playermandown.corpse == soldier then
			thisplayerman = playermandown
			break
		end
	end
	if thisplayerman ~= nil then
		RCON:TriggerEvent("soldier.onManDown", {thisplayerman.name, inflictor.name})
	else 
		RCON:TriggerEvent("soldier.onManDown", {soldier.player.name, inflictor.name})
	end
	thisplayerman = nil
	-- example: "soldier.onManDown Flash_Hit"
end 

function AdvancedRCON:OnPrePhysicsUpdate(soldier, deltaTime)
	RCON:TriggerEvent("soldier.onPrePhysicsUpdate",{soldier.player.name, tostring(deltaTime)})
	-- example: "soldier.onPrePhysicsUpdate Flash_Hit 1.000000"
end 

function AdvancedRCON:OnVehicleDamage(vehicle, damage, info)
	vehicleNameDamage = VehicleEntityData(vehicle.data).controllableType:gsub(".+/.+/","")
	if info ~= nil and info.giver ~= nil then
		RCON:TriggerEvent("vehicle.onDamage",{vehicleNameDamage, tostring(damage), info.giver.name})
	-- example: "vehicle.onDamage F16 25.0 Flash_Hit"
	else
		RCON:TriggerEvent("vehicle.onDamage",{vehicleNameDamage, tostring(damage), "None"})
	end
end 

function AdvancedRCON:OnVehicleDestroyed(vehicle, vehiclePoints, hotTeam)
	vehicleNameDestroyed = VehicleEntityData(vehicle.data).controllableType:gsub(".+/.+/","")
	RCON:TriggerEvent("vehicle.onDestroyed",{vehicleNameDestroyed, tostring(vehiclePoints), tostring(hotTeam)})
	-- example: "vehicle.onDestroyed F16 100 1"
end 

function AdvancedRCON:OnVehicleDisabled(vehicle)
	vehicleNameDisabled = VehicleEntityData(vehicle.data).controllableType:gsub(".+/.+/","")
	RCON:TriggerEvent("vehicle.onDisabled",{vehicleNameDisabled})
	-- example: "vehicle.onDisabled F16"
end 

function AdvancedRCON:OnVehicleEnter(vehicle, player)
	vehicleNameEnter = VehicleEntityData(vehicle.data).controllableType:gsub(".+/.+/","")
	RCON:TriggerEvent("vehicle.onEnter",{vehicleNameEnter, player.name, tostring(player.teamId)})
	-- example: "vehicle.onEnter F16 Flash_Hit 1"
end 

function AdvancedRCON:OnVehicleExit(vehicle, player)
	vehicleNameExit = VehicleEntityData(vehicle.data).controllableType:gsub(".+/.+/","")
	RCON:TriggerEvent("vehicle.onExit",{vehicleNameExit, player.name})
	-- example: "vehicle.onExit F16 Flash_Hit"
end 

function AdvancedRCON:OnVehicleSpawnDone(vehicle)
	vehicleNameSpawnDone = VehicleEntityData(vehicle.data).controllableType:gsub(".+/.+/","")
	RCON:TriggerEvent("vehicle.onSpawnDone",{vehicleNameSpawnDone})
	-- example: "vehicle.onSpawnDone F16"
end 

function AdvancedRCON:OnVehicleUnspawn(vehicle)
	vehicleNameUnSpawn = VehicleEntityData(vehicle.data).controllableType:gsub(".+/.+/","")
	RCON:TriggerEvent("vehicle.onUnspawn",{vehicleNameUnSpawn})
	-- example: "vehicle.onUnspawn F16"
end 

function AdvancedRCON:OnEntityFactoryCreate(hook, entityData, transform)
	RCON:TriggerEvent("entityFactory.onCreate")
end

function AdvancedRCON:OnEntityFactoryCreateFromBlueprint(hook, blueprint, transform, variation, parentRepresentative)
	RCON:TriggerEvent("entityFactory.onCreateFromBlueprint")
end

function AdvancedRCON:OnPlayerFindBestSquad(hook, player)
	print(tostring(SquadId))
	RCON:TriggerEvent("player.onFindBestSquad",{player.name})
end

function AdvancedRCON:OnPlayerRequestJoin(hook, joinMode, accountGuid, playerGuid, playerName)
	RCON:TriggerEvent("player.onRequestJoin",{joinMode, string.lower(tostring(accountGuid):gsub("-","")), string.lower(tostring(playerGuid):gsub("-","")), playerName})
	-- example: "player.onRequestJoin player auiwdauwhiaduhaidw auiwhdaiuadwiuhawdiuhdiuw Flash_Hit"
end

function AdvancedRCON:OnPlayerSelectTeam(hook, player, team)
	RCON:TriggerEvent("player.onSelectTeam",{player.name, tostring(player.teamId)})
	-- example: "player.onSelectTeam Flash_Hit 1" -- this means the player switchs from team1 to another team 
end

function AdvancedRCON:OnServerSuppressEnemies(hook, suppressionModifier)
	RCON:TriggerEvent("server.onSuppressEnemies",{tostring(suppressionModifier)})
	-- example: "server.onSuppressEnemies 0.0088"
end

function AdvancedRCON:OnSoldierDamage(hook, soldier, info, giverInfo)
	if giverInfo ~= nil and giverInfo.giver ~= nil then
		if giverInfo.giver.soldier ~= nil then
			RCON:TriggerEvent("soldier.onDamage",{soldier.player.name, tostring(info.damage), tostring(giverInfo.giver.name), giverInfo.giver.soldier.weaponsComponent.currentWeapon.name:gsub(".+/.+/","")})
		else
			RCON:TriggerEvent("soldier.onDamage",{soldier.player.name, tostring(info.damage), tostring(giverInfo.giver.name), "None"})
		end
	else
		RCON:TriggerEvent("soldier.onDamage",{soldier.player.name, tostring(info.damage), "None", "None"})
	end
	-- example: "soldier.onDamage Flash_Hit 80.0 J4nssent"
end

g_AdvancedRCON = AdvancedRCON()
