local replicatedstorage = game:GetService("ReplicatedStorage")
local userInputService = game:GetService("UserInputService")
local fireray = replicatedstorage:WaitForChild("FireRay")
local doreload = replicatedstorage:WaitForChild("DoReload")

-- Player
player = game.Players.LocalPlayer
local charater = player.Character or player.CharacterAdded()
local humanoid = charater:WaitForChild("Humanoid")

-- Tool
local tool = script.Parent.Parent
local objects = script.Objects

-- Configs
local configs = tool.Configs
local waitTime = configs.WaitTime.Value
local mouseicon = configs.MouseIcon.Value
local reloadtime = configs.ReloadTime.Value
local capacity = configs.Clip.Value
local clip = capacity

-- Objects
local screengui = objects.AmmoGui:Clone()
local namegui = objects.NameGui:Clone()
local weaponname = namegui.WeaponName
local counter = screengui.Counter
local playergui = player:WaitForChild("PlayerGui")
screengui.Parent = playergui
namegui.Parent = playergui

weaponname.Text = tool.Name

-- Functions
local function UpdateCounter()
	counter.Text = clip .. " / " .. capacity
end
UpdateCounter()

local function EditCounter(str)
	counter.Text = str
end

local function EnableGui()
	screengui.Enabled = true
	namegui.Enabled = true
end

local function DisableGui()
	screengui.Enabled = false
	namegui.Enabled = false
end

-- Mouse
local mouse = player:GetMouse()
mouse.Icon = mouseicon

-- Bools
local CanFire = true
local CanReload = true

-- ActionFunctions

local function Reload()
	if CanReload then
		CanReload = false
		CanFire = false
		doreload:InvokeServer(tool)
		EditCounter("[reloading]")
		wait(reloadtime)
		clip = capacity
		UpdateCounter()
		CanFire = true
		CanReload = true
	end
end

local function Fire()
	if CanFire and clip > 0 then
	clip = clip - 1
	UpdateCounter()
	CanFire = false
	fireray:InvokeServer(tool)
	wait(waitTime)
	CanFire = true
	end
	if clip == 0 then
		Reload()
	end
end

tool.Equipped:connect(function(mouse)
	mouse.Icon = mouseicon
	EnableGui()
	mouse.Button1Down:connect(Fire)
	userInputService.InputBegan:connect(function(key)
		if key.KeyCode == Enum.KeyCode.R then
			Reload()
		end
	end)
end)

tool.Unequipped:connect(function(mouse)
	DisableGui()	
end)
