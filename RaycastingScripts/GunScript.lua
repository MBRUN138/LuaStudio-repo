local replicatedstorage = game:GetService("ReplicatedStorage")
local userInputService = game:GetService("UserInputService")
local fireray = replicatedstorage:WaitForChild("FireRay")
local doreload = replicatedstorage:WaitForChild("DoReload")

-- Player
player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded()
local humanoid = character:WaitForChild("Humanoid")
local walkspeed = humanoid.WalkSpeed

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

-- Status
local status = tool.Status
local aiming = status.Aiming

-- Objects
local ammogui = objects.AmmoGui:Clone()
local namegui = objects.NameGui:Clone()
local counter = ammogui.Counter
local weaponname = namegui.WeaponName
local playergui = player:WaitForChild("PlayerGui")
ammogui.Parent = playergui
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
	namegui.Enabled = true
	ammogui.Enabled = true
end

local function DisableGui()
	namegui.Enabled = false
	ammogui.Enabled = false
end

-- Mouse
local mouse = player:GetMouse()

-- Bools
local CanFire = true
local CanReload = true
local Holding = false

-- ActionFunctions

local function Reload()
	if CanReload then
		CanReload = false
		Holding = false
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
	Holding = true
	if CanFire and clip > 0 then
		while Holding and clip > 0 do
			CanFire = false
			clip = clip - 1
			UpdateCounter()
			fireray:InvokeServer(tool)
			wait(waitTime)
			CanFire = true
		end
	end
	if clip == 0 then
		Reload()
	end	
end

local function Aim()
	aiming.Value = true
	humanoid.WalkSpeed = walkspeed/2
end

tool.Equipped:connect(function(mouse)
	mouse.Icon = mouseicon
	EnableGui()
	mouse.Button1Down:connect(Fire)
	mouse.Button1Up:connect(function()Holding = false end)
	mouse.Button2Down:connect(Aim)
	mouse.Button2Up:connect(function()
		aiming.Value = false
		humanoid.WalkSpeed = walkspeed
		end)
	userInputService.InputBegan:connect(function(key)
		if key.KeyCode == Enum.KeyCode.R then
			Reload()
		end
	end)
end)

tool.Unequipped:connect(function(mouse)
	humanoid.WalkSpeed = walkspeed
	Holding = false
	DisableGui()
end)
