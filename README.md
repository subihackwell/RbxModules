# RbxModules

Reusable character modules for Roblox. Drop any file from `lib/` into your project.

## Modules

| Module | Side | Description |
|--------|------|-------------|
| [Stamina](lib/Stamina.lua) | Server / Client | Sprint stamina with configurable drain, regen, and regen delay. |
| [StatusEffect](lib/StatusEffect.lua) | Server / Client | Stack-safe effect manager. Apply burn, slow, stun — any timed effect with callbacks. |
| [Ragdoll](lib/Ragdoll.lua) | Server | Disables Motor6D joints and adds BallSocketConstraints. R6 and R15 compatible. |
| [DoubleJump](lib/DoubleJump.lua) | Client | Double jump with configurable power. Resets on landing automatically. |
| [Knockback](lib/Knockback.lua) | Server | Directional knockback via BodyVelocity. Point-of-origin variant included. |

## Usage

```lua
local Stamina = require(ReplicatedStorage.Stamina)

local stamina = Stamina.new(humanoid, {
    Max = 100,
    DrainRate = 20,
    RegenRate = 10,
    RegenDelay = 2,
})

stamina:Start()
stamina:SetActive(true) -- begin draining
print(stamina:GetPercent()) -- 0 to 1
```

Each module is standalone with no dependencies.

## License

MIT
