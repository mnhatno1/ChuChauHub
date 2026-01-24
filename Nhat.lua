--// M.Nhat_No1 | FULL MAX v5 | Delta Android
repeat task.wait() until game:IsLoaded()
warn("M.Nhat_No1 v5 loading...")

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer

--// SAFE
local function Char() return Player.Character or Player.CharacterAdded:Wait() end
local function HRP() return Char():WaitForChild("HumanoidRootPart") end
local function Hum() return Char():WaitForChild("Humanoid") end

--// SETTINGS
local S = {
    AutoQuest = false,
    AutoFarm  = false,
    AutoBoss  = false,
    AutoElite = false,
    BringMob  = false,
    AutoClick = false,
    ESPPlayer = false,
    ESPFruit  = false
}

--// ANTI AFK
Player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

--// UI (Rayfield)
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()
local Window = Rayfield:CreateWindow({
    Name = "M.Nhat_No1 | Blox Fruits",
    LoadingTitle = "M.Nhat_No1",
    LoadingSubtitle = "FULL MAX v5 (Mobile)",
    ConfigurationSaving = {Enabled=true, FolderName="M.Nhat_No1", FileName="Config"},
    KeySystem = false
})

local FarmTab     = Window:CreateTab("Farm", 4483362458)
local VisualTab   = Window:CreateTab("Visual", 4483362458)
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
local ServerTab   = Window:CreateTab("Server", 4483362458)
local MiscTab     = Window:CreateTab("Misc", 4483362458)

--// FARM TOGGLES
FarmTab:CreateToggle({Name="Auto Quest", CurrentValue=false, Callback=function(v) S.AutoQuest=v end})
FarmTab:CreateToggle({Name="Auto Farm",  CurrentValue=false, Callback=function(v) S.AutoFarm=v end})
FarmTab:CreateToggle({Name="Auto Boss",  CurrentValue=false, Callback=function(v) S.AutoBoss=v end})
FarmTab:CreateToggle({Name="Auto Elite", CurrentValue=false, Callback=function(v) S.AutoElite=v end})
FarmTab:CreateToggle({Name="Bring Mob",  CurrentValue=false, Callback=function(v) S.BringMob=v end})
FarmTab:CreateToggle({Name="Auto Click (M1)", CurrentValue=false, Callback=function(v) S.AutoClick=v end})

--// VISUAL
VisualTab:CreateToggle({Name="ESP Player (Box)", CurrentValue=false, Callback=function(v) S.ESPPlayer=v end})
VisualTab:CreateToggle({Name="ESP Fruit", CurrentValue=false, Callback=function(v) S.ESPFruit=v end})

--// TELEPORT (BASIC)
local Islands = {
    Starter=CFrame.new(0,10,0),
    Jungle=CFrame.new(-1320,10,450),
    Desert=CFrame.new(1100,10,430),
    Marineford=CFrame.new(-4500,10,4300)
}
for n,cf in pairs(Islands) do
    TeleportTab:CreateButton({Name="Teleport: "..n, Callback=function() HRP().CFrame=cf end})
end

--// SERVER
ServerTab:CreateButton({
    Name="Server Hop",
    Callback=function()
        local place=game.PlaceId
        local url="https://games.roblox.com/v1/games/"..place.."/servers/Public?sortOrder=Asc&limit=100"
        local data=HttpService:JSONDecode(game:HttpGet(url))
        for _,s in pairs(data.data) do
            if s.playing < s.maxPlayers then
                TeleportService:TeleportToPlaceInstance(place, s.id, Player)
                break
            end
        end
    end
})

--// MISC
MiscTab:CreateButton({Name="Rejoin", Callback=function() TeleportService:Teleport(game.PlaceId, Player) end})

--// AUTO CLICK
task.spawn(function()
    while task.wait() do
        if S.AutoClick then
            VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(0.05)
            VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end
    end
end)

--// HELPERS
local function isBoss(m) return m.Name:lower():find("boss") end
local function isElite(m)
    local n=m.Name:lower()
    return n:find("elite") or n:find("hunter")
end

local function getNearest(onlyBoss, onlyElite)
    local best,dist=nil,math.huge
    for _,m in pairs(Workspace.Enemies:GetChildren()) do
        if m:FindFirstChild("Humanoid") and m.Humanoid.Health>0 and m:FindFirstChild("HumanoidRootPart") then
            if (not onlyBoss or isBoss(m)) and (not onlyElite or isElite(m)) then
                local d=(HRP().Position-m.HumanoidRootPart.Position).Magnitude
                if d<dist then dist=d; best=m end
            end
        end
    end
    return best
end

--// AUTO FARM / BOSS / ELITE
task.spawn(function()
    while task.wait(0.25) do
        local m=nil
        if S.AutoElite then m=getNearest(false,true)
        elseif S.AutoBoss then m=getNearest(true,false)
        elseif S.AutoFarm then m=getNearest(false,false) end
        if m then HRP().CFrame = m.HumanoidRootPart.CFrame * CFrame.new(0,12,0) end
    end
end)

--// BRING MOB
task.spawn(function()
    while task.wait() do
        if S.BringMob then
            for _,m in pairs(Workspace.Enemies:GetChildren()) do
                if m:FindFirstChild("HumanoidRootPart") then
                    m.HumanoidRootPart.CFrame = HRP().CFrame * CFrame.new(0,0,-4)
                    m.HumanoidRootPart.CanCollide=false
                end
            end
        end
    end
end)

--// AUTO QUEST (SAFE BASIC)
task.spawn(function()
    while task.wait(1) do
        if S.AutoQuest then
            local q=Player.PlayerGui:FindFirstChild("QuestGUI")
            if not q or not q.Enabled then
                for _,npc in pairs(Workspace.NPCs:GetChildren()) do
                    local hrp=npc:FindFirstChild("HumanoidRootPart")
                    local p=npc:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if hrp and p then
                        HRP().CFrame = hrp.CFrame * CFrame.new(0,0,3)
                        task.wait(0.8); fireproximityprompt(p); break
                    end
                end
            end
        end
    end
end)

--// ESP PLAYER
task.spawn(function()
    while task.wait(1) do
        if S.ESPPlayer then
            for _,pl in pairs(Players:GetPlayers()) do
                if pl~=Player and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                    if not pl.Character:FindFirstChild("ESP_BOX") then
                        local b=Instance.new("BoxHandleAdornment")
                        b.Name="ESP_BOX"; b.Adornee=pl.Character.HumanoidRootPart
                        b.Size=Vector3.new(4,6,4); b.Color3=Color3.fromRGB(255,0,0)
                        b.AlwaysOnTop=true; b.ZIndex=5; b.Parent=pl.Character
                    end
                end
            end
        end
    end
end)

--// ESP FRUIT
task.spawn(function()
    while task.wait(1) do
        if S.ESPFruit then
            for _,f in pairs(Workspace:GetChildren()) do
                if f.Name:lower():find("fruit") and f:FindFirstChild("Handle") then
                    if not f:FindFirstChild("ESP") then
                        local h=Instance.new("Highlight", f); h.Name="ESP"
                        h.FillColor=Color3.fromRGB(0,255,0); h.OutlineColor=Color3.fromRGB(255,255,255)
                    end
                end
            end
        end
    end
end)

--// ANTI FALL / BAY ỔN ĐỊNH
RunService.Stepped:Connect(function()
    if S.AutoFarm or S.AutoBoss or S.AutoElite then
        pcall(function() Hum():ChangeState(11) end)
    end
end)

Rayfield:Notify({Title="M.Nhat_No1", Content="FULL MAX v5 Loaded!", Duration=5})