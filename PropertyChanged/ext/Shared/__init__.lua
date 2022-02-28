---@param p_Partition DatabasePartition
Events:Subscribe('Partition:Loaded', function(p_Partition)
	if p_Partition.name ~= "characters/soldiers/mpsoldier" then
		return
	end

	local s_Blueprint = SoldierBlueprint(p_Partition.primaryInstance)
	s_Blueprint:MakeWritable()

	local s_PropertyCastEntityData = PropertyCastEntityData(Guid("51A231A1-CCBA-3DEF-1E3B-A28F5AE67188"))
	s_PropertyCastEntityData.isPropertyConnectionTarget = Realm.Realm_ClientAndServer
	s_PropertyCastEntityData.indexInBlueprint = 167
	p_Partition:AddInstance(s_PropertyCastEntityData)

	for i = #s_Blueprint.propertyConnections, 1, -1 do
		if s_Blueprint.propertyConnections[i].targetFieldId == MathUtils:FNVHash("SprintMultiplier") then
			s_Blueprint.propertyConnections[i].source = s_PropertyCastEntityData
			s_Blueprint.propertyConnections[i].sourceFieldId = MathUtils:FNVHash("CastToFloat")	
		end
	end

	local s_SoldierEntityData = SoldierEntityData(s_Blueprint.object)
	s_SoldierEntityData:MakeWritable()
	s_SoldierEntityData.components:add(s_PropertyCastEntityData)

	print("done")
end)
