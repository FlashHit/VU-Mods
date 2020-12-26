local adminList = {}

RCON:RegisterCommand('gameAdmin.add', RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
	
	-- example: 'gameAdmin.add PlayerName true true true false false false false false true false false true false'
	
	if args == nil or args[14] == nil then
		return {'InvalidArguments'}
	end
	
	-- args[1] has to be the name, so we add it to local name and remove it from the args table so we have only the abilities there
	local name = args[1]
	table.remove(args, 1)
	
	-- we want to know how many abilities that player got
	local tempAbilityCount = 0
	
	-- also iterate do toboolean and if it is no boolean then return 'InvalidArguments'
	for i=1,13 do
		if args[i] == "true" or args[i] == "1" then
			args[i] = true
			tempAbilityCount = tempAbilityCount + 1
		elseif args[i] == "false" or args[i] == "0" then
			args[i] = false
		else
			return {'InvalidArguments'}
		end
	end
	local logString = ""
	if adminList[name] == nil then
		logString = "ADD: Player " .. name .. "is now admin with following abilities:"
	else
		logString = "UPDATE: Player " .. name .. "is now admin with following abilities:"
	end
	-- create the table for that player
	adminList[name] = {
		abilityCount = tempAbilityCount,
		canMovePlayers = args[1],
		canKillPlayers = args[2],
		canKickPlayers = args[3],
		canTemporaryBanPlayers = args[4],
		canPermanentlyBanPlayers = args[5],
		canEditGameAdminList = args[6],
		canEditBanList = args[7],
		canEditMapList = args[8],
		canUseMapFunctions = args[9],
		canAlterServerSettings = args[10],
		canEditReservedSlotsList = args[11],
		canEditTextChatModerationList = args[12],
		canShutdownServer = args[13]
	}
	-- dispatch adminrights
	Events:Dispatch('GameAdmin:Player', name, adminList[name])
	
	-- generate the RCON response. We only want to see the player name, the abilityCount and the ability names.
	local response = {'OK',name, tostring(tempAbilityCount)}
	
	if args[1] == true then
		table.insert(response, "canMovePlayers")
		logString = logString .. " canMovePlayers"
	end
	if args[2] == true then
		table.insert(response, "canKillPlayers")
		logString = logString .. " canKillPlayers"
	end
	if args[3] == true then
		table.insert(response, "canKickPlayers")
		logString = logString .. " canKickPlayers"
	end
	if args[4] == true then
		table.insert(response, "canTemporaryBanPlayers")
		logString = logString .. " canTemporaryBanPlayers"
	end
	if args[5] == true then
		table.insert(response, "canPermanentlyBanPlayers")
		logString = logString .. " canPermanentlyBanPlayers"
	end
	if args[6] == true then
		table.insert(response, "canEditGameAdminList")
		logString = logString .. " canEditGameAdminList"
	end
	if args[7] == true then
		table.insert(response, "canEditBanList")
		logString = logString .. " canEditBanList"
	end
	if args[8] == true then
		table.insert(response, "canEditMapList")
		logString = logString .. " canEditMapList"
	end
	if args[9] == true then
		table.insert(response, "canUseMapFunctions")
		logString = logString .. " canUseMapFunctions"
	end
	if args[10] == true then
		table.insert(response, "canAlterServerSettings")
		logString = logString .. " canAlterServerSettings"
	end
	if args[11] == true then
		table.insert(response, "canEditReservedSlotsList")
		logString = logString .. " canEditReservedSlotsList"
	end
	if args[12] == true then
		table.insert(response, "canEditTextChatModerationList")
		logString = logString .. " canEditTextChatModerationList"
	end
	if args[13] == true then
		table.insert(response, "canShutdownServer")
		logString = logString .. " canShutdownServer"
	end
	
	print(logString)
	
	return response
	
	-- response for our example: 'OK PlayerName 5 canMovePlayers canKillPlayers canKickPlayers canUseMapFunctions canEditTextChatModerationList'
end)

RCON:RegisterCommand('gameAdmin.clear', RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
	-- Clear adminlist
	Events:Dispatch('GameAdmin:Clear')

	-- clear the adminList table and return 'OK'
	adminList = {}
	
	print("CLEAR - Admin list has been cleared.")
	return {'OK'}
end)

RCON:RegisterCommand('gameAdmin.list', RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
	-- generate a response
	local response = {'OK'}
	-- for each admin in the adminList we add:
	for admin,abilities in pairs(adminList) do
		-- admin name
		table.insert(response, admin)
		-- ability count
		table.insert(response, tostring(abilities.abilityCount))
		
		-- and every ability name
		if abilities.canMovePlayers == true then
			table.insert(response, "canMovePlayers")
		end
		if abilities.canKillPlayers == true then
			table.insert(response, "canKillPlayers")
		end
		if abilities.canKickPlayers == true then
			table.insert(response, "canKickPlayers")
		end
		if abilities.canTemporaryBanPlayers == true then
			table.insert(response, "canTemporaryBanPlayers")
		end
		if abilities.canPermanentlyBanPlayers == true then
			table.insert(response, "canPermanentlyBanPlayers")
		end
		if abilities.canEditGameAdminList == true then
			table.insert(response, "canEditGameAdminList")
		end
		if abilities.canEditBanList == true then
			table.insert(response, "canEditBanList")
		end
		if abilities.canEditMapList == true then
			table.insert(response, "canEditMapList")
		end
		if abilities.canUseMapFunctions == true then
			table.insert(response, "canUseMapFunctions")
		end
		if abilities.canAlterServerSettings == true then
			table.insert(response, "canAlterServerSettings")
		end
		if abilities.canEditReservedSlotsList == true then
			table.insert(response, "canEditReservedSlotsList")
		end
		if abilities.canEditTextChatModerationList == true then
			table.insert(response, "canEditTextChatModerationList")
		end
		if abilities.canShutdownServer == true then
			table.insert(response, "canShutdownServer")
		end
	end
	
	return response
	
	-- response example: 'OK PlayerName 5 canMovePlayers canKillPlayers canKickPlayers canUseMapFunctions canEditTextChatModerationList PlayerName2 2 canMovePlayers canKillPlayers'
end)

