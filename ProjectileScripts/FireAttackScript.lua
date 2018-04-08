local damage = 50
local remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
local physicsService = game:GetService("PhysicsService")
local fireAttack = remotes.FireAttack
fireAttack.Name = "FireAttack"

local function onFireAttack(player,tool)
	local barrel = tool.Barrel
	local mouse = player:GetMouse()
	local character = player.Character

	if character then
		local humanoid = character:FindFirstChild("Humanoid")
		-- Animations here
		
		local light = Instance.new("PointLight",barrel)
		local smoke = Instance.new("Smoke",barrel)
		smoke.Size = 1
		spawn(function()
			wait()
			light:Destroy()
			while smoke.Size > 0.2 do
				smoke.Size = smoke.Size - 0.2
				wait()
			end
			smoke.Enabled = false
			wait(5)
			smoke:Destroy()
		end)
		
		local orb = Instance.new("Part",workspace)
		orb.Shape = "Ball"
		orb.Material = "Neon"
		orb.BrickColor = BrickColor.new("White")
		orb.CanCollide = false
		orb.Size = Vector3.new(0.5,0.5,0.5)
		--orb.RotVelocity = Vector3.new(5,5,5)
		
		orb.CFrame = barrel.CFrame
		
		-- Body Forces
		local velocity = Instance.new("BodyVelocity")
		velocity.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
		velocity.Velocity = mouse.Hit.lookVector * 600
		
		velocity.Parent = orb
		game.Debris:AddItem(orb)
		
		orb:SetNetworkOwner(nil)
		
		orb.Touched:connect(function(part)
			if part.Parent ~= tool and part.Parent ~= player then
				
				local human = part.Parent:FindFirstChild("Humanoid")
				if human then
					human:TakeDamage(damage)
				end

				local flash = Instance.new("Part",workspace)
				flash.Shape = "Ball"
				flash.Material = "Neon"
				flash.BrickColor = BrickColor.new("White")
				flash.CanCollide = false
				flash.Anchored = true
				flash.Size = orb.Size
				flash.CFrame = orb.CFrame
				orb.Transparency = 1
				orb.Anchored = true
				
				while flash.Transparency < 1 do
					flash.Size = flash.Size + Vector3.new(0.4,0.4,0.4)
					flash.Transparency = flash.Transparency + 0.15
					wait()
				end
				flash:Destroy()
				orb:Destroy()
			end
		end)
	end
end

remotes.FireAttack.OnServerInvoke = onFireAttack
