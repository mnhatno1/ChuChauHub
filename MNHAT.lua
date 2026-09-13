--[[
    ============================================
    SCRIPT UI - M.nhat_Compile
    Bản hoàn chỉnh - đã nối phần bị thiếu
    ============================================
]]

-- ==================== SERVICES ====================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- ==================== PARENT GUI ====================
local parentGui
pcall(function()
    if gethui then
        parentGui = gethui()
    elseif syn and syn.protect_gui then
        local g = Instance.new("ScreenGui")
        syn.protect_gui(g)
        parentGui = g
    end
end)
if not parentGui then
    pcall(function() parentGui = game:GetService("CoreGui") end)
end
if not parentGui then
    parentGui = LocalPlayer:WaitForChild("PlayerGui")
end

-- ==================== THEME ====================
local THEME = {
    Red = Color3.fromRGB(255, 30, 30),
    RedDark = Color3.fromRGB(180, 15, 15),
    Black = Color3.fromRGB(10, 10, 10),
    Panel = Color3.fromRGB(20, 20, 20),
    PanelLight = Color3.fromRGB(30, 30, 30),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(180, 180, 180),
    Green = Color3.fromRGB(0, 220, 100),
    ToggleKey = Enum.KeyCode.RightShift,
}

-- ==================== AVATAR LINK ====================
local AVATAR_URL = "https://raw.githubusercontent.com/mnhat09082011-source/Mnhat/04707717b542bf8da353bf592a3b62fc4d42943d/Zeroin_nobg.png"
local AVATAR_FILE = "mnhat_avatar.png"

pcall(function()
    if writefile and isfile then
        if not isfile(AVATAR_FILE) then
            local data = game:HttpGet(AVATAR_URL)
            writefile(AVATAR_FILE, data)
        end
    end
end)

-- ==================== MODULE SYSTEM ====================
local Modules = {}

-- Module 1: FyyCommunity
Modules.FyyCommunity = {
    Name = "Fyy Community",
    Description = "Load script từ fyycommunity",
    Enabled = false,
    Thread = nil,
}
function Modules.FyyCommunity.Start(self)
    self.Enabled = true
    self.Thread = task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet("https://fyycommunity.com/"))()
        end)
    end)
end
function Modules.FyyCommunity.Stop(self)
    self.Enabled = false
    self.Thread = nil
end

-- Module 2: Speed Hub X
Modules.SpeedHubX = {
    Name = "Speed Hub X",
    Description = "Load Speed Hub X",
    Enabled = false,
    Thread = nil,
}
function Modules.SpeedHubX.Start(self)
    self.Enabled = true
    self.Thread = task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
        end)
    end)
end
function Modules.SpeedHubX.Stop(self)
    self.Enabled = false
    self.Thread = nil
end

-- Module 3: Luarmor Loader
Modules.Luarmor = {
    Name = "Luarmor Loader",
    Description = "Load Luarmor script",
    Enabled = false,
    Thread = nil,
}
function Modules.Luarmor.Start(self)
    self.Enabled = true
    self.Thread = task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/359e97f8618e9008afe5f496184ebb7c.lua"))()
        end)
    end)
end
function Modules.Luarmor.Stop(self)
    self.Enabled = false
    self.Thread = nil
end

-- Module 4: Zeroinhub
Modules.Zeroinhub = {
    Name = "Zeroinhub",
    Description = "Load script từ zeroinhub",
    Enabled = false,
    Thread = nil,
}
function Modules.Zeroinhub.Start(self)
    self.Enabled = true
    self.Thread = task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet("https://zeroinhub.com/api/script"))()
        end)
    end)
end
function Modules.Zeroinhub.Stop(self)
    self.Enabled = false
    self.Thread = nil
end

-- Module 5: FlowAuth
Modules.FlowAuth = {
    Name = "FlowAuth",
    Description = "Load script từ FlowAuth",
    Enabled = false,
    Thread = nil,
}
function Modules.FlowAuth.Start(self)
    self.Enabled = true
    self.Thread = task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet("https://flowauth.net/v1/loaders/69d3463240384f3a73fbe32c178093a2.lua"))()
        end)
    end)
end
function Modules.FlowAuth.Stop(self)
    self.Enabled = false
    self.Thread = nil
end

-- Module 6: Ciao Hub (Tab Hop)
Modules.PastefyScript = {
    Name = "Ciao Hub",
    Description = "Load script từ pastefy.app",
    Enabled = false,
    Thread = nil,
}
function Modules.PastefyScript.Start(self)
    self.Enabled = true
    self.Thread = task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet("https://pastefy.app/YoZocJ8O/raw"))()
        end)
    end)
