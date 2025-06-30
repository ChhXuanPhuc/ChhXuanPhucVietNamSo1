-- Shrink Hide & Seek ESP Script (Mobile + PC All Client)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- UI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "ShrinkESPMenu"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Position = UDim2.new(0, 20, 0, 100)
Frame.Size = UDim2.new(0, 180, 0, 80)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0.4, 0)
Title.Text = "Shrink ESP Menu"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextScaled = true

local Toggle = Instance.new("TextButton", Frame)
Toggle.Position = UDim2.new(0.1, 0, 0.5, 0)
Toggle.Size = UDim2.new(0.8, 0, 0.4, 0)
Toggle.Text = "ESP: OFF"
Toggle.BackgroundColor3 = Color3.fromRGB(50,50,50)
Toggle.TextColor3 = Color3.new(1,1,1)
Toggle.Font = Enum.Font.SourceSansBold
Toggle.TextScaled = true
Instance.new("UICorner", Toggle)

local ESPEnabled = false

Toggle.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    Toggle.Text = "ESP: " .. (ESPEnabled and "ON" or "OFF")
    Toggle.BackgroundColor3 = ESPEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50,50,50)

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            if ESPEnabled then
                if not player.Character.Head:FindFirstChild("ESPTag") then
                    local esp = Instance.new("BillboardGui", player.Character.Head)
                    esp.Name = "ESPTag"
                    esp.Size = UDim2.new(0, 100, 0, 20)
                    esp.AlwaysOnTop = true
                    local text = Instance.new("TextLabel", esp)
                    text.Size = UDim2.new(1, 0, 1, 0)
                    text.BackgroundTransparency = 1
                    text.Text = player.Name
                    text.TextColor3 = Color3.new(1, 1, 0)
                    text.TextScaled = true
                end
            else
                if player.Character.Head:FindFirstChild("ESPTag") then
                    player.Character.Head.ESPTag:Destroy()
                end
            end
        end
    end
end)

-- Tự cập nhật nếu người mới vào
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        if ESPEnabled then
            wait(1)
            local head = char:FindFirstChild("Head")
            if head and not head:FindFirstChild("ESPTag") then
                local esp = Instance.new("BillboardGui", head)
                esp.Name = "ESPTag"
                esp.Size = UDim2.new(0, 100, 0, 20)
                esp.AlwaysOnTop = true
                local text = Instance.new("TextLabel", esp)
                text.Size = UDim2.new(1, 0, 1, 0)
                text.BackgroundTransparency = 1
                text.Text = player.Name
                text.TextColor3 = Color3.new(1, 1, 0)
                text.TextScaled = true
            end
        end
    end)
end)
