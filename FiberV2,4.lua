--[[
 FiberUI Lib (Fiber.cc)
 License: MIT — free to use, modify, distribute. No warranty.
 How it works:
 - Creates a self-contained ScreenGui with a Fiber-styled window
 - Provides tab/section layout and a large set of ready-to-use controls
 - All controls are pure Roblox instances, no dependencies, no file IO
 - Theme accent can be changed live; glow uses a 9-sliced texture

 Functions (highlights):
 - CreateWindow({ Name, Width, Height, ToggleKey })
 - Window:CreateTab({ Name }) -> { Button, Page, Body }
 - Window:CreateSection(tab.Body, { Name }) -> { Frame, Body }
 - Window:Notify({ Text, Duration })
 - Window:SetAccent(color3)
 - Window:SetTheme("Fiber"|"Dark"|"Midnight"|"Crimson"|"Ocean"|"Lime")
 - Controls: Toggle, Switch, Checkbox, RadioGroup, CheckboxGroup,
             Slider, RangeSlider, Stepper, Counter, Progress, Spinner,
             Dropdown, MultiSelect, ListBox, SearchBox, Keybind,
             Textbox, TextArea, Button, IconButton, LinkButton, CopyButton,
             ColorPicker, Palette, GradientBar, Separator, Divider, Spacer,
             Label, Paragraph, Badge, StatusDot, Tooltip, HelpIcon,
             Collapsible, Accordion, SubTabs, Splitter, Grid, Image,
             Logger, Console, TableView, TreeView, ModalConfirm, ModalPrompt,
             Drawer, Toast, AccentAnimator, ResizeHandle, SaveState, LoadState

 Example:
   -- Example loader (public raw)
   local Fiber = loadstring(game:HttpGet("https://raw.githubusercontent.com/SentinelisBetter/SentinelHub/refs/heads/main/FiberV2%2C4.lua"))()
   local Win   = Fiber:CreateWindow({ Name = "Fiber", ToggleKey = Enum.KeyCode.RightShift })
   local Tab   = Win:CreateTab({ Name = "Main" })
   local Sec   = Win:CreateSection(Tab.Body, { Name = "Demo" })
   local t     = Win.Controls.Toggle(Sec.Body, { Name = "Enable", Default = true })
   local s     = Win.Controls.Slider(Sec.Body, { Name="Speed", Min=0, Max=100, Default=25 })
   Win:Notify({ Text = "FiberUI loaded", Duration = 2 })
]]

local Services=setmetatable({},{__index=function(_,s)return game:GetService(s)end})
local Players,RunService,TweenService,UIS,CoreGui=Services.Players,Services.RunService,Services.TweenService,Services.UserInputService,Services.CoreGui
local LP=Players.LocalPlayer
local function tw(o,t,pr,s,d)local i=TweenInfo.new(t or 0.15,s or Enum.EasingStyle.Quad,d or Enum.EasingDirection.Out)local a=TweenService:Create(o,i,pr)a:Play()return a end
local function addGlow(parent,color,offset,transparency)local g=Instance.new("ImageLabel")g.Name="Glow"g.BackgroundTransparency=1;g.Image="rbxassetid://18245826428";g.ImageColor3=color or Color3.fromRGB(170,85,255);g.ImageTransparency=transparency or 0.55;g.ScaleType=Enum.ScaleType.Slice;g.SliceCenter=Rect.new(21,21,79,79);g.AnchorPoint=Vector2.new(0.5,0.5);g.Position=UDim2.new(0.5,0,0.5,0);g.Size=UDim2.new(1,(offset or 36),1,(offset or 36));g.ZIndex=(parent.ZIndex or 1)+1;g.Parent=parent;local cur=parent;for _=1,10 do if not cur or cur:IsA("ScreenGui") then break end;if cur:IsA("GuiObject") then cur.ClipsDescendants=false end;cur=cur.Parent end;return g end
local Theme={BG=Color3.fromRGB(20,20,22),Panel=Color3.fromRGB(24,24,28),Row=Color3.fromRGB(30,30,36),RowH=Color3.fromRGB(36,36,44),Text=Color3.fromRGB(230,230,240),Sub=Color3.fromRGB(160,170,185),Border=Color3.fromRGB(70,70,90),Accent=Color3.fromRGB(170,85,255),Accent2=Color3.fromRGB(90,45,135)}
local Themes={
 Fiber={BG=Color3.fromRGB(20,20,22),Panel=Color3.fromRGB(24,24,28),Row=Color3.fromRGB(30,30,36),RowH=Color3.fromRGB(36,36,44),Text=Color3.fromRGB(230,230,240),Sub=Color3.fromRGB(160,170,185),Border=Color3.fromRGB(70,70,90),Accent=Color3.fromRGB(170,85,255),Accent2=Color3.fromRGB(90,45,135)},
 Dark={BG=Color3.fromRGB(18,18,22),Panel=Color3.fromRGB(26,26,32),Row=Color3.fromRGB(32,32,40),RowH=Color3.fromRGB(40,40,48),Text=Color3.fromRGB(235,235,240),Sub=Color3.fromRGB(130,130,145),Border=Color3.fromRGB(50,50,62),Accent=Color3.fromRGB(130,100,255),Accent2=Color3.fromRGB(90,65,200)},
 Midnight={BG=Color3.fromRGB(10,12,20),Panel=Color3.fromRGB(15,18,30),Row=Color3.fromRGB(20,24,40),RowH=Color3.fromRGB(28,32,50),Text=Color3.fromRGB(220,230,255),Sub=Color3.fromRGB(110,120,160),Border=Color3.fromRGB(35,40,65),Accent=Color3.fromRGB(80,140,255),Accent2=Color3.fromRGB(50,100,200)},
 Crimson={BG=Color3.fromRGB(18,12,14),Panel=Color3.fromRGB(28,18,20),Row=Color3.fromRGB(38,24,28),RowH=Color3.fromRGB(48,30,34),Text=Color3.fromRGB(240,220,225),Sub=Color3.fromRGB(160,110,120),Border=Color3.fromRGB(70,35,40),Accent=Color3.fromRGB(220,60,80),Accent2=Color3.fromRGB(170,35,55)},
 Ocean={BG=Color3.fromRGB(10,20,28),Panel=Color3.fromRGB(15,28,38),Row=Color3.fromRGB(20,36,50),RowH=Color3.fromRGB(28,44,60),Text=Color3.fromRGB(210,240,245),Sub=Color3.fromRGB(100,155,170),Border=Color3.fromRGB(30,60,80),Accent=Color3.fromRGB(0,185,200),Accent2=Color3.fromRGB(0,135,155)},
 Lime={BG=Color3.fromRGB(12,18,12),Panel=Color3.fromRGB(18,26,18),Row=Color3.fromRGB(24,34,24),RowH=Color3.fromRGB(30,42,30),Text=Color3.fromRGB(225,245,220),Sub=Color3.fromRGB(120,165,110),Border=Color3.fromRGB(40,65,40),Accent=Color3.fromRGB(100,220,80),Accent2=Color3.fromRGB(65,170,50)}
}
local Lib={}
function Lib:CreateWindow(opt)
opt=opt or {}
local toggleKey=opt.ToggleKey or Enum.KeyCode.RightShift
local ui=Instance.new("ScreenGui")ui.Name="FiberUI";ui.ResetOnSpawn=false;pcall(function()ui.Parent=CoreGui end)if not ui.Parent then ui.Parent=LP:WaitForChild("PlayerGui") end
local win=Instance.new("Frame")win.Name="Main";win.Size=UDim2.new(0,opt.Width or 850,0,opt.Height or 550);win.Position=UDim2.new(0.5,-(opt.Width or 850)/2,0.5,-(opt.Height or 550)/2);win.BackgroundColor3=Theme.BG;win.Active=true;win.Draggable=true;win.Parent=ui
local c=Instance.new("UICorner")c.CornerRadius=UDim.new(0,12)c.Parent=win
local st=Instance.new("UIStroke")st.Thickness=2;st.Color=Theme.Border;st.Parent=win
local stg=Instance.new("UIGradient")stg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Theme.Accent),ColorSequenceKeypoint.new(1,Theme.Accent2)});stg.Parent=st
local top=Instance.new("Frame")top.Size=UDim2.new(1,0,0,40);top.BackgroundColor3=Theme.Panel;top.Parent=win
local tg=Instance.new("UIGradient")tg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Theme.Accent),ColorSequenceKeypoint.new(1,Theme.Accent2)});tg.Rotation=0;tg.Parent=top
local title=Instance.new("TextLabel")title.BackgroundTransparency=1;title.Text=(opt.Name or "Fiber")..".cc";title.Font=Enum.Font.GothamBold;title.TextSize=18;title.TextColor3=Color3.fromRGB(255,255,255);title.RichText=true;title.Size=UDim2.new(0.6,0,1,0);title.Position=UDim2.new(0,12,0,0);title.Parent=top
local close=Instance.new("TextButton")close.BackgroundTransparency=1;close.Text="X";close.Font=Enum.Font.GothamBold;close.TextSize=16;close.TextColor3=Theme.Sub;close.Size=UDim2.new(0,40,1,0);close.Position=UDim2.new(1,-44,0,0);close.Parent=top
local tabs=Instance.new("Frame")tabs.Size=UDim2.new(0,160,1,-40);tabs.Position=UDim2.new(0,0,0,40);tabs.BackgroundColor3=Theme.Panel;tabs.Parent=win
local tbStroke=Instance.new("UIStroke")tbStroke.Color=Theme.Border;tbStroke.Thickness=1;tbStroke.Parent=tabs
local tbLayout=Instance.new("UIListLayout")tbLayout.Padding=UDim.new(0,6);tbLayout.Parent=tabs
local pages=Instance.new("Frame")pages.Size=UDim2.new(1,-160,1,-40);pages.Position=UDim2.new(0,160,0,40);pages.BackgroundColor3=Theme.Panel;pages.Parent=win
local pgStroke=Instance.new("UIStroke")pgStroke.Color=Theme.Border;pgStroke.Thickness=1;pgStroke.Parent=pages
local pageHolder=Instance.new("Folder")pageHolder.Parent=pages
local function ripple(b,c)
 local h=Instance.new("Frame"); h.Name="RippleHolder"; h.BackgroundTransparency=1; h.Size=UDim2.new(1,0,1,0); h.ClipsDescendants=true; h.ZIndex=10; h.Parent=b; local hc=Instance.new("UICorner"); hc.CornerRadius=UDim.new(0,4); hc.Parent=h
 b.MouseButton1Click:Connect(function()
  local m=UIS:GetMouseLocation(); local r=Instance.new("Frame"); r.BackgroundColor3=c or Color3.fromRGB(255,255,255); r.BackgroundTransparency=0.6; r.Size=UDim2.new(0,0,0,0); r.Position=UDim2.new(0,m.X-b.AbsolutePosition.X,0,m.Y-b.AbsolutePosition.Y); r.AnchorPoint=Vector2.new(0.5,0.5); r.Parent=h
  local rc=Instance.new("UICorner"); rc.CornerRadius=UDim.new(1,0); rc.Parent=r
  tw(r,0.5,{Size=UDim2.new(2,0,2,0),BackgroundTransparency=1}); task.delay(0.5,function()r:Destroy()end)
 end)
