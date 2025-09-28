-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V7 - A VERSÃO MINIMALISTA PERFEITA - by RARO XT & DRIP
-- [ ! ] - PARTE 1/20: A FUNDAÇÃO E O ARSENAL BÁSICO
-- ====================================================================================== --

-- ID: A1 - O MOLDE (A "CLASSE" RARELIB)
local rareLib = {}
rareLib.__index = rareLib

-- ID: A2 - ARSENAL DE SERVIÇOS
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- ID: A3 - FUNÇÃO DE CRIAÇÃO BÁSICA (A NOSSA FÁBRICA)
local function pCreate(instanceType, properties)
    local newInstance = Instance.new(instanceType)
    if properties then
        for prop, value in pairs(properties) do
            pcall(function() newInstance[prop] = value end)
        end
    end
    return newInstance
end

-- ID: A4 - FUNÇÃO DE ARRASTAR (MOBILE SOBERANO)
local function pMakeDrag(instance)
    local dragging, startPos, dragStart
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
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V7 - A VERSÃO MINIMALISTA PERFEITA - by RARO XT & DRIP
-- [ ! ] - PARTE 2/20: A JANELA, O CANVASGROUP E O DRAG
-- ====================================================================================== --

-- ID: B1 - O CONSTRUTOR MESTRE (:new)
function rareLib:new(Title)
    if CoreGui:FindFirstChild("RARE_LIB_UI") then CoreGui.RARE_LIB_UI:Destroy() end

    local Hub = setmetatable({}, rareLib)

    -- Configurações de Base
    Hub.Title = Title or "Rare Lib V7"
    Hub.Theme = {
        ["Color Hub BG"] = Color3.fromRGB(15, 15, 15), ["Color Panel BG"] = Color3.fromRGB(12, 12, 12),
        ["Color Stroke"] = Color3.fromRGB(40, 40, 40), ["Color Theme"] = Color3.fromRGB(139, 0, 0),
        ["Color Text"] = Color3.fromRGB(240, 240, 240), ["Color Dark Text"] = Color3.fromRGB(150, 150, 150)
    }
    Hub.Config = { UISize = {700, 450}, TabSize = 150 }
    Hub.Tabs, Hub.CurrentTab = {}, nil

    -- 1. Criação da UI Base
    Hub.MainGui = pCreate("ScreenGui", {Parent = CoreGui, Name = "RARE_LIB_UI", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    
    local Theme, Config = Hub.Theme, Hub.Config
    local UISizeX, UISizeY = unpack(Config.UISize)
    
    -- O MainFrame (Frame Principal, Pai de tudo)
    Hub.MainFrame = pCreate("Frame", {
        Parent = Hub.MainGui, Name = "Hub", Size = UDim2.fromOffset(UISizeX, UISizeY),
        Position = UDim2.new(0.5, -UISizeX/2, 0.5, -UISizeY/2), BackgroundColor3 = Theme["Color Hub BG"],
        BorderColor3 = Theme["Color Stroke"], BorderSizePixel = 2
    })
    pCreate("UICorner", {Parent = Hub.MainFrame, CornerRadius = UDim.new(0, 12)})
    pMakeDrag(Hub.MainFrame)

    -- CanvasGroup para a Animação de Entrada e Fade (ESSENCIAL)
    Hub.MainFrameGroup = pCreate("CanvasGroup", {Parent = Hub.MainFrame})
    
    -- Barra de Título
    local TitleBar = pCreate("Frame", {
        Parent = Hub.MainFrameGroup, Name = "TitleBar", Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Theme["Color Panel BG"], ZIndex = 2
    })
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
    pCreate("UICorner", {Parent = ToggleButton, CornerRadius = UDim.new(1, 0)})
    pCreate("UIStroke", {Parent = ToggleButton, Color = Color3.fromRGB(255, 255, 255)})
    ToggleButton.MouseButton1Click:Connect(function() Hub.MainFrame.Visible = not Hub.MainFrame.Visible end)
    pMakeDrag(ToggleButton)

    return Hub
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V7 - A VERSÃO MINIMALISTA PERFEITA - by RARO XT & DRIP
-- [ ! ] - PARTE 3/20: PAINÉIS INTERNOS E A CONSTELAÇÃO (SOLUÇÃO FINAL)
-- ====================================================================================== --

-- ID: C1 - FUNÇÃO "PRIVADA" PARA CONSTRUIR OS PAINÉIS
function rareLib:__buildPanels()
    local Theme = self.Theme
    local TabSize = self.Config.TabSize
    local Container = self.MainFrameGroup -- Todos os painéis são filhos do CanvasGroup

    -- O Fundo da Constelação (Camada 0)
    -- Isso garante que as partículas tenham um fundo escuro que não corta nas bordas.
    local Background = pCreate("Frame", {
        Parent = Container, Name = "Background", Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Theme["Color Hub BG"], BorderSizePixel = 0, ZIndex = 0
    })
    
    -- ID: C1.1 - A CONSTELAÇÃO (SEM CORTE)
    -- O Fim do Bug: A constelação agora é renderizada por cima do fundo escuro (ZIndex 1)
    local particleFrame = pCreate("Frame", {
        Parent = Background, Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, ZIndex = 1
    })

    local particles, lines = {}, {}
    local numParticles, connectDistance = 50, 120
    task.wait() 
    local frameSize = particleFrame.AbsoluteSize
    for i = 1, numParticles do
        local p = pCreate("Frame", {Parent=particleFrame, Size=UDim2.new(0,3,0,3), BackgroundColor3=Theme["Color Theme"], BorderSizePixel=0})
        pCreate("UICorner", {Parent=p, CornerRadius=UDim.new(1,0)})
        table.insert(particles, {gui=p, pos=Vector2.new(math.random(0, frameSize.X), math.random(0, frameSize.Y)), vel=Vector2.new(math.random(-20,20),math.random(-20,20))})
    end
    RunService.RenderStepped:Connect(function(dt)
        if not self.MainGui or not self.MainGui.Parent then return end
        for _,line in ipairs(lines) do line:Destroy() end; lines={}; local currentSize=particleFrame.AbsoluteSize; if currentSize.X==0 then return end
        for i,p1 in ipairs(particles) do p1.pos=p1.pos+p1.vel*dt; if p1.pos.X<0 or p1.pos.X>currentSize.X then p1.vel=Vector2.new(-p1.vel.X,p1.vel.Y) end; if p1.pos.Y<0 or p1.pos.Y>currentSize.Y then p1.vel=Vector2.new(p1.vel.X,-p1.vel.Y) end; p1.gui.Position=UDim2.fromOffset(p1.pos.X,p1.pos.Y)
            for j=i+1,#particles do local p2=particles[j]; local dist=(p1.pos-p2.pos).Magnitude; if dist<connectDistance then table.insert(lines,pCreate("Frame",{Parent=particleFrame, Size=UDim2.new(0,dist,0,2), Position=UDim2.fromOffset((p1.pos.X+p2.pos.X)/2,(p1.pos.Y+p2.pos.Y)/2), Rotation=math.deg(math.atan2(p2.pos.Y-p1.pos.Y,p2.pos.X-p1.pos.X)), BackgroundColor3=Theme["Color Theme"], BorderSizePixel=0, ZIndex=0, BackgroundTransparency=1-(1-dist/connectDistance)*0.6})) end end end
    end)
    
    -- O Container Geral que vai segurar os 3 painéis, posicionado abaixo da TitleBar.
    local PanelsContainer = pCreate("Frame", {
        Parent = Container,
        Name = "PanelsContainer",
        Size = UDim2.new(1, 0, 1, -30), Position = UDim2.new(0, 0, 0, 30),
        BackgroundTransparency = 1, ZIndex = 2 -- Garante que os painéis fiquem acima das partículas
    })

    pCreate("UIPadding", {Parent = PanelsContainer, PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10)})
    
    -- Painel de Navegação (Esquerda)
    self.NavContainer = pCreate("ScrollingFrame", {
        Parent = PanelsContainer, Name = "NavContainer", Size = UDim2.new(0, TabSize, 1, 0),
        BackgroundColor3 = Theme["Color Hub BG"], BorderSizePixel = 0, AutomaticCanvasSize = "Y",
        ScrollBarImageColor3 = Theme["Color Theme"], ScrollBarThickness = 6
    })
    pCreate("UICorner", {Parent = self.NavContainer, CornerRadius = UDim.new(0, 6)})
    pCreate("UIListLayout", {Parent = self.NavContainer, Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder})
    pCreate("UIPadding", {Parent = self.NavContainer, PaddingTop = UDim.new(0, 10)})
    
    -- Painel de Status (Direita)
    self.RightPanel = pCreate("Frame", {
        Parent = PanelsContainer, Name = "RightPanel", Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(1, -200, 0, 0), BackgroundColor3 = Theme["Color Panel BG"], BorderSizePixel = 0
    })
    pCreate("UICorner", {Parent = self.RightPanel, CornerRadius = UDim.new(0, 6)})
    pCreate("UIPadding", {Parent = self.RightPanel, PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)})

    -- Painel de Conteúdo (Centro)
    self.ContentPanel = pCreate("Frame", {
        Parent = PanelsContainer, Name = "ContentPanel", Size = UDim2.new(1, -(TabSize + 10 + 200), 1, 0),
        Position = UDim2.new(0, TabSize + 10, 0, 0), BackgroundColor3 = Theme["Color Hub BG"], BorderSizePixel = 0
    })
    pCreate("UICorner", {Parent = self.ContentPanel, CornerRadius = UDim.new(0, 6)})
