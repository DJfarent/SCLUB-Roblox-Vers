local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "secretservice.club",
    LoadingTitle = "secretservice.club",
    LoadingSubtitle = "For Criminality 1.0!",
    ConfigurationSaving = { Enabled = false },
})

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local rustHitSound = Instance.new("Sound")
rustHitSound.SoundId = "rbxassetid://4764109000"
rustHitSound.Volume = 0.4
rustHitSound.Parent = SoundService

local chamsEnabled = true
local chamsColor = Color3.fromRGB(0, 255, 200)
local chamsFillTrans = 0.5
local chamsOutlineTrans = 0
local nameESPEnabled = false

local customFOV = 70
local hitNotificationsEnabled = false
local hitsoundVolume = 0.4

local isHoldingAim = false
local aimFOV = 120
local aimSmoothness = 0.93
local aimPart = "Head"
local predictionEnabled = false

local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 2
fovCircle.Filled = false
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Transparency = 0.7

local playerHighlights = {}
local nameLabels = {}

local function updatePlayerChams()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            if chamsEnabled then
                if not playerHighlights[plr.Character] then
                    local hl = Instance.new("Highlight")
                    hl.FillColor = chamsColor
                    hl.OutlineColor = chamsColor
                    hl.FillTransparency = chamsFillTrans
                    hl.OutlineTransparency = chamsOutlineTrans
                    hl.Adornee = plr.Character
                    hl.Parent = plr.Character
                    playerHighlights[plr.Character] = hl
                else
                    local hl = playerHighlights[plr.Character]
                    hl.FillColor = chamsColor
                    hl.OutlineColor = chamsColor
                    hl.FillTransparency = chamsFillTrans
                    hl.OutlineTransparency = chamsOutlineTrans
                end
            else
                if playerHighlights[plr.Character] then
                    playerHighlights[plr.Character]:Destroy()
                    playerHighlights[plr.Character] = nil
                end
            end
        end
    end
end

local function updateNameESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
            if nameESPEnabled then
                if not nameLabels[plr] then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Adornee = plr.Character.Head
                    billboard.Size = UDim2.new(0, 200, 0, 50)
                    billboard.StudsOffset = Vector3.new(0, 2, 0)
                    billboard.AlwaysOnTop = true
                    billboard.Parent = plr.Character

                    local text = Instance.new("TextLabel")
                    text.Size = UDim2.new(1, 0, 1, 0)
                    text.BackgroundTransparency = 1
                    text.Text = plr.Name
                    text.TextColor3 = Color3.fromRGB(255, 255, 255)
                    text.TextStrokeTransparency = 0
                    text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    text.Font = Enum.Font.GothamBold
                    text.TextSize = 14
                    text.Parent = billboard

                    nameLabels[plr] = billboard
                end
            else
                if nameLabels[plr] then
                    nameLabels[plr]:Destroy()
                    nameLabels[plr] = nil
                end
            end
        end
    end
end

local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)
local AimbotTab = Window:CreateTab("Aimbot", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

VisualsTab:CreateToggle({
    Name = "Enable Player Chams",
    CurrentValue = true,
    Callback = function(v) chamsEnabled = v end,
})

VisualsTab:CreateColorPicker({
    Name = "Chams Color",
    Color = Color3.fromRGB(0, 255, 200),
    Callback = function(v) chamsColor = v end,
})

VisualsTab:CreateSlider({
    Name = "Fill Transparency",
    Range = {0, 1},
    Increment = 0.05,
    CurrentValue = 0.5,
    Callback = function(v) chamsFillTrans = v end,
})

VisualsTab:CreateSlider({
    Name = "Outline Transparency",
    Range = {0, 1},
    Increment = 0.05,
    CurrentValue = 0,
    Callback = function(v) chamsOutlineTrans = v end,
})

VisualsTab:CreateToggle({
    Name = "Show Player Names",
    CurrentValue = false,
    Callback = function(v) nameESPEnabled = v end,
})

PlayerTab:CreateSlider({
    Name = "Custom FOV",
    Range = {20, 120},
    Increment = 1,
    CurrentValue = 70,
    Callback = function(v) customFOV = v end,
})

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

AimbotTab:CreateSlider({
    Name = "FOV",
    Range = {30, 300},
    Increment = 1,
    CurrentValue = 120,
    Callback = function(v) aimFOV = v end,
})

AimbotTab:CreateSlider({
    Name = "Smoothness",
    Range = {0.8, 1},
    Increment = 0.01,
    CurrentValue = 0.93,
    Callback = function(v) aimSmoothness = v end,
})

AimbotTab:CreateToggle({
    Name = "Prediction",
    CurrentValue = false,
    Callback = function(v) predictionEnabled = v end,
})

MiscTab:CreateToggle({
    Name = "Hit Notifications",
    CurrentValue = false,
    Callback = function(v) hitNotificationsEnabled = v end,
})

MiscTab:CreateSlider({
    Name = "Hitsound Volume",
    Range = {0, 1},
    Increment = 0.05,
    CurrentValue = 0.4,
    Callback = function(v) rustHitSound.Volume = v end,
})

RunService.Heartbeat:Connect(function()
    updatePlayerChams()
    updateNameESP()
end)

RunService.RenderStepped:Connect(function()
    if camera.FieldOfView ~= customFOV then
        camera.FieldOfView = customFOV
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
                local targetPos = plr.Character[aimPart].Position
                if predictionEnabled then
                    local vel = plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.HumanoidRootPart.Velocity or Vector3.new()
                    targetPos = targetPos + vel * 0.065
                end
                local pos, onScreen = camera:WorldToViewportPoint(targetPos)
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
            local targetPos = closest[aimPart].Position
            if predictionEnabled then
                local vel = closest:FindFirstChild("HumanoidRootPart") and closest.HumanoidRootPart.Velocity or Vector3.new()
                targetPos = targetPos + vel * 0.065
            end
            camera.CFrame = cf:Lerp(CFrame.lookAt(cf.Position, targetPos), aimSmoothness)
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isHoldingAim = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isHoldingAim = false
    end
end)

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
                        local tool = player.Character and player.Character:FindFirstChildWhichIsA("Tool")
                        if tool then
                            local msg = string.format("Dealt %d damage to %s", damage, plr.Name)
                            rustHitSound:Play()
                            Rayfield:Notify({
                                Title = "Damage",
                                Content = msg,
                                Duration = 3,
                            })
                        end
                    end
                end
                lastHealthTable[hum] = current
            end
        end
    end
end)

Rayfield:Notify({
    Title = "secretservice.club",
    Content = "Beat Them!.",
    Duration = 5,
})