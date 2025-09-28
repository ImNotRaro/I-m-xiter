-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V1.0 - VERSÃO MONOLÍTICA E CORRIGIDA (PARTE 1-3)
-- [ ! ] - AGORA VAI! SINTAXE E SCOPE CORRIGIDOS!
-- ====================================================================================== --

-- ID: A1 - INÍCIO (SERVIÇOS E VARIÁVEIS GLOBAIS)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")

local ViewportSize = Workspace.CurrentCamera.ViewportSize
local UIScale = ViewportSize.Y / 450

local rareLib = {
    Themes = {
        ["BloodMoon"] = {
            ["Color Hub BG"] = Color3.fromRGB(15, 15, 15),
            ["Color Panel BG"] = Color3.fromRGB(12, 12, 12),
            ["Color Stroke"] = Color3.fromRGB(40, 40, 40),
            ["Color Theme"] = Color3.fromRGB(139, 0, 0),
            ["Color Text"] = Color3.fromRGB(240, 240, 240),
            ["Color Dark Text"] = Color3.fromRGB(150, 150, 150)
        }
    },
    Save = {
        Theme = "BloodMoon",
        UISize = {620, 360},
        TabSize = 150
    },
    Settings = {},
    Instances = {},
    Tabs = {},
    CurrentTab = nil
}
local Theme = rareLib.Themes[rareLib.Save.Theme]

-- ID: A1.5 - FUNÇÕES DE CRIAÇÃO BÁSICAS
local function InsertTheme(Instance, Type)
    table.insert(rareLib.Instances, {Instance = Instance, Type = Type})
    return Instance
end

local function SetProps(Instance, Props)
    if Props then
        for prop, value in pairs(Props) do
            pcall(function() Instance[prop] = value end)
        end
    end
    return Instance
end

local function Create(...)
    local args = {...}
    local new = Instance.new(args[1])
    local props = type(args[2]) == "table" and args[2] or args[3]
    local children = type(args[2]) == "table" and args[3] or args[4]
    
    if typeof(args[2]) == "Instance" then new.Parent = args[2] end
    
    SetProps(new, props)
    if children then
        for _, child in pairs(children) do child.Parent = new end
    end
    return new
end

-- ID: A1.6 - FUNÇÃO DRAGAVEL BRABA
local function MakeDrag(Instance)
    SetProps(Instance, {Active = true, AutoButtonColor = false})
    local DragStart, StartPos
    
    Instance.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            StartPos = Instance.Position
            DragStart = Input.Position
            
            local Connection
            Connection = RunService.Heartbeat:Connect(function()
                local delta = UserInputService:GetMouseLocation() - DragStart
                local newPos = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X / UIScale, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y / UIScale)
                
                TweenService:Create(Instance, TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = newPos}):Play()
            end)
            
            local EndConnection
            EndConnection = UserInputService.InputEnded:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Connection:Disconnect()
                    EndConnection:Disconnect()
                end
            end)
        end
    end)
    return Instance
end

-- ID: C5 - CONSTRUTOR DE FRAME DE OPÇÃO (BASE DE TUDO)
local function CreateOptionFrame(Container, Title, Description, RightSideWidth)
    local Theme = rareLib.Themes[rareLib.Save.Theme]
    RightSideWidth = RightSideWidth or 0

    local Frame = InsertTheme(Create("Frame", Container, {
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = Theme["Color Panel BG"],
        Name = "Option",
        LayoutOrder = 1
    }), "Panel")
    Create("UICorner", Frame, {CornerRadius = UDim.new(0, 6)})
    Create("UIPadding", Frame, {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)})
    
    local TitleLabel = InsertTheme(Create("TextLabel", Frame, {
        Size = UDim2.new(1, -RightSideWidth, 0, 15),
        Position = UDim2.new(0, 0, 0, 5),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = Title,
        TextColor3 = Theme["Color Text"],
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Name = "Title"
    }), "Text")

    local DescLabel = InsertTheme(Create("TextLabel", Frame, {
        Size = UDim2.new(1, -RightSideWidth, 0, 15),
        Position = UDim2.new(0, 0, 0, 20),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = Description or "",
        TextColor3 = Theme["Color Dark Text"],
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Visible = Description and #Description > 0 or false,
        Name = "Description"
    }), "DarkText")
    
    return Frame, TitleLabel, DescLabel
