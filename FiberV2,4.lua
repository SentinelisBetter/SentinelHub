--[[
    Fiber.cc — Roblox UI Library
    A modern, lightweight exploit UI library.

    USAGE EXAMPLE:
    ──────────────────────────────────────────────
    local Fiber = loadstring(game:HttpGet("YOUR_RAW_URL"))()

    local Window = Fiber:CreateWindow({
        Title   = "My Hub",
        Theme   = "Dark",        -- Dark | Midnight | Crimson | Ocean | Lime
        Key     = Enum.KeyCode.RightControl,
    })

    local Tab = Window:AddTab("Combat")

    Tab:AddToggle("Aimbot", false, function(v) end)
    Tab:AddSlider("FOV", 10, 360, 120, function(v) end)
    Tab:AddDropdown("Target", {"Head","Torso"}, "Head", function(v) end)
    Tab:AddButton("Rejoin", function() end)
    Tab:AddInput("Tag", "e.g. [VIP]", function(v) end)
    Tab:AddColorpicker("ESP Color", Color3.fromRGB(255,50,50), function(v) end)
    Tab:AddSection("Movement")
    ──────────────────────────────────────────────
]]

local Fiber = {}
Fiber.__index = Fiber

-- ── Services ──────────────────────────────────────────────────────────────────
local TweenService    = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService      = game:GetService("RunService")
local TextService     = game:GetService("TextService")

-- ── Themes ────────────────────────────────────────────────────────────────────
local Themes = {
    Dark = {
        Background  = Color3.fromRGB(18,  18,  22),
        Surface     = Color3.fromRGB(26,  26,  32),
        SurfaceAlt  = Color3.fromRGB(32,  32,  40),
        Border      = Color3.fromRGB(50,  50,  62),
        Accent      = Color3.fromRGB(130, 100, 255),
        AccentDark  = Color3.fromRGB(90,  65,  200),
        Text        = Color3.fromRGB(235, 235, 240),
        TextMuted   = Color3.fromRGB(130, 130, 145),
        Tab         = Color3.fromRGB(22,  22,  28),
        TabActive   = Color3.fromRGB(130, 100, 255),
        Toggle      = Color3.fromRGB(50,  50,  65),
        ToggleOn    = Color3.fromRGB(130, 100, 255),
        Slider      = Color3.fromRGB(50,  50,  65),
        SliderFill  = Color3.fromRGB(130, 100, 255),
        Shadow      = Color3.fromRGB(0,   0,   0),
    },
    Midnight = {
        Background  = Color3.fromRGB(10,  12,  20),
        Surface     = Color3.fromRGB(15,  18,  30),
        SurfaceAlt  = Color3.fromRGB(20,  24,  40),
        Border      = Color3.fromRGB(35,  40,  65),
        Accent      = Color3.fromRGB(80,  140, 255),
        AccentDark  = Color3.fromRGB(50,  100, 200),
        Text        = Color3.fromRGB(220, 230, 255),
        TextMuted   = Color3.fromRGB(110, 120, 160),
        Tab         = Color3.fromRGB(12,  15,  25),
        TabActive   = Color3.fromRGB(80,  140, 255),
        Toggle      = Color3.fromRGB(35,  42,  70),
        ToggleOn    = Color3.fromRGB(80,  140, 255),
        Slider      = Color3.fromRGB(35,  42,  70),
        SliderFill  = Color3.fromRGB(80,  140, 255),
        Shadow      = Color3.fromRGB(0,   0,   0),
    },
    Crimson = {
        Background  = Color3.fromRGB(18,  12,  14),
        Surface     = Color3.fromRGB(28,  18,  20),
        SurfaceAlt  = Color3.fromRGB(38,  24,  28),
        Border      = Color3.fromRGB(70,  35,  40),
        Accent      = Color3.fromRGB(220, 60,  80),
        AccentDark  = Color3.fromRGB(170, 35,  55),
        Text        = Color3.fromRGB(240, 220, 225),
        TextMuted   = Color3.fromRGB(160, 110, 120),
        Tab         = Color3.fromRGB(22,  14,  16),
        TabActive   = Color3.fromRGB(220, 60,  80),
        Toggle      = Color3.fromRGB(65,  35,  40),
        ToggleOn    = Color3.fromRGB(220, 60,  80),
        Slider      = Color3.fromRGB(65,  35,  40),
        SliderFill  = Color3.fromRGB(220, 60,  80),
        Shadow      = Color3.fromRGB(0,   0,   0),
    },
    Ocean = {
        Background  = Color3.fromRGB(10,  20,  28),
        Surface     = Color3.fromRGB(15,  28,  38),
        SurfaceAlt  = Color3.fromRGB(20,  36,  50),
        Border      = Color3.fromRGB(30,  60,  80),
        Accent      = Color3.fromRGB(0,   185, 200),
        AccentDark  = Color3.fromRGB(0,   135, 155),
        Text        = Color3.fromRGB(210, 240, 245),
        TextMuted   = Color3.fromRGB(100, 155, 170),
        Tab         = Color3.fromRGB(12,  22,  32),
        TabActive   = Color3.fromRGB(0,   185, 200),
        Toggle      = Color3.fromRGB(25,  55,  75),
        ToggleOn    = Color3.fromRGB(0,   185, 200),
        Slider      = Color3.fromRGB(25,  55,  75),
        SliderFill  = Color3.fromRGB(0,   185, 200),
        Shadow      = Color3.fromRGB(0,   0,   0),
    },
    Lime = {
        Background  = Color3.fromRGB(12,  18,  12),
        Surface     = Color3.fromRGB(18,  26,  18),
        SurfaceAlt  = Color3.fromRGB(24,  34,  24),
        Border      = Color3.fromRGB(40,  65,  40),
        Accent      = Color3.fromRGB(100, 220, 80),
        AccentDark  = Color3.fromRGB(65,  170, 50),
        Text        = Color3.fromRGB(225, 245, 220),
        TextMuted   = Color3.fromRGB(120, 165, 110),
        Tab         = Color3.fromRGB(14,  20,  14),
        TabActive   = Color3.fromRGB(100, 220, 80),
        Toggle      = Color3.fromRGB(38,  62,  38),
        ToggleOn    = Color3.fromRGB(100, 220, 80),
        Slider      = Color3.fromRGB(38,  62,  38),
        SliderFill  = Color3.fromRGB(100, 220, 80),
        Shadow      = Color3.fromRGB(0,   0,   0),
    },
}

