--// CHÚ CHÁU HUB V7.2 | UI CUSTOM | FLUXUS SAFE

if game.CoreGui:FindFirstChild("ChuChauHub") then
    game.CoreGui.ChuChauHub:Destroy()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- ScreenGui
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ChuChauHub"
gui.ResetOnSpawn = false

-- LOGO BUTTON
local logo = Instance.new("ImageButton", gui)
logo.Size = UDim2.fromOffset(60,60)
logo.Position = UDim2.fromOffset(20,200)
logo.BackgroundColor3 = Color3.fromRGB(25,25,25)
logo.Image = "https://raw.githubusercontent.com/mnhatno1/ChuChauHub/main/file_000000005738720986a39eb73b58c513.png"
logo.AutoButtonColor = true

local logoCorner = Instance.new("UICorner", logo)
logoCorner.CornerRadius = UDim.new(0,15)

-- MAIN MENU
local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(380,260)
main.Position = UDim2.fromScale(0.5,0.5)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.Visible = false
main.BorderSizePixel = 0

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0,20)

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,50)
title.BackgroundTransparency = 1
title.Text = "🔥 CHÚ CHÁU HUB V7.2 🔥"
title.TextColor3 = Color3.fromRGB(255,170,0)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

-- BUTTON FARM
local farm = Instance.new("TextButton", main)
farm.Size = UDim2.fromOffset(160,50)
farm.Position = UDim2.fromOffset(20,80)
farm.Text = "AUTO FARM"
farm.BackgroundColor3 = Color3.fromRGB(60,60,60)
farm.TextColor3 = Color3.new(1,1,1)
farm.Font = Enum.Font.GothamBold

local farmCorner = Instance.new("UICorner", farm)
farmCorner.CornerRadius = UDim.new(0,14)

-- BUTTON ESP
local esp = Instance.new("TextButton", main)
esp.Size = UDim2.fromOffset(160,50)
esp.Position = UDim2.fromOffset(200,80)
esp.Text = "ESP QUÁI"
esp.BackgroundColor3 = Color3.fromRGB(60,60,60)
esp.TextColor3 = Color3.new(1,1,1)
esp.Font = Enum.Font.GothamBold

local espCorner = Instance.new("UICorner", esp)
espCorner.CornerRadius = UDim.new(0,14)

-- TOGGLE MENU
logo.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- DEMO CHỨC NĂNG
farm.MouseButton1Click:Connect(function()
    farm.Text = "ĐANG FARM..."
end)

esp.MouseButton1Click:Connect(function()
    esp.Text = "ESP BẬT"
end)

-- THÔNG BÁO LOAD
game:GetService("StarterGui"):SetCore("SendNotification",{
    Title="Chú Cháu Hub",
    Text="UI Custom Loaded Thành Công!",
    Duration=5
})