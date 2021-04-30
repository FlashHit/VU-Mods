class 'SimpleSpectator'

require 'Config'

local SpectatingState = {
	Disabled = 0,
	PendingEnable = 1,
	PendingDisable = 2
}

function SimpleSpectator:__init()
	self.m_SetThirdPerson = nil
	self.m_SpectatedPlayerName = nil
	self.m_SetSpectatingState = SpectatingState.Disabled
	Events:Subscribe('Extension:Loaded', self, self.OnExtensionLoaded)
	Events:Subscribe("Extension:Unloading", self, self.OnExtensionUnloading)
end

-- =============================================
-- Events
-- =============================================

function SimpleSpectator:OnExtensionLoaded()
	Events:Subscribe('Engine:Update', self, self.OnEngineUpdate)
	Events:Subscribe('Client:UpdateInput', self, self.OnClientUpdateInput)
	Events:Subscribe('Player:Deleted', self, self.OnPlayerDeleted)
	self:RegisterConsoleCommands()
end

function SimpleSpectator:OnExtensionUnloading()
	Console:Deregister('GetSpectating')
	Console:Deregister('SetSpectating')
	Console:Deregister('SpectatePlayer')
	Console:Deregister('GetSpectatedPlayer')
	Console:Deregister('GetCameraMode')
	Console:Deregister('SetCameraMode')
	Console:Deregister('GetFreecameraTransform')
	Console:Deregister('SetFreecameraTransform')
end

function SimpleSpectator:OnEngineUpdate(p_DeltaTime, p_SimulationDeltaTime)
	self:ApplyThirdPerson()
	if self.m_SetSpectatingState == SpectatingState.PendingEnable then
		self:DisableMenuVisualEnv()
		self:HUDEnterUIGraph()
		self:ExitSoundState()
		SpectatorManager:SetCameraMode(SpectatorCameraMode.FreeCamera)
		self.m_SetSpectatingState = SpectatingState.Disabled
	elseif self.m_SetSpectatingState == SpectatingState.PendingDisable then
		self:EnableMenuVisualEnv()
		self:EnterSpawnUIGraph()
		self:EnterSoundState()
		SpectatorManager:SetCameraMode(SpectatorCameraMode.FreeCamera)
		self.m_SetSpectatingState = SpectatingState.Disabled
	end
end

function SimpleSpectator:OnClientUpdateInput(p_DeltaTime)
	if not SpectatorManager:GetSpectating() then
		return
	end
	if InputManager:WentKeyDown(InputDeviceKeys.IDK_Space) then
		local s_CameraMode = SpectatorManager:GetCameraMode()
		if self.m_SpectatedPlayerName == nil then
			self:GetPlayerToSpectate(true)
			return
		end
		if s_CameraMode == 0 or s_CameraMode == 2 then
			local s_SpectatedPlayer = PlayerManager:GetPlayerByName(self.m_SpectatedPlayerName)
			SpectatorManager:SpectatePlayer(s_SpectatedPlayer, true)
		elseif s_CameraMode == 1 then
			SpectatorManager:SetCameraMode(3)
			self:SetThirdPerson(self.m_SpectatedPlayerName)
		elseif s_CameraMode == 3 then
			SpectatorManager:SetCameraMode(0)
		end
	elseif InputManager:WentKeyDown(InputDeviceKeys.IDK_ArrowRight) then
		self:GetPlayerToSpectate(true)
	elseif InputManager:WentKeyDown(InputDeviceKeys.IDK_ArrowLeft) then
		self:GetPlayerToSpectate(false)
	end
end

function SimpleSpectator:OnPlayerDeleted(p_Player)
	if p_Player.name == self.m_SpectatedPlayerName then
		self:GetPlayerToSpectate(true)
	end
end

-- =============================================
-- Console Commands
-- =============================================

