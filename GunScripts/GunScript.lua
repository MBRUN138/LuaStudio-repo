local player = game:GetService("Players").LocalPlayer
local barrel = script.Parent.Barrel
local handle = script.Parent.Handle
local damage = 70
local mouse = player:GetMouse()
local tool = script.Parent

mouse.Button1Down:connect(function()
	local ray = Ray.new(tool.Barrel.CFrame.p,(mouse.Hit.p-tool.Barrel.CFrame.p).unit * 300)
	local part, position = workspace:FindPartOnRay(ray, player.Character, false, true)
	
	local beam = Instance.new("Part", workspace)
	beam.BrickColor = BrickColor.new("Bright red")
	beam.FormFactor = "Custom"
	beam.Material = "Neon"
	beam.Transparency = 0.25
	beam.Anchored = true
	beam.Locked = true
	beam.CanCollide = false

	local distance = (tool.Handle.CFrame.p - position).magnitude
	beam.Size = Vector3.new(0.3, 0.3, distance)
	beam.CFrame = CFrame.new(tool.Handle.CFrame.p, position) * CFrame.new(0, 0, -distance / 2)

	game:GetService("Debris"):AddItem(beam, 0.1)
	
	if part then
		local humanoid = part.Parent:FindFirstChild("Humanoid")
		if not humanoid then 
			humanoid = part.Parent.Parent:FindFirstChild("Humanoid")
		end
		if humanoid then
			humanoid:TakeDamage(damage)
		end
	end	
end)

