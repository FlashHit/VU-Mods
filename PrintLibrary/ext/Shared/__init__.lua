class 'ExampleClass'

function ExampleClass:__init()

	self.m_PrintLibrary = require '__shared/PrintLibrary'
	
	Events:Subscribe('Level:Loaded', function(partition)
		instance = CapturePointEntityData(ResourceManager:FindInstanceByGuid(Guid('09EC6C92-BCE4-11E0-8467-9159D6ACA94C'), Guid('237DADC8-CF6A-4D39-BFBA-65CAAB6DC46A')))
		self.m_PrintLibrary:Print(instance)
		-- or self.m_PrintLibrary:Print(instance, "customName")
	end)
	
end

g_ExampleClass = ExampleClass()