-- ── Helpers ───────────────────────────────────────────────────────────────────
local function Tween(obj, props, duration, style, dir)
    local info = TweenInfo.new(
        duration or 0.18,
        style or Enum.EasingStyle.Quart,
        dir   or Enum.EasingDirection.Out
    )
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function Make(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    if parent then obj.Parent = parent end
    return obj
end

local function MakePadding(parent, t, b, l, r)
    return Make("UIPadding", {
        PaddingTop    = UDim.new(0, t or 0),
        PaddingBottom = UDim.new(0, b or 0),
        PaddingLeft   = UDim.new(0, l or 0),
        PaddingRight  = UDim.new(0, r or 0),
    }, parent)
end

local function MakeCorner(parent, r)
    return Make("UICorner", { CornerRadius = UDim.new(0, r or 6) }, parent)
end

local function MakeStroke(parent, color, thickness, transparency)
    return Make("UIStroke", {
        Color        = color,
        Thickness    = thickness or 1,
        Transparency = transparency or 0,
    }, parent)
end

local function MakeList(parent, padding, dir, halign, valign)
    return Make("UIListLayout", {
        Padding          = UDim.new(0, padding or 6),
        FillDirection    = dir    or Enum.FillDirection.Vertical,
        HorizontalAlignment = halign or Enum.HorizontalAlignment.Left,
        VerticalAlignment   = valign or Enum.VerticalAlignment.Top,
        SortOrder        = Enum.SortOrder.LayoutOrder,
    }, parent)
end

-- Get or create ScreenGui safely (supports executor gethui)
local function GetGui()
    local holder
    if gethui then
        holder = gethui()
    else
        holder = game:GetService("CoreGui")
    end
    local existing = holder:FindFirstChild("FiberCC")
    if existing then existing:Destroy() end
    local sg = Make("ScreenGui", {
        Name              = "FiberCC",
        ResetOnSpawn      = false,
        ZIndexBehavior    = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset    = true,
    }, holder)
    return sg
end

-- ── Window ────────────────────────────────────────────────────────────────────
function Fiber:CreateWindow(cfg)
    cfg = cfg or {}
    local self        = setmetatable({}, { __index = Fiber })
    self._theme       = Themes[cfg.Theme] or Themes.Dark
    self._tabs        = {}
    self._activeTab   = nil
    self._visible     = true
    self._key         = cfg.Key or Enum.KeyCode.RightControl
    self._title       = cfg.Title or "Fiber.cc"
    self._flags       = {}

    local T = self._theme

    -- Root ScreenGui
    self._gui = GetGui()

    -- Drop shadow
    local Shadow = Make("Frame", {
        Name             = "Shadow",
        Size             = UDim2.new(0, 558, 0, 418),
        Position         = UDim2.new(0.5, -281, 0.5, -207),
        BackgroundColor3 = T.Shadow,
        BackgroundTransparency = 0.55,
        BorderSizePixel  = 0,
    }, self._gui)
    MakeCorner(Shadow, 10)

    -- Main frame
    local Main = Make("Frame", {
        Name             = "Main",
        Size             = UDim2.new(0, 550, 0, 410),
        Position         = UDim2.new(0.5, -275, 0.5, -205),
        BackgroundColor3 = T.Background,
        BorderSizePixel  = 0,
        ClipsDescendants = true,
    }, self._gui)
    MakeCorner(Main, 8)
    MakeStroke(Main, T.Border, 1)
    self._main = Main

    -- Titlebar
    local TitleBar = Make("Frame", {
        Name             = "TitleBar",
        Size             = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = T.Surface,
        BorderSizePixel  = 0,
    }, Main)
    Make("UICorner", { CornerRadius = UDim.new(0, 8) }, TitleBar)
    -- patch bottom corners of titlebar
    Make("Frame", {
        Size             = UDim2.new(1, 0, 0, 8),
        Position         = UDim2.new(0, 0, 1, -8),
        BackgroundColor3 = T.Surface,
        BorderSizePixel  = 0,
    }, TitleBar)

    -- Logo dot
    local Dot = Make("Frame", {
        Name             = "Dot",
        Size             = UDim2.new(0, 8, 0, 8),
        Position         = UDim2.new(0, 14, 0.5, -4),
        BackgroundColor3 = T.Accent,
        BorderSizePixel  = 0,
    }, TitleBar)
    MakeCorner(Dot, 99)

    Make("TextLabel", {
        Name             = "Title",
        Text             = self._title,
        Font             = Enum.Font.GothamBold,
        TextSize         = 14,
        TextColor3       = T.Text,
        Size             = UDim2.new(1, -100, 1, 0),
        Position         = UDim2.new(0, 28, 0, 0),
        BackgroundTransparency = 1,
        TextXAlignment   = Enum.TextXAlignment.Left,
    }, TitleBar)

    -- Watermark
    Make("TextLabel", {
        Name             = "Watermark",
        Text             = "fiber.cc",
        Font             = Enum.Font.Gotham,
        TextSize         = 11,
        TextColor3       = T.TextMuted,
        Size             = UDim2.new(0, 80, 1, 0),
        Position         = UDim2.new(1, -88, 0, 0),
        BackgroundTransparency = 1,
        TextXAlignment   = Enum.TextXAlignment.Right,
    }, TitleBar)

    -- Close / minimize buttons
    local BtnClose = Make("TextButton", {
        Name             = "Close",
        Text             = "×",
        Font             = Enum.Font.GothamBold,
        TextSize         = 16,
        TextColor3       = T.TextMuted,
        Size             = UDim2.new(0, 26, 0, 26),
        Position         = UDim2.new(1, -32, 0.5, -13),
        BackgroundColor3 = T.SurfaceAlt,
        BorderSizePixel  = 0,
        AutoButtonColor  = false,
    }, TitleBar)
    MakeCorner(BtnClose, 5)

    BtnClose.MouseEnter:Connect(function()
        Tween(BtnClose, { BackgroundColor3 = Color3.fromRGB(200,50,50) }, 0.12)
        Tween(BtnClose, { TextColor3 = Color3.fromRGB(255,255,255) }, 0.12)
    end)
    BtnClose.MouseLeave:Connect(function()
        Tween(BtnClose, { BackgroundColor3 = T.SurfaceAlt }, 0.12)
        Tween(BtnClose, { TextColor3 = T.TextMuted }, 0.12)
    end)
    BtnClose.MouseButton1Click:Connect(function()
        self:Destroy()
    end)

    local BtnMin = Make("TextButton", {
        Name             = "Minimize",
        Text             = "–",
        Font             = Enum.Font.GothamBold,
        TextSize         = 14,
        TextColor3       = T.TextMuted,
        Size             = UDim2.new(0, 26, 0, 26),
        Position         = UDim2.new(1, -62, 0.5, -13),
        BackgroundColor3 = T.SurfaceAlt,
        BorderSizePixel  = 0,
        AutoButtonColor  = false,
    }, TitleBar)
    MakeCorner(BtnMin, 5)

    BtnMin.MouseEnter:Connect(function()
        Tween(BtnMin, { BackgroundColor3 = T.Accent }, 0.12)
        Tween(BtnMin, { TextColor3 = Color3.fromRGB(255,255,255) }, 0.12)
    end)
    BtnMin.MouseLeave:Connect(function()
        Tween(BtnMin, { BackgroundColor3 = T.SurfaceAlt }, 0.12)
        Tween(BtnMin, { TextColor3 = T.TextMuted }, 0.12)
    end)
    BtnMin.MouseButton1Click:Connect(function()
        self:ToggleVisibility()
    end)

    -- Tab rail (left sidebar)
    local TabRail = Make("Frame", {
        Name             = "TabRail",
        Size             = UDim2.new(0, 130, 1, -42),
        Position         = UDim2.new(0, 0, 0, 42),
        BackgroundColor3 = T.Tab,
        BorderSizePixel  = 0,
    }, Main)
    MakeStroke(TabRail, T.Border, 1)
    local TabList = MakeList(TabRail, 2)
    MakePadding(TabRail, 8, 8, 8, 8)
    self._tabRail = TabRail
    self._tabList = TabList

    -- Content area
    local Content = Make("Frame", {
        Name             = "Content",
        Size             = UDim2.new(1, -130, 1, -42),
        Position         = UDim2.new(0, 130, 0, 42),
        BackgroundColor3 = T.Background,
        BorderSizePixel  = 0,
        ClipsDescendants = true,
    }, Main)
    self._content = Content

    -- Drag logic
    local dragging, dragStart, startPos = false, nil, nil
    TitleBar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = inp.Position
            startPos  = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = inp.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
            Shadow.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X - 4,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y - 4
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Key toggle
    UserInputService.InputBegan:Connect(function(inp, gp)
        if not gp and inp.KeyCode == self._key then
            self:ToggleVisibility()
        end
    end)

    -- Intro animation
    Main.Size        = UDim2.new(0, 0, 0, 0)
    Main.Position    = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size      = UDim2.new(0, 0, 0, 0)
    Shadow.Position  = UDim2.new(0.5, 0, 0.5, 0)
    task.defer(function()
        Tween(Main,   { Size = UDim2.new(0, 550, 0, 410), Position = UDim2.new(0.5, -275, 0.5, -205) }, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        Tween(Shadow, { Size = UDim2.new(0, 558, 0, 418), Position = UDim2.new(0.5, -281, 0.5, -209) }, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)

    return self
end

-- ── Toggle visibility ─────────────────────────────────────────────────────────
function Fiber:ToggleVisibility()
    self._visible = not self._visible
    if self._visible then
        self._main.Visible = true
        Tween(self._main, { Size = UDim2.new(0, 550, 0, 410) }, 0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    else
        local t = Tween(self._main, { Size = UDim2.new(0, 550, 0, 0) }, 0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        t.Completed:Connect(function() self._main.Visible = false end)
    end
end

function Fiber:Destroy()
    if self._gui then self._gui:Destroy() end
end

-- ── Notify ────────────────────────────────────────────────────────────────────
function Fiber:Notify(cfg)
    cfg = cfg or {}
    local T = self._theme

    local holder = self._gui:FindFirstChild("NotifHolder") or Make("Frame", {
        Name             = "NotifHolder",
        Size             = UDim2.new(0, 280, 1, 0),
        Position         = UDim2.new(1, -295, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel  = 0,
    }, self._gui)
    if not self._gui:FindFirstChild("NotifHolder") then
        MakeList(holder, 8)
        MakePadding(holder, 12, 12, 0, 0)
        holder.Parent = self._gui
    end

    local N = Make("Frame", {
        Name             = "Notif",
        Size             = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = T.Surface,
        BorderSizePixel  = 0,
        ClipsDescendants = true,
        AutomaticSize    = Enum.AutomaticSize.None,
    }, holder)
    MakeCorner(N, 7)
    MakeStroke(N, T.Border, 1)
    MakePadding(N, 10, 10, 12, 12)

    local Bar = Make("Frame", {
        Name             = "Bar",
        Size             = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = T.Accent,
        BorderSizePixel  = 0,
    }, N)
    MakeCorner(Bar, 3)

    Make("TextLabel", {
        Name             = "Title",
        Text             = cfg.Title or "Fiber.cc",
        Font             = Enum.Font.GothamBold,
        TextSize         = 13,
        TextColor3       = T.Text,
        Size             = UDim2.new(1, -10, 0, 18),
        Position         = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        TextXAlignment   = Enum.TextXAlignment.Left,
    }, N)

    Make("TextLabel", {
        Name             = "Body",
        Text             = cfg.Content or "",
        Font             = Enum.Font.Gotham,
        TextSize         = 12,
        TextColor3       = T.TextMuted,
        Size             = UDim2.new(1, -10, 0, 16),
        Position         = UDim2.new(0, 10, 0, 22),
        BackgroundTransparency = 1,
        TextXAlignment   = Enum.TextXAlignment.Left,
        TextWrapped      = true,
    }, N)

    Tween(N, { Size = UDim2.new(1, 0, 0, 60) }, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    task.delay(cfg.Duration or 4, function()
        Tween(N, { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1 }, 0.18)
        task.wait(0.2)
        N:Destroy()
    end)
end

-- ── AddTab ────────────────────────────────────────────────────────────────────
function Fiber:AddTab(name)
    local T = self._theme

    -- Tab button in sidebar
    local Btn = Make("TextButton", {
        Name             = "Tab_" .. name,
        Text             = name,
        Font             = Enum.Font.Gotham,
        TextSize         = 13,
        TextColor3       = T.TextMuted,
        Size             = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = T.Tab,
        BorderSizePixel  = 0,
        AutoButtonColor  = false,
        TextXAlignment   = Enum.TextXAlignment.Left,
    }, self._tabRail)
    MakeCorner(Btn, 5)
    MakePadding(Btn, 0, 0, 10, 0)

    -- Active indicator bar
    local Indicator = Make("Frame", {
        Name             = "Indicator",
        Size             = UDim2.new(0, 3, 0.6, 0),
        Position         = UDim2.new(0, 0, 0.2, 0),
        BackgroundColor3 = T.Accent,
        BorderSizePixel  = 0,
        BackgroundTransparency = 1,
    }, Btn)
    MakeCorner(Indicator, 3)

    -- Content scroll frame for this tab
    local Scroll = Make("ScrollingFrame", {
        Name             = "Scroll_" .. name,
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel  = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = T.Accent,
        CanvasSize       = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible          = false,
    }, self._content)
    MakeList(Scroll, 0)
    MakePadding(Scroll, 10, 10, 12, 12)

    local tab = {
        _name      = name,
        _btn       = Btn,
        _scroll    = Scroll,
        _indicator = Indicator,
        _window    = self,
    }

    -- Tab click
    Btn.MouseButton1Click:Connect(function()
        self:_selectTab(tab)
    end)

    Btn.MouseEnter:Connect(function()
        if self._activeTab ~= tab then
            Tween(Btn, { TextColor3 = T.Text }, 0.12)
            Tween(Btn, { BackgroundColor3 = T.SurfaceAlt }, 0.12)
        end
    end)
    Btn.MouseLeave:Connect(function()
        if self._activeTab ~= tab then
            Tween(Btn, { TextColor3 = T.TextMuted }, 0.12)
            Tween(Btn, { BackgroundColor3 = T.Tab }, 0.12)
        end
    end)

    table.insert(self._tabs, tab)

    -- Auto-select first tab
    if #self._tabs == 1 then
        self:_selectTab(tab)
    end

    -- Attach component builders
    setmetatable(tab, { __index = _TabMethods })
    return tab
end

function Fiber:_selectTab(tab)
    local T = self._theme

    -- Deactivate old
    if self._activeTab then
        local old = self._activeTab
        old._scroll.Visible = false
        Tween(old._btn, { BackgroundColor3 = T.Tab, TextColor3 = T.TextMuted }, 0.15)
        Tween(old._indicator, { BackgroundTransparency = 1 }, 0.15)
        old._btn.Font = Enum.Font.Gotham
    end

    -- Activate new
    self._activeTab = tab
    tab._scroll.Visible = true
    Tween(tab._btn, { BackgroundColor3 = T.SurfaceAlt, TextColor3 = T.Text }, 0.15)
    Tween(tab._indicator, { BackgroundTransparency = 0 }, 0.15)
    tab._btn.Font = Enum.Font.GothamBold
end

-- ══════════════════════════════════════════════════════
--  TAB COMPONENT METHODS
-- ══════════════════════════════════════════════════════
_TabMethods = {}
_TabMethods.__index = _TabMethods

-- ── Helper: make a row container ─────────────────────
local function MakeRow(parent, height)
    local row = Make("Frame", {
        Size             = UDim2.new(1, 0, 0, height or 44),
        BackgroundColor3 = parent._window._theme.Surface,
        BorderSizePixel  = 0,
    }, parent._scroll)
    MakeCorner(row, 6)
    MakePadding(row, 0, 0, 12, 12)
    return row
end

-- ── Section label ─────────────────────────────────────
function _TabMethods:AddSection(title)
    local T = self._window._theme
    local frame = Make("Frame", {
        Size             = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        BorderSizePixel  = 0,
    }, self._scroll)
    MakePadding(frame, 4, 0, 0, 0)

    Make("TextLabel", {
        Text             = string.upper(title),
        Font             = Enum.Font.GothamBold,
        TextSize         = 10,
        TextColor3       = T.Accent,
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        TextXAlignment   = Enum.TextXAlignment.Left,
        LetterSpacing    = 2,
    }, frame)

    Make("Frame", {
        Size             = UDim2.new(1, 0, 0, 1),
        Position         = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = T.Border,
        BorderSizePixel  = 0,
    }, frame)
end

-- ── Button ─────────────────────────────────────────────
function _TabMethods:AddButton(title, callback, description)
    local T = self._window._theme
    local row = Make("Frame", {
        Size             = UDim2.new(1, 0, 0, description and 54 or 40),
        BackgroundColor3 = T.Surface,
        BorderSizePixel  = 0,
    }, self._scroll)
    MakeCorner(row, 6)
    MakePadding(row, 0, 0, 12, 12)

    Make("TextLabel", {
        Text             = title,
        Font             = Enum.Font.GothamSemibold,
        TextSize         = 13,
        TextColor3       = T.Text,
        Size             = UDim2.new(1, -80, 0, 20),
        Position         = UDim2.new(0, 0, 0, description and 8 or 10),
        BackgroundTransparency = 1,
        TextXAlignment   = Enum.TextXAlignment.Left,
    }, row)

    if description then
        Make("TextLabel", {
            Text             = description,
            Font             = Enum.Font.Gotham,
            TextSize         = 11,
            TextColor3       = T.TextMuted,
            Size             = UDim2.new(1, -80, 0, 16),
            Position         = UDim2.new(0, 0, 0, 28),
            BackgroundTransparency = 1,
            TextXAlignment   = Enum.TextXAlignment.Left,
        }, row)
    end

    local Btn = Make("TextButton", {
        Text             = "Run",
        Font             = Enum.Font.GothamBold,
        TextSize         = 12,
        TextColor3       = T.Text,
        Size             = UDim2.new(0, 60, 0, 26),
        Position         = UDim2.new(1, -60, 0.5, -13),
        BackgroundColor3 = T.Accent,
        BorderSizePixel  = 0,
        AutoButtonColor  = false,
    }, row)
    MakeCorner(Btn, 5)

    Btn.MouseEnter:Connect(function() Tween(Btn, { BackgroundColor3 = T.AccentDark }, 0.12) end)
    Btn.MouseLeave:Connect(function() Tween(Btn, { BackgroundColor3 = T.Accent }, 0.12) end)
    Btn.MouseButton1Click:Connect(function()
        Tween(Btn, { Size = UDim2.new(0, 54, 0, 22) }, 0.08)
        task.wait(0.09)
        Tween(Btn, { Size = UDim2.new(0, 60, 0, 26) }, 0.1, Enum.EasingStyle.Back)
        if callback then callback() end
    end)
end

-- ── Toggle ─────────────────────────────────────────────
function _TabMethods:AddToggle(title, default, callback, description)
    local T   = self._window._theme
    local val = default or false

    local row = Make("Frame", {
        Size             = UDim2.new(1, 0, 0, description and 54 or 40),
        BackgroundColor3 = T.Surface,
        BorderSizePixel  = 0,
    }, self._scroll)
    MakeCorner(row, 6)
    MakePadding(row, 0, 0, 12, 12)

    Make("TextLabel", {
        Text             = title,
        Font             = Enum.Font.GothamSemibold,
        TextSize         = 13,
        TextColor3       = T.Text,
        Size             = UDim2.new(1, -58, 0, 20),
        Position         = UDim2.new(0, 0, 0, description and 8 or 10),
        BackgroundTransparency = 1,
        TextXAlignment   = Enum.TextXAlignment.Left,
    }, row)

    if description then
        Make("TextLabel", {
            Text             = description,
            Font             = Enum.Font.Gotham,
            TextSize         = 11,
            TextColor3       = T.TextMuted,
            Size             = UDim2.new(1, -58, 0, 16),
            Position         = UDim2.new(0, 0, 0, 28),
            BackgroundTransparency = 1,
            TextXAlignment   = Enum.TextXAlignment.Left,
        }, row)
    end

    -- Toggle track
    local Track = Make("Frame", {
        Size             = UDim2.new(0, 42, 0, 22),
        Position         = UDim2.new(1, -42, 0.5, -11),
        BackgroundColor3 = val and T.ToggleOn or T.Toggle,
        BorderSizePixel  = 0,
    }, row)
    MakeCorner(Track, 11)

    local Knob = Make("Frame", {
        Size             = UDim2.new(0, 16, 0, 16),
        Position         = UDim2.new(0, val and 22 or 3, 0.5, -8),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel  = 0,
    }, Track)
    MakeCorner(Knob, 99)

    local function refresh()
        Tween(Track, { BackgroundColor3 = val and T.ToggleOn or T.Toggle }, 0.15)
        Tween(Knob, { Position = UDim2.new(0, val and 22 or 3, 0.5, -8) }, 0.15, Enum.EasingStyle.Back)
    end

    local Hitbox = Make("TextButton", {
        Text             = "",
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel  = 0,
    }, row)
    Hitbox.MouseButton1Click:Connect(function()
        val = not val
        refresh()
        if callback then callback(val) end
    end)

    refresh()
    return {
        Set = function(v)
            val = v; refresh()
            if callback then callback(val) end
        end,
        Get = function() return val end,
    }
end

-- ── Slider ─────────────────────────────────────────────
function _TabMethods:AddSlider(title, min, max, default, callback, description)
    local T   = self._window._theme
    min       = min or 0
    max       = max or 100
    local val = math.clamp(default or min, min, max)

    local row = Make("Frame", {
        Size             = UDim2.new(1, 0, 0, description and 64 or 54),
        BackgroundColor3 = T.Surface,
        BorderSizePixel  = 0,
    }, self._scroll)
    MakeCorner(row, 6)
    MakePadding(row, 8, 8, 12, 12)

    local topRow = Make("Frame", {
        Size             = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        BorderSizePixel  = 0,
    }, row)

    Make("TextLabel", {
        Text             = title,
        Font             = Enum.Font.GothamSemibold,
        TextSize         = 13,
        TextColor3       = T.Text,
        Size             = UDim2.new(1, -50, 1, 0),
        BackgroundTransparency = 1,
        TextXAlignment   = Enum.TextXAlignment.Left,
    }, topRow)

    local ValLabel = Make("TextLabel", {
        Text             = tostring(val),
        Font             = Enum.Font.GothamBold,
        TextSize         = 13,
        TextColor3       = T.Accent,
        Size             = UDim2.new(0, 48, 1, 0),
        Position         = UDim2.new(1, -48, 0, 0),
        BackgroundTransparency = 1,
        TextXAlignment   = Enum.TextXAlignment.Right,
    }, topRow)

    if description then
        Make("TextLabel", {
            Text             = description,
            Font             = Enum.Font.Gotham,
            TextSize         = 11,
            TextColor3       = T.TextMuted,
            Size             = UDim2.new(1, 0, 0, 14),
            Position         = UDim2.new(0, 0, 0, 20),
            BackgroundTransparency = 1,
            TextXAlignment   = Enum.TextXAlignment.Left,
        }, row)
    end

    -- Track
    local Track = Make("Frame", {
        Size             = UDim2.new(1, 0, 0, 6),
        Position         = UDim2.new(0, 0, 1, -14),
        BackgroundColor3 = T.Slider,
        BorderSizePixel  = 0,
    }, row)
    MakeCorner(Track, 3)

    local Fill = Make("Frame", {
        Size             = UDim2.new((val - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = T.SliderFill,
        BorderSizePixel  = 0,
    }, Track)
    MakeCorner(Fill, 3)

    local Knob = Make("Frame", {
        Size             = UDim2.new(0, 14, 0, 14),
        Position         = UDim2.new((val - min) / (max - min), -7, 0.5, -7),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel  = 0,
    }, Track)
    MakeCorner(Knob, 99)
    MakeStroke(Knob, T.SliderFill, 2)

    local dragging = false

    local function setVal(x)
        local rel  = math.clamp((x - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        local newv = math.floor(min + rel * (max - min) + 0.5)
        if newv == val then return end
        val = newv
        ValLabel.Text = tostring(val)
        Tween(Fill,  { Size     = UDim2.new(rel, 0, 1, 0) }, 0.06)
        Tween(Knob,  { Position = UDim2.new(rel, -7, 0.5, -7) }, 0.06)
        if callback then callback(val) end
    end

    Track.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            setVal(inp.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
            setVal(inp.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    return {
        Set = function(v)
            val = math.clamp(v, min, max)
            local rel = (val - min) / (max - min)
            ValLabel.Text = tostring(val)
            Fill.Size     = UDim2.new(rel, 0, 1, 0)
            Knob.Position = UDim2.new(rel, -7, 0.5, -7)
            if callback then callback(val) end
        end,
        Get = function() return val end,
    }
end

-- ── Dropdown ───────────────────────────────────────────
function _TabMethods:AddDropdown(title, options, default, callback, description)
    local T      = self._window._theme
    local val    = default or options[1]
    local open   = false

    local wrapper = Make("Frame", {
        Size             = UDim2.new(1, 0, 0, description and 64 or 54),
        BackgroundTransparency = 1,
        BorderSizePixel  = 0,
        ClipsDescendants = false,
        ZIndex           = 2,
    }, self._scroll)
    MakeList(wrapper, 4)

    local row = Make("Frame", {
        Size             = UDim2.new(1, 0, 0, description and 64 or 54),
        BackgroundColor3 = T.Surface,
        BorderSizePixel  = 0,
        ZIndex           = 2,
    }, wrapper)
    MakeCorner(row, 6)
    MakePadding(row, 8, 8, 12, 12)

    Make("TextLabel", {
        Text             = title,
        Font             = Enum.Font.GothamSemibold,
        TextSize         = 13,
        TextColor3       = T.Text,
        Size             = UDim2.new(1, -130, 0, 18),
        BackgroundTransparency = 1,
        TextXAlignment   = Enum.TextXAlignment.Left,
    }, row)

    if description then
        Make("TextLabel", {
            Text             = description,
            Font             = Enum.Font.Gotham,
            TextSize         = 11,
            TextColor3       = T.TextMuted,
            Size             = UDim2.new(1, -130, 0, 14),
            Position         = UDim2.new(0, 0, 0, 22),
            BackgroundTransparency = 1,
            TextXAlignment   = Enum.TextXAlignment.Left,
        }, row)
    end

    -- Current value button
    local ValBtn = Make("TextButton", {
        Text             = val,
        Font             = Enum.Font.Gotham,
        TextSize         = 12,
        TextColor3       = T.Text,
        Size             = UDim2.new(0, 120, 0, 28),
        Position         = UDim2.new(1, -120, 0.5, -14),
        BackgroundColor3 = T.SurfaceAlt,
        BorderSizePixel  = 0,
        AutoButtonColor  = false,
        ZIndex           = 3,
    }, row)
    MakeCorner(ValBtn, 5)
    MakeStroke(ValBtn, T.Border, 1)

    -- Arrow
    local Arrow = Make("TextLabel", {
        Text             = "▾",
        Font             = Enum.Font.GothamBold,
        TextSize         = 14,
        TextColor3       = T.TextMuted,
        Size             = UDim2.new(0, 18, 1, 0),
        Position         = UDim2.new(1, -20, 0, 0),
        BackgroundTransparency = 1,
        ZIndex           = 4,
    }, ValBtn)

    -- Dropdown list
    local DropFrame = Make("Frame", {
        Size             = UDim2.new(0, 120, 0, 0),
        Position         = UDim2.new(1, -120, 1, 4),
        BackgroundColor3 = T.SurfaceAlt,
        BorderSizePixel  = 0,
        ClipsDescendants = true,
        ZIndex           = 10,
        Visible          = false,
    }, row)
    MakeCorner(DropFrame, 6)
    MakeStroke(DropFrame, T.Border, 1)
    MakePadding(DropFrame, 4, 4, 6, 6)
    MakeList(DropFrame, 2)

    local totalH = 0
    for _, opt in ipairs(options) do
        totalH = totalH + 28
        local OptBtn = Make("TextButton", {
            Text             = opt,
            Font             = Enum.Font.Gotham,
            TextSize         = 12,
            TextColor3       = opt == val and T.Accent or T.Text,
            Size             = UDim2.new(1, 0, 0, 24),
            BackgroundColor3 = T.SurfaceAlt,
            BorderSizePixel  = 0,
            AutoButtonColor  = false,
            ZIndex           = 11,
            TextXAlignment   = Enum.TextXAlignment.Left,
        }, DropFrame)
        MakeCorner(OptBtn, 4)
        MakePadding(OptBtn, 0, 0, 6, 0)

        OptBtn.MouseEnter:Connect(function()
            Tween(OptBtn, { BackgroundColor3 = T.Border }, 0.1)
        end)
        OptBtn.MouseLeave:Connect(function()
            Tween(OptBtn, { BackgroundColor3 = T.SurfaceAlt }, 0.1)
        end)

        OptBtn.MouseButton1Click:Connect(function()
            val = opt
            ValBtn.Text = opt
            -- Reset all colors
            for _, ch in ipairs(DropFrame:GetChildren()) do
                if ch:IsA("TextButton") then
                    ch.TextColor3 = T.Text
                end
            end
            OptBtn.TextColor3 = T.Accent
            open = false
            DropFrame.Visible = false
            Tween(Arrow, { Rotation = 0 }, 0.15)
            if callback then callback(val) end
        end)
    end

    ValBtn.MouseButton1Click:Connect(function()
        open = not open
        if open then
            DropFrame.Visible = true
            DropFrame.Size    = UDim2.new(0, 120, 0, 0)
            Tween(DropFrame, { Size = UDim2.new(0, 120, 0, math.min(totalH + 10, 160)) }, 0.18, Enum.EasingStyle.Back)
            Tween(Arrow, { Rotation = 180 }, 0.15)
        else
            Tween(DropFrame, { Size = UDim2.new(0, 120, 0, 0) }, 0.15)
            task.delay(0.16, function() DropFrame.Visible = false end)
            Tween(Arrow, { Rotation = 0 }, 0.15)
        end
    end)

    return {
        Set = function(v)
            val = v; ValBtn.Text = v
            if callback then callback(val) end
        end,
        Get = function() return val end,
    }
end

-- ── Input ──────────────────────────────────────────────
function _TabMethods:AddInput(title, placeholder, callback, description)
    local T  = self._window._theme
    local val = ""

    local row = Make("Frame", {
        Size             = UDim2.new(1, 0, 0, description and 64 or 54),
        BackgroundColor3 = T.Surface,
        BorderSizePixel  = 0,
    }, self._scroll)
    MakeCorner(row, 6)
    MakePadding(row, 8, 8, 12, 12)

    Make("TextLabel", {
        Text             = title,
        Font             = Enum.Font.GothamSemibold,
        TextSize         = 13,
        TextColor3       = T.Text,
        Size             = UDim2.new(0.5, 0, 0, 18),
        BackgroundTransparency = 1,
        TextXAlignment   = Enum.TextXAlignment.Left,
    }, row)

    if description then
        Make("TextLabel", {
            Text             = description,
            Font             = Enum.Font.Gotham,
            TextSize         = 11,
            TextColor3       = T.TextMuted,
            Size             = UDim2.new(1, 0, 0, 14),
            Position         = UDim2.new(0, 0, 0, 20),
            BackgroundTransparency = 1,
            TextXAlignment   = Enum.TextXAlignment.Left,
        }, row)
    end

    local Box = Make("TextBox", {
        Text             = "",
        PlaceholderText  = placeholder or "Enter value...",
        Font             = Enum.Font.Gotham,
        TextSize         = 12,
        TextColor3       = T.Text,
        PlaceholderColor3 = T.TextMuted,
        Size             = UDim2.new(0, 150, 0, 28),
        Position         = UDim2.new(1, -150, 0.5, -14),
        BackgroundColor3 = T.SurfaceAlt,
        BorderSizePixel  = 0,
        ClearTextOnFocus = false,
        TextXAlignment   = Enum.TextXAlignment.Left,
    }, row)
    MakeCorner(Box, 5)
    MakeStroke(Box, T.Border, 1)
    MakePadding(Box, 0, 0, 8, 8)

    Box.Focused:Connect(function()
        Tween(Box, { BackgroundColor3 = T.Background }, 0.12)
        Tween(Box:FindFirstChildWhichIsA("UIStroke") or Box, { Color = T.Accent }, 0.12)
    end)
    Box.FocusLost:Connect(function(enter)
        val = Box.Text
        Tween(Box, { BackgroundColor3 = T.SurfaceAlt }, 0.12)
        if callback then callback(val) end
    end)

    return {
        Set = function(v) val = v; Box.Text = v end,
        Get = function() return val end,
    }
end

-- ── Colorpicker ────────────────────────────────────────
function _TabMethods:AddColorpicker(title, default, callback)
    local T   = self._window._theme
    local val = default or Color3.fromRGB(255, 255, 255)

    local row = Make("Frame", {
        Size             = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = T.Surface,
        BorderSizePixel  = 0,
    }, self._scroll)
    MakeCorner(row, 6)
    MakePadding(row, 0, 0, 12, 12)

    Make("TextLabel", {
        Text             = title,
        Font             = Enum.Font.GothamSemibold,
        TextSize         = 13,
        TextColor3       = T.Text,
        Size             = UDim2.new(1, -100, 1, 0),
        BackgroundTransparency = 1,
        TextXAlignment   = Enum.TextXAlignment.Left,
    }, row)

    -- Color preview swatch + open button
    local Swatch = Make("TextButton", {
        Text             = "",
        Size             = UDim2.new(0, 80, 0, 24),
        Position         = UDim2.new(1, -80, 0.5, -12),
        BackgroundColor3 = val,
        BorderSizePixel  = 0,
        AutoButtonColor  = false,
    }, row)
    MakeCorner(Swatch, 5)
    MakeStroke(Swatch, T.Border, 1)

    -- Inline simple HSV picker panel
    local Panel = Make("Frame", {
        Size             = UDim2.new(0, 200, 0, 0),
        Position         = UDim2.new(1, -200, 1, 6),
        BackgroundColor3 = T.SurfaceAlt,
        BorderSizePixel  = 0,
        ClipsDescendants = true,
        ZIndex           = 20,
        Visible          = false,
    }, row)
    MakeCorner(Panel, 7)
    MakeStroke(Panel, T.Border, 1)
    MakePadding(Panel, 10, 10, 10, 10)

    local hue, sat, brt = Color3.toHSV(val)

    -- Hue bar
    local HueBar = Make("Frame", {
        Size             = UDim2.new(1, 0, 0, 14),
        Position         = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel  = 0,
        ZIndex           = 21,
    }, Panel)
    MakeCorner(HueBar, 4)

    -- Hue gradient
    local HueGrad = Make("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,    Color3.fromRGB(255,0,0)),
            ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255,255,0)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,255,0)),
            ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(0,255,255)),
            ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0,0,255)),
            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255,0,255)),
            ColorSequenceKeypoint.new(1,    Color3.fromRGB(255,0,0)),
        }),
    }, HueBar)

    local HueKnob = Make("Frame", {
        Size             = UDim2.new(0, 8, 1, 2),
        Position         = UDim2.new(hue, -4, 0, -1),
        BackgroundColor3 = Color3.fromRGB(255,255,255),
        BorderSizePixel  = 0,
        ZIndex           = 22,
    }, HueBar)
    MakeCorner(HueKnob, 3)
    MakeStroke(HueKnob, Color3.fromRGB(0,0,0), 1)

    -- Saturation/Brightness 2D pad
    local SBPad = Make("Frame", {
        Size             = UDim2.new(1, 0, 0, 90),
        Position         = UDim2.new(0, 0, 0, 22),
        BackgroundColor3 = Color3.fromHSV(hue, 1, 1),
        BorderSizePixel  = 0,
        ZIndex           = 21,
    }, Panel)
    MakeCorner(SBPad, 4)

    Make("UIGradient", {
        Color       = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255)),
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1),
        }),
    }, SBPad)

    local DarkOverlay = Make("Frame", {
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0,0,0),
        BackgroundTransparency = 0.01,
        BorderSizePixel  = 0,
        ZIndex           = 21,
    }, SBPad)
    MakeCorner(DarkOverlay, 4)

    Make("UIGradient", {
        Color       = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0,0,0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0)),
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0),
        }),
        Rotation     = 90,
    }, DarkOverlay)

    local SBKnob = Make("Frame", {
        Size             = UDim2.new(0, 12, 0, 12),
        Position         = UDim2.new(sat, -6, 1 - brt, -6),
        BackgroundColor3 = Color3.fromRGB(255,255,255),
        BorderSizePixel  = 0,
        ZIndex           = 23,
    }, SBPad)
    MakeCorner(SBKnob, 99)
    MakeStroke(SBKnob, Color3.fromRGB(0,0,0), 1)

    -- Hex input
    local function colorToHex(c)
        return string.format("#%02X%02X%02X", c.R*255, c.G*255, c.B*255)
    end
    local function hexToColor(h)
        h = h:gsub("#","")
        local r,g,b = tonumber(h:sub(1,2),16), tonumber(h:sub(3,4),16), tonumber(h:sub(5,6),16)
        if r and g and b then return Color3.fromRGB(r,g,b) end
    end

    local HexBox = Make("TextBox", {
        Text             = colorToHex(val),
        Font             = Enum.Font.Code,
        TextSize         = 12,
        TextColor3       = T.Text,
        Size             = UDim2.new(1, 0, 0, 24),
        Position         = UDim2.new(0, 0, 0, 120),
        BackgroundColor3 = T.Background,
        BorderSizePixel  = 0,
        TextXAlignment   = Enum.TextXAlignment.Center,
        ZIndex           = 22,
    }, Panel)
    MakeCorner(HexBox, 4)
    MakePadding(HexBox, 0, 0, 6, 6)

    local function updateColor()
        val = Color3.fromHSV(hue, sat, brt)
        Swatch.BackgroundColor3 = val
        SBPad.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
        SBKnob.Position = UDim2.new(sat, -6, 1 - brt, -6)
        HueKnob.Position = UDim2.new(hue, -4, 0, -1)
        HexBox.Text = colorToHex(val)
        if callback then callback(val) end
    end

    -- Dragging hue
    local hueDrag = false
    HueBar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            hueDrag = true
            hue = math.clamp((inp.Position.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1)
            updateColor()
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if hueDrag and inp.UserInputType == Enum.UserInputType.MouseMovement then
            hue = math.clamp((inp.Position.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1)
            updateColor()
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            hueDrag = false; sbDrag = false
        end
    end)

    -- Dragging SB
    local sbDrag = false
    SBPad.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            sbDrag = true
            sat = math.clamp((inp.Position.X - SBPad.AbsolutePosition.X) / SBPad.AbsoluteSize.X, 0, 1)
            brt = 1 - math.clamp((inp.Position.Y - SBPad.AbsolutePosition.Y) / SBPad.AbsoluteSize.Y, 0, 1)
            updateColor()
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if sbDrag and inp.UserInputType == Enum.UserInputType.MouseMovement then
            sat = math.clamp((inp.Position.X - SBPad.AbsolutePosition.X) / SBPad.AbsoluteSize.X, 0, 1)
            brt = 1 - math.clamp((inp.Position.Y - SBPad.AbsolutePosition.Y) / SBPad.AbsoluteSize.Y, 0, 1)
            updateColor()
        end
    end)

    HexBox.FocusLost:Connect(function()
        local c = hexToColor(HexBox.Text)
        if c then
            val = c; hue, sat, brt = Color3.toHSV(c)
            Swatch.BackgroundColor3 = val
            updateColor()
        end
    end)

    local panelOpen = false
    Swatch.MouseButton1Click:Connect(function()
        panelOpen = not panelOpen
        if panelOpen then
            Panel.Visible = true
            Tween(Panel, { Size = UDim2.new(0, 200, 0, 155) }, 0.2, Enum.EasingStyle.Back)
        else
            Tween(Panel, { Size = UDim2.new(0, 200, 0, 0) }, 0.15)
            task.delay(0.16, function() Panel.Visible = false end)
        end
    end)

    return {
        Set = function(c) val=c; hue,sat,brt=Color3.toHSV(c); updateColor() end,
        Get = function() return val end,
    }
