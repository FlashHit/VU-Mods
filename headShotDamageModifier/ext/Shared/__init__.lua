local bulletEntityDatas = {}
Events:Subscribe('Partition:Loaded', function(partition)
    for _,instance in pairs(partition.instances) do
        if instance:Is('BulletEntityData') then
            instance = BulletEntityData(instance)
			table.insert(bulletEntityDatas, instance)
        end
    end
end)
Events:Subscribe('Level:Loaded', function()
    local materialGrid = MaterialGridData(ResourceManager:SearchForDataContainer(SharedUtils:GetLevelName() .. "/MaterialGrid_Win32/Grid"))        
	for i,instance in pairs(bulletEntityDatas) do
		if instance.materialPair ~= nil and instance.materialPair.physicsPropertyIndex ~= nil and materialGrid.materialIndexMap[instance.materialPair.physicsPropertyIndex+1] ~= nil then
			MaterialRelationDamageData(MaterialInteractionGridRow(materialGrid.interactionGrid[materialGrid.materialIndexMap[instance.materialPair.physicsPropertyIndex+1]+1]).items[materialGrid.materialIndexMap[65+1]+1].physicsPropertyProperties[1]):MakeWritable()
			MaterialRelationDamageData(MaterialInteractionGridRow(materialGrid.interactionGrid[materialGrid.materialIndexMap[instance.materialPair.physicsPropertyIndex+1]+1]).items[materialGrid.materialIndexMap[65+1]+1].physicsPropertyProperties[1]).damageProtectionMultiplier = MaterialRelationDamageData(MaterialInteractionGridRow(materialGrid.interactionGrid[materialGrid.materialIndexMap[instance.materialPair.physicsPropertyIndex+1]+1]).items[materialGrid.materialIndexMap[65+1]+1].physicsPropertyProperties[1]).damageProtectionMultiplier * 1.5
		end
	end
	bulletEntityDatas = {}
end)