end

-- ID: C2 - ATUALIZANDO O CONSTRUTOR MESTRE
local OriginalNew_C = rareLib.new
function rareLib:new(Title)
    local Hub = OriginalNew_C(self, Title)

    Hub:__buildPanels() -- Adiciona a construção dos painéis.

    return Hub
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V7 - A VERSÃO MINIMALISTA PERFEITA - by RARO XT & DRIP
-- [ ! ] - PARTE 4/20: A SALA DO TRONO
-- ====================================================================================== --

-- ID: D1 - FUNÇÃO "PRIVADA" PARA CONSTRUIR A FICHA DE STATUS
function rareLib:__buildStatusPanel()
    local Theme = self.Theme
    
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
-- [ ! ] - PARTE 6/20: BOTÕES E A BASE DE COMPONENTES
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
        Parent = Frame, Size = UDim2.new(0, 130, 0, 22), Position = UDim2.new(1, -135, 0.5, -11),
        BackgroundColor3 = Theme["Color Stroke"], Text = "", AutoButtonColor = false
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
-- [ ! ] - PARTE 11/20: SEPARADORES, TÍTULOS E LEGENDAS
-- ====================================================================================== --

-- ID: K1 - A API PÚBLICA PARA CRIAR SEPARADORES: Tab:AddSeparator()
function rareLib:AddSeparator(Title)
    local Theme = self.Theme
    
    local SeparatorFrame = pCreate("Frame", {
        Parent = self.Container, Name = "Separator", Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1, LayoutOrder = #self.Container:GetChildren() + 1
    })
    
    local Line = pCreate("Frame", {
        Parent = SeparatorFrame, Name = "Line", Size = UDim2.new(1, -20, 0, 1),
        Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme["Color Stroke"], BorderSizePixel = 0
    })
    
    pCreate("TextLabel", {
        Parent = SeparatorFrame, Name = "Title", Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X, Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
        Text = "  " .. Title .. "  ", -- Espaços para o fundo não colar no texto
        TextColor3 = Theme["Color Dark Text"], TextSize = 12, BackgroundColor3 = Theme["Color Hub BG"], ZIndex = 2
    })
    
    return { Frame = SeparatorFrame }