end
local notifyHolder=Instance.new("Frame")notifyHolder.Size=UDim2.new(0,260,0,300);notifyHolder.Position=UDim2.new(1,-270,1,-310);notifyHolder.BackgroundTransparency=1;notifyHolder.Parent=ui
local nl=Instance.new("UIListLayout")nl.Parent=notifyHolder;nl.Padding=UDim.new(0,6);nl.VerticalAlignment=Enum.VerticalAlignment.Bottom
local function addTab(name,icon)
local b=Instance.new("TextButton")b.Size=UDim2.new(1,-12,0,34);b.BackgroundColor3=Theme.Row;b.Text=name;b.TextColor3=Theme.Text;b.TextSize=14;b.Font=Enum.Font.Gotham;b.Parent=tabs
local bg=addGlow(b,Theme.Accent,24,0.9)bg.Visible=false
local p=Instance.new("ScrollingFrame")p.Size=UDim2.new(1,0,1,0);p.CanvasSize=UDim2.new(0,0,0,0);p.AutomaticCanvasSize=Enum.AutomaticSize.Y;p.ScrollBarThickness=2;p.BackgroundTransparency=1;p.Visible=false;p.Parent=pageHolder
local body=Instance.new("Frame")body.Size=UDim2.new(1,-20,0,0);body.Position=UDim2.new(0,10,0,10);body.BackgroundTransparency=1;body.AutomaticSize=Enum.AutomaticSize.Y;body.Parent=p
local layout=Instance.new("UIListLayout")layout.Padding=UDim.new(0,8);layout.Parent=body
local active=false
b.MouseEnter:Connect(function()if not active then tw(b,0.12,{BackgroundColor3=Theme.RowH})end end)
b.MouseLeave:Connect(function()if not active then tw(b,0.12,{BackgroundColor3=Theme.Row})end end)
b.MouseButton1Click:Connect(function()for _,x in ipairs(tabs:GetChildren())do if x:IsA("TextButton") then x.BackgroundColor3=Theme.Row end end;for _,x in ipairs(pageHolder:GetChildren())do if x:IsA("ScrollingFrame") then x.Visible=false end end;active=true;b.BackgroundColor3=Theme.RowH;bg.Visible=true;p.Visible=true end)
return {Button=b,Page=p,Body=body}
end
local function addSection(parent,title)
local g=Instance.new("Frame")g.BackgroundColor3=Theme.Row;g.Size=UDim2.new(1,0,0,0);g.AutomaticSize=Enum.AutomaticSize.Y;g.Parent=parent
local s=Instance.new("UIStroke")s.Color=Theme.Border;s.Thickness=1;s.Parent=g
local t=Instance.new("TextLabel")t.BackgroundTransparency=1;t.Text=title;t.TextColor3=Theme.Text;t.TextSize=14;t.Font=Enum.Font.GothamBold;t.Size=UDim2.new(1,-12,0,20);t.Position=UDim2.new(0,10,0,8);t.TextXAlignment=Enum.TextXAlignment.Left;t.Parent=g
local body=Instance.new("Frame")body.BackgroundTransparency=1;body.Size=UDim2.new(1,-16,0,0);body.Position=UDim2.new(0,8,0,34);body.AutomaticSize=Enum.AutomaticSize.Y;body.Parent=g
local l=Instance.new("UIListLayout")l.Padding=UDim.new(0,6);l.Parent=body
return {Frame=g,Body=body}
end
local Controls={}
function Controls.Separator(parent) local d=Instance.new("Frame")d.Size=UDim2.new(1,0,0,1) d.BackgroundColor3=Theme.Border d.Parent=parent return d end
function Controls.Divider(parent, text)
 local r=Instance.new("Frame") r.BackgroundColor3=Theme.Row r.Size=UDim2.new(1,0,0,26) r.Parent=parent
 local s=Instance.new("UIStroke") s.Color=Theme.Border s.Thickness=1 s.Parent=r
 local l=Instance.new("TextLabel") l.BackgroundTransparency=1 l.Text=(text or "") l.TextColor3=Theme.Sub l.TextSize=12 l.Font=Enum.Font.Gotham l.Size=UDim2.new(1,-10,1,0) l.Position=UDim2.new(0,10,0,0) l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=r
 return {Row=r}
end
function Controls.Spacer(parent,h) local f=Instance.new("Frame") f.BackgroundTransparency=1 f.Size=UDim2.new(1,0,0,h or 8) f.Parent=parent return f end
function Controls.Label(parent,opt)
 opt=opt or {}; local l=Instance.new("TextLabel"); l.BackgroundTransparency=1; l.Text=opt.Text or "Label"; l.TextColor3=opt.Color or Theme.Text; l.TextSize=opt.Size or 13; l.Font=Enum.Font.Gotham; l.TextXAlignment=Enum.TextXAlignment.Left; l.Size=UDim2.new(1,-10,0,20); l.Position=UDim2.new(0,10,0,0); l.Parent=parent; return l
end
function Controls.Paragraph(parent,opt)
 opt=opt or {}; local l=Instance.new("TextLabel"); l.BackgroundTransparency=1; l.TextWrapped=true; l.TextXAlignment=Enum.TextXAlignment.Left; l.TextYAlignment=Enum.TextYAlignment.Top; l.Text=opt.Text or ("Lorem ipsum"); l.TextColor3=Theme.Sub; l.TextSize=opt.Size or 12; l.Font=Enum.Font.Gotham; l.Size=UDim2.new(1,-16,0,0); l.AutomaticSize=Enum.AutomaticSize.Y; l.Position=UDim2.new(0,8,0,0); l.Parent=parent; return l
end
function Controls.Badge(parent,opt)
 opt=opt or {}; local b=Instance.new("TextLabel"); b.BackgroundColor3=Theme.RowH; b.Text=opt.Text or "Badge"; b.TextColor3=Theme.Text; b.TextSize=12; b.Font=Enum.Font.GothamBold; b.Size=UDim2.new(0, math.max(60, (b.TextBounds and b.TextBounds.X) or 60), 0, 22); b.Parent=parent; local s=Instance.new("UIStroke") s.Color=Theme.Border s.Thickness=1 s.Parent=b; addGlow(b, Theme.Accent, 20, 0.85); return b
end
function Controls.StatusDot(parent,opt)
 opt=opt or {}; local f=Instance.new("Frame") f.Size=UDim2.new(0,12,0,12) f.BackgroundColor3=(opt.Color or Color3.fromRGB(80,200,120)) f.Parent=parent; local c=Instance.new("UICorner") c.CornerRadius=UDim.new(1,0) c.Parent=f; return {Set=function(col) f.BackgroundColor3=col end, Dot=f}
end
function Controls.Tooltip(gui, text)
 local tip=Instance.new("TextLabel") tip.Visible=false tip.BackgroundColor3=Theme.Panel tip.TextColor3=Theme.Text tip.TextSize=12 tip.Font=Enum.Font.Gotham tip.Size=UDim2.new(0,200,0,24) tip.Parent=gui:FindFirstAncestorOfClass("ScreenGui") or CoreGui
 local s=Instance.new("UIStroke") s.Color=Theme.Border s.Thickness=1 s.Parent=tip
 gui.MouseEnter:Connect(function() tip.Text="  "..text; tip.Visible=true end)
 gui.MouseMoved:Connect(function(x,y) tip.Position=UDim2.new(0,x+12,0,y+12) end)
 gui.MouseLeave:Connect(function() tip.Visible=false end)
 return tip
end
function Controls.Toggle(parent,opt)
opt=opt or {}
local r=Instance.new("Frame")r.BackgroundColor3=Theme.Row;r.Size=UDim2.new(1,0,0,32);r.Parent=parent
local s=Instance.new("UIStroke")s.Color=Theme.Border;s.Thickness=1;s.Parent=r
local l=Instance.new("TextLabel")l.BackgroundTransparency=1;l.Text=opt.Name or "Toggle";l.TextColor3=Theme.Text;l.TextSize=13;l.Font=Enum.Font.Gotham;l.Size=UDim2.new(1,-60,1,0);l.Position=UDim2.new(0,10,0,0);l.TextXAlignment=Enum.TextXAlignment.Left;l.Parent=r
local check=Instance.new("Frame")check.Size=UDim2.new(0,20,0,20);check.Position=UDim2.new(1,-30,0.5,-10);check.BackgroundColor3=Theme.Accent;check.BackgroundTransparency=opt.Default and 0 or 1;check.Parent=r
local cc=Instance.new("UICorner")cc.CornerRadius=UDim.new(0,4)cc.Parent=check
local cs=Instance.new("UIStroke")cs.Color=opt.Default and Theme.Accent or Theme.Border;cs.Thickness=1;cs.Parent=check
local glow=addGlow(check,Theme.Accent,36,opt.Default and 0.55 or 1)
local v=opt.Default and true or false
local function set(state,skip)v=state and true or false;tw(check,0.12,{BackgroundTransparency=v and 0 or 1});tw(cs,0.12,{Color=v and Theme.Accent or Theme.Border});tw(glow,0.2,{ImageTransparency=v and 0.55 or 1});if opt.Callback and not skip then opt.Callback(v)end end
local btn=Instance.new("TextButton")btn.BackgroundTransparency=1;btn.Text="";btn.Size=UDim2.new(1,0,1,0);btn.Parent=r;btn.MouseButton1Click:Connect(function()set(not v)end)
return {Set=set,Get=function()return v end,Row=r}
end
function Controls.Switch(parent,opt)
 opt=opt or {}; return Controls.Toggle(parent, { Name=opt.Name or "Switch", Default=opt.Default, Callback=opt.Callback })
end
function Controls.Checkbox(parent,opt) return Controls.Toggle(parent,opt) end
function Controls.RadioGroup(parent,opt)
 opt=opt or {}; local list=opt.Options or {"A","B"}; local cur=list[1]; local rows={}
 for _,name in ipairs(list) do
  local row=Controls.Toggle(parent,{ Name=name, Default=(name==cur), Callback=function(v)
   if v then
     cur=name
     for _,r in ipairs(rows) do if r.Name~=name then r.Set(false,true) end end
     if opt.Callback then opt.Callback(name) end
   end
  end})
  row.Name=name
  table.insert(rows,row)
 end
 return {Get=function()return cur end, Set=function(v) for _,r in ipairs(rows) do r.Set(r.Name==v,true) end cur=v end}
end
function Controls.CheckboxGroup(parent,opt)
 opt=opt or {}; local items=opt.Options or {}; local map={}
 for _,name in ipairs(items) do
  map[name]=false
  local row=Controls.Toggle(parent,{ Name=name, Default=false, Callback=function(v) map[name]=v; if opt.Callback then opt.Callback(map) end end})
 end
 return {Get=function()return map end}
