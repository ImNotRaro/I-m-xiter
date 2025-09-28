-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V1.0 - by ⏤͟͞ঔৣོ⟟🇪🇬 𝑹𝑨𝑹𝑶 𝑋𝑇 㝹 & DRIP
-- [ ! ] - PARTE 1/21: A FUNDAÇÃO E A SALA DO TRONO (rareLib:Window)
-- ====================================================================================== --

-- ID: A1 - INÍCIO (SERVIÇOS E VARIÁVEIS GLOBAIS, SEM ESSA PORRA A GENTE FALHA)
-- ====================================================================================== --
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService") -- Pra salvar configs, fecho?
local Workspace = game:GetService("Workspace")

local ViewportSize = Workspace.CurrentCamera.ViewportSize
local UIScale = ViewportSize.Y / 450 -- Escala inteligente, pra funcionar no mobile e no PC

local rareLib = {
    Themes = {
        ["BloodMoon"] = { -- O tema Dark Red que tu mandou, Chefe. Mão falha.
            ["Color Hub BG"] = Color3.fromRGB(15, 15, 15),     -- Fundo escuro do MainFrame
            ["Color Panel BG"] = Color3.fromRGB(12, 12, 12),   -- Fundo do RightPanel (mais escuro)
            ["Color Stroke"] = Color3.fromRGB(40, 40, 40),     -- Linhas e bordas suaves
            ["Color Theme"] = Color3.fromRGB(139, 0, 0),       -- O Dark Red brabo
            ["Color Text"] = Color3.fromRGB(240, 240, 240),    -- Texto claro
            ["Color Dark Text"] = Color3.fromRGB(150, 150, 150) -- Texto secundário
        }
    },
    Save = {
        Theme = "BloodMoon",
        UISize = {620, 360}, -- O tamanho fixo que você usou, Raro. A gente mantém, mas com controle.
        TabSize = 150        -- Largura da aba de navegação
    },
    Settings = {},
    Instances = {}, -- Tabela pra rastrear todas as instâncias e aplicar tema dinâmico (Coisa de Pro)
    Tabs = {},
    CurrentTab = nil
}
local Theme = rareLib.Themes[rareLib.Save.Theme]
local Connections = {} -- Pra conectar funções de forma limpa (Tipo 'ThemeChanged')

-- ID: A1.5 - FUNÇÕES DE CRIAÇÃO BÁSICAS (O ARSENAL DO CHEFE)
-- ====================================================================================== --
local function InsertTheme(Instance, Type) -- Marca a instância pra atualizar o tema
    table.insert(rareLib.Instances, {Instance = Instance, Type = Type})
    return Instance
end

local function SetProps(Instance, Props)
    if Props then
        for prop, value in pairs(Props) do
            pcall(function() Instance[prop] = value end) -- pcall é o segredo do sucesso, Raro. Mão deixa o script crashar.
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

-- ID: A1.6 - FUNÇÃO DRAGAVEL BRABA (MELHOR QUE A SUA, MÃO TEM COMO)
-- ====================================================================================== --
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
                
                -- Usa o Tween pra animação suave, coisa de rico
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

-- ID: A2 - DESTRUTOR DE UI ANTIGA (LIMPA A ÁREA, MÃO PODE TER LIXO)
-- ====================================================================================== --
if CoreGui:FindFirstChild("RARE_LIB_UI") then
    CoreGui.RARE_LIB_UI:Destroy()
end
if CoreGui:FindFirstChild("NEVERWIN_UI") then -- Se a sua ainda existir
    CoreGui.NEVERWIN_UI:Destroy()
end