end


-- ══════════════════════════════════════════════════════════════════════════════
--  FIBER.CC — EXTENDED COMPONENT LIBRARY
--  Appended below the core. All methods added to _TabMethods + Fiber.
-- ══════════════════════════════════════════════════════════════════════════════

-- ── Label ─────────────────────────────────────────────────────────────────────
-- Tab:AddLabel("Hello world", "accent")
-- styles: normal | muted | accent | success | warn | error
function _TabMethods:AddLabel(text, style)
    local T = self._window._theme
    local cols = {
        normal  = T.Text,
        muted   = T.TextMuted,
        accent  = T.Accent,
        success = Color3.fromRGB(80,220,100),
        warn    = Color3.fromRGB(255,200,50),
        error   = Color3.fromRGB(255,80,80),
    }
    local lbl = Make("TextLabel", {
        Text             = text or "",
        Font             = Enum.Font.Gotham,
        TextSize         = 12,
        TextColor3       = cols[style or "muted"] or T.TextMuted,
        Size             = UDim2.new(1, 0, 0, 24),
        BackgroundTransparency = 1,
        BorderSizePixel  = 0,
        TextXAlignment   = Enum.TextXAlignment.Left,
        TextWrapped      = true,
    }, self._scroll)
    MakePadding(lbl, 0, 0, 12, 12)
    return {
        Set      = function(t) lbl.Text = t end,
        SetStyle = function(s) lbl.TextColor3 = cols[s] or T.TextMuted end,
        Get      = function() return lbl.Text end,
    }
