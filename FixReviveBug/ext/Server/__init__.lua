Hooks:Install('BulletEntity:Collision', 1, function(hook, entity, hit, giverInfo)
	if hit.rigidBody ~= nil 
	and hit.rigidBody:Is("DynamicPhysicsEntity") 
	and entity.data.instanceGuid == Guid('1861554A-8C81-4944-96D1-7347494F7688')
	and PhysicsEntityBase(hit.rigidBody).userData ~= nil 
	and PhysicsEntityBase(hit.rigidBody).userData:Is('ServerSupplySphereEntity') then
		PhysicsEntity(PhysicsEntityBase(hit.rigidBody).userData):FireEvent('Disable')
	end
end)