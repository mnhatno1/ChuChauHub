--==================================================
-- CHÚ CHÁU HUB | V22
-- Stable Quest Farm | Logo Toggle UI
--==================================================

repeat task.wait() until game:IsLoaded()

--// SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

--// PLAYER
local Player = Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local HRP = Char:WaitForChild("HumanoidRootPart")
local Humanoid = Char:WaitForChild("Humanoid")

--==================================================
-- GLOBAL
--==================================================
getgenv().AutoQuest = false
getgenv().AutoFarm  = false
getgenv().AutoM1    = false
getgenv().AutoHaki  = false

getgenv().FarmHeight = 1.2
getgenv().TweenSpeed = 280

--==================================================
-- QUEST DATA (SEA 1 - MỞ RỘNG ĐƯỢC)
--==================================================
local QuestTable = {
	{Min=1,Max=9,Quest="BanditQuest1",Mob="Bandit",Pos=CFrame.new(1060,16,1547)},
	{Min=10,Max=29,Quest="MonkeyQuest",Mob="Monkey",Pos=CFrame.new(-1600,36,153)},
}

local function GetQuest()
	local lv = Player.Data.Level.Value
	for _,q in pairs(QuestTable) do
		if lv >= q.Min and lv <= q.Max then
			return q
		end
	end
end

--==================================================
-- EQUIP
--==================================================
local function Equip()
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
-- AUTO M1 (REAL)
--==================================================
task.spawn(function()
	while task.wait(0.06) do
		if getgenv().AutoM1 then
			Equip()
			VirtualUser:Button1Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
			task.wait()
			VirtualUser:Button1Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
		end
	end
end)

--==================================================
-- GET MOB
--==================================================
local function GetMob(name)
	for _,m in pairs(workspace.Enemies:GetChildren()) do
		if m.Name:find(name)
		and m:FindFirstChild("Humanoid")
		and m.Humanoid.Health > 0
		and m:FindFirstChild("HumanoidRootPart") then
			return m
		end
	end
end

--==================================================
-- TWEEN
--==================================================
local function Tween(cf)
	local d = (HRP.Position - cf.Position).Magnitude
	local t = d / getgenv().TweenSpeed
	TweenService:Create(HRP,TweenInfo.new(t,Enum.EasingStyle.Linear),{CFrame=cf}):Play()
	task.wait(t)
end

--==================================================
-- AUTO QUEST
--==================================================
task.spawn(function()
	while task.wait(2) do
		if getgenv().AutoQuest then
			local q = GetQuest()
			if q and not Player.PlayerGui.Main.Quest.Visible then
				Tween(q.Pos)
				task.wait(0.5)
				ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest",q.Quest,1)
			end
		end
	end
end)

--==================================================
-- AUTO FARM
--==================================================
task.spawn(function()
	while task.wait(0.15) do
		if getgenv().AutoFarm then
			local q = GetQuest()
			if not q then return end
			local mob = GetMob(q.Mob)
			if mob then
				local hrp = mob.HumanoidRootPart
				Tween(hrp.CFrame * CFrame.new(0,getgenv().FarmHeight,-1.5))
				HRP.CFrame = CFrame.new(HRP.Position,hrp.Position)
				hrp.Velocity = Vector3.zero
			end
		end
	end
end)

--==================================================
-- UI (LOGO)
--==================================================
local Gui = Instance.new("ScreenGui",game.CoreGui)
Gui.Name = "ChuChauHubV22"

local Logo = Instance.new("ImageButton",Gui)
Logo.Size = UDim2.new(0,60,0,60)
Logo.Position = UDim2.new(0,20,0.4,0)
Logo.Image = "https://raw.githubusercontent.com/mnhatno1/ChuChauHub/main/file_000000005738720986a39eb73b58c513.png"
Logo.BackgroundTransparency = 1

local Main = Instance.new("Frame",Gui)
Main.Size = UDim2.new(0,320,0,260)
Main.Position = UDim2.new(0.35,0,0.25,0)
Main.Visible = false
Main.Active = true
Main.Draggable = true
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)

Logo.MouseButton1Click:Connect(function()
	Main.Visible = not Main.Visible
end)

local function Button(text,y,cb)
	local b = Instance.new("TextButton",Main)
	b.Size = UDim2.new(0.9,0,0,36)
	b.Position = UDim2.new(0.05,0,0,y)
	b.Text = text
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.Font = Enum.Font.Gotham
	b.TextSize = 15
	b.MouseButton1Click:Connect(function()
		cb(b)
	end)
end

Button("AUTO QUEST : OFF",50,function(b)
	getgenv().AutoQuest = not getgenv().AutoQuest
	b.Text = "AUTO QUEST : "..(getgenv().AutoQuest and "ON" or "OFF")
end)

Button("AUTO FARM : OFF",90,function(b)
	getgenv().AutoFarm = not getgenv().AutoFarm
	b.Text = "AUTO FARM : "..(getgenv().AutoFarm and "ON" or "OFF")
end)

Button("AUTO MELEE : OFF",130,function(b)
	getgenv().AutoM1 = not getgenv().AutoM1
	b.Text = "AUTO MELEE : "..(getgenv().AutoM1 and "ON" or "OFF")
end)

Button("AUTO HAKI : OFF",170,function(b)
	getgenv().AutoHaki = not getgenv().AutoHaki
	b.Text = "AUTO HAKI : "..(getgenv().AutoHaki and "ON" or "OFF")
end)

print("🔥 CHÚ CHÁU HUB V22 LOADED")