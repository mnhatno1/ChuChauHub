--// M.Nhat_No1 | FINAL DELTA SAFE
repeat task.wait() until game:IsLoaded()

-- Test load
game.StarterGui:SetCore("SendNotification",{
    Title="M.Nhat_No1",
    Text="Script Loaded",
    Duration=5
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer

-- Safe functions
local function Char()
    return Player.Character or Player.CharacterAdded:Wait()
end
local function HRP()
    return Char():WaitForChild("HumanoidRootPart")
end
local function Hum()
    return Char():WaitForChild("Humanoid")
end

-- Anti AFK
Player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- UI
local Rayfield = loadstring(game:HttpGet(
"https://raw.githubusercontent.com/shlexware/Rayfield/main/source"
))()

local Window = Rayfield:CreateWindow({
    Name="M.Nhat_No1 | Delta Safe",
    LoadingTitle="M.Nhat_No1",
    LoadingSubtitle="Final Stable",
    KeySystem=false
})

local FarmTab = Window:CreateTab("Farm", 4483362458)

-- States
local AutoFarm=false
local AutoQuest=false
local AutoBoss=false
local AutoElite=false
local BringMob=false
local AutoClick=false

-- Toggles
FarmTab:CreateToggle({Name="Auto Quest",CurrentValue=false,Callback=function(v)AutoQuest=v end})
FarmTab:CreateToggle({Name="Auto Farm",CurrentValue=false,Callback=function(v)AutoFarm=v end})
FarmTab:CreateToggle({Name="Auto Boss",CurrentValue=false,Callback=function(v)AutoBoss=v end})
FarmTab:CreateToggle({Name="Auto Elite",CurrentValue=false,Callback=function(v)AutoElite=v end})
FarmTab:CreateToggle({Name="Bring Mob",CurrentValue=false,Callback=function(v)BringMob=v end})
FarmTab:CreateToggle({Name="Auto Click (M1)",CurrentValue=false,Callback=function(v)AutoClick=v end})

-- Auto Click
task.spawn(function()
    while task.wait() do
        if AutoClick then
            VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(0.05)
            VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end
    end
end)

-- Helpers
local function IsBoss(m)
    return m.Name:lower():find("boss")
end

local function IsElite(m)
    local n=m.Name:lower()
    return n:find("elite") or n:find("hunter")
end

local function GetTarget()
    local nearest,dist=nil,math.huge
    for _,m in pairs(Workspace.Enemies:GetChildren()) do
        if m:FindFirstChild("Humanoid")
        and m.Humanoid.Health>0
        and m:FindFirstChild("HumanoidRootPart") then

            if AutoElite and IsElite(m)
            or AutoBoss and IsBoss(m)
            or AutoFarm then
                local d=(HRP().Position-m.HumanoidRootPart.Position).Magnitude
                if d<dist then
                    dist=d
                    nearest=m
                end
            end
        end
    end
    return nearest
end

-- Auto Farm / Boss / Elite
task.spawn(function()
    while task.wait(0.25) do
        if AutoFarm or AutoBoss or AutoElite then
            local t=GetTarget()
            if t then
                HRP().CFrame = t.HumanoidRootPart.CFrame * CFrame.new(0,12,0)
            end
        end
    end
end)

-- Bring Mob
task.spawn(function()
    while task.wait() do
        if BringMob then
            for _,m in pairs(Workspace.Enemies:GetChildren()) do
                if m:FindFirstChild("HumanoidRootPart") then
                    m.HumanoidRootPart.CFrame = HRP().CFrame * CFrame.new(0,0,-4)
                    m.HumanoidRootPart.CanCollide=false
                end
            end
        end
    end
end)

-- Auto Quest (Safe)
task.spawn(function()
    while task.wait(1) do
        if AutoQuest then
            local q=Player.PlayerGui:FindFirstChild("QuestGUI")
            if not q or not q.Enabled then
                for _,npc in pairs(workspace.NPCs:GetChildren()) do
                    local hrp=npc:FindFirstChild("HumanoidRootPart")
                    local p=npc:FindFirstChildWhichIsA("ProximityPrompt",true)
                    if hrp and p then
                        HRP().CFrame = hrp.CFrame * CFrame.new(0,0,3)
                        task.wait(0.6)
                        fireproximityprompt(p)
                        break
                    end
                end
            end
        end
    end
end)

-- Anti fall
RunService.Stepped:Connect(function()
    if AutoFarm or AutoBoss or AutoElite then
        pcall(function()
            Hum():ChangeState(11)
        end)
    end
end)

Rayfield:Notify({
    Title="M.Nhat_No1",
    Content="Final Delta Safe Loaded!",
    Duration=5
})