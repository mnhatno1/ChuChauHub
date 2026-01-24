--==================================================
-- 🔥 CHÚ CHÁU HUB V7.2
-- 👑 Admin: M.nhat
-- Auto Farm + Auto Quest + Bay Cao + ESP
--==================================================

repeat task.wait() until game:IsLoaded()

-- ================= SERVICES =================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer

-- ================= GLOBAL =================
getgenv().AutoFarm = false
getgenv().AutoQuest = false
getgenv().FarmDistance = 25

-- ================= UTIL =================
local function TP(cf)
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    TweenService:Create(hrp, TweenInfo.new(0.25), {CFrame = cf}):Play()
end

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

-- Anti AFK
player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-- ================= AUTO QUEST (SEA 1) =================
local QuestData = {
    {
        Min = 1, Max = 9,
        QuestName = "BanditQuest1",
        QuestPart = "Quest1",
        Mob = "Bandit"
    },
    {
        Min = 10, Max = 29,
        QuestName = "JungleQuest",
        QuestPart = "Quest1",
        Mob = "Monkey"
    },
    {
        Min = 30, Max = 59,
        QuestName = "BuggyQuest1",
        QuestPart = "Quest1",
        Mob = "Pirate"
    }
}

local function GetQuest()
    local level = player.Data.Level.Value
    for _,q in pairs(QuestData) do
        if level >= q.Min and level <= q.Max then
            return q
        end
    end
end

local function StartQuest()
    local q = GetQuest()
    if not q then return end
    pcall(function()
        local args = {
            [1] = q.QuestName,
            [2] = q.QuestPart
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", unpack(args))
    end)
end

-- ================= AUTO FARM =================
local function BringMob(mob)
    pcall(function()
        mob.HumanoidRootPart.CanCollide = false
        mob.Humanoid.WalkSpeed = 0
        mob.Humanoid.JumpPower = 0
        mob.HumanoidRootPart.Size = Vector3.new(60,60,60)
    end)
end

task.spawn(function()
    while task.wait() do
        if getgenv().AutoFarm then
            if getgenv().AutoQuest then
                StartQuest()
            end

            for _,mob in pairs(workspace.Enemies:GetChildren()) do
                if mob:FindFirstChild("Humanoid")
                and mob:FindFirstChild("HumanoidRootPart")
                and mob.Humanoid.Health > 0 then

                    repeat
                        task.wait()
                        EquipWeapon()
                        BringMob(mob)

                        TP(mob.HumanoidRootPart.CFrame * CFrame.new(0, getgenv().FarmDistance, 0))

                        VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                        VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)

                    until mob.Humanoid.Health <= 0 or not getgenv().AutoFarm
                end
            end
        end
    end
end)

-- ================= UI =================
local OrionLib = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/shlexware/Orion/main/source"
))()

local Window = OrionLib:MakeWindow({
    Name = "🔥 Chú Cháu V7.2",
    SaveConfig = true,
    ConfigFolder = "ChuChauHub"
})

local FarmTab = Window:MakeTab({Name="Farm"})
FarmTab:AddToggle({
    Name="Auto Farm",
    Default=false,
    Callback=function(v) getgenv().AutoFarm = v end
})

FarmTab:AddToggle({
    Name="Auto Nhận Nhiệm Vụ",
    Default=false,
    Callback=function(v) getgenv().AutoQuest = v end
})

FarmTab:AddSlider({
    Name="Bay Cao (Anti Quái)",
    Min=15, Max=40, Default=25,
    Callback=function(v) getgenv().FarmDistance = v end
})

local InfoTab = Window:MakeTab({Name="Info"})
InfoTab:AddParagraph(
    "Chú Cháu Hub",
    "Version: V7.2\nAdmin: M.nhat\nAuto Farm + Auto Quest"
)

OrionLib:Init()