function SimpleSpectator:RegisterConsoleCommands()
	if not Config.EnableConsoleCommands then
		return
	end
	Console:Register('GetSpectating', 'GetSpectating', function()
		print("GetSpectating: " .. tostring(SpectatorManager:GetSpectating()))
	end)

	if Config.AllowPlayerSetSpectating then
		Console:Register('SetSpectating', 'true/false', function(p_Args)
			local s_LocalPlayer = PlayerManager:GetLocalPlayer()
			if s_LocalPlayer == nil or s_LocalPlayer.soldier ~= nil or s_LocalPlayer.corpse ~= nil then
				if Config.BlockForSpawnedPlayers and s_LocalPlayer.teamId ~= TeamId.TeamNeutral then
					print("Invalid - You are not dead")
					return
				end
			end
			if p_Args ~= nil and p_Args[1] == "true" then
				SpectatorManager:SetSpectating(true)
				if s_LocalPlayer.teamId ~= TeamId.TeamNeutral then
					self.m_SetSpectatingState = SpectatingState.PendingEnable
				end
				print("SetSpectating(true)")
			elseif p_Args ~= nil and p_Args[1] == "false" then
				if s_LocalPlayer.teamId ~= TeamId.TeamNeutral then
					self.m_SetSpectatingState = SpectatingState.PendingDisable
					self.m_SpectatedPlayerName = nil
				end
				SpectatorManager:SetSpectating(false)
				print("SetSpectating(false)")
			else
				print("Invalid Arguments")
			end
		end)
	end

	Console:Register('GetSpectatedPlayer', 'GetSpectatedPlayer() returns player.', function(p_Args)
		if not SpectatorManager:GetSpectating() then
			print("Invalid - Enable Spectating first")
			return
		end
		local s_SpectatedPlayer = SpectatorManager:GetSpectatedPlayer()
		if s_SpectatedPlayer ~= nil then
			print("GetSpectatedPlayer: " .. s_SpectatedPlayer.name)
		else
			print("GetSpectatedPlayer: nil")
		end
	end)

	Console:Register('SpectatePlayer', 'SpectatePlayer(playerName, firstPerson: bool).', function(p_Args)
		if not SpectatorManager:GetSpectating() then
			print("Invalid - Enable Spectating first")
			return
		end
		if p_Args ~= nil then
			local s_PlayerToSpectate = PlayerManager:GetPlayerByName(p_Args[1])
			if s_PlayerToSpectate ~= nil then
				if p_Args[2] == "true" then
					self.m_SpectatedPlayerName = s_PlayerToSpectate.name
					SpectatorManager:SpectatePlayer(s_PlayerToSpectate, true)
					print("SpectatePlayer(" .. p_Args[1] .. ", " .. p_Args[2] .. ")")
				elseif p_Args[2] ~= nil and p_Args[2] == "false" then
					SpectatorManager:SetCameraMode(3)
					self:SetThirdPerson(p_Args[1])
					print("SpectatePlayer(" .. p_Args[1] .. ", " .. p_Args[2] .. ")")
				else
					print("Invalid Arguments")
				end
			else
				print("Player Not Found")
			end
		else
			print("Invalid Arguments")
		end
	end)

	Console:Register('GetCameraMode', 'GetCameraMode()', function()
		print("GetCameraMode: " .. tostring(SpectatorManager:GetCameraMode()))
	end)

	Console:Register('SetCameraMode', 'SetCameraMode(int: 0 - 3)', function(p_Args)
		if not SpectatorManager:GetSpectating() then
			print("Invalid - Enable Spectating first")
			return
		end
		if p_Args ~= nil and p_Args[1] == "0" or p_Args[1] == "1" or p_Args[1] == "2" or p_Args[1] == "3" then
			SpectatorManager:SetCameraMode(0)
			if p_Args[1] == "2" then
				SpectatorManager:SetCameraMode(3)
				self:SetThirdPerson(nil)
			end
			if p_Args[1] == "1" then
				SpectatorManager:SetCameraMode(1)
			end
			if p_Args[1] == "3" then
				SpectatorManager:SetCameraMode(3)
			end
			print("SpectatorManager:SetCameraMode(" .. p_Args[1] .. ")")
		else
			print("Invalid Arguments")
		end
	end)

	Console:Register('GetFreecameraTransform', 'GetFreecameraTransform()', function()
		local s_FreeCamTrans = SpectatorManager:GetFreecameraTransform()
		if s_FreeCamTrans~= nil then
			print("GetFreecameraTransform: Vec3(" .. tostring(s_FreeCamTrans.left.x) .. ", " .. tostring(s_FreeCamTrans.left.y) .. ", " .. tostring(s_FreeCamTrans.left.z) .. "), Vec3(" .. tostring(s_FreeCamTrans.up.x) .. ", " .. tostring(s_FreeCamTrans.up.y) .. ", " .. tostring(s_FreeCamTrans.up.z) .. "), Vec3(" .. tostring(s_FreeCamTrans.forward.x) .. ", " .. tostring(s_FreeCamTrans.forward.y) .. ", " .. tostring(s_FreeCamTrans.forward.z) .. "), Vec3(" .. tostring(s_FreeCamTrans.trans.x) .. ", " .. tostring(s_FreeCamTrans.trans.y) .. ", " .. tostring(s_FreeCamTrans.trans.z) .. ")")
		else
			print("GetFreecameraTransform: nil")
		end
	end)

	Console:Register('SetFreecameraTransform', 'SetFreecameraTransform(transform: LinearTransform)', function(p_Args)
		if not SpectatorManager:GetSpectating() then
			print("Invalid - Enable Spectating first")
			return
		end
		if p_Args ~= nil and tonumber(p_Args[1]) and tonumber(p_Args[2]) and tonumber(p_Args[3]) then
			local s_LinearTransform = LinearTransform(Vec3(-0.592198, 0.000000, -0.805793), Vec3(0.000000, 1.000000, 0.000000), Vec3(0.805793, 0.000000, -0.592198), Vec3(0, 0, 0))
			s_LinearTransform.trans.x = tonumber(p_Args[1])
			s_LinearTransform.trans.y = tonumber(p_Args[2])
			s_LinearTransform.trans.z = tonumber(p_Args[3])
			SpectatorManager:SetFreecameraTransform(s_LinearTransform)
			print("SpectatorManager:SetFreecameraTransform(LinearTransform(Vec3(-0.592198, 0.000000, -0.805793), Vec3(0.000000, 1.000000, 0.000000), Vec3(0.805793, 0.000000, -0.592198), Vec3("..p_Args[1]..", "..p_Args[2]..", "..p_Args[3]..")))")
		else
			print("Invalid Arguments")
		end
	end)
