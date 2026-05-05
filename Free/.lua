local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local plr = Players.LocalPlayer
local playerGui = plr:WaitForChild("PlayerGui")

-- ==================================================
-- XÓA KẾT NỐI IDLE MẶC ĐỊNH
-- ==================================================
for _, conn in pairs(getconnections(plr.Idled)) do
    conn:Disable()
end

-- ==================================================
-- BIẾN TRẠNG THÁI
-- ==================================================
local running = false
local lastInputTime = tick()   -- lần cuối user dùng chuột/bàn phím
local lastClickTime = tick()   -- lần cuối anti-afk click
local IDLE_THRESHOLD = 300     -- 5 phút không input thì mới click
local CLICK_INTERVAL = 60      -- click mỗi 60s khi đang idle
local SHORT_INTERVAL = 55      -- interval kiểm tra (hơi nhỏ hơn để chắc)

-- ==================================================
-- DETECT INPUT CỦA USER (chuột + bàn phím)
-- ==================================================
UserInputService.InputBegan:Connect(function(input)
    -- Cập nhật thời gian input bất kỳ
    lastInputTime = tick()
end)

UserInputService.InputChanged:Connect(function(input)
    -- Detect cả di chuyển chuột
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Gamepad1 then
        lastInputTime = tick()
    end
end)

-- ==================================================
-- LOGIC ANTI-AFK
-- ==================================================
local function doClick()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(0.1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    lastClickTime = tick()
end

local function antiAFKLoop()
    while running do
        local now = tick()
        local idleTime = now - lastInputTime      -- bao lâu không input
        local timeSinceClick = now - lastClickTime -- bao lâu chưa click

        if idleTime >= IDLE_THRESHOLD then
            -- User đang AFK thật sự (5p không dùng gì)
            if timeSinceClick >= CLICK_INTERVAL then
                doClick()
            end
        else
            -- User đang dùng game → không click làm phiền
            -- Nhưng vẫn click 1 lần mỗi 5p để tránh server kick
            -- dù user đang online
            if timeSinceClick >= IDLE_THRESHOLD then
                doClick()
            end
        end

        task.wait(SHORT_INTERVAL)
    end
end

-- ==================================================
-- GUI
-- ==================================================
-- Xóa GUI cũ nếu có
if playerGui:FindFirstChild("LV_AntiAFK_UI") then
    playerGui.LV_AntiAFK_UI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LV_AntiAFK_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 220, 0, 130)
Frame.Position = UDim2.new(0.5, -110, 0.15, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 32)
Title.Text = "🌙 Anti-AFK Pro"
Title.TextColor3 = Color3.fromRGB(0, 255, 128)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15

-- Status label
local StatusLabel = Instance.new("TextLabel", Frame)
StatusLabel.Size = UDim2.new(1, -10, 0, 22)
StatusLabel.Position = UDim2.new(0, 5, 0, 32)
StatusLabel.Text = "Idle: 0s | Last click: 0s ago"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 11

local ToggleBtn = Instance.new("TextButton", Frame)
ToggleBtn.Size = UDim2.new(0.85, 0, 0, 36)
ToggleBtn.Position = UDim2.new(0.075, 0, 0, 60)
ToggleBtn.Text = "Anti-AFK: OFF"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

-- Threshold label
local ThreshLabel = Instance.new("TextLabel", Frame)
ThreshLabel.Size = UDim2.new(1, -10, 0, 18)
ThreshLabel.Position = UDim2.new(0, 5, 0, 104)
ThreshLabel.Text = "Click sau 5p idle | Interval: 60s"
ThreshLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
ThreshLabel.BackgroundTransparency = 1
ThreshLabel.Font = Enum.Font.Gotham
ThreshLabel.TextSize = 10

-- ==================================================
-- UPDATE STATUS REAL-TIME
-- ==================================================
task.spawn(function()
    while true do
        task.wait(1)
        local idleTime = math.floor(tick() - lastInputTime)
        local sinceClick = math.floor(tick() - lastClickTime)
        StatusLabel.Text = string.format(
            "Idle: %ds | Click: %ds ago",
            idleTime, sinceClick
        )
        -- Đổi màu khi đang idle thật sự
        if idleTime >= IDLE_THRESHOLD then
            StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        else
            StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
        end
    end
end)

-- ==================================================
-- TOGGLE
-- ==================================================
local function startAntiAFK()
    if running then return end
    running = true
    lastInputTime = tick()
    lastClickTime = tick()
    ToggleBtn.Text = "Anti-AFK: ON"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 0)
    task.spawn(antiAFKLoop)
end

local function stopAntiAFK()
    running = false
    ToggleBtn.Text = "Anti-AFK: OFF"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
end

ToggleBtn.MouseButton1Click:Connect(function()
    if running then stopAntiAFK() else startAntiAFK() end
end)

-- Tự bật
startAntiAFK()
