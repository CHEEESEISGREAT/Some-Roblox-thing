local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Variables
local targetPlayer = nil
local targetHead = nil
local rectangleSize = Vector2.new(100, 100)  -- Size of the rectangle (adjust as needed)

-- Function to find the player's head
function findPlayerHead(player)
    -- Find the player's head part
    local character = player.Character
    if character then
        local head = character:FindFirstChild("Head")
        if head then
            return head
        end
    end
    return nil
end

-- Function to draw a red rectangle around the head
function drawRedRectangle(head)
    -- Get the head's position on screen
    local headPosition = Camera:WorldToScreenPoint(head.Position)
    
    -- Draw a red rectangle around the head on the screen (this part uses GUI elements)
    local headRect = Instance.new("Frame")
    headRect.Parent = game.CoreGui
    headRect.Position = UDim2.new(0, headPosition.X - rectangleSize.X / 2, 0, headPosition.Y - rectangleSize.Y / 2)
    headRect.Size = UDim2.new(0, rectangleSize.X, 0, rectangleSize.Y)
    headRect.BorderSizePixel = 2
    headRect.BorderColor3 = Color3.fromRGB(255, 0, 0)  -- Red border
    headRect.BackgroundTransparency = 1  -- Make the background transparent

    -- Make the rectangle disappear after a short time
    wait(0.2)
    headRect:Destroy()
end

-- Function to snap the crosshair to the player's head
function snapCrosshairToHead(head)
    -- Get the head's position and snap the crosshair to it
    local headPosition = Camera:WorldToScreenPoint(head.Position)
    Mouse.Move:Connect(function()
        Mouse.Hit = CFrame.new(Camera.CFrame.Position,
Vector3.new(headPosition.X, headPosition.Y, Camera.CFrame.Position.Z))
    end)
end

-- Function to handle the "J" key press
function onKeyPress(input)
    if input.KeyCode == Enum.KeyCode.J then
        -- Check if the target player is valid
        if targetPlayer and targetHead then
            -- Draw the red rectangle around the head
            drawRedRectangle(targetHead)

            -- Snap the crosshair to the head's position
            snapCrosshairToHead(targetHead)
        end
    end
end

-- Main loop: Check for the player's head and listen for the "J" key press
UserInputService.InputBegan:Connect(onKeyPress)

-- Continuously check for the player's head
while true do
    -- Find the player's head
    targetPlayer = Players:GetPlayers()[math.random(1, #Players:GetPlayers())] -- Replace this with actual player detection logic
    if targetPlayer then
        targetHead = findPlayerHead(targetPlayer)
    end
    wait(1)  -- Update the target every second
end