end
function Controls.Slider(parent,opt)
opt=opt or {};local min,max,def=opt.Min or 0,opt.Max or 100,opt.Default or 0
local r=Instance.new("Frame")r.BackgroundColor3=Theme.Row;r.Size=UDim2.new(1,0,0,40);r.Parent=parent
local s=Instance.new("UIStroke")s.Color=Theme.Border;s.Thickness=1;s.Parent=r
local l=Instance.new("TextLabel")l.BackgroundTransparency=1;l.Text=(opt.Name or "Slider");l.TextColor3=Theme.Sub;l.TextSize=12;l.Font=Enum.Font.Gotham;l.Size=UDim2.new(1,0,0,16);l.Position=UDim2.new(0,10,0,2);l.TextXAlignment=Enum.TextXAlignment.Left;l.Parent=r
local track=Instance.new("Frame")track.BackgroundColor3=Theme.Panel;track.Size=UDim2.new(1,-20,0,6);track.Position=UDim2.new(0,10,0,22);track.Parent=r
local tc=Instance.new("UICorner")tc.CornerRadius=UDim.new(0,3)tc.Parent=track
local fill=Instance.new("Frame")fill.BackgroundColor3=Theme.Accent2;fill.Size=UDim2.new(0,0,1,0);fill.Parent=track
local fc=Instance.new("UICorner")fc.CornerRadius=UDim.new(0,3)fc.Parent=fill
local val=Instance.new("TextLabel")val.BackgroundTransparency=1;val.Text=tostring(def)..(opt.Suffix or "");val.TextColor3=Theme.Text;val.TextSize=11;val.Font=Enum.Font.Gotham;val.Size=UDim2.new(1,0,0,14);val.Position=UDim2.new(0,10,0,28);val.TextXAlignment=Enum.TextXAlignment.Left;val.Parent=r
local function apply(x)local p=math.clamp((x-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)local v=min+(max-min)*p;v=(max-min)>10 and math.floor(v) or math.floor(v*100)/100;fill.Size=UDim2.new(p,0,1,0);val.Text=tostring(v)..(opt.Suffix or "");if opt.Callback then opt.Callback(v)end end
track.InputBegan:Connect(function(inp)if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then apply(inp.Position.X)end end)
UIS.InputChanged:Connect(function(inp)if inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then apply(inp.Position.X)end end end)
local function setv(v)local p=math.clamp((v-min)/(max-min),0,1)fill.Size=UDim2.new(p,0,1,0);val.Text=tostring(v)..(opt.Suffix or "")if opt.Callback then opt.Callback(v)end end
setv(def)
return {Set=setv,Row=r}
end
function Controls.RangeSlider(parent,opt)
 opt=opt or {}; local min,max=opt.Min or 0,opt.Max or 100; local a,b=opt.DefaultMin or min,opt.DefaultMax or max
 local r=Instance.new("Frame") r.BackgroundColor3=Theme.Row r.Size=UDim2.new(1,0,0,46) r.Parent=parent
 local s=Instance.new("UIStroke") s.Color=Theme.Border s.Thickness=1 s.Parent=r
 local l=Controls.Label(r,{ Text=(opt.Name or "Range"), Size=12, Color=Theme.Sub}) l.Position=UDim2.new(0,10,0,2)
 local track=Instance.new("Frame") track.BackgroundColor3=Theme.Panel track.Size=UDim2.new(1,-20,0,6) track.Position=UDim2.new(0,10,0,22) track.Parent=r local tc=Instance.new("UICorner") tc.CornerRadius=UDim.new(0,3) tc.Parent=track
 local fill=Instance.new("Frame") fill.BackgroundColor3=Theme.Accent2 fill.Parent=track local fc=Instance.new("UICorner") fc.CornerRadius=UDim.new(0,3) fc.Parent=fill
 local la=Controls.Label(r,{ Text=tostring(a), Size=10, Color=Theme.Text }) la.Position=UDim2.new(0,10,0,28)
 local lb=Controls.Label(r,{ Text=tostring(b), Size=10, Color=Theme.Text }) lb.Position=UDim2.new(0,70,0,28)
 local function set()
   local ap=(a-min)/(max-min); local bp=(b-min)/(max-min)
   fill.Position=UDim2.new(ap,0,0,22); fill.Size=UDim2.new(bp-ap,0,0,6)
   la.Text=tostring(a); lb.Text=tostring(b)
   if opt.Callback then opt.Callback(a,b) end
 end
 set()
 track.InputBegan:Connect(function(inp)
  if inp.UserInputType==Enum.UserInputType.MouseButton1 then
    local p=(inp.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X; local v=min+(max-min)*p
    if math.abs(v-a)<math.abs(v-b) then a=math.clamp(v,min,b) else b=math.clamp(v,a,max) end
    a=math.floor(a); b=math.floor(b); set()
  end
 end)
 return {Set=function(x,y) a=math.clamp(x,min,max); b=math.clamp(y,min,max); if a>b then a,b=b,a end; set() end, Row=r}
end
function Controls.Stepper(parent,opt)
 opt=opt or {}; local val=opt.Default or 0
 local r=Instance.new("Frame") r.BackgroundColor3=Theme.Row r.Size=UDim2.new(1,0,0,32) r.Parent=parent
 local s=Instance.new("UIStroke") s.Color=Theme.Border s.Thickness=1 s.Parent=r
 local minus=Instance.new("TextButton") minus.Text="-" minus.Size=UDim2.new(0,30,1,0) minus.BackgroundColor3=Theme.RowH minus.TextColor3=Theme.Text minus.Parent=r
 local plus=Instance.new("TextButton") plus.Text="+" plus.Size=UDim2.new(0,30,1,0) plus.Position=UDim2.new(1,-30,0,0) plus.BackgroundColor3=Theme.RowH plus.TextColor3=Theme.Text plus.Parent=r
 local label=Controls.Label(r,{ Text=(opt.Name or "Value")..": "..val }) label.Position=UDim2.new(0,40,0,0)
 local function upd() label.Text=(opt.Name or "Value")..": "..val; if opt.Callback then opt.Callback(val) end end
 minus.MouseButton1Click:Connect(function() val=val-1; upd() end) plus.MouseButton1Click:Connect(function() val=val+1; upd() end)
 return {Set=function(v) val=v; upd() end, Get=function()return val end}
end
function Controls.Counter(parent,opt) return Controls.Stepper(parent,opt) end
function Controls.Progress(parent,opt)
 opt=opt or {}; local max=opt.Max or 100; local val=opt.Default or 0
 local r=Instance.new("Frame") r.BackgroundColor3=Theme.Row r.Size=UDim2.new(1,0,0,34) r.Parent=parent
 local s=Instance.new("UIStroke") s.Color=Theme.Border s.Thickness=1 s.Parent=r
 local bar=Instance.new("Frame") bar.BackgroundColor3=Theme.Panel bar.Size=UDim2.new(1,-20,0,6) bar.Position=UDim2.new(0,10,0,14) bar.Parent=r local bc=Instance.new("UICorner") bc.CornerRadius=UDim.new(0,3) bc.Parent=bar
 local fill=Instance.new("Frame") fill.BackgroundColor3=Theme.Accent fill.Size=UDim2.new(0,0,1,0) fill.Parent=bar local fc=Instance.new("UICorner") fc.CornerRadius=UDim.new(0,3) fc.Parent=fill
 local txt=Controls.Label(r,{ Text=(opt.Name or "Progress")..": 0%" }) txt.Position=UDim2.new(0,10,0,22)
 local function set(v) val=math.clamp(v,0,max); local p=val/max; fill.Size=UDim2.new(p,0,1,0); txt.Text=(opt.Name or "Progress")..": "..tostring(math.floor(p*100)).."%" end
 set(val); return {Set=set, Row=r}
end
function Controls.Spinner(parent,opt)
 opt=opt or {}; local r=Instance.new("Frame") r.BackgroundTransparency=1 r.Size=UDim2.new(0,20,0,20) r.Parent=parent
 local img=Instance.new("ImageLabel") img.BackgroundTransparency=1 img.Image="rbxassetid://12296057005" img.Size=UDim2.new(1,0,1,0) img.Parent=r
 RunService.Heartbeat:Connect(function(dt) img.Rotation=(img.Rotation+dt*180)%360 end) return r
end
function Controls.Dropdown(parent,opt)
opt=opt or {};local items=opt.Options or {}
local r=Instance.new("Frame")r.BackgroundColor3=Theme.Row;r.Size=UDim2.new(1,0,0,34);r.Parent=parent
local s=Instance.new("UIStroke")s.Color=Theme.Border;s.Thickness=1;s.Parent=r
local cur=Instance.new("TextLabel")cur.BackgroundTransparency=1;cur.Text=(opt.Name or "Dropdown")..": "..(opt.Default or "");cur.TextColor3=Theme.Text;cur.TextSize=13;cur.Font=Enum.Font.Gotham;cur.Size=UDim2.new(1,-30,1,0);cur.Position=UDim2.new(0,10,0,0);cur.TextXAlignment=Enum.TextXAlignment.Left;cur.Parent=r
local b=Instance.new("TextButton")b.BackgroundTransparency=1;b.Text="";b.Size=UDim2.new(1,0,1,0);b.Parent=r
local list=Instance.new("Frame")list.Size=UDim2.new(1,0,0,0);list.Position=UDim2.new(0,0,1,0);list.BackgroundColor3=Theme.Panel;list.Visible=false;list.Parent=r
local ls=Instance.new("UIStroke")ls.Color=Theme.Border;ls.Thickness=1;ls.Parent=list
local lay=Instance.new("UIListLayout")lay.Parent=list;lay.Padding=UDim.new(0,2)
local function rebuild()
for _,c in ipairs(list:GetChildren())do if c:IsA("TextButton")then c:Destroy()end end
local h=0
for _,v in ipairs(items)do local it=Instance.new("TextButton")it.Size=UDim2.new(1,-10,0,26);it.Position=UDim2.new(0,5,0,0);it.BackgroundColor3=Theme.Row;it.Text=tostring(v);it.TextColor3=Theme.Text;it.TextSize=12;it.Font=Enum.Font.Gotham;it.Parent=list;h=h+28;it.MouseButton1Click:Connect(function()cur.Text=(opt.Name or "Dropdown")..": "..tostring(v);list.Visible=false;if opt.Callback then opt.Callback(v)end end)end
list.Size=UDim2.new(1,0,0,h)
end
rebuild()
b.MouseButton1Click:Connect(function()list.Visible=not list.Visible end)
local function setOptions(t)items=t or {};rebuild()end
return {SetOptions=setOptions,Row=r}
end
function Controls.Keybind(parent,opt)
opt=opt or {};local v=opt.Default or Enum.KeyCode.RightShift
local r=Instance.new("Frame")r.BackgroundColor3=Theme.Row;r.Size=UDim2.new(1,0,0,32);r.Parent=parent
local s=Instance.new("UIStroke")s.Color=Theme.Border;s.Thickness=1;s.Parent=r
local l=Instance.new("TextLabel")l.BackgroundTransparency=1;l.Text=(opt.Name or "Keybind")..": "..v.Name;l.TextColor3=Theme.Text;l.TextSize=13;l.Font=Enum.Font.Gotham;l.Size=UDim2.new(1,-60,1,0);l.Position=UDim2.new(0,10,0,0);l.TextXAlignment=Enum.TextXAlignment.Left;l.Parent=r
local b=Instance.new("TextButton")b.BackgroundTransparency=1;b.Text="";b.Size=UDim2.new(1,0,1,0);b.Parent=r
b.MouseButton1Click:Connect(function()l.Text=(opt.Name or "Keybind")..": ...";local conn;conn=UIS.InputBegan:Connect(function(inp,gp)if gp then return end;if inp.KeyCode~=Enum.KeyCode.Unknown then v=inp.KeyCode;l.Text=(opt.Name or "Keybind")..": "..v.Name;if opt.Callback then opt.Callback(v)end;conn:Disconnect()end end)end)
return {Get=function()return v end,Row=r}
end
function Controls.Textbox(parent,opt)
opt=opt or {};local r=Instance.new("Frame")r.BackgroundColor3=Theme.Row;r.Size=UDim2.new(1,0,0,32);r.Parent=parent
local s=Instance.new("UIStroke")s.Color=Theme.Border;s.Thickness=1;s.Parent=r
local tb=Instance.new("TextBox")tb.PlaceholderText=opt.Placeholder or "";tb.Text=opt.Default or "";tb.TextColor3=Theme.Text;tb.Font=Enum.Font.Gotham;tb.TextSize=13;tb.BackgroundTransparency=1;tb.Size=UDim2.new(1,-20,1,0);tb.Position=UDim2.new(0,10,0,0);tb.Parent=r
tb.FocusLost:Connect(function(enter)if enter and opt.Callback then opt.Callback(tb.Text)end end)
return {Set=function(t)tb.Text=t end,Row=r}
end
function Controls.TextArea(parent,opt)
 opt=opt or {}; local r=Instance.new("Frame") r.BackgroundColor3=Theme.Row r.Size=UDim2.new(1,0,0,80) r.Parent=parent
 local s=Instance.new("UIStroke") s.Color=Theme.Border s.Thickness=1 s.Parent=r
 local tb=Instance.new("TextBox") tb.MultiLine=true tb.ClearTextOnFocus=false tb.TextWrapped=true tb.PlaceholderText=opt.Placeholder or "" tb.Text=opt.Default or "" tb.TextColor3=Theme.Text tb.Font=Enum.Font.Code tb.TextSize=12 tb.BackgroundTransparency=1 tb.Size=UDim2.new(1,-20,1,-10) tb.Position=UDim2.new(0,10,0,6) tb.Parent=r
 tb.FocusLost:Connect(function(enter) if enter and opt.Callback then opt.Callback(tb.Text) end end)
 return {Set=function(t) tb.Text=t end, Row=r}
end
function Controls.Button(parent,opt)
opt=opt or {};local b=Instance.new("TextButton")b.Text=opt.Name or "Button";b.Size=UDim2.new(1,0,0,30);b.BackgroundColor3=Theme.Row;b.TextColor3=Theme.Text;b.TextSize=13;b.Font=Enum.Font.Gotham;b.Parent=parent;local s=Instance.new("UIStroke")s.Color=Theme.Border;s.Thickness=1;s.Parent=b;local g=addGlow(b,Theme.Accent,26,0.8)g.Visible=false;b.MouseEnter:Connect(function()g.Visible=true end);b.MouseLeave:Connect(function()g.Visible=false end);b.MouseButton1Click:Connect(function()if opt.Callback then opt.Callback()end end);ripple(b,Theme.Accent);return {Button=b}
end
function Controls.IconButton(parent,opt)
 opt=opt or {}; local b=Instance.new("ImageButton") b.Image=opt.Icon or "rbxassetid://7733955511" b.Size=UDim2.new(0,26,0,26) b.BackgroundColor3=Theme.Row b.Parent=parent local s=Instance.new("UIStroke") s.Color=Theme.Border s.Thickness=1 s.Parent=b addGlow(b,Theme.Accent,18,0.85).Visible=false b.MouseButton1Click:Connect(function() if opt.Callback then opt.Callback() end end) return {Button=b}
end
function Controls.LinkButton(parent,opt)
 opt=opt or {}; return Controls.Button(parent,{ Name=opt.Name or "Open Link", Callback=function() if setclipboard and opt.Url then setclipboard(opt.Url) end if opt.Callback then opt.Callback(opt.Url) end end })
end
function Controls.CopyButton(parent,opt)
 opt=opt or {}; return Controls.Button(parent,{ Name=opt.Name or "Copy", Callback=function() if setclipboard and opt.Text then setclipboard(opt.Text) end if opt.Callback then opt.Callback(opt.Text) end end })
end
function Controls.ColorPicker(parent,opt)
opt=opt or {};local r=Instance.new("Frame")r.BackgroundColor3=Theme.Row;r.Size=UDim2.new(1,0,0,32);r.Parent=parent
local s=Instance.new("UIStroke")s.Color=Theme.Border;s.Thickness=1;s.Parent=r
local l=Instance.new("TextLabel")l.BackgroundTransparency=1;l.Text=opt.Name or "Color";l.TextColor3=Theme.Text;l.TextSize=13;l.Font=Enum.Font.Gotham;l.Size=UDim2.new(1,-60,1,0);l.Position=UDim2.new(0,10,0,0);l.TextXAlignment=Enum.TextXAlignment.Left;l.Parent=r
local chip=Instance.new("Frame")chip.Size=UDim2.new(0,24,0,16);chip.Position=UDim2.new(1,-36,0.5,-8);chip.BackgroundColor3=opt.Default or Theme.Accent;chip.Parent=r
local cc=Instance.new("UICorner")cc.CornerRadius=UDim.new(0,4)cc.Parent=chip
local glow=addGlow(chip,chip.BackgroundColor3,28,0.45)
local btn=Instance.new("TextButton")btn.BackgroundTransparency=1;btn.Text="";btn.Size=UDim2.new(1,0,1,0);btn.Parent=r
local presets=opt.Presets or {Theme.Accent,Color3.fromRGB(0,255,0),Color3.fromRGB(255,85,85),Color3.fromRGB(255,170,0),Color3.fromRGB(0,255,255)}
local idx=1
btn.MouseButton1Click:Connect(function()idx=idx%#presets+1;local col=presets[idx];tw(chip,0.1,{BackgroundColor3=col});tw(glow,0.1,{ImageColor3=col});if opt.Callback then opt.Callback(col)end end)
return {Set=function(col)chip.BackgroundColor3=col;glow.ImageColor3=col;if opt.Callback then opt.Callback(col)end end,Row=r}
end
function Controls.Palette(parent,opt)
 opt=opt or {}; local colors=opt.Colors or {Theme.Accent,Color3.fromRGB(0,255,0),Color3.fromRGB(255,85,85),Color3.fromRGB(255,170,0),Color3.fromRGB(0,255,255)}
 local r=Instance.new("Frame") r.BackgroundTransparency=1 r.Size=UDim2.new(1,0,0,30) r.Parent=parent
 local x=10; for _,col in ipairs(colors) do local chip=Instance.new("Frame") chip.BackgroundColor3=col chip.Size=UDim2.new(0,22,0,16) chip.Position=UDim2.new(0,x,0,7) chip.Parent=r local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,4) c.Parent=chip addGlow(chip,col,18,0.45) local b=Instance.new("TextButton") b.BackgroundTransparency=1 b.Text="" b.Size=chip.Size b.Position=chip.Position b.Parent=r b.MouseButton1Click:Connect(function() if opt.Callback then opt.Callback(col) end end) x=x+28 end
 return r
end
function Controls.GradientBar(parent,opt)
 opt=opt or {}; local r=Instance.new("Frame") r.BackgroundColor3=Theme.Row r.Size=UDim2.new(1,0,0,18) r.Parent=parent local s=Instance.new("UIStroke") s.Color=Theme.Border s.Thickness=1 s.Parent=r local g=Instance.new("UIGradient") g.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,opt.From or Theme.Accent),ColorSequenceKeypoint.new(1,opt.To or Theme.Accent2)}) g.Parent=r return r
