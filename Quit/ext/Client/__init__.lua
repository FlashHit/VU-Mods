Hooks:Install('UI:CreateChatMessage', 1, function(hook, message, channelId, playerId, recipientMask, isSenderDead)
	if message == "!quit" and channelId ~= 4 then
		local localPlayer = PlayerManager:GetLocalPlayer()
		if localPlayer ~= nil and localPlayer.id == playerId then
			local data = GetQuitEntityData()
			local quitPopupGraphEntity = EntityManager:CreateEntity(data, LinearTransform())
			quitPopupGraphEntity:FireEvent('Quit')
		end
	end
end)

function GetQuitEntityData()
	local quitPopupGraphAsset = UIGraphAsset()
	quitPopupGraphAsset.modal = false
	quitPopupGraphAsset.protectScreens = true
	quitPopupGraphAsset.isWin32UIGraphAsset = true
	quitPopupGraphAsset.isXenonUIGraphAsset = true
	quitPopupGraphAsset.isPs3UIGraphAsset = true
	
	local inputNode = InstanceInputNode()
	inputNode.parentGraph = quitPopupGraphAsset
	inputNode.name = 'Quit'
	inputNode.isRootNode = false
	inputNode.parentIsScreen = false
	quitPopupGraphAsset.nodes:add(inputNode)
	
	local actionNode = ActionNode()
	actionNode.actionKey = 702328210
	actionNode.inValue = UINodePort()
	actionNode.out = UINodePort()
	actionNode.appendIncomingParams = false
	actionNode.name = 'Quit'
	actionNode.isRootNode = false
	actionNode.parentGraph = quitPopupGraphAsset
	actionNode.parentIsScreen = false
	quitPopupGraphAsset.nodes:add(actionNode)
	
	local inputToDialogNodeConnection = UINodeConnection()
	inputToDialogNodeConnection.sourceNode = inputNode
	inputToDialogNodeConnection.targetNode = actionNode
	inputToDialogNodeConnection.sourcePort = inputNode.out
	inputToDialogNodeConnection.targetPort = actionNode.inValue
	inputToDialogNodeConnection.numScreensToPop = 0
	quitPopupGraphAsset.connections:add(inputToDialogNodeConnection)
	
	local outputNode = InstanceOutputNode()
	outputNode.inValue = UINodePort()
	outputNode.id = 1905656325
	outputNode.destroyGraph = true
	outputNode.name = "QuitOrSuicide"
	outputNode.isRootNode = false
	outputNode.parentGraph = quitPopupGraphAsset
	outputNode.parentIsScreen = false
	quitPopupGraphAsset.nodes:add(outputNode)
	
	local actionToOutputNodeConnection = UINodeConnection()
	actionToOutputNodeConnection.sourceNode = actionNode
	actionToOutputNodeConnection.targetNode = outputNode
	actionToOutputNodeConnection.sourcePort = actionNode.out
	actionToOutputNodeConnection.targetPort = outputNode.inValue
	actionToOutputNodeConnection.numScreensToPop = 1
	quitPopupGraphAsset.connections:add(actionToOutputNodeConnection)
	
	local quitPopupGraphEntityData = UIGraphEntityData()
	quitPopupGraphEntityData.graphAsset = quitPopupGraphAsset
	quitPopupGraphEntityData.popPreviousGraph = false
	
	return quitPopupGraphEntityData
end

	