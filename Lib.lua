    return Hub
end-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V7 - O LEGADO DO DRIP (SIMPLIFICADO) - by RARO XT & DRIP
-- [ ! ] - PARTE 1/20: A FUNDAÇÃO INABALÁVEL (ALICERCE V7)
-- ====================================================================================== --

-- ID: A1 - O MOLDE (A "CLASSE" RARELIB)
local rareLib = {}
rareLib.__index = rareLib
rareLib.Tab = {}
rareLib.Tab.__index = rareLib 

-- ID: A2 - ARSENAL DE SERVIÇOS
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local PlayerGui = Players.LocalPlayer.PlayerGui 

-- ID: A3 - FUNÇÃO DE CRIAÇÃO BÁSICA (NOSSA FÁBRICA)
local function pCreate(instanceType, properties)
    local newInstance = Instance.new(instanceType)
    if properties then
        for prop, value in pairs(properties) do
            pcall(function() newInstance[prop] = value end) 
        end
    end
    return newInstance
end
rareLib.pCreate = pCreate

-- ID: A4 - FUNÇÃO DE ARRASTAR (MOBILE SOBERANO)
local function pMakeDrag(instance, dragHandle)
    local isDragging, dragStart, startPos = false, Vector2.new(), UDim2.new()
    local Handle = dragHandle or instance 
    
    Handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging, startPos, dragStart = true, instance.Position, input.Position
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            instance.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            isDragging = false 
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        end
    end)
end
rareLib.pMakeDrag = pMakeDrag

-- ID: A5 - FUNÇÃO P/ CHAMADA SEGURA (pcall SAGRADO)
function rareLib:pcall(...)
    return pcall(...)
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V7 - O LEGADO DO DRIP (SIMPLIFICADO) - by RARO XT & DRIP
-- [ ! ] - PARTE 2/20: CONSTRUTOR E JANELA PRINCIPAL
-- ====================================================================================== --

-- ID: B1 - TEMA E CONFIGURAÇÕES DEFAULTS
local DefaultTheme = {
    ["Color Hub BG"] = Color3.fromRGB(15, 15, 15),
    ["Color Panel BG"] = Color3.fromRGB(24, 24, 24),
    ["Color Stroke"] = Color3.fromRGB(40, 40, 40),
    ["Color Theme"] = Color3.fromRGB(0, 150, 255), -- Azul padrão para o tema
    ["Color Text"] = Color3.fromRGB(240, 240, 240),
    ["Color Dark Text"] = Color3.fromRGB(150, 150, 150)
}
local DefaultConfig = {
    Title = "RARE LIB V7",
    UISize = {650, 450}, 
    TabSize = 160,
    Padding = 8,
    CornerRadius = 8, 
}