end

-- ID: E2 - CONSTRUTOR DE TOGGLE
local function CreateToggleComponent(Container, Title, Desc, InitialValue, Callback)
    local Theme = rareLib.Themes[rareLib.Save.Theme]
    local Frame, _, _ = CreateOptionFrame(Container, Title, Desc, 40)
    local state = InitialValue
    
    local ToggleButton = Create("TextButton", Frame, {
        Size = UDim2.new(0, 30, 0, 18), 
        Position = UDim2.new(1, -35, 0.5, -9),
        BackgroundColor3 = Theme["Color Stroke"],
        Text = "", 
        AutoButtonColor = false
    })
    Create("UICorner", ToggleButton, {CornerRadius = UDim.new(1, 0)})
    
    local Knob = InsertTheme(Create("Frame", ToggleButton, {
        Size = UDim2.new(0, 14, 0, 14), 
        BackgroundColor3 = Theme["Color Theme"], 
        BorderSizePixel = 0
    }), "Theme")
    Create("UICorner", Knob, {CornerRadius = UDim.new(1, 0)})
    
    local function UpdateKnobPosition(newState)
        local targetPos = newState and UDim2.new(1, -2, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        local targetColor = newState and Theme["Color Theme"] or Color3.fromRGB(150, 150, 150)
        
        TweenService:Create(Knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = targetPos, BackgroundColor3 = targetColor}):Play()
    end
    
    local function Toggle()
        state = not state
        UpdateKnobPosition(state)
        pcall(Callback, state)
    end
    
    ToggleButton.MouseButton1Click:Connect(Toggle)
    
    UpdateKnobPosition(state)
    
    return {Frame = Frame, Toggle = Toggle, SetState = function(newState) 
        if newState ~= state then Toggle() end 
    end}
end

-- ID: E3 - CONSTRUTOR DE BUTTON
local function CreateButtonComponent(Container, Title, Desc, Callback)
    local Frame, _, _ = CreateOptionFrame(Container, Title, Desc, 30)
    
    Create("ImageLabel", Frame, {
        Image = "rbxassetid://10709791437",
        Size = UDim2.new(0, 15, 0, 15),
        Position = UDim2.new(1, -22, 0.5, -7.5),
        BackgroundTransparency = 1
    })
    
    local Button = Create("TextButton", Frame, {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false
    })
    
    Button.MouseButton1Click:Connect(function()
        pcall(Callback)
        TweenService:Create(Frame, TweenInfo.new(0.1), {BackgroundTransparency = 0.5}):Play()
        task.wait(0.1)
        TweenService:Create(Frame, TweenInfo.new(0.1), {BackgroundTransparency = 0}):Play()
    end)
    
    return {Frame = Frame, Callback = Button.MouseButton1Click}
end

