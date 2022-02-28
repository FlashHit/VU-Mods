---@param p_Player Player|nil
---@param p_RecipientMask integer
---@param p_Message string
Events:Subscribe('Player:Chat', function(p_Player, p_RecipientMask, p_Message)
	if tonumber(p_Message) and p_Player.soldier then
		local s_EntityIterator = EntityManager:GetIterator('PropertyCastEntity')
		local s_Entity = s_EntityIterator:Next()

		while s_Entity do
			if s_Entity.data and s_Entity.data.instanceGuid == Guid("51A231A1-CCBA-3DEF-1E3B-A28F5AE67188") and s_Entity.bus == p_Player.soldier.bus then
				print("set property")
				s_Entity:PropertyChanged("FloatValue", tonumber(p_Message))
				return
			end

			s_Entity = s_EntityIterator:Next()
		end
	end
end)
