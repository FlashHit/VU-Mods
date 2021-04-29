-- =============================================
-- Enable FreeCam
-- =============================================

function DisableMenuVisualEnv()
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

function HUDEnterUIGraph()
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

function ExitSoundState()
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

-- Unused at the moment
function EnableSpectatorScoreboard()
	local s_UIGraphEntityIterator = EntityManager:GetIterator("ClientUIGraphEntity")
    local s_UIGraphEntity = s_UIGraphEntityIterator:Next()

    while s_UIGraphEntity do
        if s_UIGraphEntity.data.instanceGuid == Guid("37CF5B27-09C0-4925-B458-CF01CB24AD86") then
            s_UIGraphEntity = Entity(s_UIGraphEntity)
            s_UIGraphEntity:FireEvent("Spectating")
            break
        end

        s_UIGraphEntity = s_UIGraphEntityIterator:Next()
    end
end

-- =============================================
-- Disable FreeCam
-- =============================================

function EnableMenuVisualEnv()
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

function EnterSpawnUIGraph()
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

function EnterSoundState()
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

-- Unused at the moment
function DisableSpectatorScoreboard()
	-- not that easy ..
end

-- =============================================
-- Hooks
-- =============================================

Hooks:Install('ClientChatManager:IncomingMessage', 1, function(p_HookCtx, p_Message, p_PlayerId, p_RecipientMask, p_ChannelId, p_IsSenderDead)
	if p_ChannelId == 4 then
		return
	end
	if not p_Message:match("!freecam") then
		return
	end
	local s_LocalPlayer = PlayerManager:GetLocalPlayer()
	if s_LocalPlayer == nil then
		return
	end
	if s_LocalPlayer.id ~= p_PlayerId then
		return
	end
	if s_LocalPlayer.alive then
		return
	end
	if s_LocalPlayer.soldier ~= nil then
		return
	end
	if s_LocalPlayer.corpse ~= nil and not s_LocalPlayer.corpse.isDead then
		return
	end
	if p_Message == "!freecam true" then
		-- EnableSpectatorScoreboard()
		DisableMenuVisualEnv()
		HUDEnterUIGraph()
		ExitSoundState()
		SpectatorManager:SetSpectating(true)
		SpectatorManager:SetCameraMode(SpectatorCameraMode.FreeCamera)
	elseif p_Message == "!freecam false" then
		EnableMenuVisualEnv()
		EnterSpawnUIGraph()
		EnterSoundState()
		SpectatorManager:SetSpectating(false)
		-- DisableSpectatorScoreboard()
	end
end)