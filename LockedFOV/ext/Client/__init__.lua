local s_LockedFOV = 103

local s_HudEventCallback = nil

local s_Timer = -1

local RegisterEvent = function()
	if s_HudEventCallback ~= nil then
		print("Event already registered")
		return
	end

	local s_EntityIterator = EntityManager:GetIterator('ClientUIGraphEntity')
	local s_Entity = s_EntityIterator:Next()

	while s_Entity do
		if s_Entity.data ~= nil and s_Entity.data.instanceGuid == Guid("133D3825-5F17-4210-A4DB-3694FDBAD26D") then
			s_HudEventCallback = s_Entity:RegisterEventCallback(function(p_Entity, p_EntityEvent)
				s_Timer = 0
			end)

			return
		end

		s_Entity = s_EntityIterator:Next()
	end
end

local UnregisterEvent = function()
	if s_HudEventCallback ~= nil then
		local s_EntityIterator = EntityManager:GetIterator('ClientUIGraphEntity')
		local s_Entity = s_EntityIterator:Next()

		while s_Entity do
			if s_Entity.data ~= nil and s_Entity.data.instanceGuid == Guid("133D3825-5F17-4210-A4DB-3694FDBAD26D") then
				s_Entity:UnregisterEventCallback(s_HudEventCallback)
				s_HudEventCallback = nil
				return
			end

			s_Entity = s_EntityIterator:Next()
		end
	end
end

function ChangeFOV()
	local s_GameRenderSettings = ResourceManager:GetSettings("GameRenderSettings")

	if s_GameRenderSettings == nil then
		print("GameRenderSettings not found.")
		return
	end

	s_GameRenderSettings = GameRenderSettings(s_GameRenderSettings)
	s_GameRenderSettings.fovMultiplier = HDEGtoVDEG(s_LockedFOV) / 55
end

Events:Subscribe('Extension:Loaded', RegisterEvent)
Events:Subscribe('Level:Loaded', RegisterEvent)

Events:Subscribe('Level:Destroy', UnregisterEvent)
Events:Subscribe('Extension:Unloading', UnregisterEvent)


Events:Subscribe('Engine:Update', function(p_DeltaTime, p_SimulationDeltaTime)
	if s_Timer == -1 then
		return
	end

	s_Timer = s_Timer + p_DeltaTime

	if s_Timer < 1.0 then
		return
	end

	ChangeFOV()
	s_Timer = -1
end)

function HDEGtoVDEG(p_Value)
	local sixteenNine = 16 / 9
	local fourThree = 4 / 3 -- For BF3 values
	local vfovRad = tonumber(p_Value) * math.pi / 180
	local hfovRad = math.atan(math.tan(vfovRad / 2)/ sixteenNine) * 2
	local endFov = hfovRad / math.pi * 180
	return endFov
end
