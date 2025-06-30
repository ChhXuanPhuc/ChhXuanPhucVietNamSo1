--// EvadeHub - Draco X Style GUI Script for Roblox Evade
-- Made by ChatGPT for @ChhXuanPhuc

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "EvadeHubGUI"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 320)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Thickness = 1.5
UIStroke.Color = Color3.fromRGB(85, 170, 255)

-- Toggle Template
local function createToggle(name, posY, callback)
    local Toggle = Instance.new("TextButton", MainFrame)
    Toggle.Size = UDim2.new(1, -40, 0, 30)
    Toggle.Position = UDim2.new(0, 20, 0, posY)
    Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Toggle.TextColor3 = Color3.new(1, 1, 1)
    Toggle.TextSize = 16
    Toggle.Text = name .. " [OFF]"
    Toggle.Font = Enum.Font.SourceSansBold

    local UICorner = Instance.new("UICorner", Toggle)
    local UIStroke = Instance.new("UIStroke", Toggle)
    UIStroke.Color = Color3.fromRGB(80, 80, 80)

    local state = false
    Toggle.MouseButton1Click:Connect(function()
        state = not state
        Toggle.Text = name .. (state and " [ON]" or " [OFF]")
        Toggle.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50, 50, 50)
        if callback then callback(state) end
    end)
end

-- Toggle Features
createToggle("ESP Players", 20, function(state)
    -- Toggle ESP for players
end)

createToggle("ESP Bots", 60, function(state)
    -- Toggle ESP for Nextbots
end)

createToggle("Auto Respawn", 100, function(state)
    -- Toggle auto respawn logic
end)

createToggle("Auto Carry", 140, function(state)
    -- Toggle auto carry logic
end)

createToggle("Auto Jump", 180, function(state)
    if state then
        jumpConn = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    elseif jumpConn then
        jumpConn:Disconnect()
    end
end)

createToggle("Auto Drink Cola", 220, function(state)
    -- Toggle logic for auto drinking cola
end)

createToggle("Star Lag", 260, function(state)
    -- Trigger star lag effect
end)

-- Toggle GUI with RightShift
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Initial visibility
MainFrame.Visible = true
