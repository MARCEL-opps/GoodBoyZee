-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- Configurations
local CONFIG = {
    PARTICLE_COUNT = 20,
    PARTICLE_SPEED = 1.5
}

-- Users who get the special tag
local TARGET_USERNAMES = {
    ["PookiePepelssz"] = true,
    ["BAN1ZZ3"] = true
}

-- Particle effect generator
local function createParticles(tag, parent, accentColor)
    for i = 1, CONFIG.PARTICLE_COUNT do
        local particle = Instance.new("Frame")
        particle.Name = "Particle_" .. i
        particle.Size = UDim2.new(0, math.random(1, 6), 0, math.random(1, 6))
        particle.Position = UDim2.new(math.random(), math.random(-10, 10), 1 + math.random() * 0.5, 0)
        particle.BackgroundColor3 = accentColor
        particle.BackgroundTransparency = math.random(0, 0.4)
        particle.BorderSizePixel = 0

        local pCorner = Instance.new("UICorner")
        pCorner.CornerRadius = UDim.new(1, 10)
        pCorner.Parent = particle

        particle.Parent = parent

        task.spawn(function()
            while tag and tag.Parent do
                local startX = math.random()
                local startOffsetX = math.random(-10, 10)
                particle.Position = UDim2.new(startX, startOffsetX, 1 + math.random() * 0.5, 0)
                particle.Size = UDim2.new(0, math.random(1, 6), 0, math.random(1, 6))
                particle.BackgroundTransparency = math.random(0, 0.4)

                local duration = math.random(10, 40) / (CONFIG.PARTICLE_SPEED * 10)
                local endX = startX + (math.random() - 0.5) * 0.3
                local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)

                local tween = TweenService:Create(particle, tweenInfo, {
                    Position = UDim2.new(endX, startOffsetX, -0.5, math.random(-20, 20)),
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 0)
                })
                tween:Play()
                task.wait(math.random(20, 40) / (CONFIG.PARTICLE_SPEED * 10))
            end
        end)
    end
end

-- Name tag creator
local function createBillboardGui(character)
    local head = character:FindFirstChild("Head")
    if not head or head:FindFirstChild("SentinelBillboard") then return end

    local billboardGui = Instance.new("BillboardGui", head)
    billboardGui.Name = "SentinelBillboard"
    billboardGui.Active = true
    billboardGui.MaxDistance = 50
    billboardGui.ExtentsOffsetWorldSpace = Vector3.new(0, 4, 0)
    billboardGui.Size = UDim2.new(0, 180, 0, 50)
    billboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local frame = Instance.new("Frame", billboardGui)
    frame.BorderSizePixel = 0
    frame.BackgroundColor3 = Color3.fromRGB(69, 69, 69)
    frame.Size = UDim2.new(0, 170, 0, 42)
    frame.Position = UDim2.new(0, 5, 0, 5)

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

    local stroke = Instance.new("UIStroke", frame)
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Thickness = 1.2
    stroke.Color = Color3.fromRGB(255, 171, 0)

    local nameLabel = Instance.new("TextLabel", frame)
    nameLabel.Text = "Sentinel Owner"
    nameLabel.TextWrapped = true
    nameLabel.BorderSizePixel = 0
    nameLabel.TextSize = 16
    nameLabel.BackgroundTransparency = 1
    nameLabel.FontFace = Font.new([[rbxassetid://12187365977]], Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.Size = UDim2.new(0, 170, 0, 42)
    nameLabel.Position = UDim2.new(0, 10, 0, -1.3)

    local crownLabel = Instance.new("TextLabel", frame)
    crownLabel.Text = "👑"
    crownLabel.BorderSizePixel = 0
    crownLabel.TextSize = 20
    crownLabel.BackgroundTransparency = 1
    crownLabel.FontFace = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    crownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    crownLabel.Size = UDim2.new(0, 45, 0, 40)
    crownLabel.Position = UDim2.new(0, 2, 0, 0)

    local shadowHolder = Instance.new("Frame", frame)
    shadowHolder.ZIndex = 0
    shadowHolder.Size = UDim2.new(1, 0, 1, 0)
    shadowHolder.Position = UDim2.new(0, 0, -0.05, 0)
    shadowHolder.Name = "shadowHolder"
    shadowHolder.BackgroundTransparency = 1

    local function addShadow(name, transparency)
        local shadow = Instance.new("ImageLabel", shadowHolder)
        shadow.Name = name
        shadow.ZIndex = 0
        shadow.SliceCenter = Rect.new(10, 10, 118, 118)
        shadow.ScaleType = Enum.ScaleType.Slice
        shadow.ImageTransparency = transparency
        shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        shadow.AnchorPoint = Vector2.new(0.5, 0.5)
        shadow.Image = "rbxassetid://1316045217"
        shadow.Size = UDim2.new(1, 3, 1, 3)
        shadow.BackgroundTransparency = 1
        shadow.Position = UDim2.new(0.5, 0, 0.5, 2)
    end

    addShadow("umbraShadow", 0.86)
    addShadow("penumbraShadow", 0.88)
    addShadow("ambientShadow", 0.88)

    createParticles(frame, frame, Color3.fromRGB(255, 171, 0))
end

-- Monitor player spawn
local function monitorPlayer(player)
    if TARGET_USERNAMES[player.Name] then
        player.CharacterAdded:Connect(createBillboardGui)
        if player.Character then
            createBillboardGui(player.Character)
        end
    end
end

-- Initial players
for _, player in ipairs(Players:GetPlayers()) do
    monitorPlayer(player)
end

-- New players
Players.PlayerAdded:Connect(monitorPlayer)

-- Periodic check for safety
task.spawn(function()
    while true do
        for name in pairs(TARGET_USERNAMES) do
            local player = Players:FindFirstChild(name)
            if player and player.Character then
                createBillboardGui(player.Character)
            end
        end
        task.wait(1)
    end
end)
