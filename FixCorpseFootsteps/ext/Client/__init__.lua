local m_FootStepSoundEntityDataGuid = Guid("E7963709-555C-4FBB-81EA-0E3436E2C9E2")

---@param p_Soldier SoldierEntity
local function GetSoundEntity(p_Soldier)
	for _, l_Entity in pairs(p_Soldier.bus.entities) do
		if l_Entity.typeInfo.name == "SoundEntity" then
			if l_Entity.data.instanceGuid == m_FootStepSoundEntityDataGuid then
				return l_Entity
			end
		end
	end
end

local s_RegisterEventCallbacks = {}

---@param p_Soldier SoldierEntity
---@param p_Action HealthStateAction|integer
Events:Subscribe('Soldier:HealthAction', function(p_Soldier, p_Action)
	if (p_Action == HealthStateAction.OnManDown or p_Action == HealthStateAction.OnKilled) and not s_RegisterEventCallbacks[p_Soldier.instanceId] then
		local s_SoundEntity = GetSoundEntity(p_Soldier)

		if s_SoundEntity then
			s_RegisterEventCallbacks[p_Soldier.instanceId] = s_SoundEntity:RegisterEventCallback(function(p_Entity, p_EntityEvent)
				return false
			end)
		end
	elseif p_Action == HealthStateAction.OnRevive and s_RegisterEventCallbacks[p_Soldier.instanceId] then
		local s_SoundEntity = GetSoundEntity(p_Soldier)

		if s_SoundEntity then
			s_SoundEntity:UnregisterEventCallback(s_RegisterEventCallbacks[p_Soldier.instanceId])
			s_RegisterEventCallbacks[p_Soldier.instanceId] = nil
		end
	end
end)

---@param p_Soldier SoldierEntity
Events:Subscribe('Soldier:Spawn', function(p_Soldier)
	if s_RegisterEventCallbacks[p_Soldier.instanceId] then
		local s_SoundEntity = GetSoundEntity(p_Soldier)

		if s_SoundEntity then
			s_SoundEntity:UnregisterEventCallback(s_RegisterEventCallbacks[p_Soldier.instanceId])
			s_RegisterEventCallbacks[p_Soldier.instanceId] = nil
		end
	end
end)
