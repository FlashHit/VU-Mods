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

		inputRestrictionEntity = Entity(inputRestrictionEntity)
		inputRestrictionEntity:FireEvent('Disable')
		
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