local Players = game:GetService("Players")
local VU = game:GetService("VirtualUser")
local UIS = game:GetService("UserInputService")

local me = Players.LocalPlayer
local guiParent = me:WaitForChild("PlayerGui")

-- Đổi tên gui name
local guiName = "Dac Cau Anti-AFK"

-- mốc mặc định
local idleLimit = 300   -- 5p
local tapDelay = 60     -- sau mỗi 60s nếu đang idle thì fake click
local loopDelay = 2

local isOn = true
local hideBody = false
local lastInputTick = tick()
local lastTapTick = tick()

local function clampNum(v, minN, maxN)
    if v < minN then return minN end
    if v > maxN then return maxN end
    return v
end

local function touchInput()
    lastInputTick = tick()
end

-- chặn idled 
pcall(function()
    local conns = getconnections(me.Idled)
    for _, x in ipairs(conns) do
        pcall(function()
            x:Disable()
        end)
    end
end)

UIS.InputBegan:Connect(function()
    touchInput()
end)

UIS.InputChanged:Connect(function(inputObj)
    local t = inputObj.UserInputType
    if t == Enum.UserInputType.MouseMovement then
        touchInput()
    elseif t == Enum.UserInputType.Gamepad1 then
        touchInput()
    end
end)

local function doFakeTap()
    local cam = workspace.CurrentCamera
    if cam == nil then return end
    VU:Button2Down(Vector2.new(0, 0), cam.CFrame)
    task.wait(0.1)
    VU:Button2Up(Vector2.new(0, 0), cam.CFrame)
    lastTapTick = tick()
end

if guiParent:FindFirstChild(guiName) then
    guiParent[guiName]:Destroy()
end

local root = Instance.new("ScreenGui")
root.Name = guiName
root.ResetOnSpawn = false
root.Parent = guiParent

local main = Instance.new("Frame")
main.Parent = root
main.Size = UDim2.new(0, 300, 0, 190)
main.Position = UDim2.new(0.5, -150, 0.16, 0)
main.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = main

local outStroke = Instance.new("UIStroke")
outStroke.Parent = main
outStroke.Color = Color3.fromRGB(70, 85, 120)
outStroke.Thickness = 1
outStroke.Transparency = 0.2

local top = Instance.new("Frame")
top.Parent = main
top.Size = UDim2.new(1, 0, 0, 34)
top.BackgroundColor3 = Color3.fromRGB(28, 32, 42)
top.BorderSizePixel = 0

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 12)
topCorner.Parent = top

local title = Instance.new("TextLabel")
title.Parent = top
title.Size = UDim2.new(1, -70, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(175, 240, 200)
title.Text = "DacCau Anti-AFK"

local miniBtn = Instance.new("TextButton")
miniBtn.Parent = top
miniBtn.Size = UDim2.new(0, 24, 0, 24)
miniBtn.Position = UDim2.new(1, -56, 0.5, -12)
miniBtn.BackgroundColor3 = Color3.fromRGB(46, 54, 70)
miniBtn.Text = "-"
miniBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
miniBtn.Font = Enum.Font.GothamBold
miniBtn.TextSize = 15
Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 6)

local closeBtn = Instance.new("TextButton")
closeBtn.Parent = top
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -28, 0.5, -12)
closeBtn.BackgroundColor3 = Color3.fromRGB(90, 45, 45)
closeBtn.Text = "x"
closeBtn.TextColor3 = Color3.fromRGB(255, 220, 220)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

local body = Instance.new("Frame")
body.Parent = main
body.Size = UDim2.new(1, -16, 1, -46)
body.Position = UDim2.new(0, 8, 0, 38)
body.BackgroundTransparency = 1

local statusTxt = Instance.new("TextLabel")
statusTxt.Parent = body
statusTxt.Size = UDim2.new(1, 0, 0, 24)
statusTxt.BackgroundTransparency = 1
statusTxt.TextXAlignment = Enum.TextXAlignment.Left
statusTxt.Font = Enum.Font.Gotham
statusTxt.TextSize = 12
statusTxt.TextColor3 = Color3.fromRGB(185, 190, 205)
statusTxt.Text = "Status: ON | Idle: 0s | Last click: 0s"

local toggleBtn = Instance.new("TextButton")
toggleBtn.Parent = body
toggleBtn.Size = UDim2.new(0, 130, 0, 32)
toggleBtn.Position = UDim2.new(0, 0, 0, 30)
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 145, 70)
toggleBtn.Text = "Anti-AFK: ON"
toggleBtn.TextColor3 = Color3.fromRGB(245, 245, 245)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 12
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

local testBtn = Instance.new("TextButton")
testBtn.Parent = body
testBtn.Size = UDim2.new(0, 130, 0, 32)
testBtn.Position = UDim2.new(1, -130, 0, 30)
testBtn.BackgroundColor3 = Color3.fromRGB(60, 86, 140)
testBtn.Text = "Test Click"
testBtn.TextColor3 = Color3.fromRGB(245, 245, 245)
testBtn.Font = Enum.Font.GothamBold
testBtn.TextSize = 12
Instance.new("UICorner", testBtn).CornerRadius = UDim.new(0, 8)