RCON:RegisterCommand('gameAdmin.remove', RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
	-- check if args[1] is an admin name in the adminList
	if args == nil or args[1] == nil or adminList[args[1]] == nil then
		return {'PlayerNotFound'}
	end
	
	-- remove his adminrights, abilities will be nil
	Events:Dispatch('GameAdmin:Player', args[1])
	
	-- remove the admin from adminList
	adminList[args[1]] = nil
	print("REMOVE - Player " .. args[1] .. " has been removed from admin list.")
	return {'OK'}

end)

RCON:RegisterCommand('gameAdmin.save', RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
	if not SQL:Open() then
		return
	end
	local query = [[DROP TABLE IF EXISTS admin_table]]
	if not SQL:Query(query) then
	  print('Failed to execute query: ' .. SQL:Error())
	  return
	end
	query = [[
	  CREATE TABLE IF NOT EXISTS admin_table (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		adminName TEXT,
		abilityCount INTEGER,
		canMovePlayers BOOLEAN,
		canKillPlayers BOOLEAN,
		canKickPlayers BOOLEAN,
		canTemporaryBanPlayers BOOLEAN,
		canPermanentlyBanPlayers BOOLEAN,
		canEditGameAdminList BOOLEAN,
		canEditBanList BOOLEAN,
		canEditMapList BOOLEAN,
		canUseMapFunctions BOOLEAN,
		canAlterServerSettings BOOLEAN,
		canEditReservedSlotsList BOOLEAN,
		canEditTextChatModerationList BOOLEAN,
		canShutdownServer BOOLEAN
	  )
	]]
	if not SQL:Query(query) then
	  print('Failed to execute query: ' .. SQL:Error())
	  return
	end
	query = 'INSERT INTO admin_table (adminName, abilityCount, canMovePlayers, canKillPlayers, canKickPlayers, canTemporaryBanPlayers, canPermanentlyBanPlayers, canEditGameAdminList, canEditBanList, canEditMapList, canUseMapFunctions, canAlterServerSettings, canEditReservedSlotsList, canEditTextChatModerationList, canShutdownServer) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'
	for admin,abilities in pairs(adminList) do
		if not SQL:Query(query, admin, abilities.abilityCount, abilities.canMovePlayers, abilities.canKillPlayers, abilities.canKickPlayers, abilities.canTemporaryBanPlayers, abilities.canPermanentlyBanPlayers, abilities.canEditGameAdminList, abilities.canEditBanList, abilities.canEditMapList, abilities.canUseMapFunctions, abilities.canAlterServerSettings, abilities.canEditReservedSlotsList, abilities.canEditTextChatModerationList, abilities.canShutdownServer) then
		  print('Failed to execute query: ' .. SQL:Error())
		  return
		end
	end
	
	-- Fetch all rows from the table.
	results = SQL:Query('SELECT * FROM admin_table')

	if not results then
	  print('Failed to execute query: ' .. SQL:Error())
	  return
	end

	SQL:Close()
	print("SAVE - The admin list has been saved.")
	return {'OK'}
end)
RCON:RegisterCommand('gameAdmin.load', RemoteCommandFlag.RequiresLogin, function(command, args, loggedIn)
	if not SQL:Open() then
		return
	end
	
	local query = [[
	  CREATE TABLE IF NOT EXISTS admin_table (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		adminName TEXT,
		abilityCount INTEGER,
		canMovePlayers BOOLEAN,
		canKillPlayers BOOLEAN,
		canKickPlayers BOOLEAN,
		canTemporaryBanPlayers BOOLEAN,
		canPermanentlyBanPlayers BOOLEAN,
		canEditGameAdminList BOOLEAN,
		canEditBanList BOOLEAN,
		canEditMapList BOOLEAN,
		canUseMapFunctions BOOLEAN,
		canAlterServerSettings BOOLEAN,
		canEditReservedSlotsList BOOLEAN,
		canEditTextChatModerationList BOOLEAN,
		canShutdownServer BOOLEAN
	  )
	]]
	if not SQL:Query(query) then
	  print('Failed to execute query: ' .. SQL:Error())
	  return
	end
	
	-- Fetch all rows from the table.
	results = SQL:Query('SELECT * FROM admin_table')

	if not results then
	  print('Failed to execute query: ' .. SQL:Error())
	  return
	end
	-- Copy from gameAdmin.clear
	Events:Dispatch('GameAdmin:Clear')
	adminList = {}
	
	-- Print the fetched rows.
	for _, row in pairs(results) do
		local name = row["adminName"]
		row["adminName"] = nil
		row["id"] = nil
		for i,_ in pairs(row) do
			if i ~= "abilityCount" and row[i] == 1 then
				row[i] = true
			elseif row[i] == 0 then
				row[i] = false
			end
		end
		adminList[name] = row
		
		-- Copy from gameAdmin.add
			Events:Dispatch('GameAdmin:Player', name, adminList[name])
	end
	SQL:Close()
	print("LOAD - The admin list has been loaded.")
	return {'OK'}
end)

RCON:SendCommand('gameAdmin.load')
