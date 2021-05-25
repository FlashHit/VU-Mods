local s_Shots = 0
local s_Hits = 0
local s_InstanceIds = {}

Hooks:Install('BulletEntity:Collision', 1, function(p_HookCtx, p_Entity, p_Hit, p_Shooter)
	if p_Shooter == nil or p_Shooter ~= PlayerManager:GetLocalPlayer() then
		return
	end
	if s_InstanceIds[p_Entity.instanceId] == nil then
		s_Shots = s_Shots + 1
		s_InstanceIds[p_Entity.instanceId] = true
		p_Entity:RegisterDestroyCallback(function(p_DestroyedEntity)
			s_InstanceIds[p_DestroyedEntity.instanceId] = nil
		end)
	end
	if p_Hit.rigidBody ~= nil and p_Hit.rigidBody:Is("CharacterPhysicsEntity") then
		s_Hits = s_Hits + 1
	end
end)

Console:Register('Get', 'get your accuracy.', function()
	if s_Shots ~= 0 then
		print(tostring((s_Hits / s_Shots) * 100) .. "% (" .. tostring(s_Hits) .. " / " .. tostring(s_Shots) .. ")")
	else
		print("0 shots?")
	end
end)

Console:Register('Reset', 'reset your accuracy.', function()
	s_Shots = 0
	s_Hits = 0
	print("Reset done")
end)
