local getgenv = getgenv or function() return _G end
local cloneref = (type(cloneref) == "function" and cloneref) or function(o) return o end
local task = {
    wait = function(n) 
        local t = (type(getgenv) == "function" and getgenv().task) or _G.task
        if t and t.wait then return t.wait(n) end
        return (wait or function() end)(n)
    end,
    spawn = function(f)
        local t = (type(getgenv) == "function" and getgenv().task) or _G.task
        if t and t.spawn then return t.spawn(f) end
        return (spawn or function(i) i() end)(f)
    end,
    delay = function(n, f)
        local t = (type(getgenv) == "function" and getgenv().task) or _G.task
        if t and t.delay then return t.delay(n, f) end
        return (delay or function() end)(n, f)
    end,
    defer = function(f)
        local t = (type(getgenv) == "function" and getgenv().task) or _G.task
        if t and t.defer then return t.defer(f) end
        return (spawn or function(i) i() end)(f)
    end
}

local function getService(name)
    local success, service = pcall(function() return game:GetService(name) end)
    if success and service then
        return cloneref(service)
    end
    return nil
end

local Players = getService("Players")
local RunService = getService("RunService")
local UserInputService = getService("UserInputService")
local TweenService = getService("TweenService")
local Workspace = getService("Workspace") or workspace
local Lighting = getService("Lighting")
local SoundService = getService("SoundService")
local GuiService = getService("GuiService")
local HttpService = getService("HttpService")

local LocalPlayer = (Players and Players.LocalPlayer)
if not LocalPlayer then
    pcall(function()
        LocalPlayer = game:GetService("Players").LocalPlayer
    end)
end
while not LocalPlayer do
    task.wait()
    LocalPlayer = Players.LocalPlayer
end

local gethui = gethui or function()
    local success, result = pcall(function() return game:GetService("CoreGui") end)
    if success and result then return result end
    return LocalPlayer:FindFirstChild("PlayerGui")
end

local Camera = Workspace.CurrentCamera
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = Workspace.CurrentCamera
end)


local flyConfig = {
    enabled = false,
    speed = 50,
    vSpeed = 50,
    fov = 70,
    noclip = false,
    platformFly = false,
    visible = true,
    keybind = Enum.KeyCode.Q,
    toggleGui = Enum.KeyCode.Delete,
    isBinding = false,
    isBindingGui = false,


    speedHackEnabled = false,
    walkSpeed = 16,

    smoothing = 1,
    bankTurning = true,
    autoFly = false,
    animation = "Classic",
    fovSync = false,
    themeColor = Color3.fromRGB(255, 140, 0),


    fogEnabled = true,
    fogColor = Color3.fromRGB(192, 192, 192),
    fogEnd = 10000,
    cloudColor = Color3.fromRGB(255, 255, 255),
    skyColor = Color3.fromRGB(255, 255, 255),
    clockTime = 14
}

local theme = {
    background = Color3.fromRGB(15, 15, 20),
    secondary = Color3.fromRGB(20, 20, 28),
    accent = flyConfig.themeColor,
    text = Color3.fromRGB(255, 255, 255),
    textSecondary = Color3.fromRGB(180, 180, 180),
    danger = Color3.fromRGB(255, 80, 80),
    success = Color3.fromRGB(80, 255, 150)
}


local currentVelocity = Vector3.new(0, 0, 0)
local flightPos = Vector3.new(0, 0, 0)
local currentRot = CFrame.new()
local platform = nil


local adminWhitelist = {}
local bangActive = false
local bangTarget = nil
local isFrozen = false
local frozenPos = nil

pcall(function()
    if isfile and readfile and isfile("sentinel_bans.json") then
        local content = readfile("sentinel_bans.json")
        if content and content ~= "" then
            local success, banData = pcall(function() return HttpService:JSONDecode(content) end)
            if success and banData[game.JobId] then
                LocalPlayer:Kick("\n[SENTINEL BAN]\n\nYou are banned from this server.")
            end
        end
    end
end)

local function updateWhitelist()
    local success, result = pcall(function()
        return game:HttpGet("https://pastebin.com/raw/8fKwRqYM")
    end)
    if success and result and type(result) == "string" and result ~= "" then
        adminWhitelist = {}
        print("[SENTINEL] Whitelisted Admins:")
        for line in result:gmatch("[^\r\n]+") do
            local name = line:gsub("%s+", ""):lower()
            if name ~= "" then
                adminWhitelist[name] = true
                print(" - " .. name)
            end
        end
    else
        warn("[SENTINEL] Failed to fetch premium whitelist or result was empty.")
    end