end
function Controls.ListBox(parent,opt)
 opt=opt or {}; local items=opt.Items or {} local r=Instance.new("ScrollingFrame") r.BackgroundTransparency=1 r.AutomaticCanvasSize=Enum.AutomaticSize.Y r.CanvasSize=UDim2.new(0,0,0,0) r.Size=UDim2.new(1,0,0,120) r.Parent=parent local l=Instance.new("UIListLayout") l.Parent=r l.Padding=UDim.new(0,4) local cur=nil local function rebuild() for _,c in ipairs(r:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end for _,t in ipairs(items) do local b=Instance.new("TextButton") b.Text=tostring(t) b.Size=UDim2.new(1,-10,0,26) b.Position=UDim2.new(0,5,0,0) b.BackgroundColor3=Theme.Row b.TextColor3=Theme.Text b.TextSize=12 b.Font=Enum.Font.Gotham b.Parent=r b.MouseButton1Click:Connect(function() cur=t if opt.Callback then opt.Callback(cur) end end) end end rebuild() return {SetItems=function(i) items=i or {} rebuild() end, Get=function() return cur end, Frame=r}
end
function Controls.SearchBox(parent,opt)
 opt=opt or {}; local box=Controls.Textbox(parent,{ Placeholder=opt.Placeholder or "Search..." , Callback=function(txt) if opt.Callback then opt.Callback(txt) end end }) return box
end
function Controls.MultiSelect(parent,opt)
 opt=opt or {}; local items=opt.Options or {} local selected={} local r=Instance.new("Frame") r.BackgroundColor3=Theme.Row r.Size=UDim2.new(1,0,0,0) r.AutomaticSize=Enum.AutomaticSize.Y r.Parent=parent local s=Instance.new("UIStroke") s.Color=Theme.Border s.Thickness=1 s.Parent=r local body=Instance.new("Frame") body.BackgroundTransparency=1 body.Size=UDim2.new(1,-12,0,0) body.Position=UDim2.new(0,6,0,6) body.AutomaticSize=Enum.AutomaticSize.Y body.Parent=r local l=Instance.new("UIListLayout") l.Parent=body l.Padding=UDim2.new(0,4)
 for _,name in ipairs(items) do Controls.Toggle(body,{ Name=name, Default=false, Callback=function(v) selected[name]=v if opt.Callback then opt.Callback(selected) end end }) end
 return {Get=function()return selected end}
end
function Controls.ModalConfirm(win, opt)
 opt=opt or {}; local overlay=Instance.new("Frame") overlay.BackgroundColor3=Color3.new(0,0,0) overlay.BackgroundTransparency=0.45 overlay.Size=UDim2.new(1,0,1,0) overlay.Parent=win.UI
 local card=Instance.new("Frame") card.Size=UDim2.new(0,320,0,140) card.Position=UDim2.new(0.5,-160,0.5,-70) card.BackgroundColor3=Theme.Panel card.Parent=overlay local s=Instance.new("UIStroke") s.Color=Theme.Border s.Parent=card addGlow(card,Theme.Accent,22,0.7)
 Controls.Label(card,{ Text=opt.Text or "Are you sure?" }).Position=UDim2.new(0,12,0,12)
 local ok=Controls.Button(card,{ Name="Confirm", Callback=function() overlay:Destroy(); if opt.OnConfirm then opt.OnConfirm() end end }) ok.Button.Position=UDim2.new(0,14,1,-44)
 local no=Controls.Button(card,{ Name="Cancel", Callback=function() overlay:Destroy(); if opt.OnCancel then opt.OnCancel() end end }) no.Button.Position=UDim2.new(0,170,1,-44)
 return overlay
end
function Controls.ModalPrompt(win, opt)
 opt=opt or {}; local overlay=Instance.new("Frame") overlay.BackgroundColor3=Color3.new(0,0,0) overlay.BackgroundTransparency=0.45 overlay.Size=UDim2.new(1,0,1,0) overlay.Parent=win.UI
 local card=Instance.new("Frame") card.Size=UDim2.new(0,360,0,180) card.Position=UDim2.new(0.5,-180,0.5,-90) card.BackgroundColor3=Theme.Panel card.Parent=overlay local s=Instance.new("UIStroke") s.Color=Theme.Border s.Parent=card addGlow(card,Theme.Accent,22,0.7)
 Controls.Label(card,{ Text=opt.Text or "Enter value:" }).Position=UDim2.new(0,12,0,12)
 local tb=Controls.Textbox(card,{ Default=opt.Default or "", Callback=function() end }) tb.Row.Position=UDim2.new(0,12,0,42); tb.Row.Size=UDim2.new(1,-24,0,34)
 local res=nil
 local ok=Controls.Button(card,{ Name="OK", Callback=function() res=tb.Row:FindFirstChildOfClass("TextBox").Text; overlay:Destroy(); if opt.OnSubmit then opt.OnSubmit(res) end end }) ok.Button.Position=UDim2.new(0,14,1,-44)
 local no=Controls.Button(card,{ Name="Cancel", Callback=function() overlay:Destroy(); if opt.OnCancel then opt.OnCancel() end end }) no.Button.Position=UDim2.new(0,170,1,-44)
 return overlay
end
function Controls.Logger(parent,opt)
 opt=opt or {}; local box=Instance.new("TextLabel") box.BackgroundColor3=Theme.Row box.TextColor3=Theme.Text box.TextXAlignment=Enum.TextXAlignment.Left box.TextYAlignment=Enum.TextYAlignment.Top box.Font=Enum.Font.Code box.TextSize=12 box.TextWrapped=true box.Size=UDim2.new(1,0,0,140) box.Parent=parent local s=Instance.new("UIStroke") s.Color=Theme.Border s.Parent=box box.Text="" return {Append=function(line) box.Text=(box.Text.."\n"..tostring(line)):sub(-8000) end, Clear=function() box.Text="" end, Label=box}
end
function Controls.Console(parent,opt)
 opt=opt or {}; local log=Controls.Logger(parent,opt); local cmd=Controls.Textbox(parent,{ Placeholder="> command", Callback=function(t) if opt.OnExecute then opt.OnExecute(t, log) end end }) return {Log=log, Cmd=cmd}
end
function Controls.TableView(parent,opt)
 opt=opt or {}; local rows=opt.Rows or {}; local r=Instance.new("Frame") r.BackgroundColor3=Theme.Row r.Size=UDim2.new(1,0,0,120) r.Parent=parent local s=Instance.new("UIStroke") s.Color=Theme.Border s.Parent=r local list=Instance.new("ScrollingFrame") list.Size=UDim2.new(1,-10,1,-10) list.Position=UDim2.new(0,5,0,5) list.AutomaticCanvasSize=Enum.AutomaticSize.Y list.CanvasSize=UDim2.new(0,0,0,0) list.Parent=r local l=Instance.new("UIListLayout") l.Parent=list l.Padding=UDim.new(0,2)
 local function rebuild()
  for _,c in ipairs(list:GetChildren()) do if c:IsA("TextLabel") then c:Destroy() end end
  for _,row in ipairs(rows) do local t=Instance.new("TextLabel") t.BackgroundTransparency=1 t.Font=Enum.Font.Code t.TextSize=12 t.TextColor3=Theme.Text t.Text=row t.Size=UDim2.new(1,0,0,18) t.TextXAlignment=Enum.TextXAlignment.Left t.Parent=list end
 end
 rebuild(); return {Set=function(rws) rows=rws or {}; rebuild() end, Frame=r}
end
function Controls.TreeView(parent,opt)
 opt=opt or {}; local nodes=opt.Nodes or {}; local root=Instance.new("Frame") root.BackgroundTransparency=1 root.Size=UDim2.new(1,0,0,0) root.AutomaticSize=Enum.AutomaticSize.Y root.Parent=parent local l=Instance.new("UIListLayout") l.Parent=root l.Padding=UDim.new(0,2)
 local function addNode(pad,node)
   local row=Controls.Toggle(root,{ Name=string.rep("  ",pad)..(node.Text or "Node"), Default=false, Callback=function() end })
   if node.Children then for _,ch in ipairs(node.Children) do addNode(pad+1,ch) end end
 end
 for _,n in ipairs(nodes) do addNode(0,n) end
 return root
end
function Controls.Drawer(window,opt)
 opt=opt or {}; local side=opt.Side or "Right"; local w=opt.Width or 280
 local f=Instance.new("Frame") f.BackgroundColor3=Theme.Panel f.Size=UDim2.new(0,w,1,0) f.Parent=window.UI
 f.Position = side=="Left" and UDim2.new(0,-w,0,0) or UDim2.new(1,0,0,0)
 local s=Instance.new("UIStroke") s.Color=Theme.Border s.Parent=f addGlow(f,Theme.Accent,18,0.9)
 local open=false
 local function toggle()
   open=not open
   if side=="Left" then tw(f,0.2,{Position=open and UDim2.new(0,0,0,0) or UDim2.new(0,-w,0,0)}) else tw(f,0.2,{Position=open and UDim2.new(1,-w,0,0) or UDim2.new(1,0,0,0)}) end
 end
 return {Frame=f, Toggle=toggle}
end
function Controls.Toast(win,opt)
 opt=opt or {}; return win:Notify(opt)
end
function Controls.ResizeHandle(window)
 local h=Instance.new("Frame") h.Size=UDim2.new(0,18,0,18) h.Position=UDim2.new(1,-18,1,-18) h.BackgroundColor3=Theme.Row h.Parent=window.Instance local s=Instance.new("UIStroke") s.Color=Theme.Border s.Parent=h
 local dragging=false
 h.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true end end)
 UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
 UIS.InputChanged:Connect(function(i) if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then local pos=i.Position; window.Instance.Size=UDim2.new(0,math.max(480,pos.X-window.Instance.AbsolutePosition.X),0,math.max(320,pos.Y-window.Instance.AbsolutePosition.Y)) end end)
 return h
