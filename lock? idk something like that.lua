local getgenv = getgenv or function() return _G end
local cloneref = cloneref or function(o) return o end
local Drawing = Drawing or {new = function() return {Visible = false, Remove = function() end} end}

local function getService(name)
    local success, service = pcall(game.GetService, game, name)
    if success and service then
        return cloneref(service)
    end
    return nil
end

local Players = getService("Players")
local RunService = getService("RunService")
local UserInputService = getService("UserInputService")
local Workspace = getService("Workspace")
local TweenService = getService("TweenService")
local CoreGui = getService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local config = {
    Enabled = true,
    LockOnKey = Enum.KeyCode.E,
    Sensitivity = 0.2,
    Smoothing = 5,
    FOV = 400,
    ShowFOV = true,
    TargetPart = "HumanoidRootPart",
    PredictionEnabled = true,
    Prediction = 0.165,
    WallCheck = true,
    Active = false,
    Target = nil,
    Color = Color3.fromRGB(0, 162, 255),
    SpeedEnabled = false,
    SpeedValue = 16,
    JumpPowerEnabled = false,
    JumpPowerValue = 50,
    TriggerbotEnabled = false,
    TriggerbotDelay = 0.01,
    EspEnabled = true,
    EspBoxes = true,
    EspTracers = false,
    EspNames = true,
}

local espObjects = {}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SentinelLockUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 310, 0, 480)
MainFrame.Position = UDim2.new(0.5, -155, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local MCorner = Instance.new("UICorner")
MCorner.CornerRadius = UDim.new(0, 6)
MCorner.Parent = MainFrame

local MStroke = Instance.new("UIStroke")
MStroke.Color = config.Color
MStroke.Thickness = 1.5
MStroke.Transparency = 0.3
MStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "SENTINEL LOCK"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = MainFrame

local dragging, dragInput, dragStart, startPos
Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -20, 0, 30)
TabContainer.Position = UDim2.new(0, 10, 0, 45)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local TabList = Instance.new("UIListLayout")
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.Padding = UDim.new(0, 5)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabList.Parent = TabContainer

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -20, 1, -85)
ContentContainer.Position = UDim2.new(0, 10, 0, 80)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local function createTabFrame()
    local Frame = Instance.new("ScrollingFrame")
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.ScrollBarThickness = 2
    Frame.ScrollBarImageColor3 = config.Color
    Frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    Frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Frame.Visible = false
    Frame.Parent = ContentContainer
    
    local UIList = Instance.new("UIListLayout")
    UIList.Padding = UDim.new(0, 10)
    UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIList.Parent = Frame
    return Frame
end

local Tabs = {
    Combat = createTabFrame(),
    Movement = createTabFrame(),
    Visuals = createTabFrame()
}

local function selectTab(name)
    for tabName, frame in pairs(Tabs) do
        frame.Visible = (tabName == name)
    end
end

local function createTabButton(name)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 85, 1, 0)
    Button.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    Button.BorderSizePixel = 0
    Button.Text = name:upper()
    Button.TextColor3 = Color3.fromRGB(150, 150, 150)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 10
    Button.Parent = TabContainer
    
    local BCorner = Instance.new("UICorner")
    BCorner.CornerRadius = UDim.new(0, 6)
    BCorner.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        selectTab(name)
        for _, btn in ipairs(TabContainer:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.TextColor3 = (btn == Button) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
                btn.BackgroundColor3 = (btn == Button) and Color3.fromRGB(30, 30, 45) or Color3.fromRGB(20, 20, 28)
            end
        end
    end)
end

local function createToggle(name, configKey, parent, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    Button.BorderSizePixel = 0
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = parent
    
    local BCorner = Instance.new("UICorner")
    BCorner.CornerRadius = UDim.new(0, 6)
    BCorner.Parent = Button
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name:upper()
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Button
    
    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 32, 0, 18)
    Indicator.Position = UDim2.new(1, -47, 0.5, -9)
    Indicator.BackgroundColor3 = config[configKey] and config.Color or Color3.fromRGB(35, 35, 45)
    Indicator.Parent = Button
    
    local ICorner = Instance.new("UICorner")
    ICorner.CornerRadius = UDim.new(1, 0)
    ICorner.Parent = Indicator
    
    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 14, 0, 14)
    Dot.Position = UDim2.new(0, config[configKey] and 16 or 2, 0.5, -7)
    Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Dot.Parent = Indicator
    
    local DCorner = Instance.new("UICorner")
    DCorner.CornerRadius = UDim.new(1, 0)
    DCorner.Parent = Dot
    
    Button.MouseButton1Click:Connect(function()
        config[configKey] = not config[configKey]
        local enabled = config[configKey]
        TweenService:Create(Indicator, TweenInfo.new(0.3), {BackgroundColor3 = enabled and config.Color or Color3.fromRGB(35, 35, 45)}):Play()
        TweenService:Create(Dot, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, enabled and 16 or 2, 0.5, -7)}):Play()
        if callback then callback(enabled) end
    end)
