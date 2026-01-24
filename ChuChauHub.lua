--==================================================
-- 🔥 CHÚ CHÁU HUB V15 | REDZ PRO MAX
-- 👑 Admin: M.nhat
-- Android + Fluxus OK | REAL DAMAGE
--==================================================

repeat task.wait() until game:IsLoaded()

-- SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- PLAYER
local Player = Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Char:WaitForChild("Humanoid")
local HRP = Char:WaitForChild("HumanoidRootPart")

Player.CharacterAdded:Connect(function(c)
	Char=c
	Humanoid=c:WaitForChild("Humanoid")
	HRP=c:WaitForChild("HumanoidRootPart")
end)

-- GLOBAL
getgenv().AutoFarm=false
getgenv().AutoQuest=false
getgenv().FarmHeight=6
getgenv().AttackDelay=0.08
getgenv().TweenSpeed=260
getgenv().ESPMob=false

--==================================================
-- LEVEL → MOB TABLE (SEA 1 BASIC)
--==================================================
local LevelMobs={
	{min=1,max=9,name="Bandit"},
	{min=10,max=29,name="Monkey"},
	{min=30,max=59,name="Pirate"},
	{min=60,max=89,name="Brute"},
	{min=90,max=119,name="Desert Bandit"},
}

local function GetMobByLevel()
	local lv=Player.Data.Level.Value
	for _,v in pairs(LevelMobs) do
		if lv>=v.min and lv<=v.max then
			return v.name
		end
	end
	return nil
end

--==================================================
-- UI (REDZ STYLE)
--==================================================
local Gui=Instance.new("ScreenGui",game.CoreGui)
Gui.Name="ChuChauHubV15"

local Main=Instance.new("Frame",Gui)
Main.Size=UDim2.fromScale(0.6,0.6)
Main.Position=UDim2.fromScale(0.2,0.2)
Main.BackgroundColor3=Color3.fromRGB(22,22,22)
Main.Active,Main.Draggable=true,true
Instance.new("UICorner",Main).CornerRadius=UDim.new(0,18)

local Left=Instance.new("Frame",Main)
Left.Size=UDim2.fromScale(0.22,1)
Left.BackgroundColor3=Color3.fromRGB(30,30,30)
Instance.new("UICorner",Left).CornerRadius=UDim.new(0,18)

local Logo=Instance.new("ImageLabel",Left)
Logo.Size=UDim2.fromScale(0.7,0.18)
Logo.Position=UDim2.fromScale(0.15,0.04)
Logo.BackgroundTransparency=1
Logo.Image="https://raw.githubusercontent.com/mnhatno1/ChuChauHub/main/file_000000005738720986a39eb73b58c513.png"

local Title=Instance.new("TextLabel",Left)
Title.Size=UDim2.fromScale(1,0.08)
Title.Position=UDim2.fromScale(0,0.23)
Title.BackgroundTransparency=1
Title.Text="CHÚ CHÁU HUB"
Title.TextScaled=true
Title.Font=Enum.Font.GothamBold
Title.TextColor3=Color3.fromRGB(255,170,0)

local Content=Instance.new("Frame",Main)
Content.Position=UDim2.fromScale(0.24,0.05)
Content.Size=UDim2.fromScale(0.74,0.9)
Content.BackgroundTransparency=1

local Pages={}
local function Page(name)
	local f=Instance.new("Frame",Content)
	f.Size=UDim2.fromScale(1,1)
	f.BackgroundTransparency=1
	f.Visible=false
	Pages[name]=f
	return f
end

local Farm=Page("Farm")
local ESP=Page("ESP")
local Set=Page("Set")
Farm.Visible=true

local function Tab(txt,y,page)
	local b=Instance.new("TextButton",Left)
	b.Size=UDim2.fromScale(0.8,0.08)
	b.Position=UDim2.fromScale(0.1,y)
	b.Text=txt
	b.TextScaled=true
	b.Font=Enum.Font.GothamBold
	b.BackgroundColor3=Color3.fromRGB(45,45,45)
	Instance.new("UICorner",b).CornerRadius=UDim.new(0,12)
	b.MouseButton1Click:Connect(function()
		for _,p in pairs(Pages) do p.Visible=false end
		page.Visible=true
	end)
end

Tab("FARM",0.36,Farm)
Tab("ESP",0.46,ESP)
Tab("SET",0.56,Set)

local function Toggle(p,txt,y,cb)
	local b=Instance.new("TextButton",p)
	b.Size=UDim2.fromScale(0.6,0.12)
	b.Position=UDim2.fromScale(0.2,y)
	b.Text=txt..": OFF"
	b.TextScaled=true
	b.Font=Enum.Font.GothamBold
	b.BackgroundColor3=Color3.fromRGB(40,40,40)
	Instance.new("UICorner",b).CornerRadius=UDim.new(0,12)
	local on=false
	b.MouseButton1Click:Connect(function()
		on=not on
		b.Text=txt..": "..(on and "ON" or "OFF")
		cb(on)
	end)
end

Toggle(Farm,"AUTO FARM",0.18,function(v) getgenv().AutoFarm=v end)
Toggle(Farm,"AUTO QUEST",0.34,function(v) getgenv().AutoQuest=v end)
Toggle(ESP,"ESP MOB",0.18,function(v) getgenv().ESPMob=v end)

--==================================================
-- CORE FARM
--==================================================
local function EquipWeapon()
	if Char:FindFirstChildOfClass("Tool") then return end
	for _,t in pairs(Player.Backpack:GetChildren()) do
		if t:IsA("Tool") then Humanoid:EquipTool(t) break end
	end
end

local function GetTargetMob()
	local targetName=GetMobByLevel()
	if not targetName then return nil end
	for _,m in pairs(workspace.Enemies:GetChildren()) do
		if m.Name:find(targetName)
		and m:FindFirstChild("Humanoid")
		and m.Humanoid.Health>0
		and m:FindFirstChild("HumanoidRootPart") then
			return m
		end
	end
end

local function TweenTo(cf)
	local d=(HRP.Position-cf.Position).Magnitude
	local t=d/getgenv().TweenSpeed
	local tw=TweenService:Create(HRP,TweenInfo.new(t,Enum.EasingStyle.Linear),{CFrame=cf})
	tw:Play(); tw.Completed:Wait()
end

task.spawn(function()
	while task.wait(getgenv().AttackDelay) do
		if getgenv().AutoFarm then
			EquipWeapon()
			VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,0)
			VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,0)
		end
	end
end)

task.spawn(function()
	while task.wait(0.15) do
		if getgenv().AutoFarm then
			local mob=GetTargetMob()
			if mob then
				local hrp=mob.HumanoidRootPart
				TweenTo(hrp.CFrame*CFrame.new(0,getgenv().FarmHeight,0))
				HRP.CFrame=CFrame.new(HRP.Position,hrp.Position)
			end
		end
	end
end)

print("✅ CHÚ CHÁU HUB V15 LOADED – REAL FARM")