Events:Subscribe('Partition:Loaded', function(partition)
	for _, instance in pairs(partition.instances) do
		if instance:Is('PreRoundEntityData') then
			instance = PreRoundEntityData(instance)
			instance:MakeWritable()
			instance.enabled = false
		end
	end
end)

Events:Subscribe('Level:Loaded', function()

	-- This is for Conquest tickets etc.
	local ticketCounterIterator = EntityManager:GetIterator("ServerTicketCounterEntity")
	
	local ticketCounterEntity = ticketCounterIterator:Next()
	while ticketCounterEntity do

		ticketCounterEntity = Entity(ticketCounterEntity)
		ticketCounterEntity:FireEvent('StartRound')
		ticketCounterEntity = ticketCounterIterator:Next()
	end
	
	-- This is for Rush tickets etc.
	local lifeCounterIterator = EntityManager:GetIterator("ServerLifeCounterEntity")
	
	local lifeCounterEntity = lifeCounterIterator:Next()
	while lifeCounterEntity do

		lifeCounterEntity = Entity(lifeCounterEntity)
		lifeCounterEntity:FireEvent('StartRound')
		lifeCounterEntity = lifeCounterIterator:Next()
	end
	
	-- This is for TDM tickets etc.
	local killCounterIterator = EntityManager:GetIterator("ServerKillCounterEntity")
	
	local killCounterEntity = killCounterIterator:Next()
	while killCounterEntity do

		killCounterEntity = Entity(killCounterEntity)
		killCounterEntity:FireEvent('StartRound')
		killCounterEntity = killCounterIterator:Next()
	end
	
	-- This is needed so you are able to move
	local inputRestrictionIterator = EntityManager:GetIterator("ServerInputRestrictionEntity")
	
	local inputRestrictionEntity = inputRestrictionIterator:Next()
	while inputRestrictionEntity do
		if inputRestrictionEntity.data.instanceGuid == Guid('E8C37E6A-0C8B-4F97-ABDD-28715376BD2D') or -- cq / cq assault / tank- / air superiority
		inputRestrictionEntity.data.instanceGuid == Guid('593710B7-EDC4-4EDB-BE20-323E7B0CE023') or -- tdm XP4
		inputRestrictionEntity.data.instanceGuid == Guid('6F42FBE3-428A-463A-9014-AA0C6E09DA64') or -- tdm
		inputRestrictionEntity.data.instanceGuid == Guid('9EDC59FB-5821-4A37-A739-FE867F251000') or -- rush / sq rush
		inputRestrictionEntity.data.instanceGuid == Guid('BF4003AC-4B85-46DC-8975-E6682815204D') or -- domination / scavenger
		inputRestrictionEntity.data.instanceGuid == Guid('A0158B87-FA34-4ED2-B752-EBFC1A34B081') or -- gunmaster XP4
		inputRestrictionEntity.data.instanceGuid == Guid('AAF90FE3-D1CA-4CFE-84F3-66C6146AD96F') or -- gunmaster
		inputRestrictionEntity.data.instanceGuid == Guid('753BD81F-07AC-4140-B05C-24210E1DF3FA') or -- sqdm XP4
		inputRestrictionEntity.data.instanceGuid == Guid('CBFB0D7E-8561-4216-9AB2-99E14E9D18D0') or -- sqdm noVehicles
		inputRestrictionEntity.data.instanceGuid == Guid('A40B08B7-D781-487A-8D0C-2E1B911C1949') then -- sqdm
			inputRestrictionEntity = Entity(inputRestrictionEntity)
			inputRestrictionEntity:FireEvent('Disable')
		end
		inputRestrictionEntity = inputRestrictionIterator:Next()
	end
	
	-- This Entity is needed so the round ends when tickets are reached
	local roundOverIterator = EntityManager:GetIterator("ServerRoundOverEntity")
	
	local roundOverEntity = roundOverIterator:Next()
	while roundOverEntity do

		roundOverEntity = Entity(roundOverEntity)
		roundOverEntity:FireEvent('RoundStarted')
		
		roundOverEntity = roundOverIterator:Next()
	end
	
	-- This EventGate needs to be closed otherwise Attacker can't win in Rush 
	local eventGateIterator = EntityManager:GetIterator("EventGateEntity")
	
	local eventGateEntity = eventGateIterator:Next()
	while eventGateEntity do

		eventGateEntity = Entity(eventGateEntity)
		if eventGateEntity.data.instanceGuid == Guid('253BD7C1-920E-46D6-B112-5857D88DAF41') then
			eventGateEntity:FireEvent('Close')
		end
		eventGateEntity = eventGateIterator:Next()
	end
end)