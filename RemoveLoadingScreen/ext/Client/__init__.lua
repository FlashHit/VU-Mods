require "LoadingScreenTable"

Events:Subscribe('Extension:Loaded', function()
	for _, l_LevelLoadingScreenInfo in pairs(LoadingScreenTable) do
		local s_UILevelDescriptionComponent = ResourceManager:FindInstanceByGuid(table.unpack(l_LevelLoadingScreenInfo.Guids))

		if s_UILevelDescriptionComponent ~= nil then
			s_UILevelDescriptionComponent = UILevelDescriptionComponent(s_UILevelDescriptionComponent)
			s_UILevelDescriptionComponent:MakeWritable()
			s_UILevelDescriptionComponent.loadingMusicPath = ""
			s_UILevelDescriptionComponent.loadingImagePath = ""
			s_UILevelDescriptionComponent.mpLoadingAssetPath = ""
		end
	end
end)

Events:Subscribe('Extension:Unloading', function()
	for _, l_LevelLoadingScreenInfo in pairs(LoadingScreenTable) do
		local s_UILevelDescriptionComponent = ResourceManager:FindInstanceByGuid(table.unpack(l_LevelLoadingScreenInfo.Guids))

		if s_UILevelDescriptionComponent ~= nil then
			s_UILevelDescriptionComponent = UILevelDescriptionComponent(s_UILevelDescriptionComponent)
			s_UILevelDescriptionComponent.loadingMusicPath = l_LevelLoadingScreenInfo.LoadingMusicPath
			s_UILevelDescriptionComponent.loadingImagePath = l_LevelLoadingScreenInfo.LoadingImagePath
			s_UILevelDescriptionComponent.mpLoadingAssetPath = "UI/Assets/LoadingScreen"
		end
	end
end)
