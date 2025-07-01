-- SpectraPhucHub for Evade - Full CPI Version (Horizontal UI)
-- Features: ESP (Player + Bot), Infinite Jump, Emote Boost, Auto Respawn, Emote Dash, Logo UI

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
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

-- Logo
local Logo = Instance.new("ImageLabel", Main)
Logo.Size = UDim2.new(0, 40, 0, 40)
Logo.Position = UDim2.new(0, 10, 0, -5)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://80557621260986"

-- Title
local Title = Instance.new("TextLabel", Main)
Title.Text = "🌟 SpectraPhucHub - Evade 🌟"
Title.Size = UDim2.new(1, -60, 0, 40)
Title.Position = UDim2.new(0, 60, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255,255,0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

local tabs = {"Class Player", "ESP", "System"}
local tabFrames = {}
local sidebar = Instance.new("Frame", Main)
sidebar.Size = UDim2.new(0,120,1,-40)
sidebar.Position = UDim2.new(0,0,0,40)
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

-- Toggle Generator
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

-- CLASS PLAYER
local playerTab = tabFrames["Class Player"]

createToggle(playerTab, "Infinite Jump", function(enabled)
	_G.InfJump = enabled
	if enabled then
		UIS.JumpRequest:Connect(function()
			if _G.InfJump and hum then
				hum:ChangeState("Jumping")
			end
		end)
	end
end)

createToggle(playerTab, "Emote Speed Boost", function(enabled)
	_G.EmoteSpeed = enabled
	if enabled then
		if _G._ConnSpeed then _G._ConnSpeed:Disconnect() end
		_G._ConnSpeed = RunService.RenderStepped:Connect(function()
			local animator = hum:FindFirstChildOfClass("Animator")
			if animator then
				local playing = false
				for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
					if track.IsPlaying then playing = true break end
				end
				hum.WalkSpeed = playing and 70 or 16
			end
		end)
	else
		if _G._ConnSpeed then _G._ConnSpeed:Disconnect() end
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

-- ESP
local espTab = tabFrames["ESP"]

local function highlightObject(obj, color)
	local box = Instance.new("BoxHandleAdornment")
	box.Size = Vector3.new(4,5,1)
	box.Adornee = obj
	box.AlwaysOnTop = true
	box.ZIndex = 10
	box.Color3 = color
	box.Transparency = 0.3
	box.Parent = obj
	return box
end

local espObjects = {}

task.spawn(function()
	while task.wait(1) do
		for _,v in pairs(espObjects) do if v and v.Parent then v:Destroy() end end
		table.clear(espObjects)
		if _G.ESPPlayer then
			for _,plr in pairs(Players:GetPlayers()) do
				if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
					table.insert(espObjects, highlightObject(plr.Character, Color3.fromRGB(0,255,0)))
				end
			end
		end
		if _G.ESPBot then
			for _,npc in pairs(workspace:GetDescendants()) do
				if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(npc) then
					if npc:FindFirstChild("HumanoidRootPart") then
						table.insert(espObjects, highlightObject(npc, Color3.fromRGB(255,0,0)))
					end
				end
			end
		end
	end
end)

createToggle(espTab, "ESP Player", function(state)
	_G.ESPPlayer = state
end)

createToggle(espTab, "ESP Bot", function(state)
	_G.ESPBot = state
end)

-- SYSTEM
local systemTab = tabFrames["System"]
createToggle(systemTab, "Auto Respawn", function(enabled)
	_G.AutoRespawn = enabled
	if enabled then
		spawn(function()
			while _G.AutoRespawn do
				task.wait(1.5)
				local char = player.Character
				if char and char:FindFirstChild("Downed") then
					local event = RS:FindFirstChild("Events") and RS.Events:FindFirstChild("Respawn")
					if event then
						event:FireServer()
					end
				end
			end
		end)
	end
end)

-- Toggle UI
UIS.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.RightShift then
		Main.Visible = not Main.Visible
	end
end)
