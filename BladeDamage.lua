local player = game:GetService(“Players”).LocalPlayer
local blade = script.Parent
local damage = 25
local CanHit = true

blade.Touched:connect(function(part)
    local humanoid = part.Parent.FindFirstChild(“Humanoid”)
    if humanoid then
        humanoid:TakeDamage(damage)
        
end)