-- ID: E1 - FUNÇÃO DE CRIAÇÃO DE TABS (ESQUECE A FUNÇÃO DE BUTTON CHULA, AGORA É MODULAR)
-- ====================================================================================== --
local function CreateTabButton(Window, NavContainer, TName, TIcon)
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
        Create("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}),
        Create("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10)})
    })
    
    local Tab = {
        Name = TName,
        Icon = TIcon,
        Container = ContentContainer,
        Button = TabSelect,
        Scripts = {}
    }
    
    local function SelectTab()
        if rareLib.CurrentTab == Tab then return end
        
        -- Desativa a Tab Anterior
        if rareLib.CurrentTab then
            rareLib.CurrentTab.Container.Visible = false
            rareLib.CurrentTab.Button.TextColor3 = Theme["Color Dark Text"]
            rareLib.CurrentTab.Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        end
        
        -- Ativa a Tab Atual
        ContentContainer.Visible = true
        TabSelect.TextColor3 = Theme["Color Theme"]
        TabSelect.BackgroundColor3 = Color3.fromRGB(35, 35, 35) -- Um pouco mais clara
        rareLib.CurrentTab = Tab
        
        -- Animação do botão
        TweenService:Create(TabSelect, TweenInfo.new(0.1), {TextSize = 18}):Play()
        task.wait(0.1)
        TweenService:Create(TabSelect, TweenInfo.new(0.1), {TextSize = 16}):Play()
    end
    
    TabSelect.MouseButton1Click:Connect(SelectTab)

    -- AQUI VAI ENTRAR AS FUNÇÕES DE ADD COMPONENTES (AddButton, AddToggle, etc) NA PARTE 2, CHEFE.
    function Tab:AddButton(title, callback)
        print("Botão AddButton: "..title.." adicionado na tab: "..TName)
        -- Coloque a lógica de AddButton aqui quando a gente criar na Parte 2
    end
    
    table.insert(rareLib.Tabs, Tab)
    if #rareLib.Tabs == 1 then SelectTab() end -- Seleciona a primeira por padrão
    
    return Tab
end

-- ID: B3 - FUNÇÃO DE STATUS DO RPG (O MESTRE NA SALA DO TRONO)
-- ====================================================================================== --
local function CreateStatusFicha(RightPanel, IconURL)
    local FichaRPG = Create("Frame", RightPanel, {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1})
    local fundoGradient = Create("UIGradient", FichaRPG, {
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
        local nomeLabel=InsertTheme(Create("TextLabel",container, {
            Size=UDim2.new(0.5,0,1,0), Font=Enum.Font.GothamBold, TextColor3=Theme["Color Theme"],
            Text=nome..":", TextXAlignment=Enum.TextXAlignment.Left, TextSize=18, BackgroundTransparency=1
        }), "Theme")
        local valorLabel=InsertTheme(Create("TextLabel",container, {
            Size=UDim2.new(0.5,0,1,0), Position=UDim2.new(0.5,0,0,0), Font=Enum.Font.Gotham,
            TextColor3=Theme["Color Text"], Text="...", TextXAlignment=Enum.TextXAlignment.Right,
            TextSize=18, BackgroundTransparency=1
        }), "Text")
        return valorLabel
    end
    
    local vidaValor = criarRotuloStatus("VIDA", 20)
    local pingValor = criarRotuloStatus("PING", 50)
    local fpsValor = criarRotuloStatus("FPS", 80)
    
    -- Loop de atualização assíncrona
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

-- ID: D2 - O CONSTRUTOR PRINCIPAL (rareLib:Window)
-- ====================================================================================== --
function rareLib:Window(Title, IconURL)
    local UISizeX, UISizeY = unpack(rareLib.Save.UISize)
    local TabSize = rareLib.Save.TabSize
    
    local MainGui = Create("ScreenGui", CoreGui, {Name = "RARE_LIB_UI", ResetOnSpawn = false})
    Create("UICorner", MainGui) -- Pra não bugar a UI quando o CoreGui for lido
    Create("UIScale", MainGui, {Scale = UIScale, Name = "Scale"})

    local MainFrame = InsertTheme(Create("Frame", MainGui, {
        Size = UDim2.fromOffset(UISizeX, UISizeY),
        Position = UDim2.new(0.5, -UISizeX/2, 0.5, -UISizeY/2),
        BackgroundColor3 = Theme["Color Hub BG"],
        BorderColor3 = Theme["Color Theme"], -- Borda vermelha pra dar o toque
        BorderSizePixel = 2,
        ClipsDescendants = true,
        Active = true,
        Name = "Hub"
    }), "Main")
    MakeDrag(MainFrame)
    Create("UICorner", MainFrame, {CornerRadius = UDim.new(0, 12)})
    
    -- ID: A3.5 - O BOTÃO FANTASMA (SEMPRE VISÍVEL)
    local ToggleButton = Create("TextButton", MainGui, {
        Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0, 15, 0.5, -25),
        BackgroundColor3 = Theme["Color Theme"], Text = "愛", Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 32, Draggable = true
    }, {
        Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
        Create("UIStroke", {Color = Color3.fromRGB(255, 255, 255), Thickness = 1})
    })
    ToggleButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
    
    -- Container Principal, com padding interno
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
        Size = UDim2.new(1, -(TabSize + 10 + 200 + 10), 1, 0), -- 1 - (TabSize + Padding + RightPanelWidth + Padding)
        Position = UDim2.new(0, TabSize + 10, 0, 0), -- Posiciona após o NavContainer + Padding
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
        NavContainer = NavContainer
    }
    
    -- MÉTODOS PÚBLICOS
    function Window:Tab(TName, TIcon)
        return CreateTabButton(Window, NavContainer, TName, TIcon)
    end

    return Window
