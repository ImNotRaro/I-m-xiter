-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V3 - A VERSÃO DEFINITIVA - by RARO XT & DRIP
-- [ ! ] - PARTE 1/20: A FUNDAÇÃO (REVISADA E REFORÇADA)
-- ====================================================================================== --

-- ID: A1 - O QUARTEL-GENERAL (A TABELA PRINCIPAL)
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
    Instances = {},
    Tabs = {},
    CurrentTab = nil,
    Window = nil -- Referência para a janela principal
}

-- ID: A2 - SERVIÇOS ESSENCIAIS (AS FERRAMENTAS DO ARSENAL)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- ID: A3 - AS FUNÇÕES-MESTRE (NOSSA FÁBRICA DE PEÇAS)
-- Revisadas para serem ainda mais seguras.

-- Função para criar qualquer instância da UI.
local function Create(instanceType, properties)
    local newInstance = Instance.new(instanceType)
    if properties then
        for prop, value in pairs(properties) do
            -- pcall é nosso colete a prova de balas.
            pcall(function()
                newInstance[prop] = value
            end)
        end
    end
    return newInstance
end

-- Função para rastrear as instâncias que mudam de cor com o tema.
local function Track(instance, themeType)
    table.insert(rareLib.Instances, {Instance = instance, Type = themeType})
    return instance
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V3 - by RARO XT & DRIP
-- [ ! ] - PARTE 2/20: A JANELA PRINCIPAL
-- ====================================================================================== --

-- ID: B1 - A FUNÇÃO DE ARRASTAR PERFEITA (REVISADA)
local function MakeDrag(instance)
    local isDragging = false
    local startPos, dragStart
    
    instance.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            startPos = instance.Position
            dragStart = input.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            instance.Position = newPos
        end
    end)

    instance.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)
end

-- ID: B2 - O CONSTRUTOR DA JANELA (A FUNÇÃO MESTRA)
function rareLib:CreateWindow(Title, IconURL)
    -- Limpa qualquer lixo de UI antiga
    if CoreGui:FindFirstChild("RARE_LIB_UI") then CoreGui.RARE_LIB_UI:Destroy() end

    local Theme = rareLib.Themes[rareLib.Save.Theme]
    local UISizeX, UISizeY = unpack(rareLib.Save.UISize)
    local TabSize = rareLib.Save.TabSize

    local MainGui = Create("ScreenGui", {
        Parent = CoreGui, Name = "RARE_LIB_UI", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    local MainFrame = Track(Create("Frame", {
        Parent = MainGui, Name = "Hub", Size = UDim2.fromOffset(UISizeX, UISizeY),
        Position = UDim2.new(0.5, -UISizeX/2, 0.5, -UISizeY/2), BackgroundColor3 = Theme["Color Hub BG"],
        BorderColor3 = Theme["Color Theme"], BorderSizePixel = 2, ClipsDescendants = true, Active = true
    }), "Main")
    Create("UICorner", {Parent = MainFrame, CornerRadius = UDim.new(0, 12)})
    MakeDrag(MainFrame)

    local ToggleButton = Create("TextButton", {
        Parent = MainGui, Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0, 15, 0.5, -25),
        BackgroundColor3 = Theme["Color Theme"], Text = "愛", Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 32,
    })
    Create("UICorner", {Parent = ToggleButton, CornerRadius = UDim.new(1, 0)})
    Create("UIStroke", {Parent = ToggleButton, Color = Color3.fromRGB(255, 255, 255)})
    ToggleButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
    MakeDrag(ToggleButton)

    Create("UIPadding", {Parent = MainFrame, PaddingLeft=UDim.new(0,10), PaddingRight=UDim.new(0,10), PaddingTop=UDim.new(0,10), PaddingBottom=UDim.new(0,10)})
    
    local NavContainer = Track(Create("ScrollingFrame", {
        Parent = MainFrame, Name = "NavContainer", Size = UDim2.new(0, TabSize, 1, 0),
        BackgroundColor3 = Theme["Color Hub BG"], BorderSizePixel = 0, AutomaticCanvasSize = "Y",
        ScrollBarImageColor3 = Theme["Color Theme"], ScrollBarThickness = 6
    }), "ScrollBar")
    Create("UICorner", {Parent = NavContainer, CornerRadius = UDim.new(0, 6)})
    Create("UIListLayout", {Parent = NavContainer, Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder})
    Create("UIPadding", {Parent = NavContainer, PaddingTop = UDim.new(0, 10)})
    
    local RightPanel = Track(Create("Frame", {
        Parent = MainFrame, Name = "RightPanel", Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(1, -200, 0, 0), BackgroundColor3 = Theme["Color Panel BG"], BorderSizePixel = 0
    }), "Panel")
    Create("UICorner", {Parent = RightPanel, CornerRadius = UDim.new(0, 6)})
    Create("UIPadding", {Parent = RightPanel, PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)})

    local ContentPanel = Track(Create("Frame", {
        Parent = MainFrame, Name = "ContentPanel", Size = UDim2.new(1, -(TabSize + 10 + 200), 1, 0),
        Position = UDim2.new(0, TabSize + 10, 0, 0), BackgroundColor3 = Theme["Color Hub BG"], BorderSizePixel = 0
    }), "Frame")
    Create("UICorner", {Parent = ContentPanel, CornerRadius = UDim.new(0, 6)})

    -- Armazena as referências na tabela principal pra todo o script ter acesso
    rareLib.Window = {
        MainGui = MainGui,
        MainFrame = MainFrame,
        NavContainer = NavContainer,
        ContentPanel = ContentPanel,
        RightPanel = RightPanel,
    }
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V3 - by RARO XT & DRIP
-- [ ! ] - PARTE 3/20: A SALA DO TRONO
-- ====================================================================================== --

