--==================================================
-- 🔥 CHÚ CHÁU HUB | REDZ STYLE FARM
-- 👑 Admin: M.nhat
-- Auto Farm M1 - Fix Dame 100%
--==================================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

local lp = Players.LocalPlayer

-- ================= CONFIG =================
getgenv().AutoFarm = false
getgenv().Magnet = true
getgenv().FarmDistance = 7      -- KHOẢNG CÁCH GÂY DAME CHUẨN
getgenv().HitboxSize = 25       -- ĐỪNG ĐỂ >30

-- ================= ANTI AFK =================
lp.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- ================= FUNCTION =================
local function Character()
    return lp.Character or lp.CharacterAdded:Wait()
end

local function HRP()
    return Character():WaitForChild("HumanoidRootPart")
end

local function EquipWeapon()
    for _,v in pairs(lp.Backpack:GetChildren()) do
        if v:IsA("Tool") then
            Character().Humanoid:EquipTool(v)
            return
        end
    end
end

local function GetMob()
    for _,mob in pairs(workspace.Enemies:GetChildren()) do
        if mob:FindFirstChild("Humanoid")
        and mob:FindFirstChild("HumanoidRootPart")
        and mob.Humanoid.Health > 0 then
            return mob
        end
    end
end

local function MagnetMob(mob)
    mob.HumanoidRootPart.Size = Vector3.new(
        getgenv().HitboxSize,
        getgenv().HitboxSize,
        getgenv().HitboxSize
    )
    mob.HumanoidRootPart.Transparency = 1
    mob.HumanoidRootPart.CanCollide = false
    mob.HumanoidRootPart.CFrame = HRP().CFrame * CFrame.new(0,0,-getgenv().FarmDistance)
end

local function Attack()
    VirtualUser:Button1Down(Vector2.new(0,0))
    task.wait(0.05)
    VirtualUser:Button1Up(Vector2.new(0,0))
end

-- ================= FARM LOOP =================
task.spawn(function()
    while task.wait(0.12) do
        if getgenv().AutoFarm then
            pcall(function()
                EquipWeapon()
                local mob = GetMob()
                if mob then
                    if getgenv().Magnet then
                        MagnetMob(mob)
                    else
                        TweenService:Create(
                            HRP(),
                            TweenInfo.new(0.2),
                            {CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0,0,-getgenv().FarmDistance)}
                        ):Play()
                    end
                    Attack()
                end
            end)
        end
    end
end)

-- ================= UI MINI (REDZ KIỂU GỌN) =================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ChuChauRedz"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(220,140)
frame.Position = UDim2.fromOffset(30,200)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromOffset(220,35)
title.Text = "🔥 Chú Cháu Hub | Farm"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14

local toggle = Instance.new("TextButton", frame)
toggle.Position = UDim2.fromOffset(20,60)
toggle.Size = UDim2.fromOffset(180,45)
toggle.Text = "AUTO FARM: OFF"
toggle.BackgroundColor3 = Color3.fromRGB(45,45,45)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,12)

toggle.MouseButton1Click:Connect(function()
    getgenv().AutoFarm = not getgenv().AutoFarm
    toggle.Text = getgenv().AutoFarm and "AUTO FARM: ON" or "AUTO FARM: OFF"
end)