--==================================================
--        CHÚ CHÁU HUB V13 - FINAL STABLE
--==================================================

-- SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- PLAYER
local Player = Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Char:WaitForChild("Humanoid")
local HRP = Char:WaitForChild("HumanoidRootPart")

--==================================================
-- SETTINGS
--==================================================
getgenv().AutoFarm = false
getgenv().FarmHeight = 4
getgenv().AttackDelay = 0.08
getgenv().TweenSpeed = 250

--==================================================
-- GUI
--==================================================
local Gui = Instance.new("ScreenGui", game.CoreGui)
Gui.Name = "ChuChauHub"

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0,260,0,180)
Main.Position = UDim2.new(0.5,-130,0.5,-90)
Main.BackgroundColor3 = Color3.fromRGB(25,25,25)
Main.Visible = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "🔥 CHÚ CHÁU HUB V13"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

-- BUTTON
local FarmBtn = Instance.new("TextButton", Main)
FarmBtn.Size = UDim2.new(1,-20,0,45)
FarmBtn.Position = UDim2.new(0,10,0,60)
FarmBtn.Text = "AUTO FARM : OFF"
FarmBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
FarmBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", FarmBtn).CornerRadius = UDim.new(0,8)

--==================================================
-- LOGO PNG (CLICK ẨN MENU)
--==================================================
local Logo = Instance.new("ImageButton", Gui)
Logo.Size = UDim2.new(0,60,0,60)
Logo.Position = UDim2.new(0,10,0.5,-30)
Logo.BackgroundTransparency = 1
Logo.Image = "https://raw.githubusercontent.com/mnhatno1/ChuChauHub/refs/heads/main/file_000000005738720986a39eb73b58c513.png"
Instance.new("UICorner", Logo).CornerRadius = UDim.new(1,0)

Logo.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

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
-- GET MOB
--==================================================
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

--==================================================
-- TWEEN
--==================================================
local function TweenTo(cf)
    local dist = (HRP.Position - cf.Position).Magnitude
    local time = dist / getgenv().TweenSpeed
    TweenService:Create(
        HRP,
        TweenInfo.new(time, Enum.EasingStyle.Linear),
        {CFrame = cf}
    ):Play()
end

--==================================================
-- ATTACK LOOP (DAME THẬT)
--==================================================
task.spawn(function()
    while task.wait(getgenv().AttackDelay) do
        if getgenv().AutoFarm then
            pcall(function()
                EquipWeapon()
                mouse1click()
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
                    local mhrp = mob.HumanoidRootPart
                    TweenTo(mhrp.CFrame * CFrame.new(0, getgenv().FarmHeight, 0))
                    HRP.CFrame = CFrame.new(HRP.Position, mhrp.Position)
                end
            end)
        end
    end
end)

--==================================================
-- AUTO QUEST (MẪU – CHỈNH THEO GAME)
--==================================================
task.spawn(function()
    while task.wait(3) do
        if getgenv().AutoFarm then
            -- ví dụ:
            -- fireclickdetector(workspace.Quest.NPC.ClickDetector)
        end
    end
end)

--==================================================
-- BUTTON EVENT
--==================================================
FarmBtn.MouseButton1Click:Connect(function()
    getgenv().AutoFarm = not getgenv().AutoFarm
    FarmBtn.Text = getgenv().AutoFarm and "AUTO FARM : ON" or "AUTO FARM : OFF"
end)

print("✅ CHÚ CHÁU HUB V13 LOADED")