end

-- ── Divider ───────────────────────────────────────────────────────────────────
-- Tab:AddDivider()
-- Tab:AddDivider("Section name")
function _TabMethods:AddDivider(label)
    local T = self._window._theme
    local h = label and 28 or 12
    local frame = Make("Frame", {
        Size             = UDim2.new(1, 0, 0, h),
        BackgroundTransparency = 1,
        BorderSizePixel  = 0,
    }, self._scroll)
    Make("Frame", {
        Size             = UDim2.new(1, -24, 0, 1),
        Position         = UDim2.new(0, 12, 0.5, 0),
        BackgroundColor3 = T.Border,
        BorderSizePixel  = 0,
    }, frame)
    if label then
        local txt = Make("TextLabel", {
            Text             = label,
            Font             = Enum.Font.Gotham,
            TextSize         = 11,
            TextColor3       = T.TextMuted,
            AutomaticSize    = Enum.AutomaticSize.X,
            Size             = UDim2.new(0, 0, 0, 16),
            Position         = UDim2.new(0.5, 0, 0.5, -8),
            BackgroundColor3 = T.Background,
            BorderSizePixel  = 0,
            TextXAlignment   = Enum.TextXAlignment.Center,
        }, frame)
        MakePadding(txt, 0, 0, 6, 6)
    end
end

-- ── Spacer ────────────────────────────────────────────────────────────────────
-- Tab:AddSpacer(16)
function _TabMethods:AddSpacer(height)
    Make("Frame", {
        Size             = UDim2.new(1, 0, 0, height or 8),
        BackgroundTransparency = 1,
        BorderSizePixel  = 0,
    }, self._scroll)
end

