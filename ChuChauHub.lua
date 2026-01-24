--==================================================
-- 🔥 CHÚ CHÁU HUB v7.1 | FLUXUS FIX
-- 👑 Admin: M.nhat
--==================================================

repeat task.wait() until game:IsLoaded()
task.wait(3) -- ⬅️ CỰC QUAN TRỌNG CHO FLUXUS

pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "ChuChauHub",
        Text = "Đang load UI...",
        Duration = 5
    })
end)

-- LOAD ORION (FIX)
local OrionLib
for i = 1,5 do
    local success, err = pcall(function()
        OrionLib = loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/shlexware/Orion/main/source"
        ))()
    end)
    if success then break end
    task.wait(1)
end

if not OrionLib then
    warn("Không load được Orion UI")
    return
end

-- TẠO WINDOW
local Window = OrionLib:MakeWindow({
    Name = "🔥 Chú Cháu Hub | Fluxus",
    HidePremium = true,
    SaveConfig = false
})

local Tab = Window:MakeTab({Name="Test"})
Tab:AddButton({
    Name="UI OK",
    Callback=function()
        game.StarterGui:SetCore("SendNotification", {
            Title="ChuChauHub",
            Text="UI hoạt động bình thường",
            Duration=5
        })
    end
})

OrionLib:Init()