Events:Subscribe('Partition:Loaded', function(partition)
	for _,instance in pairs(partition.instances) do
		if instance.instanceGuid == Guid("D3B9DF55-7BD7-401E-AF84-071BFDD9689D", 'D') then
			healthperkL1 = ValueUnlockAsset(instance)
		end
		if instance.instanceGuid == Guid("532F6C61-7400-4D46-9E54-866EFC03E4F7", 'D') then
			healthperkL2 = ValueUnlockAsset(instance)
		end
		if instance:Is("VeniceSoldierCustomizationAsset") then
			instance = VeniceSoldierCustomizationAsset(instance)
			instance = CustomizationTable(instance.specializationTable)
			instance = CustomizationUnlockParts(instance.unlockParts[1])
			instance:MakeWritable()
			instance.selectableUnlocks:add(healthperkL1)
			instance.selectableUnlocks:add(healthperkL2)
		end
	end
end)