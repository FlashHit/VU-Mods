Hooks:Install('BulletEntity:Collision', 1, function(p_HookCtx, p_Entity, p_Hit, p_Shooter)
	if p_Entity.data ~= nil and p_Entity.data.instanceGuid == Guid("1861554A-8C81-4944-96D1-7347494F7688") then
		return
	end
	if p_Hit.rigidBody:Is('RagdollEntity')
	and PhysicsEntityBase(p_Hit.rigidBody).sleeping == true
	and PhysicsEntityBase(p_Hit.rigidBody).userData ~= nil
	and PhysicsEntityBase(p_Hit.rigidBody).userData:Is('ClientSoldierEntity')
	and SoldierEntity(PhysicsEntityBase(p_Hit.rigidBody).userData).internalHealth > 20 then
		p_HookCtx:Return()
	end
end)
