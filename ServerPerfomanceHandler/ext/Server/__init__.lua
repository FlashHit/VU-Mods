local s_CumulatedTime = 0
local s_LastFps = 99999
local s_ServerHz = 30
local s_Done = false
local s_DefaultPlayerCount = 24

Events:Subscribe('Engine:Update', function(p_DeltaTime, p_SimulationDeltaTime)
    s_CumulatedTime = s_CumulatedTime + p_DeltaTime

	if s_CumulatedTime >= 30 then
		
		s_CumulatedTime = 0
		
		local s_Fps = RCON:SendCommand('vu.FpsMa')
		s_Fps = tonumber(s_Fps[2])
		
		if s_LastFps < (s_ServerHz + 15) and s_Fps < (s_ServerHz + 15) then
			
			local s_PlayerCount = PlayerManager:GetPlayerCount()
			
			local s_LowerPlayerCount = nil
			if s_PlayerCount > 3 then
				if (s_PlayerCount % 2 == 0) then
					s_LowerPlayerCount = s_PlayerCount - 2
				else
					s_LowerPlayerCount = s_PlayerCount - 3
				end
			else
				s_LowerPlayerCount = 2
			end
			
			RCON:SendCommand('vars.maxPlayers', {tostring(s_LowerPlayerCount)})
			
			local s_MaxPlayerCount = RCON:SendCommand('vars.maxPlayers')
			s_MaxPlayerCount = s_MaxPlayerCount[2]
			
			print("CAUTION: FPS is LOWER then server frequency. FPS: " .. s_Fps .. ". Set vars.maxPlayers to " .. s_MaxPlayerCount)
			
			s_CumulatedTime = -30
			s_LastFps = 99999
			
		elseif s_LastFps > (s_ServerHz + 25) and s_Fps > (s_ServerHz + 25) then
		
			local s_MaxPlayerCount = RCON:SendCommand('vars.maxPlayers')
			s_MaxPlayerCount = tonumber(s_MaxPlayerCount[2])
			
			if s_DefaultPlayerCount > s_MaxPlayerCount then
				
				s_MaxPlayerCount = s_MaxPlayerCount + 2
				
				if s_MaxPlayerCount <= 128 then
					RCON:SendCommand('vars.maxPlayers', {tostring(s_MaxPlayerCount)})
				end
				
				s_MaxPlayerCount = RCON:SendCommand('vars.maxPlayers')
				s_MaxPlayerCount = tonumber(s_MaxPlayerCount[2])
				
				print("FPS is HIGHER then server frequency. FPS: " .. s_Fps .. ". Set vars.maxPlayers to " .. s_MaxPlayerCount)
				
				s_CumulatedTime = -30
				s_LastFps = 99999
				
			end
			
		end
		
		s_LastFps = s_Fps
	end
end)

Events:Subscribe('Level:Loaded', function()
	if not s_Done then
		
		s_Done = true
		
		local s_FrequencyMode = RCON:SendCommand('vu.FrequencyMode')
		if s_FrequencyMode[2] == "high60" then
			s_ServerHz = 60
		elseif s_FrequencyMode[2] == "high120" then
			s_ServerHz = 120
		else
			s_ServerHz = 30
		end
		
		local s_MaxPlayerCount = RCON:SendCommand('vars.maxPlayers')
		s_DefaultPlayerCount = tonumber(s_MaxPlayerCount[2])
	
	end
end)