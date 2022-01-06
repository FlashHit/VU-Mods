---@param p_GunSway GunSway
---@param p_Weapon Entity|nil
---@param p_WeaponFiring WeaponFiring|nil
---@param p_DeltaTime number
Events:Subscribe('GunSway:UpdateRecoil', function(p_GunSway, p_Weapon, p_WeaponFiring, p_DeltaTime)
	if p_GunSway.dispersionAngle < p_GunSway.minDispersionAngle then
		p_GunSway.dispersionAngle = p_GunSway.minDispersionAngle
	end

	if p_GunSway.isFiring and p_WeaponFiring ~= nil and p_WeaponFiring.weaponState <= WeaponState.NoTrigger then
		p_GunSway.isFiring = false
	end
end)