-- ID: C1 - O CONSTRUTOR DA FICHA DE STATUS
function rareLib:CreateStatusFicha()
    local RightPanel = self.Window.RightPanel
    local Theme = self.Themes[self.Save.Theme]
    local LocalPlayer = Players.LocalPlayer

    local FichaRPG = Create("Frame", {
        Parent = RightPanel, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Name = "FichaRPG"
    })
    
    Create("UIGradient", {
        Parent = FichaRPG, Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 0, 0))
        }), Rotation = 90
    })

    local success, thumbUrl = pcall(Players.GetUserThumbnailAsync, Players, LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180)
    if not success then thumbUrl = "" end

    local AvatarImage = Create("ImageLabel", {
        Parent = FichaRPG, Size = UDim2.new(0, 80, 0, 80), Position = UDim2.new(0.5, -40, 0, 40),
        BackgroundColor3 = Theme["Color Theme"], Image = thumbUrl, ScaleType = Enum.ScaleType.Crop, BackgroundTransparency = 0.1
    })
    Create("UIAspectRatioConstraint", {Parent = AvatarImage})
    Create("UICorner", {Parent = AvatarImage, CornerRadius = UDim.new(1, 0)})
    Create("UIStroke", {Parent = AvatarImage, Color = Color3.fromRGB(255, 255, 255), Thickness = 2})

    Track(Create("TextLabel", {
        Parent = FichaRPG, Size = UDim2.new(1, 0, 0, 25), Position = UDim2.new(0, 0, 0, 130),
        Font = Enum.Font.GothamBold, Text = LocalPlayer.DisplayName, TextColor3 = Theme["Color Text"], TextSize = 20, BackgroundTransparency = 1
    }), "Text")

    Track(Create("TextLabel", {
        Parent = FichaRPG, Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, 155),
        Font = Enum.Font.Gotham, Text = "⛩️ RARE LIB V3", TextColor3 = Theme["Color Theme"], TextSize = 14, BackgroundTransparency = 1
    }), "Theme")

    local function CreateStatusRow(name, posY)
        local Row = Create("Frame", {
            Parent = FichaRPG, Size = UDim2.new(1, -20, 0, 22), Position = UDim2.new(0, 10, 0, posY), BackgroundTransparency = 1
        })
        Track(Create("TextLabel", {
            Parent = Row, Size = UDim2.new(0.5, 0, 1, 0), Font = Enum.Font.GothamBold, TextColor3 = Theme["Color Theme"],
            Text = name .. ":", TextXAlignment = Enum.TextXAlignment.Left, TextSize = 18, BackgroundTransparency = 1
        }), "Theme")
        local ValueLabel = Track(Create("TextLabel", {
            Parent = Row, Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0.5, 0, 0, 0), Font = Enum.Font.Gotham,
            TextColor3 = Theme["Color Text"], Text = "...", TextXAlignment = Enum.TextXAlignment.Right, TextSize = 18, BackgroundTransparency = 1
        }), "Text")
        return ValueLabel
    end

    local VidaLabel = CreateStatusRow("VIDA", 200)
    local PingLabel = CreateStatusRow("PING", 230)
    local FPSLabel = CreateStatusRow("FPS", 260)

    task.spawn(function()
        while FichaRPG and FichaRPG.Parent do
            pcall(function()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then VidaLabel.Text = string.format("%d/%d", math.floor(hum.Health), math.floor(hum.MaxHealth)) else VidaLabel.Text = "N/A" end
            end)
            pcall(function() PingLabel.Text = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString() end)
            pcall(function() FPSLabel.Text = tostring(math.floor(Workspace:GetRealPhysicsFPS())) end)
            task.wait(1)
        end
    end)
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V3 - by RARO XT & DRIP
-- [ ! ] - PARTE 4/20: AS ABAS
-- ====================================================================================== --

