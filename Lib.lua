-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB: A VERSÃO FINAL - by RARO XT & DRIP
-- [ ! ] - PARTE 1/20: A FUNDAÇÃO (O ALICERCE FINAL)
-- ====================================================================================== --

-- ID: A1 - O MOLDE MESTRE (A "CLASSE" RARELIB)
local rareLib = {}
rareLib.__index = rareLib -- A vacina anti-erro de API. Essencial.

-- ID: A2 - ARSENAL DE SERVIÇOS
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- ID: A3 - A FÁBRICA DE PEÇAS (FUNÇÃO DE CRIAÇÃO)
-- Única, otimizada e à prova de balas.
local function pCreate(instanceType, properties)
    local newInstance = Instance.new(instanceType)
    if properties then
        for prop, value in pairs(properties) do
            pcall(function() newInstance[prop] = value end)
        end
    end
    return newInstance
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V7 - A VERSÃO PERFEITA - by RARO XT & DRIP
-- [ ! ] - PARTE 2/20: O CONSTRUTOR DO HUB E A UI ARREDONDADA
-- ====================================================================================== --

-- ID: B1 - FUNÇÃO DE ARRASTAR (MOBILE SOBERANO)
local function pMakeDrag(instance)
    local isDragging = false
    local startPos, dragStart
    instance.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging, startPos, dragStart = true, instance.Position, input.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            instance.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (input.Position.X - dragStart.X), startPos.Y.Scale, startPos.Y.Offset + (input.Position.Y - dragStart.Y))
        end
    end)
    instance.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDragging = false end
    end)
end