end
function Modules.PastefyScript.Stop(self)
    self.Enabled = false
    self.Thread = nil
end

-- Danh sách module theo tab
local TabModules = {
    Main = { "FyyCommunity", "SpeedHubX", "Luarmor", "Zeroinhub", "FlowAuth" },
    Info = {},
    Hop = { "PastefyScript" },
}

-- ==================== MAIN GUI ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MnhatCompile_" .. HttpService:GenerateGUID(false)
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = parentGui

-- ==================== MAIN FRAME ====================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 300)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
MainFrame.BackgroundColor3 = THEME.Black
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = MainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = THEME.Red
mainStroke.Thickness = 2
mainStroke.Transparency = 0.2
mainStroke.Parent = MainFrame

-- ==================== HEADER ====================
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 40)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = THEME.Panel
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 14)
headerCorner.Parent = Header

local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 15)
headerFix.Position = UDim2.new(0, 0, 1, -15)
headerFix.BackgroundColor3 = THEME.Panel
headerFix.BorderSizePixel = 0
headerFix.Parent = Header

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 300, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ M.nhat_Compile"
Title.TextColor3 = THEME.Red
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.Parent = Header

-- Nút Minimize
local MinBtn = Instance.new("TextButton")
MinBtn.Name = "MinBtn"
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -75, 0, 5)
MinBtn.BackgroundColor3 = THEME.PanelLight
MinBtn.Text = "−"
MinBtn.TextColor3 = THEME.Text
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.BorderSizePixel = 0
MinBtn.Parent = Header

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = MinBtn

-- Nút Close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundColor3 = THEME.RedDark
CloseBtn.Text = "×"
CloseBtn.TextColor3 = THEME.Text
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = Header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = CloseBtn

-- ==================== TAB BAR ====================
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(1, -20, 0, 30)
TabBar.Position = UDim2.new(0, 10, 0, 45)
TabBar.BackgroundTransparency = 1
TabBar.Parent = MainFrame

local tabBarLayout = Instance.new("UIListLayout")
tabBarLayout.FillDirection = Enum.FillDirection.Horizontal
tabBarLayout.Padding = UDim.new(0, 6)
tabBarLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabBarLayout.Parent = TabBar

-- ==================== CONTENT AREA (SCROLLING) ====================
local Content = Instance.new("ScrollingFrame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -20, 1, -90)
Content.Position = UDim2.new(0, 10, 0, 80)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 4
Content.ScrollBarImageColor3 = THEME.Red
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.ScrollBarImageTransparency = 0.3
Content.Parent = MainFrame

local contentGrid = Instance.new("UIGridLayout")
contentGrid.CellSize = UDim2.new(0, 230, 0, 80)
contentGrid.CellPadding = UDim2.new(0, 10, 0, 10)
contentGrid.SortOrder = Enum.SortOrder.LayoutOrder
contentGrid.Parent = Content

local contentPad = Instance.new("UIPadding")
contentPad.PaddingTop = UDim.new(0, 10)
contentPad.PaddingLeft = UDim.new(0, 5)
contentPad.PaddingBottom = UDim.new(0, 10)
contentPad.Parent = Content

contentGrid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Content.CanvasSize = UDim2.new(0, 0, 0, contentGrid.AbsoluteContentSize.Y + 20)
end)

-- ==================== FLOATING TOGGLE BUTTON ====================
local FloatBtn = Instance.new("TextButton")
FloatBtn.Name = "FloatBtn"
FloatBtn.Size = UDim2.new(0, 50, 0, 50)
FloatBtn.Position = UDim2.new(0, 15, 0.5, -25)
FloatBtn.BackgroundColor3 = THEME.Black
FloatBtn.Text = ""
FloatBtn.BorderSizePixel = 0
FloatBtn.Visible = false
FloatBtn.Active = true
FloatBtn.ZIndex = 2
FloatBtn.Parent = ScreenGui

local floatCorner = Instance.new("UICorner")
floatCorner.CornerRadius = UDim.new(0, 25)
floatCorner.Parent = FloatBtn

-- VIỀN CẦU VỒNG
local rainbowColors = {
    Color3.fromRGB(255, 0, 0),
    Color3.fromRGB(255, 127, 0),
    Color3.fromRGB(255, 255, 0),
    Color3.fromRGB(0, 255, 0),
    Color3.fromRGB(0, 0, 255),
    Color3.fromRGB(75, 0, 130),
    Color3.fromRGB(148, 0, 211),
}

