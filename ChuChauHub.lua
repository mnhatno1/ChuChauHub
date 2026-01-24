repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Workspace:FindFirstChild("Enemies")

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer

-- STATES
local AutoFarm=false
local BringMob=false
local AutoClick=false
local FarmMode="Melee" -- Melee / Sword / Fruit / Gun

-- ANTI AFK
Player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(), workspace.CurrentCamera.CFrame)
end)

-- CHARACTER
local function Char()
    return Player.Character or Player.CharacterAdded:Wait()
end
local function HRP()
    return Char():WaitForChild("HumanoidRootPart")
end

-- ================= UI =================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "M_Nhat_No1"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,270,0,380)
main.Position = UDim2.new(0.05,0,0.2,0)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.Text = "M.Nhat_No1 | Fluxus"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(40,40,40)
title.Font = Enum.Font.GothamBold
title.TextSize = 14

local function Button(text,y)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.9,0,0,34)
    b.Position = UDim2.new(0.05,0,0,y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(60,60,60)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 13
    return b
end

-- MAIN TOGGLES
local farmBtn = Button("Auto Farm : OFF",50)
local bringBtn = Button("Bring Mob : OFF",90)
local clickBtn = Button("Auto Click : OFF",130)

-- MODE LABEL
local modeLabel = Instance.new("TextLabel", main)
modeLabel.Size = UDim2.new(0.9,0,0,30)
modeLabel.Position = UDim2.new(0.05,0,0,175)
modeLabel.Text = "Farm Mode : Melee"
modeLabel.TextColor3 = Color3.new(1,1,1)
modeLabel.BackgroundColor3 = Color3.fromRGB(35,35,35)
modeLabel.Font = Enum.Font.GothamBold
modeLabel.TextSize = 13

-- MODE BUTTONS
local meleeBtn = Button("Melee",215)
local swordBtn = Button("Sword",255)
local fruitBtn = Button("Fruit",295)
local gunBtn   = Button("Gun",335)

-- BUTTON LOGIC
farmBtn.MouseButton1Click:Connect(function()
    AutoFarm = not AutoFarm
    farmBtn.Text = "Auto Farm : "..(AutoFarm and "ON" or "OFF")
end)

bringBtn.MouseButton1Click:Connect(function()
    BringMob = not BringMob
    bringBtn.Text = "Bring Mob : "..(BringMob and "ON" or "OFF")
end)

clickBtn.MouseButton1Click:Connect(function()
    AutoClick = not AutoClick
    clickBtn.Text = "Auto Click : "..(AutoClick and "ON" or "OFF")
end)

local function SetMode(m)
    FarmMode = m
    modeLabel.Text = "Farm Mode : "..m
end

meleeBtn.MouseButton1Click:Connect(function() SetMode("Melee") end)
swordBtn.MouseButton1Click:Connect(function() SetMode("Sword") end)
fruitBtn.MouseButton1Click:Connect(function() SetMode("Fruit") end)
gunBtn.MouseButton1Click:Connect(function() SetMode("Gun") end)

-- ================= FARM LOGIC =================

-- AUTO EQUIP
local function EquipTool()
    local backpack = Player.Backpack
    for _,tool in pairs(backpack:GetChildren()) do
        local n = tool.Name:lower()

        if FarmMode=="Melee"
        and not n:find("sword")
        and not n:find("gun")
        and not n:find("fruit") then
            Char():FindFirstChildOfClass("Humanoid"):EquipTool(tool)
            return
        end

        if FarmMode=="Sword" and n:find("sword") then
            Char():FindFirstChildOfClass("Humanoid"):EquipTool(tool)
            return
        end

        if FarmMode=="Gun" and n:find("gun") then
            Char():FindFirstChildOfClass("Humanoid"):EquipTool(tool)
            return
        end

        if FarmMode=="Fruit" and (n:find("fruit") or n:find("blox")) then
            Char():FindFirstChildOfClass("Humanoid"):EquipTool(tool)
            return
        end
    end
end

-- AUTO CLICK
task.spawn(function()
    while task.wait(0.08) do
        if AutoClick then
            VirtualUser:Button1Down(Vector2.new(), workspace.CurrentCamera.CFrame)
            task.wait(0.03)
            VirtualUser:Button1Up(Vector2.new(), workspace.CurrentCamera.CFrame)
        end
    end
end)

-- FIND ENEMY
local function GetEnemy()
    for _,m in pairs(Workspace.Enemies:GetChildren()) do
        if m:FindFirstChild("HumanoidRootPart")
        and m:FindFirstChild("Humanoid")
        and m.Humanoid.Health > 0 then
            return m
        end
    end
end

-- AUTO FARM (ĐÁNH XA – NHANH)
task.spawn(function()
    while task.wait(0.25) do
        if AutoFarm and HRP() then
            EquipTool()
            local enemy = GetEnemy()
            if enemy then
                HRP().CFrame =
                    enemy.HumanoidRootPart.CFrame * CFrame.new(0,15,10)
            end
        end
    end
end)

-- BRING MOB
task.spawn(function()
    while task.wait(0.4) do
        if BringMob and HRP() then
            for _,m in pairs(Workspace.Enemies:GetChildren()) do
                if m:FindFirstChild("HumanoidRootPart") then
                    m.HumanoidRootPart.CFrame =
                        HRP().CFrame * CFrame.new(0,0,-5)
                    m.HumanoidRootPart.CanCollide=false
                end
            end
        end
    end
end)

-- NOTIFY
game.StarterGui:SetCore("SendNotification",{
    Title="M.Nhat_No1",
    Text="Loaded | Mode Select Ready",
    Duration=5
})