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

return Fiber
