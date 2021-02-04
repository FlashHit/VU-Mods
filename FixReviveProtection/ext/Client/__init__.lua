Hooks:Install('BulletEntity:Collision', 1, function(hook, entity, hit, shooter)
    if hit.rigidBody:Is('RagdollEntity') 
	and PhysicsEntityBase(hit.rigidBody).sleeping == true
	and PhysicsEntityBase(hit.rigidBody).userData ~= nil 
	and PhysicsEntityBase(hit.rigidBody).userData:Is('ClientSoldierEntity') 
	and SoldierEntity(PhysicsEntityBase(hit.rigidBody).userData).internalHealth > 20 then
		hook:Return()
	end
end)