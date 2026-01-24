-- =================================================
-- 🔥 CHÚ CHÁU HUB V7.2 | BLOX FRUITS
-- 👑 Admin: M.nhat
-- 📱 Fluxus Android | UI Custom | No Orion
-- =================================================

repeat task.wait() until game:IsLoaded()

-- ============ SERVICES ============
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local UIS = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local lp = Players.LocalPlayer

-- ============ ANTI AFK ============
pcall(function()
    lp.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)

-- ============ GLOBAL ============
getgenv().AutoFarm = false
getgenv().FarmHeight = 35      -- bay cao né đòn
getgenv().HitboxSize = 80      -- tầm đánh xa (40-80 an toàn)

-- ============ UTIL ============
local function EquipWeapon()
    local char = lp.Character
    if not char then return end
    for _,tool in pairs(lp.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            char.Humanoid:EquipTool(tool)
            return
        end
    end
end

local function TweenTo(cf)
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    TweenService:Create(hrp, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {CFrame = cf}):Play()
end

local function GetNearestMob()
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local hrp = char.HumanoidRootPart
    local nearest, dist = nil, math.huge
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return nil end
    for _,mob in pairs(enemies:GetChildren()) do
        if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart")
        and mob.Humanoid.Health > 0 then
            local d = (mob.HumanoidRootPart.Position - hrp.Position).Magnitude
            if d < dist then
                dist = d
                nearest = mob
            end
        end
    end
    return nearest
end

local function HitboxMob(mob)
    if not mob or not mob:FindFirstChild("HumanoidRootPart") then return end
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    mob.HumanoidRootPart.Size = Vector3.new(getgenv().HitboxSize, getgenv().HitboxSize, getgenv().HitboxSize)
    mob.HumanoidRootPart.Transparency = 1
    mob.HumanoidRootPart.CanCollide = false
    -- kéo quái vào vùng đánh (trước mặt)
    mob.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, 0, -6)
end

local function StayAbove(mob)
    if not mob or not mob:FindFirstChild("HumanoidRootPart") then return end
    TweenTo(mob.HumanoidRootPart.CFrame * CFrame.new(0, getgenv().FarmHeight, 0))
end

local function AttackM1()
    VirtualUser:Button1Down(Vector2.new(0,0))
    task.wait(0.05)
    VirtualUser:Button1Up(Vector2.new(0,0))
end

-- ============ AUTO FARM LOOP ============
task.spawn(function()
    while task.wait(0.12) do
        if getgenv().AutoFarm then
            pcall(function()
                local mob = GetNearestMob()
                if mob and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                    EquipWeapon()
                    StayAbove(mob)
                    HitboxMob(mob)
                    AttackM1()
                end
            end)
        end
    end
end)

-- ============ UI CUSTOM ============
if game.CoreGui:FindFirstChild("ChuChauHub") then
    game.CoreGui.ChuChauHub:Destroy()
end

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ChuChauHub"
gui.ResetOnSpawn = false

-- LOGO (bấm hiện/ẩn)
local logo = Instance.new("ImageButton", gui)
logo.Size = UDim2.fromOffset(60,60)
logo.Position = UDim2.fromOffset(20,200)
logo.BackgroundColor3 = Color3.fromRGB(25,25,25)
logo.Image = "https://raw.githubusercontent.com/mnhatno1/ChuChauHub/main/file_000000005738720986a39eb73b58c513.png"
Instance.new("UICorner", logo).CornerRadius = UDim.new(0,15)

-- MAIN PANEL
local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(380,260)
main.Position = UDim2.fromScale(0.5,0.5)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.BorderSizePixel = 0
main.Visible = false
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,20)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,48)
title.BackgroundTransparency = 1
title.Text = "🔥 CHÚ CHÁU HUB V7.2"
title.TextColor3 = Color3.fromRGB(255,170,0)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

-- BUTTON AUTO FARM
local btnFarm = Instance.new("TextButton", main)
btnFarm.Size = UDim2.fromOffset(160,46)
btnFarm.Position = UDim2.fromOffset(20,80)
btnFarm.Text = "AUTO FARM: OFF"
btnFarm.BackgroundColor3 = Color3.fromRGB(60,60,60)
btnFarm.TextColor3 = Color3.new(1,1,1)
btnFarm.Font = Enum.Font.GothamBold
Instance.new("UICorner", btnFarm).CornerRadius = UDim.new(0,14)

-- SLIDER HITBOX (đơn giản bằng nút)
local btnRange = Instance.new("TextButton", main)
btnRange.Size = UDim2.fromOffset(160,46)
btnRange.Position = UDim2.fromOffset(200,80)
btnRange.Text = "TẦM ĐÁNH: 80"
btnRange.BackgroundColor3 = Color3.fromRGB(60,60,60)
btnRange.TextColor3 = Color3.new(1,1,1)
btnRange.Font = Enum.Font.GothamBold
Instance.new("UICorner", btnRange).CornerRadius = UDim.new(0,14)

logo.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

btnFarm.MouseButton1Click:Connect(function()
    getgenv().AutoFarm = not getgenv().AutoFarm
    btnFarm.Text = getgenv().AutoFarm and "AUTO FARM: ON" or "AUTO FARM: OFF"
end)

btnRange.MouseButton1Click:Connect(function()
    -- đổi nhanh 40 -> 60 -> 80
    if getgenv().HitboxSize == 40 then
        getgenv().HitboxSize = 60
    elseif getgenv().HitboxSize == 60 then
        getgenv().HitboxSize = 80
    else
        getgenv().HitboxSize = 40
    end
    btnRange.Text = "TẦM ĐÁNH: "..getgenv().HitboxSize
end)

StarterGui:SetCore("SendNotification",{
    Title="Chú Cháu Hub",
    Text="V7.2 Loaded - Bấm logo để mở menu",
    Duration=5
})