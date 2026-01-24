--==================================================
-- 🔥 CHÚ CHÁU HUB v7.2 | FLUXUS FIX
-- 👑 Admin: M.nhat
-- UI: Kavo (ỔN ĐỊNH FLUXUS)
--==================================================

repeat task.wait() until game:IsLoaded()
task.wait(2)

pcall(function()
    game.StarterGui:SetCore("SendNotification",{
        Title="ChuChauHub",
        Text="Loading menu...",
        Duration=5
    })
end)

-- LOAD KAVO UI
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"
))()

if not Library then
    warn("Không load được UI")
    return
end

local Window = Library.CreateLib(
    "🔥 Chú Cháu Hub | Fluxus",
    "Ocean"
)

-- FLAGS
getgenv().AutoFarm = false
getgenv().AutoHaki = false

-- SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- UTIL
local function Char()
    return player.Character or player.CharacterAdded:Wait()
end

local function HRP()
    return Char():WaitForChild("HumanoidRootPart")
end

local function Equip()
    for _,v in pairs(player.Backpack:GetChildren()) do
        if v:IsA("Tool") then
            Char().Humanoid:EquipTool(v)
            return
        end
    end
end

local function Attack()
    VirtualUser:Button1Down(Vector2.new(0,0))
    task.wait()
    VirtualUser:Button1Up(Vector2.new(0,0))
end

-- AUTO HAKI
task.spawn(function()
    while task.wait(1) do
        if getgenv().AutoHaki then
            pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
            end)
        end
    end
end)

-- AUTO FARM
task.spawn(function()
    while task.wait() do
        if getgenv().AutoFarm then
            for _,mob in pairs(workspace.Enemies:GetChildren()) do
                if mob:FindFirstChild("Humanoid")
                and mob.Humanoid.Health > 0 then
                    repeat
                        task.wait()
                        Equip()
                        TweenService:Create(
                            HRP(),
                            TweenInfo.new(0.2),
                            {CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0,10,0)}
                        ):Play()
                        Attack()
                    until mob.Humanoid.Health <= 0 or not getgenv().AutoFarm
                end
            end
        end
    end
end)

-- UI TABS
local FarmTab = Window:NewTab("Farm")
local FarmSection = FarmTab:NewSection("Auto Farm")

FarmSection:NewToggle("Auto Farm Mob","",function(v)
    getgenv().AutoFarm = v
end)

FarmSection:NewToggle("Auto Haki","",function(v)
    getgenv().AutoHaki = v
end)

local InfoTab = Window:NewTab("Info")
local InfoSection = InfoTab:NewSection("Thông Tin")

InfoSection:NewLabel("Chú Cháu Hub v7.2")
InfoSection:NewLabel("Admin: M.nhat")
InfoSection:NewLabel("Fluxus Stable | No Key")