-- ── Badge / Stat Card ─────────────────────────────────────────────────────────
-- local b = Tab:AddBadge("Players Online", "24", "accent")
-- b.SetValue("32")
function _TabMethods:AddBadge(title, value, style)
    local T = self._window._theme
    local cols = {
        accent  = T.Accent,
        success = Color3.fromRGB(80,220,100),
        warn    = Color3.fromRGB(255,200,50),
        error   = Color3.fromRGB(255,80,80),
        muted   = T.TextMuted,
    }
    local col = cols[style or "accent"] or T.Accent
    local row = Make("Frame", {
        Size             = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = T.Surface,
        BorderSizePixel  = 0,
    }, self._scroll)
    MakeCorner(row, 6)
    MakePadding(row, 0, 0, 12, 12)
    local bar = Make("Frame", {
        Size             = UDim2.new(0, 3, 0.6, 0),
        Position         = UDim2.new(0, 0, 0.2, 0),
        BackgroundColor3 = col, BorderSizePixel = 0,
    }, row)
    MakeCorner(bar, 3)
    Make("TextLabel", {
        Text = title, Font = Enum.Font.Gotham, TextSize = 12,
        TextColor3 = T.TextMuted, Size = UDim2.new(0.55, 0, 1, 0),
        BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
    local valLbl = Make("TextLabel", {
        Text = tostring(value), Font = Enum.Font.GothamBold, TextSize = 13,
        TextColor3 = col, Size = UDim2.new(0.45, 0, 1, 0),
        Position = UDim2.new(0.55, 0, 0, 0),
        BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Right,
    }, row)
    return {
        SetValue = function(v) valLbl.Text = tostring(v) end,
        SetStyle = function(s)
            local c = cols[s] or T.Accent
            valLbl.TextColor3 = c; bar.BackgroundColor3 = c
        end,
        Get = function() return valLbl.Text end,
    }
end

-- ── Live Value ────────────────────────────────────────────────────────────────
-- local lv = Tab:AddLiveValue("Ping", "—")
-- lv.Set("24 ms")
function _TabMethods:AddLiveValue(title, initial)
    local T = self._window._theme
    local row = Make("Frame", {
        Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = T.Surface, BorderSizePixel = 0,
    }, self._scroll)
    MakeCorner(row, 6); MakePadding(row, 0, 0, 12, 12)
    Make("TextLabel", {
        Text = title, Font = Enum.Font.Gotham, TextSize = 12,
        TextColor3 = T.TextMuted, Size = UDim2.new(0.55, 0, 1, 0),
        BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
    local valLbl = Make("TextLabel", {
        Text = tostring(initial or "—"), Font = Enum.Font.GothamBold, TextSize = 13,
        TextColor3 = T.Accent, Size = UDim2.new(0.45, 0, 1, 0),
        Position = UDim2.new(0.55, 0, 0, 0),
        BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Right,
    }, row)
    return {
        Set = function(v) valLbl.Text = tostring(v) end,
        Get = function() return valLbl.Text end,
    }
end

-- ── Progress Bar ──────────────────────────────────────────────────────────────
-- local pb = Tab:AddProgressBar("Loading", 0)
-- pb.Set(0.75)  -- 0.0 to 1.0
function _TabMethods:AddProgressBar(title, default, description)
    local T = self._window._theme
    local val = math.clamp(default or 0, 0, 1)
    local row = Make("Frame", {
        Size = UDim2.new(1, 0, 0, description and 62 or 48),
        BackgroundColor3 = T.Surface, BorderSizePixel = 0,
    }, self._scroll)
    MakeCorner(row, 6); MakePadding(row, 8, 8, 12, 12)
    local top = Make("Frame", {
        Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, BorderSizePixel = 0,
    }, row)
    Make("TextLabel", {
        Text = title, Font = Enum.Font.GothamSemibold, TextSize = 13,
        TextColor3 = T.Text, Size = UDim2.new(1, -44, 1, 0),
        BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
    }, top)
    local pct = Make("TextLabel", {
        Text = string.format("%.0f%%", val*100), Font = Enum.Font.GothamBold, TextSize = 12,
        TextColor3 = T.Accent, Size = UDim2.new(0, 42, 1, 0),
        Position = UDim2.new(1,-42,0,0), BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Right,
    }, top)
    if description then
        Make("TextLabel", {
            Text = description, Font = Enum.Font.Gotham, TextSize = 11,
            TextColor3 = T.TextMuted, Size = UDim2.new(1,0,0,14),
            Position = UDim2.new(0,0,0,18), BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, row)
    end
    local track = Make("Frame", {
        Size = UDim2.new(1,0,0,6), Position = UDim2.new(0,0,1,-14),
        BackgroundColor3 = T.Slider, BorderSizePixel = 0,
    }, row)
    MakeCorner(track, 3)
    local fill = Make("Frame", {
        Size = UDim2.new(val,0,1,0), BackgroundColor3 = T.Accent, BorderSizePixel = 0,
    }, track)
    MakeCorner(fill, 3)
    return {
        Set = function(v)
            val = math.clamp(v, 0, 1)
            Tween(fill, {Size=UDim2.new(val,0,1,0)}, 0.2)
            pct.Text = string.format("%.0f%%", val*100)
        end,
        Get = function() return val end,
    }
end

-- ── Info Card ─────────────────────────────────────────────────────────────────
-- Tab:AddInfoCard("⚠ Warning", "This may cause lag", "warn")
-- styles: info | success | warn | error | accent
function _TabMethods:AddInfoCard(title, body, style)
    local T = self._window._theme
    local cols = {
        accent  = T.Accent,
        success = Color3.fromRGB(80,220,100),
        warn    = Color3.fromRGB(255,200,50),
        error   = Color3.fromRGB(255,80,80),
        info    = Color3.fromRGB(80,160,255),
    }
    local col = cols[style or "info"] or T.Accent
    local card = Make("Frame", {
        Size = UDim2.new(1,0,0,52), BackgroundColor3 = T.Surface, BorderSizePixel = 0,
    }, self._scroll)
    MakeCorner(card, 6); MakePadding(card, 8, 8, 14, 12)
    local bar = Make("Frame", {
        Size = UDim2.new(0,3,1,-16), Position = UDim2.new(0,0,0,8),
        BackgroundColor3 = col, BorderSizePixel = 0,
    }, card)
    MakeCorner(bar, 3)
    Make("TextLabel", {
        Text = title, Font = Enum.Font.GothamBold, TextSize = 12,
        TextColor3 = col, Size = UDim2.new(1,-10,0,16),
        Position = UDim2.new(0,10,0,0), BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
    Make("TextLabel", {
        Text = body or "", Font = Enum.Font.Gotham, TextSize = 11,
        TextColor3 = T.TextMuted, Size = UDim2.new(1,-10,0,18),
        Position = UDim2.new(0,10,0,18), BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
    }, card)
end

-- ── Keybind ───────────────────────────────────────────────────────────────────
-- local kb = Tab:AddKeybind("Toggle ESP", Enum.KeyCode.F, function(key) end)
function _TabMethods:AddKeybind(title, default, callback, description)
    local T = self._window._theme
    local current = default or Enum.KeyCode.Unknown
    local binding = false
    local row = Make("Frame", {
        Size = UDim2.new(1,0,0, description and 54 or 40),
        BackgroundColor3 = T.Surface, BorderSizePixel = 0,
    }, self._scroll)
    MakeCorner(row, 6); MakePadding(row, 0, 0, 12, 12)
    Make("TextLabel", {
        Text = title, Font = Enum.Font.GothamSemibold, TextSize = 13,
        TextColor3 = T.Text, Size = UDim2.new(1,-90,0,20),
        Position = UDim2.new(0,0,0, description and 8 or 10),
        BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
    if description then
        Make("TextLabel", {
            Text = description, Font = Enum.Font.Gotham, TextSize = 11,
            TextColor3 = T.TextMuted, Size = UDim2.new(1,-90,0,16),
            Position = UDim2.new(0,0,0,28), BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, row)
    end
    local KeyBtn = Make("TextButton", {
        Text = current.Name, Font = Enum.Font.GothamBold, TextSize = 11,
        TextColor3 = T.Accent, Size = UDim2.new(0,80,0,26),
        Position = UDim2.new(1,-80,0.5,-13),
        BackgroundColor3 = T.SurfaceAlt, BorderSizePixel = 0, AutoButtonColor = false,
    }, row)
    MakeCorner(KeyBtn, 5); MakeStroke(KeyBtn, T.Accent, 1)
    KeyBtn.MouseButton1Click:Connect(function()
        binding = true; KeyBtn.Text = "..."; KeyBtn.TextColor3 = T.TextMuted
    end)
    UserInputService.InputBegan:Connect(function(inp, gp)
        if not binding then return end
        if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
        binding = false; current = inp.KeyCode
        KeyBtn.Text = current.Name; KeyBtn.TextColor3 = T.Accent
        if callback then callback(current) end
    end)
    return {
        Get = function() return current end,
        Set = function(k) current = k; KeyBtn.Text = k.Name end,
    }
end

-- ── Number Input (stepper) ────────────────────────────────────────────────────
-- local n = Tab:AddNumberInput("Damage", 0, 1000, 50, function(v) end)
function _TabMethods:AddNumberInput(title, min, max, default, callback, description)
    local T = self._window._theme
    min = min or 0; max = max or 100
    local val = math.clamp(default or min, min, max)
    local row = Make("Frame", {
        Size = UDim2.new(1,0,0, description and 54 or 40),
        BackgroundColor3 = T.Surface, BorderSizePixel = 0,
    }, self._scroll)
    MakeCorner(row, 6); MakePadding(row, 0, 0, 12, 12)
    Make("TextLabel", {
        Text = title, Font = Enum.Font.GothamSemibold, TextSize = 13,
        TextColor3 = T.Text, Size = UDim2.new(0.5,0,0,20),
        Position = UDim2.new(0,0,0, description and 8 or 10),
        BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
    if description then
        Make("TextLabel", {
            Text = description, Font = Enum.Font.Gotham, TextSize = 11,
            TextColor3 = T.TextMuted, Size = UDim2.new(0.5,0,0,16),
            Position = UDim2.new(0,0,0,28), BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, row)
    end
    local grp = Make("Frame", {
        Size = UDim2.new(0,110,0,28), Position = UDim2.new(1,-110,0.5,-14),
        BackgroundTransparency = 1, BorderSizePixel = 0,
    }, row)
    local minus = Make("TextButton", {
        Text = "−", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = T.Text,
        Size = UDim2.new(0,28,1,0), BackgroundColor3 = T.SurfaceAlt,
        BorderSizePixel = 0, AutoButtonColor = false,
    }, grp); MakeCorner(minus, 5)
    local box = Make("TextBox", {
        Text = tostring(val), Font = Enum.Font.GothamBold, TextSize = 13,
        TextColor3 = T.Accent, Size = UDim2.new(1,-60,1,0),
        Position = UDim2.new(0,32,0,0), BackgroundColor3 = T.Background,
        BorderSizePixel = 0, TextXAlignment = Enum.TextXAlignment.Center,
        ClearTextOnFocus = false,
    }, grp); MakeCorner(box, 4)
    local plus = Make("TextButton", {
        Text = "+", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = T.Text,
        Size = UDim2.new(0,28,1,0), Position = UDim2.new(1,-28,0,0),
        BackgroundColor3 = T.SurfaceAlt, BorderSizePixel = 0, AutoButtonColor = false,
    }, grp); MakeCorner(plus, 5)
    local function setVal(v)
        val = math.clamp(v, min, max); box.Text = tostring(val)
        if callback then callback(val) end
    end
    minus.MouseButton1Click:Connect(function() setVal(val-1) end)
    plus.MouseButton1Click:Connect(function()  setVal(val+1) end)
    box.FocusLost:Connect(function()
        local n = tonumber(box.Text)
        if n then setVal(n) else box.Text = tostring(val) end
    end)
    for _, b in ipairs({minus, plus}) do
        b.MouseEnter:Connect(function() Tween(b,{BackgroundColor3=T.Accent},0.1) end)
        b.MouseLeave:Connect(function() Tween(b,{BackgroundColor3=T.SurfaceAlt},0.1) end)
    end
    return { Get=function() return val end, Set=function(v) setVal(v) end }
end

-- ── Checkbox ──────────────────────────────────────────────────────────────────
-- Tab:AddCheckbox("Options", {"Fly","Speed","God"}, {"Speed"}, function(t) end)
function _TabMethods:AddCheckbox(title, options, defaults, callback)
    local T = self._window._theme
    local checked = {}
    if defaults then for _, v in ipairs(defaults) do checked[v] = true end end
    local rowH = 34 + #options * 30
    local row = Make("Frame", {
        Size = UDim2.new(1,0,0,rowH), BackgroundColor3 = T.Surface, BorderSizePixel = 0,
    }, self._scroll)
    MakeCorner(row, 6); MakePadding(row, 8, 8, 12, 12)
    Make("TextLabel", {
        Text = title, Font = Enum.Font.GothamSemibold, TextSize = 13,
        TextColor3 = T.Text, Size = UDim2.new(1,0,0,18),
        BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
    local function fireCallback()
        local r = {}
        for k, v in pairs(checked) do if v then table.insert(r, k) end end
        if callback then callback(r) end
    end
    for i, opt in ipairs(options) do
        local item = Make("Frame", {
            Size = UDim2.new(1,0,0,26), Position = UDim2.new(0,0,0,22+(i-1)*28),
            BackgroundTransparency = 1, BorderSizePixel = 0,
        }, row)
        local box = Make("Frame", {
            Size = UDim2.new(0,16,0,16), Position = UDim2.new(0,0,0.5,-8),
            BackgroundColor3 = checked[opt] and T.Accent or T.Toggle, BorderSizePixel = 0,
        }, item); MakeCorner(box, 4); MakeStroke(box, T.Border, 1)
        local tick = Make("TextLabel", {
            Text = checked[opt] and "✓" or "", Font = Enum.Font.GothamBold, TextSize = 11,
            TextColor3 = Color3.fromRGB(255,255,255), Size = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Center,
        }, box)
        Make("TextLabel", {
            Text = opt, Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = T.Text,
            Size = UDim2.new(1,-24,1,0), Position = UDim2.new(0,24,0,0),
            BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
        }, item)
        Make("TextButton", {
            Text = "", Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, BorderSizePixel = 0,
        }, item).MouseButton1Click:Connect(function()
            checked[opt] = not checked[opt]
            Tween(box, {BackgroundColor3 = checked[opt] and T.Accent or T.Toggle}, 0.12)
            tick.Text = checked[opt] and "✓" or ""
            fireCallback()
        end)
    end
    return {
        GetChecked = function()
            local r = {} for k,v in pairs(checked) do if v then table.insert(r,k) end end return r
        end,
        SetChecked = function(opt, v) checked[opt] = v end,
    }
end

-- ── Radio ─────────────────────────────────────────────────────────────────────
-- Tab:AddRadio("Mode", {"PvP","PvE","Sandbox"}, "PvP", function(v) end)
function _TabMethods:AddRadio(title, options, default, callback)
    local T = self._window._theme
    local val = default or options[1]
    local knobs = {}
    local rowH = 34 + #options * 30
    local row = Make("Frame", {
        Size = UDim2.new(1,0,0,rowH), BackgroundColor3 = T.Surface, BorderSizePixel = 0,
    }, self._scroll)
    MakeCorner(row, 6); MakePadding(row, 8, 8, 12, 12)
    Make("TextLabel", {
        Text = title, Font = Enum.Font.GothamSemibold, TextSize = 13,
        TextColor3 = T.Text, Size = UDim2.new(1,0,0,18),
        BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
    local function refresh()
        for opt, k in pairs(knobs) do
            Tween(k.outer, {BackgroundColor3 = opt==val and T.Accent or T.Toggle}, 0.12)
            Tween(k.inner, {BackgroundTransparency = opt==val and 0 or 1}, 0.12)
        end
    end
    for i, opt in ipairs(options) do
        local item = Make("Frame", {
            Size = UDim2.new(1,0,0,26), Position = UDim2.new(0,0,0,22+(i-1)*28),
            BackgroundTransparency = 1, BorderSizePixel = 0,
        }, row)
        local outer = Make("Frame", {
            Size = UDim2.new(0,16,0,16), Position = UDim2.new(0,0,0.5,-8),
            BackgroundColor3 = opt==val and T.Accent or T.Toggle, BorderSizePixel = 0,
        }, item); MakeCorner(outer, 99); MakeStroke(outer, T.Border, 1)
        local inner = Make("Frame", {
            Size = UDim2.new(0,8,0,8), Position = UDim2.new(0.5,-4,0.5,-4),
            BackgroundColor3 = Color3.fromRGB(255,255,255),
            BackgroundTransparency = opt==val and 0 or 1, BorderSizePixel = 0,
        }, outer); MakeCorner(inner, 99)
        knobs[opt] = {outer=outer, inner=inner}
        Make("TextLabel", {
            Text = opt, Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = T.Text,
            Size = UDim2.new(1,-24,1,0), Position = UDim2.new(0,24,0,0),
            BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
        }, item)
        Make("TextButton", {
            Text = "", Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, BorderSizePixel = 0,
        }, item).MouseButton1Click:Connect(function()
            val = opt; refresh(); if callback then callback(val) end
        end)
    end
    return {
        Get = function() return val end,
        Set = function(v) val=v; refresh(); if callback then callback(val) end end,
    }
end

-- ── Multi-Select Dropdown ─────────────────────────────────────────────────────
-- Tab:AddMultiDropdown("Flags", {"Fly","Speed","God"}, {}, function(t) end)
function _TabMethods:AddMultiDropdown(title, options, defaults, callback, description)
    local T = self._window._theme
    local selected = {}
    if defaults then for _, v in ipairs(defaults) do selected[v] = true end end
    local open = false
    local row = Make("Frame", {
        Size = UDim2.new(1,0,0, description and 62 or 52),
        BackgroundColor3 = T.Surface, BorderSizePixel = 0, ZIndex = 2, ClipsDescendants = false,
    }, self._scroll)
    MakeCorner(row, 6); MakePadding(row, 8, 8, 12, 12)
    Make("TextLabel", {
        Text = title, Font = Enum.Font.GothamSemibold, TextSize = 13,
        TextColor3 = T.Text, Size = UDim2.new(1,-130,0,18),
        BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
    if description then
        Make("TextLabel", {
            Text = description, Font = Enum.Font.Gotham, TextSize = 11,
            TextColor3 = T.TextMuted, Size = UDim2.new(1,-130,0,14),
            Position = UDim2.new(0,0,0,22), BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, row)
    end
    local function getLabel()
        local sel = {} for k,v in pairs(selected) do if v then table.insert(sel,k) end end
        if #sel==0 then return "None" end
        if #sel==1 then return sel[1] end
        return sel[1].." +"..(#sel-1)
    end
    local valBtn = Make("TextButton", {
        Text = getLabel(), Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = T.Text,
        Size = UDim2.new(0,120,0,28), Position = UDim2.new(1,-120,0.5,-14),
        BackgroundColor3 = T.SurfaceAlt, BorderSizePixel = 0, AutoButtonColor = false,
        ZIndex = 3, TextTruncate = Enum.TextTruncate.AtEnd,
    }, row); MakeCorner(valBtn, 5); MakeStroke(valBtn, T.Border, 1)
    local arrow = Make("TextLabel", {
        Text = "▾", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = T.TextMuted,
        Size = UDim2.new(0,18,1,0), Position = UDim2.new(1,-20,0,0),
        BackgroundTransparency = 1, ZIndex = 4,
    }, valBtn)
    local drop = Make("Frame", {
        Size = UDim2.new(0,120,0,0), Position = UDim2.new(1,-120,1,4),
        BackgroundColor3 = T.SurfaceAlt, BorderSizePixel = 0,
        ClipsDescendants = true, ZIndex = 10, Visible = false,
    }, row); MakeCorner(drop, 6); MakeStroke(drop, T.Border, 1)
    MakePadding(drop, 4, 4, 6, 6); MakeList(drop, 2)
    local ticks = {}
    for _, opt in ipairs(options) do
        local orow = Make("Frame", {
            Size = UDim2.new(1,0,0,24), BackgroundColor3 = T.SurfaceAlt, BorderSizePixel = 0, ZIndex = 11,
        }, drop); MakeCorner(orow, 4)
        local tick = Make("Frame", {
            Size = UDim2.new(0,12,0,12), Position = UDim2.new(0,4,0.5,-6),
            BackgroundColor3 = selected[opt] and T.Accent or T.Border, BorderSizePixel = 0, ZIndex = 12,
        }, orow); MakeCorner(tick, 3)
        Make("TextLabel", {
            Text = opt, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = T.Text,
            Size = UDim2.new(1,-22,1,0), Position = UDim2.new(0,20,0,0),
            BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 12,
        }, orow)
        ticks[opt] = tick
        Make("TextButton", {
            Text="", Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, BorderSizePixel=0, ZIndex=13,
        }, orow).MouseButton1Click:Connect(function()
            selected[opt] = not selected[opt]
            Tween(tick, {BackgroundColor3 = selected[opt] and T.Accent or T.Border}, 0.1)
            valBtn.Text = getLabel()
            local r = {} for k,v in pairs(selected) do if v then table.insert(r,k) end end
            if callback then callback(r) end
        end)
    end
    valBtn.MouseButton1Click:Connect(function()
        open = not open
        if open then
            drop.Visible = true
            Tween(drop, {Size=UDim2.new(0,120,0,math.min(#options*30+10,180))}, 0.18, Enum.EasingStyle.Back)
            Tween(arrow, {Rotation=180}, 0.15)
        else
            Tween(drop, {Size=UDim2.new(0,120,0,0)}, 0.15)
            task.delay(0.16, function() drop.Visible = false end)
            Tween(arrow, {Rotation=0}, 0.15)
        end
    end)
    return {
        GetSelected = function()
            local r={} for k,v in pairs(selected) do if v then table.insert(r,k) end end return r
        end,
        SetSelected = function(opt,v) selected[opt]=v; valBtn.Text=getLabel() end,
    }
end

-- ── Searchable Dropdown ───────────────────────────────────────────────────────
-- Tab:AddSearchDropdown("Teleport", bigLocationList, "Spawn", function(v) end)
function _TabMethods:AddSearchDropdown(title, options, default, callback)
    local T = self._window._theme
    local val = default or options[1]
    local open = false
    local row = Make("Frame", {
        Size = UDim2.new(1,0,0,52), BackgroundColor3 = T.Surface,
        BorderSizePixel = 0, ZIndex = 5, ClipsDescendants = false,
    }, self._scroll)
    MakeCorner(row, 6); MakePadding(row, 8, 8, 12, 12)
    Make("TextLabel", {
        Text = title, Font = Enum.Font.GothamSemibold, TextSize = 13,
        TextColor3 = T.Text, Size = UDim2.new(1,-130,0,18),
        BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
    local valBtn = Make("TextButton", {
        Text = val, Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = T.Text,
        Size = UDim2.new(0,120,0,28), Position = UDim2.new(1,-120,0.5,-14),
        BackgroundColor3 = T.SurfaceAlt, BorderSizePixel = 0, AutoButtonColor = false, ZIndex = 6,
    }, row); MakeCorner(valBtn, 5); MakeStroke(valBtn, T.Border, 1)
    local panel = Make("Frame", {
        Size = UDim2.new(0,200,0,0), Position = UDim2.new(1,-200,1,4),
        BackgroundColor3 = T.SurfaceAlt, BorderSizePixel = 0,
        ClipsDescendants = true, ZIndex = 20, Visible = false,
    }, row); MakeCorner(panel, 6); MakeStroke(panel, T.Border, 1)
    local search = Make("TextBox", {
        Text="", PlaceholderText="Search...", Font=Enum.Font.Gotham, TextSize=12,
        TextColor3=T.Text, PlaceholderColor3=T.TextMuted,
        Size=UDim2.new(1,-12,0,28), Position=UDim2.new(0,6,0,6),
        BackgroundColor3=T.Background, BorderSizePixel=0,
        ClearTextOnFocus=false, ZIndex=21, TextXAlignment=Enum.TextXAlignment.Left,
    }, panel); MakeCorner(search, 4); MakePadding(search, 0, 0, 6, 6)
    local list = Make("ScrollingFrame", {
        Size=UDim2.new(1,-12,0,130), Position=UDim2.new(0,6,0,40),
        BackgroundTransparency=1, BorderSizePixel=0, ScrollBarThickness=2,
        ScrollBarImageColor3=T.Accent, CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y, ZIndex=21,
    }, panel); MakeList(list, 2); MakePadding(list, 2, 2, 0, 0)
    local function buildList(filter)
        for _, c in ipairs(list:GetChildren()) do
            if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
        end
        for _, opt in ipairs(options) do
            if filter=="" or opt:lower():find(filter:lower(),1,true) then
                local b = Make("TextButton", {
                    Text=opt, Font=Enum.Font.Gotham, TextSize=12,
                    TextColor3=opt==val and T.Accent or T.Text,
                    Size=UDim2.new(1,0,0,24), BackgroundColor3=T.SurfaceAlt,
                    BorderSizePixel=0, AutoButtonColor=false, ZIndex=22,
                    TextXAlignment=Enum.TextXAlignment.Left,
                }, list); MakeCorner(b,3); MakePadding(b,0,0,6,0)
                b.MouseEnter:Connect(function() Tween(b,{BackgroundColor3=T.Border},0.08) end)
                b.MouseLeave:Connect(function() Tween(b,{BackgroundColor3=T.SurfaceAlt},0.08) end)
                b.MouseButton1Click:Connect(function()
                    val=opt; valBtn.Text=opt; open=false
                    Tween(panel,{Size=UDim2.new(0,200,0,0)},0.15)
                    task.delay(0.16,function() panel.Visible=false end)
                    if callback then callback(val) end
                end)
            end
        end
    end
    buildList("")
    search:GetPropertyChangedSignal("Text"):Connect(function() buildList(search.Text) end)
    valBtn.MouseButton1Click:Connect(function()
        open = not open
        if open then
            panel.Visible=true; search.Text=""; buildList("")
            Tween(panel,{Size=UDim2.new(0,200,0,178)},0.18,Enum.EasingStyle.Back)
        else
            Tween(panel,{Size=UDim2.new(0,200,0,0)},0.15)
            task.delay(0.16,function() panel.Visible=false end)
        end
    end)
    return { Get=function() return val end, Set=function(v) val=v; valBtn.Text=v end }
end

-- ── Button Group (segmented control) ─────────────────────────────────────────
-- Tab:AddButtonGroup({"Easy","Medium","Hard"}, "Medium", function(v) end)
function _TabMethods:AddButtonGroup(options, default, callback)
    local T = self._window._theme
    local val = default or options[1]
    local btns = {}
    local row = Make("Frame", {
        Size = UDim2.new(1,0,0,36), BackgroundColor3 = T.Surface, BorderSizePixel = 0,
    }, self._scroll)
    MakeCorner(row, 6); MakePadding(row, 4, 4, 6, 6)
    local bw = 1 / #options
    for i, opt in ipairs(options) do
        local active = opt == val
        local btn = Make("TextButton", {
            Text = opt, Font = active and Enum.Font.GothamBold or Enum.Font.Gotham,
            TextSize = 12, TextColor3 = active and T.Text or T.TextMuted,
            Size = UDim2.new(bw, i==#options and 0 or -4, 1, 0),
            Position = UDim2.new(bw*(i-1), 0, 0, 0),
            BackgroundColor3 = active and T.Accent or T.SurfaceAlt,
            BorderSizePixel = 0, AutoButtonColor = false,
        }, row); MakeCorner(btn, 5)
        btns[opt] = btn
        btn.MouseButton1Click:Connect(function()
            val = opt
            for o, b in pairs(btns) do
                local a = o==val
                Tween(b,{BackgroundColor3=a and T.Accent or T.SurfaceAlt},0.15)
                Tween(b,{TextColor3=a and T.Text or T.TextMuted},0.15)
                b.Font = a and Enum.Font.GothamBold or Enum.Font.Gotham
            end
            if callback then callback(val) end
        end)
    end
    return {
        Get = function() return val end,
        Set = function(v)
            val=v
            for o,b in pairs(btns) do
                local a=o==val
                b.BackgroundColor3=a and T.Accent or T.SurfaceAlt
                b.TextColor3=a and T.Text or T.TextMuted
            end
            if callback then callback(val) end
        end,
    }
end

-- ── Confirm Button ────────────────────────────────────────────────────────────
-- Tab:AddConfirmButton("Delete Save", "Sure?", function() end)
function _TabMethods:AddConfirmButton(title, confirmText, callback, description)
    local T = self._window._theme
    local confirming = false
    local row = Make("Frame", {
        Size = UDim2.new(1,0,0, description and 54 or 40),
        BackgroundColor3 = T.Surface, BorderSizePixel = 0,
    }, self._scroll)
    MakeCorner(row, 6); MakePadding(row, 0, 0, 12, 12)
    Make("TextLabel", {
        Text = title, Font = Enum.Font.GothamSemibold, TextSize = 13,
        TextColor3 = T.Text, Size = UDim2.new(1,-80,0,20),
        Position = UDim2.new(0,0,0, description and 8 or 10),
        BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
    if description then
        Make("TextLabel", {
            Text=description, Font=Enum.Font.Gotham, TextSize=11, TextColor3=T.TextMuted,
            Size=UDim2.new(1,-80,0,16), Position=UDim2.new(0,0,0,28),
            BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left,
        }, row)
    end
    local btn = Make("TextButton", {
        Text="Run", Font=Enum.Font.GothamBold, TextSize=12, TextColor3=T.Text,
        Size=UDim2.new(0,60,0,26), Position=UDim2.new(1,-60,0.5,-13),
        BackgroundColor3=T.Accent, BorderSizePixel=0, AutoButtonColor=false,
    }, row); MakeCorner(btn, 5)
    btn.MouseButton1Click:Connect(function()
        if not confirming then
            confirming=true; btn.Text=confirmText or "Sure?"
            Tween(btn,{BackgroundColor3=Color3.fromRGB(220,60,60)},0.15)
            task.delay(2.5, function()
                if confirming then
                    confirming=false; btn.Text="Run"
                    Tween(btn,{BackgroundColor3=T.Accent},0.15)
                end
            end)
        else
            confirming=false; btn.Text="Run"
            Tween(btn,{BackgroundColor3=T.Accent},0.15)
            if callback then callback() end
        end
    end)
    btn.MouseEnter:Connect(function() if not confirming then Tween(btn,{BackgroundColor3=T.AccentDark},0.12) end end)
    btn.MouseLeave:Connect(function() if not confirming then Tween(btn,{BackgroundColor3=T.Accent},0.12) end end)
end

-- ── Copy Button ───────────────────────────────────────────────────────────────
-- Tab:AddCopyButton("API Key", "fiber-xxxx-yyyy")
function _TabMethods:AddCopyButton(title, value, description)
    local T = self._window._theme
    local row = Make("Frame", {
        Size=UDim2.new(1,0,0, description and 54 or 40),
        BackgroundColor3=T.Surface, BorderSizePixel=0,
    }, self._scroll)
    MakeCorner(row, 6); MakePadding(row, 0, 0, 12, 12)
    Make("TextLabel", {
        Text=title, Font=Enum.Font.GothamSemibold, TextSize=13, TextColor3=T.Text,
        Size=UDim2.new(1,-80,0,20), Position=UDim2.new(0,0,0, description and 8 or 10),
        BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left,
    }, row)
    if description then
        Make("TextLabel", {
            Text=description, Font=Enum.Font.Gotham, TextSize=11, TextColor3=T.TextMuted,
            Size=UDim2.new(1,-80,0,16), Position=UDim2.new(0,0,0,28),
            BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left,
        }, row)
    end
    local btn = Make("TextButton", {
        Text="Copy", Font=Enum.Font.GothamBold, TextSize=12, TextColor3=T.Text,
        Size=UDim2.new(0,60,0,26), Position=UDim2.new(1,-60,0.5,-13),
        BackgroundColor3=T.SurfaceAlt, BorderSizePixel=0, AutoButtonColor=false,
    }, row); MakeCorner(btn,5); MakeStroke(btn, T.Border, 1)
    btn.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard(tostring(value)) end
        btn.Text="✓"; Tween(btn,{BackgroundColor3=Color3.fromRGB(60,180,80)},0.1)
        task.delay(1.5, function() btn.Text="Copy"; Tween(btn,{BackgroundColor3=T.SurfaceAlt},0.15) end)
    end)
    btn.MouseEnter:Connect(function() Tween(btn,{BackgroundColor3=T.Border},0.1) end)
    btn.MouseLeave:Connect(function() Tween(btn,{BackgroundColor3=T.SurfaceAlt},0.1) end)
end

-- ── Accordion / Expandable Group ──────────────────────────────────────────────
-- local acc = Tab:AddAccordion("Advanced")
-- acc:AddToggle("...")   -- same API
function _TabMethods:AddAccordion(title)
    local T = self._window._theme
    local open = false
    local outer = Make("Frame", {
        Size=UDim2.new(1,0,0,36), BackgroundColor3=T.Surface,
        BorderSizePixel=0, ClipsDescendants=true,
    }, self._scroll)
    MakeCorner(outer, 6)
    local header = Make("TextButton", {
        Text="", Size=UDim2.new(1,0,0,36),
        BackgroundTransparency=1, BorderSizePixel=0, AutoButtonColor=false,
    }, outer)
    Make("TextLabel", {
        Text=title, Font=Enum.Font.GothamSemibold, TextSize=13, TextColor3=T.Text,
        Size=UDim2.new(1,-40,1,0), Position=UDim2.new(0,12,0,0),
        BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left,
    }, header)
    local arrow = Make("TextLabel", {
        Text="▸", Font=Enum.Font.GothamBold, TextSize=14, TextColor3=T.TextMuted,
        Size=UDim2.new(0,24,1,0), Position=UDim2.new(1,-30,0,0),
        BackgroundTransparency=1,
    }, header)
    local inner = Make("Frame", {
        Size=UDim2.new(1,0,0,0), Position=UDim2.new(0,0,0,36),
        BackgroundTransparency=1, BorderSizePixel=0, AutomaticSize=Enum.AutomaticSize.Y,
    }, outer)
    MakeList(inner, 4); MakePadding(inner, 4, 6, 8, 8)
    header.MouseButton1Click:Connect(function()
        open = not open
        Tween(arrow, {Rotation=open and 90 or 0}, 0.15)
        if open then
            outer.AutomaticSize = Enum.AutomaticSize.Y
            outer.ClipsDescendants = false
        else
            outer.ClipsDescendants = true
            outer.AutomaticSize = Enum.AutomaticSize.None
            Tween(outer, {Size=UDim2.new(1,0,0,36)}, 0.18)
        end
    end)
    local proxy = {_scroll=inner, _window=self._window}
    setmetatable(proxy, {__index=_TabMethods})
    return proxy
end

-- ── Table / Data Grid ─────────────────────────────────────────────────────────
-- Tab:AddTable("Leaderboard", {"Name","Kills","Deaths"}, {{"Bob",5,2},{"Alice",8,1}})
function _TabMethods:AddTable(title, headers, rows)
    local T = self._window._theme
    local cw = math.floor(100/#headers)/100
    local h = 34 + 28 + #rows*26 + 8
    local wrap = Make("Frame", {
        Size=UDim2.new(1,0,0,h), BackgroundColor3=T.Surface, BorderSizePixel=0,
    }, self._scroll)
    MakeCorner(wrap, 6); MakePadding(wrap, 8, 8, 10, 10)
    Make("TextLabel", {
        Text=title, Font=Enum.Font.GothamSemibold, TextSize=13, TextColor3=T.Text,
        Size=UDim2.new(1,0,0,18), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left,
    }, wrap)
    local hdr = Make("Frame", {
        Size=UDim2.new(1,0,0,24), Position=UDim2.new(0,0,0,22),
        BackgroundColor3=T.SurfaceAlt, BorderSizePixel=0,
    }, wrap); MakeCorner(hdr, 4)
    for i,h in ipairs(headers) do
        Make("TextLabel", {
            Text=h, Font=Enum.Font.GothamBold, TextSize=11, TextColor3=T.Accent,
            Size=UDim2.new(cw,0,1,0), Position=UDim2.new(cw*(i-1),0,0,0),
            BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left,
        }, hdr)
    end
    for ri, row in ipairs(rows) do
        local dr = Make("Frame", {
            Size=UDim2.new(1,0,0,24), Position=UDim2.new(0,0,0,22+26+( ri-1)*26),
            BackgroundColor3=ri%2==0 and T.SurfaceAlt or T.Surface, BorderSizePixel=0,
        }, wrap)
        for ci, cell in ipairs(row) do
            Make("TextLabel", {
                Text=tostring(cell), Font=Enum.Font.Gotham, TextSize=11, TextColor3=T.Text,
                Size=UDim2.new(cw,0,1,0), Position=UDim2.new(cw*(ci-1),0,0,0),
                BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left,
            }, dr)
        end
    end
end

-- ── Tooltip ───────────────────────────────────────────────────────────────────
-- Tab:AddTooltip(anyGuiObject, "Explains what this does")
function _TabMethods:AddTooltip(target, text)
    local T = self._window._theme
    local tt = Make("Frame", {
        Size=UDim2.new(0,0,0,28), BackgroundColor3=T.SurfaceAlt,
        BorderSizePixel=0, ZIndex=50, Visible=false, AutomaticSize=Enum.AutomaticSize.X,
    }, self._window._main)
    MakeCorner(tt,5); MakeStroke(tt, T.Border, 1); MakePadding(tt,0,0,8,8)
    Make("TextLabel", {
        Text=text, Font=Enum.Font.Gotham, TextSize=11, TextColor3=T.Text,
        Size=UDim2.new(0,0,1,0), AutomaticSize=Enum.AutomaticSize.X,
        BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=51,
    }, tt)
    target.MouseEnter:Connect(function()
        tt.Visible=true
        local mp=UserInputService:GetMouseLocation()
        tt.Position=UDim2.new(0,mp.X-self._window._main.AbsolutePosition.X+12,
                                0,mp.Y-self._window._main.AbsolutePosition.Y-34)
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if tt.Visible and inp.UserInputType==Enum.UserInputType.MouseMovement then
            tt.Position=UDim2.new(0,inp.Position.X-self._window._main.AbsolutePosition.X+12,
                                   0,inp.Position.Y-self._window._main.AbsolutePosition.Y-34)
        end
    end)
    target.MouseLeave:Connect(function() tt.Visible=false end)
end

-- ── Dual Slider (range) ───────────────────────────────────────────────────────
-- local ds = Tab:AddDualSlider("Range", 0, 100, 20, 80, function(lo,hi) end)
function _TabMethods:AddDualSlider(title, min, max, defaultLo, defaultHi, callback)
    local T = self._window._theme
    min=min or 0; max=max or 100
    local lo=math.clamp(defaultLo or min,min,max)
    local hi=math.clamp(defaultHi or max,min,max)
    local row=Make("Frame",{
        Size=UDim2.new(1,0,0,58), BackgroundColor3=T.Surface, BorderSizePixel=0,
    },self._scroll); MakeCorner(row,6); MakePadding(row,8,8,12,12)
    Make("TextLabel",{
        Text=title, Font=Enum.Font.GothamSemibold, TextSize=13, TextColor3=T.Text,
        Size=UDim2.new(1,0,0,16), BackgroundTransparency=1,
        TextXAlignment=Enum.TextXAlignment.Left,
    },row)
    local rangeLbl=Make("TextLabel",{
        Text=tostring(lo).." – "..tostring(hi), Font=Enum.Font.GothamBold,TextSize=12,
        TextColor3=T.Accent, Size=UDim2.new(1,0,0,14), Position=UDim2.new(0,0,0,18),
        BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Right,
    },row)
    local track=Make("Frame",{
        Size=UDim2.new(1,0,0,6), Position=UDim2.new(0,0,1,-14),
        BackgroundColor3=T.Slider, BorderSizePixel=0,
    },row); MakeCorner(track,3)
    local fill=Make("Frame",{
        Size=UDim2.new((hi-lo)/(max-min),0,1,0),
        Position=UDim2.new((lo-min)/(max-min),0,0,0),
        BackgroundColor3=T.Accent, BorderSizePixel=0,
    },track); MakeCorner(fill,3)
    local function makeKnob(rel)
        local k=Make("Frame",{
            Size=UDim2.new(0,14,0,14), Position=UDim2.new(rel,-7,0.5,-7),
            BackgroundColor3=Color3.fromRGB(255,255,255), BorderSizePixel=0,
        },track); MakeCorner(k,99); MakeStroke(k,T.Accent,2); return k
    end
    local kLo=makeKnob((lo-min)/(max-min))
    local kHi=makeKnob((hi-min)/(max-min))
    local dragging=nil
    local function refresh()
        local rLo=(lo-min)/(max-min); local rHi=(hi-min)/(max-min)
        Tween(fill,{Size=UDim2.new(rHi-rLo,0,1,0),Position=UDim2.new(rLo,0,0,0)},0.06)
        Tween(kLo,{Position=UDim2.new(rLo,-7,0.5,-7)},0.06)
        Tween(kHi,{Position=UDim2.new(rHi,-7,0.5,-7)},0.06)
        rangeLbl.Text=tostring(lo).." – "..tostring(hi)
        if callback then callback(lo,hi) end
    end
    local function setFromX(x)
        local rel=math.clamp((x-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
        local v=math.floor(min+rel*(max-min)+0.5)
        if dragging=="lo" then lo=math.clamp(v,min,hi) end
        if dragging=="hi" then hi=math.clamp(v,lo,max) end
        refresh()
    end
    kLo.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging="lo" end end)
    kHi.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging="hi" end end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then setFromX(i.Position.X) end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=nil end
    end)
    return {
        Get=function() return lo,hi end,
        Set=function(l,h) lo=l;hi=h;refresh() end,
    }
end

-- ── Color Swatch Row ──────────────────────────────────────────────────────────
-- Quickly pick from a preset palette
-- Tab:AddColorSwatches("Team Color", {Color3.fromRGB(255,0,0),...}, function(c) end)
function _TabMethods:AddColorSwatches(title, colors, callback)
    local T=self._window._theme
    local selected=colors[1]
    local rowH=24+24+8
    local row=Make("Frame",{
        Size=UDim2.new(1,0,0,rowH), BackgroundColor3=T.Surface, BorderSizePixel=0,
    },self._scroll); MakeCorner(row,6); MakePadding(row,6,6,12,12)
    Make("TextLabel",{
        Text=title, Font=Enum.Font.GothamSemibold, TextSize=13, TextColor3=T.Text,
        Size=UDim2.new(1,0,0,18), BackgroundTransparency=1,
        TextXAlignment=Enum.TextXAlignment.Left,
    },row)
    local swatchRow=Make("Frame",{
        Size=UDim2.new(1,0,0,22), Position=UDim2.new(0,0,0,22),
        BackgroundTransparency=1, BorderSizePixel=0,
    },row)
    MakeList(swatchRow,4,Enum.FillDirection.Horizontal)
    local swatches={}
    for _,col in ipairs(colors) do
        local sw=Make("TextButton",{
            Text="", Size=UDim2.new(0,22,0,22), BackgroundColor3=col,
            BorderSizePixel=0, AutoButtonColor=false,
        },swatchRow); MakeCorner(sw,5)
        swatches[col]=sw
        sw.MouseButton1Click:Connect(function()
            selected=col
            for c2,s2 in pairs(swatches) do
                MakeStroke(s2, c2==selected and Color3.fromRGB(255,255,255) or T.Border, c2==selected and 2 or 1)
            end
            if callback then callback(col) end
        end)
    end
    return {Get=function() return selected end}
end

-- ── Image Label ───────────────────────────────────────────────────────────────
-- Tab:AddImage("rbxassetid://XXXXXXX", 100, 50)
function _TabMethods:AddImage(assetId, width, height)
    local T=self._window._theme
    width=width or 200; height=height or 100
    local row=Make("Frame",{
        Size=UDim2.new(1,0,0,height+16), BackgroundColor3=T.Surface, BorderSizePixel=0,
    },self._scroll); MakeCorner(row,6); MakePadding(row,8,8,12,12)
    local img=Make("ImageLabel",{
        Image=assetId or "", Size=UDim2.new(0,width,0,height),
        Position=UDim2.new(0.5,-width/2,0,0),
        BackgroundColor3=T.SurfaceAlt, BorderSizePixel=0,
        ScaleType=Enum.ScaleType.Fit,
    },row); MakeCorner(img,6)
    return {SetImage=function(id) img.Image=id end}
end

-- ── Notification Badge on Window ──────────────────────────────────────────────
-- Window:SetTabBadge("Combat", 3)
function Fiber:SetTabBadge(tabName, count)
    local T=self._theme
    for _,tab in ipairs(self._tabs) do
        if tab._name==tabName then
            local ex=tab._btn:FindFirstChild("_badge")
            if ex then ex:Destroy() end
            if count and count>0 then
                local badge=Make("Frame",{
                    Name="_badge", Size=UDim2.new(0,16,0,16),
                    Position=UDim2.new(1,-6,0,-4),
                    BackgroundColor3=Color3.fromRGB(220,60,60),
                    BorderSizePixel=0, ZIndex=5,
                },tab._btn); MakeCorner(badge,99)
                Make("TextLabel",{
                    Text=tostring(math.min(count,99)), Font=Enum.Font.GothamBold, TextSize=9,
                    TextColor3=Color3.fromRGB(255,255,255), Size=UDim2.new(1,0,1,0),
                    BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Center, ZIndex=6,
                },badge)
            end
            break
        end
    end
end

-- ── Loading Overlay ───────────────────────────────────────────────────────────
-- Window:ShowLoading("Connecting...", 3)
function Fiber:ShowLoading(message, duration)
    local T=self._theme
    local overlay=Make("Frame",{
        Size=UDim2.new(1,0,1,0), BackgroundColor3=T.Background,
        BorderSizePixel=0, ZIndex=100,
    },self._main)
    Make("TextLabel",{
        Text="fiber.cc", Font=Enum.Font.GothamBold, TextSize=22, TextColor3=T.Accent,
        Size=UDim2.new(1,0,0,30), Position=UDim2.new(0,0,0.4,-40),
        BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Center, ZIndex=101,
    },overlay)
    local msgLbl=Make("TextLabel",{
        Text=message or "Loading...", Font=Enum.Font.Gotham, TextSize=13, TextColor3=T.TextMuted,
        Size=UDim2.new(1,0,0,20), Position=UDim2.new(0,0,0.4,0),
        BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Center, ZIndex=101,
    },overlay)
    local spin={"●  ○  ○","○  ●  ○","○  ○  ●","○  ●  ○"}
    local di=1
    local conn=RunService.Heartbeat:Connect(function()
        msgLbl.Text=(message or "Loading").."  "..spin[di]; di=di%#spin+1
    end)
    task.delay(duration or 2, function()
        conn:Disconnect()
        Tween(overlay,{BackgroundTransparency=1},0.4)
        for _,c in ipairs(overlay:GetChildren()) do
            if c:IsA("TextLabel") then Tween(c,{TextTransparency=1},0.4) end
        end
        task.wait(0.45); overlay:Destroy()
    end)
end

-- ── Set Window Title ──────────────────────────────────────────────────────────
-- Window:SetTitle("New Title")
function Fiber:SetTitle(title)
    self._title=title
    local tb=self._main:FindFirstChild("TitleBar")
    local lbl=tb and tb:FindFirstChild("Title")
    if lbl then lbl.Text=title end
end

-- ── Disable / Enable Tab ──────────────────────────────────────────────────────
-- Window:SetTabEnabled("Combat", false)
function Fiber:SetTabEnabled(tabName, enabled)
    local T=self._theme
    for _,tab in ipairs(self._tabs) do
        if tab._name==tabName then
            tab._btn.AutoButtonColor=enabled
            tab._btn.TextColor3=enabled and T.TextMuted or Color3.fromRGB(60,60,70)
            tab._btn.Active=enabled
            break
        end
    end
end

-- ── Rename Tab ────────────────────────────────────────────────────────────────
-- Window:RenameTab("Old", "New")
function Fiber:RenameTab(oldName, newName)
    for _,tab in ipairs(self._tabs) do
        if tab._name==oldName then
            tab._name=newName; tab._btn.Text=newName; break
        end
    end
end

-- ── Theme Switch ─────────────────────────────────────────────────────────────
-- Window:SetTheme("Ocean")
function Fiber:SetTheme(name)
    if Themes[name] then
        self._theme=Themes[name]
        if self._main then self._main.BackgroundColor3=self._theme.Background end
    end
end

-- ── Textarea (large multi-line input) ────────────────────────────────────────
-- local ta = Tab:AddTextarea("Notes", "", function(v) end)
function _TabMethods:AddTextarea(title, placeholder, callback)
    local T=self._window._theme
    local val=""
    local row=Make("Frame",{
        Size=UDim2.new(1,0,0,110), BackgroundColor3=T.Surface, BorderSizePixel=0,
    },self._scroll); MakeCorner(row,6); MakePadding(row,8,8,12,12)
    Make("TextLabel",{
        Text=title, Font=Enum.Font.GothamSemibold, TextSize=13, TextColor3=T.Text,
        Size=UDim2.new(1,0,0,18), BackgroundTransparency=1,
        TextXAlignment=Enum.TextXAlignment.Left,
    },row)
    local box=Make("TextBox",{
        Text="", PlaceholderText=placeholder or "Enter text...",
        Font=Enum.Font.Gotham, TextSize=12,
        TextColor3=T.Text, PlaceholderColor3=T.TextMuted,
        Size=UDim2.new(1,0,0,72), Position=UDim2.new(0,0,0,22),
        BackgroundColor3=T.SurfaceAlt, BorderSizePixel=0,
        MultiLine=true, ClearTextOnFocus=false,
        TextXAlignment=Enum.TextXAlignment.Left,
        TextYAlignment=Enum.TextYAlignment.Top,
    },row); MakeCorner(box,5); MakeStroke(box,T.Border,1); MakePadding(box,6,6,6,6)
    box.Focused:Connect(function() Tween(box:FindFirstChildWhichIsA("UIStroke") or Make("UIStroke",{},box),{Color=T.Accent},0.12) end)
    box.FocusLost:Connect(function() val=box.Text; if callback then callback(val) end end)
    return {Get=function() return val end, Set=function(v) val=v; box.Text=v end}
end

-- ── Slider with text label below ─────────────────────────────────────────────
-- Tab:AddLabeledSlider("Volume", 0, 100, 75, {"Mute","Low","Med","High"}, function(v) end)
function _TabMethods:AddLabeledSlider(title, min, max, default, labels, callback)
    local T=self._window._theme
    min=min or 0; max=max or 100
    local val=math.clamp(default or min,min,max)
    local row=Make("Frame",{
        Size=UDim2.new(1,0,0,70), BackgroundColor3=T.Surface, BorderSizePixel=0,
    },self._scroll); MakeCorner(row,6); MakePadding(row,8,8,12,12)
    local top=Make("Frame",{Size=UDim2.new(1,0,0,16),BackgroundTransparency=1,BorderSizePixel=0},row)
    Make("TextLabel",{
        Text=title, Font=Enum.Font.GothamSemibold, TextSize=13, TextColor3=T.Text,
        Size=UDim2.new(1,-44,1,0), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left,
    },top)
    local valLbl=Make("TextLabel",{
        Text=tostring(val), Font=Enum.Font.GothamBold, TextSize=12, TextColor3=T.Accent,
        Size=UDim2.new(0,42,1,0), Position=UDim2.new(1,-42,0,0),
        BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Right,
    },top)
    local track=Make("Frame",{
        Size=UDim2.new(1,0,0,6), Position=UDim2.new(0,0,0,22),
        BackgroundColor3=T.Slider, BorderSizePixel=0,
    },row); MakeCorner(track,3)
    local fill=Make("Frame",{
        Size=UDim2.new((val-min)/(max-min),0,1,0), BackgroundColor3=T.Accent, BorderSizePixel=0,
    },track); MakeCorner(fill,3)
    local knob=Make("Frame",{
        Size=UDim2.new(0,14,0,14), Position=UDim2.new((val-min)/(max-min),-7,0.5,-7),
        BackgroundColor3=Color3.fromRGB(255,255,255), BorderSizePixel=0,
    },track); MakeCorner(knob,99); MakeStroke(knob,T.Accent,2)
    -- Labels row
    if labels and #labels>0 then
        local labRow=Make("Frame",{
            Size=UDim2.new(1,0,0,16), Position=UDim2.new(0,0,0,34),
            BackgroundTransparency=1, BorderSizePixel=0,
        },row)
        local lw=1/#labels
        for i,l in ipairs(labels) do
            Make("TextLabel",{
                Text=l, Font=Enum.Font.Gotham, TextSize=10, TextColor3=T.TextMuted,
                Size=UDim2.new(lw,0,1,0), Position=UDim2.new(lw*(i-1),0,0,0),
                BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Center,
            },labRow)
        end
    end
    local dragging=false
    local function setVal(x)
        local rel=math.clamp((x-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
        local nv=math.floor(min+rel*(max-min)+0.5)
        if nv==val then return end; val=nv; valLbl.Text=tostring(val)
        Tween(fill,{Size=UDim2.new(rel,0,1,0)},0.06)
        Tween(knob,{Position=UDim2.new(rel,-7,0.5,-7)},0.06)
        if callback then callback(val) end
    end
    track.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true; setVal(i.Position.X) end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then setVal(i.Position.X) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
    return {Get=function() return val end, Set=function(v) val=math.clamp(v,min,max); local r=(val-min)/(max-min); valLbl.Text=tostring(val); fill.Size=UDim2.new(r,0,1,0); knob.Position=UDim2.new(r,-7,0.5,-7) end}
end

-- ── Countdown Button ──────────────────────────────────────────────────────────
-- Fires callback after a countdown, can be cancelled
-- Tab:AddCountdownButton("Self Destruct", 5, function() end)
function _TabMethods:AddCountdownButton(title, seconds, callback, description)
    local T=self._window._theme
    local running=false
    local row=Make("Frame",{
        Size=UDim2.new(1,0,0, description and 54 or 40),
        BackgroundColor3=T.Surface, BorderSizePixel=0,
    },self._scroll); MakeCorner(row,6); MakePadding(row,0,0,12,12)
    Make("TextLabel",{
        Text=title, Font=Enum.Font.GothamSemibold, TextSize=13, TextColor3=T.Text,
        Size=UDim2.new(1,-80,0,20), Position=UDim2.new(0,0,0, description and 8 or 10),
        BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left,
    },row)
    if description then
        Make("TextLabel",{
            Text=description, Font=Enum.Font.Gotham, TextSize=11, TextColor3=T.TextMuted,
            Size=UDim2.new(1,-80,0,16), Position=UDim2.new(0,0,0,28),
            BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left,
        },row)
    end
    local btn=Make("TextButton",{
        Text="Start", Font=Enum.Font.GothamBold, TextSize=12, TextColor3=T.Text,
        Size=UDim2.new(0,66,0,26), Position=UDim2.new(1,-66,0.5,-13),
        BackgroundColor3=T.Accent, BorderSizePixel=0, AutoButtonColor=false,
    },row); MakeCorner(btn,5)
    btn.MouseButton1Click:Connect(function()
        if running then
            running=false; btn.Text="Start"
            Tween(btn,{BackgroundColor3=T.Accent},0.15)
        else
            running=true
            Tween(btn,{BackgroundColor3=Color3.fromRGB(220,60,60)},0.15)
            local t=seconds or 5
            task.spawn(function()
                while running and t>0 do
                    btn.Text=tostring(t).."s ✕"
                    task.wait(1); t=t-1
                end
                if running then
                    running=false; btn.Text="Start"
                    Tween(btn,{BackgroundColor3=T.Accent},0.15)
                    if callback then callback() end
                end
            end)
        end
    end)
end

-- ── Toggle with preview dot ───────────────────────────────────────────────────
-- Like AddToggle but shows an animated status dot (green/red)
-- Tab:AddStatusToggle("Auto Farm", false, function(v) end)
function _TabMethods:AddStatusToggle(title, default, callback, description)
    local T=self._window._theme
    local val=default or false
    local row=Make("Frame",{
        Size=UDim2.new(1,0,0, description and 54 or 40),
        BackgroundColor3=T.Surface, BorderSizePixel=0,
    },self._scroll); MakeCorner(row,6); MakePadding(row,0,0,12,12)
    -- Status dot
    local dot=Make("Frame",{
        Size=UDim2.new(0,8,0,8), Position=UDim2.new(0,0,0.5,-4),
        BackgroundColor3=val and Color3.fromRGB(80,220,80) or Color3.fromRGB(220,60,60),
        BorderSizePixel=0,
    },row); MakeCorner(dot,99)
    Make("TextLabel",{
        Text=title, Font=Enum.Font.GothamSemibold, TextSize=13, TextColor3=T.Text,
        Size=UDim2.new(1,-60,0,20), Position=UDim2.new(0,16,0, description and 8 or 10),
        BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left,
    },row)
    if description then
        Make("TextLabel",{
            Text=description, Font=Enum.Font.Gotham, TextSize=11, TextColor3=T.TextMuted,
            Size=UDim2.new(1,-60,0,16), Position=UDim2.new(0,16,0,28),
            BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left,
        },row)
    end
    local track=Make("Frame",{
        Size=UDim2.new(0,42,0,22), Position=UDim2.new(1,-42,0.5,-11),
        BackgroundColor3=val and T.ToggleOn or T.Toggle, BorderSizePixel=0,
    },row); MakeCorner(track,11)
    local knob=Make("Frame",{
        Size=UDim2.new(0,16,0,16), Position=UDim2.new(0,val and 22 or 3,0.5,-8),
        BackgroundColor3=Color3.fromRGB(255,255,255), BorderSizePixel=0,
    },track); MakeCorner(knob,99)
    local function refresh()
        Tween(track,{BackgroundColor3=val and T.ToggleOn or T.Toggle},0.15)
        Tween(knob,{Position=UDim2.new(0,val and 22 or 3,0.5,-8)},0.15,Enum.EasingStyle.Back)
        Tween(dot,{BackgroundColor3=val and Color3.fromRGB(80,220,80) or Color3.fromRGB(220,60,60)},0.2)
    end
    Make("TextButton",{
        Text="", Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, BorderSizePixel=0,
    },row).MouseButton1Click:Connect(function()
        val=not val; refresh(); if callback then callback(val) end
    end)
    refresh()
    return {Get=function() return val end, Set=function(v) val=v; refresh(); if callback then callback(val) end end}
end

-- ── Scrollable Log Box ────────────────────────────────────────────────────────
-- local log = Tab:AddLog("Console Output", 100)
-- log.Append("Hello world", "info")
-- log.Clear()
function _TabMethods:AddLog(title, maxLines)
    local T=self._window._theme
    maxLines=maxLines or 50
    local lines={}
    local wrap=Make("Frame",{
        Size=UDim2.new(1,0,0,130), BackgroundColor3=T.Surface, BorderSizePixel=0,
    },self._scroll); MakeCorner(wrap,6); MakePadding(wrap,6,6,10,10)
    Make("TextLabel",{
        Text=title, Font=Enum.Font.GothamSemibold, TextSize=13, TextColor3=T.Text,
        Size=UDim2.new(1,0,0,18), BackgroundTransparency=1,
        TextXAlignment=Enum.TextXAlignment.Left,
    },wrap)
    local scroll=Make("ScrollingFrame",{
        Size=UDim2.new(1,0,0,100), Position=UDim2.new(0,0,0,22),
        BackgroundColor3=T.SurfaceAlt, BorderSizePixel=0,
        ScrollBarThickness=3, ScrollBarImageColor3=T.Accent,
        CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y,
    },wrap); MakeCorner(scroll,5); MakeList(scroll,1); MakePadding(scroll,3,3,6,6)
    local cols={
        info   =T.Text,
        warn   =Color3.fromRGB(255,200,50),
        error  =Color3.fromRGB(255,80,80),
        success=Color3.fromRGB(80,220,100),
        muted  =T.TextMuted,
    }
    return {
        Append=function(text, style)
            table.insert(lines,text)
            if #lines>maxLines then
                table.remove(lines,1)
                local first=scroll:FindFirstChild("line1") or scroll:GetChildren()[3]
                if first and first:IsA("TextLabel") then first:Destroy() end
            end
            local lbl=Make("TextLabel",{
                Text="› "..tostring(text), Font=Enum.Font.Code, TextSize=11,
                TextColor3=cols[style or "info"] or T.Text,
                Size=UDim2.new(1,0,0,16), BackgroundTransparency=1,
                TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true,
            },scroll)
            scroll.CanvasPosition=Vector2.new(0,scroll.AbsoluteCanvasSize.Y)
        end,
        Clear=function()
            lines={}
            for _,c in ipairs(scroll:GetChildren()) do
                if c:IsA("TextLabel") then c:Destroy() end
            end
        end,
        GetLines=function() return lines end,
    }
end

-- ── Horizontal Stat Row ───────────────────────────────────────────────────────
-- Shows up to 4 stats side-by-side in one row
-- Tab:AddStatRow({"KD","2.4"},{"Kills","148"},{"Deaths","61"},{"Rank","Gold"})
function _TabMethods:AddStatRow(...)
    local T=self._window._theme
    local stats={...}
    local row=Make("Frame",{
        Size=UDim2.new(1,0,0,54), BackgroundColor3=T.Surface, BorderSizePixel=0,
    },self._scroll); MakeCorner(row,6); MakePadding(row,0,0,8,8)
    local sw=1/#stats
    for i,stat in ipairs(stats) do
        local cell=Make("Frame",{
            Size=UDim2.new(sw,-4,1,0), Position=UDim2.new(sw*(i-1)+0.005,0,0,0),
            BackgroundColor3=T.SurfaceAlt, BorderSizePixel=0,
        },row); MakeCorner(cell,5)
        Make("TextLabel",{
            Text=stat[1] or "—", Font=Enum.Font.Gotham, TextSize=11, TextColor3=T.TextMuted,
            Size=UDim2.new(1,0,0,16), Position=UDim2.new(0,0,0,8),
            BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Center,
        },cell)
        Make("TextLabel",{
            Text=tostring(stat[2] or "—"), Font=Enum.Font.GothamBold, TextSize=14, TextColor3=T.Accent,
            Size=UDim2.new(1,0,0,18), Position=UDim2.new(0,0,0,24),
            BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Center,
        },cell)
    end
end

-- ── Toggle Lock ───────────────────────────────────────────────────────────────
-- Locks a toggle so user cannot change it
-- Tab:AddToggle returns obj, then Tab:LockToggle(obj, true)
function _TabMethods:AddLockedToggle(title, locked, val, reason)
    local T=self._window._theme
    local row=Make("Frame",{
        Size=UDim2.new(1,0,0,40), BackgroundColor3=T.Surface, BorderSizePixel=0,
    },self._scroll); MakeCorner(row,6); MakePadding(row,0,0,12,12)
    Make("TextLabel",{
        Text=title..(locked and " 🔒" or ""), Font=Enum.Font.GothamSemibold, TextSize=13,
        TextColor3=locked and T.TextMuted or T.Text,
        Size=UDim2.new(1,-58,0,20), Position=UDim2.new(0,0,0,10),
        BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left,
    },row)
    if reason and locked then
        Make("TextLabel",{
            Text=reason, Font=Enum.Font.Gotham, TextSize=10, TextColor3=T.TextMuted,
            Size=UDim2.new(1,-58,0,14), Position=UDim2.new(0,0,0,24),
            BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left,
        },row)
    end
    local track=Make("Frame",{
        Size=UDim2.new(0,42,0,22), Position=UDim2.new(1,-42,0.5,-11),
        BackgroundColor3=val and T.ToggleOn or T.Toggle,
        BorderSizePixel=0, BackgroundTransparency=locked and 0.4 or 0,
    },row); MakeCorner(track,11)
    local knob=Make("Frame",{
        Size=UDim2.new(0,16,0,16), Position=UDim2.new(0,val and 22 or 3,0.5,-8),
        BackgroundColor3=Color3.fromRGB(255,255,255),
        BorderSizePixel=0, BackgroundTransparency=locked and 0.4 or 0,
    },track); MakeCorner(knob,99)
end

-- ── Hotkey Display ────────────────────────────────────────────────────────────
-- Shows a non-interactive hotkey hint row
-- Tab:AddHotkeyHint("Toggle UI", "RightControl")
function _TabMethods:AddHotkeyHint(action, keyName)
    local T=self._window._theme
    local row=Make("Frame",{
        Size=UDim2.new(1,0,0,32), BackgroundTransparency=1, BorderSizePixel=0,
    },self._scroll)
    Make("TextLabel",{
        Text=action, Font=Enum.Font.Gotham, TextSize=12, TextColor3=T.TextMuted,
        Size=UDim2.new(1,-70,1,0), BackgroundTransparency=1,
        TextXAlignment=Enum.TextXAlignment.Left,
    },row); MakePadding(row,0,0,12,0)
    local chip=Make("Frame",{
        Size=UDim2.new(0,0,0,22), Position=UDim2.new(1,-4,0.5,-11),
        BackgroundColor3=T.SurfaceAlt, BorderSizePixel=0,
        AutomaticSize=Enum.AutomaticSize.X,
    },row); MakeCorner(chip,4); MakeStroke(chip,T.Border,1); MakePadding(chip,0,0,6,6)
    Make("TextLabel",{
        Text=keyName or "None", Font=Enum.Font.GothamBold, TextSize=11, TextColor3=T.Accent,
        Size=UDim2.new(0,0,1,0), AutomaticSize=Enum.AutomaticSize.X,
        BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Center,
    },chip)
end

-- ── Link Button ───────────────────────────────────────────────────────────────
-- Tab:AddLink("Discord Server", "https://discord.gg/xxx")
function _TabMethods:AddLink(title, url, description)
    local T=self._window._theme
    local row=Make("Frame",{
        Size=UDim2.new(1,0,0, description and 54 or 40),
        BackgroundColor3=T.Surface, BorderSizePixel=0,
    },self._scroll); MakeCorner(row,6); MakePadding(row,0,0,12,12)
    Make("TextLabel",{
        Text=title, Font=Enum.Font.GothamSemibold, TextSize=13, TextColor3=T.Text,
        Size=UDim2.new(1,-80,0,20), Position=UDim2.new(0,0,0, description and 8 or 10),
        BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left,
    },row)
    if description then
        Make("TextLabel",{
            Text=description, Font=Enum.Font.Gotham, TextSize=11, TextColor3=T.TextMuted,
            Size=UDim2.new(1,-80,0,16), Position=UDim2.new(0,0,0,28),
            BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left,
        },row)
    end
    local btn=Make("TextButton",{
        Text="Open ↗", Font=Enum.Font.GothamBold, TextSize=11, TextColor3=T.Accent,
        Size=UDim2.new(0,66,0,26), Position=UDim2.new(1,-66,0.5,-13),
        BackgroundColor3=T.SurfaceAlt, BorderSizePixel=0, AutoButtonColor=false,
    },row); MakeCorner(btn,5); MakeStroke(btn,T.Accent,1)
    btn.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard(url) end
        btn.Text="Copied!"
        task.delay(1.5,function() btn.Text="Open ↗" end)
    end)
    btn.MouseEnter:Connect(function() Tween(btn,{BackgroundColor3=T.Accent,TextColor3=T.Text},0.12) end)
    btn.MouseLeave:Connect(function() Tween(btn,{BackgroundColor3=T.SurfaceAlt,TextColor3=T.Accent},0.12) end)
end

-- ── Password Input ────────────────────────────────────────────────────────────
-- Tab:AddPasswordInput("API Key", function(v) end)
function _TabMethods:AddPasswordInput(title, callback, description)
    local T=self._window._theme
    local val=""
    local hidden=true
    local row=Make("Frame",{
        Size=UDim2.new(1,0,0, description and 54 or 40),
        BackgroundColor3=T.Surface, BorderSizePixel=0,
    },self._scroll); MakeCorner(row,6); MakePadding(row,0,0,12,12)
    Make("TextLabel",{
        Text=title, Font=Enum.Font.GothamSemibold, TextSize=13, TextColor3=T.Text,
        Size=UDim2.new(0.45,0,0,20), Position=UDim2.new(0,0,0, description and 8 or 10),
        BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left,
    },row)
    if description then
        Make("TextLabel",{
            Text=description, Font=Enum.Font.Gotham, TextSize=11, TextColor3=T.TextMuted,
            Size=UDim2.new(0.45,0,0,16), Position=UDim2.new(0,0,0,28),
            BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left,
        },row)
    end
    local box=Make("TextBox",{
        Text="", PlaceholderText="Enter key...", Font=Enum.Font.Code, TextSize=12,
        TextColor3=T.Text, PlaceholderColor3=T.TextMuted,
        Size=UDim2.new(0,130,0,28), Position=UDim2.new(1,-164,0.5,-14),
        BackgroundColor3=T.SurfaceAlt, BorderSizePixel=0,
        ClearTextOnFocus=false, TextXAlignment=Enum.TextXAlignment.Left,
    },row); MakeCorner(box,5); MakeStroke(box,T.Border,1); MakePadding(box,0,0,6,6)
    local eyeBtn=Make("TextButton",{
        Text="👁", Font=Enum.Font.GothamBold, TextSize=12,
        TextColor3=T.TextMuted, Size=UDim2.new(0,28,0,28),
        Position=UDim2.new(1,-30,0.5,-14), BackgroundColor3=T.SurfaceAlt,
        BorderSizePixel=0, AutoButtonColor=false,
    },row); MakeCorner(eyeBtn,5)
    eyeBtn.MouseButton1Click:Connect(function()
        hidden=not hidden
        -- Roblox doesn't support password char, so we show/hide with placeholder trick
        if hidden then box.Text=""; box.PlaceholderText=string.rep("●",#val) else box.Text=val end
    end)
    box.FocusLost:Connect(function()
        val=box.Text
        if hidden then box.Text=""; box.PlaceholderText=string.rep("●",#val) end
        if callback then callback(val) end
    end)
    return {Get=function() return val end, Set=function(v) val=v end}
end

return Fiber

-- ══════════════════════════════════════════════════════════════════════════════
--  FIBER.CC EXTENDED COMPONENTS v2
-- ══════════════════════════════════════════════════════════════════════════════