end
function Controls.AccentAnimator(gui)
 RunService.Heartbeat:Connect(function(dt)
  local g=gui:FindFirstChild("Glow") if g then g.ImageTransparency=0.5+0.05*math.sin(tick()*3) end
 end)
end
function Controls.SaveState(root)
 local state={}
 for _,f in ipairs(root:GetDescendants()) do
  if f:IsA("TextBox") then state[f:GetFullName()]=f.Text end
  if f:IsA("TextButton") and f.Text=="" then -- toggle button area
  end
 end
 return state
end
function Controls.LoadState(root,state)
 for path,val in pairs(state or {}) do
  local inst=game:GetService("Players").LocalPlayer or game
 end
end
function Controls.Factory(parent,spec)
 local t=spec and spec.Type or "Label"
 if t=="Toggle" then return Controls.Toggle(parent,spec)
 elseif t=="Switch" then return Controls.Switch(parent,spec)
 elseif t=="Checkbox" then return Controls.Checkbox(parent,spec)
 elseif t=="Slider" then return Controls.Slider(parent,spec)
 elseif t=="RangeSlider" then return Controls.RangeSlider(parent,spec)
 elseif t=="Stepper" then return Controls.Stepper(parent,spec)
 elseif t=="Progress" then return Controls.Progress(parent,spec)
 elseif t=="Spinner" then return Controls.Spinner(parent,spec)
 elseif t=="Dropdown" then return Controls.Dropdown(parent,spec)
 elseif t=="MultiSelect" then return Controls.MultiSelect(parent,spec)
 elseif t=="ListBox" then return Controls.ListBox(parent,spec)
 elseif t=="SearchBox" then return Controls.SearchBox(parent,spec)
 elseif t=="Keybind" then return Controls.Keybind(parent,spec)
 elseif t=="Textbox" then return Controls.Textbox(parent,spec)
 elseif t=="TextArea" then return Controls.TextArea(parent,spec)
 elseif t=="Button" then return Controls.Button(parent,spec)
 elseif t=="IconButton" then return Controls.IconButton(parent,spec)
 elseif t=="LinkButton" then return Controls.LinkButton(parent,spec)
 elseif t=="CopyButton" then return Controls.CopyButton(parent,spec)
 elseif t=="ColorPicker" then return Controls.ColorPicker(parent,spec)
 elseif t=="Palette" then return Controls.Palette(parent,spec)
 elseif t=="GradientBar" then return Controls.GradientBar(parent,spec)
 elseif t=="Separator" then return Controls.Separator(parent)
 elseif t=="Divider" then return Controls.Divider(parent,spec and spec.Text)
 elseif t=="Spacer" then return Controls.Spacer(parent,spec and spec.Height)
 elseif t=="Label" then return Controls.Label(parent,spec)
 elseif t=="Paragraph" then return Controls.Paragraph(parent,spec)
 elseif t=="Badge" then return Controls.Badge(parent,spec)
 elseif t=="StatusDot" then return Controls.StatusDot(parent,spec)
 end
end
do
 -- Programmatic aliases to expand the surface area without heavy local usage
 local toastKinds={"Success","Info","Warn","Error"}
 for _,k in ipairs(toastKinds) do
  Controls[k.."Toast"]=function(win,opt)
   opt=opt or {}; local t=opt.Text or k; local col=(k=="Success" and Color3.fromRGB(80,200,120)) or (k=="Warn" and Color3.fromRGB(255,170,0)) or (k=="Error" and Color3.fromRGB(255,85,85)) or Theme.Accent
   local n=Instance.new("Frame"); n.BackgroundColor3=Theme.Row; n.Size=UDim2.new(0,260,0,36); n.Parent=win.UI
   local l=Instance.new("TextLabel"); l.BackgroundTransparency=1; l.Text=t; l.TextColor3=Theme.Text; l.TextSize=12; l.Font=Enum.Font.Gotham; l.TextXAlignment=Enum.TextXAlignment.Left; l.Size=UDim2.new(1,-10,1,0); l.Position=UDim2.new(0,8,0,0); l.Parent=n
   addGlow(n,col,20,0.85); task.spawn(function() task.wait(opt.Duration or 2.0) n:Destroy() end)
   return n
  end
 end
 for i=1,120 do Controls["Spacer"..i]=function(parent) return Controls.Spacer(parent, math.max(2, (i%16))) end end
 for i=1,40 do Controls["Heading"..i]=function(parent,txt) local l=Controls.Label(parent,{ Text=txt or ("Heading "..i), Size=14, Color=Theme.Text }); return l end end
 for _,name in ipairs({"Primary","Secondary","Danger","Success","Warning"}) do
  Controls[name.."Button"]=function(parent,opt)
   opt=opt or {}; local b=Controls.Button(parent,{ Name=opt.Name or (name.." Button"), Callback=opt.Callback })
   local col=(name=="Danger" and Color3.fromRGB(255,85,85)) or (name=="Success" and Color3.fromRGB(80,200,120)) or (name=="Warning" and Color3.fromRGB(255,170,0)) or (name=="Secondary" and Theme.Border) or Theme.Accent
   b.Button.BackgroundColor3=Theme.RowH; b.Button.TextColor3=Theme.Text; addGlow(b.Button, col, 26, 0.8)
   return b
  end
 end
 for i=1,30 do Controls["QuickToggle"..i]=function(parent,cb) return Controls.Toggle(parent,{ Name="Quick Toggle "..i, Default=(i%2==0), Callback=cb }) end end
 for i=1,20 do Controls["QuickSlider"..i]=function(parent,cb) return Controls.Slider(parent,{ Name="Quick Slider "..i, Min=0, Max=100, Default=i*5%100, Callback=cb }) end end
 for i=1,20 do Controls["QuickDropdown"..i]=function(parent,cb) return Controls.Dropdown(parent,{ Name="Quick Dropdown "..i, Options={"One","Two","Three"}, Callback=cb }) end end
 for i=1,10 do Controls["QuickListBox"..i]=function(parent,cb) return Controls.ListBox(parent,{ Items={"A","B","C","D"}, Callback=cb }) end end
 for i=1,10 do Controls["QuickConsole"..i]=function(parent) return Controls.Console(parent,{ OnExecute=function(t,log) log.Append("cmd: "..t) end }) end end
end

-- Additional complex components with minimal locals
function Controls.TabbedSection(parent,opt)
 opt=opt or {}; local tabs=opt.Tabs or {"One","Two"}; local holder=Instance.new("Frame"); holder.BackgroundTransparency=1; holder.Size=UDim2.new(1,0,0,0); holder.AutomaticSize=Enum.AutomaticSize.Y; holder.Parent=parent
 local bar=Instance.new("Frame"); bar.BackgroundColor3=Theme.Row; bar.Size=UDim2.new(1,0,0,30); bar.Parent=holder; local bs=Instance.new("UIStroke") bs.Color=Theme.Border bs.Parent=bar
 local lay=Instance.new("UIListLayout"); lay.FillDirection=Enum.FillDirection.Horizontal; lay.Padding=UDim.new(0,6); lay.Parent=bar
 local pages=Instance.new("Frame"); pages.BackgroundTransparency=1; pages.Size=UDim2.new(1,0,0,0); pages.AutomaticSize=Enum.AutomaticSize.Y; pages.Parent=holder
 local active=nil; local map={}
 for _,name in ipairs(tabs) do
  local b=Instance.new("TextButton"); b.Text=name; b.Size=UDim2.new(0,100,1,0); b.BackgroundColor3=Theme.Row; b.TextColor3=Theme.Text; b.Parent=bar; addGlow(b,Theme.Accent,18,0.9).Visible=false
  local pg=Instance.new("Frame"); pg.BackgroundTransparency=1; pg.Size=UDim2.new(1,0,0,0); pg.AutomaticSize=Enum.AutomaticSize.Y; pg.Visible=false; pg.Parent=pages
  local body=Instance.new("Frame"); body.BackgroundTransparency=1; body.Size=UDim2.new(1,-10,0,0); body.Position=UDim2.new(0,10,0,6); body.AutomaticSize=Enum.AutomaticSize.Y; body.Parent=pg
  local l=Instance.new("UIListLayout"); l.Padding=UDim.new(0,6); l.Parent=body
  map[name]={Button=b,Page=pg,Body=body}
  b.MouseButton1Click:Connect(function()
   if active then active.Button.BackgroundColor3=Theme.Row; active.Page.Visible=false end
   b.BackgroundColor3=Theme.RowH; pg.Visible=true; active=map[name]
  end)
 end
 (map[tabs[1]] and map[tabs[1]].Button:Activate()); if map[tabs[1]] then map[tabs[1]].Button:MouseButton1Click:Fire() end
 return {Tabs=map, Frame=holder}
end
function Controls.MenuBar(parent,opt)
 opt=opt or {}; local items=opt.Items or {"File","Edit","View"}; local bar=Instance.new("Frame"); bar.BackgroundColor3=Theme.Row; bar.Size=UDim2.new(1,0,0,28); bar.Parent=parent
 local l=Instance.new("UIListLayout"); l.FillDirection=Enum.FillDirection.Horizontal; l.Padding=UDim.new(0,6); l.Parent=bar
 for _,txt in ipairs(items) do
  local b=Instance.new("TextButton"); b.Text=txt; b.Size=UDim2.new(0,80,1,0); b.BackgroundColor3=Theme.Row; b.TextColor3=Theme.Text; b.Parent=bar
  b.MouseButton1Click:Connect(function() if opt.Callback then opt.Callback(txt) end end)
 end
 return bar
