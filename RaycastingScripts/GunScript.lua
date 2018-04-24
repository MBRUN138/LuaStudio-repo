local replicatedstorage = game:GetService("ReplicatedStorage")

-- Class Enums
local handgun, assaultrifle, shotgun, longrifle, other =
 "Handgun","AssultRifle","Shotgun","LongRifle","Other"

function Handgun() return handgun end
function AssaultRifle() return assaultrifle end
function Shotgun() return shotgun end
function LongRifle() return longrifle end
function Other() return other end

-- Handguns
local h_animations = script.Animations

-- AssaultRifles
-- Shotguns
-- LongRifles
-- Others

-- LoadAnimations
local function LoadAnimations(humanoid,class)
	if class == Handgun() then
		local fire = humanoid:LoadAnimation(h_animations.Fire)
		return fire
	end
end

-- Create Remote
local fireray = Instance.new("RemoteFunction")
fireray.Parent = replicatedstorage
fireray.Name = "FireRay"

local function onFireRay(player,tool)
	
	local playerfolder = workspace["@"..player.Name]
	
	-- Configs
	local configs = tool.Configs
	local damage = configs.Damage.Value
	local class = configs.Class.Value
	local color = configs.RayColor.Value
	local pellets = configs.Pellets.Value
	
	local barrel = tool.Barrel
	local flash = barrel.Flash
	local mouse = player:GetMouse()
	mouse.TargetFilter = playerfolder
	local character = player.Character
	
	local n_hitsound = script.NeutralHitSound:Clone()
	local p_hitsound = script.PlayerHitSound:Clone()
	
	-- Status
	local status = tool.Status
	local aiming = status.Aiming.Value
	
	-- Objects
	local scripts = tool.Scripts
	local raycastscript = scripts:FindFirstChild("SemiRaycastScript") or scripts:FindFirstChild("AutoRaycastScript")
	local objects = raycastscript.Objects
	local firesound = objects.FireSound:Clone()
	firesound.Parent = barrel
	
	if character then
		firesound:Play()
		-- Animations
		local humanoid = character:FindFirstChild("Humanoid")
		local fire = LoadAnimations(humanoid,class)
		fire:Play()
		
		flash.Color = ColorSequence.new(color)
		flash.Enabled = true
		
		local light = Instance.new("PointLight",barrel)
		light.Color = color
		
		spawn(function()
			light:Destroy()
			flash.Enabled = false
		end)
		
		local function rand(a, b)
		    return a + math.random() * (b - a)
		end
		
		for i = 1, pellets, 1 do
		
			local accuracy = 2
					
			local barrelCF = barrel.CFrame
			barrelCF = barrelCF * CFrame.Angles(0, 0, rand(0, math.pi/accuracy))
			barrelCF = barrelCF * CFrame.Angles(rand(0,0.1), 0, 0)
			
			local mouseCF = mouse.Hit
			mouseCF = mouseCF * CFrame.Angles(0, 0, rand(0, math.pi/accuracy))
			mouseCF = mouseCF * CFrame.Angles(rand(0,0.1),0,0)
			
			local part, position
			if not aiming then 
				local ray = Ray.new(barrelCF.p, mouseCF.lookVector * 300) 
				part, position = workspace:FindPartOnRayWithIgnoreList(ray,{character,playerfolder})
			else
				local ray = Ray.new(barrel.CFrame.p, (mouse.Hit.p - barrel.CFrame.p) * 300) 
				part, position = workspace:FindPartOnRayWithIgnoreList(ray,{character,playerfolder})
			end
			
			local beam = Instance.new("Part",workspace.bin)
			beam.Name = "Beam"
			beam.Color = color
			beam.Material = "Neon"
			beam.Transparency = 0.9
			beam.Anchored = true
			beam.CanCollide = false
		
			local distance = (barrel.CFrame.p - position).magnitude
			beam.Size = Vector3.new(0.1, 0.1, distance)
			beam.CFrame = CFrame.new(barrel.CFrame.p, position) * CFrame.new(0, 0, -distance / 2)
	
			spawn(function()
				while beam.Transparency < 1 do
					beam.Transparency = beam.Transparency + 0.15
					wait()
				end
				beam:Destroy()
			end)
			
			if part then
			
				local humanoid = part.Parent:FindFirstChild("Humanoid")
				if not humanoid then 
					humanoid = part.Parent.Parent:FindFirstChild("Humanoid")
				end
				if humanoid then
					p_hitsound.Parent = part
					p_hitsound:Play()
					if part.Name == "Head" then
						humanoid:TakeDamage(damage * 1.5)
					else
						humanoid:TakeDamage(damage)
					end
				else
					local hit = Instance.new("Part",workspace.bin)
					hit.CanCollide = false
					hit.Anchored = true
					hit.Size = Vector3.new(0.1,0.1,0.1)
					hit.Shape = "Ball"
					hit.Color = color
					hit.Position = position
					hit.Material = "Neon"
					n_hitsound.Parent = hit
					n_hitsound:Play()
								
					game:GetService("Debris"):AddItem(hit,0.1)
				end
			end
		end
	end
end

fireray.OnServerInvoke = onFireRay
