local s_Delay = false
local s_CumulatedTime = 0
local s_Timer = 0.175

Events:Subscribe('Player:Respawn', function(p_Player)
	local s_LocalPlayer = PlayerManager:GetLocalPlayer() 
	if p_Player == s_LocalPlayer then
		s_Delay = true
	end
end)


Events:Subscribe('Engine:Update', function(p_DeltaTime)
	if s_Delay == false then
		return
	end
	
	s_CumulatedTime = s_CumulatedTime + p_DeltaTime
	
	if s_CumulatedTime >= s_Timer then
		
		s_CumulatedTime = 0
		s_Delay = false
		
		local s_clientUIGraphEntityIterator = EntityManager:GetIterator("ClientUIGraphEntity")
		
		local s_clientUIGraphEntity = s_clientUIGraphEntityIterator:Next()
		
		while s_clientUIGraphEntity do
			
			if s_clientUIGraphEntity.data.instanceGuid == Guid('9F8D5FCA-9B2A-484F-A085-AFF309DC5B7A') then
				
				s_clientUIGraphEntity = Entity(s_clientUIGraphEntity)
				s_clientUIGraphEntity:FireEvent('ShowCrosshair')	
				return
				
			end
			
			s_clientUIGraphEntity = s_clientUIGraphEntityIterator:Next()
		
		end
	end
end)