-- ID: B2 - O CONSTRUTOR MESTRE (:new)
function rareLib:new(Title)
    if CoreGui:FindFirstChild("RARE_LIB_UI") then CoreGui.RARE_LIB_UI:Destroy() end

    local Hub = setmetatable({}, rareLib)

    -- Configurações de Base
    Hub.Title = Title or "Rare Lib"
    Hub.Theme = {
        ["Color Hub BG"] = Color3.fromRGB(15, 15, 15), ["Color Panel BG"] = Color3.fromRGB(12, 12, 12),
        ["Color Stroke"] = Color3.fromRGB(40, 40, 40), ["Color Theme"] = Color3.fromRGB(139, 0, 0),
        ["Color Text"] = Color3.fromRGB(240, 240, 240), ["Color Dark Text"] = Color3.fromRGB(150, 150, 150)
    }
    Hub.Config = { UISize = {700, 450}, TabSize = 150 }
    Hub.Tabs, Hub.CurrentTab = {}, nil

    -- O ScreenGui que segura tudo
    Hub.MainGui = pCreate("ScreenGui", {Parent = CoreGui, Name = "RARE_LIB_UI", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    
    -- O MainFrame (A janela principal)
    local Theme = Hub.Theme
    local UISizeX, UISizeY = unpack(Hub.Config.UISize)
    Hub.MainFrame = pCreate("Frame", {
        Parent = Hub.MainGui, Name = "Hub", Size = UDim2.fromOffset(UISizeX, UISizeY),
        Position = UDim2.new(0.5, -UISizeX/2, 0.5, -UISizeY/2), BackgroundColor3 = Theme["Color Hub BG"],
        BorderColor3 = Theme["Color Stroke"], BorderSizePixel = 2
    })
    pCreate("UICorner", {Parent = Hub.MainFrame, CornerRadius = UDim.new(0, 12)}) -- <<< ARREDONDADO NA JANELA PRINCIPAL
    pMakeDrag(Hub.MainFrame)

    -- Barra de Título
    local TitleBar = pCreate("Frame", {
        Parent = Hub.MainFrame, Name = "TitleBar", Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Theme["Color Panel BG"], ZIndex = 2
    })
    pCreate("UICorner", {Parent = TitleBar, CornerRadius = UDim.new(0, 10)}) -- <<< ARREDONDADO NA BARRA DE TÍTULO
    pCreate("TextLabel", {
        Parent = TitleBar, Name = "TitleLabel", Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = Hub.Title,
        TextColor3 = Theme["Color Text"], TextSize = 16
    })

    -- Botão flutuante para abrir/fechar
    local ToggleButton = pCreate("TextButton", {
        Parent = Hub.MainGui, Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0, 15, 0.5, -25),
        BackgroundColor3 = Theme["Color Theme"], Text = "愛", Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 32,
    })
    pCreate("UICorner", {Parent = ToggleButton, CornerRadius = UDim.new(1, 0)}) -- Botão redondinho
    pCreate("UIStroke", {Parent = ToggleButton, Color = Color3.fromRGB(255, 255, 255)})
    ToggleButton.MouseButton1Click:Connect(function() Hub.MainFrame.Visible = not Hub.MainFrame.Visible end)
    pMakeDrag(ToggleButton)

    return Hub
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V7 - A VERSÃO MINIMALISTA PERFEITA - by RARO XT & DRIP
-- [ ! ] - PARTE 4/20: A SALA DO TRONO
-- ====================================================================================== --

-- ID: D1 - FUNÇÃO "PRIVADA" PARA CONSTRUIR A FICHA DE STATUS
function rareLib:__buildStatusPanel()
    local Theme = self.Theme
    local LocalPlayer = Players.LocalPlayer

    local FichaRPG = pCreate("Frame", {
        Parent = self.RightPanel, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Name = "FichaRPG"
    })
    
    pCreate("UIGradient", {
        Parent = FichaRPG, Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 0, 0))
        }), Rotation = 90
    })

    local success, thumbUrl = pcall(Players.GetUserThumbnailAsync, Players, LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180)
    
    local AvatarImage = pCreate("ImageLabel", {
        Parent = FichaRPG, Size = UDim2.new(0, 80, 0, 80), Position = UDim2.new(0.5, -40, 0, 40),
        BackgroundColor3 = Theme["Color Theme"], Image = success and thumbUrl or "", ScaleType = Enum.ScaleType.Crop, BackgroundTransparency = 0.1
    })
    pCreate("UIAspectRatioConstraint", {Parent = AvatarImage})
    pCreate("UICorner", {Parent = AvatarImage, CornerRadius = UDim.new(1, 0)})
    pCreate("UIStroke", {Parent = AvatarImage, Color = Color3.fromRGB(255, 255, 255), Thickness = 2})

    pCreate("TextLabel", {
        Parent = FichaRPG, Size = UDim2.new(1, 0, 0, 25), Position = UDim2.new(0, 0, 0, 130),
        Font = Enum.Font.GothamBold, Text = LocalPlayer.DisplayName, TextColor3 = Theme["Color Text"], TextSize = 20, BackgroundTransparency = 1
    })

    pCreate("TextLabel", {
        Parent = FichaRPG, Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, 155),
        Font = Enum.Font.Gotham, Text = "⛩️ " .. self.Title, TextColor3 = Theme["Color Theme"], TextSize = 14, BackgroundTransparency = 1
    })

    local function CreateStatusRow(name, posY)
        local Row = pCreate("Frame", {Parent = FichaRPG, Size = UDim2.new(1, -20, 0, 22), Position = UDim2.new(0, 10, 0, posY), BackgroundTransparency = 1})
        pCreate("TextLabel", {Parent = Row, Size = UDim2.new(0.5, 0, 1, 0), Font = Enum.Font.GothamBold, TextColor3 = Theme["Color Theme"], Text = name .. ":", TextXAlignment = Enum.TextXAlignment.Left, TextSize = 18, BackgroundTransparency = 1})
        local ValueLabel = pCreate("TextLabel", {Parent = Row, Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0.5, 0, 0, 0), Font = Enum.Font.Gotham, TextColor3 = Theme["Color Text"], Text = "...", TextXAlignment = Enum.TextXAlignment.Right, TextSize = 18, BackgroundTransparency = 1})
        return ValueLabel
    end

    local VidaLabel = CreateStatusRow("VIDA", 200)
    local PingLabel = CreateStatusRow("PING", 230)
    local FPSLabel = CreateStatusRow("FPS", 260)

    task.spawn(function()
        while self.MainGui and self.MainGui.Parent do
            pcall(function()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                VidaLabel.Text = hum and string.format("%d/%d", math.floor(hum.Health), math.floor(hum.MaxHealth)) or "N/A"
            end)
            pcall(function() PingLabel.Text = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString() end)
            pcall(function() FPSLabel.Text = tostring(math.floor(Workspace:GetRealPhysicsFPS())) end)
            task.wait(1)
        end
    end)