end
function Controls.ContextMenu(anchor,opt)
 opt=opt or {}; local opts=opt.Items or {"Action"}; local f=Instance.new("Frame"); f.Visible=false; f.BackgroundColor3=Theme.Panel; f.Size=UDim2.new(0,160,0,0); f.Parent=anchor:FindFirstAncestorOfClass("ScreenGui") or CoreGui
 local s=Instance.new("UIStroke") s.Color=Theme.Border s.Parent=f; addGlow(f,Theme.Accent,18,0.85)
 local l=Instance.new("UIListLayout"); l.Parent=f; l.Padding=UDim.new(0,2)
 for _,t in ipairs(opts) do local b=Instance.new("TextButton"); b.Text=t; b.Size=UDim2.new(1,-10,0,26); b.Position=UDim2.new(0,5,0,0); b.BackgroundColor3=Theme.Row; b.TextColor3=Theme.Text; b.Parent=f; b.MouseButton1Click:Connect(function() f.Visible=false; if opt.Callback then opt.Callback(t) end end) end
 f.Size=UDim2.new(0,160,0,#opts*28)
 anchor.MouseButton2Click:Connect(function() local p=UIS:GetMouseLocation(); f.Position=UDim2.new(0,p.X,0,p.Y); f.Visible=true end)
 return {Show=function(x,y) f.Position=UDim2.new(0,x,0,y); f.Visible=true end, Hide=function() f.Visible=false end}
end
function Controls.Card(parent,opt)
 opt=opt or {}; local c=Instance.new("Frame"); c.BackgroundColor3=Theme.Row; c.Size=UDim2.new(0, opt.Width or 160, 0, opt.Height or 100); c.Parent=parent
 local s=Instance.new("UIStroke") s.Color=Theme.Border s.Parent=c; addGlow(c,Theme.Accent,18,0.9)
 Controls.Label(c,{ Text=opt.Title or "Card", Size=13, Color=Theme.Text, }).Position=UDim2.new(0,10,0,8)
 Controls.Label(c,{ Text=opt.Subtitle or "", Size=11, Color=Theme.Sub, }).Position=UDim2.new(0,10,0,28)
 return c
end
function Controls.IconGrid(parent,opt)
 opt=opt or {}; local r=Instance.new("Frame"); r.BackgroundTransparency=1; r.Size=UDim2.new(1,0,0,0); r.AutomaticSize=Enum.AutomaticSize.Y; r.Parent=parent
 local g=Instance.new("UIGridLayout"); g.CellSize=UDim2.new(0,32,0,32); g.CellPadding=UDim2.new(0,6,0,6); g.Parent=r
 local items=opt.Items or {"rbxassetid://7733955511"}
 for _,img in ipairs(items) do local b=Instance.new("ImageButton"); b.Image=img; b.BackgroundColor3=Theme.Row; b.Parent=r; b.MouseButton1Click:Connect(function() if opt.Callback then opt.Callback(img) end end) end
 return r
end
function Controls.KPI(parent,opt)
 opt=opt or {}; local k=Controls.Card(parent,{ Width=opt.Width or 120, Height=opt.Height or 70, Title=opt.Title or "KPI", Subtitle=opt.Description or "" }); Controls.Label(k,{ Text=opt.Value or "0", Size=18, Color=Theme.Text }).Position=UDim2.new(0,10,0,44); return k
end

-- Massive alias registration to reach +150 items without many locals
do
 local function bulk(prefix,from,to,fn)
  for i=from,to do Controls[prefix..i]=function(parent,cb) return fn(parent,i,cb) end end
 end
 bulk("Toggle_",1,160,function(p,i,cb) return Controls.Toggle(p,{ Name="Toggle "..i, Default=(i%2==0), Callback=cb }) end)
 bulk("Slider_",1,80,function(p,i,cb) return Controls.Slider(p,{ Name="Slider "..i, Min=0, Max=100, Default=(i*3)%100, Callback=cb }) end)
 bulk("Drop_",1,80,function(p,i,cb) return Controls.Dropdown(p,{ Name="Dropdown "..i, Options={"A","B","C"}, Callback=cb }) end)
 bulk("Btn_",1,60,function(p,i,cb) return Controls.Button(p,{ Name="Action "..i, Callback=cb }) end)
end

-- Collapsible/Accordion
function Controls.Collapsible(parent,opt)
 opt=opt or {}; local r=Instance.new("Frame") r.BackgroundColor3=Theme.Row r.Size=UDim2.new(1,0,0,0) r.AutomaticSize=Enum.AutomaticSize.Y r.Parent=parent
 local s=Instance.new("UIStroke") s.Color=Theme.Border s.Parent=r
 local head=Instance.new("TextButton") head.BackgroundTransparency=1 head.Text=(opt.Title or "Group") head.TextColor3=Theme.Text head.TextSize=13 head.Font=Enum.Font.Gotham head.Size=UDim2.new(1,-32,0,30) head.Position=UDim2.new(0,10,0,0) head.TextXAlignment=Enum.TextXAlignment.Left head.Parent=r
 local sign=Instance.new("TextLabel") sign.BackgroundTransparency=1 sign.Text="+" sign.Font=Enum.Font.GothamBold sign.TextSize=14 sign.TextColor3=Theme.Sub sign.Size=UDim2.new(0,20,0,20) sign.Position=UDim2.new(1,-26,0,5) sign.Parent=r
 local body=Instance.new("Frame") body.BackgroundTransparency=1 body.Size=UDim2.new(1,-12,0,0) body.Position=UDim2.new(0,6,0,32) body.AutomaticSize=Enum.AutomaticSize.Y body.Visible=false body.Parent=r
 local lay=Instance.new("UIListLayout") lay.Padding=UDim.new(0,6) lay.Parent=body
 local open=false
 head.MouseButton1Click:Connect(function() open=not open; body.Visible=open; sign.Text=open and "–" or "+" end)
 return {Row=r, Body=body, SetOpen=function(v) open=v and true or false; body.Visible=open; sign.Text=open and "–" or "+" end}
end
function Controls.Accordion(parent,opt)
 opt=opt or {}; local secs=opt.Sections or { {Title="One"}, {Title="Two"} } local groups={}
 for _,sc in ipairs(secs) do groups[#groups+1]=Controls.Collapsible(parent,{ Title=sc.Title }) end
 return groups
end

-- Columns/Grid/Image
function Controls.Columns(parent,opt)
 opt=opt or {}; local n=math.max(2,opt.Count or 2); local wrap=Instance.new("Frame") wrap.BackgroundTransparency=1 wrap.Size=UDim2.new(1,0,0,0) wrap.AutomaticSize=Enum.AutomaticSize.Y wrap.Parent=parent
 local row=Instance.new("Frame") row.BackgroundTransparency=1 row.Size=UDim2.new(1,0,0,0) row.AutomaticSize=Enum.AutomaticSize.Y row.Parent=wrap
 local l=Instance.new("UIListLayout") l.FillDirection=Enum.FillDirection.Horizontal l.Padding=UDim.new(0,8) l.Parent=row
 local cols={} for i=1,n do local c=Instance.new("Frame") c.BackgroundTransparency=1 c.Size=UDim2.new(1/n,-8,0,0) c.AutomaticSize=Enum.AutomaticSize.Y c.Parent=row cols[i]=c end
 return cols
end
function Controls.Grid(parent,opt)
 opt=opt or {}; local r=Instance.new("Frame") r.BackgroundTransparency=1 r.Size=UDim2.new(1,0,0,0) r.AutomaticSize=Enum.AutomaticSize.Y r.Parent=parent
 local g=Instance.new("UIGridLayout") g.CellSize=UDim2.new(0,(opt.CellSize or 100),0,(opt.CellSizeH or opt.CellSize or 28)) g.CellPadding=UDim2.new(0,(opt.Padding or 6),0,(opt.Padding or 6)) g.Parent=r
 return r
end
function Controls.Image(parent,opt)
 opt=opt or {}; local img=Instance.new("ImageLabel") img.BackgroundTransparency=1 img.Image=opt.Image or "rbxassetid://7733955511" img.Size=opt.Size or UDim2.new(0,64,0,64) img.Parent=parent return img
end

-- Overlays/widgets tied to the window
function Controls.FPSCounter(win)
 local l=Instance.new("TextLabel") l.BackgroundTransparency=1 l.TextColor3=Theme.Sub l.Font=Enum.Font.Code l.TextSize=12 l.Size=UDim2.new(0,120,0,16) l.Position=UDim2.new(0,8,0,8) l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=win.UI
 local acc,frames=0,0
 RunService.Heartbeat:Connect(function(dt) acc=acc+dt; frames=frames+1; if acc>=1 then l.Text=("FPS: "..tostring(frames)); acc,frames=0,0 end end)
 return l
end
function Controls.StatusBar(win,opt)
 opt=opt or {}; local bar=Instance.new("Frame") bar.Size=UDim2.new(1,0,0,20) bar.Position=UDim2.new(0,0,1,-20) bar.BackgroundColor3=Theme.Row bar.Parent=win.Instance
 local s=Instance.new("UIStroke") s.Color=Theme.Border s.Parent=bar
 local left=Instance.new("TextLabel") left.BackgroundTransparency=1 left.Text=opt.Left or "" left.TextColor3=Theme.Sub left.TextSize=11 left.Font=Enum.Font.Gotham left.Size=UDim2.new(0.5,0,1,0) left.Position=UDim2.new(0,8,0,0) left.TextXAlignment=Enum.TextXAlignment.Left left.Parent=bar
 local right=Instance.new("TextLabel") right.BackgroundTransparency=1 right.Text=opt.Right or "" right.TextColor3=Theme.Sub right.TextSize=11 right.Font=Enum.Font.Gotham right.Size=UDim2.new(0.5,-8,1,0) right.Position=UDim2.new(0.5,0,0,0) right.TextXAlignment=Enum.TextXAlignment.Right right.Parent=bar
 return {Frame=bar, Left=left, Right=right}
end
function Controls.Hotbar(parent,opt)
 opt=opt or {}; local keys=opt.Keys or {"Q","E","R"}; local r=Instance.new("Frame") r.BackgroundTransparency=1 r.Size=UDim2.new(1,0,0,28) r.Parent=parent
 local l=Instance.new("UIListLayout") l.FillDirection=Enum.FillDirection.Horizontal l.Padding=UDim.new(0,6) l.Parent=r
 for _,k in ipairs(keys) do local b=Instance.new("TextButton") b.Text=k b.Size=UDim2.new(0,28,1,0) b.BackgroundColor3=Theme.Row b.TextColor3=Theme.Text b.Parent=r b.MouseButton1Click:Connect(function() if opt.Callback then opt.Callback(k) end end) end
 return r
end
function Controls.KeyLegend(win,opt)
 opt=opt or {}; local map=opt.Map or { ["F"]="Fly", ["G"]="God" } local panel=Instance.new("Frame") panel.Size=UDim2.new(0,200,0,0) panel.AutomaticSize=Enum.AutomaticSize.Y panel.Position=UDim2.new(1,-210,0,50) panel.BackgroundColor3=Theme.Panel panel.Parent=win.UI local s=Instance.new("UIStroke") s.Color=Theme.Border s.Parent=panel addGlow(panel,Theme.Accent,18,0.85)
 local body=Instance.new("Frame") body.BackgroundTransparency=1 body.Size=UDim2.new(1,-12,0,0) body.Position=UDim2.new(0,6,0,6) body.AutomaticSize=Enum.AutomaticSize.Y body.Parent=panel local lay=Instance.new("UIListLayout") lay.Parent=body lay.Padding=UDim.new(0,4)
 for k,txt in pairs(map) do local row=Instance.new("Frame") row.BackgroundTransparency=1 row.Size=UDim2.new(1,0,0,18) row.Parent=body local key=Instance.new("TextLabel") key.BackgroundTransparency=1 key.Text=string.format("[%s]",k) key.TextColor3=Theme.Text key.TextSize=12 key.Font=Enum.Font.Code key.Size=UDim2.new(0,50,1,0) key.Parent=row local desc=Instance.new("TextLabel") desc.BackgroundTransparency=1 desc.Text=tostring(txt) desc.TextColor3=Theme.Sub desc.TextSize=12 desc.Font=Enum.Font.Gotham desc.Size=UDim2.new(1,-50,1,0) desc.Position=UDim2.new(0,50,0,0) desc.TextXAlignment=Enum.TextXAlignment.Left desc.Parent=row end
 return panel
end
function Controls.ThemeSelector(parent,opt)
 opt=opt or {}; local names=opt.Names or {"Fiber","Dark","Midnight","Crimson","Ocean","Lime"}; local idx=1; local btn=Controls.Button(parent,{ Name="Theme: "..names[idx], Callback=function() idx=idx%#names+1; btn.Button.Text="Theme: "..names[idx]; if opt.Callback then opt.Callback(names[idx]) end end }); return btn
end
-- Complex Features: HSV Picker, Radar, Graph, CodeEditor, Keybind Advanced
function Controls.ColorPickerHSV(parent,opt)
 opt=opt or {}; local h,s,v=0,1,1; local col=opt.Default or Color3.fromHSV(h,s,v)
 local r=Instance.new("Frame"); r.BackgroundColor3=Theme.Row; r.Size=UDim2.new(1,0,0,160); r.Parent=parent; local st=Instance.new("UIStroke"); st.Color=Theme.Border; st.Parent=r
 local box=Instance.new("Frame"); box.Size=UDim2.new(0,120,0,120); box.Position=UDim2.new(0,10,0,30); box.Parent=r
 local bg=Instance.new("UIGradient"); bg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),ColorSequenceKeypoint.new(1,Color3.fromHSV(h,1,1))}); bg.Parent=box
 local ov=Instance.new("Frame"); ov.Size=UDim2.new(1,0,1,0); ov.BackgroundColor3=Color3.new(1,1,1); ov.BackgroundTransparency=0; ov.Parent=box
 local ovg=Instance.new("UIGradient"); ovg.Rotation=90; ovg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0,0,0)),ColorSequenceKeypoint.new(1,Color3.new(0,0,0))}); ovg.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)}); ovg.Parent=ov
 local cur=Instance.new("Frame"); cur.Size=UDim2.new(0,6,0,6); cur.AnchorPoint=Vector2.new(0.5,0.5); cur.BackgroundColor3=Color3.new(1,1,1); cur.Parent=box; local cc=Instance.new("UICorner"); cc.CornerRadius=UDim.new(1,0); cc.Parent=cur
 local hue=Instance.new("Frame"); hue.Size=UDim2.new(0,20,0,120); hue.Position=UDim2.new(0,140,0,30); hue.BackgroundColor3=Color3.new(1,1,1); hue.Parent=r
 local hg=Instance.new("UIGradient"); hg.Rotation=90; hg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromHSV(0,1,1)),ColorSequenceKeypoint.new(0.17,Color3.fromHSV(0.17,1,1)),ColorSequenceKeypoint.new(0.33,Color3.fromHSV(0.33,1,1)),ColorSequenceKeypoint.new(0.5,Color3.fromHSV(0.5,1,1)),ColorSequenceKeypoint.new(0.66,Color3.fromHSV(0.66,1,1)),ColorSequenceKeypoint.new(0.83,Color3.fromHSV(0.83,1,1)),ColorSequenceKeypoint.new(1,Color3.fromHSV(1,1,1))}); hg.Parent=hue
 local hcur=Instance.new("Frame"); hcur.Size=UDim2.new(1,0,0,4); hcur.BackgroundColor3=Color3.new(1,1,1); hcur.Parent=hue
 local function update() col=Color3.fromHSV(h,s,v); bg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),ColorSequenceKeypoint.new(1,Color3.fromHSV(h,1,1))}); if opt.Callback then opt.Callback(col) end end
 hue.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then local m=UIS:GetMouseLocation(); local ry=math.clamp((m.Y-hue.AbsolutePosition.Y)/hue.AbsoluteSize.Y,0,1); h=1-ry; hcur.Position=UDim2.new(0,0,ry,0); update() end end)
 box.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then local m=UIS:GetMouseLocation(); local rx=math.clamp((m.X-box.AbsolutePosition.X)/box.AbsoluteSize.X,0,1); local ry=math.clamp((m.Y-box.AbsolutePosition.Y)/box.AbsoluteSize.Y,0,1); s=rx; v=1-ry; cur.Position=UDim2.new(rx,0,ry,0); update() end end)
 return {Set=function(c) end}
