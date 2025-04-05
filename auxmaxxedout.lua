-- 🚀 Aux Hacks UI: Fly + Speed + Gravity
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

-- UI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 220)
mainFrame.Position = UDim2.new(0.4, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 2
mainFrame.Parent = screenGui

-- Title Label (Draggable)
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.Text = "Aux Hacks"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 120)
titleLabel.Parent = mainFrame

-- Button Function
local function createButton(text, position, color)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 35)
    button.Position = UDim2.new(0, 0, 0, position)
    button.Text = text
    button.Font = Enum.Font.Gotham
    button.TextSize = 16
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = color
    button.Parent = mainFrame
    return button
end

-- Fly Button
local flyButton = createButton("Fly", 35, Color3.fromRGB(70, 70, 200))
local speedButton = createButton("Speed", 70, Color3.fromRGB(50, 150, 50))

-- Gravity Label
local gravityLabel = Instance.new("TextLabel")
gravityLabel.Size = UDim2.new(1, 0, 0, 35)
gravityLabel.Position = UDim2.new(0, 0, 0, 105)
gravityLabel.Text = "Gravity: 196.2"
gravityLabel.Font = Enum.Font.GothamBold
gravityLabel.TextSize = 16
gravityLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
gravityLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
gravityLabel.Parent = mainFrame

-- Gravity Input Box
local gravityInput = Instance.new("TextBox")
gravityInput.Size = UDim2.new(1, 0, 0, 35)
gravityInput.Position = UDim2.new(0, 0, 0, 140)
gravityInput.Text = "196.2"
gravityInput.Font = Enum.Font.Gotham
gravityInput.TextSize = 16
gravityInput.TextColor3 = Color3.fromRGB(255, 255, 255)
gravityInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
gravityInput.Parent = mainFrame

-- Apply Gravity Button
local applyGravityButton = createButton("Apply Gravity", 175, Color3.fromRGB(50, 100, 50))

-- 🛫 **Fly Variables**
local flying = false
local flySpeed = 200
local bodyVelocity

-- Movement Input Tracking
local movement = {W=false, A=false, S=false, D=false, Space=false, Shift=false}

-- Update Movement Inputs
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.W then movement.W = true end
    if input.KeyCode == Enum.KeyCode.A then movement.A = true end
    if input.KeyCode == Enum.KeyCode.S then movement.S = true end
    if input.KeyCode == Enum.KeyCode.D then movement.D = true end
    if input.KeyCode == Enum.KeyCode.Space then movement.Space = true end
    if input.KeyCode == Enum.KeyCode.LeftShift then movement.Shift = true end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then movement.W = false end
    if input.KeyCode == Enum.KeyCode.A then movement.A = false end
    if input.KeyCode == Enum.KeyCode.S then movement.S = false end
    if input.KeyCode == Enum.KeyCode.D then movement.D = false end
    if input.KeyCode == Enum.KeyCode.Space then movement.Space = false end
    if input.KeyCode == Enum.KeyCode.LeftShift then movement.Shift = false end
end)

-- 🛫 **Start Flying**
local function startFlying()
    workspace.Gravity = 0
    humanoid.PlatformStand = true

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
    bodyVelocity.Parent = rootPart

    game:GetService("RunService").RenderStepped:Connect(function()
        if flying then
            local direction = Vector3.new(0, 0, 0)
            local look = camera.CFrame.LookVector
            local right = camera.CFrame.RightVector
            local up = camera.CFrame.UpVector
            local moving = false

            if movement.W then direction = direction + (look * flySpeed) moving = true end
            if movement.S then direction = direction - (look * flySpeed) moving = true end
            if movement.A then direction = direction - (right * flySpeed) moving = true end
            if movement.D then direction = direction + (right * flySpeed) moving = true end
            if movement.Space then direction = direction + (up * flySpeed) moving = true end
            if movement.Shift then direction = direction - (up * flySpeed) moving = true end

            bodyVelocity.Velocity = moving and direction or Vector3.new(0, 0, 0)
        end
    end)
end

-- 🛬 **Stop Flying**
local function stopFlying()
    workspace.Gravity = tonumber(gravityInput.Text) or 196.2
    humanoid.PlatformStand = false
    if bodyVelocity then bodyVelocity:Destroy() end
end

-- 🛫 **Toggle Fly**
local function toggleFly()
    flying = not flying
    flyButton.Text = flying and "Disable Fly" or "Fly"
    if flying then startFlying() else stopFlying() end
end

flyButton.MouseButton1Click:Connect(toggleFly)

-- 🚀 Speed Boost Toggle
local speedBoost = false
speedButton.MouseButton1Click:Connect(function()
    speedBoost = not speedBoost
    speedButton.Text = speedBoost and "Disable Speed" or "Speed"
    humanoid.WalkSpeed = speedBoost and 75 or 16
end)

-- 🌍 Apply Gravity Change
applyGravityButton.MouseButton1Click:Connect(function()
    local newGravity = tonumber(gravityInput.Text)
    if newGravity then
        workspace.Gravity = newGravity
        gravityLabel.Text = "Gravity: " .. newGravity
    else
        gravityInput.Text = "Invalid Input"
    end
end)

-- 🔄 **Make UI Draggable**
local dragging, start, startPos
titleLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        start = input.Position
        startPos = mainFrame.Position
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - start
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)