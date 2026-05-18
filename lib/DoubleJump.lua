--!strict
-- client-side only

local UserInputService = game:GetService("UserInputService")

local DoubleJump = {}
DoubleJump.__index = DoubleJump

function DoubleJump.new(character, config)
	local self = setmetatable({}, DoubleJump)
	self._humanoid = character:WaitForChild("Humanoid") :: Humanoid
	self._hrp = character:WaitForChild("HumanoidRootPart") :: BasePart
	self._jumpPower = config and config.JumpPower or 60
	self._used = false
	self._connections = {}
	return self
end

function DoubleJump:Start()
	table.insert(self._connections, self._humanoid.StateChanged:Connect(function(_, new)
		if new == Enum.HumanoidStateType.Landed then
			self._used = false
		end
	end))

	table.insert(self._connections, UserInputService.JumpRequest:Connect(function()
		if self._humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then return end
		if self._used then return end
		self._used = true

		-- override vertical velocity directly rather than calling Jump()
		-- because Jump() triggers a full jump state which resets animations
		self._hrp.AssemblyLinearVelocity = Vector3.new(
			self._hrp.AssemblyLinearVelocity.X,
			self._jumpPower,
			self._hrp.AssemblyLinearVelocity.Z
		)
	end))
end

function DoubleJump:Destroy()
	for _, conn in self._connections do
		conn:Disconnect()
	end
	table.clear(self._connections)
end

return DoubleJump