end

-- ID: D2 - ATUALIZANDO O CONSTRUTOR MESTRE
local OriginalNew_D = rareLib.new
function rareLib:new(Title)
    local Hub = OriginalNew_D(self, Title)

    Hub:__buildStatusPanel()

    return Hub
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V7 - A VERSÃO MINIMALISTA PERFEITA - by RARO XT & DRIP
-- [ ! ] - PARTE 5/20: AS ABAS
-- ====================================================================================== --

-- ID: E1 - A API PÚBLICA PARA CRIAR ABAS: Hub:CreateTab()
function rareLib:CreateTab(TName)
    local Theme = self.Theme
    
    -- O objeto Tab. Ele vai herdar as funções do Hub (como AddButton)
    local Tab = setmetatable({}, {__index = self})
    Tab.Name = TName
    
    Tab.Button = pCreate("TextButton", {
        Parent = self.NavContainer, Name = TName .. "Button", Text = "  " .. TName,
        TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.Gotham, TextSize = 16,
        TextColor3 = Theme["Color Dark Text"], Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25), LayoutOrder = #self.Tabs + 1, AutoButtonColor = false
    })
    pCreate("UICorner", {Parent = Tab.Button, CornerRadius = UDim.new(0, 4)})
    pCreate("UIStroke", {Parent = Tab.Button, Color = Theme["Color Stroke"], Thickness = 1, ApplyStrokeMode = "Border"})

    Tab.Container = pCreate("ScrollingFrame", {
        Parent = self.ContentPanel, Name = TName .. "_Container", Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, AutomaticCanvasSize = "Y", ScrollingDirection = Enum.ScrollingDirection.Y,
        ScrollBarImageColor3 = Theme["Color Theme"], ScrollBarThickness = 6, Visible = false
    })
    pCreate("UIListLayout", {Parent = Tab.Container, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder})
    pCreate("UIPadding", {Parent = Tab.Container, PaddingTop = UDim.new(0, 10), PaddingRight = UDim.new(0, 5)})

    local function SelectTab()
        if self.CurrentTab == Tab then return end
        if self.CurrentTab then
            self.CurrentTab.Container.Visible = false
            TweenService:Create(self.CurrentTab.Button, TweenInfo.new(0.2), {
                TextColor3 = Theme["Color Dark Text"], BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            }):Play()
        end
        Tab.Container.Visible = true
        self.CurrentTab = Tab
        TweenService:Create(Tab.Button, TweenInfo.new(0.2), {
            TextColor3 = Theme["Color Theme"], BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        }):Play()
    end

    Tab.Button.MouseButton1Click:Connect(SelectTab)
    table.insert(self.Tabs, Tab)
    
    if #self.Tabs == 1 then SelectTab() end
    
    return Tab
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V7 - A VERSÃO MINIMALISTA PERFEITA - by RARO XT & DRIP
-- [ ! ] - PARTE 6/20: BOTÕES E TOGGLES
-- ====================================================================================== --

-- ID: F1 - A BASE VISUAL DOS COMPONENTES (FRAME DE OPÇÃO)
-- Função privada que cria o "molde" visual para todos os componentes.
function rareLib:__createOptionFrame(Container, options)
    local Theme = self.Theme
    local Frame = pCreate("Frame", {
        Parent = Container, Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = Theme["Color Panel BG"], Name = "Option", LayoutOrder = #Container:GetChildren() + 1
    })
    pCreate("UICorner", {Parent = Frame, CornerRadius = UDim.new(0, 6)})
    pCreate("UIPadding", {Parent = Frame, PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)})
    
    pCreate("TextLabel", {
        Parent = Frame, Size = UDim2.new(1, -(options.RightSideWidth or 0), 0, 18), Position = UDim2.new(0, 0, 0, 5),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = options.Title,
        TextColor3 = Theme["Color Text"], TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
    })

    pCreate("TextLabel", {
        Parent = Frame, Size = UDim2.new(1, -(options.RightSideWidth or 0), 0, 15), Position = UDim2.new(0, 0, 0, 23),
        BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = options.Desc or "",
        TextColor3 = Theme["Color Dark Text"], TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
        Visible = options.Desc and #options.Desc > 0
    })
    
    return Frame
end

