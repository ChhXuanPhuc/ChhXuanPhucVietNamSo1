-- ✅ World Zero Auto Farm UI - World 1 (Xeno Ready)
-- 📌 Menu bằng RightShift | Auto Mob | Không GUI nặng

-- UI Setup (UI gọn, bật bằng RightShift)
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local HRP = Char:WaitForChild("HumanoidRootPart")

-- Create UI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "WZAutoFarmUI"
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 240, 0, 140)
frame.Position = UDim2.new(0, 20, 0, 200)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Visible = false

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "World // Zero AutoFarm"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Position = UDim2.new(0, 20, 0, 50)
toggleBtn.Size = UDim2.new(0, 200, 0, 40)
toggleBtn.Text = "🟥 Auto Farm: OFF"
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 16

-- Toggle UI on RightShift
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        frame.Visible = not frame.Visible
    end
end)

-- Logic: Auto Farm
local farming = false

toggleBtn.MouseButton1Click:Connect(function()
    farming = not farming
    toggleBtn.Text = farming and "🟩 Auto Farm: ON" or "🟥 Auto Farm: OFF"
    toggleBtn.BackgroundColor3 = farming and Color3.fromRGB(20, 130, 20) or Color3.fromRGB(50, 50, 50)
end)

-- Get closest valid mob (Health < MaxHealth)
function getClosestMob()
    local closest, dist = nil, math.huge
    for _, mob in pairs(workspace:FindFirstChild("NPC"):GetChildren()) do
        local hum = mob:FindFirstChild("Humanoid")
        local root = mob:FindFirstChild("HumanoidRootPart")
        if hum and root and hum.Health > 0 and hum.MaxHealth > 0 and hum.Health < hum.MaxHealth then
            local d = (root.Position - HRP.Position).Magnitude
            if d < dist then
                closest = mob
                dist = d
            end
        end
    end
    return closest
end

-- Auto farm loop
RS.RenderStepped:Connect(function()
    if farming and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        HRP = LP.Character.HumanoidRootPart
        local mob = getClosestMob()
        if mob then
            HRP.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
            wait(0.1)
            mouse1click()
        end
    end
end)