-- ID: E5 - CONSTRUTOR DE SLIDER
local function CreateSliderComponent(Container, Title, Desc, Min, Max, Default, Callback)
    local Theme = rareLib.Themes[rareLib.Save.Theme]
    local Frame, _, _ = CreateOptionFrame(Container, Title, Desc, 120)
    local CurrentValue = Default
    local isDragging = false
    
    local SliderHolder = Create("TextButton", Frame, {
        Size = UDim2.new(0, 110, 0, 18), 
        Position = UDim2.new(1, -115, 0.5, -9),
        BackgroundTransparency = 1, Text = "", AutoButtonColor = false
    })
    
    local SliderBar = InsertTheme(Create("Frame", SliderHolder, {
        BackgroundColor3 = Theme["Color Stroke"], Size = UDim2.new(1, -30, 0, 4), Position = UDim2.new(0, 0, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5)
    }), "Stroke")
    Create("UICorner", SliderBar, {CornerRadius = UDim.new(1, 0)})
    
    local Indicator = InsertTheme(Create("Frame", SliderBar, {
        BackgroundColor3 = Theme["Color Theme"], Size = UDim2.fromScale(0, 1), BorderSizePixel = 0
    }), "Theme")
    Create("UICorner", Indicator, {CornerRadius = UDim.new(1, 0)})

    local Knob = Create("Frame", SliderBar, {
        Size = UDim2.new(0, 12, 0, 12), BackgroundColor3 = Theme["Color Theme"], Position = UDim2.fromScale(0, 0.5), AnchorPoint = Vector2.new(0.5, 0.5), BorderSizePixel = 0
    }, {
        Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    local ValueLabel = InsertTheme(Create("TextLabel", SliderHolder, {
        Text = tostring(CurrentValue), Size = UDim2.new(0, 30, 1, 0), Position = UDim2.new(1, -30, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextColor3 = Theme["Color Text"], TextSize = 14
    }), "Text")

    local function UpdateSlider(NewValue)
        CurrentValue = math.clamp(NewValue, Min, Max)
        local percentage = (CurrentValue - Min) / (Max - Min)
        
        TweenService:Create(Knob, TweenInfo.new(0.1), {Position = UDim2.fromScale(percentage, 0.5)}):Play()
        TweenService:Create(Indicator, TweenInfo.new(0.1), {Size = UDim2.fromScale(percentage, 1)}):Play()
        
        ValueLabel.Text = string.format("%.0f", CurrentValue)
        pcall(Callback, CurrentValue)
    end

    local function OnDrag(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            local MousePos = UserInputService:GetMouseLocation()
            local SliderStart = SliderBar.AbsolutePosition.X
            local SliderWidth = SliderBar.AbsoluteSize.X
            
            local NormalizedPos = math.clamp((MousePos.X - SliderStart) / SliderWidth, 0, 1)
            
            local NewRawValue = NormalizedPos * (Max - Min) + Min
            local Step = 1
            local SteppedValue = math.floor(NewRawValue / Step + 0.5) * Step
            
            UpdateSlider(SteppedValue)
        end
    end

    SliderHolder.MouseButton1Down:Connect(function()
        isDragging = true
        Container.ScrollingEnabled = false
        local moveConnection = RunService.Heartbeat:Connect(OnDrag)
        
        local upConnection = UserInputService.InputEnded:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                isDragging = false
                Container.ScrollingEnabled = true
                moveConnection:Disconnect()
                upConnection:Disconnect()
            end
        end)
    end)
    
    UpdateSlider(Default)

    return {Frame = Frame, SetValue = UpdateSlider}
end

-- ID: E6 - CONSTRUTOR DE DROPDOWN
local function CreateDropdownComponent(Window, Container, Title, Desc, Options, DefaultOption, Callback)
    local Theme = rareLib.Themes[rareLib.Save.Theme]
    local Frame, _, _ = CreateOptionFrame(Container, Title, Desc, 140)
    local SelectedValue = DefaultOption
    local DropdownVisible = false

    local DropdownFrame = InsertTheme(Create("TextButton", Frame, {
        Size = UDim2.new(0, 130, 0, 18),
        Position = UDim2.new(1, -135, 0.5, -9),
        BackgroundColor3 = Theme["Color Stroke"],
        Text = "", AutoButtonColor = false
    }), "Stroke")
    Create("UICorner", DropdownFrame, {CornerRadius = UDim.new(0, 4)})

    local Label = InsertTheme(Create("TextLabel", DropdownFrame, {
        Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 5, 0, 0), BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold, TextColor3 = Theme["Color Text"], Text = SelectedValue,
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = "AtEnd"
    }), "Text")

    local Arrow = Create("ImageLabel", DropdownFrame, {
        Image = "rbxassetid://10709791523",
        Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(1, -15, 0.5, -6), BackgroundTransparency = 1
    })
    
    local Overlay = Create("Frame", Window.MainFrame.Parent, {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 3, Visible = false
    })
    
    local ListPanel = InsertTheme(Create("ScrollingFrame", Overlay, {
        Size = UDim2.new(0, 130, 0, 1), BackgroundTransparency = 0.1, BackgroundColor3 = Theme["Color Hub BG"],
        ZIndex = 4, ScrollBarImageColor3 = Theme["Color Theme"], ScrollBarThickness = 6,
        AutomaticCanvasSize = "Y", ScrollingDirection = "Y", ClipsDescendants = true
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
        Create("UIStroke", {Color = Theme["Color Theme"], Thickness = 2, ApplyStrokeMode = "Border"}),
        Create("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder}),
        Create("UIPadding", {PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5)})
    }), "ScrollBar")
    
    local function UpdateListPanelPosition()
        local pos = DropdownFrame.AbsolutePosition
        local listHeight = ListPanel.CanvasSize.Y.Scale * ListPanel.AbsoluteSize.Y
        
        local x = pos.X / UIScale
        local y = (pos.Y + DropdownFrame.AbsoluteSize.Y) / UIScale
        
        local ScreenH = Window.MainFrame.Parent.AbsoluteSize.Y / UIScale
        if y + listHeight > ScreenH and y - DropdownFrame.AbsoluteSize.Y - listHeight > 0 then
            y = (pos.Y - listHeight) / UIScale
        end
        
        ListPanel.Position = UDim2.fromOffset(x, y)
    end
    
    local function ToggleDropdown()
        DropdownVisible = not DropdownVisible
        Overlay.Visible = DropdownVisible
        
        if DropdownVisible then
            UpdateListPanelPosition()
            local targetHeight = math.min(#Options * 20 + 10, 200)
            TweenService:Create(ListPanel, TweenInfo.new(0.2), {Size = UDim2.new(0, 130, 0, targetHeight)}):Play()
            TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
        else
            TweenService:Create(ListPanel, TweenInfo.new(0.2), {Size = UDim2.new(0, 130, 0, 1)}):Play()
            TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
        end
    end
    
    local function SelectOption(optionName)
        SelectedValue = optionName
        Label.Text = optionName
        pcall(Callback, optionName)
        if DropdownVisible then ToggleDropdown() end -- Fecha se estiver aberto
    end
    
    for _, option in ipairs(Options) do
        local optButton = InsertTheme(Create("TextButton", ListPanel, {
            Size = UDim2.new(1, 0, 0, 18), BackgroundColor3 = Theme["Color Hub BG"],
            Text = option, Font = Enum.Font.Gotham, TextColor3 = Theme["Color Text"], TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, AutoButtonColor = false
        }), "Frame")
        Create("UIPadding", optButton, {PaddingLeft = UDim.new(0, 5)})
        
        optButton.MouseEnter:Connect(function() optButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30) end)
        optButton.MouseLeave:Connect(function() optButton.BackgroundColor3 = Theme["Color Hub BG"] end)
        
        optButton.MouseButton1Click:Connect(function()
            SelectOption(option)
        end)
    end
    
    DropdownFrame.MouseButton1Click:Connect(ToggleDropdown)
    Overlay.MouseButton1Down:Connect(function()
        if DropdownVisible then ToggleDropdown() end
    end)
    
    if DefaultOption then SelectOption(DefaultOption) end

    return {Frame = Frame, SetValue = SelectOption}
end


-- ID: B3 - FUNÇÃO DE STATUS DO RPG
local function CreateStatusFicha(RightPanel, IconURL)
    local FichaRPG = Create("Frame", RightPanel, {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1})
    Create("UIGradient", FichaRPG, {
        Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 0, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 0, 0))}),
        Rotation = 90
    })
    
    local estandarteImg = Create("ImageLabel", FichaRPG, {
        Size=UDim2.new(0,64,0,64), Position=UDim2.new(0.5,-32,0,120),
        BackgroundColor3=Theme["Color Theme"], ScaleType=Enum.ScaleType.Crop,
        Image=IconURL or "", BackgroundTransparency=0.1
    }, {
        Create("UIAspectRatioConstraint", {AspectRatio=1}),
        Create("UICorner", {CornerRadius=UDim.new(1,0)})
    })
    
    local nomePrincipalLabel = InsertTheme(Create("TextLabel", FichaRPG, {
        Size=UDim2.new(1,0,0,25), Position=UDim2.new(0,0,0,190),
        Font=Enum.Font.GothamBold, Text=LocalPlayer.DisplayName,
        TextColor3=Theme["Color Text"], TextSize=20, BackgroundTransparency=1
    }), "Text")
    
    local subtituloNomeLabel = InsertTheme(Create("TextLabel", FichaRPG, {
        Size=UDim2.new(1,0,0,20), Position=UDim2.new(0,0,0,215),
        Font=Enum.Font.Gotham, Text="⛩️ RARE LIB V1",
        TextColor3=Theme["Color Theme"], TextSize=14, BackgroundTransparency=1
    }), "Theme")
    
    local function criarRotuloStatus(nome, posY)
        local container=Create("Frame",FichaRPG, {Size=UDim2.new(1,-20,0,22), Position=UDim2.new(0,10,0,posY), BackgroundTransparency=1})
        local valorLabel=InsertTheme(Create("TextLabel",container, {
            Size=UDim2.new(0.5,0,1,0), Position=UDim2.new(0.5,0,0,0), Font=Enum.Font.Gotham,
            TextColor3=Theme["Color Text"], Text="...", TextXAlignment=Enum.TextXAlignment.Right,
            TextSize=18, BackgroundTransparency=1
        }), "Text")
        InsertTheme(Create("TextLabel",container, {
            Size=UDim2.new(0.5,0,1,0), Font=Enum.Font.GothamBold, TextColor3=Theme["Color Theme"],
            Text=nome..":", TextXAlignment=Enum.TextXAlignment.Left, TextSize=18, BackgroundTransparency=1
        }), "Theme")
        return valorLabel
    end
    
    local vidaValor = criarRotuloStatus("VIDA", 20)
    local pingValor = criarRotuloStatus("PING", 50)
    local fpsValor = criarRotuloStatus("FPS", 80)
    
    task.spawn(function()
        while task.wait(1) do 
            if FichaRPG and FichaRPG.Parent then
                pcall(function() 
                    local hum=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if hum then vidaValor.Text=string.format("%d/%d",math.floor(hum.Health),math.floor(hum.MaxHealth)) end
                end)
                pcall(function() pingValor.Text=game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString() end)
                pcall(function() fpsValor.Text=tostring(math.floor(Workspace:GetRealPhysicsFPS())) end)
            end
        end
    end)
