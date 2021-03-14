Hooks:Install('UI:CreateChatMessage', 1, function(hook, message, channelId, playerId, recipientMask, isSenderDead)

	if message == "!deploy" and channelId ~= 4 then
		local localPlayer = PlayerManager:GetLocalPlayer()
		if localPlayer ~= nil and localPlayer.id == playerId then
			local data = GetDeployGraphEntityData()
			local deployGraphEntity = EntityManager:CreateEntity(data, LinearTransform())
			deployGraphEntity:FireEvent('Deploy')
		end
	end

end)

function GetDeployGraphEntityData()
	local deployGraphAsset = UIGraphAsset()
	deployGraphAsset.modal = false
	deployGraphAsset.protectScreens = true
	deployGraphAsset.isWin32UIGraphAsset = true
	deployGraphAsset.isXenonUIGraphAsset = true
	deployGraphAsset.isPs3UIGraphAsset = true

	local inputNode = InstanceInputNode()
	inputNode.parentGraph = deployGraphAsset
	inputNode.name = 'Deploy'
	inputNode.isRootNode = false
	inputNode.parentIsScreen = false
	deployGraphAsset.nodes:add(inputNode)

	local actionNode = ActionNode()
	actionNode.parentGraph = deployGraphAsset
	actionNode.actionKey = 230891742
	actionNode.name = 'Deploy'
	actionNode.appendIncomingParams = false
	deployGraphAsset.nodes:add(actionNode)

	local inputToActionNodeConnection = UINodeConnection()
	inputToActionNodeConnection.sourceNode = inputNode
	inputToActionNodeConnection.targetNode = actionNode
	inputToActionNodeConnection.sourcePort = inputNode.out
	inputToActionNodeConnection.targetPort = actionNode.inValue
	deployGraphAsset.connections:add(inputToActionNodeConnection)

	local outputNode = InstanceOutputNode()
	outputNode.parentGraph = deployGraphAsset
	deployGraphAsset.nodes:add(outputNode)

	local actionToOutputNodeConnection = UINodeConnection()
	actionToOutputNodeConnection.sourceNode = actionNode
	actionToOutputNodeConnection.targetNode = outputNode
	actionToOutputNodeConnection.sourcePort = actionNode.out
	actionToOutputNodeConnection.targetPort = outputNode.inValue
	deployGraphAsset.connections:add(actionToOutputNodeConnection)
	
	local deployGraphEntityData = UIGraphEntityData()
	deployGraphEntityData.graphAsset = deployGraphAsset
	deployGraphEntityData.popPreviousGraph = false
	
	return deployGraphEntityData
end

	