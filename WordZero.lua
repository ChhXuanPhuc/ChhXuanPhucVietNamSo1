-- World // Zero Auto Farm - World 1
-- Executor: Xeno | Script by ChatGPT
-- Features: Auto Farm, Auto Boss, Auto Item, Auto Gold, GUI Toggle

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- UI Library
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = OrionLib:MakeWindow({Name = "World // Zero - Auto Farm", HidePremium = false, SaveConfig = false, IntroText = "W//Z AutoFarm Hub"})

-- Toggles
local autoFarm = false
local autoPickup = false

-- Auto Teleport + Attack
function findNearestMob()
    local closest, distance = nil, math.huge
    for _, v in pairs(workspace.Mobs:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid") and v:FindFirstChildOfClass("Humanoid").Health > 0 then
            local dist = (v.HumanoidRootPart.Position - Char.HumanoidRootPart.Position).Magnitude
            if dist < distance then
                closest = v
                distance = dist
            end
        end
    end
    return closest
end

function attackMob()
    pcall(function()
        local mob = findNearestMob()
        if mob then
            local goal = {CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)}
            TweenService:Create(Char.HumanoidRootPart, TweenInfo.new(0.3), goal):Play()
            wait(0.4)
            Char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            mouse1click()
        end
    end)
end

-- Auto Farm Loop
RunService.RenderStepped:Connect(function()
    if autoFarm then
        attackMob()
    end
    if autoPickup then
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Part") and v.Name:lower():find("gold") then
                firetouchinterest(Char.HumanoidRootPart, v, 0)
                wait()
                firetouchinterest(Char.HumanoidRootPart, v, 1)
            end
        end
    end
end)

-- GUI Tabs
local tab = Window:MakeTab({Name = "Auto Farm", Icon = "rbxassetid://4483345998", PremiumOnly = false})
tab:AddToggle({
    Name = "Auto Farm (Mob + Boss)",
    Default = false,
    Callback = function(v)
        autoFarm = v
    end
})
tab:AddToggle({
    Name = "Auto Pickup Gold/Item",
    Default = false,
    Callback = function(v)
        autoPickup = v
    end
})
tab:AddButton({
    Name = "Teleport to Dungeon Door",
    Callback = function()
        local door = workspace:FindFirstChild("DungeonTeleporter")
        if door then
            Char:PivotTo(door.CFrame + Vector3.new(0, 2, 0))
        end
    end
})

OrionLib:Init()
