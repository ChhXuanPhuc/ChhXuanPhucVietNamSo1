-- SpectraPhucHub for Evade - Horizontal UI
-- UI giống TurboLite - Giao diện ngang, chia tab

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

-- UI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "SpectraPhucHub"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 600, 0, 300)
Main.Position = UDim2.new(0.5, -300, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(30,30,30)
Main.BorderSizePixel = 0
Main.Visible = true
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Text = "🌟 SpectraPhucHub - Evade 🌟"
Title.Size = UDim2.new(1,0,0,30)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255,255,0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

local tabs = {"Class Player", "ESP", "System"}
local tabFrames = {}
local sidebar = Instance.new("Frame", Main)
sidebar.Size = UDim2.new(0,120,1,0)
sidebar.Position = UDim2.new(0,0,0,30)
sidebar.BackgroundColor3 = Color3.fromRGB(25,25,25)

local function clearTabs()
	for _,f in pairs(tabFrames) do f.Visible = false end
end

for i, tabName in ipairs(tabs) do
	local btn = Instance.new("TextButton", sidebar)
	btn.Size = UDim2.new(1,0,0,30)
	btn.Position = UDim2.new(0,0,0,(i-1)*30)
	btn.Text = tabName
	btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14

	local frame = Instance.new("Frame", Main)
	frame.Size = UDim2.new(1,-130,1,-40)
	frame.Position = UDim2.new(0,130,0,40)
	frame.BackgroundTransparency = 1
	frame.Visible = false
	tabFrames[tabName] = frame

	btn.MouseButton1Click:Connect(function()
		clearTabs()
		frame.Visible = true
	end)

	if i == 1 then
		frame.Visible = true
	end
end

-- Class Player Tab
local function createToggle(parent, text, callback)
	local toggle = Instance.new("TextButton", parent)
	toggle.Size = UDim2.new(1, -20, 0, 30)
	toggle.Position = UDim2.new(0, 10, 0, #parent:GetChildren()*35)
	toggle.BackgroundColor3 = Color3.fromRGB(45,45,45)
	toggle.TextColor3 = Color3.fromRGB(0,255,0)
	toggle.Font = Enum.Font.Gotham
	toggle.TextSize = 14
	toggle.Text = text .. ": OFF"
	local state = false
	toggle.MouseButton1Click:Connect(function()
		state = not state
		toggle.Text = text .. ": " .. (state and "ON" or "OFF")
		callback(state)
	end)
end

local playerTab = tabFrames["Class Player"]
createToggle(playerTab, "Infinite Jump", function(enabled)
	if enabled then
		_G.InfJump = true
		UIS.JumpRequest:Connect(function()
			if _G.InfJump and hum then
				hum:ChangeState("Jumping")
			end
		end)
	else
		_G.InfJump = false
	end
end)

createToggle(playerTab, "Emote Speed Boost", function(enabled)
	if enabled then
		RunService.RenderStepped:Connect(function()
			if not _G.EmoteSpeed then return end
			local animator = hum:FindFirstChildOfClass("Animator")
			if animator then
				for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
					if track.IsPlaying then
						hum.WalkSpeed = 70
						return
					end
				end
			end
		hum.WalkSpeed = 16
		end)
		_G.EmoteSpeed = true
	else
		_G.EmoteSpeed = false
		hum.WalkSpeed = 16
	end
end)

createToggle(playerTab, "Emote Dash (V)", function(state)
	_G.EmoteDash = state
end)

UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.V and _G.EmoteDash then
		hum.PlatformStand = true
		local bv = Instance.new("BodyVelocity")
		bv.Velocity = hrp.CFrame.LookVector * 100 + Vector3.new(0, 25, 0)
		bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
		bv.Parent = hrp
		task.wait(0.35)
		bv:Destroy()
		hum.PlatformStand = false
	end
end)

-- ESP Tab (placeholder)
local espTab = tabFrames["ESP"]
createToggle(espTab, "ESP Player", function(state)
	-- Add your ESP player logic here
end)
createToggle(espTab, "ESP Bot", function(state)
	-- Add your ESP bot logic here
end)

-- System Tab
local systemTab = tabFrames["System"]
createToggle(systemTab, "Auto Respawn", function(enabled)
	if enabled then
		spawn(function()
			while wait(1) do
				if not player.Character or player.Character:FindFirstChild("Downed") then
					game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Respawn"):FireServer()
				end
			end
		end)
	end
end)