-- ID: F2 - A API PÚBLICA PARA CRIAR BOTÕES: Tab:AddButton({...})
function rareLib:AddButton(options)
    options.RightSideWidth = 30 -- Define a largura reservada para o ícone
    local Frame = self:__createOptionFrame(self.Container, options)
    
    pCreate("ImageLabel", {
        Parent = Frame, Image = "rbxassetid://10709791437", Size = UDim2.new(0, 15, 0, 15),
        Position = UDim2.new(1, -22, 0.5, -7.5), BackgroundTransparency = 1
    })
    
    local Button = pCreate("TextButton", {
        Parent = Frame, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", AutoButtonColor = false
    })
    
    Button.MouseButton1Click:Connect(function()
        pcall(options.Callback)
        local originalColor = Frame.BackgroundColor3
        TweenService:Create(Frame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
        task.wait(0.1)
        TweenService:Create(Frame, TweenInfo.new(0.1), {BackgroundColor3 = originalColor}):Play()
    end)
    
    return { Frame = Frame }
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V7 - A VERSÃO MINIMALISTA PERFEITA - by RARO XT & DRIP
-- [ ! ] - PARTE 7/20: TOGGLES
-- ====================================================================================== --

-- ID: G1 - A API PÚBLICA PARA CRIAR TOGGLES: Tab:AddToggle({...})
function rareLib:AddToggle(options)
    options.RightSideWidth = 40 -- Define a largura reservada para o switch
    local Theme = self.Theme
    local Frame = self:__createOptionFrame(self.Container, options)
    local state = options.Default or false
    
    local ToggleButton = pCreate("TextButton", {
        Parent = Frame, Name = "Switch", Size = UDim2.new(0, 35, 0, 20),
        Position = UDim2.new(1, -40, 0.5, -10), BackgroundColor3 = Theme["Color Stroke"],
        Text = "", AutoButtonColor = false
    })
    pCreate("UICorner", {Parent = ToggleButton, CornerRadius = UDim.new(1, 0)})
    
    local Knob = pCreate("Frame", {
        Parent = ToggleButton, Name = "Knob", Size = UDim2.new(0, 16, 0, 16),
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 10, 0.5, 0),
        BackgroundColor3 = Theme["Color Dark Text"], BorderSizePixel = 0
    })
    pCreate("UICorner", {Parent = Knob, CornerRadius = UDim.new(1, 0)})
    
    local function UpdateKnob(newState, isInstant)
        state = newState
        local targetPos = newState and UDim2.new(0, 25, 0.5, 0) or UDim2.new(0, 10, 0.5, 0)
        local targetColor = newState and Theme["Color Theme"] or Theme["Color Dark Text"]
        
        if isInstant then
            Knob.Position = targetPos
            Knob.BackgroundColor3 = targetColor
        else
            TweenService:Create(Knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = targetPos, BackgroundColor3 = targetColor}):Play()
        end
    end
    
    ToggleButton.MouseButton1Click:Connect(function()
        local newState = not state
        UpdateKnob(newState)
        pcall(options.Callback, newState)
    end)
    
    UpdateKnob(state, true)
    
    local API = {}
    API.SetState = function(newState) 
        if newState ~= state then
            UpdateKnob(newState)
            pcall(options.Callback, newState)
        end
    end
    API.GetState = function() return state end

    return API
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V7 - A VERSÃO MINIMALISTA PERFEITA - by RARO XT & DRIP
-- [ ! ] - PARTE 8/20: SLIDERS
-- ====================================================================================== --