end


-- ID: E1 - FUNÇÃO DE CRIAÇÃO DE TABS (FINALIZADA)
local function CreateTabButton(Window, NavContainer, TName, TIcon)
    local Theme = rareLib.Themes[rareLib.Save.Theme]
    
    local TabSelect = InsertTheme(Create("TextButton", NavContainer, {
        Text = " "..TName,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        TextSize = 16,
        TextColor3 = Theme["Color Dark Text"],
        Size = UDim2.new(1, -20, 0, 35),
        Position = UDim2.new(0, 10),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        LayoutOrder = #rareLib.Tabs + 1
    }), "Frame")
    Create("UICorner", TabSelect, {CornerRadius = UDim.new(0, 4)})
    Create("UIStroke", TabSelect, {Color = Theme["Color Stroke"], Thickness = 1, ApplyStrokeMode = "Border"})
    
    local ContentContainer = Create("ScrollingFrame", Window.ContentPanel, {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = "Y",
        ScrollingDirection = "Y",
        ScrollBarImageColor3 = Theme["Color Theme"],
        ScrollBarThickness = 6,
        Visible = false,
        Name = TName.."_Container"
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 6)}), -- Corner pro Container, visual brabo
        Create("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}),
        Create("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10)})
    })
    
    local Tab = {
        Name = TName,
        Icon = TIcon,
        Container = ContentContainer,
        Button = TabSelect,
    }
    
    local function SelectTab()
        if rareLib.CurrentTab == Tab then return end
        
        if rareLib.CurrentTab then
            rareLib.CurrentTab.Container.Visible = false
            rareLib.CurrentTab.Button.TextColor3 = Theme["Color Dark Text"]
            rareLib.CurrentTab.Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        end
        
        ContentContainer.Visible = true
        TabSelect.TextColor3 = Theme["Color Theme"]
        TabSelect.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        rareLib.CurrentTab = Tab
        
        TweenService:Create(TabSelect, TweenInfo.new(0.1), {TextSize = 18}):Play()
        task.wait(0.1)
        TweenService:Create(TabSelect, TweenInfo.new(0.1), {TextSize = 16}):Play()
    end
    
    TabSelect.MouseButton1Click:Connect(SelectTab)

    -- ID: E7 - INJEÇÃO FINAL DAS FUNÇÕES NA TAB
    function Tab:AddButton(Title, Desc, Callback)
        return CreateButtonComponent(Tab.Container, Title, Desc, Callback)
    end

    function Tab:AddToggle(Title, Desc, InitialValue, Callback)
        return CreateToggleComponent(Tab.Container, Title, Desc, InitialValue, Callback)
    end
    
    function Tab:AddSlider(Title, Desc, Min, Max, Default, Callback)
        return CreateSliderComponent(Tab.Container, Title, Desc, Min, Max, Default, Callback)
    end

    function Tab:AddDropdown(Title, Desc, Options, DefaultOption, Callback)
        return CreateDropdownComponent(Window, Tab.Container, Title, Desc, Options, DefaultOption, Callback)
    end
    
    table.insert(rareLib.Tabs, Tab)
    if #rareLib.Tabs == 1 then SelectTab() end
    
    return Tab