-- ID: D1 - O CONSTRUTOR DE TABS
function rareLib:CreateTab(TName, TIcon)
    local Window = self.Window
    local Theme = self.Themes[self.Save.Theme]
    
    local TabButton = Track(Create("TextButton", {
        Parent = Window.NavContainer, Name = tostring(TName) .. "Button", Text = "  " .. tostring(TName),
        TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.Gotham, TextSize = 16,
        TextColor3 = Theme["Color Dark Text"], Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25), LayoutOrder = #self.Tabs + 1, AutoButtonColor = false
    }), "Frame")
    Create("UICorner", {Parent = TabButton, CornerRadius = UDim.new(0, 4)})
    Create("UIStroke", {Parent = TabButton, Color = Theme["Color Stroke"], Thickness = 1, ApplyStrokeMode = "Border"})

    local ContentContainer = Create("ScrollingFrame", {
        Parent = Window.ContentPanel, Name = tostring(TName) .. "_Container", Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, AutomaticCanvasSize = "Y", ScrollingDirection = "Y",
        ScrollBarImageColor3 = Theme["Color Theme"], ScrollBarThickness = 6, Visible = false
    })
    Create("UIListLayout", {Parent = ContentContainer, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder})
    Create("UIPadding", {Parent = ContentContainer, PaddingTop = UDim.new(0, 10), PaddingRight = UDim.new(0, 5)})

    local Tab = {
        Name = TName,
        Container = ContentContainer,
        Button = TabButton,
    }

    local function SelectTab()
        if self.CurrentTab == Tab then return end
        if self.CurrentTab then
            local oldTab = self.CurrentTab
            oldTab.Container.Visible = false
            TweenService:Create(oldTab.Button, TweenInfo.new(0.2), {
                TextColor3 = Theme["Color Dark Text"], BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            }):Play()
        end
        Tab.Container.Visible = true
        self.CurrentTab = Tab
        TweenService:Create(Tab.Button, TweenInfo.new(0.2), {
            TextColor3 = Theme["Color Theme"], BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        }):Play()
    end

    TabButton.MouseButton1Click:Connect(SelectTab)
    table.insert(self.Tabs, Tab)
    
    if #self.Tabs == 1 then SelectTab() end
    
    return Tab
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V3 - by RARO XT & DRIP
-- [ ! ] - PARTE 5/20: BOTÕES
-- ====================================================================================== --

-- ID: E1 - A BASE DOS COMPONENTES (FRAME DE OPÇÃO)
local function CreateOptionFrame(Container, Title, Description, RightSideWidth)
    local Theme = rareLib.Themes[rareLib.Save.Theme]
    local Frame = Track(Create("Frame", {
        Parent = Container, Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = Theme["Color Panel BG"], Name = "Option", LayoutOrder = #Container:GetChildren()
    }), "Panel")
    Create("UICorner", {Parent = Frame, CornerRadius = UDim.new(0, 6)})
    Create("UIPadding", {Parent = Frame, PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)})
    
    Track(Create("TextLabel", {
        Parent = Frame, Size = UDim2.new(1, -(RightSideWidth or 0), 0, 18), Position = UDim2.new(0, 0, 0, 5),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = Title,
        TextColor3 = Theme["Color Text"], TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
    }), "Text")

    Track(Create("TextLabel", {
        Parent = Frame, Size = UDim2.new(1, -(RightSideWidth or 0), 0, 15), Position = UDim2.new(0, 0, 0, 23),
        BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = Description or "",
        TextColor3 = Theme["Color Dark Text"], TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
        Visible = Description and #Description > 0
    }), "DarkText")
    
    return Frame
