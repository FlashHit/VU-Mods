class 'HotReloadClass'

function HotReloadClass:__init()
    Events:Subscribe('Extension:Loaded', self, self.OnExtensionLoaded)
end

function HotReloadClass:OnExtensionLoaded()
    self.m_IsHotReload = self:GetIsHotReload()
	print("Hotreload? " .. tostring(self.m_IsHotReload))
end

function HotReloadClass:GetIsHotReload()
    if #SharedUtils:GetContentPackages() == 0 then
        return false
    else
        return true
    end
end

if g_HotReloadClass == nil then
    g_HotReloadClass = HotReloadClass()
end