end

-- ID: K2 - A API PÚBLICA PARA CRIAR TÍTULOS/LEGENDAS (GRANDE)
function rareLib:AddTitle(Title)
    local Theme = self.Theme
    
    local TitleLabel = pCreate("TextLabel", {
        Parent = self.Container, Name = "Title", Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1, LayoutOrder = #self.Container:GetChildren() + 1,
        Font = Enum.Font.GothamBlack, Text = Title,
        TextColor3 = Theme["Color Theme"], TextSize = 20, TextXAlignment = Enum.TextXAlignment.Left
    })
    
    pCreate("UIPadding", {Parent = TitleLabel, PaddingLeft = UDim.new(0, 10)})
    
    return { Label = TitleLabel }
end

-- ID: K3 - A API PÚBLICA PARA CRIAR LEGENDAS (PEQUENA)
function rareLib:AddLabel(Text)
    local Theme = self.Theme
    
    local Label = pCreate("TextLabel", {
        Parent = self.Container, Name = "Label", Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1, LayoutOrder = #self.Container:GetChildren() + 1,
        Font = Enum.Font.Gotham, Text = Text,
        TextColor3 = Theme["Color Dark Text"], TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left
    })
    
    pCreate("UIPadding", {Parent = Label, PaddingLeft = UDim.new(0, 15)})
    
    return { Label = Label }
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V7 - A VERSÃO MINIMALISTA PERFEITA - by RARO XT & DRIP
-- [ ! ] - PARTE 12/20: CONSTELAÇÃO, ANIMAÇÃO E PACOTE FINAL
-- ====================================================================================== --

