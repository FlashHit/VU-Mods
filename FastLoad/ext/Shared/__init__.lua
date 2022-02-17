-- Your shared code here
local m_InitialSimRate = 30.0

Events:Subscribe('Level:LoadResources', function()
	---@type DataContainer|GameTimeSettings|nil
	local s_GameTimeSettings = ResourceManager:GetSettings('GameTimeSettings')

	if s_GameTimeSettings ~= nil then
		s_GameTimeSettings = GameTimeSettings(s_GameTimeSettings)
		m_InitialSimRate = s_GameTimeSettings.maxSimFps
		s_GameTimeSettings.maxSimFps = 10000.0
	end
end)

local function ResetSimFPS()
	---@type DataContainer|GameTimeSettings|nil
	local s_GameTimeSettings = ResourceManager:GetSettings('GameTimeSettings')

	if s_GameTimeSettings ~= nil then
		s_GameTimeSettings = GameTimeSettings(s_GameTimeSettings)
		s_GameTimeSettings.maxSimFps = m_InitialSimRate
	end
end

Events:Subscribe('Level:Loaded', function()
	ResetSimFPS()
end)

Events:Subscribe('Extension:Unloading', function()
	ResetSimFPS()
end)
