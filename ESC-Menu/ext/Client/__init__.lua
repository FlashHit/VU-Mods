local s_IsKillScreen = false

-- =============================================
-- Open ESC Menu
-- =============================================

function EnableMenuVisualEnv()
	-- not working cuz of the property Visibility
	local s_Iterator = EntityManager:GetIterator("LogicVisualEnvironmentEntity")
    local s_Entity = s_Iterator:Next()

    while s_Entity do
		if s_Entity.data.instanceGuid == Guid("A17FCE78-E904-4833-98F8-50BE77EFCC41") then
            s_Entity = Entity(s_Entity)
			s_Entity:PropertyChanged("Visibility", 1.0)
            s_Entity:FireEvent("Enable")
            return
        end

        s_Entity = s_Iterator:Next()
    end
	
	s_Iterator = EntityManager:GetIterator("VisualEnvironmentEntity")
    s_Entity = s_Iterator:Next()

    while s_Entity do
		if s_Entity.data.instanceGuid == Guid("F26B7ECE-A71D-93AC-6C49-B6223BF424D6") then
            s_Entity = Entity(s_Entity)
            s_Entity:FireEvent("Enable")
            return
        end

        s_Entity = s_Iterator:Next()
    end
end

function EnterEscapeMenu()
	local s_UIGraphEntityIterator = EntityManager:GetIterator("ClientUIGraphEntity")
    local s_UIGraphEntity = s_UIGraphEntityIterator:Next()

    while s_UIGraphEntity do
         if s_UIGraphEntity.data.instanceGuid == Guid("B9437F95-2EBC-4F22-A5F6-F4D0F1331A5E") then
            s_UIGraphEntity = Entity(s_UIGraphEntity)
            s_UIGraphEntity:FireEvent("EnterFromGame")
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

-- =============================================
-- Events
-- =============================================

Events:Subscribe('Client:UpdateInput', function(p_DeltaTime)
	if not s_IsKillScreen then
		return
	end
	if not InputManager:WentKeyDown(InputDeviceKeys.IDK_Escape) then
		return
	end
	EnableMenuVisualEnv()
	EnterEscapeMenu()
	EnterSoundState()
end)
-- 3FD5F757-7523-4D9B-81A1-FBC1F3C6492B -- killscreen -- "Death"
-- 5C1E9F44-EE8D-41AC-A7C6-A1B6F304451A -- StartSpawnButtonScreen

-- =============================================
-- Hooks
-- =============================================

Hooks:Install('UI:PushScreen', 1, function(hook, screen, priority, parentGraph, stateNodeGuid)
	if Asset(screen).name == "UI/Flow/Screen/KillScreen" then
		s_IsKillScreen = true
	else
		s_IsKillScreen = false
	end
end)
