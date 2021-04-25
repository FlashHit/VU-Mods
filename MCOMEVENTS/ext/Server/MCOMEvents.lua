Events:Subscribe('Level:Loaded', function()
	local s_Iterator = EntityManager:GetIterator("EventSplitterEntity")
	local s_Entity = s_Iterator:Next()
	while s_Entity do
		if s_Entity.data == nil then
			goto continue_entity_loop
		end
		if s_Entity.data.instanceGuid == Guid("87E78B77-78F9-4DE0-82FF-904CDC2F7D03") then
			s_Entity:RegisterEventCallback(function(p_Entity, p_EntityEvent)
				Events:Dispatch('MCOM:Armed', p_EntityEvent.player)
			end)
		elseif s_Entity.data.instanceGuid == Guid("74B7AD6D-8EB5-40B1-BB53-C0CFB956048E") then
			s_Entity:RegisterEventCallback(function(p_Entity, p_EntityEvent)
				Events:Dispatch('MCOM:Disarmed', p_EntityEvent.player)
			end)
		elseif s_Entity.data.instanceGuid == Guid("70B36E2F-0B6F-40EC-870B-1748239A63A8") then
			s_Entity:RegisterEventCallback(function(p_Entity, p_EntityEvent)
				Events:Dispatch('MCOM:Destroyed', p_EntityEvent.player)
			end)
		end
		::continue_entity_loop::
		s_Entity = s_Iterator:Next()
	end
end)
