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
		if giverInfo.giver.soldier.weaponsComponent.currentWeapon.weaponModifier.weaponProjectileModifier ~= nil and giverInfo.giver.soldier.weaponsComponent.currentWeapon.weaponModifier.weaponProjectileModifier.projectileData ~= nil then
			bullet = BulletEntityData(giverInfo.giver.soldier.weaponsComponent.currentWeapon.weaponModifier.weaponProjectileModifier.projectileData)
		end
		local materialIndexMapIndex = bullet.materialPair.physicsPropertyIndex
		if materialIndexMapIndex < 0 then
			materialIndexMapIndex = 256 + materialIndexMapIndex
		end
		local materialGridItems = MaterialInteractionGridRow(materialGrid.interactionGrid[materialGrid.materialIndexMap[materialIndexMapIndex+1]+1]).items
		local multiplier = MaterialRelationDamageData(materialGridItems[boneToMaterialMap[info.boneIndex+1]+1].physicsPropertyProperties[1]).damageProtectionMultiplier
		local damageLimit = bullet.startDamage * multiplier 
		
		
		local shotDistance = info.position:Distance(info.origin)
		
		if (shotDistance >= bullet.damageFalloffEndDistance) then

			damageLimit = bullet.endDamage * multiplier

		elseif (shotDistance > bullet.damageFalloffStartDistance) then
			
			local damageFalloffMax = (bullet.startDamage - bullet.endDamage)
			-- 25.0 - 18.4 = 6.6
			
			local distanceRange = (bullet.damageFalloffEndDistance - bullet.damageFalloffStartDistance)
			-- 50.0 - 8.0 = 42.0
			
			local distancePercentage = (shotDistance - bullet.damageFalloffStartDistance) / distanceRange
			-- 50.0 - 8.0 / 42.0 = 1.00
			
			damageLimit = bullet.startDamage - (damageFalloffMax * distancePercentage) * multiplier
			-- 25.0 - (6.6 * 1.00) * 1.0 = 18.4
		
		end
		
		if (damageLimit < info.damage - 0.5) then
			info.damage = damageLimit
			hook:Pass(soldier, info, giverInfo)
		end
	end
end)

Events:Subscribe('Level:Loaded', function(levelName, gameMode, round, roundsPerMap)
	materialGrid = MaterialGridData(ResourceManager:SearchForDataContainer(SharedUtils:GetLevelName() .. "/MaterialGrid_Win32/Grid"))
	boneToMaterialMap = { materialGrid.materialIndexMap[158+1], materialGrid.materialIndexMap[65+1], materialGrid.materialIndexMap[66+1], materialGrid.materialIndexMap[66+1], materialGrid.materialIndexMap[91+1], materialGrid.materialIndexMap[91+1] }
end)

Events:Subscribe('Level:Destroy', function()
	boneToMaterialMap = nil
	materialGrid = nil
end) 