local idleLine = Instance.new("TextLabel")
idleLine.Parent = body
idleLine.Size = UDim2.new(1, 0, 0, 20)
idleLine.Position = UDim2.new(0, 0, 0, 74)
idleLine.BackgroundTransparency = 1
idleLine.TextXAlignment = Enum.TextXAlignment.Left
idleLine.Font = Enum.Font.Gotham
idleLine.TextSize = 11
idleLine.TextColor3 = Color3.fromRGB(170, 175, 190)

local clickLine = idleLine:Clone()
clickLine.Parent = body
clickLine.Position = UDim2.new(0, 0, 0, 98)

local minusIdle = Instance.new("TextButton")
minusIdle.Parent = body
minusIdle.Size = UDim2.new(0, 28, 0, 24)
minusIdle.Position = UDim2.new(0, 0, 0, 122)
minusIdle.BackgroundColor3 = Color3.fromRGB(50, 56, 72)
minusIdle.Text = "-"
minusIdle.TextColor3 = Color3.fromRGB(230, 230, 230)
minusIdle.Font = Enum.Font.GothamBold
minusIdle.TextSize = 14
Instance.new("UICorner", minusIdle).CornerRadius = UDim.new(0, 6)

local plusIdle = minusIdle:Clone()
plusIdle.Parent = body
plusIdle.Position = UDim2.new(0, 126, 0, 122)
plusIdle.Text = "+"

local minusClick = minusIdle:Clone()
minusClick.Parent = body
minusClick.Position = UDim2.new(1, -154, 0, 122)

local plusClick = minusIdle:Clone()
plusClick.Parent = body
plusClick.Position = UDim2.new(1, -28, 0, 122)
plusClick.Text = "+"

local idleBox = Instance.new("TextLabel")
idleBox.Parent = body
idleBox.Size = UDim2.new(0, 92, 0, 24)
idleBox.Position = UDim2.new(0, 32, 0, 122)
idleBox.BackgroundColor3 = Color3.fromRGB(35, 40, 54)
idleBox.TextColor3 = Color3.fromRGB(225, 225, 225)
idleBox.Font = Enum.Font.GothamSemibold
idleBox.TextSize = 11
Instance.new("UICorner", idleBox).CornerRadius = UDim.new(0, 6)

local clickBox = idleBox:Clone()
clickBox.Parent = body
clickBox.Position = UDim2.new(1, -122, 0, 122)

local function updateUi()
    idleLine.Text = "Idle threshold: " .. tostring(idleLimit) .. "s"
    clickLine.Text = "Click interval: " .. tostring(tapDelay) .. "s"
    idleBox.Text = tostring(idleLimit) .. "s"
    clickBox.Text = tostring(tapDelay) .. "s"

    if isOn then
        toggleBtn.Text = "Anti-AFK: ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 145, 70)
    else
        toggleBtn.Text = "Anti-AFK: OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(150, 48, 48)
    end
end

toggleBtn.MouseButton1Click:Connect(function()
    isOn = not isOn
    if isOn then
        lastInputTick = tick()
        lastTapTick = tick()
    end
    updateUi()
end)

testBtn.MouseButton1Click:Connect(function()
    doFakeTap()
end)

minusIdle.MouseButton1Click:Connect(function()
    idleLimit = clampNum(idleLimit - 30, 60, 1200)
    updateUi()
end)
plusIdle.MouseButton1Click:Connect(function()
    idleLimit = clampNum(idleLimit + 30, 60, 1200)
    updateUi()
end)
minusClick.MouseButton1Click:Connect(function()
    tapDelay = clampNum(tapDelay - 10, 20, 300)
    updateUi()
end)
plusClick.MouseButton1Click:Connect(function()
    tapDelay = clampNum(tapDelay + 10, 20, 300)
    updateUi()
end)

miniBtn.MouseButton1Click:Connect(function()
    hideBody = not hideBody
    body.Visible = not hideBody
    if hideBody then
        main.Size = UDim2.new(0, 300, 0, 34)
        miniBtn.Text = "+"
    else
        main.Size = UDim2.new(0, 300, 0, 190)
        miniBtn.Text = "-"
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    root:Destroy()
end)

updateUi()

task.spawn(function()
    while root.Parent do
        task.wait(1)
        local idle = math.floor(tick() - lastInputTick)
        local ago = math.floor(tick() - lastTapTick)
        statusTxt.Text = string.format("Status: %s | Idle: %ds | Last click: %ds", isOn and "ON" or "OFF", idle, ago)
        if idle >= idleLimit then
            statusTxt.TextColor3 = Color3.fromRGB(255, 212, 92)
        else
            statusTxt.TextColor3 = Color3.fromRGB(185, 190, 205)
        end
    end
end)

task.spawn(function()
    while root.Parent do
        task.wait(loopDelay)
        if not isOn then
            continue
        end

        local idle = tick() - lastInputTick
        local sinceTap = tick() - lastTapTick

        if idle >= idleLimit and sinceTap >= tapDelay then
            doFakeTap()
        elseif idle < idleLimit and sinceTap >= idleLimit then
            doFakeTap()
        end
    end
end)
