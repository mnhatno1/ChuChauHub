-- =================================================
-- 🔥 CHÚ CHÁU HUB V7.2 | BLOX FRUITS
-- 👑 Admin: M.nhat
-- 📱 Executor: Fluxus Android
-- =================================================

repeat task.wait() until game:IsLoaded()

-- Anti Kick
pcall(function()
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        task.wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end)

-- ================== UI ==================
local Player = game.Players.LocalPlayer
local Gui = Instance.new("ScreenGui", Player.PlayerGui)
Gui.Name = "ChuChauHub"
Gui.ResetOnSpawn = false

-- MAIN FRAME
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 300, 0, 260)
Main.Position = UDim2.new(0.5, -150, 0.5, -130)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.Visible = true
Main.Active = true
Main.Draggable = true

-- BO GÓC
local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 20)

-- TITLE
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "CHÚ CHÁU HUB V7.2"
Title.TextColor3 = Color3.fromRGB(255,120,0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

-- LOGO BUTTON
local Logo = Instance.new("ImageButton", Gui)
Logo.Size = UDim2.new(0,60,0,60)
Logo.Position = UDim2.new(0,20,0.5,-30)
Logo.Image = "https://raw.githubusercontent.com/mnhatno1/ChuChauHub/main/file_000000005738720986a39eb73b58c513.png"
Logo.BackgroundTransparency = 1

Logo.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- BUTTON AUTO FARM
local AutoFarmBtn = Instance.new("TextButton", Main)
AutoFarmBtn.Size = UDim2.new(0.8,0,0,40)
AutoFarmBtn.Position = UDim2.new(0.1,0,0.3,0)
AutoFarmBtn.Text = "AUTO FARM: OFF"
AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
AutoFarmBtn.TextColor3 = Color3.fromRGB(255,255,255)
AutoFarmBtn.Font = Enum.Font.GothamBold
AutoFarmBtn.TextSize = 16
Instance.new("UICorner", AutoFarmBtn).CornerRadius = UDim.new(0,12)

-- ================= AUTO FARM =================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local lp = Players.LocalPlayer
getgenv().AutoFarm = false

AutoFarmBtn.MouseButton1Click:Connect(function()
    AutoFarm = not AutoFarm
    AutoFarmBtn.Text = AutoFarm and "AUTO FARM: ON" or "AUTO FARM: OFF"
end)

function TweenTo(cf)
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    TweenService:Create(hrp, TweenInfo.new(0.3), {CFrame = cf}):Play()
end

function GetMob()
    for _,v in pairs(workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            return v
        end
    end
end

task.spawn(function()
    while task.wait() do
        if AutoFarm then
            pcall(function()
                local mob = GetMob()
                if mob then
                    TweenTo(mob.HumanoidRootPart.CFrame * CFrame.new(0,25,0))
                    mob.HumanoidRootPart.Size = Vector3.new(50,50,50)
                    mob.HumanoidRootPart.Transparency = 1
                    mob.HumanoidRootPart.CanCollide = false
                    game:GetService("VirtualUser"):Button1Down(Vector2.new())
                    task.wait(0.1)
                    game:GetService("VirtualUser"):Button1Up(Vector2.new())
                end
            end)
        end
    end
end)

print("🔥 Chú Cháu Hub V7.2 Loaded Successfully")