end

-- =============================================
-- Third Person Cam Tweak
-- =============================================

function SimpleSpectator:SetThirdPerson(p_PlayerToSpectate)
	self.m_SetThirdPerson = p_PlayerToSpectate
	if self.m_SetThirdPerson == nil then
		local s_SpectatedPlayer = SpectatorManager:GetSpectatedPlayer()
		if s_SpectatedPlayer ~= nil then
			self.m_SetThirdPerson = s_SpectatedPlayer.name
			return
		end
		print("Invalid player not found")
	end
end

function SimpleSpectator:ApplyThirdPerson()
	if self.m_SetThirdPerson == nil then
		return
	end
	local s_SpectatedPlayer = PlayerManager:GetPlayerByName(self.m_SetThirdPerson)
	if s_SpectatedPlayer == nil or s_SpectatedPlayer.soldier == nil then
		return
	end
	local s_EntityIterator = EntityManager:GetIterator("ClientPlayerCameraEntity")
	local s_Entity = s_EntityIterator:Next()
	while s_Entity do
		s_Entity = Entity(s_Entity)
		if s_Entity.data ~= nil and s_Entity.data.instanceGuid == Guid("B075B3D3-0BB7-43CA-8F5D-92A28438688D") then
			local s_Event = ClientPlayerEvent("TakeControl", s_SpectatedPlayer)
			self.m_SpectatedPlayerName = self.m_SetThirdPerson
			s_Entity:FireEvent(s_Event)
			self.m_SetThirdPerson = nil
		else
			s_Entity:FireEvent("ReleaseControl")
		end
		s_Entity = s_EntityIterator:Next()
	end