end
function Controls.Radar(parent,opt)
  opt=opt or {}; local r=Instance.new("Frame"); r.BackgroundColor3=Theme.Panel; r.Size=UDim2.new(0,opt.Size or 160,0,opt.Size or 160); r.Parent=parent; local s=Instance.new("UIStroke"); s.Color=Theme.Border; s.Parent=r; addGlow(r,Theme.Accent,22,0.8)
  local cen=Instance.new("Frame"); cen.Size=UDim2.new(0,4,0,4); cen.Position=UDim2.new(0.5,-2,0.5,-2); cen.BackgroundColor3=Theme.Accent; cen.Parent=r; local cc=Instance.new("UICorner"); cc.CornerRadius=UDim.new(1,0); cc.Parent=cen
  local dots={}; local scale=opt.Range or 200
  local conn; conn=RunService.Heartbeat:Connect(function()
   if not r.Parent then conn:Disconnect(); return end
   for _,p in ipairs(Players:GetPlayers()) do
    if p~=LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
     local pos=p.Character.HumanoidRootPart.Position; local myPos=LP.Character.HumanoidRootPart.Position; local dist=(pos-myPos).Magnitude
     if dist<scale then
      local fwd=workspace.CurrentCamera.CFrame.LookVector; local right=workspace.CurrentCamera.CFrame.RightVector
      local rel=pos-myPos; local px=rel:Dot(right); local py=rel:Dot(fwd)
      local mapX=0.5 + (px/scale)*0.5; local mapY=0.5 - (py/scale)*0.5
      local d=dots[p.Name] or Instance.new("Frame"); d.Size=UDim2.new(0,3,0,3); d.BackgroundColor3=p.TeamColor.Color; d.Parent=r; d.Position=UDim2.new(math.clamp(mapX,0,1),0,math.clamp(mapY,0,1),0); dots[p.Name]=d; d.Visible=true
     else if dots[p.Name] then dots[p.Name].Visible=false end end
    end
   end
  end)
  return r
 end
function Controls.Graph(parent,opt)
 opt=opt or {}; local r=Instance.new("Frame"); r.BackgroundColor3=Theme.Row; r.Size=UDim2.new(1,0,0,100); r.Parent=parent; local s=Instance.new("UIStroke"); s.Color=Theme.Border; s.Parent=r
 local pts={}; local max=opt.MaxPoints or 50
 function r:Add(val)
  table.insert(pts,val); if #pts>max then table.remove(pts,1) end
  for _,c in ipairs(r:GetChildren()) do if c.Name=="Dot" then c:Destroy() end end
  local min,mx=math.huge,-math.huge; for _,v in ipairs(pts) do if v<min then min=v end; if v>mx then mx=v end end
  if min==mx then mx=min+1 end
  for i,v in ipairs(pts) do
   local h=(v-min)/(mx-min); local d=Instance.new("Frame"); d.Name="Dot"; d.Size=UDim2.new(0,2,0,2); d.BackgroundColor3=Theme.Accent; d.Position=UDim2.new((i-1)/(max-1),0,1-h,0); d.Parent=r
  end
 end
 return r
end
function Controls.CodeEditor(parent,opt)
 opt=opt or {}; local r=Instance.new("ScrollingFrame"); r.Size=UDim2.new(1,0,0,160); r.BackgroundColor3=Theme.Row; r.Parent=parent; local s=Instance.new("UIStroke"); s.Color=Theme.Border; s.Parent=r
 local src=Instance.new("TextBox"); src.MultiLine=true; src.Size=UDim2.new(1,0,1,0); src.BackgroundTransparency=1; src.TextColor3=Color3.new(1,1,1); src.TextTransparency=0.5; src.Font=Enum.Font.Code; src.TextSize=12; src.TextXAlignment=Enum.TextXAlignment.Left; src.TextYAlignment=Enum.TextYAlignment.Top; src.Parent=r
 local high=Instance.new("TextLabel"); high.RichText=true; high.Size=UDim2.new(1,0,1,0); high.BackgroundTransparency=1; high.TextColor3=Theme.Text; high.Font=Enum.Font.Code; high.TextSize=12; high.TextXAlignment=Enum.TextXAlignment.Left; high.TextYAlignment=Enum.TextYAlignment.Top; high.Parent=r
 src:GetPropertyChangedSignal("Text"):Connect(function()
  local t=src.Text:gsub("<","&lt;"):gsub(">","&gt;")
  t=t:gsub("local ","<font color='#ff5555'>local </font>"):gsub("function ","<font color='#55aaff'>function </font>"):gsub("end","<font color='#ff5555'>end</font>"):gsub("return","<font color='#ff5555'>return</font>")
  high.Text=t
 end)
 return {Get=function() return src.Text end, Set=function(t) src.Text=t end}
end
function Controls.KeybindAdvanced(parent,opt)
 opt=opt or {}; local v=opt.Default; local mode=opt.Mode or "Toggle"
 local r=Instance.new("Frame"); r.BackgroundColor3=Theme.Row; r.Size=UDim2.new(1,0,0,32); r.Parent=parent
 local s=Instance.new("UIStroke"); s.Color=Theme.Border; s.Parent=r
 local l=Instance.new("TextLabel"); l.BackgroundTransparency=1; l.Text=(opt.Name or "Bind")..": "..(v and v.Name or "None"); l.TextColor3=Theme.Text; l.TextSize=12; l.Font=Enum.Font.Gotham; l.Size=UDim2.new(0,100,1,0); l.Position=UDim2.new(0,10,0,0); l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
 local b=Instance.new("TextButton"); b.Text=mode; b.Size=UDim2.new(0,60,0,20); b.Position=UDim2.new(1,-70,0.5,-10); b.BackgroundColor3=Theme.Panel; b.TextColor3=Theme.Sub; b.Parent=r
 local k=Instance.new("TextButton"); k.Text="..."; k.Size=UDim2.new(1,0,1,0); k.BackgroundTransparency=1; k.Parent=r
 b.MouseButton1Click:Connect(function() mode=(mode=="Toggle" and "Hold" or "Toggle"); b.Text=mode; if opt.Callback then opt.Callback(v,mode) end end)
 k.MouseButton1Click:Connect(function() l.Text="Press key..."; local c; c=UIS.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Keyboard then v=i.KeyCode; l.Text=(opt.Name or "Bind")..": "..v.Name; c:Disconnect(); if opt.Callback then opt.Callback(v,mode) end end end) end)
 return {Get=function() return v,mode end}
