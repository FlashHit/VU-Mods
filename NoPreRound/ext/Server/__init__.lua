local OnPreRoundEntityDataCallback = function(p_Instance)
	p_Instance = PreRoundEntityData(p_Instance)
	p_Instance:MakeWritable()
	p_Instance.enabled = false
end

ResourceManager:RegisterInstanceLoadHandler(Guid('0C342A8C-BCDE-11E0-8467-9159D6ACA94C'), Guid('B3AF5AF0-4703-402C-A238-601E610A0B48'), OnPreRoundEntityDataCallback)
ResourceManager:RegisterInstanceLoadHandler(Guid('57F399B3-70DD-11E0-9327-ED63059941A3'), Guid('C328EFDC-AF70-4097-B47C-DF4C32E2EC3C'), OnPreRoundEntityDataCallback)
ResourceManager:RegisterInstanceLoadHandler(Guid('9E2ED50A-C01C-49BA-B3BE-9940BD4C5A08'), Guid('15D85ECF-E9F8-414D-A3AD-67E4CD684E6C'), OnPreRoundEntityDataCallback)
ResourceManager:RegisterInstanceLoadHandler(Guid('56364B35-5D80-4874-9D74-CCF829D579D9'), Guid('6C21CE10-43DF-4A8C-92DB-19B0F90A61DC'), OnPreRoundEntityDataCallback)
ResourceManager:RegisterInstanceLoadHandler(Guid('3255E7F8-98D2-4C86-A581-E5A3C7A16BFF'), Guid('E423309A-1486-4C9B-BEBA-97AA82CF5ACA'), OnPreRoundEntityDataCallback)

local OnInputRestrictionEntityDataCallback = function(p_Instance)
	p_Instance = InputRestrictionEntityData(p_Instance)
	p_Instance:MakeWritable()
	p_Instance.enabled = false
end

-- cq / cq assault / tank- / air superiority
ResourceManager:RegisterInstanceLoadHandler(Guid('0C342A8C-BCDE-11E0-8467-9159D6ACA94C'), Guid('E8C37E6A-0C8B-4F97-ABDD-28715376BD2D'), OnInputRestrictionEntityDataCallback)
-- tdm XP4
ResourceManager:RegisterInstanceLoadHandler(Guid('676C0FD7-EA75-4F5D-8764-BB076F6F3E11'), Guid('593710B7-EDC4-4EDB-BE20-323E7B0CE023'), OnInputRestrictionEntityDataCallback)
-- tdm
ResourceManager:RegisterInstanceLoadHandler(Guid('FAD987C1-7D2A-11E0-B283-C22E2A7B7393'), Guid('6F42FBE3-428A-463A-9014-AA0C6E09DA64'), OnInputRestrictionEntityDataCallback)
-- rush / sq rush
ResourceManager:RegisterInstanceLoadHandler(Guid('56364B35-5D80-4874-9D74-CCF829D579D9'), Guid('9EDC59FB-5821-4A37-A739-FE867F251000'), OnInputRestrictionEntityDataCallback)
-- domination / scavenger
ResourceManager:RegisterInstanceLoadHandler(Guid('9E2ED50A-C01C-49BA-B3BE-9940BD4C5A08'), Guid('BF4003AC-4B85-46DC-8975-E6682815204D'), OnInputRestrictionEntityDataCallback)
-- gunmaster XP4
ResourceManager:RegisterInstanceLoadHandler(Guid('F58C83A7-C753-4360-A9C0-4E44C79836F8'), Guid('A0158B87-FA34-4ED2-B752-EBFC1A34B081'), OnInputRestrictionEntityDataCallback)
-- gunmaster
ResourceManager:RegisterInstanceLoadHandler(Guid('F71EE45B-1BB0-4442-A46D-5B079A722230'), Guid('AAF90FE3-D1CA-4CFE-84F3-66C6146AD96F'), OnInputRestrictionEntityDataCallback)
-- sqdm XP4
ResourceManager:RegisterInstanceLoadHandler(Guid('7B941CFA-9955-461B-8390-0789AD9AA1A5'), Guid('753BD81F-07AC-4140-B05C-24210E1DF3FA'), OnInputRestrictionEntityDataCallback)
-- sqdm noVehicles
ResourceManager:RegisterInstanceLoadHandler(Guid('1341E76F-293C-4091-AF99-05DFA3B73CF3'), Guid('CBFB0D7E-8561-4216-9AB2-99E14E9D18D0'), OnInputRestrictionEntityDataCallback)
-- sqdm
ResourceManager:RegisterInstanceLoadHandler(Guid('A2074F27-7D1F-11E0-B283-C22E2A7B7393'), Guid('A40B08B7-D781-487A-8D0C-2E1B911C1949'), OnInputRestrictionEntityDataCallback)



local function _NoPreRound()
	-- This is for Conquest tickets etc.
	local s_TicketCounterIterator = EntityManager:GetIterator("ServerTicketCounterEntity")
	local s_TicketCounterEntity = s_TicketCounterIterator:Next()

	while s_TicketCounterEntity do
		s_TicketCounterEntity:FireEvent('StartRound')
		s_TicketCounterEntity = s_TicketCounterIterator:Next()
	end

	-- This is for Rush tickets etc.
	local s_LifeCounterIterator = EntityManager:GetIterator("ServerLifeCounterEntity")
	local s_LifeCounterEntity = s_LifeCounterIterator:Next()

	while s_LifeCounterEntity do
		s_LifeCounterEntity:FireEvent('StartRound')
		s_LifeCounterEntity = s_LifeCounterIterator:Next()
	end

	-- This is for TDM tickets etc.
	local s_KillCounterIterator = EntityManager:GetIterator("ServerKillCounterEntity")
	local s_KillCounterEntity = s_KillCounterIterator:Next()

	while s_KillCounterEntity do
		s_KillCounterEntity:FireEvent('StartRound')
		s_KillCounterEntity = s_KillCounterIterator:Next()
	end

	-- This Entity is needed so the round ends when tickets are reached
	local s_RoundOverIterator = EntityManager:GetIterator("ServerRoundOverEntity")
	local s_RoundOverEntity = s_RoundOverIterator:Next()

	while s_RoundOverEntity do
		s_RoundOverEntity:FireEvent('RoundStarted')
		s_RoundOverEntity = s_RoundOverIterator:Next()
	end

	-- This EventGate needs to be closed otherwise Attacker can't win in Rush
	local s_EventGateIterator = EntityManager:GetIterator("EventGateEntity")
	local s_EventGateEntity = s_EventGateIterator:Next()

	while s_EventGateEntity do
		if s_EventGateEntity.data.instanceGuid == Guid('253BD7C1-920E-46D6-B112-5857D88DAF41') then
			s_EventGateEntity:FireEvent('Close')
		end

		s_EventGateEntity = s_EventGateIterator:Next()
	end
end

Events:Subscribe('Level:Loaded', _NoPreRound)