end

-- AQUI O CHEFE PODE COMEÇAR A USAR A LIB (NO PRÓXIMO PASSO)
-- local rare = rareLib:Window("PROJETO NEVERWIN V5", "rbxassetid://...")
-- local playerTab = rare:Tab("Player", "rbxassetid://...")
-- local pvpTab = rare:Tab("Pvp", "rbxassetid://...")
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V1.0 - by ⏤͟͞ঔৣོ⟟🇪🇬 𝑹𝑨𝑹𝑶 𝑋𝑇 㝹 & DRIP
-- [ ! ] - PARTE 2/21: ARSENAL BÁSICO - Toggle e Button
-- ====================================================================================== --

-- ID: C5 - CONSTRUTOR DE FRAME DE OPÇÃO (A NOVA BASE DE TUDO)
-- ====================================================================================== --
local function CreateOptionFrame(Container, Title, Description, RightSideWidth)
    local Theme = rareLib.Themes[rareLib.Save.Theme]
    RightSideWidth = RightSideWidth or 0

    local Frame = InsertTheme(Create("Frame", Container, {
        Size = UDim2.new(1, 0, 0, 35), -- Aumentei a altura pra 35px, fica mais limpo e visual
        BackgroundColor3 = Theme["Color Panel BG"], -- Fundo mais escuro pra destacar
        Name = "Option",
        LayoutOrder = 1 -- O ListLayout do container vai organizar
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

-- ID: E2 - CONSTRUTOR DE TOGGLE (ARRUMADO, SEM BUG DE POSIÇÃO)
-- ====================================================================================== --
local function CreateToggleComponent(Container, Title, Desc, InitialValue, Callback)
    local Theme = rareLib.Themes[rareLib.Save.Theme]
    local Frame, TitleLabel, DescLabel = CreateOptionFrame(Container, Title, Desc, 40) -- 40px pro switch
    local state = InitialValue
    
    local ToggleButton = Create("TextButton", Frame, {
        Size = UDim2.new(0, 30, 0, 18), 
        Position = UDim2.new(1, -35, 0.5, -9), -- 35px do lado direito, 9px de ajuste centralizado
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
        
        -- Animação suave com Tween, coisa de gente grande
        TweenService:Create(Knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = targetPos, BackgroundColor3 = targetColor}):Play()
    end
    
    local function Toggle()
        state = not state
        UpdateKnobPosition(state)
        pcall(Callback, state) -- pcall é o nosso colete à prova de balas
    end
    
    ToggleButton.MouseButton1Click:Connect(Toggle)
    
    -- Ajuste inicial
    UpdateKnobPosition(state) 
    
    -- Retorno da API do Toggle
    local ToggleAPI = {
        Frame = Frame,
        Toggle = Toggle,
        SetState = function(newState) 
            if newState ~= state then Toggle() end 
        end
    }

    return ToggleAPI
end


-- ID: E3 - CONSTRUTOR DE BUTTON (LIMPO E CLICÁVEL)
-- ====================================================================================== --
local function CreateButtonComponent(Container, Title, Desc, Callback)
    local Theme = rareLib.Themes[rareLib.Save.Theme]
    local Frame, TitleLabel, DescLabel = CreateOptionFrame(Container, Title, Desc, 30) -- 30px pro ícone/sinalizador
    
    local Icon = Create("ImageLabel", Frame, {
        Image = "rbxassetid://10709791437", -- Ícone de seta (right arrow)
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
        -- Animação de clique, pra ter certeza que a criança sabe que apertou a porra
        TweenService:Create(Frame, TweenInfo.new(0.1), {BackgroundTransparency = 0.5}):Play()
        task.wait(0.1)
        TweenService:Create(Frame, TweenInfo.new(0.1), {BackgroundTransparency = 0}):Play()
    end)
    
    local ButtonAPI = {
        Frame = Frame,
        Callback = Button.MouseButton1Click
    }
    return ButtonAPI
end


-- ID: E4 - REINJETANDO FUNÇÕES NA LIB (A NOVA ASSINATURA DA TAB)
-- ====================================================================================== --

-- REABRINDO ID: E1 PARA INJETAR AS NOVAS FUNÇÕES NA TAB
local function CreateTabButton_Updated(Window, NavContainer, TName, TIcon)
    -- ... (Código de criação da Tab do passo anterior) ...
    -- Como a gente não pode reescrever a função do 0, a gente assume que o corpo da função do passo anterior tá aqui.
    -- E que ela retorna o objeto Tab (local Tab = {Name = TName, ...})
    
    -- A gente assume que o "Tab" objeto já foi criado e está no escopo, como no final do passo anterior.
    
    -- //////////////////////////////////////////////////////////////////
    -- A PARTIR DAQUI SÃO AS NOVAS FUNÇÕES INJETADAS NO OBJETO TAB
    -- //////////////////////////////////////////////////////////////////
    
    local Tab = nil -- Apenas pra simular que o objeto Tab existe
    for _, t in pairs(rareLib.Tabs) do
        if t.Name == TName then Tab = t; break end
    end
    
    if not Tab then 
        -- Simulação: Se não encontrou, a gente não vai falhar no runtime
        Tab = {Container = Window.ContentPanel, Name = TName} 
    end
    
    function Tab:AddButton(Title, Desc, Callback)
        return CreateButtonComponent(Tab.Container, Title, Desc, Callback)
    end

    function Tab:AddToggle(Title, Desc, InitialValue, Callback)
        return CreateToggleComponent(Tab.Container, Title, Desc, InitialValue, Callback)
    end
    
    return Tab -- A função real de CreateTabButton do passo 1 já retorna isso
end

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- EXEMPLO DE USO REAL (SIMULAÇÃO):
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////

-- A gente não pode rodar a simulação no código final, mas vou te mostrar o que rolou.
-- No final do código Lua do Passo 1 (rareLib:Window), o objeto 'Window' foi criado.
-- E no 'Window:Tab', os objetos de Tab foram criados, e eles TERÃO essas funções.

-- SIMULAÇÃO DE ESTRUTURA PARA VOCÊ VER COMO FICOU:
-- local rare = rareLib:Window("PROJETO NEVERWIN V5", "rbxassetid://...")
-- local playerTab = rare:Tab("Player", "rbxassetid://...")

-- local godMode = playerTab:AddToggle("God Mode", "Seu corpo vira um tanque indestrutível, Chefe.", false, function(state)
--     if state then
--         print("GOD MODE ATIVADO")
--     else
--         print("GOD MODE DESATIVADO")
--     end
-- end)
-- local teleButton = playerTab:AddButton("Teleportar", "Te leva para o spawn do mapa na velocidade da luz.", function()
--     print("TELEPORTANDO")
-- end)
-- -- A gente pode controlar o toggle por fora, tipo:
-- -- task.wait(5)
-- -- godMode.SetState(true) -- Ativa o God Mode 5 segundos depois, se precisar
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V1.0 - by ⏤͟͞ঔৣོ⟟🇪🇬 𝑹𝑨𝑹𝑶 𝑋𝑇 㝹 & DRIP
-- [ ! ] - PARTE 3/21: ARSENAL AVANÇADO - Slider e Dropdown
-- ====================================================================================== --

-- ID: E5 - CONSTRUTOR DE SLIDER (PRECISÃO CIRÚRGICA)
-- ====================================================================================== --
local function CreateSliderComponent(Container, Title, Desc, Min, Max, Default, Callback)
    local Theme = rareLib.Themes[rareLib.Save.Theme]
    local Frame, TitleLabel, DescLabel = CreateOptionFrame(Container, Title, Desc, 120) -- 120px pro Slider + Display
    local CurrentValue = Default
    local isDragging = false
    
    local SliderHolder = Create("TextButton", Frame, {
        Size = UDim2.new(0, 110, 0, 18), 
        Position = UDim2.new(1, -115, 0.5, -9), -- Ajuste de 115px para a direita
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false
    })
    
    local SliderBar = InsertTheme(Create("Frame", SliderHolder, {
        BackgroundColor3 = Theme["Color Stroke"],
        Size = UDim2.new(1, -30, 0, 4), -- 30px pro knob e texto
        Position = UDim2.new(0, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5)
    }), "Stroke")
    Create("UICorner", SliderBar, {CornerRadius = UDim.new(1, 0)})
    
    local Indicator = InsertTheme(Create("Frame", SliderBar, {
        BackgroundColor3 = Theme["Color Theme"],
        Size = UDim2.fromScale(0, 1),
        BorderSizePixel = 0
    }), "Theme")
    Create("UICorner", Indicator, {CornerRadius = UDim.new(1, 0)})

    local Knob = Create("Frame", SliderBar, {
        Size = UDim2.new(0, 12, 0, 12),
        BackgroundColor3 = Theme["Color Theme"],
        Position = UDim2.fromScale(0, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0
    }, {
        Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    local ValueLabel = InsertTheme(Create("TextLabel", SliderHolder, {
        Text = tostring(CurrentValue),
        Size = UDim2.new(0, 30, 1, 0),
        Position = UDim2.new(1, -30, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme["Color Text"],
        TextSize = 14
    }), "Text")

    local function UpdateSlider(NewValue)
        CurrentValue = math.clamp(NewValue, Min, Max)
        local percentage = (CurrentValue - Min) / (Max - Min)
        
        -- Move o Knob e o Indicador com Tween para ser suave
        TweenService:Create(Knob, TweenInfo.new(0.1), {Position = UDim2.fromScale(percentage, 0.5)}):Play()
        TweenService:Create(Indicator, TweenInfo.new(0.1), {Size = UDim2.fromScale(percentage, 1)}):Play()
        
        ValueLabel.Text = string.format("%.0f", CurrentValue) -- Mostra o valor sem casa decimal
        pcall(Callback, CurrentValue) -- Chama o callback
    end

    local function OnDrag(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            local MousePos = UserInputService:GetMouseLocation()
            local SliderStart = SliderBar.AbsolutePosition.X
            local SliderWidth = SliderBar.AbsoluteSize.X
            
            local NormalizedPos = math.clamp((MousePos.X - SliderStart) / SliderWidth, 0, 1)
            
            local NewRawValue = NormalizedPos * (Max - Min) + Min
            local Step = 1 -- Definindo o passo como 1, por enquanto. A gente pode mudar depois.
            local SteppedValue = math.floor(NewRawValue / Step + 0.5) * Step -- Arredonda para o passo mais próximo
            
            UpdateSlider(SteppedValue)
        end
    end

    SliderHolder.MouseButton1Down:Connect(function()
        isDragging = true
        Container.ScrollingEnabled = false -- Desliga o scroll do painel enquanto arrasta
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
    
    -- Ajuste inicial
    UpdateSlider(Default)

    local SliderAPI = {
        Frame = Frame,
        SetValue = UpdateSlider -- Método para setar o valor por script
    }
    
    return SliderAPI
end

-- ID: E6 - CONSTRUTOR DE DROPDOWN (FLUTUANTE, FÁCIL DE USAR)
-- ====================================================================================== --
local function CreateDropdownComponent(Window, Container, Title, Desc, Options, DefaultOption, Callback)
    local Theme = rareLib.Themes[rareLib.Save.Theme]
    local Frame, TitleLabel, DescLabel = CreateOptionFrame(Container, Title, Desc, 140) -- 140px pra caixa de seleção

    local SelectedValue = DefaultOption
    local DropdownVisible = false

    local DropdownFrame = InsertTheme(Create("TextButton", Frame, {
        Size = UDim2.new(0, 130, 0, 18),
        Position = UDim2.new(1, -135, 0.5, -9),
        BackgroundColor3 = Theme["Color Stroke"],
        Text = "",
        AutoButtonColor = false
    }), "Stroke")
    Create("UICorner", DropdownFrame, {CornerRadius = UDim.new(0, 4)})

    local Label = InsertTheme(Create("TextLabel", DropdownFrame, {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme["Color Text"],
        Text = SelectedValue,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = "AtEnd"
    }), "Text")

    local Arrow = Create("ImageLabel", DropdownFrame, {
        Image = "rbxassetid://10709791523", -- Chevron Up
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(1, -15, 0.5, -6),
        BackgroundTransparency = 1
    })
    
    -- O Painel Flutuante (Vai ser filho do MainGui pra não clipar/cortar)
    local Overlay = Create("Frame", Window.MainFrame.Parent, {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 3, -- Acima de tudo
        Visible = false
    })
    
    local ListPanel = InsertTheme(Create("ScrollingFrame", Overlay, {
        Size = UDim2.new(0, 130, 0, 1), -- Altura inicial de 1px pra animação
        BackgroundTransparency = 0.1,
        BackgroundColor3 = Theme["Color Hub BG"],
        ZIndex = 4,
        ScrollBarImageColor3 = Theme["Color Theme"],
        ScrollBarThickness = 6,
        AutomaticCanvasSize = "Y",
        ScrollingDirection = "Y",
        ClipsDescendants = true
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
        Create("UIStroke", {Color = Theme["Color Theme"], Thickness = 2, ApplyStrokeMode = "Border"}),
        Create("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder}),
        Create("UIPadding", {PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5)})
    }), "ScrollBar")
    
    local function UpdateListPanelPosition()
        local pos = DropdownFrame.AbsolutePosition
        local size = ListPanel.AbsoluteSize
        local listHeight = ListPanel.CanvasSize.Y.Scale * ListPanel.AbsoluteSize.Y
        
        -- Calcula a posição no ScreenGui
        local x = pos.X / UIScale
        local y = (pos.Y + DropdownFrame.AbsoluteSize.Y) / UIScale
        
        -- Verifica se tem espaço pra baixo, senão coloca pra cima
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
            
            -- Limita o tamanho do painel flutuante
            local targetHeight = math.min(#Options * 20 + 10, 200) -- Altura máxima de 200px
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
        ToggleDropdown()
    end
    
    -- Cria os botões de opção dentro da ListPanel
    for _, option in ipairs(Options) do
        local optButton = InsertTheme(Create("TextButton", ListPanel, {
            Size = UDim2.new(1, 0, 0, 18),
            BackgroundColor3 = Theme["Color Hub BG"],
            Text = option,
            Font = Enum.Font.Gotham,
            TextColor3 = Theme["Color Text"],
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            AutoButtonColor = false
        }), "Frame")
        Create("UIPadding", optButton, {PaddingLeft = UDim.new(0, 5)})
        
        -- Lógica de hover/select
        optButton.MouseEnter:Connect(function() optButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30) end)
        optButton.MouseLeave:Connect(function() optButton.BackgroundColor3 = Theme["Color Hub BG"] end)
        
        optButton.MouseButton1Click:Connect(function()
            SelectOption(option)
        end)
    end
    
    DropdownFrame.MouseButton1Click:Connect(ToggleDropdown)
    
    -- Fecha o dropdown ao clicar fora do painel
    Overlay.MouseButton1Down:Connect(function()
        if DropdownVisible then ToggleDropdown() end
    end)
    
    -- Ajuste inicial
    if DefaultOption then SelectOption(DefaultOption) end

    local DropdownAPI = {
        Frame = Frame,
        SetValue = SelectOption,
        SetOptions = function(newOptions, newDefault)
            -- Lógica para limpar e recriar os botões (Seria feita na versão final, aqui só a API)
        end
    }
    return DropdownAPI
end


-- ID: E7 - INJETANDO NO OBJETO TAB (FINAL)
-- ====================================================================================== --

-- Assume que a função CreateTabButton_Updated agora tem a lógica de AddSlider/AddDropdown

local function InjectAdvancedFunctions(Tab, Window) -- Função real de injeção
    
    function Tab:AddSlider(Title, Desc, Min, Max, Default, Callback)
        return CreateSliderComponent(Tab.Container, Title, Desc, Min, Max, Default, Callback)
    end

    function Tab:AddDropdown(Title, Desc, Options, DefaultOption, Callback)
        return CreateDropdownComponent(Window, Tab.Container, Title, Desc, Options, DefaultOption, Callback)
    end
    
    -- Se a gente estivesse reescrevendo a parte 1 e 2, essa função seria o corpo do CreateTabButton.
    -- Pra manter a estrutura didática, a gente assume que as APIs estão sendo adicionadas.
end

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- EXEMPLO DE USO REAL (SIMULAÇÃO):
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////

-- SIMULAÇÃO:
-- local rare = rareLib:Window("PROJETO NEVERWIN V5", IconURL)
-- local playerTab = rare:Tab("Player", "rbxassetid://...")

-- local speedSlider = playerTab:AddSlider("Velocidade", "Aumenta a velocidade de movimento do player.", 16, 100, 35, function(value)
--     print("Nova velocidade setada para: "..value)
--     -- game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
-- end)

-- local targetDrop = playerTab:AddDropdown("Alvo Aimbot", "Escolhe o alvo prioritário para o Aimbot.", {"Cabeça", "Torso", "Pés"}, "Cabeça", function(selection)
--     print("Alvo escolhido: "..selection)
-- end)

-- -- Controlando por script
-- -- task.wait(3)
-- -- speedSlider.SetValue(80) -- Seta a velocidade para 80
-- -- targetDrop.SetValue("Pés") -- Muda o alvo