end

-- =============================================
-- Get Next / Previous Player
-- =============================================

function SimpleSpectator:GetPlayerToSpectate(p_IsNext)
	local s_SpectatedPlayer = SpectatorManager:GetSpectatedPlayer()
	if self.m_SpectatedPlayerName ~= nil then
		s_SpectatedPlayer = PlayerManager:GetPlayerByName(self.m_SpectatedPlayerName)
	end
	local s_CameraMode = SpectatorManager:GetCameraMode()
	local s_FirstPerson = false
	if s_CameraMode == 1 then
		s_FirstPerson = true
	end
	if s_SpectatedPlayer == nil then
		for _, l_Player in pairs(PlayerManager:GetPlayers()) do
			if l_Player ~= nil and l_Player.soldier ~= nil then
				SpectatorManager:SpectatePlayer(l_Player, s_FirstPerson)
				return
			end
		end
	end
	local s_Players = PlayerManager:GetPlayers()
	local s_FoundSpectatedPlayer = false
	local s_PlayerToSpectate = nil

	local s_StartIndex = #s_Players
	local s_EndIndex = 1
	local s_Steps = -1

	if p_IsNext then
		s_StartIndex = 1
		s_EndIndex =  #s_Players
		s_Steps = 1
	end

	for i = s_StartIndex, s_EndIndex, s_Steps do
		if s_FoundSpectatedPlayer and s_Players[i] ~= nil and s_Players[i].soldier ~= nil then
			s_PlayerToSpectate = s_Players[i]
			break
		end
		if s_Players[i] ~= nil and s_Players[i] == s_SpectatedPlayer then
			s_FoundSpectatedPlayer = true
		end
	end
	if s_PlayerToSpectate == nil then
		for i = s_StartIndex, s_EndIndex, s_Steps do
			if s_Players[i] ~= nil and s_Players[i].soldier ~= nil then
				s_PlayerToSpectate = s_Players[i]
				break
			end
		end
		if s_PlayerToSpectate == nil then
			return
		end
	end
	if s_FirstPerson then
		self.m_SpectatedPlayerName = s_PlayerToSpectate.name
		SpectatorManager:SpectatePlayer(s_PlayerToSpectate, s_FirstPerson)
	else
		self:SetThirdPerson(s_PlayerToSpectate.name)
	end
end

-- =============================================
	-- Enter Spectator as Player
-- =============================================

function SimpleSpectator:DisableMenuVisualEnv()
	local s_Iterator = EntityManager:GetIterator("VisualEnvironmentEntity")
    local s_Entity = s_Iterator:Next()

    while s_Entity do
		if s_Entity.data.instanceGuid == Guid("F26B7ECE-A71D-93AC-6C49-B6223BF424D6") then
            s_Entity = Entity(s_Entity)
            s_Entity:FireEvent("Disable")
            return
        end

        s_Entity = s_Iterator:Next()
    end
end

function SimpleSpectator:HUDEnterUIGraph()
	local s_UIGraphEntityIterator = EntityManager:GetIterator("ClientUIGraphEntity")
    local s_UIGraphEntity = s_UIGraphEntityIterator:Next()

    while s_UIGraphEntity do
        if s_UIGraphEntity.data.instanceGuid == Guid("133D3825-5F17-4210-A4DB-3694FDBAD26D") then
            s_UIGraphEntity = Entity(s_UIGraphEntity)
            s_UIGraphEntity:FireEvent("EnterUIGraph")
            return
        end

        s_UIGraphEntity = s_UIGraphEntityIterator:Next()
    end