end

-- ID: E2 - ADICIONANDO BOTÕES ÀS ABAS
function rareLib:AddButton(Tab, Title, Desc, Callback)
    local Frame = CreateOptionFrame(Tab.Container, Title, Desc, 30)
    
    Create("ImageLabel", {
        Parent = Frame, Image = "rbxassetid://10709791437", Size = UDim2.new(0, 15, 0, 15),
        Position = UDim2.new(1, -22, 0.5, -7.5), BackgroundTransparency = 1
    })
    
    local Button = Create("TextButton", {
        Parent = Frame, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", AutoButtonColor = false
    })
    
    Button.MouseButton1Click:Connect(function()
        pcall(Callback)
        -- Animação de clique
        local originalColor = Frame.BackgroundColor3
        TweenService:Create(Frame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
        task.wait(0.1)
        TweenService:Create(Frame, TweenInfo.new(0.1), {BackgroundColor3 = originalColor}):Play()
    end)
    
    return { Frame = Frame }
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V3 - by RARO XT & DRIP
-- [ ! ] - PARTE 6/20: TOGGLES
-- ====================================================================================== --

-- ID: F1 - ADICIONANDO TOGGLES ÀS ABAS
function rareLib:AddToggle(Tab, Title, Desc, InitialValue, Callback)
    local Theme = self.Themes[self.Save.Theme]
    local Frame = CreateOptionFrame(Tab.Container, Title, Desc, 40)
    local state = InitialValue or false
    
    local ToggleButton = Create("TextButton", {
        Parent = Frame, Name = "Switch", Size = UDim2.new(0, 35, 0, 20),
        Position = UDim2.new(1, -40, 0.5, -10), BackgroundColor3 = Theme["Color Stroke"],
        Text = "", AutoButtonColor = false
    })
    Create("UICorner", {Parent = ToggleButton, CornerRadius = UDim.new(1, 0)})
    
    local Knob = Track(Create("Frame", {
        Parent = ToggleButton, Name = "Knob", Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Theme["Color Dark Text"], BorderSizePixel = 0
    }), "DarkText")
    Create("UICorner", {Parent = Knob, CornerRadius = UDim.new(1, 0)})
    
    local function UpdateKnob(newState, isInstant)
        state = newState
        local targetPos = newState and UDim2.new(1, -2, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        local targetColor = newState and Theme["Color Theme"] or Theme["Color Dark Text"]
        
        if isInstant then
            Knob.Position = targetPos
            Knob.BackgroundColor3 = targetColor
        else
            TweenService:Create(Knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = targetPos, BackgroundColor3 = targetColor}):Play()
        end
    end
    
    ToggleButton.MouseButton1Click:Connect(function()
        UpdateKnob(not state)
        pcall(Callback, not state)
    end)
    
    UpdateKnob(state, true)
    
    return {
        Frame = Frame,
        SetState = function(newState) 
            if newState ~= state then
                UpdateKnob(newState)
                pcall(Callback, newState)
            end
        end,
        GetState = function() return state end
    }
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V3 - by RARO XT & DRIP
-- [ ! ] - PARTE 7/20: SLIDERS
-- ====================================================================================== --

-- ID: G1 - ADICIONANDO SLIDERS ÀS ABAS
function rareLib:AddSlider(Tab, Title, Desc, Min, Max, Default, Callback)
    local Theme = self.Themes[self.Save.Theme]
    local Frame = CreateOptionFrame(Tab.Container, Title, Desc, 120)
    local CurrentValue = Default or Min
    
    local SliderHolder = Create("Frame", {
        Parent = Frame, Size = UDim2.new(0, 110, 0, 20),
        Position = UDim2.new(1, -115, 0.5, -10), BackgroundTransparency = 1
    })

    local SliderBar = Track(Create("Frame", {
        Parent = SliderHolder, Name = "SliderBar", BackgroundColor3 = Theme["Color Stroke"],
        Size = UDim2.new(1, -30, 0, 6), Position = UDim2.new(0, 0, 0.5, -3)
    }), "Stroke")
    Create("UICorner", {Parent = SliderBar, CornerRadius = UDim.new(1, 0)})

    local Indicator = Track(Create("Frame", {
        Parent = SliderBar, Name = "Indicator", BackgroundColor3 = Theme["Color Theme"],
        Size = UDim2.fromScale(0, 1), BorderSizePixel = 0
    }), "Theme")
    Create("UICorner", {Parent = Indicator, CornerRadius = UDim.new(1, 0)})

    local Knob = Track(Create("Frame", {
        Parent = SliderBar, Name = "Knob", Size = UDim2.new(0, 14, 0, 14),
        BackgroundColor3 = Theme["Color Text"], Position = UDim2.fromScale(0, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5), BorderSizePixel = 0
    }), "Text")
    Create("UICorner", {Parent = Knob, CornerRadius = UDim.new(1, 0)})

    local ValueLabel = Track(Create("TextLabel", {
        Parent = SliderHolder, Name = "ValueLabel", Text = tostring(math.floor(CurrentValue)),
        Size = UDim2.new(0, 30, 1, 0), Position = UDim2.new(1, -30, 0, 0), BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold, TextColor3 = Theme["Color Text"], TextSize = 14
    }), "Text")

    local function UpdateSlider(NewValue, isInstant)
        CurrentValue = math.clamp(NewValue, Min, Max)
        local percentage = (CurrentValue - Min) / (Max - Min)
        ValueLabel.Text = string.format("%.0f", CurrentValue)
        
        local tweenInfo = isInstant and nil or TweenInfo.new(0.1)
        if tweenInfo then
            TweenService:Create(Knob, tweenInfo, {Position = UDim2.fromScale(percentage, 0.5)}):Play()
            TweenService:Create(Indicator, tweenInfo, {Size = UDim2.fromScale(percentage, 1)}):Play()
        else
            Knob.Position = UDim2.fromScale(percentage, 0.5)
            Indicator.Size = UDim2.fromScale(percentage, 1)
        end
        pcall(Callback, CurrentValue)
    end

    local Dragger = Create("TextButton", {
        Parent = SliderBar, Size = UDim2.new(1, 0, 3, 0), Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Text = ""
    })

    local isDragging = false
    local function HandleInput(input)
        local percentage = (input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X
        percentage = math.clamp(percentage, 0, 1)
        local newValue = math.floor((percentage * (Max - Min)) + Min + 0.5)
        UpdateSlider(newValue)
    end

    Dragger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            Tab.Container.ScrollingEnabled = false
            HandleInput(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            HandleInput(input)
        end
    end)

    Dragger.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
            Tab.Container.ScrollingEnabled = true
        end
    end)
    
    UpdateSlider(Default, true)

    return {
        Frame = Frame,
        SetValue = function(newValue) UpdateSlider(newValue) end,
        GetValue = function() return CurrentValue end
    }
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V3 - by RARO XT & DRIP
-- [ ! ] - PARTE 8/20: DROPDOWNS
-- ====================================================================================== --

-- ID: H1 - ADICIONANDO DROPDOWNS ÀS ABAS
function rareLib:AddDropdown(Tab, Title, Desc, Options, DefaultOption, Callback)
    local Theme = self.Themes[self.Save.Theme]
    local Frame = CreateOptionFrame(Tab.Container, Title, Desc, 140)
    local SelectedValue = DefaultOption or Options[1]
    local DropdownVisible = false

    local DropdownButton = Track(Create("TextButton", {
        Parent = Frame, Size = UDim2.new(0, 130, 0, 22), Position = UDim2.new(1, -135, 0.5, -11),
        BackgroundColor3 = Theme["Color Stroke"], Text = "", AutoButtonColor = false
    }), "Stroke")
    Create("UICorner", {Parent = DropdownButton, CornerRadius = UDim.new(0, 4)})

    local Label = Track(Create("TextLabel", {
        Parent = DropdownButton, Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextColor3 = Theme["Color Text"],
        Text = SelectedValue, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = "AtEnd"
    }), "Text")

    local Arrow = Create("ImageLabel", {
        Parent = DropdownButton, Image = "rbxassetid://10709791523", Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(1, -15, 0.5, -6), BackgroundTransparency = 1
    })
    
    local Overlay = Create("Frame", {
        Parent = self.Window.MainGui, Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, ZIndex = 3, Visible = false
    })
    
    local ListPanel = Track(Create("ScrollingFrame", {
        Parent = Overlay, Size = UDim2.new(0, 130, 0, 1), BackgroundColor3 = Theme["Color Hub BG"],
        BorderColor3 = Theme["Color Theme"], BorderSizePixel = 2, ZIndex = 4,
        ScrollBarImageColor3 = Theme["Color Theme"], ScrollBarThickness = 6,
        AutomaticCanvasSize = "Y", ScrollingDirection = "Y", ClipsDescendants = true
    }), "ScrollBar")
    Create("UICorner", {Parent = ListPanel, CornerRadius = UDim.new(0, 4)})
    Create("UIListLayout", {Parent = ListPanel, Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder})
    Create("UIPadding", {Parent = ListPanel, PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5)})
    
    local function ToggleDropdown()
        DropdownVisible = not DropdownVisible
        Overlay.Visible = DropdownVisible
        
        if DropdownVisible then
            local pos = DropdownButton.AbsolutePosition
            local listHeight = ListPanel.CanvasSize.Y.Offset + 10
            local targetHeight = math.min(listHeight, 150)
            local x, y = pos.X, pos.Y + DropdownButton.AbsoluteSize.Y
            if y + targetHeight > self.Window.MainGui.AbsoluteSize.Y then y = pos.Y - targetHeight end
            
            ListPanel.Position = UDim2.fromOffset(x, y)
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
        if DropdownVisible then ToggleDropdown() end
    end
    
    for _, option in ipairs(Options) do
        local optButton = Track(Create("TextButton", {
            Parent = ListPanel, Size = UDim2.new(1, 0, 0, 22), BackgroundColor3 = Theme["Color Hub BG"],
            Text = "  " .. option, Font = Enum.Font.Gotham, TextColor3 = Theme["Color Text"],
            TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false
        }), "Frame")
        optButton.MouseEnter:Connect(function() optButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30) end)
        optButton.MouseLeave:Connect(function() optButton.BackgroundColor3 = Theme["Color Hub BG"] end)
        optButton.MouseButton1Click:Connect(function() SelectOption(option) end)
    end
    
    DropdownButton.MouseButton1Click:Connect(ToggleDropdown)
    Overlay.MouseButton1Down:Connect(function() if DropdownVisible then ToggleDropdown() end end)

    return { Frame = Frame, SetValue = SelectOption, GetValue = function() return SelectedValue end }
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V3 - by RARO XT & DRIP
-- [ ! ] - PARTE 9/20: TEXTBOXES
-- ====================================================================================== --

