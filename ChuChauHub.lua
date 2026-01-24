--==================================================
-- 🔥 CHÚ CHÁU HUB v7 | GRAVITY STYLE
-- 👑 Admin: M.nhat
-- No Key | Fluxus / Delta
--==================================================

repeat task.wait() until game:IsLoaded()

-- SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer

-- FLAGS
getgenv().AutoFarm = false
getgenv().AutoQuest = false
getgenv().AutoBoss = false
getgenv().AutoHaki = false
getgenv().ESPMob = false
getgenv().ESPBoss = false
getgenv().ESPChest = false

-- DATA SEA 1
local QuestData = {
    {Min=1, Max=9, Mob="Bandit", Quest="BanditQuest1", NPC="Bandit Quest Giver"},
    {Min=10, Max=29, Mob="Monkey", Quest="JungleQuest", NPC="Adventurer"},
    {Min=30, Max=59, Mob="Pirate", Quest="BuggyQuest1", NPC="Pirate Adventurer"},
    {Min=60, Max=99, Mob="Brute", Quest="DesertQuest", NPC="Desert Adventurer"},
}

local BossList = {
    "Vice Admiral",
    "Warden",
    "Chief Warden",
    "Saber Expert"
}

--================ UTIL =================
local function Char()
    return player.Character or player.CharacterAdded:Wait()
end

local function HRP()
    return Char():WaitForChild("HumanoidRootPart")
end

local function Level()
    return player.Data.Level.Value
end

local function Equip()
    for _,v in pairs(player.Backpack:GetChildren()) do
        if v:IsA("Tool") then
            Char().Humanoid:EquipTool(v)
            return
        end
    end
end

local function TP(cf)
    TweenService:Create(HRP(), TweenInfo.new(0.2), {CFrame = cf}):Play()
end

local function Attack()
    VirtualUser:Button1Down(Vector2.new(0,0))
    task.wait()
    VirtualUser:Button1Up(Vector2.new(0,0))
end

--================ AUTO HAKI =================
task.spawn(function()
    while task.wait(1) do
        if getgenv().AutoHaki then
            pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
            end)
        end
    end
end)

--================ AUTO QUEST =================
local function GetQuest()
    for _,q in pairs(QuestData) do
        if Level() >= q.Min and Level() <= q.Max then
            return q
        end
    end
end

task.spawn(function()
    while task.wait() do
        if getgenv().AutoQuest then
            pcall(function()
                local q = GetQuest()
                if q then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer(
                        "StartQuest", q.Quest, 1
                    )
                end
            end)
        end
    end
end)

--================ AUTO FARM =================
task.spawn(function()
    while task.wait() do
        if getgenv().AutoFarm then
            for _,mob in pairs(workspace.Enemies:GetChildren()) do
                if mob:FindFirstChild("Humanoid")
                and mob.Humanoid.Health > 0 then
                    repeat
                        task.wait()
                        Equip()
                        TP(mob.HumanoidRootPart.CFrame * CFrame.new(0,10,0))
                        Attack()
                    until mob.Humanoid.Health <= 0 or not getgenv().AutoFarm
                end
            end
        end
    end
end)

--================ AUTO BOSS =================
task.spawn(function()
    while task.wait() do
        if getgenv().AutoBoss then
            for _,mob in pairs(workspace.Enemies:GetChildren()) do
                if table.find(BossList, mob.Name)
                and mob:FindFirstChild("Humanoid")
                and mob.Humanoid.Health > 0 then
                    repeat
                        task.wait()
                        Equip()
                        TP(mob.HumanoidRootPart.CFrame * CFrame.new(0,15,0))
                        Attack()
                    until mob.Humanoid.Health <= 0 or not getgenv().AutoBoss
                end
            end
        end
    end
end)

--================ UI (GRAVITY STYLE) =================
local Orion = loadstring(game:HttpGet(
"https://raw.githubusercontent.com/shlexware/Orion/main/source"
))()

local Window = Orion:MakeWindow({
    Name = "🔥 Chú Cháu Hub | v7",
    HidePremium = true,
    SaveConfig = true,
    ConfigFolder = "ChuChauHub"
})

local Farm = Window:MakeTab({Name="Farm"})
Farm:AddToggle({Name="Auto Farm", Callback=function(v) getgenv().AutoFarm=v end})
Farm:AddToggle({Name="Auto Quest", Callback=function(v) getgenv().AutoQuest=v end})
Farm:AddToggle({Name="Auto Boss", Callback=function(v) getgenv().AutoBoss=v end})
Farm:AddToggle({Name="Auto Haki", Callback=function(v) getgenv().AutoHaki=v end})

local ESP = Window:MakeTab({Name="ESP"})
ESP:AddToggle({Name="ESP Mob", Callback=function(v) getgenv().ESPMob=v end})
ESP:AddToggle({Name="ESP Boss", Callback=function(v) getgenv().ESPBoss=v end})

local Info = Window:MakeTab({Name="Info"})
Info:AddParagraph(
    "Chú Cháu Hub v7",
    "Admin: M.nhat\nStyle: Gravity Hub\nNo Key | Fluxus Ready"
)

Orion:Init()