-- ID: L1 - FUNÇÃO "PRIVADA" PARA CONSTRUIR O EFEITO DE PARTÍCULAS
function rareLib:__buildConstellation()
    local Theme = self.Theme
    
    -- O Fim do Bug: ZIndex 0 e Sem ClipsDescendants no MainFrame.
    local particleFrame = pCreate("Frame", {
        Parent = self.MainFrame, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 0
    })
    
    local particles, lines = {}, {}
    local numParticles, connectDistance = 50, 120

    task.wait() 
    local frameSize = particleFrame.AbsoluteSize

    for i = 1, numParticles do
        local p = pCreate("Frame", {
            Parent = particleFrame, Size = UDim2.new(0, 3, 0, 3), BackgroundColor3 = Theme["Color Theme"], BorderSizePixel = 0
        })
        pCreate("UICorner", {Parent = p, CornerRadius = UDim.new(1, 0)})
        table.insert(particles, {gui=p, pos=Vector2.new(math.random(0, frameSize.X), math.random(0, frameSize.Y)), vel=Vector2.new(math.random(-20,20),math.random(-20,20))})
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

-- ID: L2 - FUNÇÃO "PRIVADA" PARA CRIAR A ANIMAÇÃO DE ENTRADA
function rareLib:__buildIntroAnimation()
    self.MainFrameGroup.GroupTransparency = 1 -- Esconde a UI principal
    
    local LogoText = pCreate("TextLabel", {
        Parent = self.MainGui, Name = "IntroLogo", Text = "RARE HUB", Font = Enum.Font.GothamBlack,
        TextSize = 80, TextColor3 = self.Theme["Color Text"], Position = UDim2.new(0.5, 0, -0.2, 0),
        AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, ZIndex = 100
    })
    
    pCreate("TextStroke", {Parent = LogoText, Color = self.Theme["Color Theme"], Thickness = 2, Transparency = 0})

    -- Animações
    local tweenIn = TweenService:Create(LogoText, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.5, 0)})
    local tweenOut = TweenService:Create(LogoText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, 0, -0.2, 0), TextTransparency = 1})
    local tweenUI = TweenService:Create(self.MainFrameGroup, TweenInfo.new(0.5), {GroupTransparency = 0})

    -- Sequência de execução
    task.spawn(function()
        tweenIn:Play()
        tweenIn.Completed:Wait()
        task.wait(0.7)
        tweenOut:Play()
        tweenOut.Completed:Wait()
        LogoText:Destroy()
        tweenUI:Play()
    end)
end

-- ID: L3 - ATUALIZANDO O CONSTRUTOR MESTRE PARA CONCLUIR A INICIALIZAÇÃO
local OriginalNew_K = rareLib.new
function rareLib:new(Title)
    local Hub = OriginalNew_K(self, Title)
    
    -- Ordem FINAL de construção
    Hub:__buildStatusPanel()
    Hub:__buildConstellation()
    Hub:__buildIntroAnimation()

    return Hub
end

-- ID: L4 - O FIM DA LIB. RETORNANDO O OBJETO PRINCIPAL.
return rareLib