end
updateWhitelist()

task.spawn(function()
    while task.wait(60) do
        updateWhitelist()
    end
end)

local function showNotify(text)
    task.spawn(function()
        local targetParent = (gethui and gethui()) or (LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChildWhichIsA("ScreenGui"))
        if not targetParent then

            targetParent = LocalPlayer:WaitForChild("PlayerGui")
        end

        local notifyGui = targetParent:FindFirstChild("SentinelNotificationPopup")
        if notifyGui then notifyGui:Destroy() end

        notifyGui = Instance.new("ScreenGui")
        notifyGui.Name = "SentinelNotificationPopup"
        notifyGui.DisplayOrder = 10000
        notifyGui.Parent = targetParent

        local main = Instance.new("Frame")
        main.Size = UDim2.new(0, 300, 0, 150)
        main.Position = UDim2.new(0.5, -150, 0.5, -75)
        main.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
        main.BorderSizePixel = 0
        main.Parent = notifyGui

        Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
        local stroke = Instance.new("UIStroke", main)
        stroke.Color = Color3.fromRGB(255, 140, 0)
        stroke.Thickness = 2

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 40)
        title.BackgroundTransparency = 1
        title.Text = "SENTINEL NOTIFICATION"
        title.TextColor3 = Color3.fromRGB(255, 140, 0)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 14
        title.Parent = main

        local contentText = Instance.new("TextLabel")
        contentText.Size = UDim2.new(1, -20, 1, -80)
        contentText.Position = UDim2.new(0, 10, 0, 40)
        contentText.BackgroundTransparency = 1
        contentText.Text = text
        contentText.TextColor3 = Color3.fromRGB(255, 255, 255)
        contentText.Font = Enum.Font.Gotham
        contentText.TextSize = 12
        contentText.TextWrapped = true
        contentText.Parent = main

        local dismiss = Instance.new("TextButton")
        dismiss.Size = UDim2.new(0, 100, 0, 30)
        dismiss.Position = UDim2.new(0.5, -50, 1, -40)
        dismiss.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
        dismiss.Text = "DISMISS"
        dismiss.TextColor3 = Color3.fromRGB(255, 255, 255)
        dismiss.Font = Enum.Font.GothamBold
        dismiss.TextSize = 12
        dismiss.Parent = main
        Instance.new("UICorner", dismiss).CornerRadius = UDim.new(0, 6)

        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://203785572"
        sound.Volume = 1
        sound.Parent = SoundService
        sound:Play()
        task.delay(2, function() sound:Destroy() end)

        dismiss.MouseButton1Click:Connect(function()
            notifyGui:Destroy()
        end)
    end)
end

