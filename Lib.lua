-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V4.1 - A VERSÃO DA REDENÇÃO - by RARO XT & DRIP
-- [ ! ] - ARQUITETURA CORRIGIDA. API INTUITIVA. À PROVA DE FALHAS.
-- ====================================================================================== --

local rareLib = {}
rareLib.__index = rareLib

--[<SERVICES>]--
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

--[<HELPER FUNCTIONS>]--
local function Create(instanceType, properties)
    local newInstance = Instance.new(instanceType)
    if properties then
        for prop, value in pairs(properties) do
            pcall(function() newInstance[prop] = value end)
        end
    end
    return newInstance
end

local function MakeDrag(instance)
    local dragging = false
    local startPos, dragStart
    instance.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging, startPos, dragStart = true, instance.Position, input.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            instance.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (input.Position.X - dragStart.X), startPos.Y.Scale, startPos.Y.Offset + (input.Position.Y - dragStart.Y))
        end
    end)
    instance.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

--[<PRIVATE CONSTRUCTORS>]--
function rareLib:__CreateOptionFrame(Container, Title, Description, RightSideWidth)
    local Frame = Create("Frame", {Parent = Container, Size = UDim2.new(1, 0, 0, 45), BackgroundColor3 = self.Theme["Color Panel BG"], Name = "Option", LayoutOrder = #Container:GetChildren() + 1})
    Create("UICorner", {Parent = Frame, CornerRadius = UDim.new(0, 6)}); Create("UIPadding", {Parent = Frame, PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)})
    Create("TextLabel", {Parent = Frame, Size = UDim2.new(1, -(RightSideWidth or 0), 0, 18), Position = UDim2.new(0, 0, 0, 5), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = Title, TextColor3 = self.Theme["Color Text"], TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left})
    Create("TextLabel", {Parent = Frame, Size = UDim2.new(1, -(RightSideWidth or 0), 0, 15), Position = UDim2.new(0, 0, 0, 23), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = Description or "", TextColor3 = self.Theme["Color Dark Text"], TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Visible = Description and #Description > 0})
    return Frame
end

--[<PUBLIC API - COMPONENTS>]--
function rareLib:AddButton(options)
    local Frame = self:__CreateOptionFrame(self.Container, options.Title, options.Desc, 30)
    Create("ImageLabel", {Parent=Frame, Image="rbxassetid://10709791437", Size=UDim2.new(0,15,0,15), Position=UDim2.new(1,-22,0.5,-7.5), BackgroundTransparency=1})
    local Button=Create("TextButton",{Parent=Frame, Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", AutoButtonColor=false})
    Button.MouseButton1Click:Connect(function() pcall(options.Callback); local c=Frame.BackgroundColor3; TweenService:Create(Frame,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(45,45,45)}):Play(); task.wait(0.1); TweenService:Create(Frame,TweenInfo.new(0.1),{BackgroundColor3=c}):Play() end)
end

function rareLib:AddToggle(options)
    local Frame = self:__CreateOptionFrame(self.Container, options.Title, options.Desc, 40)
    local state = options.Default or false
    local Button = Create("TextButton",{Parent=Frame, Name="Switch", Size=UDim2.new(0,35,0,20), Position=UDim2.new(1,-40,0.5,-10), BackgroundColor3=self.Theme["Color Stroke"], Text="", AutoButtonColor=false})
    Create("UICorner", {Parent=Button, CornerRadius=UDim.new(1,0)})
    local Knob = Create("Frame",{Parent=Button, Name="Knob", Size=UDim2.new(0,16,0,16), Position=UDim2.new(0,2,0.5,-8), BackgroundColor3=self.Theme["Color Dark Text"], BorderSizePixel=0})
    Create("UICorner",{Parent=Knob, CornerRadius=UDim.new(1,0)})
    local function UpdateKnob(newState, instant) state=newState; local pos=newState and UDim2.new(1,-2,0.5,-8) or UDim2.new(0,2,0.5,-8); local color=newState and self.Theme["Color Theme"] or self.Theme["Color Dark Text"]; if instant then Knob.Position,Knob.BackgroundColor3=pos,color else TweenService:Create(Knob,TweenInfo.new(0.2),{Position=pos,BackgroundColor3=color}):Play() end end
    Button.MouseButton1Click:Connect(function() UpdateKnob(not state); pcall(options.Callback, not state) end)
    UpdateKnob(state, true)
end

--[<PUBLIC API - TAB>]--
function rareLib:CreateTab(TName)
    local Tab = setmetatable({}, {__index = self}) -- A MÁGICA: A TAB AGORA É UM OBJETO DA LIB
    Tab.Name = TName
    Tab.Button = Create("TextButton", {Parent = self.NavContainer, Name = TName .. "Button", Text = "  " .. TName, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.Gotham, TextSize = 16, TextColor3 = self.Theme["Color Dark Text"], Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = Color3.fromRGB(25, 25, 25), LayoutOrder = #self.Tabs + 1, AutoButtonColor = false})
    Create("UICorner", {Parent = Tab.Button, CornerRadius = UDim.new(0, 4)}); Create("UIStroke", {Parent = Tab.Button, Color = self.Theme["Color Stroke"], Thickness = 1, ApplyStrokeMode = "Border"})
    Tab.Container = Create("ScrollingFrame", {Parent = self.ContentPanel, Name = TName .. "_Container", Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, AutomaticCanvasSize = "Y", ScrollBarImageColor3 = self.Theme["Color Theme"], ScrollBarThickness = 6, Visible = false})
    Create("UIListLayout", {Parent = Tab.Container, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}); Create("UIPadding", {Parent = Tab.Container, PaddingTop = UDim.new(0, 10), PaddingRight = UDim.new(0, 5)})
    local function SelectTab() if self.CurrentTab==Tab then return end; if self.CurrentTab then self.CurrentTab.Container.Visible=false; TweenService:Create(self.CurrentTab.Button,TweenInfo.new(0.2),{TextColor3=self.Theme["Color Dark Text"],BackgroundColor3=Color3.fromRGB(25,25,25)}):Play() end; Tab.Container.Visible=true; self.CurrentTab=Tab; TweenService:Create(Tab.Button,TweenInfo.new(0.2),{TextColor3=self.Theme["Color Theme"],BackgroundColor3=Color3.fromRGB(35,35,35)}):Play() end
    Tab.Button.MouseButton1Click:Connect(SelectTab); table.insert(self.Tabs, Tab); if #self.Tabs==1 then SelectTab() end
    return Tab
end

--[<HUB INITIALIZER>]--
function rareLib:new(Title)
    local self = setmetatable({}, rareLib)
    self.Theme = {["Color Hub BG"]=Color3.fromRGB(15,15,15), ["Color Panel BG"]=Color3.fromRGB(12,12,12), ["Color Stroke"]=Color3.fromRGB(40,40,40), ["Color Theme"]=Color3.fromRGB(139,0,0), ["Color Text"]=Color3.fromRGB(240,240,240), ["Color Dark Text"]=Color3.fromRGB(150,150,150)}
    self.Config = {UISize={620,360}, TabSize=150}
    self.Tabs, self.CurrentTab = {}, nil
    
    -- INICIALIZAÇÃO EM ORDEM
    self:__CreateWindow(Title)
    self:__CreateStatusFicha()
    self:__CreateConstellation()

    return self
end

return rareLib