-- ID: I1 - ADICIONANDO TEXTBOXES ÀS ABAS
function rareLib:AddTextbox(Tab, Title, Desc, Placeholder, Callback)
    local Theme = self.Themes[self.Save.Theme]
    local Frame = CreateOptionFrame(Tab.Container, Title, Desc, 140)

    local TextboxFrame = Track(Create("Frame", {
        Parent = Frame, Size = UDim2.new(0, 130, 0, 22),
        Position = UDim2.new(1, -135, 0.5, -11), BackgroundColor3 = Theme["Color Stroke"]
    }), "Stroke")
    Create("UICorner", {Parent = TextboxFrame, CornerRadius = UDim2.new(0, 4, 0, 4)})

    local Textbox = Track(Create("TextBox", {
        Parent = TextboxFrame, Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextColor3 = Theme["Color Text"],
        Text = "", PlaceholderText = Placeholder or "...", PlaceholderColor3 = Theme["Color Dark Text"],
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false
    }), "Text")

    Textbox.FocusGained:Connect(function()
        TweenService:Create(TextboxFrame, TweenInfo.new(0.2), {BorderColor3 = Theme["Color Theme"], BorderSizePixel = 1}):Play()
    end)
    
    Textbox.FocusLost:Connect(function(enterPressed)
        TweenService:Create(TextboxFrame, TweenInfo.new(0.2), {BorderColor3 = Color3.fromRGB(0,0,0), BorderSizePixel = 0}):Play()
        if enterPressed and Textbox.Text:gsub("%s", "") ~= "" then
            pcall(Callback, Textbox.Text)
        end
    end)
    
    return {
        Frame = Frame,
        SetText = function(newText) Textbox.Text = newText end,
        GetText = function() return Textbox.Text end,
    }
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V3 - by RARO XT & DRIP
-- [ ! ] - PARTE 10/20: A CONSTELAÇÃO
-- ====================================================================================== --