local function handleCommand(issuer, msg)
    if not adminWhitelist[issuer.Name:lower()] then return end

    local myWhitelisted = adminWhitelist[LocalPlayer.Name:lower()] or false

    local args = msg:split(" ")
    local cmd = args[1]:lower()
    local targetName = args[2] or ""

    local isTarget = false
    local targetLower = targetName:lower()
    if targetName == "." then
        if not myWhitelisted then isTarget = true end
    elseif #targetLower >= 4 and (LocalPlayer.Name:lower():find(targetLower, 1, true) or LocalPlayer.DisplayName:lower():find(targetLower, 1, true)) then
        if not myWhitelisted then isTarget = true end
    elseif targetLower == LocalPlayer.Name:lower() or targetLower == LocalPlayer.DisplayName:lower() then
        if not myWhitelisted then isTarget = true end
    end

    if not isTarget then return end

    if cmd == "*bang" then
        if bangActive then return end

        local targetToBang = issuer 
        if targetName ~= "" and targetName ~= "." then
            for _, p in ipairs(Players:GetPlayers()) do
                local pName = p.Name:lower()
                local pDisp = p.DisplayName:lower()
                local tName = targetName:lower()
                if (pName == tName or pDisp == tName or (tName:len() >= 3 and (pName:find(tName) or pDisp:find(tName)))) and p ~= LocalPlayer then
                    targetToBang = p
                    break
                end
            end
        end

        if not targetToBang then return end
        bangActive = true


        local function holdCtrl()
            pcall(function()
                if keypress then
                    keypress(17) 
                end
            end)
        end

        local ctrlConnection
        ctrlConnection = UserInputService.InputEnded:Connect(function(input)
            if not bangActive then
                if ctrlConnection then ctrlConnection:Disconnect() end
                return
            end
            if input.KeyCode == Enum.KeyCode.LeftControl then
                holdCtrl()
            end
        end)

        holdCtrl()

        task.spawn(function()
            local phase = 0
            while bangActive do
                local targetAlive = false
                if targetToBang and targetToBang.Parent and targetToBang.Character then
                    targetAlive = true
                    pcall(function()
                        local targetRP = targetToBang.Character:FindFirstChild("HumanoidRootPart")
                        local myChar = LocalPlayer.Character
                        if not targetRP or not myChar then return end

                        local hum = myChar:FindFirstChild("Humanoid")
                        if hum then hum.PlatformStand = true end

                        -- Animation: Move back and forth behind the target
                        local offset = (phase == 0) and CFrame.new(0, 0, 1.2) or CFrame.new(0, 0, 2.5)
                        myChar:PivotTo(targetRP.CFrame * offset)
                    end)
                end

                if not targetAlive then break end
                phase = (phase + 1) % 2
                task.wait(0.1)
            end
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.PlatformStand = false
                end
                if keyrelease then
                    keyrelease(17)
                end
                if ctrlConnection then ctrlConnection:Disconnect() end
            end)
            bangActive = false
        end)
    elseif cmd == "*unbang" then
        bangActive = false
    elseif cmd == "*freeze" then
        isFrozen = true
        pcall(function()
            frozenPos = LocalPlayer.Character.HumanoidRootPart.CFrame
        end)
    elseif cmd == "*unfreeze" then
        isFrozen = false
        frozenPos = nil
    elseif cmd == "*bring" then
        pcall(function()
            LocalPlayer.Character:PivotTo(issuer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2))
        end)
    elseif cmd == "*kick" then
        local reason = table.concat(args, " ", 3)
        if reason == "" then reason = "No reason provided" end
        LocalPlayer:Kick("\n[SENTINEL KICK]\nReason: " .. reason)
    elseif cmd == "*ban" then
        local reason = table.concat(args, " ", 3)
        if reason == "" then reason = "No reason provided" end
        pcall(function()
            if writefile then
                local banData = {}
                if isfile and isfile("sentinel_bans.json") then
                    pcall(function() 
                        if HttpService then
                            banData = HttpService:JSONDecode(readfile("sentinel_bans.json")) 
                        end
                    end)
                end
                banData[game.JobId] = true
                if HttpService and writefile then
                    writefile("sentinel_bans.json", HttpService:JSONEncode(banData))
                end
            end
            LocalPlayer:Kick("\n[SENTINEL BAN]\nReason: " .. reason .. "\n\nYou are banned from this server.")
        end)
    elseif cmd == "*reset" then
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.Health = 0
            else
                LocalPlayer.Character:BreakJoints()
            end
        end)
    elseif cmd == "*notify" then
        local text = table.concat(args, " ", 2)
        if text ~= "" then showNotify(text) end
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    player.Chatted:Connect(function(msg) handleCommand(player, msg) end)
end
Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(msg) handleCommand(player, msg) end)
end)

RunService.RenderStepped:Connect(function()
    if isFrozen and frozenPos then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                char:PivotTo(frozenPos)
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    root.Velocity = Vector3.new(0, 0, 0)
                    root.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
        end)
    end
end)

local function getMoveDirection()
    local dir = Vector3.new(0, 0, 0)
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.LookVector:Cross(Vector3.new(0, 1, 0)) end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.LookVector:Cross(Vector3.new(0, 1, 0)) end

    local vDir = 0
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vDir = 1 end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then vDir = -1 end

    return dir, vDir
end

local function toggleFly()
    flyConfig.enabled = not flyConfig.enabled
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")

    if flyConfig.enabled then
        if hum and not hum.SeatPart then hum.PlatformStand = true end
        if root then flightPos = root.Position end
        if flyConfig.platformFly then
            platform = Instance.new("Part")
            platform.Size = Vector3.new(6, 1, 6)
            platform.Transparency = 1
            platform.Anchored = true
            platform.Parent = Workspace
        end
    else
        if hum then hum.PlatformStand = false end
        if platform then platform:Destroy() platform = nil end
        if root then root.Velocity = Vector3.new(0, 0, 0) end
    end
