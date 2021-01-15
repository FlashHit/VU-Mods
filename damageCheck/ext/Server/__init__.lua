local materialGrid = nil
local boneToMaterialMap = nil
		
Hooks:Install('Soldier:Damage', 1, function(hook, soldier, info, giverInfo)
	if giverInfo == nil or giverInfo.weaponFiring == nil then -- or giverInfo.giver == nil 
		return
	end
	if giverInfo.assist ~= nil then 
		return 
	end
	if info.isBulletDamage == false then
		return
	end
	if (info.boneIndex >= 0 and info.boneIndex <= 5) then

		local bullet = BulletEntityData(WeaponFiringData(giverInfo.weaponFiring).primaryFire.shot.projectileData)
		local materialGridItems = MaterialInteractionGridRow(materialGrid.interactionGrid[materialGrid.materialIndexMap[bullet.materialPair.physicsPropertyIndex+1]+1]).items
		local multiplier = MaterialRelationDamageData(materialGridItems[boneToMaterialMap[info.boneIndex+1]+1].physicsPropertyProperties[1]).damageProtectionMultiplier
		local damageLimit = bullet.startDamage * multiplier 
		
		if (damageLimit < info.damage - 0.5) then
			info.damage = bullet.endDamage * multiplier
			hook:Pass(soldier, info, giverInfo)
		end
	end
end)

Events:Subscribe('Level:Loaded', function(levelName, gameMode, round, roundsPerMap)
	materialGrid = MaterialGridData(ResourceManager:SearchForDataContainer(SharedUtils:GetLevelName() .. "/MaterialGrid_Win32/Grid"))
	boneToMaterialMap = { materialGrid.materialIndexMap[158+1], materialGrid.materialIndexMap[66+1], materialGrid.materialIndexMap[67+1], materialGrid.materialIndexMap[67+1], materialGrid.materialIndexMap[91+1], materialGrid.materialIndexMap[91+1] }
end)

Events:Subscribe('Level:Destroy', function()
	boneToMaterialMap = nil
	materialGrid = nil
end)