-- ID: J1 - O CONSTRUTOR DO EFEITO DE PARTÍCULAS
function rareLib:CreateConstellation()
    local Theme = self.Themes[self.Save.Theme]
    local MainFrame = self.Window.MainFrame

    local particleFrame = Create("Frame", {
        Parent = MainFrame, Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, ZIndex = 0
    })
    
    local particles, lines = {}, {}
    local numParticles, connectDistance = 35, 100

    for i = 1, numParticles do
        local p = Create("Frame", {
            Parent = particleFrame, Size = UDim2.new(0, 3, 0, 3),
            BackgroundColor3 = Theme["Color Theme"], BorderSizePixel = 0
        })
        Create("UICorner", {Parent = p, CornerRadius = UDim.new(1, 0)})
        table.insert(particles, {
            gui = p,
            pos = Vector2.new(math.random(0, MainFrame.AbsoluteSize.X), math.random(0, MainFrame.AbsoluteSize.Y)),
            vel = Vector2.new(math.random(-20, 20), math.random(-20, 20))
        })
    end

    local connection = RunService.RenderStepped:Connect(function(dt)
        if not MainFrame or not MainFrame.Parent then connection:Disconnect() return end
        for _, line in ipairs(lines) do line:Destroy() end; lines = {}
        
        local size = MainFrame.AbsoluteSize
        if size.X == 0 then return end

        for i, p1 in ipairs(particles) do
            p1.pos = p1.pos + p1.vel * dt
            if p1.pos.X < 0 or p1.pos.X > size.X then p1.vel = Vector2.new(-p1.vel.X, p1.vel.Y) end
            if p1.pos.Y < 0 or p1.pos.Y > size.Y then p1.vel = Vector2.new(p1.vel.X, -p1.vel.Y) end
            p1.gui.Position = UDim2.fromOffset(p1.pos.X, p1.pos.Y)
            
            for j = i + 1, #particles do
                local p2 = particles[j]
                local dist = (p1.pos - p2.pos).Magnitude
                if dist < connectDistance then
                    local line = Create("Frame", {
                        Parent = particleFrame, Size = UDim2.new(0, dist, 0, 1),
                        Position = UDim2.fromOffset((p1.pos.X + p2.pos.X) / 2, (p1.pos.Y + p2.pos.Y) / 2),
                        Rotation = math.deg(math.atan2(p2.pos.Y - p1.pos.Y, p2.pos.X - p1.pos.X)),
                        BackgroundColor3 = Theme["Color Theme"], BorderSizePixel = 0, ZIndex = 0,
                        BackgroundTransparency = 1 - (1 - dist / connectDistance) * 0.8,
                    })
                    table.insert(lines, line)
                end
            end
        end
    end)
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V3 - by RARO XT & DRIP
-- [ ! ] - PARTE 11/20: FINALIZAÇÃO
-- ====================================================================================== --

