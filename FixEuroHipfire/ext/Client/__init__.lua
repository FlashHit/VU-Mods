Events:Subscribe('GunSway:Update', function(gunSway, weapon, weaponFiring, deltaTime)
    if InputManager:IsDown(InputConceptIdentifiers.ConceptZoom) == false then
		if gunSway.dispersionAngle < gunSway.minDispersionAngle then
			gunSway.dispersionAngle = gunSway.minDispersionAngle
		end
	end
end)