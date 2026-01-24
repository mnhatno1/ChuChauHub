-- =========================================
-- 🔥 CHÚ CHÁU HUB | AUTO FARM M1 FIX DAME
-- =========================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")

local lp = Players.LocalPlayer

-- ====== CONFIG ======
getgenv().AutoFarm = false
getgenv().Hitbox = 30      -- KHÔNG để quá cao
getgenv().Distance = 8    -- khoảng cách gây dame chuẩn

-- ====== ANTI AFK ======
lp.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-- ====== FUNCTION ======
local function Equip()
    local char = lp.Character
    if not char then return end
    for _,v in pairs(lp.Backpack:GetChildren()) do
        if v:IsA("Tool") then
            char.Humanoid:EquipTool(v)
            return
        end
    end
end

local function GetMob()
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    for _,mob in pairs(workspace.Enemies:GetChildren()) do
        if mob:FindFirstChild("Humanoid")
        and mob.Humanoid.Health > 0
        and mob:FindFirstChild("HumanoidRootPart") then
            return mob
        end
    end
end

local function Hitbox(mob)
    mob.HumanoidRootPart.Size = Vector3.new(getgenv().Hitbox,getgenv().Hitbox,getgenv().Hitbox)
    mob.HumanoidRootPart.Transparency = 1
    mob.HumanoidRootPart.CanCollide = false
end

local function MoveToMob(mob)
    local hrp = lp.Character.HumanoidRootPart
    local pos = mob.HumanoidRootPart.CFrame * CFrame.new(0,0,getgenv().Distance)
    TweenService:Create(hrp,TweenInfo.new(0.15),{CFrame = pos}):Play()
end

local function Attack()
    VirtualUser:Button1Down(Vector2.new(0,0))
    task.wait(0.05)
    VirtualUser:Button1Up(Vector2.new(0,0))
end

-- ====== LOOP ======
task.spawn(function()
    while task.wait(0.12) do
        if getgenv().AutoFarm then
            pcall(function()
                Equip()
                local mob = GetMob()
                if mob then
                    Hitbox(mob)
                    MoveToMob(mob)
                    Attack()
                end
            end)
        end
    end
end)

-- ====== UI NÚT BẬT TẮT ======
local gui = Instance.new("ScreenGui",game.CoreGui)
gui.Name = "ChuChauFix"

local btn = Instance.new("TextButton",gui)
btn.Size = UDim2.fromOffset(160,50)
btn.Position = UDim2.fromOffset(20,200)
btn.Text = "AUTO FARM: OFF"
btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
btn.TextColor3 = Color3.new(1,1,1)

btn.MouseButton1Click:Connect(function()
    getgenv().AutoFarm = not getgenv().AutoFarm
    btn.Text = getgenv().AutoFarm and "AUTO FARM: ON" or "AUTO FARM: OFF"
end)