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
local playerNameSize = 14

local selfChamsEnabled = false
local selfChamsColor = Color3.fromRGB(0, 255, 200)
local selfFillTrans = 1
local selfOutlineTrans = 1

local customFOV = 70
local hitNotificationsEnabled = false

local worldESPEnabled = false
local worldRegistersEnabled = true
local worldSafesEnabled = true
local worldSupplyCratesEnabled = true
local worldDealersEnabled = true
local worldSpawnedPilesEnabled = true
local worldRenderDistance = 250
local worldFillTrans = 0.5
local worldOutlineTrans = 0
local worldNameEnabled = true
local worldNameSize = 13

local aimbotEnabled = false
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
local selfHighlight = nil
local nameLabels = {}
local worldLabels = {}

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

local function updateSelfChams()
    if selfChamsEnabled and player.Character then
        if not selfHighlight then
            selfHighlight = Instance.new("Highlight")
            selfHighlight.FillColor = selfChamsColor
            selfHighlight.OutlineColor = selfChamsColor
            selfHighlight.FillTransparency = selfFillTrans
            selfHighlight.OutlineTransparency = selfOutlineTrans
            selfHighlight.Adornee = player.Character
            selfHighlight.Parent = player.Character
        else
            selfHighlight.FillColor = selfChamsColor
            selfHighlight.OutlineColor = selfChamsColor
            selfHighlight.FillTransparency = selfFillTrans
            selfHighlight.OutlineTransparency = selfOutlineTrans
        end
    else
        if selfHighlight then
            selfHighlight:Destroy()
            selfHighlight = nil
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
                    text.TextSize = playerNameSize
                    text.Parent = billboard

                    nameLabels[plr] = billboard
                else
                    nameLabels[plr].TextLabel.TextSize = playerNameSize
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

local function updateWorldESP()
    for _, v in pairs(worldLabels) do
        if v[1] then v[1]:Destroy() end
        if v[2] then v[2]:Destroy() end
    end
    worldLabels = {}

    if not worldESPEnabled then return end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local name = obj.Name
            local enabled = false
            local color = nil

            if name:find("Register") and worldRegistersEnabled then
                enabled = true
                color = Color3.fromRGB(255, 60, 60)
            elseif (name:find("SmallSafe") or name:find("MediumSafe")) and worldSafesEnabled then
                enabled = true
                color = Color3.fromRGB(60, 120, 255)
            elseif name:find("SupplyCrate") and worldSupplyCratesEnabled then
                enabled = true
                color = Color3.fromRGB(255, 220, 60)
            elseif (name:find("Dealer") or name:find("ArmoryDealer") or name:find("DealerMan")) and worldDealersEnabled then
                enabled = true
                color = Color3.fromRGB(180, 60, 255)
            elseif (name == "SpawnedPiles" or name == "S1" or name == "S2") and worldSpawnedPilesEnabled then
                enabled = true
                color = Color3.fromRGB(200, 200, 200)
            end

            if enabled then
                local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("PrimaryPart") or obj:FindFirstChildWhichIsA("BasePart")
                if root then
                    local dist = (root.Position - camera.CFrame.Position).Magnitude
                    if dist <= worldRenderDistance then
                        local hl = Instance.new("Highlight")
                        hl.FillColor = color
                        hl.OutlineColor = color
                        hl.FillTransparency = worldFillTrans
                        hl.OutlineTransparency = worldOutlineTrans
                        hl.Adornee = obj
                        hl.Parent = obj

                        local billboard = nil
                        if worldNameEnabled then
                            billboard = Instance.new("BillboardGui")
                            billboard.Adornee = root
                            billboard.Size = UDim2.new(0, 180, 0, 40)
                            billboard.StudsOffset = Vector3.new(0, 3, 0)
                            billboard.AlwaysOnTop = true
                            billboard.Parent = obj

                            local text = Instance.new("TextLabel")
                            text.Size = UDim2.new(1, 0, 1, 0)
                            text.BackgroundTransparency = 1
                            text.Text = name
                            text.TextColor3 = color
                            text.TextStrokeTransparency = 0
                            text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                            text.Font = Enum.Font.GothamBold
                            text.TextSize = worldNameSize
                            text.Parent = billboard
                        end

                        worldLabels[obj] = {hl, billboard}
                    end
                end
            end
        end
    end
end

