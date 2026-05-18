--!strict
-- server-side only

local Debris = game:GetService("Debris")

local Knockback = {}

function Knockback.apply(character, direction: Vector3, force: number, duration: number?)
	local hrp = character:FindFirstChild("HumanoidRootPart") :: BasePart?
	if not hrp then return end

	local bv = Instance.new("BodyVelocity")
	bv.Velocity = direction.Unit * force + Vector3.new(0, force * 0.25, 0)
	bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	bv.P = 1e4
	bv.Parent = hrp

	-- short lifetime so it doesn't fight player movement after the hit
	Debris:AddItem(bv, duration or 0.15)
end

-- convenience variant for area abilities — calculates direction away from origin automatically
function Knockback.applyFromOrigin(character, origin: Vector3, force: number, duration: number?)
	local hrp = character:FindFirstChild("HumanoidRootPart") :: BasePart?
	if not hrp then return end
	Knockback.apply(character, hrp.Position - origin, force, duration)
end

return Knockback
