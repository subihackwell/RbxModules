--!strict

local RunService = game:GetService("RunService")

local StatusEffect = {}
StatusEffect.__index = StatusEffect

type EffectConfig = {
	Duration: number,
	OnApply: (() -> ())?,
	OnRemove: (() -> ())?,
	OnTick: ((dt: number) -> ())?,
}

function StatusEffect.new()
	return setmetatable({
		_effects = {} :: {[string]: {remaining: number, config: EffectConfig}},
		_connection = nil,
	}, StatusEffect)
end

function StatusEffect:Start()
	self._connection = RunService.Heartbeat:Connect(function(dt)
		self:_tick(dt)
	end)
end

function StatusEffect:Apply(name: string, config: EffectConfig)
	-- reapplying an existing effect resets its timer instead of stacking
	if self._effects[name] then
		self._effects[name].remaining = config.Duration
		return
	end

	self._effects[name] = {
		remaining = config.Duration,
		config = config,
	}

	if config.OnApply then
		config.OnApply()
	end
end

function StatusEffect:Remove(name: string)
	local effect = self._effects[name]
	if not effect then return end
	if effect.config.OnRemove then
		effect.config.OnRemove()
	end
	self._effects[name] = nil
end

function StatusEffect:Has(name: string): boolean
	return self._effects[name] ~= nil
end

function StatusEffect:GetRemaining(name: string): number
	local effect = self._effects[name]
	return effect and effect.remaining or 0
end

function StatusEffect:_tick(dt: number)
	for name, effect in self._effects do
		effect.remaining -= dt
		if effect.config.OnTick then
			effect.config.OnTick(dt)
		end
		if effect.remaining <= 0 then
			self:Remove(name)
		end
	end
end

function StatusEffect:Destroy()
	for name in self._effects do
		self:Remove(name)
	end
	if self._connection then
		self._connection:Disconnect()
		self._connection = nil
	end
end

return StatusEffect
