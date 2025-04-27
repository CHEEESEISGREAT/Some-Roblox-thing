local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Variables
local flying = false
local noclip = false
local aimbotEnabled = true
local espEnabled = true
local rectangleSize = Vector2.new(100, 100)

-- Flying Variables
local flyingSpeed = 50  -- Speed of flight
local targetPlayer = nil

-- Function to enable flying
function enableFlying()
    local character = LocalPlayer.Character
    local humanoid = character:WaitForChild("Humanoid")

    -- Remove gravity effect
    humanoid.PlatformStand = true
    while flying do
        humanoid:Move(Vector3.new(0, flyingSpeed, 0))  -- Constant upward movement
        wait(0.1)  -- Update every 0.1 seconds
    end
end

-- Function to disable flying
function disableFlying()
    local character = LocalPlayer.Character
    local humanoid = character:WaitForChild("Humanoid")

    -- Re-enable gravity
    humanoid.PlatformStand = false
end

-- Function to enable noclip (move through walls)
function enableNoClip()
    local character = LocalPlayer.Character
    local humanoid = character:WaitForChild("Humanoid")
    local parts = character:GetChildren()

    -- Disable collisions for all parts
    for _, part in ipairs(parts) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    noclip = true
end

-- Function to disable noclip (restore collisions)
function disableNoClip()
    local character = LocalPlayer.Character
    local humanoid = character:WaitForChild("Humanoid")
    local parts = character:GetChildren()

    -- Restore collisions for all parts
    for _, part in ipairs(parts) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
    noclip = false
end

-- Function to enable Aimbot (lock onto enemy)
function aimbot()
    local closestEnemy = nil
    local closestDistance = math.huge  -- Start with a very large distance

    -- Find the closest enemy
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local headPosition = player.Character.Head.Position
            local distance = (Camera.CFrame.Position - headPosition).magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestEnemy = player
            end
        end
    end

    -- Lock on to the closest enemy
    if closestEnemy then
        local headPosition = closestEnemy.Character.Head.Position
        local headScreenPosition = Camera:WorldToScreenPoint(headPosition)

        -- Move the mouse to the locked-on target
        Mouse.Hit = CFrame.new(Camera.CFrame.Position, headPosition)
    end
end

-- Function to enable ESP (Extra Sensory Perception)
function esp()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local headPosition = Camera:WorldToScreenPoint(head.Position)

            -- Draw a red rectangle around the enemy player's head
            local espRect = Instance.new("Frame")
            espRect.Parent = game.CoreGui
            espRect.Position = UDim2.new(0, headPosition.X - rectangleSize.X / 2, 0, headPosition.Y - rectangleSize.Y / 2)
            espRect.Size = UDim2.new(0, rectangleSize.X, 0, rectangleSize.Y)
            espRect.BorderSizePixel = 2
            espRect.BorderColor3 = Color3.fromRGB(255, 0, 0)
            espRect.BackgroundTransparency = 1

            wait(0.2)  -- Show ESP box for 0.2 seconds
            espRect:Destroy()
        end
    end
end

-- Listen for key presses to toggle features
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end

    if input.KeyCode == Enum.KeyCode.Space then
        if not flying then
            flying = true
            enableFlying()  -- Start flying
        else
            flying = false
            disableFlying()  -- Stop flying
        end
    end

    if input.KeyCode == Enum.KeyCode.F then
        if not noclip then
            enableNoClip()  -- Start noclip
        else
            disableNoClip()  -- Stop noclip
        end
    end
end)

-- Main loop to continuously execute features
while true do
    if aimbotEnabled then
        aimbot()  -- Continuously aim at the closest enemy
    end

    if espEnabled then
        esp()  -- Continuously show ESP
    end

    wait(0.1)  -- Update every 0.1 seconds
end

