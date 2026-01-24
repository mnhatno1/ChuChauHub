repeat task.wait() until game:IsLoaded()
task.wait(2)

warn("M.Nhat_No1 start loading")

--================ SERVICES =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer

--================ SAFE =================
local function Char()
    return player.Character or player.CharacterAdded:Wait()
end

local function HRP()
    return Char():WaitForChild("HumanoidRootPart")
end

local function Hum()
    return Char():WaitForChild("Humanoid")
end

--================ SETTINGS =================
local Settings = {
    AutoFarm = false,
    BringMob = false,
    AutoClick = false,
    AutoFruit = false,
    ESPPlayer = false,
    ESPFruit = false
}

--================ UI =================
local Gui = Instance.new("ScreenGui")
Gui.Name = "M.Nhat_No1"
Gui.Parent = game.CoreGui

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0,360,0,300)
Main.Position = UDim2.new(0.5,-180,0.5,-150)
Main.BackgroundColor3 = Color3.fromRGB(25,25,25)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner",Main).CornerRadius = UDim.new(0,10)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "🔥 M.Nhat_No1 HUB | FINAL"
Title.TextColor3 = Color3.fromRGB(255,80,80)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

local List = Instance.new("UIListLayout", Main)
List.Padding = UDim.new(0,6)
List.HorizontalAlignment = Enum.HorizontalAlignment.Center
List.VerticalAlignment = Enum.VerticalAlignment.Top

local function Toggle(text, key)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(1,-20,0,34)
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.BorderSizePixel = 0
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,6)

    local function refresh()
        b.Text = text.." : "..(Settings[key] and "ON" or "OFF")
        b.BackgroundColor3 = Settings[key] and Color3.fromRGB(60,120,60)
            or Color3.fromRGB(45,45,45)
        b.TextColor3 = Color3.new(1,1,1)
    end

    refresh()
    b.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        refresh()
    end)
end

task.wait()
Toggle("⚔ Auto Farm","AutoFarm")
Toggle("🧲 Gom Quái","BringMob")
Toggle("🖱 Auto Click","AutoClick")
Toggle("🍎 Nhặt Trái","AutoFruit")
Toggle("👁 ESP Player","ESPPlayer")
Toggle("🍏 ESP Fruit","ESPFruit")

--================ AUTO CLICK =================
RunService.RenderStepped:Connect(function()
    if Settings.AutoClick then
        pcall(function()
            VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait()
            VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end
end)

--================ FIND MOB =================
local function GetMob()
    if not workspace:FindFirstChild("Enemies") then return end
    for _,v in pairs(workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid")
        and v.Humanoid.Health > 0
        and v:FindFirstChild("HumanoidRootPart") then
            return v
        end
    end
end

--================ AUTO FARM =================
task.spawn(function()
    while task.wait() do
        if Settings.AutoFarm then
            local mob = GetMob()
            if mob then
                HRP().CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0,12,0)
            end
        end
    end
end)

--================ BRING MOB =================
task.spawn(function()
    while task.wait(0.3) do
        if Settings.BringMob then
            local mob = GetMob()
            if mob then
                for _,v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("HumanoidRootPart") then
                        v.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame
                        v.HumanoidRootPart.CanCollide = false
                    end
                end
            end
        end
    end
end)

--================ AUTO FRUIT =================
task.spawn(function()
    while task.wait(1) do
        if Settings.AutoFruit then
            for _,v in pairs(workspace:GetChildren()) do
                if string.find(v.Name,"Fruit") and v:FindFirstChild("Handle") then
                    HRP().CFrame = v.Handle.CFrame
                end
            end
        end
    end
end)

--================ ESP =================
local ESPFolder = Instance.new("Folder", Gui)

local function Box(obj,color)
    local b = Instance.new("BoxHandleAdornment")
    b.Adornee = obj
    b.Size = obj.Size
    b.AlwaysOnTop = true
    b.ZIndex = 10
    b.Transparency = 0.5
    b.Color3 = color
    b.Parent = ESPFolder
end

RunService.RenderStepped:Connect(function()
    ESPFolder:ClearAllChildren()

    if Settings.ESPPlayer then
        for _,p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                Box(p.Character.HumanoidRootPart, Color3.fromRGB(255,0,0))
            end
        end
    end

    if Settings.ESPFruit then
        for _,v in pairs(workspace:GetChildren()) do
            if string.find(v.Name,"Fruit") and v:FindFirstChild("Handle") then
                Box(v.Handle, Color3.fromRGB(0,255,0))
            end
        end
    end
end)

game.StarterGui:SetCore("SendNotification",{
    Title="M.Nhat_No1 HUB",
    Text="FINAL Loaded Successfully",
    Duration=3
})

warn("M.Nhat_No1 LOADED SUCCESS")