end

RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")

    if flyConfig.enabled or flyConfig.noclip then
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and not part:FindFirstAncestorWhichIsA("Tool") then
                    part.CanCollide = false
                end
            end
            if hum and not hum.SeatPart then
                hum:ChangeState(Enum.HumanoidStateType.NoPhysics)
            end
        end
    end

    if hum then
        if flyConfig.speedHackEnabled then
            hum.WalkSpeed = flyConfig.walkSpeed
        else


        end
    end
end)

RunService.Heartbeat:Connect(function(dt)
    if not flyConfig.enabled then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local moveDir, vDir = getMoveDirection()
    local targetVel = Vector3.new(0, 0, 0)

    if (flightPos - root.Position).Magnitude > 20 then
        flightPos = root.Position
    end

    if moveDir.Magnitude > 0 then
        targetVel = moveDir.Unit * flyConfig.speed
    end

    targetVel = targetVel + Vector3.new(0, vDir * flyConfig.vSpeed, 0)


    currentVelocity = currentVelocity:Lerp(targetVel, flyConfig.smoothing)
    root.Velocity = Vector3.new(0, 0, 0)
    root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)


    local bank = 0
    if flyConfig.bankTurning then
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then bank = 0.3 end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then bank = -0.3 end
    end

    local targetRot = CFrame.new(flightPos, flightPos + Camera.CFrame.LookVector) * CFrame.Angles(0, 0, bank)


    flightPos = flightPos + (currentVelocity * dt)
    root.CFrame = CFrame.new(flightPos) * targetRot.Rotation

    if platform then
        platform.CFrame = root.CFrame * CFrame.new(0, -3.5, 0)
    end
end)

local function updateEnvironment()
    local lighting = Lighting
    if not lighting then return end
    lighting.FogEnd = flyConfig.fogEnabled and flyConfig.fogEnd or 1000000
    lighting.FogColor = flyConfig.fogColor
    lighting.ClockTime = flyConfig.clockTime

    local clouds = Workspace.Terrain:FindFirstChildOfClass("Clouds") or lighting:FindFirstChildOfClass("Clouds")
    if clouds then
        clouds.Color = flyConfig.cloudColor
    end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SentinelFly_V2"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = gethui() end)

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 320)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -160)
MainFrame.BackgroundColor3 = theme.background
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local mainGradient = Instance.new("UIGradient")
mainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, theme.background),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 15))
})
mainGradient.Rotation = 45
mainGradient.Parent = MainFrame

local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
Shadow.Size = UDim2.new(1, 60, 1, 60)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://6015667341"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ZIndex = 0
Shadow.Parent = MainFrame

local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local objects = {}

            if GuiService then
                pcall(function()
                    objects = GuiService:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)
                end)
            end

            if #objects == 0 then

                pcall(function()
                    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                    if playerGui then
                        objects = playerGui:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)
                    end
                end)
            end

            local interactive = false
            for _, obj in ipairs(objects) do
                if (obj:IsA("TextButton") or obj:IsA("TextBox") or obj:IsA("ScrollingFrame") or obj.Name == "SliderBack" or obj.Name == "SliderFill") then
                    if obj:IsDescendantOf(frame) and obj ~= frame then
                        interactive = true
                        break
                    end
                end
            end

            if not interactive then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position

                local connection
                connection = input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                        if connection then connection:Disconnect() end
                    end
                end)
            end
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end
makeDraggable(MainFrame)

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = theme.accent
Stroke.Thickness = 1.2


local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 110, 1, 0)
Sidebar.BackgroundColor3 = theme.secondary
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local sidebarGradient = Instance.new("UIGradient")
sidebarGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, theme.secondary),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 22))
})
sidebarGradient.Rotation = 90
sidebarGradient.Parent = Sidebar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Position = UDim2.new(0, 0, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "SENTINEL HUB"
Title.TextColor3 = theme.accent
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = Sidebar

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, 0, 0, 15)
SubTitle.Position = UDim2.new(0, 0, 0, 28)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = ""
SubTitle.TextColor3 = theme.textSecondary
SubTitle.Font = Enum.Font.GothamBold
SubTitle.TextSize = 9
SubTitle.Parent = Sidebar

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 1, -60)
TabContainer.Position = UDim2.new(0, 0, 0, 55)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = Sidebar