-- ID: H1 - A API PÚBLICA PARA CRIAR SLIDERS: Tab:AddSlider({...})
function rareLib:AddSlider(options)
    options.RightSideWidth = 120 -- Define a largura reservada para a barra e o valor
    local Theme = self.Theme
    local Min, Max, Default = options.Min or 0, options.Max or 100, options.Default or 0
    local Frame = self:__createOptionFrame(self.Container, options)
    local CurrentValue = Default
    
    local SliderHolder = pCreate("Frame", {
        Parent = Frame, Size = UDim2.new(0, 110, 0, 20),
        Position = UDim2.new(1, -115, 0.5, -10), BackgroundTransparency = 1
    })

    local SliderBar = pCreate("Frame", {
        Parent = SliderHolder, Name = "SliderBar", BackgroundColor3 = Theme["Color Stroke"],
        Size = UDim2.new(1, -30, 0, 6), Position = UDim2.new(0, 0, 0.5, -3)
    })
    pCreate("UICorner", {Parent = SliderBar, CornerRadius = UDim.new(1, 0)})

    local Indicator = pCreate("Frame", {
        Parent = SliderBar, Name = "Indicator", BackgroundColor3 = Theme["Color Theme"],
        Size = UDim2.fromScale(0, 1), BorderSizePixel = 0
    })
    pCreate("UICorner", {Parent = Indicator, CornerRadius = UDim.new(1, 0)})

    local Knob = pCreate("Frame", {
        Parent = SliderBar, Name = "Knob", Size = UDim2.new(0, 14, 0, 14),
        BackgroundColor3 = Theme["Color Text"], Position = UDim2.fromScale(0, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5), BorderSizePixel = 0
    })
    pCreate("UICorner", {Parent = Knob, CornerRadius = UDim.new(1, 0)})

    local ValueLabel = pCreate("TextLabel", {
        Parent = SliderHolder, Name = "ValueLabel", Text = tostring(math.floor(CurrentValue)),
        Size = UDim2.new(0, 30, 1, 0), Position = UDim2.new(1, -30, 0, 0), BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold, TextColor3 = Theme["Color Text"], TextSize = 14
    })

    local function UpdateSlider(NewValue, isInstant)
        CurrentValue = math.clamp(NewValue, Min, Max)
        local percentage = (CurrentValue - Min) / (Max - Min)
        ValueLabel.Text = string.format("%.0f", CurrentValue)
        
        local info = isInstant and TweenInfo.new(0) or TweenInfo.new(0.1)
        TweenService:Create(Knob, info, {Position = UDim2.fromScale(percentage, 0.5)}):Play()
        TweenService:Create(Indicator, info, {Size = UDim2.fromScale(percentage, 1)}):Play()
        
        pcall(options.Callback, CurrentValue)
    end

    local Dragger = pCreate("TextButton", {
        Parent = SliderBar, Size = UDim2.new(1, 10, 3, 0), Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Text = ""
    })

    local isDragging = false
    Dragger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            self.Container.ScrollingEnabled = false
            local pos = input.Position.X - SliderBar.AbsolutePosition.X
            local percentage = math.clamp(pos / SliderBar.AbsoluteSize.X, 0, 1)
            local newValue = math.floor((percentage * (Max - Min)) + Min + 0.5)
            UpdateSlider(newValue)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = input.Position.X - SliderBar.AbsolutePosition.X
            local percentage = math.clamp(pos / SliderBar.AbsoluteSize.X, 0, 1)
            local newValue = math.floor((percentage * (Max - Min)) + Min + 0.5)
            UpdateSlider(newValue)
        end
    end)

    Dragger.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
            self.Container.ScrollingEnabled = true
        end
    end)
    
    UpdateSlider(Default, true)

    local API = {}
    API.SetValue = UpdateSlider
    API.GetValue = function() return CurrentValue end

    return API
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V7 - A VERSÃO MINIMALISTA PERFEITA - by RARO XT & DRIP
-- [ ! ] - PARTE 9/20: DROPDOWNS
-- ====================================================================================== --

