--==================================================
-- 🔥 CHÚ CHÁU HUB V13 | BLOX FRUITS
-- 👑 Admin: M.nhat
-- 📱 Android + Fluxus OK
--==================================================

repeat task.wait() until game:IsLoaded()

--// SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")

--// PLAYER
local Player = Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Char:WaitForChild("Humanoid")
local HRP = Char:WaitForChild("HumanoidRootPart")

--==================================================
-- SETTINGS
--==================================================
getgenv().AutoFarm = false
getgenv().AutoQuest = false
getgenv().FarmHeight = 6
getgenv().AttackDelay = 0.08
getgenv().TweenSpeed = 250

--==================================================
-- UI
--==================================================
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "ChuChauHubV13"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.fromScale(0.35,0.35)
Main.Position = UDim2.fromScale(0.33,0.3)
Main.BackgroundColor3 = Color3.fromRGB(25,25,25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,16)

-- TITLE
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.fromScale(1,0.18)
Title.BackgroundTransparency = 1
Title.Text = "🔥 CHÚ CHÁU HUB V13"
Title.TextColor3 = Color3.fromRGB(255,170,0)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true

-- LOGO
local Logo = Instance.new("ImageLabel", Main)
Logo.Size = UDim2.fromScale(0.28,0.45)
Logo.Position = UDim2.fromScale(0.36,0.18)
Logo.BackgroundTransparency = 1
Logo.Image = "https://raw.githubusercontent.com/mnhatno1/ChuChauHub/main/file_000000005738720986a39eb73b58c513.png"

-- BUTTON
local function MakeButton(text,y)
	local b = Instance.new("TextButton", Main)
	b.Size = UDim2.fromScale(0.8,0.15)
	b.Position = UDim2.fromScale(0.1,y)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)
	return b
end

local FarmBtn = MakeButton("AUTO FARM : OFF",0.65)
local QuestBtn = MakeButton("AUTO QUEST : OFF",0.82)

--==================================================
-- FUNCTIONS
--==================================================
local function EquipWeapon()
	if Char:FindFirstChildOfClass("Tool") then return end
	for _,v in pairs(Player.Backpack:GetChildren()) do
		if v:IsA("Tool") then
			Humanoid:EquipTool(v)
			break
		end
	end
end

local function GetMob()
	local nearest, dist = nil, math.huge
	for _,mob in pairs(workspace.Enemies:GetChildren()) do
		if mob:FindFirstChild("Humanoid")
		and mob.Humanoid.Health > 0
		and mob:FindFirstChild("HumanoidRootPart") then
			local d = (HRP.Position - mob.HumanoidRootPart.Position).Magnitude
			if d < dist then
				dist = d
				nearest = mob
			end
		end
	end
	return nearest
end

local function TweenTo(cf)
	local dist = (HRP.Position - cf.Position).Magnitude
	local time = dist / getgenv().TweenSpeed
	local tween = TweenService:Create(
		HRP,
		TweenInfo.new(time, Enum.EasingStyle.Linear),
		{CFrame = cf}
	)
	tween:Play()
	tween.Completed:Wait()
end

--==================================================
-- ATTACK (REAL M1)
--==================================================
task.spawn(function()
	while task.wait(getgenv().AttackDelay) do
		if getgenv().AutoFarm then
			pcall(function()
				EquipWeapon()
				VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,0)
				VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,0)
			end)
		end
	end
end)

--==================================================
-- FARM LOOP
--==================================================
task.spawn(function()
	while task.wait(0.15) do
		if getgenv().AutoFarm then
			pcall(function()
				local mob = GetMob()
				if mob then
					local hrp = mob.HumanoidRootPart
					local pos = hrp.CFrame * CFrame.new(0,getgenv().FarmHeight,0)
					TweenTo(pos)
					HRP.CFrame = CFrame.new(HRP.Position, hrp.Position)
				end
			end)
		end
	end
end)

--==================================================
-- BUTTON EVENTS
--==================================================
FarmBtn.MouseButton1Click:Connect(function()
	getgenv().AutoFarm = not getgenv().AutoFarm
	FarmBtn.Text = "AUTO FARM : "..(getgenv().AutoFarm and "ON" or "OFF")
end)

QuestBtn.MouseButton1Click:Connect(function()
	getgenv().AutoQuest = not getgenv().AutoQuest
	QuestBtn.Text = "AUTO QUEST : "..(getgenv().AutoQuest and "ON" or "OFF")
end)

print("✅ CHÚ CHÁU HUB V13 LOADED")