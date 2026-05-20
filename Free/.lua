local p = game:GetService("Players")
local v = game:GetService("VirtualUser")
local i = game:GetService("UserInputService")

local lp = p.LocalPlayer
local g = lp:WaitForChild("PlayerGui")

local n = "DacCau AntiAFK"
local idleNeed = 300
local clickNeed = 60
local loopWait = 5

local on = false
local lastIn = tick()
local lastClick = tick()

local function T()
    return tick()
end

pcall(function()
    for _, c in ipairs(getconnections(lp.Idled)) do
        pcall(function()
            c:Disable()
        end)
    end
end)

local function touch()
    lastIn = T()
end

i.InputBegan:Connect(function()
    touch()
end)

i.InputChanged:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseMovement then
        touch()
    elseif inp.UserInputType == Enum.UserInputType.Gamepad1 then
        touch()
    end
end)

local function fakeClick()
    local cam = workspace.CurrentCamera
    if not cam then
        return
    end
    v:Button2Down(Vector2.new(0, 0), cam.CFrame)
    task.wait(0.1)
    v:Button2Up(Vector2.new(0, 0), cam.CFrame)
    lastClick = T()
end

if g:FindFirstChild(n) then
    g[n]:Destroy()
end

local s = Instance.new("ScreenGui")
s.Name = n
s.ResetOnSpawn = false
s.Parent = g

local u = Instance.new("Frame")
u.Size = UDim2.new(0, 240, 0, 130)
u.Position = UDim2.new(0.5, -120, 0.16, 0)
u.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
u.BorderSizePixel = 0
u.Active = true
u.Draggable = true
u.Parent = s

local uc = Instance.new("UICorner")
uc.CornerRadius = UDim.new(0, 10)
uc.Parent = u

local t = Instance.new("TextLabel")
t.Size = UDim2.new(1, 0, 0, 30)
t.BackgroundTransparency = 1
t.Text = "Anti AFK"
t.TextColor3 = Color3.fromRGB(120, 255, 170)
t.Font = Enum.Font.GothamBold
t.TextSize = 15
t.Parent = u

local st = Instance.new("TextLabel")
st.Size = UDim2.new(1, -12, 0, 22)
st.Position = UDim2.new(0, 6, 0, 30)
st.BackgroundTransparency = 1
st.Text = "Idle: 0s | Click: 0s"
st.TextColor3 = Color3.fromRGB(180, 180, 180)
st.Font = Enum.Font.Gotham
st.TextSize = 11
st.Parent = u

local b = Instance.new("TextButton")
b.Size = UDim2.new(0.86, 0, 0, 36)
b.Position = UDim2.new(0.07, 0, 0, 58)
b.BackgroundColor3 = Color3.fromRGB(170, 35, 35)
b.Text = "Anti AFK: OFF"
b.TextColor3 = Color3.fromRGB(255, 255, 255)
b.Font = Enum.Font.GothamBold
b.TextSize = 14
b.Parent = u

local bc = Instance.new("UICorner")
bc.CornerRadius = UDim.new(0, 8)
bc.Parent = b

local d = Instance.new("TextLabel")
d.Size = UDim2.new(1, -12, 0, 20)
d.Position = UDim2.new(0, 6, 0, 102)
d.BackgroundTransparency = 1
d.Text = "Idle 5 phut, click moi 60s"
d.TextColor3 = Color3.fromRGB(120, 120, 120)
d.Font = Enum.Font.Gotham
d.TextSize = 10
d.Parent = u

local function setOn(x)
    on = x
    if x then
        b.Text = "Anti AFK: ON"
        b.BackgroundColor3 = Color3.fromRGB(35, 160, 70)
        lastIn = T()
        lastClick = T()
    else
        b.Text = "Anti AFK: OFF"
        b.BackgroundColor3 = Color3.fromRGB(170, 35, 35)
    end
end

b.MouseButton1Click:Connect(function()
    setOn(not on)
end)

task.spawn(function()
    while s.Parent do
        task.wait(1)
        local idle = math.floor(T() - lastIn)
        local ago = math.floor(T() - lastClick)
        st.Text = string.format("Idle: %ds | Click: %ds", idle, ago)
        if idle >= idleNeed then
            st.TextColor3 = Color3.fromRGB(255, 210, 80)
        else
            st.TextColor3 = Color3.fromRGB(140, 220, 140)
        end
    end
end)

task.spawn(function()
    while s.Parent do
        task.wait(loopWait)
        if not on then
            continue
        end

        local idle = T() - lastIn
        local ago = T() - lastClick

        if idle >= idleNeed and ago >= clickNeed then
            fakeClick()
        elseif idle < idleNeed and ago >= idleNeed then
            fakeClick()
        end
    end
end)

setOn(true)