end

function SimpleSpectator:ExitSoundState()
	local s_SoundStateEntityIterator = EntityManager:GetIterator("SoundStateEntity")
    local s_SoundStateEntity = s_SoundStateEntityIterator:Next()

    while s_SoundStateEntity do
        if s_SoundStateEntity.data.instanceGuid == Guid("AC7A757C-D9FA-4693-97E7-7A5C50EF29C7") then
            s_SoundStateEntity = Entity(s_SoundStateEntity)
            s_SoundStateEntity:FireEvent("Exit")
            return
        end

        s_SoundStateEntity = s_SoundStateEntityIterator:Next()
    end
end


-- =============================================
-- Disable FreeCam
-- =============================================

function SimpleSpectator:EnableMenuVisualEnv()
	local s_Iterator = EntityManager:GetIterator("VisualEnvironmentEntity")
    local s_Entity = s_Iterator:Next()

    while s_Entity do
		if s_Entity.data.instanceGuid == Guid("F26B7ECE-A71D-93AC-6C49-B6223BF424D6") then
            s_Entity = Entity(s_Entity)
            s_Entity:FireEvent("Enable")
            return
        end

        s_Entity = s_Iterator:Next()
    end
end

function SimpleSpectator:EnterSpawnUIGraph()
	-- has to be in the correct order

	local s_UIGraphEntityIterator = EntityManager:GetIterator("ClientUIGraphEntity")
    local s_UIGraphEntity = s_UIGraphEntityIterator:Next()

    while s_UIGraphEntity do
        if s_UIGraphEntity.data.instanceGuid == Guid("C1B7EFE2-A8B7-497E-AB9D-8D4DA1E677FD") then
            s_UIGraphEntity = Entity(s_UIGraphEntity)
            s_UIGraphEntity:FireEvent("EnterUIGraph")
            break
        end

        s_UIGraphEntity = s_UIGraphEntityIterator:Next()
    end
	s_UIGraphEntityIterator = EntityManager:GetIterator("ClientUIGraphEntity")
    s_UIGraphEntity = s_UIGraphEntityIterator:Next()

    while s_UIGraphEntity do
        if s_UIGraphEntity.data.instanceGuid == Guid("5C1E9F44-EE8D-41AC-A7C6-A1B6F304451A") then
            s_UIGraphEntity = Entity(s_UIGraphEntity)
            s_UIGraphEntity:FireEvent("StartSpawnButtonScreen")
            break
        end

        s_UIGraphEntity = s_UIGraphEntityIterator:Next()
    end
	s_UIGraphEntityIterator = EntityManager:GetIterator("ClientUIGraphEntity")
    s_UIGraphEntity = s_UIGraphEntityIterator:Next()

    while s_UIGraphEntity do
        if s_UIGraphEntity.data.instanceGuid == Guid("31DAEA00-29DD-4524-9E90-5BB82037749F") then
            s_UIGraphEntity = Entity(s_UIGraphEntity)
            s_UIGraphEntity:FireEvent("EnterSpawn")
            break
        end

        s_UIGraphEntity = s_UIGraphEntityIterator:Next()
    end
end

function SimpleSpectator:EnterSoundState()
	local s_SoundStateEntityIterator = EntityManager:GetIterator("SoundStateEntity")
    local s_SoundStateEntity = s_SoundStateEntityIterator:Next()

    while s_SoundStateEntity do
        if s_SoundStateEntity.data.instanceGuid == Guid("AC7A757C-D9FA-4693-97E7-7A5C50EF29C7") then
            s_SoundStateEntity = Entity(s_SoundStateEntity)
            s_SoundStateEntity:FireEvent("Enter")
            return
        end

        s_SoundStateEntity = s_SoundStateEntityIterator:Next()
    end
end

if g_SimpleSpectator == nil then
	g_SimpleSpectator = SimpleSpectator()
end
