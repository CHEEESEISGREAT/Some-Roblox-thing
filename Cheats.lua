-- Variables
local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local isFlying = false
local isAimbotActive = false

-- Flight Variables
local flightSpeed = 50  -- Speed of flight
local flightHeight = 10  -- Height the player can fly at

-- Aimbot Variables
local aimbotFOV = 50  -- Field of view to target enemies
local aimbotSmoothness = 0.1  -- Smoothness of aiming

-- Function to Toggle Flight
local function toggleFlight()
    isFlying = not isFlying
    if isFlying then
        -- Set player's humanoid to non-collidable
        player.Character.Humanoid.PlatformStand = true
    else
        -- Re-enable platform stand
        player.Character.Humanoid.PlatformStand = false
    end
end

-- Function to Toggle Aimbot
local function toggleAimbot()
    isAimbotActive = not isAimbotActive
end

-- Aimbot Functionality
local function aimbot(target)
    if target then
        -- Smoothly adjust aim towards the target
        local direction = (target.Position - player.Character.HumanoidRootPart.Position).unit
        player.Character.HumanoidRootPart.CFrame = CFrame.lookAt(player.Character.HumanoidRootPart.Position, target.Position) * CFrame.new(0, 0, aimbotSmoothness)
    end
end

-- Flight Functionality
local function handleFlight()
    if isFlying then
        local camera = game.Workspace.CurrentCamera
        local velocity = camera.CFrame.LookVector * flightSpeed
        player.Character.HumanoidRootPart.Velocity = velocity
    end
end

-- Find Closest Target for Aimbot
local function findClosestTarget()
    local closestTarget = nil
    local closestDistance = aimbotFOV

    -- Find the closest enemy in the game
    for _, enemy in pairs(game.Workspace:GetChildren()) do
        if enemy:IsA("Model") and enemy.Name == "Enemy" then
            local distance = (player.Character.HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestTarget = enemy
            end
        end
    end

    return closestTarget
end

-- Toggle flight and aimbot on "J" key press
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.J then
        toggleFlight()
        toggleAimbot()
    end
end)

-- Main Loop
runService.Heartbeat:Connect(function()
    -- Handle flight if it's active
    handleFlight()

    -- Handle aimbot if it's active
    if isAimbotActive then
        local target = findClosestTarget()
        aimbot(target)
    end
end)