end

local function createSlider(name, min, max, default, parent, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 60)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Text = name:upper() .. ": " .. config[default]
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local SliderBack = Instance.new("Frame")
    SliderBack.Size = UDim2.new(1, -10, 0, 6)
    SliderBack.Position = UDim2.new(0, 5, 0, 35)
    SliderBack.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    SliderBack.BorderSizePixel = 0
    SliderBack.Parent = Frame
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new(math.clamp((config[default] - min) / (max - min), 0, 1), 0, 1, 0)
    SliderFill.BackgroundColor3 = config.Color
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBack
    
    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 12, 0, 12)
    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    Knob.Position = UDim2.new(math.clamp((config[default] - min) / (max - min), 0, 1), 0, 0.5, 0)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.Parent = SliderBack
    
    local function update(input)
        local pos = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
        SliderFill.Size = UDim2.new(pos, 0, 1, 0)
        Knob.Position = UDim2.new(pos, 0, 0.5, 0)
        local val = min + (max - min) * pos
        if max > 10 then val = math.floor(val) else val = math.floor(val * 100) / 100 end
        Label.Text = name:upper() .. ": " .. val
        config[default] = val
        callback(val)
    end
    
    local dragging = false
    SliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            update(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end
    end)
end

local function createDropdown(name, options, configKey, parent, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 40)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    Button.BorderSizePixel = 0
    Button.Text = name:upper() .. ": " .. tostring(config[configKey]):upper()
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 11
    Button.Parent = Frame
    
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Size = UDim2.new(1, 0, 0, #options * 30)
    DropdownFrame.Position = UDim2.new(0, 0, 1, 5)
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.Visible = false
    DropdownFrame.ZIndex = 10
    DropdownFrame.Parent = Frame
    
    local UIList = Instance.new("UIListLayout")
    UIList.Parent = DropdownFrame
    
    for _, option in ipairs(options) do
        local OptBtn = Instance.new("TextButton")
        OptBtn.Size = UDim2.new(1, 0, 0, 30)
        OptBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
        OptBtn.Text = tostring(option):upper()
        OptBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        OptBtn.Font = Enum.Font.GothamBold
        OptBtn.TextSize = 10
        OptBtn.Parent = DropdownFrame
        
        OptBtn.MouseButton1Click:Connect(function()
            config[configKey] = option
            Button.Text = name:upper() .. ": " .. tostring(option):upper()
            DropdownFrame.Visible = false
            callback(option)
        end)
    end
    
    Button.MouseButton1Click:Connect(function()
        DropdownFrame.Visible = not DropdownFrame.Visible
    end)
end

createTabButton("Combat")
createTabButton("Movement")
createTabButton("Visuals")
selectTab("Combat")

createToggle("Lock Enabled", "Enabled", Tabs.Combat)
createSlider("FOV Radius", 10, 800, "FOV", Tabs.Combat, function(v) end)
createToggle("Show FOV", "ShowFOV", Tabs.Combat)
createSlider("Smoothing", 1, 50, "Smoothing", Tabs.Combat, function(v) end)
createSlider("Prediction", 0.01, 0.5, "Prediction", Tabs.Combat, function(v) end)
createToggle("Wall Check", "WallCheck", Tabs.Combat)
createDropdown("Target Part", {"HumanoidRootPart", "Head", "UpperTorso"}, "TargetPart", Tabs.Combat, function(v) end)
createToggle("Triggerbot", "TriggerbotEnabled", Tabs.Combat)
createSlider("Trigger Delay", 0, 1, "TriggerbotDelay", Tabs.Combat, function(v) end)

createToggle("Speed Hack", "SpeedEnabled", Tabs.Movement)
createSlider("Speed Value", 16, 200, "SpeedValue", Tabs.Movement, function(v) end)
createToggle("Jump Power", "JumpPowerEnabled", Tabs.Movement)
createSlider("Jump Value", 50, 300, "JumpPowerValue", Tabs.Movement, function(v) end)

createToggle("ESP Enabled", "EspEnabled", Tabs.Visuals)
createToggle("ESP Boxes", "EspBoxes", Tabs.Visuals)
createToggle("ESP Tracers", "EspTracers", Tabs.Visuals)
createToggle("ESP Names", "EspNames", Tabs.Visuals)

local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1.5
fovCircle.NumSides = 64
fovCircle.Filled = false
fovCircle.Transparency = 0.6

local function getClosestPlayer()
    local closest = nil
    local shortestDistance = config.FOV
    local mousePos = UserInputService:GetMouseLocation()

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local root = player.Character:FindFirstChild(config.TargetPart)
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            
            if root and hum and hum.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    if distance < shortestDistance then
                        if config.WallCheck then
                            local rayDirection = (root.Position - Camera.CFrame.Position)
                            local raycastParams = RaycastParams.new()
                            raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                            raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, player.Character}
                            
                            local result = Workspace:Raycast(Camera.CFrame.Position, rayDirection, raycastParams)
                            if result then continue end
                        end
                        closest = player
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    return closest
end

