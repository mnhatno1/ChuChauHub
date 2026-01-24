--==================================================
-- 🔥 CHÚ CHÁU HUB V7.2 (FIXED)
-- 👑 Admin: M.nhat
-- Auto Farm | Fluxus Ready
--==================================================

repeat task.wait() until game:IsLoaded()

-- SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer

-- GLOBAL
getgenv().AutoFarm = false
getgenv().FarmHeight = 30

-- ANTI AFK
player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- UTIL
local function EquipWeapon()
    local char = player.Character
    if not char then return end
    for _,v in pairs(player.Backpack:GetChildren()) do
        if v:IsA("Tool") then
            char.Humanoid:EquipTool(v)
            break
        end
    end
end

local function TP(cf)
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    TweenService:Create(hrp, TweenInfo.new(0.25), {CFrame = cf}):Play()
end

-- AUTO FARM CORE
task.spawn(function()
    while task.wait() do
        if getgenv().AutoFarm then
            for _,mob in pairs(workspace.Enemies:GetChildren()) do
                if mob:FindFirstChild("Humanoid")
                and mob:FindFirstChild("HumanoidRootPart")
                and mob.Humanoid.Health > 0 then

                    repeat
                        task.wait()
                        EquipWeapon()
                        TP(mob.HumanoidRootPart.CFrame * CFrame.new(0, getgenv().FarmHeight, 0))
                        VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                        VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    until mob.Humanoid.Health <= 0 or not getgenv().AutoFarm
                end
            end
        end
    end
end)

-- UI
local OrionLib = loadstring(game:HttpGet(
"https://raw.githubusercontent.com/shlexware/Orion/main/source"
))()

local Window = OrionLib:MakeWindow({
    Name = "🔥 Chú Cháu V7.2",
    SaveConfig = false,
})

local FarmTab = Window:MakeTab({Name="Farm"})
FarmTab:AddToggle({
    Name="Auto Farm",
    Default=false,
    Callback=function(v) getgenv().AutoFarm = v end
})

FarmTab:AddSlider({
    Name="Bay cao (Anti hit)",
    Min=20, Max=50, Default=30,
    Callback=function(v) getgenv().FarmHeight = v end
})

local InfoTab = Window:MakeTab({Name="Info"})
InfoTab:AddParagraph(
    "Chú Cháu Hub",
    "V7.2 FIXED\nAdmin: M.nhat\nFluxus OK"
)

OrionLib:Init()