local TabList = Instance.new("UIListLayout", TabContainer)
TabList.Padding = UDim.new(0, 5)


local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -125, 1, -10)
ContentContainer.Position = UDim2.new(0, 115, 0, 5)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local Tabs = {}
local activeTab = nil

local function createTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, -10, 0, 30)
    TabBtn.BackgroundTransparency = 1
    TabBtn.Text = name:upper()
    TabBtn.TextColor3 = theme.textSecondary
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 12
    TabBtn.Parent = TabContainer

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 0
    Page.Visible = false
    Page.Parent = ContentContainer

    local PageLayout = Instance.new("UIListLayout", Page)
    PageLayout.Padding = UDim.new(0, 8)

    TabBtn.MouseButton1Click:Connect(function()
        if activeTab then
            Tabs[activeTab].Page.Visible = false
            Tabs[activeTab].Btn.TextColor3 = theme.textSecondary
        end
        Page.Visible = true
        TabBtn.TextColor3 = theme.accent
        activeTab = name
    end)

    Tabs[name] = {Btn = TabBtn, Page = Page}
    if not activeTab then
        Page.Visible = true
        TabBtn.TextColor3 = theme.accent
        activeTab = name
    end
    return Page
end

local function createToggle(name, configKey, parent, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 35)
    Frame.BackgroundColor3 = theme.secondary
    Frame.BorderSizePixel = 0
    Frame.Parent = parent
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = theme.text
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(0, 35, 0, 18)
    Toggle.Position = UDim2.new(1, -45, 0.5, -9)
    Toggle.BackgroundColor3 = flyConfig[configKey] and theme.accent or Color3.fromRGB(40, 40, 45)
    Toggle.Text = ""
    Toggle.Parent = Frame
    Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)

    Toggle.MouseButton1Click:Connect(function()
        flyConfig[configKey] = not flyConfig[configKey]
        TweenService:Create(Toggle, TweenInfo.new(0.3), {BackgroundColor3 = flyConfig[configKey] and theme.accent or Color3.fromRGB(40, 40, 45)}):Play()
        if callback then callback(flyConfig[configKey]) end
    end)
end

