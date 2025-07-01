-- ✅ WorldZeroLite - Auto Farm (Không cần OrionLib, chạy ổn trên Xeno)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VInput = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local HRP = LP.Character:WaitForChild("HumanoidRootPart")

-- Menu trạng thái
local autoFarm = false
local autoSkill = false
local autoLoot = false
local menuVisible = false

-- Toggle menu bằng phím B
UserInputService.InputBegan:Connect(function(key, gp)
	if gp then return end
	if key.KeyCode == Enum.KeyCode.B then
		menuVisible = not menuVisible
		print("📜 WorldZeroLite Menu:")
		print("1. [F] Toggle Auto Farm:", autoFarm and "ON" or "OFF")
		print("2. [L] Toggle Auto Loot :", autoLoot and "ON" or "OFF")
		print("3. [K] Toggle Auto Skill:", autoSkill and "ON" or "OFF")
		print("Nhấn B để ẩn menu.")
	end
	if menuVisible then
		if key.KeyCode == Enum.KeyCode.F then autoFarm = not autoFarm end
		if key.KeyCode == Enum.KeyCode.L then autoLoot = not autoLoot end
		if key.KeyCode == Enum.KeyCode.K then autoSkill = not autoSkill end
	end
end)

-- Tìm mob thật
function isMob(m)
	if m:IsA("Model") and m:FindFirstChild("HumanoidRootPart") then
		local hum = m:FindFirstChildOfClass("Humanoid")
		if hum and hum.Health > 0 then
			for _, p in pairs(Players:GetPlayers()) do
				if p.Character == m then return false end
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
	while true do wait(0.4)
		if autoFarm and HRP then
			local mob = getClosestMob()
			if mob then
				local tween = TweenService:Create(HRP, TweenInfo.new(0.3), {
					CFrame = CFrame.new(mob.Position + Vector3.new(0,0,3))
				})
				tween:Play()
				wait(0.3)
				VInput:SendMouseButtonEvent(0, 0, 0, true, game, 0)
				VInput:SendMouseButtonEvent(0, 0, 0, false, game, 0)
			end
		end
	end
end)

-- Auto Skill (Q/E/R)
task.spawn(function()
	while true do wait(1)
		if autoSkill then
			for _, key in pairs({"Q", "E", "R"}) do
				VInput:SendKeyEvent(true, key, false, game)
				wait(0.1)
				VInput:SendKeyEvent(false, key, false, game)
			end
		end
	end
end)

-- Auto Loot (E)
task.spawn(function()
	while true do wait(0.3)
		if autoLoot then
			VInput:SendKeyEvent(true, "E", false, game)
			wait(0.1)
			VInput:SendKeyEvent(false, "E", false, game)
		end
	end
end)
