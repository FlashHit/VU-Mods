-- disable the vanilla killcam
ResourceManager:RegisterInstanceLoadHandler(Guid('9BD8BDF3-C1CA-11E0-BB8D-A338A0111AEF'), Guid('DE7D2AA7-6F41-99A6-8236-0FDFFCAE320F'), function(p_Instance)
	p_Instance = LogicPrefabBlueprint(p_Instance)
	p_Instance:MakeWritable()
	p_Instance.eventConnections:clear()
end)

-- disable the kill screen
-- prevent delay from getting overwritten by propertyconnections
-- set the delay to zero
ResourceManager:RegisterInstanceLoadHandler(Guid('E006FA38-6668-11E0-8215-820026059936'), Guid('7F2573C7-5712-C90F-7328-B82E3C732CE9'), function(p_Instance)
	p_Instance = LogicPrefabBlueprint(p_Instance)
	p_Instance:MakeWritable()

	for l_Index = #p_Instance.eventConnections, 1, -1 do
		if p_Instance.eventConnections[l_Index].source.instanceGuid == Guid("0B65B60C-CD0D-4C89-9E1E-2CC535D36D18") then
			p_Instance.eventConnections:erase(l_Index)
		end
	end

	p_Instance.propertyConnections:clear()

	local s_StartDelayEntityData = p_Instance.partition:FindInstance(Guid("6137EE08-C204-4B4D-89E2-39C9A78C792C"))

	if s_StartDelayEntityData ~= nil then
		s_StartDelayEntityData = DelayEntityData(s_StartDelayEntityData)
		s_StartDelayEntityData:MakeWritable()
		s_StartDelayEntityData.delay = 0.0
	end

	local s_EndDelayEntityData = p_Instance.partition:FindInstance(Guid("2C423F78-0D73-4394-BC60-4BED30F998F3"))

	if s_EndDelayEntityData ~= nil then
		s_EndDelayEntityData = DelayEntityData(s_EndDelayEntityData)
		s_EndDelayEntityData:MakeWritable()
		s_EndDelayEntityData.delay = 0.3
	end
end)