local function createSlider(name, configKey, min, max, parent, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 50)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 15)
    Label.BackgroundTransparency = 1
    Label.Text = name:upper() .. ": " .. tostring(flyConfig[configKey])
    Label.TextColor3 = theme.textSecondary
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 10
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local SliderBack = Instance.new("Frame")
    SliderBack.Name = "SliderBack"
    SliderBack.Size = UDim2.new(1, -20, 0, 6)
    SliderBack.Position = UDim2.new(0, 10, 0, 30)
    SliderBack.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    SliderBack.Parent = Frame
    Instance.new("UICorner", SliderBack).CornerRadius = UDim.new(1, 0)

    local SliderFill = Instance.new("Frame")
    SliderFill.Name = "SliderFill"
    SliderFill.Size = UDim2.new((flyConfig[configKey] - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = theme.accent
    SliderFill.Parent = SliderBack
    Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame")
    Knob.Name = "Knob"
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    Knob.Position = UDim2.new((flyConfig[configKey] - min) / (max - min), 0, 0.5, 0)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.Parent = SliderBack
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local KnobStroke = Instance.new("UIStroke", Knob)
    KnobStroke.Color = theme.accent
    KnobStroke.Thickness = 2

    local function update(input)
        local pos = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        flyConfig[configKey] = val
        SliderFill.Size = UDim2.new(pos, 0, 1, 0)
        Knob.Position = UDim2.new(pos, 0, 0.5, 0)
        Label.Text = name:upper() .. ": " .. val
        if callback then callback(val) end
    end

    local dragging = false
    Frame.InputBegan:Connect(function(input)
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

local function createColorSliders(name, configKey, parent, callback)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Text = name:upper()
    Label.TextColor3 = theme.accent
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = parent

    local r, g, b = math.floor(flyConfig[configKey].R * 255), math.floor(flyConfig[configKey].G * 255), math.floor(flyConfig[configKey].B * 255)

    local tempConfig = {
        [configKey.."_R"] = r,
        [configKey.."_G"] = g,
        [configKey.."_B"] = b
    }


    flyConfig[configKey.."_R"] = r
    flyConfig[configKey.."_G"] = g
    flyConfig[configKey.."_B"] = b

    local function updateColor()
        flyConfig[configKey] = Color3.fromRGB(flyConfig[configKey.."_R"], flyConfig[configKey.."_G"], flyConfig[configKey.."_B"])
        if callback then callback(flyConfig[configKey]) end
    end

    createSlider("  Red", configKey.."_R", 0, 255, parent, updateColor)
    createSlider("  Green", configKey.."_G", 0, 255, parent, updateColor)
    createSlider("  Blue", configKey.."_B", 0, 255, parent, updateColor)
end

local MainTab = createTab("Main")
local ExtraTab = createTab("Extra")
local VisualTab = createTab("Visual")
local EnvTab = createTab("Env")


createToggle("Enable Fog", "fogEnabled", EnvTab, updateEnvironment)
createSlider("Fog Distance", "fogEnd", 0, 50000, EnvTab, updateEnvironment)
createSlider("Time of Day", "clockTime", 0, 24, EnvTab, updateEnvironment)
createColorSliders("Fog Color", "fogColor", EnvTab, updateEnvironment)
createColorSliders("Cloud Color", "cloudColor", EnvTab, updateEnvironment)
createColorSliders("Sky/Atmosphere Color", "skyColor", EnvTab, updateEnvironment)


createToggle("Toggle Fly", "enabled", MainTab, function() toggleFly() end)
createSlider("Fly Speed", "speed", 0, 500, MainTab)
createSlider("Vertical Speed", "vSpeed", 0, 500, MainTab)

createToggle("Speed Hack", "speedHackEnabled", MainTab, function(v)
    if not v then
        pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = 16 end)
    end
end)
createSlider("Walk Speed", "walkSpeed", 16, 500, MainTab)

local BindBtn = Instance.new("TextButton")
BindBtn.Size = UDim2.new(1, 0, 0, 35)
BindBtn.BackgroundColor3 = theme.secondary
BindBtn.Text = "FLY BIND: " .. flyConfig.keybind.Name
BindBtn.TextColor3 = theme.text
BindBtn.Font = Enum.Font.GothamBold
BindBtn.TextSize = 11
BindBtn.Parent = MainTab
Instance.new("UICorner", BindBtn).CornerRadius = UDim.new(0, 6)

BindBtn.MouseButton1Click:Connect(function()
    flyConfig.isBinding = true
    BindBtn.Text = "PRESS ANY KEY..."
end)


createToggle("Bank Turning", "bankTurning", ExtraTab)
createToggle("Noclip", "noclip", ExtraTab)
createToggle("Legit Platform", "platformFly", ExtraTab)
createToggle("Auto Fly", "autoFly", ExtraTab)


createSlider("Base FOV", "fov", 30, 120, VisualTab, function(v) Camera.FieldOfView = v end)


local Colors = {
    Orange = Color3.fromRGB(255, 140, 0),
    Blue = Color3.fromRGB(0, 140, 255),
    Red = Color3.fromRGB(255, 50, 50),
    Purple = Color3.fromRGB(160, 50, 255)
}

local ColorGrid = Instance.new("Frame")
ColorGrid.Size = UDim2.new(1, 0, 0, 40)
ColorGrid.BackgroundTransparency = 1
ColorGrid.Parent = VisualTab

local ColorList = Instance.new("UIListLayout", ColorGrid)
ColorList.FillDirection = Enum.FillDirection.Horizontal
ColorList.Padding = UDim.new(0, 10)
ColorList.HorizontalAlignment = Enum.HorizontalAlignment.Center

for name, color in pairs(Colors) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 30, 0, 30)
    btn.BackgroundColor3 = color
    btn.Text = ""
    btn.Parent = ColorGrid
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    btn.MouseButton1Click:Connect(function()
        theme.accent = color
        Stroke.Color = color
        for _, t in pairs(Tabs) do
            if activeTab == _ then t.Btn.TextColor3 = color end
        end
    end)
end


UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if flyConfig.isBinding then
        flyConfig.keybind = input.KeyCode
        flyConfig.isBinding = false
        BindBtn.Text = "FLY BIND: " .. flyConfig.keybind.Name
        return
    end
    if input.KeyCode == flyConfig.keybind then
        toggleFly()
    elseif input.KeyCode == flyConfig.toggleGui then
        MainFrame.Visible = not MainFrame.Visible
    end
end)


if flyConfig.autoFly then toggleFly() end
updateEnvironment()
print("[SENTINEL] Fly V2 Loaded Successfully.")
