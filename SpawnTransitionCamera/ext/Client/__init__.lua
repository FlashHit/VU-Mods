-- store the CameraEntityData to change the transform
local m_CameraData
-- store the CameraEntity to fire events // TakeControl & ReleaseControl
local m_CameraEntity
-- if the camera is active or not
local m_CameraActive = false

-- how much time has passed since the camera got activated
local m_TimeElapsed = 0.0
-- CONFIG: smoothness factor. Lower = faster.
local m_SmoothNessFactor = 0.5

-- start position
---@type Vec3?
local m_StartPosition
-- start yaw
local m_StartYaw = 0.0
-- start pitch
local m_StartPitch = 0.0

-- target position
---@type Vec3?
local m_TargetPosition
-- target yaw
local m_TargetYaw = 0.0
-- target pitch
local m_TargetPitch = 0.0

-- identifies if the yaw needs to get lerped differently to use the shortest way
local m_TweakYaw = false

---@param p_ControllableEntity ControllableEntity -- can be vehicle or soldier
local function _CreateCamera(p_ControllableEntity)
	local s_ControllableTransform = p_ControllableEntity.transform
	local s_Position = s_ControllableTransform.trans

	-- define target position, yaw and pitch
	if p_ControllableEntity.typeInfo.name == "ClientSoldierEntity" then
		p_ControllableEntity = SoldierEntity(p_ControllableEntity)

		-- adjust the height based on the character pose
		if p_ControllableEntity.pose == CharacterPoseType.CharacterPoseType_Prone then
			m_TargetPosition = Vec3(s_Position.x, s_Position.y + 0.3, s_Position.z)
		elseif p_ControllableEntity.pose == CharacterPoseType.CharacterPoseType_Crouch then
			m_TargetPosition = Vec3(s_Position.x, s_Position.y + 1.15, s_Position.z)
		else
			m_TargetPosition = Vec3(s_Position.x, s_Position.y + 1.8, s_Position.z)
		end

		local s_Yaw = p_ControllableEntity.authoritativeYaw

		-- invert the yaw
		if s_Yaw > math.pi then
			m_TargetYaw = s_Yaw - math.pi
		else
			m_TargetYaw = s_Yaw + math.pi
		end

		m_TargetPitch = p_ControllableEntity.authoritativePitch
	-- Vehicle
	else
		m_TargetPosition = s_Position:Clone()

		local s_TargetYPR = MathUtils:GetYPRFromULF(s_ControllableTransform.up, s_ControllableTransform.left * -1, s_ControllableTransform.forward * -1)
		if not s_TargetYPR then return end

		m_TargetYaw = s_TargetYPR.x
		m_TargetPitch = s_TargetYPR.y
	end

	-- define start position, yaw and pitch
	local s_Transform = ClientUtils:GetCameraTransform()

	if not s_Transform then return end

	m_StartPosition = s_Transform.trans

	s_Transform:LookAtTransform(s_Transform.trans, m_TargetPosition)
	s_Transform.forward = s_Transform.forward * -1
	s_Transform.left = s_Transform.left * -1

	local s_YPR = MathUtils:GetYPRFromULF(s_Transform.up, s_Transform.left, s_Transform.forward)

	if not s_YPR then return end

	m_StartYaw = s_YPR.x
	m_StartPitch = s_YPR.y

	m_TweakYaw = m_StartYaw - m_TargetYaw > math.pi

	-- create or update the CameraEntityData
	m_CameraData = m_CameraData or CameraEntityData()
	m_CameraData.transform = s_Transform
	-- high priority needed
	m_CameraData.priority = 999999999

	-- create CameraEntity if needed
	if m_CameraEntity then
		return
	end

	m_CameraEntity = EntityManager:CreateEntity(m_CameraData, m_CameraData.transform)

	if m_CameraEntity then
		m_CameraEntity:Init(Realm.Realm_Client, true, false)
	end
end

---@param p_Player Player
Events:Subscribe('Player:Respawn', function(p_Player)
	-- Check if it is the local player and that it is a respawn and not a revive
	if p_Player == PlayerManager:GetLocalPlayer() and p_Player.soldier.health == 100.0 then
		_CreateCamera(p_Player.controlledControllable)

		if m_CameraEntity then
			m_CameraActive = true
			m_CameraEntity:FireEvent("TakeControl")
		end
	end
end)

---@param p_DeltaTime number
---@param p_UpdatePass UpdatePass|integer
Events:Subscribe('UpdateManager:Update', function(p_DeltaTime, p_UpdatePass)
	if p_UpdatePass ~= UpdatePass.UpdatePass_PostFrame then
		return
	end

	if not m_CameraActive then
		return
	end

	if not m_CameraEntity or not m_CameraData then
		m_CameraActive = false
		return
	end

	if not m_StartPosition or not m_TargetPosition then
		m_CameraActive = false
		return
	end

	-- Lerp between start and target transform
	m_TimeElapsed = MathUtils:Clamp(m_TimeElapsed + (p_DeltaTime / m_SmoothNessFactor), 0.0, 1.0)

	-- Make sure it goes the shortest way from start yaw to target yaw.
	-- Example: from 1.0 to 6.0. It would be fast going over 0.0, because if it gets below 0.0 it will be 2*pi. 
	-- So 6.0 is the same as 6.0 - 2*pi. And the distance between 1.0 and 6.0 is bigger then between 1.0 and (6.0 - 2*pi).
	local s_NewYaw

	if m_TweakYaw then
		s_NewYaw = MathUtils:Lerp(m_StartYaw, m_TargetYaw - 2 * math.pi, m_TimeElapsed)

		if s_NewYaw < 0.0 then
			s_NewYaw = s_NewYaw + 2 * math.pi
		end
	else
		s_NewYaw = MathUtils:Lerp(m_StartYaw, m_TargetYaw, m_TimeElapsed)
	end

	local s_NewPitch = MathUtils:Lerp(m_StartPitch, m_TargetPitch, m_TimeElapsed)
	local s_NewTransform = MathUtils:GetTransformFromYPR(s_NewYaw, s_NewPitch, 0.0)
	s_NewTransform.trans = m_StartPosition:Clone():Lerp(m_TargetPosition, m_TimeElapsed)

	m_CameraData.transform = s_NewTransform

	-- Check if the camera is close enough to the target
	if m_TargetPosition:Distance(s_NewTransform.trans) < 0.1 then
		m_CameraActive = false
		m_CameraEntity:FireEvent("ReleaseControl")
		m_TimeElapsed = 0.0
		return
	end
end)

local function _Destroy()
	if m_CameraEntity then
		m_CameraEntity:FireEvent("ReleaseControl")
		m_CameraEntity:Destroy()
	end

	m_CameraActive = false
	m_CameraEntity = nil
	m_CameraData = nil
	m_TargetPosition = nil
	m_StartPosition = nil
	m_TimeElapsed = 0.0
end

Events:Subscribe('Level:Destroy', _Destroy)
Events:Subscribe('Extension:Unloading', _Destroy)

---@param to Vec3
---@param t number
---@return Vec3
function Vec3:Lerp(to, t)
	local from = self
	self.x = MathUtils:Lerp(from.x, to.x, t)
	self.y = MathUtils:Lerp(from.y, to.y, t)
	self.z = MathUtils:Lerp(from.z, to.z, t)
	return self
end
