class 'PlayerSpawn'

function PlayerSpawn:__init()
	NetEvents:Subscribe('RequestSpawn', self, self.OnRequestSpawn)
	NetEvents:Subscribe('TriggerSpawn', self, self.TriggerSpawn)
end

-- TODO: Add VehicleSpawn
function PlayerSpawn:OnRequestSpawn(p_Player, s_Table)

	if p_Player.selectedKit == nil then
		-- SoldierBlueprint
		p_Player.selectedKit = ResourceManager:SearchForInstanceByGuid(Guid('261E43BF-259B-41D2-BF3B-9AE4DDA96AD2'))
	end
	
	local s_SoldierKit = ResourceManager:SearchForInstanceByGuid(s_Table[1])
	local s_SoldierPersistance = ResourceManager:SearchForInstanceByGuid(s_Table[2])
	
	
	-- select Kit (USSupport) + Persistance (MP_US_Support_Appearance01)
	p_Player:SelectUnlockAssets(s_SoldierKit, {s_SoldierPersistance})
	
	-- select Weapons
	for i = 3, 8, 1 do 
		local s_Weapon = ResourceManager:SearchForInstanceByGuid(s_Table[i][2])
		local s_Attachments = {}
		if #s_Table[i] == 3 then
			for l_AttachmentIndex, l_AttachmentGuid in pairs(s_Table[i][3]) do
				s_Attachments[l_AttachmentIndex] = ResourceManager:SearchForInstanceByGuid(l_AttachmentGuid)
			end
		end
		p_Player:SelectWeapon(s_Table[i][1], s_Weapon, s_Attachments)
	end
	
	if s_Table[10] then
		-- dont even try 
		self:VehicleSpawn(p_Player, s_Table[9])
		return
	end
	
	self:TriggerSpawn(p_Player, s_Table[9])
	
end

function PlayerSpawn:TriggerSpawn(p_Player, p_TargetSpawn)
	local s_CurrentGameMode = SharedUtils:GetCurrentGameMode()
	if s_CurrentGameMode:match("DeathMatch") or 
	s_CurrentGameMode:match("Domination") or 
	s_CurrentGameMode:match("GunMaster") or
	s_CurrentGameMode:match("Scavenger") or
	s_CurrentGameMode:match("TankSuperiority") or
	s_CurrentGameMode:match("CaptureTheFlag") then
		
		self:DeathMatchSpawn(p_Player)
		
	elseif s_CurrentGameMode:match("Rush") then
		-- seems to be the same as DeathMatchSpawn
		-- but it has vehicles
		self:RushSpawn(p_Player)
		
	elseif s_CurrentGameMode:match("Conquest") then
		-- event + target spawn ("ID_H_US_B", "_ID_H_US_HQ", etc.)
		self:ConquestSpawn(p_Player, p_TargetSpawn)
	end
end

function PlayerSpawn:DeathMatchSpawn(p_Player)
	local s_Event = ServerPlayerEvent("Spawn", p_Player, true, false, false, false, false, false, p_Player.teamId)
	local s_EntityIterator = EntityManager:GetIterator("ServerCharacterSpawnEntity")
	local s_Entity = s_EntityIterator:Next()
	while s_Entity do
		if s_Entity.data:Is('CharacterSpawnReferenceObjectData') then
			print("TeamID: " .. CharacterSpawnReferenceObjectData(s_Entity.data).team)
			if CharacterSpawnReferenceObjectData(s_Entity.data).team == p_Player.teamId then
				s_Entity:FireEvent(s_Event)
				return
			end
		end
		s_Entity = s_EntityIterator:Next()
	end
end

function PlayerSpawn:RushSpawn(p_Player)
	local s_Event = ServerPlayerEvent("Spawn", p_Player, true, false, false, false, false, false, p_Player.teamId)
	local s_EntityIterator = EntityManager:GetIterator("ServerCharacterSpawnEntity")
	local s_Entity = s_EntityIterator:Next()
	while s_Entity do
		if s_Entity.data:Is('CharacterSpawnReferenceObjectData') then
			
			print("TeamID: " .. CharacterSpawnReferenceObjectData(s_Entity.data).team)
			if CharacterSpawnReferenceObjectData(s_Entity.data).team == p_Player.teamId then
				for i, l_Entity in pairs(s_Entity.bus.entities) do
					if l_Entity:Is("ServerVehicleSpawnEntity") then
						print("SKIP")
						goto skip
					end
				end
				print("Spawn me now")
				print(s_Entity.data.instanceGuid)
				-- Behaviour: if we take both mcoms they spawns change, and here we see the entity order changes as well, the first entity is always the right one
				-- the guid changes
				s_Entity:FireEvent(s_Event)
				return
			end
		end
		::skip::
		s_Entity = s_EntityIterator:Next()
	end
end

function PlayerSpawn:ConquestSpawn(p_Player, p_TargetSpawn)
	local s_Event = ServerPlayerEvent("Spawn", p_Player, true, false, false, false, false, false, p_Player.teamId)	
	local s_EntityIterator = EntityManager:GetIterator("ServerCapturePointEntity")
	local s_Entity = s_EntityIterator:Next()
	while s_Entity do
		s_Entity = CapturePointEntity(s_Entity)
		print(s_Entity.name)
		if s_Entity.name == p_TargetSpawn then
			for i, l_Entity in pairs(s_Entity.bus.entities) do
				if l_Entity:Is('ServerCharacterSpawnEntity') then
					print(CharacterSpawnReferenceObjectData(l_Entity.data).team)
					if CharacterSpawnReferenceObjectData(l_Entity.data).team == p_Player.teamId 
					or CharacterSpawnReferenceObjectData(l_Entity.data).team == 0 then
						print("Spawn me now")
						l_Entity:FireEvent(s_Event)
						return
					end
				end
			end
		end
		s_Entity = s_EntityIterator:Next()
	end
end

-- not working yet
-- getting the coordinates is possible
-- but getting the vehicle names in a VehicleEntity would be better
function PlayerSpawn:VehicleSpawn(p_Player, p_TargetSpawn)
	local s_Event = ServerPlayerEvent("Spawn", p_Player, true, false, false, false, false, false, p_Player.teamId)
	local s_EntityIterator = EntityManager:GetIterator("ServerCharacterSpawnEntity")
	local s_Entity = s_EntityIterator:Next()
		
	while s_Entity do
		if s_Entity.data:Is('CharacterSpawnReferenceObjectData') then
			
			if CharacterSpawnReferenceObjectData(s_Entity.data).team == p_Player.teamId then
				for i, l_Entity in pairs(s_Entity.bus.entities) do
					if l_Entity:Is('ServerVehicleSpawnEntity') then
						--if Asset(VehicleSpawnReferenceObjectData(l_Entity.data).blueprint).name == p_TargetSpawn then
							print("TeamID: " .. CharacterSpawnReferenceObjectData(s_Entity.data).team)
							print(Asset(VehicleSpawnReferenceObjectData(l_Entity.data).blueprint).name)
							if l_Entity.bus.parentRepresentative ~= nil then
								print(l_Entity.bus.parentRepresentative.instanceGuid)
								-----for k, l_ParentEntity in pairs(l_Entity.bus.parent.entities) do
								------	if l_ParentEntity.data ~= nil and l_Entity.bus.parentRepresentative == l_ParentEntity.data then
								---		print("match found")
										--s_Entity:FireEvent(s_Event)
										--return
								----	end
								------end
							end
						--end
					end
				end
			end
		end
		s_Entity = s_EntityIterator:Next()
	end
end

g_PlayerSpawn = PlayerSpawn()
