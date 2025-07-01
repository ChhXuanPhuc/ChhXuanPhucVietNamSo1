-- ✅ Bản sửa lỗi: tìm mob trực tiếp trong workspace
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VInput = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local HRP = LP.Character:WaitForChild("HumanoidRootPart")

-- Trạng thái toggle
local autoFarm, autoSkill, autoLoot, menuVisible = false, false, false, false

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.B then
		menuVisible = not menuVisible
		print("== 🌍 WorldZeroLite Menu ==")
		print("[F] Auto Farm:", autoFarm)
		print("[L] Auto Loot :", autoLoot)
		print("[K] Auto Skill:", autoSkill)
	end
	if menuVisible then
		if input.KeyCode == Enum.KeyCode.F then autoFarm = not autoFarm print("Auto Farm:", autoFarm) end
		if input.KeyCode == Enum.KeyCode.L then autoLoot = not autoLoot print("Auto Loot:", autoLoot) end
		if input.KeyCode == Enum.KeyCode.K then autoSkill = not autoSkill print("Auto Skill:", autoSkill) end
	end
end)

-- Kiểm tra mob
function isMob(model)
	if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") then
		local hum = model:FindFirstChildOfClass("Humanoid")
		if hum and hum.Health > 0 then
			for _, p in pairs(Players:GetPlayers()) do
				if p.Character == model then return false end
			end
			return true
		end
	end
	return false
end

function getClosestMob()
	local nearest, dist = nil, math.huge
	for _, m in pairs(workspace:GetChildren()) do
		if isMob(m) then
			local root = m:FindFirstChild("HumanoidRootPart")
			if root then
				local d = (HRP.Position - root.Position).Magnitude
				if d < dist then
					dist = d
					nearest = root
				end
			end
		end
	end
	return nearest
end

-- Auto Farm
task.spawn(function()
	while task.wait(0.4) do
		if autoFarm and HRP then
			local mob = getClosestMob()
			if mob then
				local pos = mob.Position + Vector3.new(0, 0, 3)
				local tween = TweenService:Create(HRP, TweenInfo.new(0.3), {CFrame = CFrame.new(pos)})
				tween:Play()
				task.wait(0.3)
				VInput:SendMouseButtonEvent(0, 0, 0, true, game, 0)
				VInput:SendMouseButtonEvent(0, 0, 0, false, game, 0)
			end
		end
	end
end)

-- Auto Skill
task.spawn(function()
	while wait(1) do
		if autoSkill then
			for _, key in {"Q", "E", "R"} do
				VInput:SendKeyEvent(true, key, false, game)
				wait(0.1)
				VInput:SendKeyEvent(false, key, false, game)
			end
		end
	end
end)

-- Auto Loot
task.spawn(function()
	while wait(0.3) do
		if autoLoot then
			VInput:SendKeyEvent(true, "E", false, game)
			wait(0.1)
			VInput:SendKeyEvent(false, "E", false, game)
		end
	end
end)
