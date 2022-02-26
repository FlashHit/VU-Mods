local m_InitialSimRate = nil

local function _SetSimFPS()
	---@type DataContainer|GameTimeSettings|nil
	local s_GameTimeSettings = ResourceManager:GetSettings('GameTimeSettings')

	if s_GameTimeSettings ~= nil then
		s_GameTimeSettings = GameTimeSettings(s_GameTimeSettings)

		if s_GameTimeSettings.maxSimFps > 200.0 then
			return
		end

		m_InitialSimRate = s_GameTimeSettings.maxSimFps
		s_GameTimeSettings.maxSimFps = 10000.0
	end
end

local function _ResetSimFPS()
	if m_InitialSimRate == nil then
		return
	end

	---@type DataContainer|GameTimeSettings|nil
	local s_GameTimeSettings = ResourceManager:GetSettings('GameTimeSettings')

	if s_GameTimeSettings ~= nil then
		s_GameTimeSettings = GameTimeSettings(s_GameTimeSettings)
		s_GameTimeSettings.maxSimFps = m_InitialSimRate
		m_InitialSimRate = nil
	end
end

Events:Subscribe('Level:LoadResources', _SetSimFPS)
Events:Subscribe('Level:Loaded', _ResetSimFPS)
Events:Subscribe('Extension:Unloading', _ResetSimFPS)
