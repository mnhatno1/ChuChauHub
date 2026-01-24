--==================================================
-- CHÚ CHÁU HUB | V20 (REDZ REAL FARM)
--==================================================

--// SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// PLAYER
local Player = Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Char:WaitForChild("Humanoid")
local HRP = Char:WaitForChild("HumanoidRootPart")

--==================================================
-- SETTINGS
--==================================================
getgenv().AutoFarm  = false
getgenv().AutoQuest = false
getgenv().AutoHaki  = false
getgenv().AutoM1    = false

getgenv().FarmHeight = 1.5
getgenv().TweenSpeed = 280

--==================================================
-- EQUIP WEAPON
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

--==================================================
-- AUTO HAKI
--==================================================
task.spawn(function()
	while task.wait(1) do
		if getgenv().AutoHaki then
			pcall(function()
				if not Char:FindFirstChild("HasBuso") then
					ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
				end
			end)
		end
	end
end)

--==================================================
-- AUTO M1 (REAL CLICK)
--==================================================
task.spawn(function()
	while task.wait(0.06) do
		if getgenv().AutoM1 then
			pcall(function()
				EquipWeapon()
				VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
				task.wait()
				VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
			end)
		end
	end
end)

--==================================================
-- GET NEAREST MOB
--==================================================
local function GetMob()
	local near, dist = nil, math.huge
	for _,mob in pairs(workspace.Enemies:GetChildren()) do
		if mob:FindFirstChild("Humanoid")
		and mob.Humanoid.Health > 0
		and mob:FindFirstChild("HumanoidRootPart") then
			local d = (HRP.Position - mob.HumanoidRootPart.Position).Magnitude
			if d < dist then
				dist = d
				near = mob
			end
		end
	end
	return near
end

--==================================================
-- TWEEN
--==================================================
local function TweenTo(cf)
	local d = (HRP.Position - cf.Position).Magnitude
	local t = d / getgenv().TweenSpeed
	TweenService:Create(
		HRP,
		TweenInfo.new(t, Enum.EasingStyle.Linear),
		{CFrame = cf}
	):Play()
	task.wait(t)
end

--==================================================
-- AUTO FARM (REDZ STYLE)
--==================================================
task.spawn(function()
	while task.wait(0.15) do
		if getgenv().AutoFarm then
			pcall(function()
				local mob = GetMob()
				if mob then
					local mhrp = mob.HumanoidRootPart

					-- ĐỨNG SÁT HÔNG QUÁI
					local pos = mhrp.CFrame * CFrame.new(0, getgenv().FarmHeight, -2)
					TweenTo(pos)

					-- QUAY MẶT
					HRP.CFrame = CFrame.new(HRP.Position, mhrp.Position)

					-- GIỮ QUÁI KHÔNG BAY
					mhrp.Velocity = Vector3.zero
				end
			end)
		end
	end
end)

--==================================================
-- AUTO QUEST (CƠ BẢN)
--==================================================
task.spawn(function()
	while task.wait(2) do
		if getgenv().AutoQuest then
			pcall(function()
				ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest")
			end)
		end
	end
end)

--==================================================
-- UI
--==================================================
local Gui = Instance.new("ScreenGui", game.CoreGui)
Gui.Name = "ChuChauHubV20"

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0,340,0,300)
Main.Position = UDim2.new(0.35,0,0.25,0)
Main.BackgroundColor3 = Color3.fromRGB(22,22,22)
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "CHÚ CHÁU HUB | V20"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.BackgroundTransparency = 1

local function Btn(txt,y,cb)
	local b = Instance.new("TextButton", Main)
	b.Size = UDim2.new(0.9,0,0,36)
	b.Position = UDim2.new(0.05,0,0,y)
	b.Text = txt
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.Font = Enum.Font.Gotham
	b.TextSize = 15
	b.MouseButton1Click:Connect(function()
		cb(b)
	end)
end

Btn("AUTO FARM : OFF",50,function(b)
	getgenv().AutoFarm = not getgenv().AutoFarm
	b.Text = "AUTO FARM : "..(getgenv().AutoFarm and "ON" or "OFF")
end)

Btn("AUTO QUEST : OFF",90,function(b)
	getgenv().AutoQuest = not getgenv().AutoQuest
	b.Text = "AUTO QUEST : "..(getgenv().AutoQuest and "ON" or "OFF")
end)

Btn("AUTO HAKI : OFF",130,function(b)
	getgenv().AutoHaki = not getgenv().AutoHaki
	b.Text = "AUTO HAKI : "..(getgenv().AutoHaki and "ON" or "OFF")
end)

Btn("AUTO MELEE : OFF",170,function(b)
	getgenv().AutoM1 = not getgenv().AutoM1
	b.Text = "AUTO MELEE : "..(getgenv().AutoM1 and "ON" or "OFF")
end)

Btn("ẨN / HIỆN MENU",220,function()
	Main.Visible = not Main.Visible
end)

print("🔥 CHÚ CHÁU HUB V20 LOADED | REAL DAMAGE")