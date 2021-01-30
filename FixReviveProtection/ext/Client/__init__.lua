Hooks:Install('BulletEntity:Collision', 1, function(hook, entity, hit, shooter)
    if hit.rigidBody:Is('RagdollEntity') then
		hook:Return()
	end
end)