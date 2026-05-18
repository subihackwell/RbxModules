--!strict

local RunService = game:GetService("RunService")

local Stamina = {}
Stamina.__index = Stamina

function Stamina.new(humanoid, config)
	local self = setmetatable({}, Stamina)
	self._humanoid = humanoid
	self._max = config and config.Max or 100
	self._current = self._max
	self._drainRate = config and config.DrainRate or 20
	self._regenRate = config and config.RegenRate or 10
	self._regenDelay = config and config.RegenDelay or 2
	self._active = false
	self._lastDrain = 0
	self._connection = nil
	return self
end

function Stamina:Start()
	self._connection = RunService.Heartbeat:Connect(function(dt)
		self:_tick(dt)
	end)
end

function Stamina:_tick(dt: number)
	if self._active then
		self._current = math.max(0, self._current - self._drainRate * dt)
		self._lastDrain = tick()
		if self._current == 0 then
			-- force deactivate so sprint stops when stamina hits zero
			self._active = false
		end
	elseif tick() - self._lastDrain >= self._regenDelay then
		self._current = math.min(self._max, self._current + self._regenRate * dt)
	end
end

function Stamina:SetActive(active: boolean)
	if active and self._current <= 0 then return end
	self._active = active
end

function Stamina:IsActive(): boolean
	return self._active
end

function Stamina:GetStamina(): number
	return self._current
end

function Stamina:GetMax(): number
	return self._max
end

function Stamina:GetPercent(): number
	return self._current / self._max
end

function Stamina:Destroy()
	if self._connection then
		self._connection:Disconnect()
		self._connection = nil
	end
end

return Stamina
