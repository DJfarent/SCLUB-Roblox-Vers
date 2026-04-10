local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))() --ui library will redo further

local Window = Rayfield:CreateWindow({
    Name = "secretservice.club",
    LoadingTitle = "secretservice.club",
    LoadingSubtitle = "Auto Chams + Tool Fixed",
    ConfigurationSaving = { Enabled = false },
})

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local headshotSound = Instance.new("Sound")
headshotSound.SoundId = "rbxassetid://4764109000"
headshotSound.Volume = 0.9
headshotSound.Parent = SoundService

local damageNotif = Instance.new("Frame")
damageNotif.Size = UDim2.new(0, 330, 0, 68)
damageNotif.Position = UDim2.new(0.5, -165, 0.32, 0)
damageNotif.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
damageNotif.Visible = false
damageNotif.Parent = player:WaitForChild("PlayerGui")
Instance.new("UICorner", damageNotif).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", damageNotif).Color = Color3.fromRGB(0, 255, 180)

local damageLabel = Instance.new("TextLabel")
damageLabel.Size = UDim2.new(1, -20, 1, 0)
damageLabel.BackgroundTransparency = 1
damageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
damageLabel.Font = Enum.Font.GothamSemibold
damageLabel.TextSize = 17
damageLabel.TextXAlignment = Enum.TextXAlignment.Center
damageLabel.Parent = damageNotif

local dragging = false
local dragStart, startPos
damageNotif.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = damageNotif.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        damageNotif.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

local lastDamageTime = 0
local function showDamageNotification(targetName, damage, isHeadshot)
    if tick() - lastDamageTime < 0.25 then return end
    lastDamageTime = tick()

    local text = string.format("Dealt %d damage to %s", damage, targetName)
    if isHeadshot then
        text = "HEADSHOT! " .. text
        headshotSound:Play()
    end

    damageLabel.Text = text
    damageNotif.Visible = true

    task.delay(3, function()
        if damageNotif.Visible then
            TweenService:Create(damageNotif, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
            TweenService:Create(damageLabel, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
            task.delay(0.7, function() damageNotif.Visible = false end)
        end
    end)
end

local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local AimbotTab = Window:CreateTab("Aimbot", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

local chamsEnabled = true
local fillColor = Color3.fromRGB(0, 255, 200)
local fillTrans = 0.5
local outlineTrans = 0
local highlights = {}

local aimFOV = 120
local aimSmoothness = 0.94
local aimPart = "Head"
local aimKey = Enum.UserInputType.MouseButton2

local hitNotificationsEnabled = false

local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 2
fovCircle.Filled = false
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Transparency = 0.7

local function updateChams()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            if chamsEnabled then
                if not highlights[plr.Character] then
                    local hl = Instance.new("Highlight")
                    hl.FillColor = fillColor
                    hl.OutlineColor = fillColor
                    hl.FillTransparency = fillTrans
                    hl.OutlineTransparency = outlineTrans
                    hl.Adornee = plr.Character
                    hl.Parent = plr.Character
                    highlights[plr.Character] = hl
                else
                    local hl = highlights[plr.Character]
                    hl.FillColor = fillColor
                    hl.OutlineColor = fillColor
                    hl.FillTransparency = fillTrans
                    hl.OutlineTransparency = outlineTrans
                end
            else
                if highlights[plr.Character] then
                    highlights[plr.Character]:Destroy()
                    highlights[plr.Character] = nil
                end
            end
        end
    end
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.5)
        updateChams()
    end)
end)

player.CharacterAdded:Connect(function()
    task.wait(1)
    updateChams()
end)

VisualsTab:CreateToggle({
    Name = "Enable Chams",
    CurrentValue = true,
    Callback = function(v)
        chamsEnabled = v
        updateChams()
        Rayfield:Notify({Title = "Chams", Content = v and "Enabled" or "Disabled", Duration = 3})
    end,
})

VisualsTab:CreateColorPicker({
    Name = "Chams Color",
    Color = Color3.fromRGB(0, 255, 200),
    Callback = function(v)
        fillColor = v
        updateChams()
    end,
})

VisualsTab:CreateSlider({Name = "Fill Transparency", Range = {0,1}, Increment = 0.05, CurrentValue = 0.5, Callback = function(v) fillTrans = v updateChams() end})
VisualsTab:CreateSlider({Name = "Outline Transparency", Range = {0,1}, Increment = 0.05, CurrentValue = 0, Callback = function(v) outlineTrans = v updateChams() end})

AimbotTab:CreateKeybind({
    Name = "Aimbot Bind (Hold)",
    CurrentKeybind = "MouseButton2",
    HoldToUse = true,
    Callback = function() end,
})

AimbotTab:CreateDropdown({
    Name = "Aim Part",
    Options = {"Head", "Torso"},
    CurrentOption = {"Head"},
    Callback = function(opt)
        aimPart = (opt[1] == "Torso") and "HumanoidRootPart" or "Head"
    end,
})

AimbotTab:CreateSlider({Name = "FOV", Range = {30,300}, Increment = 1, CurrentValue = 120, Callback = function(v) aimFOV = v end})
AimbotTab:CreateSlider({Name = "Smoothness (Stiffness)", Range = {0.8,1}, Increment = 0.01, CurrentValue = 0.94, Callback = function(v) aimSmoothness = v end})

PlayerTab:CreateSlider({Name = "Field of View", Range = {20,120}, Increment = 1, CurrentValue = 70, Callback = function(v) camera.FieldOfView = v end})

MiscTab:CreateToggle({
    Name = "Hit Notifications",
    CurrentValue = false,
    Callback = function(v)
        hitNotificationsEnabled = v
        Rayfield:Notify({Title = "Hit Notifications", Content = v and "Enabled" or "Disabled", Duration = 4})
    end,
})

local lastHealthTable = {}
RunService.Heartbeat:Connect(function()
    if not hitNotificationsEnabled then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local hum = plr.Character:FindFirstChild("Humanoid")
            if hum then
                local current = hum.Health
                local prev = lastHealthTable[hum] or current
                if current < prev - 0.1 then
                    local damage = math.floor(prev - current)
                    if damage > 0 then
                        showDamageNotification(plr.Name, damage, damage >= 25)
                    end
                end
                lastHealthTable[hum] = current
            end
        end
    end
end)

local isHoldingAim = false

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == aimKey or input.KeyCode == aimKey then
        isHoldingAim = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == aimKey or input.KeyCode == aimKey then
        isHoldingAim = false
    end
end)

RunService:BindToRenderStep("Aimbot", Enum.RenderPriority.Camera.Value + 1, function()
    fovCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    fovCircle.Radius = aimFOV
    fovCircle.Visible = isHoldingAim

    if isHoldingAim then
        local closest, dist = nil, aimFOV
        local mousePos = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild(aimPart) then
                local pos, onScreen = camera:WorldToViewportPoint(plr.Character[aimPart].Position)
                if onScreen then
                    local d = (mousePos - Vector2.new(pos.X, pos.Y)).Magnitude
                    if d < dist then
                        dist = d
                        closest = plr.Character
                    end
                end
            end
        end

        if closest and closest:FindFirstChild(aimPart) then
            local cf = camera.CFrame
            camera.CFrame = cf:Lerp(CFrame.lookAt(cf.Position, closest[aimPart].Position), aimSmoothness)
        end
    end
end)

Rayfield:Notify({
    Title = "Secretservice.club",
    Content = "Enjoy Beating the Competition!",
    Duration = 7,
})

print("secretservice.club loaded")

--created with the help of Roblox Wiki and stack 