-- ID: B2 - O CONSTRUTOR MESTRE (:new)
-- Usa Tabela Options (MANDAMENTO DA API options)
function rareLib:new(options)
    local self = setmetatable({}, rareLib)
    
    -- Juntar Configs/Theme do usuário com os defaults
    self.Options = options or {}
    self.Config = setmetatable(self.Options.Config or {}, {__index = DefaultConfig})
    self.Theme = setmetatable(self.Options.Theme or {}, {__index = DefaultTheme})
    
    -- Cleanup (Reaproveitado da V6)
    if PlayerGui:FindFirstChild("RARE_LIB_UI") then PlayerGui.RARE_LIB_UI:Destroy() end
    
    -- Propriedades internas
    self.Tabs, self.CurrentTab = {}, nil
    
    -- O ScreenGui que segura tudo
    self.MainGui = self.pCreate("ScreenGui", {Parent = PlayerGui, Name = "RARE_LIB_UI", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    
    -- O MainFrame (A Janela Principal)
    local UISizeX, UISizeY = unpack(self.Config.UISize)
    self.MainFrame = self.pCreate("Frame", {
        Parent = self.MainGui, Name = "Hub", Size = UDim2.fromOffset(UISizeX, UISizeY),
        Position = UDim2.new(0.5, -UISizeX/2, 0.5, -UISizeY/2), 
        BackgroundColor3 = self.Theme["Color Panel BG"],
        BorderColor3 = self.Theme["Color Stroke"], BorderSizePixel = 1,
        ClipsDescendants = false, -- CORREÇÃO DO ERRO VISUAL #1 (CONSTELAÇÃO): Não pode cortar as partículas!
        ZIndex = 5
    })
    
    -- Cantos Arredondados do Hub (UI ARREDONDADA)
    self.pCreate("UICorner", {Parent = self.MainFrame, CornerRadius = UDim.new(0, self.Config.CornerRadius)})
    
    -- TitleBar (A Alça de Arraste)
    local TitleBar = self.pCreate("Frame", {
        Name = "TitleBar", Size = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = self.Theme["Color Hub BG"], 
        Parent = self.MainFrame, ZIndex = 6
    })
    
    -- Arredonda a TitleBar para acompanhar o MainFrame
    self.pCreate("UICorner", {Parent = TitleBar, CornerRadius = UDim.new(0, self.Config.CornerRadius)})
    
    -- Título
    self.pCreate("TextLabel", {
        Parent = TitleBar, Name = "TitleLabel", Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = self.Config.Title or self.Options.Title,
        TextColor3 = self.Theme["Color Text"], TextSize = 18, ZIndex = 7
    })

    -- Tornar a TitleBar arrastável (pMakeDrag da Parte 1)
    self.pMakeDrag(self.MainFrame, TitleBar) 
    
    -- Removido: CanvasGroup (Obrigado pela simplicidade, Chefe!)
    
    -- Botão flutuante para abrir/fechar (UX)
    local ToggleButton = self.pCreate("TextButton", {
        Parent = self.MainGui, Size = UDim2.new(0, 40, 0, 40), Position = UDim2.new(0, 15, 0.5, -20),
        BackgroundColor3 = self.Theme["Color Theme"], Text = "愛", Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 24, ZIndex = 100
    })
    self.pCreate("UICorner", {Parent = ToggleButton, CornerRadius = UDim.new(1, 0)})
    self.pCreate("UIStroke", {Parent = ToggleButton, Color = Color3.fromRGB(255, 255, 255), Thickness = 1})
    ToggleButton.MouseButton1Click:Connect(function() 
        self.MainFrame.Visible = not self.MainFrame.Visible 
    end)
    self.pMakeDrag(ToggleButton)

    return self
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V7 - O LEGADO DO DRIP (SIMPLIFICADO) - by RARO XT & DRIP
-- [ ! ] - PARTE 3/20: CONSTELAÇÃO (O EFEITO DRIP) E ATUALIZAÇÃO DO CONSTRUTOR
-- ====================================================================================== --

-- ID: C1 - FUNÇÃO "PRIVADA" PARA CONSTRUIR O EFEITO DE PARTÍCULAS
function rareLib:__buildConstellation()
    local Theme = self.Theme
    
    local particleFrame = self.pCreate("Frame", {
        Parent = self.MainFrame, 
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, 
        ZIndex = 0 -- ESSENCIAL: Fica atrás de absolutamente tudo (REQUERIMENTO)
    })
    
    local particles, lines = {}, {}
    local numParticles, connectDistance = 40, 150 

    task.wait() 
    local frameSize = particleFrame.AbsoluteSize
    if frameSize.X == 0 then return end

    for i = 1, numParticles do
        local p = self.pCreate("Frame", {
            Parent = particleFrame, Size = UDim2.new(0, 3, 0, 3),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255), 
            BackgroundTransparency = 0.3,
            BorderSizePixel = 0, ZIndex = 0
        })
        self.pCreate("UICorner", {Parent = p, CornerRadius = UDim.new(1, 0)})
        table.insert(particles, {
            gui = p,
            pos = Vector2.new(math.random(0, frameSize.X), math.random(0, frameSize.Y)),
            vel = Vector2.new(math.random() * 2 - 1, math.random() * 2 - 1) * 15
        })
    end

    local connection = RunService.RenderStepped:Connect(function(dt)
        if not self.MainGui or not self.MainGui.Parent then connection:Disconnect() return end
        
        -- Destrói as linhas antigas para redesenhar
        for _, line in ipairs(lines) do line:Destroy() end; lines = {}
        
        local currentSize = particleFrame.AbsoluteSize
        if currentSize.X == 0 then return end

        for i, p1 in ipairs(particles) do
            -- Atualiza posição e bordas
            p1.pos = p1.pos + p1.vel * dt
            if p1.pos.X < 0 or p1.pos.X > currentSize.X then p1.vel = Vector2.new(-p1.vel.X, p1.vel.Y) end
            if p1.pos.Y < 0 or p1.pos.Y > currentSize.Y then p1.vel = Vector2.new(p1.vel.X, -p1.vel.Y) end
            p1.gui.Position = UDim2.fromOffset(p1.pos.X, p1.pos.Y)
            
            for j = i + 1, #particles do
                local p2 = particles[j]
                local dist = (p1.pos - p2.pos).Magnitude
                if dist < connectDistance then
                    -- Cria a linha
                    local alpha = 1 - dist / connectDistance
                    table.insert(lines, self.pCreate("Frame", {
                        Parent = particleFrame, Size = UDim2.new(0, dist, 0, 1),
                        Position = UDim2.fromOffset((p1.pos.X + p2.pos.X) / 2, (p1.pos.Y + p2.pos.Y) / 2),
                        Rotation = math.deg(math.atan2(p2.pos.Y - p1.pos.Y, p2.pos.X - p1.pos.X)),
                        BackgroundColor3 = Theme["Color Theme"], 
                        BackgroundTransparency = 1 - alpha * 0.5, 
                        BorderSizePixel = 0, ZIndex = 0
                    }))
                end
            end
        end
    end)
end

-- ID: C2 - ATUALIZANDO O CONSTRUTOR MESTRE
local OriginalNew_C = rareLib.new
function rareLib:new(options)
    local Hub = OriginalNew_C(self, options)

    Hub:__buildConstellation()

    return Hub
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V7 - O LEGADO DO DRIP (SIMPLIFICADO) - by RARO XT & DRIP
-- [ ! ] - PARTE 4/20: DESENHANDO OS PAINÉIS INTERNOS (CLEAN DESIGN)
-- ====================================================================================== --

-- ID: D1 - FUNÇÃO "PRIVADA" PARA CONSTRUIR OS PAINÉIS INTERNOS
function rareLib:__buildPanels()
    local Theme = self.Theme
    local Config = self.Config
    
    -- 1. O Container Geral dentro do MainFrame
    local TitleBarHeight = 28 -- Altura da TitleBar (Parte 2)
    local PanelsContainer = self.pCreate("Frame", {
        Parent = self.MainFrame, 
        Name = "PanelsContainer",
        Size = UDim2.new(1, 0, 1, -TitleBarHeight), -- Ocupa o MainFrame menos a TitleBar
        Position = UDim2.new(0, 0, 0, TitleBarHeight),
        BackgroundTransparency = 1,
        ZIndex = 8
    })

    -- Padding externo para dar um respiro total (Minimalismo).
    self.pCreate("UIPadding", {
        Parent = PanelsContainer,
        PaddingLeft = UDim.new(0, Config.Padding),
        PaddingRight = UDim.new(0, Config.Padding),
        PaddingTop = UDim.new(0, Config.Padding),
        PaddingBottom = UDim.new(0, Config.Padding)
    })
    
    -- A. Painel de Navegação (Esquerda) - Onde os botões de Tab ficam
    local NavContainerHolder = self.pCreate("Frame", {
        Parent = PanelsContainer, Name = "NavContainerHolder", 
        Size = UDim2.new(0, Config.TabSize, 1, 0),
        BackgroundColor3 = Theme["Color Hub BG"], -- Fundo mais escuro para o painel lateral
        BorderSizePixel = 0, 
        ZIndex = 9
    })
    self.pCreate("UICorner", {Parent = NavContainerHolder, CornerRadius = UDim.new(0, Config.CornerRadius)})
    
    -- O ScrollingFrame que contém os botões de Tab
    self.NavContainer = self.pCreate("ScrollingFrame", {
        Parent = NavContainerHolder, Name = "NavScroll", 
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        AutomaticCanvasSize = "Y", ScrollingDirection = "Y",
        ScrollBarImageColor3 = Theme["Color Theme"], ScrollBarThickness = 4 
    })
    
    -- Layout para os botões de Tab
    self.pCreate("UIListLayout", {
        Parent = self.NavContainer, 
        Padding = UDim.new(0, 5), -- Espaçamento entre os botões
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center
    })

    self.pCreate("UIPadding", {
        Parent = self.NavContainer, 
        PaddingTop = UDim.new(0, Config.Padding),
        PaddingBottom = UDim.new(0, Config.Padding),
    })


    -- B. Painel de Conteúdo (Direita) - Onde os componentes ficam
    local ContentPanelHolder = self.pCreate("Frame", {
        Parent = PanelsContainer, Name = "ContentPanelHolder", 
        -- Calcula o tamanho: 100% - TabSize - Padding total horizontal (Config.Padding)
        Size = UDim2.new(1, -(Config.TabSize + Config.Padding), 1, 0), 
        -- Posição: TabSize + Padding
        Position = UDim2.new(0, Config.TabSize + Config.Padding, 0, 0), 
        BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 9
    })
    
    -- Container interno que vai segurar as páginas das Tabs
    self.PagesContainer = self.pCreate("Frame", {
        Parent = ContentPanelHolder, Name = "PagesContainer",
        Size = UDim2.new(1, 0, 1, 0), 
        BackgroundColor3 = Theme["Color Hub BG"], -- Cor do painel de conteúdo
        ClipsDescendants = true, -- Aqui PODE cortar o conteúdo, mas não o Constellation (ZIndex=0)
        ZIndex = 10
    })
    self.pCreate("UICorner", {Parent = self.PagesContainer, CornerRadius = UDim.new(0, Config.CornerRadius)})
    
end

-- ID: D2 - ATUALIZANDO O CONSTRUTOR MESTRE
local OriginalNew_D = rareLib.new
function rareLib:new(options)
    local Hub = OriginalNew_D(self, options)

    Hub:__buildPanels() 

    return Hub
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V7 - O LEGADO DO DRIP (SIMPLIFICADO) - by RARO XT & DRIP
-- [ ! ] - PARTE 5/20: CRIAÇÃO E LÓGICA DAS ABAS (TABS)
-- ====================================================================================== --

-- ID: E1 - A API PÚBLICA PARA CRIAR ABAS: Hub:CreateTab(options)
function rareLib:CreateTab(options)
    local options = options or {}
    local TName = options.Title or "Nova Tab" 
    
    local Theme = self.Theme
    local Config = self.Config
    
    -- O objeto Tab. Herda de rareLib.Tab, que tem __index = rareLib (Hub)
    local Tab = setmetatable({
        Name = TName,
        ParentHub = self, 
    }, rareLib.Tab) 
    
    -- 1. Botão de Navegação (NavContainer)
    Tab.Button = self.pCreate("TextButton", {
        Parent = self.NavContainer, Name = TName .. "Button", 
        Text = "  " .. TName,
        TextXAlignment = Enum.TextXAlignment.Left, 
        Font = Enum.Font.GothamBold, TextSize = 15,
        TextColor3 = Theme["Color Dark Text"], 
        Size = UDim2.new(1, -Config.Padding, 0, 32), 
        Position = UDim2.new(0.5, 0, 0, 0), AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Theme["Color Hub BG"], 
        LayoutOrder = #self.Tabs + 1, 
        AutoButtonColor = false,
        ZIndex = 11
    })
    
    -- UI Visual do Botão (UI ARREDONDADA)
    self.pCreate("UICorner", {Parent = Tab.Button, CornerRadius = UDim.new(0, Config.CornerRadius - 2)})
    
    -- 2. Container de Conteúdo (PagesContainer)
    Tab.Container = self.pCreate("ScrollingFrame", {
        Parent = self.PagesContainer, Name = TName .. "_Container", 
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        AutomaticCanvasSize = "Y", ScrollingDirection = "Y",
        ScrollBarImageColor3 = Theme["Color Theme"], ScrollBarThickness = 4,
        Visible = false,
        ZIndex = 12
    })
    
    -- UI Layout dos Componentes (Minimalismo e Espaçamento)
    self.pCreate("UIListLayout", {
        Parent = Tab.Container, 
        Padding = UDim.new(0, Config.Padding), 
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center
    })
    
    self.pCreate("UIPadding", {
        Parent = Tab.Container, 
        PaddingTop = UDim.new(0, Config.Padding), 
        PaddingBottom = UDim.new(0, Config.Padding),
        PaddingLeft = UDim.new(0, Config.Padding),
        PaddingRight = UDim.new(0, Config.Padding),
    })

    -- 3. Lógica de Seleção
    local function SelectTab()
        if self.CurrentTab == Tab then return end
        
        -- Desativa a Tab antiga
        if self.CurrentTab then
            self.CurrentTab.Container.Visible = false
            TweenService:Create(self.CurrentTab.Button, TweenInfo.new(0.2), {
                TextColor3 = Theme["Color Dark Text"], 
                BackgroundColor3 = Theme["Color Hub BG"]
            }):Play()
        end
        
        -- Ativa a nova Tab
        Tab.Container.Visible = true
        self.CurrentTab = Tab
        TweenService:Create(Tab.Button, TweenInfo.new(0.2), {
            TextColor3 = Theme["Color Theme"], 
            BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        }):Play()
    end

    -- 4. Conexão (MOBILE SOBERANO)
    Tab.Button.MouseButton1Click:Connect(SelectTab)
    table.insert(self.Tabs, Tab)
    
    -- Seleciona a primeira Tab por padrão
    if #self.Tabs == 1 then SelectTab() end
    
    return Tab
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V7 - O LEGADO DO DRIP (SIMPLIFICADO) - by RARO XT & DRIP
-- [ ! ] - PARTE 6/20: NOVAS FUNÇÕES DE UTILIDADE (TÍTULOS, LABELS, SEPARADORES)
-- ====================================================================================== --

-- ID: F1 - NOVIDADE: Tab:AddSeparator(options)
-- Cria uma linha divisória com ou sem texto centralizado
function rareLib:AddSeparator(options)
    local options = options or {}
    local Title = options.Title or ""
    local Theme = self.ParentHub.Theme
    
    local Frame = self.pCreate("Frame", {
        Parent = self.Container, Name = "Separator",
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        LayoutOrder = #self.Container:GetChildren() + 1
    })
    
    -- Se o título for vazio, a linha ocupa 100% da largura.
    if Title == "" then
        self.pCreate("Frame", {
            Parent = Frame, Size = UDim2.new(1, 0, 0, 1),
            Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Theme["Color Stroke"], ZIndex = 1
        })
    else
        -- Linha da esquerda (calculada para parar no texto)
        self.pCreate("Frame", {
            Parent = Frame, Size = UDim2.new(0.5, -((#Title*4)+20), 0, 1), 
            Position = UDim2.new(0, 0, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Theme["Color Stroke"], ZIndex = 1
        })
        
        -- Linha da direita
        self.pCreate("Frame", {
            Parent = Frame, Size = UDim2.new(0.5, -((#Title*4)+20), 0, 1),
            Position = UDim2.new(1, 0, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = Theme["Color Stroke"], ZIndex = 1
        })
        
        -- Título centralizado
        self.pCreate("TextLabel", {
            Parent = Frame, Size = UDim2.new(0, #Title*8, 1, 0), 
            Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = Title,
            TextColor3 = Theme["Color Dark Text"], TextSize = 12, ZIndex = 2
        })
    end
    
    return { Frame = Frame }
end


-- ID: F2 - NOVIDADE: Tab:AddTitle(options)
-- Título Grande (Header) para seções
function rareLib:AddTitle(options)
    local options = options or {}
    local Title = options.Title or "Título Grande"
    local Theme = self.ParentHub.Theme

    local Label = self.pCreate("TextLabel", {
        Parent = self.Container, Name = "HeaderTitle",
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = Title,
        TextColor3 = Theme["Color Text"], TextSize = 18, 
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = #self.Container:GetChildren() + 1
    })

    return { Label = Label }
end


-- ID: F3 - NOVIDADE: Tab:AddLabel(options)
-- Texto pequeno (Legenda) para informações adicionais
function rareLib:AddLabel(options)
    local options = options or {}
    local Text = options.Text or "Legenda/Texto Pequeno"
    local Theme = self.ParentHub.Theme

    local Label = self.pCreate("TextLabel", {
        Parent = self.Container, Name = "SmallLabel",
        Size = UDim2.new(1, 0, 0, 16),
        BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = Text,
        TextColor3 = Theme["Color Dark Text"], TextSize = 11, 
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = #self.Container:GetChildren() + 1
    })

    return { Label = Label }
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V7 - O LEGADO DO DRIP (SIMPLIFICADO) - by RARO XT & DRIP
-- [ ! ] - PARTE 7/20: O MOLDE UNIVERSAL DOS COMPONENTES (OPÇÃO FRAME)
-- ====================================================================================== --

-- ID: G1 - A BASE VISUAL DOS COMPONENTES (FRAME DE OPÇÃO)
-- Função privada que cria o "molde" visual para todos os componentes.
function rareLib:__createOptionFrame(options)
    local options = options or {}
    local Theme = self.ParentHub.Theme 
    local Config = self.ParentHub.Config 
    local ParentContainer = self.Container 

    -- 1. Frame Principal (Molde)
    local Frame = self.pCreate("Frame", {
        Parent = ParentContainer, Name = "Option",
        Size = UDim2.new(1, 0, 0, 45), -- Altura fixa (Minimalismo)
        BackgroundColor3 = Theme["Color Panel BG"], 
        LayoutOrder = #ParentContainer:GetChildren() + 1,
        ClipsDescendants = false -- ESSENCIAL: Permite que o Knob do Toggle não seja cortado (CORREÇÃO DE ERRO ANTIGO)
    })
    
    -- 2. Cantos Arredondados (UI ARREDONDADA)
    self.pCreate("UICorner", {Parent = Frame, CornerRadius = UDim.new(0, Config.CornerRadius - 2)}) 
    
    -- 3. Container para o Conteúdo (Texto + Controlo)
    local MainContainer = self.pCreate("Frame", {
        Parent = Frame, Name = "MainContainer",
        Size = UDim2.new(1, 0, 1, 0), 
        BackgroundTransparency = 1,
    })

    -- 4. Padding interno
    self.pCreate("UIPadding", {
        Parent = MainContainer,
        PaddingLeft = UDim.new(0, Config.Padding * 1.5), 
        PaddingRight = UDim.new(0, Config.Padding * 1.5),
    })

    -- 5. Container para o Texto (Ocupa o espaço à esquerda)
    local TextContainer = self.pCreate("Frame", {
        Parent = MainContainer, Name = "TextContainer",
        Size = UDim2.new(1, -(options.RightSideWidth or 0), 1, 0), -- Desconta a área reservada para o controlo
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
    })
    
    -- 6. Título (Alinhamento Perfeito)
    self.pCreate("TextLabel", {
        Parent = TextContainer, Name = "Title", 
        Size = UDim2.new(1, 0, 0.5, 0), Position = UDim2.new(0, 0, 0, -2), 
        AnchorPoint = Vector2.new(0, 0),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = options.Title or "Opção",
        TextColor3 = Theme["Color Text"], TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
    })

    -- 7. Descrição/Legenda
    self.pCreate("TextLabel", {
        Parent = TextContainer, Name = "Desc",
        Size = UDim2.new(1, 0, 0.5, 0), Position = UDim2.new(0, 0, 0.5, 2), 
        AnchorPoint = Vector2.new(0, 0),
        BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = options.Desc or "",
        TextColor3 = Theme["Color Dark Text"], TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
        Visible = options.Desc and #options.Desc > 0
    })

    -- Retorna o Frame principal e o MainContainer para que o componente insira o controlo
    return Frame, MainContainer
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V7 - O LEGADO DO DRIP (SIMPLIFICADO) - by RARO XT & DRIP
-- [ ! ] - PARTE 8/20: BOTÃO (ADD BUTTON)
-- ====================================================================================== --

-- ID: H1 - A API PÚBLICA PARA CRIAR BOTÕES: Tab:AddButton({...})
function rareLib:AddButton(options)
    local options = options or {}
    options.RightSideWidth = options.RightSideWidth or 30 -- Largura reservada para o ícone
    local Theme = self.ParentHub.Theme
    
    -- Usa o nosso Molde Universal (Parte 7)
    local Frame, MainContainer = self:__createOptionFrame(options)
    
    -- 1. Ícone/Sinalizador de Ação
    self.pCreate("ImageLabel", {
        Parent = MainContainer, Image = "rbxassetid://10709791437", -- Seta de ação
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(1, -options.RightSideWidth + 7, 0.5, 0), 
        AnchorPoint = Vector2.new(0, 0.5), 
        BackgroundTransparency = 1, ZIndex = 2
    })
    
    -- 2. Botão de Overlay (Área clicável)
    local Button = self.pCreate("TextButton", {
        Parent = Frame, Size = UDim2.new(1, 0, 1, 0), 
        BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
        ZIndex = 3
    })
    
    -- 3. Lógica do Click (MANDAMENTO DO pcall SAGRADO)
    Button.MouseButton1Click:Connect(function()
        -- 3.1. Chamada Segura do Callback
        if options.Callback then
            self:pcall(options.Callback) 
        end
        
        -- 3.2. Animação de Click (Feedback visual clean)
        local originalColor = Frame.BackgroundColor3
        TweenService:Create(Frame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
        task.wait(0.1)
        TweenService:Create(Frame, TweenInfo.new(0.1), {BackgroundColor3 = originalColor}):Play()
    end)

    local API = {}
    API.Frame = Frame
    API.Button = Button
    
    return API
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V7 - O LEGADO DO DRIP (SIMPLIFICADO) - by RARO XT & DRIP
-- [ ! ] - PARTE 9/20: TOGGLES (ADD TOGGLE) - CORREÇÃO DO KNOB
-- ====================================================================================== --

-- ID: I1 - A API PÚBLICA PARA CRIAR TOGGLES: Tab:AddToggle({...})
function rareLib:AddToggle(options)
    local options = options or {}
    options.RightSideWidth = options.RightSideWidth or 40 -- Largura reservada para o switch
    local Theme = self.ParentHub.Theme
    local state = options.Default or false
    
    -- Usa o nosso Molde Universal (Parte 7)
    local Frame, MainContainer = self:__createOptionFrame(options)
    
    -- 1. Botão/Barra do Switch
    local ToggleButton = self.pCreate("Frame", {
        Parent = MainContainer, Name = "Switch", 
        Size = UDim2.new(0, 32, 0, 18), 
        Position = UDim2.new(1, -options.RightSideWidth + 4, 0.5, 0), -- 4px de padding
        AnchorPoint = Vector2.new(0, 0.5), 
        BackgroundColor3 = Theme["Color Stroke"],
        ZIndex = 2
    })
    self.pCreate("UICorner", {Parent = ToggleButton, CornerRadius = UDim.new(1, 0)})
    
    -- 2. Knob (A Bolinha)
    local KnobSize = 14
    local Padding = 2 -- Espaçamento interno (2px de cada lado)
    
    local Knob = self.pCreate("Frame", {
        Parent = ToggleButton, Name = "Knob", 
        Size = UDim2.new(0, KnobSize, 0, KnobSize),
        -- SOLUÇÃO DEFINITIVA PARA O ERRO VISUAL #2:
        AnchorPoint = Vector2.new(0.5, 0.5), 
        Position = UDim2.new(0, KnobSize/2 + Padding, 0.5, 0), -- Posição INICIAL: Padding + metade do Knob
        BackgroundColor3 = Theme["Color Dark Text"], 
        BorderSizePixel = 0,
        ZIndex = 3
    })
    self.pCreate("UICorner", {Parent = Knob, CornerRadius = UDim.new(1, 0)})
    
    -- 3. Função de Atualização
    local function UpdateKnob(newState, isInstant)
        state = newState
        
        -- Posição FINAL: Largura do ToggleButton (32) - Padding (2) - metade do Knob (7) = 23
        local targetX = 32 - KnobSize/2 - Padding
        
        local targetPos = newState and UDim2.new(0, targetX, 0.5, 0) or UDim2.new(0, KnobSize/2 + Padding, 0.5, 0)
        local targetColor = newState and Theme["Color Theme"] or Theme["Color Dark Text"]
        local targetBGColor = newState and Color3.fromRGB(80, 0, 0) or Theme["Color Stroke"] 
        
        if isInstant then
            Knob.Position = targetPos
            Knob.BackgroundColor3 = targetColor
            ToggleButton.BackgroundColor3 = targetBGColor
        else
            TweenService:Create(Knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = targetPos, BackgroundColor3 = targetColor}):Play()
            TweenService:Create(ToggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = targetBGColor}):Play()
        end
    end
    
    -- 4. Lógica do Click (MOBILE SOBERANO e pcall SAGRADO)
    local ToggleClickFrame = self.pCreate("TextButton", {
        Parent = ToggleButton, Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
        ZIndex = 4
    })
    
    ToggleClickFrame.MouseButton1Click:Connect(function()
        local newState = not state
        UpdateKnob(newState)
        
        -- MANDAMENTO DO pcall SAGRADO
        self:pcall(options.Callback, newState) 
    end)
    
    -- 5. Inicialização
    UpdateKnob(state, true)
    
    -- 6. API
    local API = {}
    API.SetState = function(newState) 
        if newState ~= state then
            UpdateKnob(newState)
            self:pcall(options.Callback, newState)
        end
    end
    API.GetState = function() return state end

    return API
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V7 - O LEGADO DO DRIP (SIMPLIFICADO) - by RARO XT & DRIP
-- [ ! ] - PARTE 10/20: SLIDERS (ADD SLIDER)
-- ====================================================================================== --

-- ID: J1 - A API PÚBLICA PARA CRIAR SLIDERS: Tab:AddSlider({...})
function rareLib:AddSlider(options)
    local options = options or {}
    options.RightSideWidth = options.RightSideWidth or 120 -- Largura reservada para a barra e o valor
    local Theme = self.ParentHub.Theme
    local Min, Max = options.Min or 0, options.Max or 100
    local Default = math.clamp(options.Default or 0, Min, Max)
    
    -- Usa o nosso Molde Universal (Parte 7)
    local Frame, MainContainer = self:__createOptionFrame(options)
    local CurrentValue = Default
    
    -- 1. Holder da Barra e do Valor
    local SliderHolder = self.pCreate("Frame", {
        Parent = MainContainer, Name = "SliderHolder", 
        Size = UDim2.new(0, options.RightSideWidth - 4, 0, 20),
        Position = UDim2.new(1, -options.RightSideWidth + 4, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1,
        ZIndex = 2
    })

    -- 2. Label do Valor (Fica à direita)
    local ValueLabel = self.pCreate("TextLabel", {
        Parent = SliderHolder, Name = "ValueLabel", Text = tostring(math.floor(CurrentValue)),
        Size = UDim2.new(0, 30, 1, 0), Position = UDim2.new(1, -30, 0, 0), AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextColor3 = Theme["Color Text"], TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 3
    })
    
    -- 3. Barra Principal (Fica à esquerda do ValueLabel)
    local BarWidth = options.RightSideWidth - 30 - 4 -- Largura total - largura do valor - espaço
    local SliderBar = self.pCreate("Frame", {
        Parent = SliderHolder, Name = "SliderBar", BackgroundColor3 = Theme["Color Stroke"],
        Size = UDim2.new(0, BarWidth, 0, 6), Position = UDim2.new(0, 0, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5),
        ZIndex = 3
    })
    self.pCreate("UICorner", {Parent = SliderBar, CornerRadius = UDim.new(1, 0)})

    -- 4. Indicador de Progresso (Cor Tema)
    local Indicator = self.pCreate("Frame", {
        Parent = SliderBar, Name = "Indicator", BackgroundColor3 = Theme["Color Theme"],
        Size = UDim2.fromScale(0, 1), BorderSizePixel = 0, ZIndex = 4
    })
    self.pCreate("UICorner", {Parent = Indicator, CornerRadius = UDim.new(1, 0)})

    -- 5. Knob (O Puxador)
    local KnobSize = 14
    local Knob = self.pCreate("Frame", {
        Parent = SliderBar, Name = "Knob", Size = UDim2.new(0, KnobSize, 0, KnobSize),
        BackgroundColor3 = Theme["Color Text"], Position = UDim2.fromScale(0, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5), BorderSizePixel = 0, ZIndex = 5
    })
    self.pCreate("UICorner", {Parent = Knob, CornerRadius = UDim.new(1, 0)})
    
    -- 6. Área de Clique/Arrasto 
    local Dragger = self.pCreate("TextButton", {
        Parent = SliderBar, Size = UDim2.new(1, 0, 3, 0), 
        Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), 
        BackgroundTransparency = 1, Text = "", ZIndex = 6
    })

    -- 7. Lógica de Atualização
    local function UpdateSlider(NewValue, isInstant)
        CurrentValue = math.clamp(NewValue, Min, Max)
        local percentage = (CurrentValue - Min) / (Max - Min)
        ValueLabel.Text = string.format("%.0f", CurrentValue)
        
        local info = isInstant and TweenInfo.new(0) or TweenInfo.new(0.1, Enum.EasingStyle.Quad)
        TweenService:Create(Knob, info, {Position = UDim2.fromScale(percentage, 0.5)}):Play()
        TweenService:Create(Indicator, info, {Size = UDim2.fromScale(percentage, 1)}):Play()
        
        -- MANDAMENTO DO pcall SAGRADO
        self:pcall(options.Callback, CurrentValue)
    end

    -- 8. Lógica de Arrastar (MOBILE SOBERANO)
    local isDragging = false
    
    local function processInput(input)
        local barAbsoluteX, barAbsoluteSizeX = SliderBar.AbsolutePosition.X, SliderBar.AbsoluteSize.X
        local pos = input.Position.X - barAbsoluteX
        local percentage = math.clamp(pos / barAbsoluteSizeX, 0, 1)
        
        local newValue = math.floor((percentage * (Max - Min)) + Min + 0.5) 
        UpdateSlider(newValue)
    end

    Dragger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            -- Desabilita o scroll da Tab enquanto arrasta o Slider (Melhor UX)
            self.Container.ScrollingEnabled = false 
            processInput(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            processInput(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
            self.Container.ScrollingEnabled = true
        end
    end)
    
    -- 9. Inicialização e API
    UpdateSlider(Default, true)

    local API = {}
    API.SetValue = UpdateSlider
    API.GetValue = function() return CurrentValue end

    return API
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V7 - O LEGADO DO DRIP (SIMPLIFICADO) - by RARO XT & DRIP
-- [ ! ] - PARTE 11/20: DROPDOWNS (ADD DROPDOWN)
-- ====================================================================================== --

-- ID: K1 - A API PÚBLICA PARA CRIAR DROPDOWNS: Tab:AddDropdown({...})
function rareLib:AddDropdown(options)
    local options = options or {}
    options.RightSideWidth = options.RightSideWidth or 140
    local Theme = self.ParentHub.Theme
    local Config = self.ParentHub.Config
    local Options, Default, Callback = options.Options or {}, options.Default or options.Options[1], options.Callback
    
    -- Usa o nosso Molde Universal (Parte 7)
    local Frame, MainContainer = self:__createOptionFrame(options)
    local SelectedValue = Default
    local isDropdownVisible = false
    
    -- 1. Botão/Caixa de Seleção (Dentro do Option Frame)
    local DropdownButton = self.pCreate("TextButton", {
        Parent = MainContainer, Size = UDim2.new(0, options.RightSideWidth - 8, 0, 22), 
        Position = UDim2.new(1, -options.RightSideWidth + 4, 0.5, 0), 
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Theme["Color Stroke"], Text = "", AutoButtonColor = false, ZIndex = 2
    })
    self.pCreate("UICorner", {Parent = DropdownButton, CornerRadius = UDim.new(0, Config.CornerRadius - 4)})

    local Label = self.pCreate("TextLabel", {
        Parent = DropdownButton, Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextColor3 = Theme["Color Text"],
        Text = SelectedValue, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = "AtEnd"
    })

    local Arrow = self.pCreate("ImageLabel", {
        Parent = DropdownButton, Image = "rbxassetid://10709791523", Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(1, -15, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 1, ZIndex = 3
    })
    
    -- 2. Overlay (Ocupa a tela toda)
    local Overlay = self.pCreate("TextButton", {
        Parent = self.ParentHub.MainGui, Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, ZIndex = 100, Visible = false, Text = "" 
    })
    
    -- 3. Lista de Opções (DENTRO do Overlay)
    local ListPanel = self.pCreate("ScrollingFrame", {
        Parent = Overlay, Name = "ListPanel", Size = UDim2.new(0, options.RightSideWidth - 8, 0, 1), 
        BackgroundColor3 = Theme["Color Hub BG"],
        BorderColor3 = Theme["Color Theme"], BorderSizePixel = 1, ZIndex = 101,
        ScrollBarImageColor3 = Theme["Color Theme"], ScrollBarThickness = 4,
        AutomaticCanvasSize = "Y", ScrollingDirection = "Y", ClipsDescendants = true
    })
    self.pCreate("UICorner", {Parent = ListPanel, CornerRadius = UDim.new(0, Config.CornerRadius - 4)})
    self.pCreate("UIListLayout", {Parent = ListPanel, Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder})
    self.pCreate("UIPadding", {Parent = ListPanel, PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5)})
    
    -- 4. Funções de Toggle
    local function ToggleDropdown()
        isDropdownVisible = not isDropdownVisible
        
        if isDropdownVisible then
            local pos = DropdownButton.AbsolutePosition
            ListPanel.Size = UDim2.new(0, options.RightSideWidth - 8, 0, 1) 
            task.wait() 
            
            local listHeight = ListPanel.CanvasSize.Y.Offset
            local targetHeight = math.min(listHeight + 10, 200) 
            
            -- CÁLCULO DE POSIÇÃO PRECISO
            local x = pos.X
            local y = pos.Y + DropdownButton.AbsoluteSize.Y
            if y + targetHeight > Overlay.AbsoluteSize.Y then 
                y = pos.Y - targetHeight 
            end
            
            Overlay.Visible = true
            ListPanel.Position = UDim2.fromOffset(x, y)
            TweenService:Create(ListPanel, TweenInfo.new(0.2), {Size = UDim2.new(0, options.RightSideWidth - 8, 0, targetHeight)}):Play()
            TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
        else
            TweenService:Create(ListPanel, TweenInfo.new(0.2), {Size = UDim2.new(0, options.RightSideWidth - 8, 0, 1)}):Play()
            TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
            task.delay(0.2, function() Overlay.Visible = false end)
        end
    end
    
    local function SelectOption(optionName)
        SelectedValue = optionName
        Label.Text = optionName
        
        -- MANDAMENTO DO pcall SAGRADO
        self:pcall(Callback, optionName) 
        
        if isDropdownVisible then ToggleDropdown() end
    end
    
    -- 5. População da Lista
    for _, option in ipairs(Options) do
        local optButton = self.pCreate("TextButton", {
            Parent = ListPanel, Size = UDim2.new(1, 0, 0, 22), 
            BackgroundColor3 = Theme["Color Hub BG"],
            Text = "  " .. option, Font = Enum.Font.Gotham, TextColor3 = Theme["Color Text"],
            TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false, ZIndex = 102
        })
        optButton.MouseEnter:Connect(function() optButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30) end)
        optButton.MouseLeave:Connect(function() optButton.BackgroundColor3 = Theme["Color Hub BG"] end)
        optButton.MouseButton1Click:Connect(function() SelectOption(option) end)
    end
    
    -- 6. Conexões
    DropdownButton.MouseButton1Click:Connect(ToggleDropdown)
    Overlay.MouseButton1Click:Connect(function() if isDropdownVisible then ToggleDropdown() end end)

    local API = {}
    API.SetValue = SelectOption
    API.GetValue = function() return SelectedValue end
    
    return API
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V7 - O LEGADO DO DRIP (SIMPLIFICADO) - by RARO XT & DRIP
-- [ ! ] - PARTE 12/20: TEXTBOXES (ADD TEXTBOX)
-- ====================================================================================== --

-- ID: L1 - A API PÚBLICA PARA CRIAR TEXTBOXES: Tab:AddTextbox({...})
function rareLib:AddTextbox(options)
    local options = options or {}
    options.RightSideWidth = options.RightSideWidth or 140
    local Theme = self.ParentHub.Theme
    local Config = self.ParentHub.Config
    local Placeholder, Callback = options.Placeholder or "...", options.Callback
    
    -- Usa o nosso Molde Universal (Parte 7)
    local Frame, MainContainer = self:__createOptionFrame(options)

    -- 1. Frame Container do Textbox (Para aplicar o UIStroke)
    local TextboxFrame = self.pCreate("Frame", {
        Parent = MainContainer, Name = "TextboxFrame", 
        Size = UDim2.new(0, options.RightSideWidth - 8, 0, 22), 
        Position = UDim2.new(1, -options.RightSideWidth + 4, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Theme["Color Stroke"], 
        ZIndex = 2
    })
    self.pCreate("UICorner", {Parent = TextboxFrame, CornerRadius = UDim.new(0, Config.CornerRadius - 4)})

    -- 2. O Textbox
    local Textbox = self.pCreate("TextBox", {
        Parent = TextboxFrame, Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextColor3 = Theme["Color Text"],
        Text = options.Default or "", PlaceholderText = Placeholder, PlaceholderColor3 = Theme["Color Dark Text"],
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false,
        ZIndex = 3
    })
    
    -- 3. O UIStroke (A Borda Animada)
    local Stroke = self.pCreate("UIStroke", { 
        Parent = TextboxFrame, ApplyStrokeMode = "Border", Color = Theme["Color Theme"], 
        Thickness = 0, Enabled = false, 
    })

    -- 4. Lógica de Foco (CORRIGIDO: Usando 'Focused' e 'FocusLost')
    Textbox.Focused:Connect(function()
        Stroke.Enabled = true
        TweenService:Create(Stroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { Thickness = 2 }):Play()
        TweenService:Create(TextboxFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { BackgroundColor3 = Theme["Color Hub BG"] }):Play()
    end)
    
    Textbox.FocusLost:Connect(function(enterPressed)
        TweenService:Create(Stroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { Thickness = 0 }):Play()
        TweenService:Create(TextboxFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { BackgroundColor3 = Theme["Color Stroke"] }):Play()
        
        task.delay(0.2, function()
            if Stroke and Stroke.Parent then Stroke.Enabled = false end
        end)
        
        -- Chama o callback apenas se ENTER foi pressionado (pcall SAGRADO)
        if enterPressed and Textbox.Text:gsub("%s", "") ~= "" then
            self:pcall(Callback, Textbox.Text)
        end
    end)
    
    -- 5. API
    local API = {}
    API.SetText = function(newText) Textbox.Text = newText end
    API.GetText = function() return Textbox.Text end
    
    return API
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V7 - O LEGADO DO DRIP (SIMPLIFICADO) - by RARO XT & DRIP
-- [ ! ] - PARTE 13/20: SELETOR DE TECLAS (ADD KEYBIND)
-- ====================================================================================== --

-- ID: M1 - A API PÚBLICA PARA CRIAR KEYBINDS: Tab:AddKeybind({...})
function rareLib:AddKeybind(options)
    local options = options or {}
    options.RightSideWidth = options.RightSideWidth or 100 
    local Theme = self.ParentHub.Theme
    local Config = self.ParentHub.Config
    
    -- Usa o nosso Molde Universal (Parte 7)
    local Frame, MainContainer = self:__createOptionFrame(options)
    
    local DefaultKey = options.Default or Enum.KeyCode.Unknown
    local CurrentKeyCode = DefaultKey
    local isListening = false
    
    -- 1. Frame Container do Keybind (Para aplicar o UIStroke)
    local KeybindFrame = self.pCreate("Frame", {
        Parent = MainContainer, Name = "KeybindFrame", 
        Size = UDim2.new(0, options.RightSideWidth - 8, 0, 22), 
        Position = UDim2.new(1, -options.RightSideWidth + 4, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Theme["Color Stroke"], 
        ZIndex = 2
    })
    self.pCreate("UICorner", {Parent = KeybindFrame, CornerRadius = UDim.new(0, Config.CornerRadius - 4)})
    
    -- 2. Label de Exibição da Tecla (Botão Clicável)
    local KeyLabel = self.pCreate("TextButton", {
        Parent = KeybindFrame, Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextColor3 = Theme["Color Text"],
        Text = CurrentKeyCode.Name, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Center,
        AutoButtonColor = false, ZIndex = 3
    })
    
    -- 3. UIStroke (Feedback de escuta de tecla)
    local Stroke = self.pCreate("UIStroke", { 
        Parent = KeybindFrame, ApplyStrokeMode = "Border", Color = Theme["Color Theme"], 
        Thickness = 0, Enabled = false, 
    })

    -- 4. Lógica de Atualização Visual
    local function UpdateKeyDisplay(keyCode)
        CurrentKeyCode = keyCode
        KeyLabel.Text = keyCode == Enum.KeyCode.Unknown and "NONE" or keyCode.Name
        isListening = false
        
        -- Garante que o estado de escuta seja desativado visualmente
        TweenService:Create(Stroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { Thickness = 0 }):Play()
        TweenService:Create(KeybindFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { BackgroundColor3 = Theme["Color Stroke"] }):Play()
        task.delay(0.2, function() if Stroke and Stroke.Parent then Stroke.Enabled = false end end)
    end
    
    -- 5. Lógica de Captura (Escuta)
    local function StartListening()
        if isListening then return end
        isListening = true
        
        -- Feedback Visual de Escuta
        Stroke.Enabled = true
        TweenService:Create(Stroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { Thickness = 2 }):Play()
        TweenService:Create(KeybindFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { BackgroundColor3 = Theme["Color Theme"] }):Play()
        KeyLabel.Text = "..."
    end
    
    KeyLabel.MouseButton1Click:Connect(function()
        if isListening then UpdateKeyDisplay(Enum.KeyCode.Unknown)
        else StartListening() end
    end)
    
    -- 6. Conexão Global para Capturar a Tecla
    local Connection = UserInputService.InputBegan:Connect(function(input)
        if not isListening or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        
        -- Ignorar teclas de modificação
        if input.KeyCode.Name:match("Control|Shift|Alt|Meta|Unknown") then return end

        UpdateKeyDisplay(input.KeyCode)
        
        -- Persiste a nova tecla no callback de setup (MANDAMENTO DO pcall SAGRADO)
        self:pcall(options.Callback, input.KeyCode)
    end)

    -- 7. Inicialização e API
    UpdateKeyDisplay(DefaultKey)
    
    local API = {}
    API.SetValue = UpdateKeyDisplay
    API.GetValue = function() return CurrentKeyCode end
    API.Connection = Connection
    
    return API
end


-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V7 - O LEGADO DO DRIP (SIMPLIFICADO) - by RARO XT & DRIP
-- [ ! ] - PARTE 14/20: LABEL DE LINK/CRÉDITO
-- ====================================================================================== --

-- ID: N1 - A API PÚBLICA PARA CRIAR LABEL DE LINK/AÇÃO: Tab:AddLabelLink({...})
function rareLib:AddLabelLink(options)
    local options = options or {}
    local Theme = self.ParentHub.Theme
    local Config = self.ParentHub.Config
    
    local Text = options.Text or "Link/Ação"
    local Action = options.Action or "Clique para Copiar"

    -- 1. Frame de Opção (Minimalista)
    local Frame = self.pCreate("Frame", {
        Parent = self.Container, Name = "LinkOption",
        Size = UDim2.new(1, 0, 0, 30), 
        BackgroundColor3 = Theme["Color Panel BG"], 
        LayoutOrder = #self.Container:GetChildren() + 1,
        ClipsDescendants = false
    })
    self.pCreate("UICorner", {Parent = Frame, CornerRadius = UDim.new(0, Config.CornerRadius - 2)})
    self.pCreate("UIPadding", {Parent = Frame, PaddingAll = UDim.new(0, Config.Padding)})
    
    -- 2. Label Principal (Texto/Link)
    local Label = self.pCreate("TextLabel", {
        Parent = Frame, Name = "LinkText", 
        Size = UDim2.new(1, -70, 1, 0), Position = UDim2.new(0, 0, 0, 0), 
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = Text,
        TextColor3 = Theme["Color Text"], TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
    })

    -- 3. Label de Ação (Hint)
    local ActionHint = self.pCreate("TextLabel", {
        Parent = Frame, Name = "ActionHint", 
        Size = UDim2.new(0, 70, 1, 0), Position = UDim2.new(1, -70, 0, 0), 
        BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = Action,
        TextColor3 = Theme["Color Dark Text"], TextSize = 10, TextXAlignment = Enum.TextXAlignment.Right,
    })
    
    -- 4. Botão Clicável 
    local Button = self.pCreate("TextButton", {
        Parent = Frame, Size = UDim2.new(1, 0, 1, 0), 
        BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 3
    })
    
    -- 5. Lógica de Click (MANDAMENTO DO pcall SAGRADO)
    Button.MouseButton1Click:Connect(function()
        if options.Callback then
            self:pcall(options.Callback) 
        end
        
        -- Animação de Click
        local originalColor = Frame.BackgroundColor3
        TweenService:Create(Frame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
        task.wait(0.1)
        TweenService:Create(Frame, TweenInfo.new(0.1), {BackgroundColor3 = originalColor}):Play()
    end)

    return { Frame = Frame }
end


-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V7 - O LEGADO DO DRIP (SIMPLIFICADO) - by RARO XT & DRIP
-- [ ! ] - PARTES 15/20 A 19/20: RESERVADAS PARA FUTUROS COMPONENTES AVANÇADOS 
-- ====================================================================================== --
-- O espaço está reservado, a V7 é modular!


-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V7 - O LEGADO DO DRIP (SIMPLIFICADO) - by RARO XT & DRIP
-- [ ! ] - PARTE 20/20: O FIM DA LIB. RETORNANDO O OBJETO PRINCIPAL.
-- ====================================================================================== --

-- ID: Z1 - O GRANDE FINAL!
return rareLib
