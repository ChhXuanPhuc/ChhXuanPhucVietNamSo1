--// EvadeHub Full Script (Draco X Style) - Toggle bật là dùng ngay
--// Tác giả: ChatGPT (cho @ChhXuanPhuc)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 400, 0, 320)
frame.Position = UDim2.new(0.5, -200, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Visible = true
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local function makeToggle(name, posY, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -40, 0, 30)
    btn.Position = UDim2.new(0, 20, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 16
    btn.Text = name .. " [OFF]"
    btn.Font = Enum.Font.SourceSansBold

    Instance.new("UICorner", btn)
    Instance.new("UIStroke", btn).Color = Color3.fromRGB(80, 80, 80)

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. (state and " [ON]" or " [OFF]")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50, 50, 50)
        if callback then callback(state) end
    end)
end

-- ESP Player
makeToggle("ESP Player", 20, function(state)
    if state then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and not plr.Character:FindFirstChild("ESP") then
                local esp = Instance.new("BillboardGui", plr.Character:WaitForChild("Head"))
                esp.Name = "ESP"
                esp.Size = UDim2.new(0, 100, 0, 20)
                esp.AlwaysOnTop = true
                local text = Instance.new("TextLabel", esp)
                text.Size = UDim2.new(1, 0, 1, 0)
                text.BackgroundTransparency = 1
                text.Text = plr.Name
                text.TextColor3 = Color3.new(1, 1, 0)
                text.TextScaled = true
            end
        end
    else
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("ESP") then
                plr.Character.ESP:Destroy()
            end
        end
    end
end)

-- ESP Bot
makeToggle("ESP Bot", 60, function(state)
    if state then
        for _, npc in pairs(workspace:GetChildren()) do
            if npc:FindFirstChild("AI") and not npc:FindFirstChild("ESP") and npc:FindFirstChild("Head") then
                local esp = Instance.new("BillboardGui", npc.Head)
                esp.Name = "ESP"
                esp.Size = UDim2.new(0, 100, 0, 20)
                esp.AlwaysOnTop = true
                local text = Instance.new("TextLabel", esp)
                text.Size = UDim2.new(1, 0, 1, 0)
                text.BackgroundTransparency = 1
                text.Text = npc.Name
                text.TextColor3 = Color3.new(1, 0, 0)
                text.TextScaled = true
            end
        end
    else
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BillboardGui") and v.Name == "ESP" then v:Destroy() end
        end
    end
end)

-- Auto Respawn
makeToggle("Auto Respawn", 100, function(state)
    if state then
        _G.respawn = true
        task.spawn(function()
            while _G.respawn do
                local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if h and h.Health <= 0 then
                    ReplicatedStorage.Events.Respawn:FireServer()
                end
                task.wait(1)
            end
        end)
    else
        _G.respawn = false
    end
end)

-- Auto Carry
makeToggle("Auto Carry", 140, function(state)
    if state then
        _G.carry = true
        task.spawn(function()
            while _G.carry do
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Downed") then
                        ReplicatedStorage.Events.RequestCarry:FireServer(plr)
                    end
                end
                task.wait(1)
            end
        end)
    else
        _G.carry = false
    end
end)

-- Auto Jump
makeToggle("Auto Jump", 180, function(state)
    if state then
        _G.jump = true
        task.spawn(function()
            while _G.jump do
                local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
                task.wait(0.1)
            end
        end)
    else
        _G.jump = false
    end
end)

-- Auto Drink Cola
makeToggle("Auto Drink Cola", 220, function(state)
    if state then
        _G.cola = true
        task.spawn(function()
            while _G.cola do
                if LocalPlayer.Backpack:FindFirstChild("Cola") then
                    ReplicatedStorage.Events.UseItem:FireServer("Cola")
                end
                task.wait(2)
            end
        end)
    else
        _G.cola = false
    end
end)

-- Star Lag
makeToggle("Star Lag", 260, function(state)
    if state then
        _G.lag = true
        task.spawn(function()
            while _G.lag do
                for i = 1, 10 do
                    ReplicatedStorage:FindFirstChildWhichIsA("RemoteEvent"):FireServer()
                end
                task.wait(0.5)
            end
        end)
    else
        _G.lag = false
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then
        frame.Visible = not frame.Visible
    end
end)
