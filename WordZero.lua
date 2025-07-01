-- Auto Farm for World // Zero - World 1 (Fixed)
-- Features: Auto Farm Mob, Auto Pickup Gold/Item, Auto Hit
-- Made for Xeno Executor

-- UI Setup
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = OrionLib:MakeWindow({Name = "W//Z AutoFarm Hub", HidePremium = false, SaveConfig = false, ConfigFolder = "WZAuto"})

-- Toggles
local autoFarm = false
local autoPickup = false

-- Main Loop
task.spawn(function()
    while true do
        task.wait(0.2)
        pcall(function()
            if autoFarm then
                local mobs = workspace:FindFirstChild("Enemies") or workspace:FindFirstChild("Mobs") or workspace:FindFirstChild("Hostiles")
                if mobs then
                    for _, mob in pairs(mobs:GetChildren()) do
                        if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Health") and mob.Health.Value > 0 then
                            local char = game.Players.LocalPlayer.Character
                            if char and char:FindFirstChild("HumanoidRootPart") then
                                char:PivotTo(mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2))
                                wait(0.1)
                                mouse1click() -- đánh
                            end
                        end
                    end
                end
            end

            if autoPickup then
                for _, drop in pairs(workspace:GetChildren()) do
                    if drop:IsA("Part") and (drop.Name:lower():find("gold") or drop.Name:lower():find("item")) then
                        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, drop, 0)
                        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, drop, 1)
                    end
                end
            end
        end)
    end
end)

-- GUI Toggle
local tab = Window:MakeTab({Name = "Auto Farm", Icon = "rbxassetid://4483345998", PremiumOnly = false})
tab:AddToggle({
    Name = "Auto Farm (Mob)",
    Default = false,
    Callback = function(v) autoFarm = v end
})
tab:AddToggle({
    Name = "Auto Pickup (Gold/Item)",
    Default = false,
    Callback = function(v) autoPickup = v end
})

OrionLib:Init()
