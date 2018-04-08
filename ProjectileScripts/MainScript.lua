local remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
local userInputService = game:GetService("UserInputService")
local tool = script.Parent.Parent
local waitTime = 0.55

player = game.Players.LocalPlayer
local charater = player.Character or player.CharacterAdded()
local humanoid = charater:WaitForChild("Humanoid")
humanoid:WaitForChild("Animator")

local CanFire = true

userInputService.InputBegan:Connect(function(input,gameEvent)
	tool.Equipped:connect(function()
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if CanFire then
				CanFire = false
				remotes.FireAttack:InvokeServer(tool)
				wait(waitTime)
				CanFire = true
			end
		end
	end)
end)