end


-- ID: D2 - O CONSTRUTOR PRINCIPAL (rareLib:Window)
function rareLib:Window(Title, IconURL)
    local UISizeX, UISizeY = unpack(rareLib.Save.UISize)
    local TabSize = rareLib.Save.TabSize
    
    -- ID: A2 - DESTRUTOR DE UI ANTIGA
    if CoreGui:FindFirstChild("RARE_LIB_UI") then CoreGui.RARE_LIB_UI:Destroy() end
    if CoreGui:FindFirstChild("NEVERWIN_UI") then CoreGui.NEVERWIN_UI:Destroy() end

    local MainGui = Create("ScreenGui", CoreGui, {Name = "RARE_LIB_UI", ResetOnSpawn = false})
    Create("UIScale", MainGui, {Scale = UIScale, Name = "Scale"})

    local MainFrame = InsertTheme(Create("Frame", MainGui, {
        Size = UDim2.fromOffset(UISizeX, UISizeY),
        Position = UDim2.new(0.5, -UISizeX/2, 0.5, -UISizeY/2),
        BackgroundColor3 = Theme["Color Hub BG"],
        BorderColor3 = Theme["Color Theme"],
        BorderSizePixel = 2,
        ClipsDescendants = true,
        Active = true,
        Name = "Hub"
    }), "Main")
    MakeDrag(MainFrame)
    Create("UICorner", MainFrame, {CornerRadius = UDim.new(0, 12)})
    
    -- ID: A3.5 - O BOTÃO FANTASMA
    local ToggleButton = Create("TextButton", MainGui, {
        Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0, 15, 0.5, -25),
        BackgroundColor3 = Theme["Color Theme"], Text = "愛", Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 32, Draggable = true
    }, {
        Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
        Create("UIStroke", {Color = Color3.fromRGB(255, 255, 255), Thickness = 1})
    })
    ToggleButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
    
    local MainPadding = Create("UIPadding", MainFrame, {PaddingLeft=UDim.new(0,10), PaddingRight=UDim.new(0,10), PaddingTop=UDim.new(0,10), PaddingBottom=UDim.new(0,10)})
    
    local NavContainer = InsertTheme(Create("ScrollingFrame", MainFrame, {
        Size = UDim2.new(0, TabSize, 1, 0), BackgroundColor3 = Theme["Color Hub BG"], BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = "Y", ScrollingDirection = "Y",
        ScrollBarImageColor3 = Theme["Color Theme"], ScrollBarThickness = 6
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        Create("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}),
        Create("UIPadding", {PaddingTop = UDim.new(0, 10)})
    }), "ScrollBar")

    local ContentPanel = InsertTheme(Create("Frame", MainFrame, {
        Size = UDim2.new(1, -(TabSize + 10 + 200 + 10), 1, 0),
        Position = UDim2.new(0, TabSize + 10, 0, 0),
        BackgroundColor3 = Theme["Color Hub BG"], BorderSizePixel = 0
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
    }), "Frame")
    
    local RightPanel = InsertTheme(Create("Frame", MainFrame, {
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(1, -200, 0, 0),
        BackgroundColor3 = Theme["Color Panel BG"], BorderSizePixel = 0
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        Create("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)})
    }), "Panel")
    
    -- ID: B2 - ADICIONA A FICHA DE STATUS AO PAINEL DIREITO
    pcall(function() 
        local _, thumbUrl = Players.GetUserThumbnailAsync(Players, LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180)
        CreateStatusFicha(RightPanel, thumbUrl) 
    end)
    
    local Window = {
        MainFrame = MainFrame,
        ContentPanel = ContentPanel,
        NavContainer = NavContainer,
        MainGui = MainGui -- Precisa disso pro Dropdown saber onde tá a tela
    }
    
    function Window:Tab(TName, TIcon)
        return CreateTabButton(Window, NavContainer, TName, TIcon)
    end

    return Window
end

return rareLib
