--// WorldZeroHub.lua
-- ✅ Full Auto Farm World // Zero - World 1 | Xeno Executor | Menu RightShift

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualInput = game:GetService("VirtualInputManager")
local LP = Players.LocalPlayer
local HRP = LP.Character:WaitForChild("HumanoidRootPart")

-- UI Library
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local Window = OrionLib:MakeWindow({
    Name = "🌍 WorldZeroHub",
    HidePremium = false,
    SaveConfig = false,
    IntroEnabled = false
})

local AutoFarmToggle = false
local AutoLootToggle = false
local AutoSkillToggle = false
local AutoDungeonToggle = false
local AutoFeedPetToggle = false

-- Auto Farm
function isMob(model)
	if not model:IsA("Model") then return false end
	local hum = model:FindFirstChildOfClass("Humanoid")
	local root = model:FindFirstChild("HumanoidRootPart")
	if not hum or not root or hum.Health <= 0 then return false end
	for _, p in pairs(Players:GetPlayers()) do
		if p.Character == model then return false end
	end
	return true
end

function getClosestMob()
	local closest, dist = nil, math.huge
	for _, m in pairs(workspace:GetChildren()) do
		if isMob(m) then
			local root = m:FindFirstChild("HumanoidRootPart")
			if root then
				local d = (HRP.Position - root.Position).Magnitude
				if d < dist then
					dist = d
					closest = root
				end
			end
		end
	end
	return closest
end

task.spawn(function()
	while task.wait(0.35) do
		if AutoFarmToggle then
			local mob = getClosestMob()
			if mob then
				local goal = mob.Position + Vector3.new(0, 0, 3)
				local tween = TweenService:Create(HRP, TweenInfo.new(0.25), {CFrame = CFrame.new(goal)})
				tween:Play()
				task.wait(0.3)
				VirtualInput:SendMouseButtonEvent(0, 0, 0, true, game, 0)
				VirtualInput:SendMouseButtonEvent(0, 0, 0, false, game, 0)
			end
		end
	end
end)

-- Auto Loot
task.spawn(function()
	while task.wait(0.2) do
		if AutoLootToggle then
			VirtualInput:SendKeyEvent(true, "E", false, game)
			task.wait(0.1)
			VirtualInput:SendKeyEvent(false, "E", false, game)
		end
	end
end)

-- Auto Skill (Q E R)
task.spawn(function()
	while task.wait(1) do
		if AutoSkillToggle then
			for _, key in pairs({"Q", "E", "R"}) do
				VirtualInput:SendKeyEvent(true, key, false, game)
				task.wait(0.1)
				VirtualInput:SendKeyEvent(false, key, false, game)
			end
		end
	end
end)

-- Auto Pet Feed
task.spawn(function()
	while task.wait(3) do
		if AutoFeedPetToggle then
			VirtualInput:SendKeyEvent(true, "T", false, game)
			task.wait(0.1)
			VirtualInput:SendKeyEvent(false, "T", false, game)
		end
	end
end)

-- Auto Dungeon (simple loop press F to join)
task.spawn(function()
	while task.wait(1) do
		if AutoDungeonToggle then
			VirtualInput:SendKeyEvent(true, "F", false, game)
			task.wait(0.1)
			VirtualInput:SendKeyEvent(false, "F", false, game)
		end
	end
end)

-- UI Tabs
local tab = Window:MakeTab({Name = "Auto Farm", Icon = "rbxassetid://4483345998", PremiumOnly = false})

tab:AddToggle({
	Name = "🤖 Auto Farm Quái",
	Default = false,
	Callback = function(v) AutoFarmToggle = v end
})

tab:AddToggle({
	Name = "💰 Auto Loot (E)",
	Default = false,
	Callback = function(v) AutoLootToggle = v end
})

tab:AddToggle({
	Name = "⚔️ Auto Skill Q E R",
	Default = false,
	Callback = function(v) AutoSkillToggle = v end
})

tab:AddToggle({
	Name = "🐾 Auto Feed Pet (T)",
	Default = false,
	Callback = function(v) AutoFeedPetToggle = v end
})

tab:AddToggle({
	Name = "🏰 Auto Join Dungeon (F)",
	Default = false,
	Callback = function(v) AutoDungeonToggle = v end
})

OrionLib:Init()
