function string:split(sep)
   local sep, fields = sep or " ", {}
   local pattern = string.format("([^%s]+)", sep)
   self:gsub(pattern, function(c) fields[#fields+1] = c end)
   return fields
end

Hooks:Install('UI:CreateChatMessage', 1, function(hook, message, channelId, playerId, recipientMask, isSenderDead)
	
	if channelId == 4 then
		return
	end
	local parts = string.lower(message):split(' ')
	if parts[1] ~= "!spawnme" and parts[1] ~= "!respawnme" then
		return
	end
	local localPlayer = PlayerManager:GetLocalPlayer()
	if localPlayer == nil or localPlayer.id ~= playerId then
		return
	end
	
	if localPlayer.soldier ~= nil or (localPlayer.corpse ~= nil and not localPlayer.corpse.isDead) then
		print("INFO: You are still not dead")
		-- TODO use deathTimer? 
		return
	end
	
	if parts[1] == "!respawnme" then
		local s_TargetSpawn = GetTargetSpawn(localPlayer)
		NetEvents:Send('RequestSpawn', s_TargetSpawn)
		print("INFO: You are now respawning")
	end
	
	local s_SoldierKitGuid = Guid('47949491-F672-4CD6-998A-101B7740F919')
	--local s_SoldierKitGMGuid = Guid('44C31E6C-EAD2-4082-A2B6-33AC58CBF458')
	--local s_SoldierKitXP4Guid = Guid('518B1D53-A27C-4A83-BFD4-9AD8D837FC5E')
	local s_SoldierPersistenceGuid = Guid('23CFF61F-F1E2-4306-AECE-2819E35484D2')
	--local s_SoldierPersistenceXP4Guid = Guid('8A46AA03-D88B-49D8-8602-1D3A3D58ADE1')
	
	
	local s_PrimaryWeapon = Guid('A7278B05-8D76-4A40-B65D-4414490F6886')
	-- Note: if you dont want attachments you still need NoOptics, NoPrimaryAccessory (for AssaultRifles it's NoSecondaryRail), NoSecondaryAccessory, 
	-- and NoCamo (for weapons that have more then the default camo it's DefaultCamo).
	-- otherwise the weapon might get bugged
	local s_PrimaryWeapon_Attachment1 = Guid('1890AFA0-2C17-FB9B-789C-990AA78E8F93')
	local s_PrimaryWeapon_Attachment2 = Guid('47A66D9C-ADE6-1AA7-253B-D18C3059ABE5')
	local s_PrimaryWeapon_Attachment3 = Guid('47A66D9C-ADE6-1AA7-253B-D18C3059ABE5')
	local s_PrimaryWeapon_Attachment4 = Guid('90DA90C5-2ED3-4CAC-A01E-8E5E75145945')
	local s_PrimaryWeapon_AttachmentTable = {s_PrimaryWeapon_Attachment1, s_PrimaryWeapon_Attachment2, s_PrimaryWeapon_Attachment3, s_PrimaryWeapon_AttachmentCamo}
	local s_PrimaryWeaponTable = {WeaponSlot.WeaponSlot_0, s_PrimaryWeapon, s_PrimaryWeapon_AttachmentTable}
	
	local s_SecondaryWeapon = Guid('1EA227D8-2EB5-A63B-52FF-BBA9CFE34AD8')
	local s_SecondaryWeaponTable = {WeaponSlot.WeaponSlot_1, s_SecondaryWeapon}
	
	local s_Gadget1 = Guid('00F16262-38F3-45F0-B577-C243CDB10A9E')
	local s_Gadget1Table = {WeaponSlot.WeaponSlot_4, s_Gadget1}
	
	local s_Gadget2 = Guid('7D11603B-8188-45FD-AD95-B27A4B35980E')
	local s_Gadget2Table = {WeaponSlot.WeaponSlot_5, s_Gadget2}
	
	local s_Grenade = Guid('9F789F05-CE7B-DADC-87D7-16E847DBDD09')
	local s_GrenadeTable = {WeaponSlot.WeaponSlot_6, s_Grenade}
	
	local s_Knife = Guid('8963F500-E71D-41FC-4B24-AE17D18D8C73')
	local s_KnifeTable = {WeaponSlot.WeaponSlot_7, s_Knife}
	
	
	local s_TargetSpawn = GetTargetSpawn(localPlayer)
	
	local s_TargetSpawnIsVehicle = false
	
	local s_Table = {s_SoldierKitGuid, s_SoldierPersistenceGuid, s_PrimaryWeaponTable, s_SecondaryWeaponTable, s_Gadget1Table, s_Gadget2Table, s_GrenadeTable, s_KnifeTable, s_TargetSpawn, s_TargetSpawnIsVehicle}
	
	NetEvents:Send('RequestSpawn', s_Table)
	print("INFO: You are now spawning")
end)

function GetTargetSpawn(localPlayer)
	if p_TargetSpawn == "ru" then
		return "_ID_H_RU_HQ"
	elseif p_TargetSpawn == "us" then
		return "_ID_H_US_HQ"
	elseif p_TargetSpawn == "a" then
		return "ID_H_US_A"
	elseif p_TargetSpawn == "b" then
		return "ID_H_US_B"
	elseif p_TargetSpawn == "c" then
		return "ID_H_US_C"
	elseif p_TargetSpawn == "d" then
		return "ID_H_US_D"
	elseif p_TargetSpawn == "e" then
		return "ID_H_US_E"
	elseif p_TargetSpawn == "f" then
		return "ID_H_US_F"
	elseif p_TargetSpawn == "g" then
		return "ID_H_US_G"
	elseif p_TargetSpawn == "h" then
		return "ID_H_US_H"
	elseif localPlayer.teamId == 2 then
		return "_ID_H_RU_HQ"
	else
		return "_ID_H_US_HQ"
	end
end

