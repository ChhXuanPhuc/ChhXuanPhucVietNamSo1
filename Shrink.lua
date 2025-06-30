--// Shrink Hide & Seek ESP + Fly + UI Đẹp (UIv2)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Giao diện
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ShrinkESP_UIv2"

local frame = Instance.new("Frame", gui)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.Size = UDim2.new(0, 220, 0, 150)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.BackgroundTransparency = 0.05
frame.Active = true
frame.Draggable = true

local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0.25, 0)
title.Text = "✨ Shrink Hub ✨"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local function createToggleButton(name, yPos)
	local btn = Instance.new("TextButton", frame)
	btn.Name = name
	btn.Position = UDim2.new(0.1, 0, yPos, 0)
	btn.Size = UDim2.new(0.8, 0, 0.22, 0)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true
	btn.Text = name .. ": OFF"
	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 6)
	return btn
end

local espButton = createToggleButton("ESP", 0.35)
local flyButton = createToggleButton("Fly", 0.65)

-- ESP
local ESPEnabled = false

local function updateESP()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			if ESPEnabled then
				if not player.Character:FindFirstChild("FullHighlight") then
					local hl = Instance.new("Highlight", player.Character)
					hl.Name = "FullHighlight"
					hl.FillColor = Color3.fromRGB(255, 0, 0) -- đỏ
					hl.OutlineColor = Color3.fromRGB(255, 255, 255)
					hl.FillTransparency = 0.3
					hl.OutlineTransparency = 0
				end
			else
				if player.Character:FindFirstChild("FullHighlight") then
					player.Character.FullHighlight:Destroy()
				end
			end
		end
	end
end

espButton.MouseButton1Click:Connect(function()
	ESPEnabled = not ESPEnabled
	espButton.Text = "ESP: " .. (ESPEnabled and "ON" or "OFF")
	espButton.BackgroundColor3 = ESPEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50, 50, 50)
	updateESP()
end)

Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		wait(1)
		if ESPEnabled then updateESP() end
	end)
end)

-- Fly
local flying = false
local speed = 45
local bodyGyro, bodyVelocity

function startFly()
	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end

	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.P = 9e4
	bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
	bodyGyro.cframe = char.HumanoidRootPart.CFrame
	bodyGyro.Parent = char.HumanoidRootPart

	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Velocity = Vector3.zero
	bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	bodyVelocity.Parent = char.HumanoidRootPart

	RunService:BindToRenderStep("FlyMovement", Enum.RenderPriority.Character.Value + 1, function()
		if flying and char and char:FindFirstChild("HumanoidRootPart") then
			local moveVec = Vector3.zero
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then
				moveVec += workspace.CurrentCamera.CFrame.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then
				moveVec -= workspace.CurrentCamera.CFrame.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then
				moveVec -= workspace.CurrentCamera.CFrame.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then
				moveVec += workspace.CurrentCamera.CFrame.RightVector
			end
			bodyVelocity.Velocity = moveVec.Unit * speed
			bodyGyro.CFrame = workspace.CurrentCamera.CFrame
		end
	end)
end

function stopFly()
	RunService:UnbindFromRenderStep("FlyMovement")
	if bodyGyro then bodyGyro:Destroy() end
	if bodyVelocity then bodyVelocity:Destroy() end
end

flyButton.MouseButton1Click:Connect(function()
	flying = not flying
	flyButton.Text = "Fly: " .. (flying and "ON" or "OFF")
	flyButton.BackgroundColor3 = flying and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50, 50, 50)
	if flying then
		startFly()
	else
		stopFly()
	end
end)