-- ID: I1 - A API PÚBLICA PARA CRIAR DROPDOWNS: Tab:AddDropdown({...})
function rareLib:AddDropdown(options)
    options.RightSideWidth = 140
    local Theme = self.Theme
    local Options, Default, Callback = options.Options or {}, options.Default or options.Options[1], options.Callback
    local Frame = self:__createOptionFrame(self.Container, options)
    local SelectedValue = Default
    local isDropdownVisible = false

    local DropdownButton = pCreate("TextButton", {
        Parent = Frame, Size = UDim2.new(0, 130, 0, 22),
        Position = UDim2.new(1, -135, 0.5, -11), BackgroundColor3 = Theme["Color Stroke"],
        Text = "", AutoButtonColor = false
    })
    pCreate("UICorner", {Parent = DropdownButton, CornerRadius = UDim.new(0, 4)})

    local Label = pCreate("TextLabel", {
        Parent = DropdownButton, Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextColor3 = Theme["Color Text"],
        Text = SelectedValue, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = "AtEnd"
    })

    local Arrow = pCreate("ImageLabel", {
        Parent = DropdownButton, Image = "rbxassetid://10709791523", Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(1, -15, 0.5, -6), BackgroundTransparency = 1
    })
    
    local Overlay = pCreate("TextButton", {
        Parent = self.MainGui, Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, ZIndex = 10, Visible = false, Text = ""
    })
    
    local ListPanel = pCreate("ScrollingFrame", {
        Parent = Overlay, Size = UDim2.new(0, 130, 0, 1), BackgroundColor3 = Theme["Color Hub BG"],
        BorderColor3 = Theme["Color Theme"], BorderSizePixel = 2, ZIndex = 11,
        ScrollBarImageColor3 = Theme["Color Theme"], ScrollBarThickness = 6,
        AutomaticCanvasSize = "Y", ScrollingDirection = Enum.ScrollingDirection.Y, ClipsDescendants = true
    })
    pCreate("UICorner", {Parent = ListPanel, CornerRadius = UDim.new(0, 4)})
    pCreate("UIListLayout", {Parent = ListPanel, Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder})
    pCreate("UIPadding", {Parent = ListPanel, PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5)})
    
    local function ToggleDropdown()
        isDropdownVisible = not isDropdownVisible
        Overlay.Visible = isDropdownVisible
        
        if isDropdownVisible then
            local pos = DropdownButton.AbsolutePosition
            local listHeight = ListPanel.CanvasSize.Y.Offset + 10
            local targetHeight = math.min(listHeight, 200)
            local x, y = pos.X, pos.Y + DropdownButton.AbsoluteSize.Y
            if y + targetHeight > self.MainGui.AbsoluteSize.Y then y = pos.Y - targetHeight end
            
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
        if isDropdownVisible then ToggleDropdown() end
    end
    
    for _, option in ipairs(Options) do
        local optButton = pCreate("TextButton", {
            Parent = ListPanel, Size = UDim2.new(1, 0, 0, 22), BackgroundColor3 = Theme["Color Hub BG"],
            Text = "  " .. option, Font = Enum.Font.Gotham, TextColor3 = Theme["Color Text"],
            TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false
        })
        optButton.MouseEnter:Connect(function() optButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30) end)
        optButton.MouseLeave:Connect(function() optButton.BackgroundColor3 = Theme["Color Hub BG"] end)
        optButton.MouseButton1Click:Connect(function() SelectOption(option) end)
    end
    
    DropdownButton.MouseButton1Click:Connect(ToggleDropdown)
    Overlay.MouseButton1Click:Connect(function() if isDropdownVisible then ToggleDropdown() end end)

    local API = {}
    API.SetValue = SelectOption
    API.GetValue = function() return SelectedValue end
    
    return API
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V7 - A VERSÃO MINIMALISTA PERFEITA - by RARO XT & DRIP
-- [ ! ] - PARTE 10/20: TEXTBOXES
-- ====================================================================================== --

-- ID: J1 - A API PÚBLICA PARA CRIAR TEXTBOXES: Tab:AddTextbox({...})
function rareLib:AddTextbox(options)
    options.RightSideWidth = 140 -- Define a largura reservada para a caixa
    local Theme = self.Theme
    local Placeholder, Callback = options.Placeholder or "...", options.Callback
    local Frame = self:__createOptionFrame(self.Container, options)

    local TextboxFrame = pCreate("Frame", {
        Parent = Frame, Size = UDim2.new(0, 130, 0, 22),
        Position = UDim2.new(1, -135, 0.5, -11), BackgroundColor3 = Theme["Color Stroke"]
    })
    pCreate("UICorner", {Parent = TextboxFrame, CornerRadius = UDim2.new(0, 4, 0, 4)})

    local Textbox = pCreate("TextBox", {
        Parent = TextboxFrame, Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextColor3 = Theme["Color Text"],
        Text = "", PlaceholderText = Placeholder, PlaceholderColor3 = Theme["Color Dark Text"],
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false
    })
    
    local Stroke = pCreate("UIStroke", { Parent = TextboxFrame, ApplyStrokeMode = "Border", Color = Theme["Color Theme"], Thickness = 0, Enabled = false })

    Textbox.Focused:Connect(function()
        Stroke.Enabled = true
        TweenService:Create(Stroke, TweenInfo.new(0.2), { Thickness = 1 }):Play()
    end)
    
    Textbox.FocusLost:Connect(function(enterPressed)
        TweenService:Create(Stroke, TweenInfo.new(0.2), { Thickness = 0 }):Play()
        task.delay(0.2, function()
            if Stroke and Stroke.Parent then Stroke.Enabled = false end
        end)
        if enterPressed and Textbox.Text:gsub("%s", "") ~= "" then
            pcall(Callback, Textbox.Text)
        end
    end)
    
    local API = {}
    API.SetText = function(newText) Textbox.Text = newText end
    API.GetText = function() return Textbox.Text end
    
    return API
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V7 - A VERSÃO MINIMALISTA PERFEITA - by RARO XT & DRIP
-- [ ! ] - PARTE 11/20: A CONSTELAÇÃO E O PACOTE FINAL
-- ====================================================================================== --

