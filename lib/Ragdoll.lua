--!strict

local Ragdoll = {}
Ragdoll.__index = Ragdoll

function Ragdoll.new(character)
	return setmetatable({
		_character = character,
		_motors = {},
		_constraints = {},
		_active = false,
	}, Ragdoll)
end

function Ragdoll:Enable()
	if self._active then return end
	self._active = true

	local humanoid = self._character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid:ChangeState(Enum.HumanoidStateType.Physics)
	end

	for _, desc in self._character:GetDescendants() do
		if not desc:IsA("Motor6D") then continue end
		if not desc.Part0 or not desc.Part1 then continue end

		local att0 = Instance.new("Attachment")
		att0.CFrame = desc.C0
		att0.Parent = desc.Part0

		local att1 = Instance.new("Attachment")
		att1.CFrame = desc.C1
		att1.Parent = desc.Part1

		local constraint = Instance.new("BallSocketConstraint")
		constraint.Attachment0 = att0
		constraint.Attachment1 = att1
		constraint.LimitsEnabled = true
		constraint.UpperAngle = 45
		constraint.Parent = desc.Parent

		desc.Enabled = false

		table.insert(self._motors, desc)
		table.insert(self._constraints, { constraint, att0, att1 })
	end
end

function Ragdoll:Disable()
	if not self._active then return end
	self._active = false

	-- re-enable joints before removing constraints so the character snaps back cleanly
	for _, motor in self._motors do
		motor.Enabled = true
	end

	for _, group in self._constraints do
		for _, obj in group do
			obj:Destroy()
		end
	end

	table.clear(self._motors)
	table.clear(self._constraints)

	local humanoid = self._character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	end
end

function Ragdoll:IsActive(): boolean
	return self._active
end

function Ragdoll:Destroy()
	if self._active then
		self:Disable()
	end
end

return Ragdoll