local rainbowStrokes = {}
for i, color in ipairs(rainbowColors) do
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = 1.5
    stroke.Transparency = 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = FloatBtn
    table.insert(rainbowStrokes, stroke)
end

task.spawn(function()
    local t = 0
    while FloatBtn.Parent do
        t = t + 0.02
        for i, stroke in ipairs(rainbowStrokes) do
            local hue = (t + i / #rainbowStrokes) % 1
            local color = Color3.fromHSV(hue, 1, 1)
            if stroke and stroke.Parent then
                stroke.Color = color
            end
        end
        task.wait(0.05)
    end
end)

-- AVATAR ICON
local FloatIcon = Instance.new("ImageLabel")
FloatIcon.Name = "FloatIcon"
FloatIcon.Size = UDim2.new(1, -6, 1, -6)
FloatIcon.Position = UDim2.new(0, 3, 0, 3)
FloatIcon.BackgroundTransparency = 1
FloatIcon.ScaleType = Enum.ScaleType.Fit
FloatIcon.ZIndex = 3
FloatIcon.Parent = FloatBtn

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 25)
iconCorner.Parent = FloatIcon

pcall(function()
    if getcustomasset and isfile and isfile(AVATAR_FILE) then
        FloatIcon.Image = getcustomasset(AVATAR_FILE)
    else
        FloatIcon.Image = AVATAR_URL
    end
end)

-- GLOW
local glow = Instance.new("ImageLabel")
glow.Name = "Glow"
glow.Size = UDim2.new(1, 12, 1, 12)
glow.Position = UDim2.new(0, -6, 0, -6)
glow.BackgroundTransparency = 1
glow.Image = FloatIcon.Image
glow.ImageTransparency = 0.6
glow.ScaleType = Enum.ScaleType.Fit
glow.ZIndex = 1
glow.Parent = FloatBtn

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 30)
glowCorner.Parent = glow

-- DI CHUYỂN FLOATBTN
local floatDragging = false
local floatDragStart = nil
local floatStartPos = nil
local floatMoved = false

FloatBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        floatDragging = true
        floatMoved = false
        floatDragStart = input.Position
        floatStartPos = FloatBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                floatDragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if floatDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - floatDragStart
        if math.abs(delta.X) > 3 or math.abs(delta.Y) > 3 then
            floatMoved = true
        end
        FloatBtn.Position = UDim2.new(
            floatStartPos.X.Scale, floatStartPos.X.Offset + delta.X,
            floatStartPos.Y.Scale, floatStartPos.Y.Offset + delta.Y
        )
    end
end)

-- DRAGGABLE MAINFRAME
local dragging = false
local dragStart = nil
local startPos = nil

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- TWEEN ANIMATIONS
local function OpenUI()
    MainFrame.Visible = true
    FloatBtn.Visible = false
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    local tween = TweenService:Create(
        MainFrame,
        TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {
            Size = UDim2.new(0, 500, 0, 300),
            Position = UDim2.new(0.5, -250, 0.5, -150)
        }
    )
    tween:Play()
end

local function CloseUI()
    local tween = TweenService:Create(
        MainFrame,
        TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }
    )
    tween:Play()
    tween.Completed:Connect(function()
        MainFrame.Visible = false
        FloatBtn.Visible = true
    end)
end

CloseBtn.MouseButton1Click:Connect(CloseUI)

FloatBtn.MouseButton1Click:Connect(function()
    if not floatMoved then
        OpenUI()
    end
end)

-- MINIMIZE / EXPAND
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MinBtn.Text = "+"
        local tween = TweenService:Create(
            MainFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { Size = UDim2.new(0, 500, 0, 40) }
        )
        tween:Play()
        TabBar.Visible = false
        Content.Visible = false
    else
        MinBtn.Text = "−"
        local tween = TweenService:Create(
            MainFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { Size = UDim2.new(0, 500, 0, 300) }
        )
        tween:Play()
        TabBar.Visible = true
        Content.Visible = true
    end
end)

-- KEY TOGGLE
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == THEME.ToggleKey then
        if MainFrame.Visible then
            CloseUI()
        else
            OpenUI()
        end
    end
end)