-- ID: K1 - FUNÇÃO "PRIVADA" PARA CONSTRUIR O EFEITO DE PARTÍCULAS
function rareLib:__buildConstellation()
    local Theme = self.Theme
    
    -- O Fundo da Constelação (Camada 0 dentro do MainFrame)
    local particleFrame = pCreate("Frame", {
        Parent = self.MainFrame, -- O pai é o MainFrame
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, 
        ZIndex = 0 -- Fica atrás de absolutamente tudo DENTRO do MainFrame
    })
    
    local particles, lines = {}, {}
    local numParticles, connectDistance = 50, 120

    task.wait() 
    local frameSize = particleFrame.AbsoluteSize

    for i = 1, numParticles do
        local p = pCreate("Frame", {
            Parent = particleFrame, Size = UDim2.new(0, 3, 0, 3),
            BackgroundColor3 = Theme["Color Theme"], BorderSizePixel = 0
        })
        pCreate("UICorner", {Parent = p, CornerRadius = UDim.new(1, 0)})
        table.insert(particles, {
            gui = p,
            pos = Vector2.new(math.random(0, frameSize.X), math.random(0, frameSize.Y)),
            vel = Vector2.new(math.random(-20, 20), math.random(-20, 20))
        })
    end

    local connection = RunService.RenderStepped:Connect(function(dt)
        if not self.MainGui or not self.MainGui.Parent then connection:Disconnect() return end
        for _, line in ipairs(lines) do line:Destroy() end; lines = {}
        
        local currentSize = particleFrame.AbsoluteSize
        if currentSize.X == 0 then return end

        for i, p1 in ipairs(particles) do
            p1.pos = p1.pos + p1.vel * dt
            if p1.pos.X < 0 or p1.pos.X > currentSize.X then p1.vel = Vector2.new(-p1.vel.X, p1.vel.Y) end
            if p1.pos.Y < 0 or p1.pos.Y > currentSize.Y then p1.vel = Vector2.new(p1.vel.X, -p1.vel.Y) end
            p1.gui.Position = UDim2.fromOffset(p1.pos.X, p1.pos.Y)
            
            for j = i + 1, #particles do
                local p2 = particles[j]
                local dist = (p1.pos - p2.pos).Magnitude
                if dist < connectDistance then
                    table.insert(lines, pCreate("Frame", {
                        Parent = particleFrame, Size = UDim2.new(0, dist, 0, 2),
                        Position = UDim2.fromOffset((p1.pos.X + p2.pos.X) / 2, (p1.pos.Y + p2.pos.Y) / 2),
                        Rotation = math.deg(math.atan2(p2.pos.Y - p1.pos.Y, p2.pos.X - p1.pos.X)),
                        BackgroundColor3 = Theme["Color Theme"], BorderSizePixel = 0, ZIndex = 0,
                        BackgroundTransparency = 1 - (1 - dist / connectDistance) * 0.6,
                    }))
                end
            end
        end
    end)
end

-- ID: K2 - ATUALIZANDO O CONSTRUTOR MESTRE PARA INICIALIZAR A CONSTECAÇÃO
local OriginalNew_K = rareLib.new
function rareLib:new(Title)
    local Hub = OriginalNew_K(self, Title)

    Hub:__buildConstellation()

    return Hub
end

-- ID: K3 - O FIM DA LIB. RETORNANDO O OBJETO PRINCIPAL.
return rareLib