local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local AimbotTab = Window:CreateTab("Aimbot", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)
local WorldTab = Window:CreateTab("World (W.I.P)", 4483362458)
local RageTab = Window:CreateTab("Rage", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

VisualsTab:CreateToggle({ Name = "Enable Player Chams", CurrentValue = true, Callback = function(v) chamsEnabled = v end })
VisualsTab:CreateColorPicker({ Name = "Chams Color", Color = Color3.fromRGB(0, 255, 200), Callback = function(v) chamsColor = v end })
VisualsTab:CreateSlider({ Name = "Fill Transparency", Range = {0, 1}, Increment = 0.05, CurrentValue = 0.5, Callback = function(v) chamsFillTrans = v end })
VisualsTab:CreateSlider({ Name = "Outline Transparency", Range = {0, 1}, Increment = 0.05, CurrentValue = 0, Callback = function(v) chamsOutlineTrans = v end })
VisualsTab:CreateToggle({ Name = "Show Player Names", CurrentValue = false, Callback = function(v) nameESPEnabled = v end })
VisualsTab:CreateSlider({ Name = "Player Name Size", Range = {8, 24}, Increment = 1, CurrentValue = 14, Callback = function(v) playerNameSize = v end })

PlayerTab:CreateToggle({ Name = "Enable Self Chams", CurrentValue = false, Callback = function(v) selfChamsEnabled = v end })
PlayerTab:CreateColorPicker({ Name = "Self Chams Color", Color = Color3.fromRGB(0, 255, 200), Callback = function(v) selfChamsColor = v end })
PlayerTab:CreateSlider({ Name = "Self Fill Transparency", Range = {0, 1}, Increment = 0.05, CurrentValue = 1, Callback = function(v) selfFillTrans = v end })
PlayerTab:CreateSlider({ Name = "Self Outline Transparency", Range = {0, 1}, Increment = 0.05, CurrentValue = 1, Callback = function(v) selfOutlineTrans = v end })
PlayerTab:CreateSlider({ Name = "Custom FOV", Range = {20, 120}, Increment = 1, CurrentValue = 70, Callback = function(v) customFOV = v end })

AimbotTab:CreateToggle({ Name = "Enable Aimbot", CurrentValue = false, Callback = function(v) aimbotEnabled = v end })
AimbotTab:CreateKeybind({ Name = "Aimbot Bind (Hold)", CurrentKeybind = "MouseButton2", HoldToUse = true, Callback = function() end })
AimbotTab:CreateDropdown({ Name = "Aim Part", Options = {"Head", "Torso"}, CurrentOption = {"Head"}, Callback = function(opt) aimPart = (opt[1] == "Torso") and "HumanoidRootPart" or "Head" end })
AimbotTab:CreateSlider({ Name = "FOV", Range = {30, 300}, Increment = 1, CurrentValue = 120, Callback = function(v) aimFOV = v end })
AimbotTab:CreateSlider({ Name = "Smoothness", Range = {0.8, 1}, Increment = 0.01, CurrentValue = 0.93, Callback = function(v) aimSmoothness = v end })
AimbotTab:CreateToggle({ Name = "Prediction", CurrentValue = false, Callback = function(v) predictionEnabled = v end })

WorldTab:CreateToggle({ Name = "Enable World ESP (Master)", CurrentValue = false, Callback = function(v) worldESPEnabled = v end })
WorldTab:CreateToggle({ Name = "Registers", CurrentValue = true, Callback = function(v) worldRegistersEnabled = v end })
WorldTab:CreateToggle({ Name = "Safes", CurrentValue = true, Callback = function(v) worldSafesEnabled = v end })
WorldTab:CreateToggle({ Name = "Supply Crates", CurrentValue = true, Callback = function(v) worldSupplyCratesEnabled = v end })
WorldTab:CreateToggle({ Name = "Dealers", CurrentValue = true, Callback = function(v) worldDealersEnabled = v end })
WorldTab:CreateToggle({ Name = "SpawnedPiles (S1/S2)", CurrentValue = true, Callback = function(v) worldSpawnedPilesEnabled = v end })
WorldTab:CreateSlider({ Name = "Render Distance", Range = {50, 400}, Increment = 10, CurrentValue = 250, Callback = function(v) worldRenderDistance = v end })
WorldTab:CreateSlider({ Name = "World Fill Transparency", Range = {0, 1}, Increment = 0.05, CurrentValue = 0.5, Callback = function(v) worldFillTrans = v end })
WorldTab:CreateSlider({ Name = "World Outline Transparency", Range = {0, 1}, Increment = 0.05, CurrentValue = 0, Callback = function(v) worldOutlineTrans = v end })
WorldTab:CreateToggle({ Name = "Show World Names", CurrentValue = true, Callback = function(v) worldNameEnabled = v end })
WorldTab:CreateSlider({ Name = "World Name Size", Range = {8, 20}, Increment = 1, CurrentValue = 13, Callback = function(v) worldNameSize = v end })

RageTab:CreateToggle({ Name = "Enable Spinbot", CurrentValue = false, Callback = function(v) spinbotEnabled = v end })
RageTab:CreateToggle({ Name = "Enable Jitter", CurrentValue = false, Callback = function(v) jitterEnabled = v end })
RageTab:CreateSlider({ Name = "Spinbot Speed", Range = {5, 60}, Increment = 1, CurrentValue = 20, Callback = function(v) spinbotSpeed = v end })
RageTab:CreateSlider({ Name = "Jitter Intensity", Range = {5, 40}, Increment = 1, CurrentValue = 15, Callback = function(v) jitterIntensity = v end })

MiscTab:CreateToggle({ Name = "Hit Notifications", CurrentValue = false, Callback = function(v) hitNotificationsEnabled = v end })
MiscTab:CreateSlider({ Name = "Hitsound Volume", Range = {0, 1}, Increment = 0.05, CurrentValue = 0.4, Callback = function(v) rustHitSound.Volume = v end })

RunService.Heartbeat:Connect(function()
    updatePlayerChams()
    updateNameESP()
    updateSelfChams()
end)

RunService.RenderStepped:Connect(function()
    if camera.FieldOfView ~= customFOV then
        camera.FieldOfView = customFOV
    end

    if spinbotEnabled then
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(spinbotSpeed), 0)
        end
    end

    if jitterEnabled then
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(math.random(-jitterIntensity, jitterIntensity)), 0)
        end
    end
end)

local lastWorldUpdate = 0
RunService.Heartbeat:Connect(function()
    if worldESPEnabled and tick() - lastWorldUpdate > 0.4 then
        lastWorldUpdate = tick()
        updateWorldESP()
    end
end)

RunService:BindToRenderStep("Aimbot", Enum.RenderPriority.Camera.Value + 1, function()
    fovCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    fovCircle.Radius = aimFOV
    fovCircle.Visible = isHoldingAim and aimbotEnabled

    if isHoldingAim and aimbotEnabled then
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
                            rustHitSound:Play()
                            Rayfield:Notify({
                                Title = "Damage",
                                Content = string.format("Dealt %d damage to %s", damage, plr.Name),
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
    Content = "Loaded successfully",
    Duration = 5,
})