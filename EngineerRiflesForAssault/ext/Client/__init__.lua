Events:Subscribe('Level:Loaded', function()
	local ruEngineer = ResourceManager:SearchForDataContainer('Gameplay/Kits/RUEngineer')
	if ruEngineer == nil then
		print("RU Engineer not found")
		ruEngineer = ResourceManager:SearchForDataContainer('Gameplay/Kits/RUEngineer_XP4')
		if ruEngineer == nil then
			print("RU Engineer XP4 also not found")
			return
		end
	end
	
	local ruAssault = ResourceManager:SearchForDataContainer('Gameplay/Kits/RUAssault')
	if ruAssault == nil then
		print("RU Assault not found")
		ruAssault = ResourceManager:SearchForDataContainer('Gameplay/Kits/RUAssault_XP4')
		if ruAssault == nil then
			print("RU Assault XP4 also not found")
			return
		end
	end
	
	ruEngineer = VeniceSoldierCustomizationAsset(ruEngineer)
	ruAssault = VeniceSoldierCustomizationAsset(ruAssault)
	
	CustomizationUnlockParts(CustomizationTable(ruAssault.weaponTable).unlockParts[1]):MakeWritable()
	for i,weapon in pairs(CustomizationUnlockParts(CustomizationTable(ruEngineer.weaponTable).unlockParts[1]).selectableUnlocks) do
		if i <= 11 then
		CustomizationUnlockParts(CustomizationTable(ruAssault.weaponTable).unlockParts[1]).selectableUnlocks:add(weapon)
		end
	end
	
	
	local usEngineer = ResourceManager:SearchForDataContainer('Gameplay/Kits/USEngineer')
	if usEngineer == nil then
		print("US Engineer not found")
		usEngineer = ResourceManager:SearchForDataContainer('Gameplay/Kits/USEngineer_XP4')
		if usEngineer == nil then
			print("US Engineer XP4 also not found")
			return
		end
	end
	
	local usAssault = ResourceManager:SearchForDataContainer('Gameplay/Kits/USAssault')
	if usAssault == nil then
		print("US Assault not found")
		usAssault = ResourceManager:SearchForDataContainer('Gameplay/Kits/USAssault_XP4')
		if usAssault == nil then
			print("US Assault XP4 also not found")
			return
		end
	end
	
	usEngineer = VeniceSoldierCustomizationAsset(usEngineer)
	usAssault = VeniceSoldierCustomizationAsset(usAssault)
	
	CustomizationUnlockParts(CustomizationTable(usAssault.weaponTable).unlockParts[1]):MakeWritable()
	for i,weapon in pairs(CustomizationUnlockParts(CustomizationTable(usEngineer.weaponTable).unlockParts[1]).selectableUnlocks) do
		if i <= 11 then
		CustomizationUnlockParts(CustomizationTable(usAssault.weaponTable).unlockParts[1]).selectableUnlocks:add(weapon)
		end
	end
	
end)