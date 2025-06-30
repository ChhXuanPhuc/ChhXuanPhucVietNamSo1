-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 260)
frame.Position = UDim2.new(0, 20, 0.5, -130)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local function addButton(text, y, func)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.Text = text
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	btn.MouseButton1Click:Connect(func)
end

-- ESP Function
function createESP(target, color)
	if not target:FindFirstChild("Head") then return end
	if target:FindFirstChild("EvadeESP") then return end

	local box = Instance.new("BillboardGui", target)
	box.Name = "EvadeESP"
	box.AlwaysOnTop = true
	box.Size = UDim2.new(0, 100, 0, 30)
	box.Adornee = target:FindFirstChild("Head")

	local text = Instance.new("TextLabel", box)
	text.Size = UDim2.new(1, 0, 1, 0)
	text.BackgroundTransparency = 1
	text.Text = target.Name
	text.TextColor3 = color
	text.TextScaled = true
	text.Font = Enum.Font.GothamBold
end

-- ESP Bot
addButton("🤖 ESP Bot", 10, function()
	for _, bot in pairs(workspace:GetDescendants()) do
		if bot:FindFirstChild("AI") and bot:FindFirstChild("Head") then
			createESP(bot, Color3.fromRGB(255, 0, 0))
		end
	end
end)

-- ESP Player
addButton("👤 ESP Player", 50, function()
	for _, p in pairs(game.Players:GetPlayers()) do
		if p ~= game.Players.LocalPlayer and p.Character then
			createESP(p.Character, Color3.fromRGB(0, 255, 0))
		end
	end
end)

-- Auto Respawn
addButton("♻️ Auto Respawn", 90, function()
	local RS = game:GetService("ReplicatedStorage")
	local found = false

	for _, folder in pairs(RS:GetChildren()) do
		for _, ev in pairs(folder:GetChildren()) do
			if ev:IsA("RemoteEvent") and ev.Name:lower():find("respawn") then
				found = true
				game:GetService("RunService").RenderStepped:Connect(function()
					local char = game.Players.LocalPlayer.Character
					if char and char:FindFirstChild("Dead") then
						ev:FireServer()
					end
				end)
				warn("✅ Auto Respawn activated:", ev.Name)
				break
			end
		end
		if found then break end
	end

	if not found then
		warn("⚠️ Không tìm thấy event Respawn.")
	end
end)

-- Auto Carry
addButton("💪 Auto Carry", 130, function()
	local player = game.Players.LocalPlayer
	local carryEvent = nil

	for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
		if v:IsA("RemoteEvent") and v.Name:lower():find("carry") then
			carryEvent = v
			break
		end
	end

	if not carryEvent then
		warn("❌ Không tìm thấy Carry RemoteEvent.")
		return
	end

	while true do
		wait(0.5)
		for _, other in pairs(game.Players:GetPlayers()) do
			if other ~= player and other.Character and other.Character:FindFirstChild("Dead") then
				local dist = (other.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
				if dist < 10 then
					carryEvent:FireServer(other.Character)
					break
				end
			end
		end
	end
end)

-- Close Menu
addButton("❌ Đóng Menu", 170, function()
	gui:Destroy()
end)