local function createEsp(player)
    if espObjects[player] then return end
    
    local objects = {
        Box = Drawing.new("Square"),
        Tracer = Drawing.new("Line"),
        Name = Drawing.new("Text")
    }
    
    objects.Box.Thickness = 1
    objects.Box.Filled = false
    objects.Box.Color = config.Color
    objects.Box.Visible = false
    
    objects.Tracer.Thickness = 1
    objects.Tracer.Color = config.Color
    objects.Tracer.Visible = false
    
    objects.Name.Size = 14
    objects.Name.Center = true
    objects.Name.Outline = true
    objects.Name.Color = Color3.new(1, 1, 1)
    objects.Name.Visible = false
    
    espObjects[player] = objects
end

local function removeEsp(player)
    if espObjects[player] then
        for _, obj in pairs(espObjects[player]) do
            pcall(function()
                obj.Visible = false
                obj:Remove()
            end)
        end
        espObjects[player] = nil
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then 
        createEsp(player) 
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        createEsp(player)
    end
end)

Players.PlayerRemoving:Connect(removeEsp)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == config.LockOnKey then
        if config.Active then
            config.Active = false
            config.Target = nil
        elseif config.Enabled then
            local target = getClosestPlayer()
            if target then
                config.Target = target
                config.Active = true
            end
        end
    elseif input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

RunService.RenderStepped:Connect(function()
    fovCircle.Visible = config.ShowFOV and MainFrame.Visible
    fovCircle.Radius = config.FOV
    fovCircle.Position = UserInputService:GetMouseLocation()
    fovCircle.Color = config.Color
    
    if config.Active and config.Target and config.Target.Character then
        local root = config.Target.Character:FindFirstChild(config.TargetPart)
        local hum = config.Target.Character:FindFirstChildOfClass("Humanoid")
        
        if root and hum and hum.Health > 0 then
            local targetPos = root.Position
            if config.PredictionEnabled then
                targetPos = targetPos + (root.Velocity * config.Prediction)
            end
            local targetViewportPos, onScreen = Camera:WorldToViewportPoint(targetPos)
            if onScreen then
                local mousePos = UserInputService:GetMouseLocation()
                local diffX = (targetViewportPos.X - mousePos.X)
                local diffY = (targetViewportPos.Y - mousePos.Y)
                
                mousemoverel(diffX / config.Smoothing, diffY / config.Smoothing)
            else
                config.Active = false
                config.Target = nil
            end
        else
            config.Active = false
            config.Target = nil
        end
    end
    

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local hum = LocalPlayer.Character.Humanoid
        if config.SpeedEnabled then 
            hum.WalkSpeed = config.SpeedValue 
        else
            hum.WalkSpeed = 16
        end
        
        if config.JumpPowerEnabled then 
            hum.JumpPower = config.JumpPowerValue 
            hum.UseJumpPower = true 
        else
            hum.JumpPower = 50
        end
    end
    

    if config.TriggerbotEnabled then
        local mouseTarget = LocalPlayer:GetMouse().Target
        if mouseTarget and mouseTarget.Parent and mouseTarget.Parent:FindFirstChild("Humanoid") then
            local player = Players:GetPlayerFromCharacter(mouseTarget.Parent)
            if player and player ~= LocalPlayer then
                mouse1click()
                task.wait(config.TriggerbotDelay)
            end
        end
    end
    

    for player, objects in pairs(espObjects) do
        local visible = false
        if config.EspEnabled and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if root and hum and hum.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    visible = true
                    local color = config.Color
                    

                    if config.EspBoxes then
                        local head = player.Character:FindFirstChild("Head")
                        local headPos = head and Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0)) or Camera:WorldToViewportPoint(root.Position + Vector3.new(0, 3, 0))
                        local legPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
                        
                        local height = math.abs(headPos.Y - legPos.Y)
                        local width = height * 0.6
                        
                        objects.Box.Size = Vector2.new(width, height)
                        objects.Box.Position = Vector2.new(pos.X - width / 2, pos.Y - height / 2)
                        objects.Box.Color = color
                        objects.Box.Visible = true
                    else
                        objects.Box.Visible = false
                    end
                    

                    if config.EspTracers then
                        objects.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        objects.Tracer.To = Vector2.new(pos.X, pos.Y)
                        objects.Tracer.Color = color
                        objects.Tracer.Visible = true
                    else
                        objects.Tracer.Visible = false
                    end
                    

                    if config.EspNames then
                        objects.Name.Text = player.DisplayName or player.Name
                        objects.Name.Position = Vector2.new(pos.X, pos.Y - (objects.Box.Size.Y / 2) - 15)
                        objects.Name.Visible = true
                    else
                        objects.Name.Visible = false
                    end
                end
            end
        end
        
        if not visible then
            objects.Box.Visible = false
            objects.Tracer.Visible = false
            objects.Name.Visible = false
        end
    end
end)

print("[SENTINEL LOCK] Loaded with ESP & Fixes")