-- ==================== TẠO Ô SCRIPT CON (KHÔNG LOGO) ====================
local function CreateModuleBox(moduleKey, layoutOrder)
    local module = Modules[moduleKey]
    if not module then return end

    local box = Instance.new("Frame")
    box.Name = moduleKey
    box.BackgroundColor3 = THEME.PanelLight
    box.BorderSizePixel = 0
    box.LayoutOrder = layoutOrder
    box.Parent = Content

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 10)
    boxCorner.Parent = box

    local boxStroke = Instance.new("UIStroke")
    boxStroke.Color = THEME.Red
    boxStroke.Thickness = 1
    boxStroke.Transparency = 0.6
    boxStroke.Parent = box

    -- TÊN SCRIPT
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -20, 0, 25)
    nameLabel.Position = UDim2.new(0, 12, 0, 10)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = module.Name
    nameLabel.TextColor3 = THEME.Text
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 15
    nameLabel.Parent = box

    -- MÔ TẢ
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -20, 0, 15)
    descLabel.Position = UDim2.new(0, 12, 0, 35)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = module.Description
    descLabel.TextColor3 = THEME.TextDim
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 10
    descLabel.Parent = box

    -- NÚT TOGGLE
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 60, 0, 25)
    toggleBtn.Position = UDim2.new(1, -70, 1, -35)
    toggleBtn.BackgroundColor3 = THEME.RedDark
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = THEME.Text
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 11
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = box

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleBtn

    toggleBtn.MouseButton1Click:Connect(function()
        module.Enabled = not module.Enabled
        if module.Enabled then
            pcall(function() module:Start() end)
            toggleBtn.BackgroundColor3 = THEME.Green
            toggleBtn.Text = "ON"
            boxStroke.Transparency = 0.2
            boxStroke.Color = THEME.Green
        else
            pcall(function() module:Stop() end)
            toggleBtn.BackgroundColor3 = THEME.RedDark
            toggleBtn.Text = "OFF"
            boxStroke.Transparency = 0.6
            boxStroke.Color = THEME.Red
        end
    end)
end

-- ==================== TẠO Ô INFO (TIKTOK) ====================
local function CreateInfoBox()
    local box = Instance.new("Frame")
    box.Name = "InfoBox"
    box.Size = UDim2.new(1, -20, 0, 60)
    box.Position = UDim2.new(0, 10, 0, 10)
    box.BackgroundColor3 = THEME.PanelLight
    box.BorderSizePixel = 0
    box.LayoutOrder = 999
    box.Parent = Content

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 10)
    boxCorner.Parent = box

    local boxStroke = Instance.new("UIStroke")
    boxStroke.Color = THEME.Red
    boxStroke.Thickness = 1
    boxStroke.Transparency = 0.4
    boxStroke.Parent = box

    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -20, 1, 0)
    infoLabel.Position = UDim2.new(0, 15, 0, 0)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "Tiktok: tiktok.com/@m.nhatdev101"
    infoLabel.TextColor3 = THEME.Text
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
        infoLabel.TextColor3 = THEME.Text
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.Font = Enum.Font.GothamBold
    infoLabel.TextSize = 14
    infoLabel.Parent = box
end

-- ==================== RENDER TAB ====================
local function RenderTab(tabName)
    for _, v in pairs(Content:GetChildren()) do
        if v:IsA("Frame") then
            v:Destroy()
        end
    end

    if tabName == "Info" then
        CreateInfoBox()
        return
    end

    local list = TabModules[tabName]
    if not list then return end

    for i, modKey in ipairs(list) do
        CreateModuleBox(modKey, i)
    end
end

-- ==================== TẠO TAB BUTTON ====================
local TabButtons = {}
local function CreateTabButton(tabName, order)
    local btn = Instance.new("TextButton")
    btn.Name = tabName
    btn.Size = UDim2.new(0, 90, 0, 28)
    btn.BackgroundColor3 = THEME.PanelLight
    btn.Text = tabName
    btn.TextColor3 = THEME.Text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.LayoutOrder = order
    btn.Parent = TabBar

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn

    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(TabButtons) do
            b.BackgroundColor3 = THEME.PanelLight
        end
        btn.BackgroundColor3 = THEME.RedDark
        RenderTab(tabName)
    end)

    table.insert(TabButtons, btn)
    return btn
end

CreateTabButton("Main", 1)
CreateTabButton("Info", 2)
CreateTabButton("Hop", 3)

TabButtons[1].BackgroundColor3 = THEME.RedDark
RenderTab("Main")

-- ==================== INIT ====================
MainFrame.Visible = false
FloatBtn.Visible = true
print("[M.nhat_Compile] UI Loaded. Press RightShift to toggle.")
