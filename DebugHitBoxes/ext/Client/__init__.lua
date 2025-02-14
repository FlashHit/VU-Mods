local m_enabled = false

---@param worldTransform LinearTransform
---@param radius number
---@param length number
---@param color Vec4
---@param segments integer
function DebugCapsule(worldTransform, radius, length, color, segments)
	-- Default values if not provided
	segments = segments or 16

	-- Extract transformation data
	local position = worldTransform.trans
	local up = worldTransform.up -- Length direction
	local forward = worldTransform.forward -- Used for circular base
	local right = worldTransform.left * -1 -- Vertical direction

	-- Compute endpoints of the capsule
	local bottomCenter = position
	local topCenter = position + (up * length)

	-- Draw base axis line (helps visualize direction)
	DebugRenderer:DrawLine(bottomCenter, topCenter, color, color)

	-- Draw cylindrical body
	for i = 0, segments - 1 do
		local angle1 = (i / segments) * math.pi * 2
		local angle2 = ((i + 1) / segments) * math.pi * 2

		-- Calculate circle points around the cylinder's base and top
		local p1 = (forward * math.cos(angle1) * radius) + (right * math.sin(angle1) * radius)
		local p2 = (forward * math.cos(angle2) * radius) + (right * math.sin(angle2) * radius)

		-- Apply position offsets
		local basePoint1 = bottomCenter + p1
		local basePoint2 = bottomCenter + p2
		local topPoint1 = topCenter + p1
		local topPoint2 = topCenter + p2

		-- Draw horizontal circles at top and bottom
		DebugRenderer:DrawLine(basePoint1, basePoint2, color, color)
		DebugRenderer:DrawLine(topPoint1, topPoint2, color, color)

		-- Draw vertical lines connecting top and bottom circles
		DebugRenderer:DrawLine(basePoint1, topPoint1, color, color)
		DebugRenderer:DrawLine(basePoint2, topPoint2, color, color)
	end

	-- Draw hemispheres
	local numArcs = segments / 2  -- Number of arcs forming each hemisphere

	for j = 0, numArcs - 1 do
		local rotAngle = (j / numArcs) * math.pi * 2  -- Rotate around capsule axis
		local sinRot = math.sin(rotAngle)
		local cosRot = math.cos(rotAngle)

		for i = 0, segments / 2 - 1 do  -- Loop through the hemisphere arcs
			local theta1 = (i / (segments / 2)) * math.pi * 0.5
			local theta2 = ((i + 1) / (segments / 2)) * math.pi * 0.5

			-- Spherical coordinates for hemisphere arc
			local x1 = math.cos(theta1) * radius
			local y1 = math.sin(theta1) * radius
			local x2 = math.cos(theta2) * radius
			local y2 = math.sin(theta2) * radius

			-- Apply rotation using adjusted basis vectors
			local p1 = (right * (x1 * cosRot)) + (up * y1) + (forward * (x1 * sinRot))
			local p2 = (right * (x2 * cosRot)) + (up * y2) + (forward * (x2 * sinRot))

			-- Draw top hemisphere arcs
			DebugRenderer:DrawLine(topCenter + p1, topCenter + p2, color, color)

			-- Draw bottom hemisphere arcs (mirrored)
			DebugRenderer:DrawLine(bottomCenter - p1, bottomCenter - p2, color, color)
		end
	end
end

local boneMap = {}

---@param boneName string
---@return integer
function FindBone(boneName)
	local skeletonAsset = SkeletonAsset(ResourceManager:SearchForDataContainer("Animations/Skeletons/VeniceAntSke01"))
	for index, value in ipairs(skeletonAsset.boneNames) do
		if value == boneName then
			return index - 1
		end
	end
	error("Bone not found")
end

---@param worldTransform LinearTransform
---@param offset Vec3
---@param axis integer
---@return LinearTransform
local function FixBoneAxis(worldTransform, offset, axis)
	if axis == 0 then
		-- Axis 0 means left and up need to be flipped
		local worldLeft = worldTransform.left:Clone()
		---@diagnostic disable-next-line: assign-type-mismatch
		worldTransform.left = worldTransform.up:Clone() * -1
		worldTransform.up = worldLeft
	else
		error("Axis not supported")
	end

	-- Apply offset
	-- Source: https://github.com/microsoft/DirectXMath/blob/af1e6a1db5b4c4d8b4a12cf15006d85579840c89/Inc/DirectXMathVector.inl#L10348-L10350
	worldTransform.trans = worldTransform * offset
	return worldTransform
end

---@param ragdollComponent RagdollComponent
local function DrawHitBoxes(ragdollComponent)
	local asset = DataContainerAsset(ResourceManager:SearchForDataContainer("Characters/Soldiers/DefaultSoldierBoneCollision"))
	local skeletonCollisionData = SkeletonCollisionData(asset.data)

	for _, data in ipairs(skeletonCollisionData.boneCollisionData) do
		if data.validInHiLod then
			if not boneMap[data.boneName] then
				boneMap[data.boneName] = FindBone(data.boneName)
			end

			local quatTransform = ragdollComponent:GetActiveWorldTransform(boneMap[data.boneName])
			if quatTransform then
				local worldTransform = FixBoneAxis(quatTransform:ToLinearTransform(), data.capsuleOffset, data.boneAxis)
				DebugCapsule(worldTransform, data.capsuleRadius, data.capsuleLength, Vec4.one, 16)
			end
		end
	end
end

Events:Subscribe("UpdateManager:Update", function (deltaTime, updatePass)
	if updatePass ~= UpdatePass.UpdatePass_PreFrame then return end
	if not m_enabled then return end

	local localPlayer = PlayerManager:GetLocalPlayer()
	for _, player in ipairs(PlayerManager:GetPlayers()) do
		if localPlayer ~= player then
			local soldier = player.soldier
			if soldier then
				DrawHitBoxes(soldier.ragdollComponent)
			end
		end
	end
end)

Hooks:Install("ClientChatManager:IncomingMessage", 1, function (hookCtx, message, playerId, recipientMask, channelId, isSenderDead)
	if not PlayerManager:GetLocalPlayer() and not PlayerManager:GetLocalPlayer().id == playerId then return end
	if message == "!enable" then
		m_enabled = true
		return
	end

	if message == "!disable" then
		m_enabled = false
		return
	end
end)
