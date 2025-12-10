-- Lâm Vĩ™ Anti-AFK Hub
local vuong = game:GetService("Players").LocalPlayer
local vuongGui = vuong:FindFirstChild("PlayerGui")
local vuongService = game:GetService("VirtualUser")

-- GUI
local ScreenGui = Instance.new("ScreenGui", vuongGui)
ScreenGui.Name = "LV_AntiAFK_UI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.5, -100, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "🌙 Lâm Vĩ Anti-AFK"
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

local ToggleBtn = Instance.new("TextButton", Frame)
ToggleBtn.Size = UDim2.new(0.8, 0, 0.4, 0)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
ToggleBtn.Text = "Anti-AFK: OFF"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.Gotham
ToggleBtn.TextSize = 14
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

-- Anti-AFK logic
local running = false
local loop

local function startAntiAFK()
    if running then return end
    running = true
    ToggleBtn.Text = "Anti-AFK: ON"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)

    -- xóa kết nối mặc định
    for _, conn in pairs(getconnections(vuong.Idled)) do
        conn:Disable()
    end

    loop = task.spawn(function()
        while running do
            vuongService:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            task.wait(1)
            vuongService:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            task.wait(60)
        end
    end)
end

local function stopAntiAFK()
    running = false
    ToggleBtn.Text = "Anti-AFK: OFF"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
end

ToggleBtn.MouseButton1Click:Connect(function()
    if running then
        stopAntiAFK()
    else
        startAntiAFK()
    end
end)

-- Startsfsfsefsdsdsv
startAntiAFK()