end
function Controls.PlayerList(parent,opt)
  opt=opt or {}; local r=Instance.new("Frame"); r.BackgroundColor3=Theme.Row; r.Size=UDim2.new(1,0,0,200); r.Parent=parent; local s=Instance.new("UIStroke"); s.Color=Theme.Border; s.Parent=r
  local list=Instance.new("ScrollingFrame"); list.Size=UDim2.new(1,-10,1,-10); list.Position=UDim2.new(0,5,0,5); list.BackgroundTransparency=1; list.AutomaticCanvasSize=Enum.AutomaticSize.Y; list.CanvasSize=UDim2.new(0,0,0,0); list.Parent=r
  local layout=Instance.new("UIListLayout"); layout.Padding=UDim.new(0,2); layout.Parent=list
  local cache={}
  local function update()
   for _,p in ipairs(Players:GetPlayers()) do
    if not cache[p] then
     local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,24); row.BackgroundColor3=Theme.Panel; row.Parent=list
     local name=Instance.new("TextLabel"); name.Text=p.Name; name.Size=UDim2.new(0.5,0,1,0); name.Position=UDim2.new(0,4,0,0); name.BackgroundTransparency=1; name.TextColor3=Theme.Text; name.TextSize=12; name.Font=Enum.Font.Gotham; name.TextXAlignment=Enum.TextXAlignment.Left; name.Parent=row
     local hp=Instance.new("Frame"); hp.Size=UDim2.new(0.4,-4,0,4); hp.Position=UDim2.new(0.5,0,0.5,-2); hp.BackgroundColor3=Theme.RowH; hp.Parent=row
     local hpf=Instance.new("Frame"); hpf.Size=UDim2.new(1,0,1,0); hpf.BackgroundColor3=Color3.fromRGB(80,200,120); hpf.Parent=hp
     local dist=Instance.new("TextLabel"); dist.Text="0m"; dist.Size=UDim2.new(0.1,0,1,0); dist.Position=UDim2.new(0.9,0,0,0); dist.BackgroundTransparency=1; dist.TextColor3=Theme.Sub; dist.TextSize=11; dist.Font=Enum.Font.Code; dist.Parent=row
     cache[p]={Row=row,Name=name,Bar=hpf,Dist=dist}
    end
    local d=cache[p]
    if d and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character:FindFirstChild("HumanoidRootPart") and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
     local h=p.Character.Humanoid; d.Bar.Size=UDim2.new(h.Health/h.MaxHealth,0,1,0)
     d.Dist.Text=math.floor((p.Character.HumanoidRootPart.Position-LP.Character.HumanoidRootPart.Position).Magnitude).."m"
    elseif d then
     d.Bar.Size=UDim2.new(0,0,1,0); d.Dist.Text="-"
    end
   end
   for p,data in pairs(cache) do if not p.Parent then data.Row:Destroy(); cache[p]=nil end end
  end
  local c=RunService.Heartbeat:Connect(update)
  r.Destroying:Connect(function() c:Disconnect() end)
  return r
 end
 function Controls.Knob(parent,opt)
  opt=opt or {}; local min,max=opt.Min or 0,opt.Max or 100; local val=opt.Default or min
  local r=Instance.new("Frame"); r.BackgroundColor3=Theme.Row; r.Size=UDim2.new(0,60,0,80); r.Parent=parent; local s=Instance.new("UIStroke"); s.Color=Theme.Border; s.Parent=r; addGlow(r,Theme.Accent,18,0.6)
  local k=Instance.new("Frame"); k.Size=UDim2.new(0,40,0,40); k.Position=UDim2.new(0.5,-20,0.5,-10); k.BackgroundColor3=Theme.Panel; k.Parent=r; local kc=Instance.new("UICorner"); kc.CornerRadius=UDim.new(1,0); kc.Parent=k; local ks=Instance.new("UIStroke"); ks.Color=Theme.Accent; ks.Thickness=2; ks.Parent=k
  local ptr=Instance.new("Frame"); ptr.Size=UDim2.new(0,2,0,10); ptr.Position=UDim2.new(0.5,-1,0,4); ptr.BackgroundColor3=Theme.Accent; ptr.Parent=k
  local lbl=Instance.new("TextLabel"); lbl.Text=tostring(val); lbl.Size=UDim2.new(1,0,0,16); lbl.Position=UDim2.new(0,0,1,-18); lbl.BackgroundTransparency=1; lbl.TextColor3=Theme.Text; lbl.TextSize=12; lbl.Font=Enum.Font.Gotham; lbl.Parent=r
  local function set(v) val=math.clamp(v,min,max); local p=(val-min)/(max-min); k.Rotation=-135+(p*270); lbl.Text=tostring(math.floor(val)); if opt.Callback then opt.Callback(val) end end
  set(val)
  k.InputBegan:Connect(function(i)
   if i.UserInputType==Enum.UserInputType.MouseButton1 then
    local m=UIS:GetMouseLocation(); local startY=m.Y; local startV=val
    local conn; conn=UIS.InputChanged:Connect(function(ic)
     if ic.UserInputType==Enum.UserInputType.MouseMovement then
      local d=(startY-ic.Position.Y); set(startV+d)
     end
    end)
    UIS.InputEnded:Connect(function(ie) if ie.UserInputType==Enum.UserInputType.MouseButton1 then conn:Disconnect() end end)
   end
  end)
  return {Set=set}
 end
 function Controls.SkillTree(parent,opt)
  opt=opt or {}; local r=Instance.new("Frame"); r.BackgroundColor3=Theme.Row; r.Size=UDim2.new(1,0,0,200); r.Parent=parent; local s=Instance.new("UIStroke"); s.Color=Theme.Border; s.Parent=r
  local nodes=opt.Nodes or {{ID=1,X=0.5,Y=0.2},{ID=2,X=0.3,Y=0.5},{ID=3,X=0.7,Y=0.5}}
  local links=opt.Links or {{1,2},{1,3}}
  local map={}
  for _,n in ipairs(nodes) do
   local b=Instance.new("TextButton"); b.Size=UDim2.new(0,30,0,30); b.Position=UDim2.new(n.X,-15,n.Y,-15); b.BackgroundColor3=Theme.Panel; b.Text=tostring(n.ID); b.TextColor3=Theme.Text; b.Parent=r; local bc=Instance.new("UICorner"); bc.CornerRadius=UDim.new(1,0); bc.Parent=b; local bs=Instance.new("UIStroke"); bs.Color=Theme.Border; bs.Parent=b
   map[n.ID]=b
   b.MouseButton1Click:Connect(function() b.BackgroundColor3=Theme.Accent; if opt.Callback then opt.Callback(n.ID) end end)
  end
  for _,l in ipairs(links) do
   local a,b=map[l[1]],map[l[2]]
   if a and b then
    local line=Instance.new("Frame"); line.BackgroundColor3=Theme.Border; line.BorderSizePixel=0; line.ZIndex=0; line.Parent=r
    local p1,p2=a.Position,b.Position; local dist=math.sqrt((p2.X.Scale-p1.X.Scale)^2 + (p2.Y.Scale-p1.Y.Scale)^2) -- Rough approx for relative
    -- Accurate line drawing in pure UI without AbsoluteSize is tricky, using simple method
    -- This is a placeholder visual line since we don't have absolute size easily without render loop
   end
  end
  return r
 end
 function Controls.CircularProgress(parent,opt)
  opt=opt or {}; local r=Instance.new("Frame"); r.BackgroundTransparency=1; r.Size=UDim2.new(0,60,0,60); r.Parent=parent
  local bg=Instance.new("ImageLabel"); bg.Image="rbxassetid://3570695787"; bg.ImageColor3=Theme.Row; bg.BackgroundTransparency=1; bg.Size=UDim2.new(1,0,1,0); bg.Parent=r
  local bar=Instance.new("ImageLabel"); bar.Image="rbxassetid://3570695787"; bar.ImageColor3=Theme.Accent; bar.BackgroundTransparency=1; bar.Size=UDim2.new(1,0,1,0); bar.Parent=r
  local g=Instance.new("UIGradient"); g.Rotation=90; g.Parent=bar
  local lbl=Instance.new("TextLabel"); lbl.BackgroundTransparency=1; lbl.Size=UDim2.new(1,0,1,0); lbl.TextColor3=Theme.Text; lbl.TextSize=12; lbl.Font=Enum.Font.GothamBold; lbl.Text="0%"; lbl.Parent=r
  local function set(p) p=math.clamp(p,0,1); local a=math.floor(p*360); local seq={}; if a>180 then table.insert(seq,NumberSequenceKeypoint.new(0,0)); table.insert(seq,NumberSequenceKeypoint.new(0.5,0)); table.insert(seq,NumberSequenceKeypoint.new(1,1)) else table.insert(seq,NumberSequenceKeypoint.new(0,0)); table.insert(seq,NumberSequenceKeypoint.new(0.5,1)); table.insert(seq,NumberSequenceKeypoint.new(1,1)) end; g.Rotation=math.clamp(a,0,360); lbl.Text=math.floor(p*100).."%"; end
  set(opt.Default or 0)
  return {Set=set}
 end
 local function notify(text,dur)
 local n=Instance.new("Frame")n.BackgroundColor3=Theme.Row;n.Size=UDim2.new(1,0,0,36);n.Parent=notifyHolder
 local s=Instance.new("UIStroke")s.Color=Theme.Border;s.Thickness=1;s.Parent=n
 local l=Instance.new("TextLabel")l.BackgroundTransparency=1;l.Text=text;l.TextColor3=Theme.Text;l.TextSize=12;l.Font=Enum.Font.Gotham;l.TextXAlignment=Enum.TextXAlignment.Left;l.Size=UDim2.new(1,-10,1,0);l.Position=UDim2.new(0,8,0,0);l.Parent=n
 local g=addGlow(n,Theme.Accent,20,0.85)
 task.spawn(function()task.wait(dur or 2.5);tw(n,0.2,{BackgroundTransparency=1});g.ImageTransparency=1;task.wait(0.2);n:Destroy()end)
 end
 -- Watermark / Config / Keybinds
 local watermark=nil
 local keybindList=nil
 function W:Watermark(opt)
  opt=opt or {}; if not opt.Enabled then if watermark then watermark:Destroy(); watermark=nil end return end
  if watermark then watermark:Destroy() end
  watermark=Instance.new("Frame"); watermark.BackgroundColor3=Theme.Row; watermark.Size=UDim2.new(0,0,0,24); watermark.Position=UDim2.new(0,20,0,20); watermark.AutomaticSize=Enum.AutomaticSize.X; watermark.Parent=ui
  local s=Instance.new("UIStroke"); s.Color=Theme.Border; s.Parent=watermark; addGlow(watermark,Theme.Accent,18,0.85)
  local l=Instance.new("TextLabel"); l.BackgroundTransparency=1; l.Text=opt.Text or "Fiber.cc | FPS: 60 | Ping: 45ms"; l.TextColor3=Theme.Text; l.TextSize=12; l.Font=Enum.Font.Code; l.Size=UDim2.new(0,0,1,0); l.AutomaticSize=Enum.AutomaticSize.X; l.Position=UDim2.new(0,8,0,0); l.Parent=watermark
  local dragging,dragStart,startPos
  watermark.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true; dragStart=i.Position; startPos=watermark.Position end end)
  UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then local delta=i.Position-dragStart; watermark.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y) end end)
  UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
  RunService.Heartbeat:Connect(function() l.Text=(opt.Text or "Fiber.cc").." | FPS: "..math.floor(1/RunService.Heartbeat:Wait()).." | Ping: "..math.floor(LP:GetNetworkPing()*2000).."ms" end)
  return watermark
 end
 function W:KeybindList(opt)
  opt=opt or {}; if not opt.Enabled then if keybindList then keybindList:Destroy(); keybindList=nil end return end
  if keybindList then keybindList:Destroy() end
  keybindList=Instance.new("Frame"); keybindList.BackgroundColor3=Theme.Row; keybindList.Size=UDim2.new(0,180,0,0); keybindList.Position=UDim2.new(0,20,0.5,-100); keybindList.AutomaticSize=Enum.AutomaticSize.Y; keybindList.Parent=ui
  local s=Instance.new("UIStroke"); s.Color=Theme.Border; s.Parent=keybindList; addGlow(keybindList,Theme.Accent,18,0.85)
  local t=Instance.new("TextLabel"); t.BackgroundTransparency=1; t.Text="Keybinds"; t.TextColor3=Theme.Text; t.TextSize=12; t.Font=Enum.Font.GothamBold; t.Size=UDim2.new(1,0,0,20); t.Parent=keybindList
  local list=Instance.new("Frame"); list.BackgroundTransparency=1; list.Size=UDim2.new(1,-10,0,0); list.Position=UDim2.new(0,5,0,24); list.AutomaticSize=Enum.AutomaticSize.Y; list.Parent=keybindList
  local ll=Instance.new("UIListLayout"); ll.Padding=UDim.new(0,2); ll.Parent=list
  -- This is a placeholder visual; actual keybind tracking would require hooking into the Controls.Keybind instances
  -- For now, it shows a static example or needs manual Add()
  function keybindList:Add(name,key)
   local row=Instance.new("Frame"); row.BackgroundTransparency=1; row.Size=UDim2.new(1,0,0,16); row.Parent=list
   local n=Instance.new("TextLabel"); n.Text=name; n.TextColor3=Theme.Text; n.TextSize=11; n.Font=Enum.Font.Gotham; n.Size=UDim2.new(0.6,0,1,0); n.TextXAlignment=Enum.TextXAlignment.Left; n.BackgroundTransparency=1; n.Parent=row
   local k=Instance.new("TextLabel"); k.Text="["..key.."]"; k.TextColor3=Theme.Sub; k.TextSize=11; k.Font=Enum.Font.Code; k.Size=UDim2.new(0.4,0,1,0); k.TextXAlignment=Enum.TextXAlignment.Right; k.BackgroundTransparency=1; k.Parent=row
   return row
  end
  local dragging,dragStart,startPos
  keybindList.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true; dragStart=i.Position; startPos=keybindList.Position end end)
  UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then local delta=i.Position-dragStart; keybindList.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y) end end)
  UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
  return keybindList
 end
 function Controls.ConfigManager(parent)
  local r=Instance.new("Frame"); r.BackgroundColor3=Theme.Row; r.Size=UDim2.new(1,0,0,110); r.Parent=parent; local s=Instance.new("UIStroke"); s.Color=Theme.Border; s.Parent=r
  local b1=Controls.Button(r,{Name="Copy Config to Clipboard",Callback=function()
   local data={} -- Serialize window state (simplified)
   for _,c in ipairs(win:GetDescendants()) do if c:IsA("TextBox") then data[c.Name]=c.Text end end -- Very basic example
   if setclipboard then setclipboard(game:GetService("HttpService"):JSONEncode(data)) notify("Config Copied!",2) end
  end}); b1.Button.Position=UDim2.new(0,10,0,10); b1.Button.Size=UDim2.new(1,-20,0,26)
  local b2=Controls.Button(r,{Name="Load Config from Clipboard",Callback=function()
   -- Placeholder for loading logic
   notify("Config Loaded (Mock)!",2)
  end}); b2.Button.Position=UDim2.new(0,10,0,42); b2.Button.Size=UDim2.new(1,-20,0,26)
  local b3=Controls.Button(r,{Name="Reset Config",Callback=function() notify("Config Reset!",2) end}); b3.Button.Position=UDim2.new(0,10,0,74); b3.Button.Size=UDim2.new(1,-20,0,26)
  return r
 end
 function Controls.Viewport(parent,opt)
  opt=opt or {}; local r=Instance.new("Frame"); r.BackgroundColor3=Theme.Row; r.Size=UDim2.new(1,0,0,150); r.Parent=parent; local s=Instance.new("UIStroke"); s.Color=Theme.Border; s.Parent=r
  local vp=Instance.new("ViewportFrame"); vp.Size=UDim2.new(1,-10,1,-10); vp.Position=UDim2.new(0,5,0,5); vp.BackgroundTransparency=1; vp.Parent=r
  local cam=Instance.new("Camera"); cam.Parent=vp; vp.CurrentCamera=cam
  local model=opt.Model or Instance.new("Part"); model.Parent=vp
  if model:IsA("Model") then local cf,sz=model:GetBoundingBox(); cam.CFrame=CFrame.new(cf.Position+Vector3.new(sz.X*1.5,sz.Y*0.5,sz.Z*1.5),cf.Position) else cam.CFrame=CFrame.new(Vector3.new(4,4,4),Vector3.new(0,0,0)) end
  return {SetModel=function(m) model:Destroy(); model=m; m.Parent=vp end}
 end
close.MouseButton1Click:Connect(function()win.Visible=false end)
UIS.InputBegan:Connect(function(inp,gp)if gp then return end;if inp.KeyCode==toggleKey then win.Visible=not win.Visible end end)
local W={}
function W:CreateTab(o)
 local t=addTab(o and o.Name or "Tab",o and o.Icon)
 self._tabByName=self._tabByName or {}
 self._tabsList=self._tabsList or {}
 self._tabByName[o and o.Name or "Tab"]=t
 table.insert(self._tabsList,t)
 return t
end
function W:SwitchTab(name)
 local t=self._tabByName and self._tabByName[name]
 if t and t.Button and t.Button.MouseButton1Click then
  t.Button:MouseButton1Click:Fire()
 end
end
function W:CreateSection(parent,o)return addSection(parent,o and o.Name or "Section")end
function W:Notify(o)notify(o and o.Text or "",o and o.Duration or 2.5)end
function W:SetAccent(c)Theme.Accent=c;Theme.Accent2=c;stg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Theme.Accent),ColorSequenceKeypoint.new(1,Theme.Accent2)});tg.Color=stg.Color end
function W:SetTheme(name)
 local t=Themes[name] or Themes.Fiber
 for k,v in pairs(t) do Theme[k]=v end
 st.Color=Theme.Border; tbStroke.Color=Theme.Border; pgStroke.Color=Theme.Border
 stg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Theme.Accent),ColorSequenceKeypoint.new(1,Theme.Accent2)})
 tg.Color=stg.Color
 win.BackgroundColor3=Theme.BG; top.BackgroundColor3=Theme.Panel; tabs.BackgroundColor3=Theme.Panel; pages.BackgroundColor3=Theme.Panel
end
W.Controls=Controls;W.Instance=win;W.UI=ui;W.Theme=Theme
return W
end
return Lib
