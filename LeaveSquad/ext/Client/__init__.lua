local s_BlockedSquad = false

Events:Subscribe('Player:SquadChange', function(p_Player, p_SquadId)
	print(p_Player.name .. " - squad: " .. tostring(p_SquadId) .. " time: " .. p_Player.time)

	if s_BlockedSquad then
		return
	end

	if p_SquadId == SquadId.SquadNone then
		return
	end

	local s_LocalPlayer = PlayerManager:GetLocalPlayer()

	if s_LocalPlayer == nil then
		return
	end

	if s_LocalPlayer ~= p_Player then
		return
	end

	s_BlockedSquad = true

	-- if the auto squad join is missing, we will use the player.timer to detect if it was a manual squad joining
	-- in my tests the automatic squad join was always below 12 seconds
	-- so worst case: a player has to press join squad twice
	if p_Player.time > 12.0 then
		print("This was no automatic squad join")
		return
	end

	local s_Data = GetSquadActionGraphEntityData()
	local s_SquadActionGraphEntity = EntityManager:CreateEntity(s_Data, LinearTransform())

	if s_SquadActionGraphEntity == nil then
		print("Error - failed to create UIGraphEntity")
		return
	end

	s_SquadActionGraphEntity:FireEvent('SquadAction')
	print("Leaving SquadID " .. p_Player.squadId)
end)

function GetSquadActionGraphEntityData()
	local s_SquadActionGraphAsset = UIGraphAsset()
	s_SquadActionGraphAsset.modal = false
	s_SquadActionGraphAsset.protectScreens = true
	s_SquadActionGraphAsset.isWin32UIGraphAsset = true
	s_SquadActionGraphAsset.isXenonUIGraphAsset = true
	s_SquadActionGraphAsset.isPs3UIGraphAsset = true

	local s_InputNode = InstanceInputNode()
	s_InputNode.parentGraph = s_SquadActionGraphAsset
	s_InputNode.name = 'SquadAction'
	s_InputNode.isRootNode = false
	s_InputNode.parentIsScreen = false
	s_SquadActionGraphAsset.nodes:add(s_InputNode)

	local s_ActionNode = ActionNode()
	s_ActionNode.parentGraph = s_SquadActionGraphAsset
	s_ActionNode.actionKey = -1497091703
	s_ActionNode.name = 'SquadAction'
	s_ActionNode.params:add('create')
	s_ActionNode.appendIncomingParams = false
	s_SquadActionGraphAsset.nodes:add(s_ActionNode)

	local s_InputToActionNodeConnection = UINodeConnection()
	s_InputToActionNodeConnection.sourceNode = s_InputNode
	s_InputToActionNodeConnection.targetNode = s_ActionNode
	s_InputToActionNodeConnection.sourcePort = s_InputNode.out
	s_InputToActionNodeConnection.targetPort = s_ActionNode.inValue
	s_SquadActionGraphAsset.connections:add(s_InputToActionNodeConnection)

	local s_OutputNode = InstanceOutputNode()
	s_OutputNode.parentGraph = s_SquadActionGraphAsset
	s_SquadActionGraphAsset.nodes:add(s_OutputNode)

	local s_ActionToOutputNodeConnection = UINodeConnection()
	s_ActionToOutputNodeConnection.sourceNode = s_ActionNode
	s_ActionToOutputNodeConnection.targetNode = s_OutputNode
	s_ActionToOutputNodeConnection.sourcePort = s_ActionNode.out
	s_ActionToOutputNodeConnection.targetPort = s_OutputNode.inValue
	s_SquadActionGraphAsset.connections:add(s_ActionToOutputNodeConnection)

	local s_SquadActionGraphEntityData = UIGraphEntityData()
	s_SquadActionGraphEntityData.graphAsset = s_SquadActionGraphAsset
	s_SquadActionGraphEntityData.popPreviousGraph = false

	return s_SquadActionGraphEntityData
end