-- ID: K1 - O EMPACOTADOR
-- Essa função vai juntar todas as peças que a gente construiu
function rareLib:Init(Title, IconURL)
    -- Cria a janela principal e armazena a referência
    self:CreateWindow(Title, IconURL)
    
    -- Popula a janela com a ficha de status
    self:CreateStatusFicha()
    
    -- Ativa o efeito de partículas no fundo
    self:CreateConstellation()
    
    -- Retorna a API final para o usuário poder criar abas e componentes
    local UserAPI = {
        Window = self.Window,
        CreateTab = function(TName, TIcon)
            return self:CreateTab(TName, TIcon)
        end,
        -- Adicionando um atalho direto pra criar componentes na última aba criada
        AddButton = function(...)
            if self.CurrentTab then return self:AddButton(self.CurrentTab, ...) end
        end,
        AddToggle = function(...)
            if self.CurrentTab then return self:AddToggle(self.CurrentTab, ...) end
        end,
        AddSlider = function(...)
            if self.CurrentTab then return self:AddSlider(self.CurrentTab, ...) end
        end,
        AddDropdown = function(...)
            if self.CurrentTab then return self:AddDropdown(self.CurrentTab, ...) end
        end,
        AddTextbox = function(...)
            if self.CurrentTab then return self:AddTextbox(self.CurrentTab, ...) end
        end
    }
    
    return UserAPI
end

-- ID: K2 - O FIM DA LIB
return rareLib
