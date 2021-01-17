local materialGrid = nil
		
Hooks:Install('Soldier:Damage', 1, function(hook, soldier, info, giverInfo)
	if giverInfo == nil or giverInfo.weaponFiring == nil or giverInfo.giver == nil or giverInfo.giver.soldier == nil then
		return
	end
	if giverInfo.assist ~= nil then 
		return 
	end
	if info.isBulletDamage == false then
		return
	end

	local bullet = BulletEntityData(WeaponFiringData(giverInfo.weaponFiring).primaryFire.shot.projectileData)
	if giverInfo.giver.soldier.weaponsComponent.currentWeapon.weaponModifier.weaponProjectileModifier ~= nil and giverInfo.giver.soldier.weaponsComponent.currentWeapon.weaponModifier.weaponProjectileModifier.projectileData ~= nil then
		bullet = BulletEntityData(giverInfo.giver.soldier.weaponsComponent.currentWeapon.weaponModifier.weaponProjectileModifier.projectileData)
	elseif giverInfo.giver.soldier.weaponsComponent.currentWeapon.weaponModifier.weaponFiringDataModifier ~= nil and giverInfo.giver.soldier.weaponsComponent.currentWeapon.weaponModifier.weaponFiringDataModifier.weaponFiring ~= nil then
		bullet = BulletEntityData(WeaponFiringData(giverInfo.giver.soldier.weaponsComponent.currentWeapon.weaponModifier.weaponFiringDataModifier.weaponFiring).primaryFire.shot.projectileData)
	end
	
	-- temp. avoid/ignore shotguns
	if bullet.hitReactionWeaponType == AntHitReactionWeaponType.AntHitReactionWeaponType_Shotgun then
		return
	end	
		
	local materialIndexMapIndex1 = bullet.materialPair.physicsPropertyIndex
	if materialIndexMapIndex1 < 0 then
		materialIndexMapIndex1 = 256 + materialIndexMapIndex1
	end
	
	local materialIndexMapIndex2 = MaterialContainerPair(info.damagedMaterial).physicsPropertyIndex
	if materialIndexMapIndex2 < 0 then
		materialIndexMapIndex2 = 256 + materialIndexMapIndex2
	end

	local materialGridItems = MaterialInteractionGridRow(materialGrid.interactionGrid[materialGrid.materialIndexMap[materialIndexMapIndex1+1]+1]).items
	local materialRelationDamageData = materialGridItems[materialGrid.materialIndexMap[materialIndexMapIndex2+1]+1]

	local multiplier = 1.0
	for i,physicsPropertyProperty in pairs(materialRelationDamageData.physicsPropertyProperties) do
		if physicsPropertyProperty:Is('MaterialRelationDamageData') then
			multiplier = MaterialRelationDamageData(physicsPropertyProperty).damageProtectionMultiplier
		end
	end

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

		damageLimit = (bullet.startDamage - (damageFalloffMax * distancePercentage)) * multiplier
		-- 25.0 - (6.6 * 1.00) * 1.0 = 18.4

	end

	if (damageLimit < info.damage - 0.5) then
		info.damage = damageLimit
		hook:Pass(soldier, info, giverInfo)
	end
end)

Events:Subscribe('Level:Loaded', function(levelName, gameMode, round, roundsPerMap)
	materialGrid = MaterialGridData(ResourceManager:SearchForDataContainer(SharedUtils:GetLevelName() .. "/MaterialGrid_Win32/Grid"))
end)

Events:Subscribe('Level:Destroy', function()
	materialGrid = nil
end) 
