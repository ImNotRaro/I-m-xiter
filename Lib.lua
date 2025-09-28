-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V2 - by RARO XT & DRIP
-- [ ! ] - PARTE 1/20: O ESQUELETO DA LIB
-- ====================================================================================== --

-- ID: A1 - O QUARTEL-GENERAL (A TABELA PRINCIPAL)
local rareLib = {
    Themes = {
        ["BloodMoon"] = { -- O tema que o Chefe mandou, o único que importa
            ["Color Hub BG"] = Color3.fromRGB(15, 15, 15),
            ["Color Panel BG"] = Color3.fromRGB(12, 12, 12),
            ["Color Stroke"] = Color3.fromRGB(40, 40, 40),
            ["Color Theme"] = Color3.fromRGB(139, 0, 0),
            ["Color Text"] = Color3.fromRGB(240, 240, 240),
            ["Color Dark Text"] = Color3.fromRGB(150, 150, 150)
        }
    },
    Save = { -- Configs que a gente pode salvar no futuro
        Theme = "BloodMoon",
        UISize = {620, 360},
        TabSize = 150
    },
    Instances = {}, -- Tabela pra rastrear tudo que a gente cria, pra poder mudar o tema depois
    Tabs = {},      -- Onde as abas (Player, PvP) vão morar
    CurrentTab = nil
}

-- ID: A2 - SERVIÇOS ESSENCIAIS (AS FERRAMENTAS DO ARSENAL)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- ID: A3 - ESCALA INTELIGENTE (PRA RODAR ATÉ EM TORRADEIRA)
-- A UI vai se adaptar à resolução da tela, Chefe. Mão tem erro no mobile.
local ViewportSize = Workspace.CurrentCamera.ViewportSize
local UIScale = ViewportSize.Y / 720 -- Usando 720p como base pra uma escala boa

-- ID: A4 - AS FUNÇÕES-MESTRE (NOSSA FÁBRICA DE PEÇAS)
-- Essas duas funções vão ser usadas em TUDO que a gente fizer. É a base da base.

-- Função pra criar qualquer instância da UI (Frame, Button, etc.) de um jeito limpo
local function Create(instanceType, properties)
    local newInstance = Instance.new(instanceType)
    if properties then
        for prop, value in pairs(properties) do
            -- pcall pra não dar merda. Se uma propriedade falhar, o script não quebra.
            pcall(function()
                newInstance[prop] = value
            end)
        end
    end
    return newInstance
end

-- Função pra rastrear as instâncias que precisam mudar de cor com o tema
local function Track(instance, themeType)
    table.insert(rareLib.Instances, {Instance = instance, Type = themeType})
    return instance
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V2 - by RARO XT & DRIP
-- [ ! ] - PARTE 2/20: A JANELA PRINCIPAL
-- ====================================================================================== --

-- ID: B1 - A FUNÇÃO DE ARRASTAR PERFEITA (ANTI-LAG E MOBILE-FRIENDLY)
local function MakeDrag(instance)
    local isDragging = false
    local startPos, dragStart
    
    instance.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            startPos = instance.Position
            dragStart = input.Position
            
            local parent = instance.Parent
            while parent and not parent:IsA("ScrollingFrame") do
                parent = parent.Parent
            end
            if parent then
                parent.ScrollingEnabled = false
            end
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            
            TweenService:Create(instance, TweenInfo.new(0.05), {Position = newPos}):Play()
        end
    end)

    instance.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
            local parent = instance.Parent
            while parent and not parent:IsA("ScrollingFrame") do
                parent = parent.Parent
            end
            if parent then
                parent.ScrollingEnabled = true
            end
        end
    end)
end

-- ID: B2 - O CONSTRUTOR DA JANELA (A FUNÇÃO MESTRA)
function rareLib:Window(Title, IconURL)
    -- Limpa qualquer lixo de UI antiga antes de começar
    if CoreGui:FindFirstChild("RARE_LIB_UI") then CoreGui.RARE_LIB_UI:Destroy() end

    -- Pega as configs salvas
    local Theme = rareLib.Themes[rareLib.Save.Theme]
    local UISizeX, UISizeY = unpack(rareLib.Save.UISize)
    local TabSize = rareLib.Save.TabSize

    -- O container principal que vai na tela do jogador
    local MainGui = Create("ScreenGui", {
        Parent = CoreGui,
        Name = "RARE_LIB_UI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    -- O palácio em si
    local MainFrame = Track(Create("Frame", {
        Parent = MainGui,
        Name = "Hub",
        Size = UDim2.fromOffset(UISizeX, UISizeY),
        Position = UDim2.new(0.5, -UISizeX/2, 0.5, -UISizeY/2),
        BackgroundColor3 = Theme["Color Hub BG"],
        BorderColor3 = Theme["Color Theme"],
        BorderSizePixel = 2,
        ClipsDescendants = true,
        Active = true
    }), "Main")
    Create("UICorner", {Parent = MainFrame, CornerRadius = UDim.new(0, 12)})
    MakeDrag(MainFrame)

    -- Botão fantasma pra abrir/fechar
    local ToggleButton = Create("TextButton", {
        Parent = MainGui,
        Size = UDim2.new(0, 50, 0, 50), 
        Position = UDim2.new(0, 15, 0.5, -25),
        BackgroundColor3 = Theme["Color Theme"],
        Text = "愛",
        Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 32,
    })
    Create("UICorner", {Parent = ToggleButton, CornerRadius = UDim.new(1, 0)})
    Create("UIStroke", {Parent = ToggleButton, Color = Color3.fromRGB(255, 255, 255)})
    ToggleButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
    MakeDrag(ToggleButton)

    -- Padding interno
    Create("UIPadding", {Parent = MainFrame, PaddingLeft=UDim.new(0,10), PaddingRight=UDim.new(0,10), PaddingTop=UDim.new(0,10), PaddingBottom=UDim.new(0,10)})
    
    -- Painel da Esquerda (Navegação)
    local NavContainer = Track(Create("ScrollingFrame", {
        Parent = MainFrame,
        Name = "NavContainer",
        Size = UDim2.new(0, TabSize, 1, 0),
        BackgroundColor3 = Theme["Color Hub BG"],
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = "Y",
        ScrollingDirection = "Y",
        ScrollBarImageColor3 = Theme["Color Theme"],
        ScrollBarThickness = 6
    }), "ScrollBar")
    Create("UICorner", {Parent = NavContainer, CornerRadius = UDim.new(0, 6)})
    Create("UIListLayout", {Parent = NavContainer, Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder})
    Create("UIPadding", {Parent = NavContainer, PaddingTop = UDim.new(0, 10)})
    
    -- Painel da Direita (Ficha RPG)
    local RightPanel = Track(Create("Frame", {
        Parent = MainFrame,
        Name = "RightPanel",
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(1, -200, 0, 0),
        BackgroundColor3 = Theme["Color Panel BG"],
        BorderSizePixel = 0
    }), "Panel")
    Create("UICorner", {Parent = RightPanel, CornerRadius = UDim.new(0, 6)})
    Create("UIPadding", {Parent = RightPanel, PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)})

    -- Painel Central (Conteúdo)
    local ContentPanel = Track(Create("Frame", {
        Parent = MainFrame,
        Name = "ContentPanel",
        Size = UDim2.new(1, -(TabSize + 10 + 200), 1, 0),
        Position = UDim2.new(0, TabSize + 10, 0, 0),
        BackgroundColor3 = Theme["Color Hub BG"],
        BorderSizePixel = 0
    }), "Frame")
    Create("UICorner", {Parent = ContentPanel, CornerRadius = UDim.new(0, 6)})

    -- A API da Janela
    local Window = {
        MainGui = MainGui,
        MainFrame = MainFrame,
        NavContainer = NavContainer,
        ContentPanel = ContentPanel,
        RightPanel = RightPanel,
        Tab = function() end -- Placeholder pra gente preencher depois
    }
    
    -- Retornamos a Window pra gente poder usar ela no final do script
    return Window
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V2 - by RARO XT & DRIP
-- [ ! ] - PARTE 3/20: A SALA DO TRONO
-- ====================================================================================== --

-- ID: C1 - O CONSTRUTOR DA FICHA DE STATUS (O TRONO DO CHEFE)
function rareLib:CreateStatusFicha(Window)
    local RightPanel = Window.RightPanel
    local Theme = rareLib.Themes[rareLib.Save.Theme]
    local LocalPlayer = Players.LocalPlayer

    -- O container da ficha
    local FichaRPG = Create("Frame", {
        Parent = RightPanel,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Name = "FichaRPG"
    })
    
    -- Degradê de fundo vermelho-sangue
    Create("UIGradient", {
        Parent = FichaRPG,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 0, 0))
        }),
        Rotation = 90
    })

    -- Puxa a foto de perfil do jogador. Se falhar, não quebra o script.
    local success, thumbUrl = pcall(Players.GetUserThumbnailAsync, Players, LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180)
    if not success then thumbUrl = "" end -- Se der merda, fica sem imagem mas não cracha

    -- A imagem do perfil, redondinha e com borda
    local AvatarImage = Create("ImageLabel", {
        Parent = FichaRPG,
        Size = UDim2.new(0, 80, 0, 80),
        Position = UDim2.new(0.5, -40, 0, 40),
        BackgroundColor3 = Theme["Color Theme"],
        Image = thumbUrl,
        ScaleType = Enum.ScaleType.Crop,
        BackgroundTransparency = 0.1
    })
    Create("UIAspectRatioConstraint", {Parent = AvatarImage})
    Create("UICorner", {Parent = AvatarImage, CornerRadius = UDim.new(1, 0)})
    Create("UIStroke", {Parent = AvatarImage, Color = Color3.fromRGB(255, 255, 255), Thickness = 2})

    -- Nome do jogador
    local NameLabel = Track(Create("TextLabel", {
        Parent = FichaRPG,
        Size = UDim2.new(1, 0, 0, 25),
        Position = UDim2.new(0, 0, 0, 130),
        Font = Enum.Font.GothamBold,
        Text = LocalPlayer.DisplayName,
        TextColor3 = Theme["Color Text"],
        TextSize = 20,
        BackgroundTransparency = 1
    }), "Text")

    -- Subtítulo
    local SubtitleLabel = Track(Create("TextLabel", {
        Parent = FichaRPG,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 155),
        Font = Enum.Font.Gotham,
        Text = "⛩️ RARE LIB V2",
        TextColor3 = Theme["Color Theme"],
        TextSize = 14,
        BackgroundTransparency = 1
    }), "Theme")

    -- Função pra criar cada linha de status (VIDA, PING, FPS)
    local function CreateStatusRow(name, posY)
        local Row = Create("Frame", {
            Parent = FichaRPG,
            Size = UDim2.new(1, -20, 0, 22),
            Position = UDim2.new(0, 10, 0, posY),
            BackgroundTransparency = 1
        })

        Track(Create("TextLabel", {
            Parent = Row,
            Size = UDim2.new(0.5, 0, 1, 0),
            Font = Enum.Font.GothamBold,
            TextColor3 = Theme["Color Theme"],
            Text = name .. ":",
            TextXAlignment = Enum.TextXAlignment.Left,
            TextSize = 18,
            BackgroundTransparency = 1
        }), "Theme")

        local ValueLabel = Track(Create("TextLabel", {
            Parent = Row,
            Size = UDim2.new(0.5, 0, 1, 0),
            Position = UDim2.new(0.5, 0, 0, 0),
            Font = Enum.Font.Gotham,
            TextColor3 = Theme["Color Text"],
            Text = "...",
            TextXAlignment = Enum.TextXAlignment.Right,
            TextSize = 18,
            BackgroundTransparency = 1
        }), "Text")
        
        return ValueLabel
    end

    local VidaLabel = CreateStatusRow("VIDA", 200)
    local PingLabel = CreateStatusRow("PING", 230)
    local FPSLabel = CreateStatusRow("FPS", 260)

    -- O loop que atualiza os valores em tempo real, rodando em outra thread pra não travar a UI
    task.spawn(function()
        while FichaRPG.Parent do -- Enquanto a ficha existir, o loop roda
            pcall(function()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    VidaLabel.Text = string.format("%d/%d", math.floor(hum.Health), math.floor(hum.MaxHealth))
                else
                    VidaLabel.Text = "N/A"
                end
            end)
            pcall(function()
                PingLabel.Text = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
            end)
            pcall(function()
                FPSLabel.Text = tostring(math.floor(Workspace:GetRealPhysicsFPS()))
            end)
            task.wait(1) -- Atualiza a cada 1 segundo, mais que suficiente
        end
    end)
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V2 - by RARO XT & DRIP
-- [ ! ] - PARTE 4/20: AS ABAS
-- ====================================================================================== --

-- ID: D1 - O CONSTRUTOR DE TABS (OS CORREDORES DO PALÁCIO)
function rareLib:CreateTab(Window, TName, TIcon)
    local Theme = rareLib.Themes[rareLib.Save.Theme]
    
    -- O Botão da Aba na Navegação Esquerda
    local TabButton = Track(Create("TextButton", {
        Parent = Window.NavContainer,
        Name = TName .. "Button",
        Text = "  " .. TName,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        TextSize = 16,
        TextColor3 = Theme["Color Dark Text"],
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        LayoutOrder = #rareLib.Tabs + 1,
        AutoButtonColor = false
    }), "Frame")
    Create("UICorner", {Parent = TabButton, CornerRadius = UDim.new(0, 4)})
    Create("UIStroke", {Parent = TabButton, Color = Theme["Color Stroke"], Thickness = 1, ApplyStrokeMode = "Border"})

    -- O Painel de Conteúdo da Aba no Centro
    local ContentContainer = Create("ScrollingFrame", {
        Parent = Window.ContentPanel,
        Name = TName .. "_Container",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = "Y",
        ScrollingDirection = "Y",
        ScrollBarImageColor3 = Theme["Color Theme"],
        ScrollBarThickness = 6,
        Visible = false -- Começa invisível
    })
    Create("UIListLayout", {Parent = ContentContainer, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder})
    Create("UIPadding", {Parent = ContentContainer, PaddingTop = UDim.new(0, 10), PaddingRight = UDim.new(0, 5)})

    -- A API da Aba
    local Tab = {
        Name = TName,
        Icon = TIcon,
        Container = ContentContainer,
        Button = TabButton,
        AddButton = function() end, -- Placeholders
        AddToggle = function() end,
        AddSlider = function() end,
        AddDropdown = function() end
    }

    local function SelectTab()
        if rareLib.CurrentTab == Tab then return end

        if rareLib.CurrentTab then
            local oldTab = rareLib.CurrentTab
            oldTab.Container.Visible = false
            TweenService:Create(oldTab.Button, TweenInfo.new(0.2), {
                TextColor3 = Theme["Color Dark Text"],
                BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            }):Play()
        end

        Tab.Container.Visible = true
        rareLib.CurrentTab = Tab

        TweenService:Create(Tab.Button, TweenInfo.new(0.2), {
            TextColor3 = Theme["Color Theme"],
            BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        }):Play()
    end

    TabButton.MouseButton1Click:Connect(SelectTab)
    
    table.insert(rareLib.Tabs, Tab)
    
    if #rareLib.Tabs == 1 then
        SelectTab()
    end
    
    return Tab
end

-- ID: D2 - ATUALIZANDO A API DA JANELA
-- Agora que as funções de Ficha e Tab existem, a gente conecta elas na Window
local OriginalWindow = rareLib.Window
function rareLib:Window(Title, IconURL)
    -- Chama a função original pra criar a janela
    local Window = OriginalWindow(self, Title, IconURL)
    
    -- Conecta a função de criar a ficha
    self:CreateStatusFicha(Window)
    
    -- Substitui o placeholder pela função real de criar abas
    Window.Tab = function(TName, TIcon)
        return self:CreateTab(Window, TName, TIcon)
    end
    
    -- Retorna a janela agora completa com as novas funções
    return Window
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V2 - by RARO XT & DRIP
-- [ ! ] - PARTE 5/20: BOTÕES
-- ====================================================================================== --

-- ID: E1 - A BASE DOS COMPONENTES (FRAME DE OPÇÃO)
-- Todos os componentes (botão, slider, etc.) vão usar essa base pra manter o visual padrão.
local function CreateOptionFrame(Container, Title, Description, RightSideWidth)
    local Theme = rareLib.Themes[rareLib.Save.Theme]
    RightSideWidth = RightSideWidth or 0

    local Frame = Track(Create("Frame", {
        Parent = Container,
        Size = UDim2.new(1, 0, 0, 45), -- Aumentei pra 45px pra dar mais respiro, Chefe.
        BackgroundColor3 = Theme["Color Panel BG"],
        Name = "Option",
        LayoutOrder = 1
    }), "Panel")
    Create("UICorner", {Parent = Frame, CornerRadius = UDim.new(0, 6)})
    Create("UIPadding", {Parent = Frame, PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)})
    
    local TitleLabel = Track(Create("TextLabel", {
        Parent = Frame,
        Size = UDim2.new(1, -RightSideWidth, 0, 18),
        Position = UDim2.new(0, 0, 0, 5),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = Title,
        TextColor3 = Theme["Color Text"],
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Name = "Title"
    }), "Text")

    local DescLabel = Track(Create("TextLabel", {
        Parent = Frame,
        Size = UDim2.new(1, -RightSideWidth, 0, 15),
        Position = UDim2.new(0, 0, 0, 23), -- Posição ajustada pra não colar no título
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = Description or "",
        TextColor3 = Theme["Color Dark Text"],
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Visible = Description and #Description > 0 or false,
        Name = "Description"
    }), "DarkText")
    
    return Frame, TitleLabel, DescLabel
end

-- ID: E2 - O CONSTRUTOR DE BOTÕES
function rareLib:CreateButton(Tab, Title, Desc, Callback)
    local Frame, _, _ = CreateOptionFrame(Tab.Container, Title, Desc, 30) -- Reserva 30px pra seta
    
    -- Ícone de seta pra indicar que é clicável
    Create("ImageLabel", {
        Parent = Frame,
        Image = "rbxassetid://10709791437", -- Seta pra direita
        Size = UDim2.new(0, 15, 0, 15),
        Position = UDim2.new(1, -22, 0.5, -7.5),
        BackgroundTransparency = 1
    })
    
    -- O botão invisível que cobre o frame todo
    local Button = Create("TextButton", {
        Parent = Frame,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false
    })
    
    Button.MouseButton1Click:Connect(function()
        pcall(Callback)
        -- Animação de clique pra dar feedback visual
        TweenService:Create(Frame.BackgroundColor3, TweenInfo.new(0.1), {Value = Color3.fromRGB(40,40,40)}):Play()
        task.wait(0.1)
        TweenService:Create(Frame.BackgroundColor3, TweenInfo.new(0.1), {Value = rareLib.Themes.BloodMoon["Color Panel BG"]}):Play()
    end)
    
    local ButtonAPI = {
        Frame = Frame,
        Callback = Button.MouseButton1Click
    }
    return ButtonAPI
end

-- ID: E3 - ATUALIZANDO A API DA ABA
-- Agora a gente conecta o construtor de botões na função da aba.
local OriginalTab = rareLib.CreateTab
function rareLib:CreateTab(Window, TName, TIcon)
    local Tab = OriginalTab(self, Window, TName, TIcon)
    
    Tab.AddButton = function(Title, Desc, Callback)
        return self:CreateButton(Tab, Title, Desc, Callback)
    end
    
    return Tab
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V2 - by RARO XT & DRIP
-- [ ! ] - PARTE 6/20: TOGGLES
-- ====================================================================================== --

-- ID: F1 - O CONSTRUTOR DE TOGGLES
function rareLib:CreateToggle(Tab, Title, Desc, InitialValue, Callback)
    local Theme = rareLib.Themes[rareLib.Save.Theme]
    local Frame, _, _ = CreateOptionFrame(Tab.Container, Title, Desc, 40) -- Reserva 40px pro switch
    local state = InitialValue or false
    
    local ToggleButton = Create("TextButton", {
        Parent = Frame,
        Name = "Switch",
        Size = UDim2.new(0, 35, 0, 20),
        Position = UDim2.new(1, -40, 0.5, -10),
        BackgroundColor3 = Theme["Color Stroke"],
        Text = "", 
        AutoButtonColor = false
    })
    Create("UICorner", {Parent = ToggleButton, CornerRadius = UDim.new(1, 0)})
    
    local Knob = Track(Create("Frame", {
        Parent = ToggleButton,
        Name = "Knob",
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 2, 0.5, -8),
        BackgroundColor3 = Theme["Color Dark Text"],
        BorderSizePixel = 0
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
            TweenService:Create(Knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = targetPos}):Play()
            TweenService:Create(Knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = targetColor}):Play()
        end
    end
    
    local function Toggle()
        UpdateKnob(not state)
        pcall(Callback, not state)
    end
    
    ToggleButton.MouseButton1Click:Connect(Toggle)
    
    UpdateKnob(state, true) -- Seta a posição inicial sem animação
    
    local ToggleAPI = {
        Frame = Frame,
        Toggle = Toggle,
        SetState = function(newState) 
            if newState ~= state then
                UpdateKnob(newState)
                pcall(Callback, newState)
            end
        end,
        GetState = function()
            return state
        end
    }

    return ToggleAPI
end

-- ID: F2 - ATUALIZANDO A API DA ABA
local OriginalTab_F = rareLib.CreateTab
function rareLib:CreateTab(Window, TName, TIcon)
    local Tab = OriginalTab_F(self, Window, TName, TIcon)
    
    Tab.AddToggle = function(Title, Desc, InitialValue, Callback)
        return self:CreateToggle(Tab, Title, Desc, InitialValue, Callback)
    end
    
    return Tab
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V2 - by RARO XT & DRIP
-- [ ! ] - PARTE 7/20: SLIDERS
-- ====================================================================================== --

-- ID: G1 - O CONSTRUTOR DE SLIDERS
function rareLib:CreateSlider(Tab, Title, Desc, Min, Max, Default, Callback)
    local Theme = rareLib.Themes[rareLib.Save.Theme]
    local Frame, _, _ = CreateOptionFrame(Tab.Container, Title, Desc, 120)
    local CurrentValue = Default or Min
    
    local SliderHolder = Create("Frame", {
        Parent = Frame,
        Size = UDim2.new(0, 110, 0, 20),
        Position = UDim2.new(1, -115, 0.5, -10),
        BackgroundTransparency = 1
    })

    local SliderBar = Track(Create("Frame", {
        Parent = SliderHolder,
        Name = "SliderBar",
        BackgroundColor3 = Theme["Color Stroke"],
        Size = UDim2.new(1, -30, 0, 6),
        Position = UDim2.new(0, 0, 0.5, -3),
        AnchorPoint = Vector2.new(0, 0.5)
    }), "Stroke")
    Create("UICorner", {Parent = SliderBar, CornerRadius = UDim.new(1, 0)})

    local Indicator = Track(Create("Frame", {
        Parent = SliderBar,
        Name = "Indicator",
        BackgroundColor3 = Theme["Color Theme"],
        Size = UDim2.fromScale(0, 1),
        BorderSizePixel = 0
    }), "Theme")
    Create("UICorner", {Parent = Indicator, CornerRadius = UDim.new(1, 0)})

    local Knob = Create("Frame", {
        Parent = SliderBar,
        Name = "Knob",
        Size = UDim2.new(0, 14, 0, 14),
        BackgroundColor3 = Theme["Color Text"],
        Position = UDim2.fromScale(0, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0
    }, {
        Create("UICorner", {Parent = _, CornerRadius = UDim.new(1, 0)})
    })

    local ValueLabel = Track(Create("TextLabel", {
        Parent = SliderHolder,
        Name = "ValueLabel",
        Text = tostring(math.floor(CurrentValue)),
        Size = UDim2.new(0, 30, 1, 0),
        Position = UDim2.new(1, -30, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme["Color Text"],
        TextSize = 14
    }), "Text")

    local function UpdateSlider(NewValue, isInstant)
        CurrentValue = math.clamp(NewValue, Min, Max)
        local percentage = (CurrentValue - Min) / (Max - Min)
        
        ValueLabel.Text = string.format("%.0f", CurrentValue)
        
        if isInstant then
            Knob.Position = UDim2.fromScale(percentage, 0.5)
            Indicator.Size = UDim2.fromScale(percentage, 1)
        else
            TweenService:Create(Knob, TweenInfo.new(0.1), {Position = UDim2.fromScale(percentage, 0.5)}):Play()
            TweenService:Create(Indicator, TweenInfo.new(0.1), {Size = UDim2.fromScale(percentage, 1)}):Play()
        end
        
        pcall(Callback, CurrentValue)
    end

    local Dragger = Create("TextButton", {
        Parent = SliderBar,
        Size = UDim2.new(1, 0, 3, 0), -- Área de arrasto maior que a barra visual
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Text = ""
    })

    local isDragging = false
    Dragger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            Tab.Container.ScrollingEnabled = false
            
            local percentage = (input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X
            local newValue = math.floor((percentage * (Max - Min)) + Min + 0.5)
            UpdateSlider(newValue)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local percentage = (input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X
            percentage = math.clamp(percentage, 0, 1)
            local newValue = math.floor((percentage * (Max - Min)) + Min + 0.5)
            UpdateSlider(newValue)
        end
    end)

    Dragger.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
            Tab.Container.ScrollingEnabled = true
        end
    end)
    
    UpdateSlider(Default, true) -- Seta o valor inicial

    local SliderAPI = {
        Frame = Frame,
        SetValue = function(newValue)
            UpdateSlider(newValue)
        end,
        GetValue = function()
            return CurrentValue
        end
    }

    return SliderAPI
end

-- ID: G2 - ATUALIZANDO A API DA ABA
local OriginalTab_G = rareLib.CreateTab
function rareLib:CreateTab(Window, TName, TIcon)
    local Tab = OriginalTab_G(self, Window, TName, TIcon)
    
    Tab.AddSlider = function(Title, Desc, Min, Max, Default, Callback)
        return self:CreateSlider(Tab, Title, Desc, Min, Max, Default, Callback)
    end
    
    return Tab
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V2 - by RARO XT & DRIP
-- [ ! ] - PARTE 8/20: DROPDOWNS
-- ====================================================================================== --

-- ID: H1 - O CONSTRUTOR DE DROPDOWNS
function rareLib:CreateDropdown(Window, Tab, Title, Desc, Options, DefaultOption, Callback)
    local Theme = rareLib.Themes[rareLib.Save.Theme]
    local Frame, _, _ = CreateOptionFrame(Tab.Container, Title, Desc, 140)
    local SelectedValue = DefaultOption or Options[1]
    local DropdownVisible = false

    local DropdownButton = Track(Create("TextButton", {
        Parent = Frame,
        Size = UDim2.new(0, 130, 0, 22),
        Position = UDim2.new(1, -135, 0.5, -11),
        BackgroundColor3 = Theme["Color Stroke"],
        Text = "",
        AutoButtonColor = false
    }), "Stroke")
    Create("UICorner", {Parent = DropdownButton, CornerRadius = UDim.new(0, 4)})

    local Label = Track(Create("TextLabel", {
        Parent = DropdownButton,
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

    local Arrow = Create("ImageLabel", {
        Parent = DropdownButton,
        Image = "rbxassetid://10709791523", -- Chevron Up
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(1, -15, 0.5, -6),
        BackgroundTransparency = 1
    })
    
    local Overlay = Create("Frame", {
        Parent = Window.MainGui,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 3,
        Visible = false
    })
    
    local ListPanel = Track(Create("ScrollingFrame", {
        Parent = Overlay,
        Size = UDim2.new(0, 130, 0, 1),
        BackgroundColor3 = Theme["Color Hub BG"],
        BorderColor3 = Theme["Color Theme"],
        BorderSizePixel = 2,
        ZIndex = 4,
        ScrollBarImageColor3 = Theme["Color Theme"],
        ScrollBarThickness = 6,
        AutomaticCanvasSize = "Y",
        ScrollingDirection = "Y",
        ClipsDescendants = true
    }, {
        Create("UICorner", {Parent = _, CornerRadius = UDim.new(0, 4)}),
        Create("UIListLayout", {Parent = _, Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder}),
        Create("UIPadding", {Parent = _, PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5)})
    }), "ScrollBar")
    
    local function UpdateListPanelPosition()
        local pos = DropdownButton.AbsolutePosition
        local listHeight = ListPanel.CanvasSize.Y.Offset + 10 -- Padding
        local targetHeight = math.min(listHeight, 200)

        local x = pos.X
        local y = pos.Y + DropdownButton.AbsoluteSize.Y
        
        local ScreenH = Window.MainGui.AbsoluteSize.Y
        if y + targetHeight > ScreenH and pos.Y - targetHeight > 0 then
            y = pos.Y - targetHeight
        end
        
        ListPanel.Position = UDim2.fromOffset(x, y)
    end
    
    local function ToggleDropdown()
        DropdownVisible = not DropdownVisible
        Overlay.Visible = DropdownVisible
        
        if DropdownVisible then
            UpdateListPanelPosition()
            local listHeight = ListPanel.CanvasSize.Y.Offset + 10
            local targetHeight = math.min(listHeight, 200)
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
            Parent = ListPanel,
            Size = UDim2.new(1, 0, 0, 22),
            BackgroundColor3 = Theme["Color Hub BG"],
            Text = "  " .. option,
            Font = Enum.Font.Gotham,
            TextColor3 = Theme["Color Text"],
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false
        }), "Frame")
        
        optButton.MouseEnter:Connect(function() optButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30) end)
        optButton.MouseLeave:Connect(function() optButton.BackgroundColor3 = Theme["Color Hub BG"] end)
        optButton.MouseButton1Click:Connect(function() SelectOption(option) end)
    end
    
    DropdownButton.MouseButton1Click:Connect(ToggleDropdown)
    Overlay.MouseButton1Down:Connect(function() if DropdownVisible then ToggleDropdown() end end)

    local DropdownAPI = {
        Frame = Frame,
        SetValue = SelectOption,
        GetValue = function() return SelectedValue end
    }
    return DropdownAPI
end

-- ID: H2 - ATUALIZANDO A API DA ABA
local OriginalTab_H = rareLib.CreateTab
function rareLib:CreateTab(Window, TName, TIcon)
    local Tab = OriginalTab_H(self, Window, TName, TIcon)
    
    Tab.AddDropdown = function(Title, Desc, Options, DefaultOption, Callback)
        return self:CreateDropdown(Window, Tab, Title, Desc, Options, DefaultOption, Callback)
    end
    
    return Tab
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V2 - by RARO XT & DRIP
-- [ ! ] - PARTE 9/20: TEXTBOXES
-- ====================================================================================== --

-- ID: I1 - O CONSTRUTOR DE TEXTBOXES
function rareLib:CreateTextbox(Tab, Title, Desc, Placeholder, Callback)
    local Theme = rareLib.Themes[rareLib.Save.Theme]
    local Frame, _, _ = CreateOptionFrame(Tab.Container, Title, Desc, 140)

    local TextboxFrame = Track(Create("Frame", {
        Parent = Frame,
        Size = UDim2.new(0, 130, 0, 22),
        Position = UDim2.new(1, -135, 0.5, -11),
        BackgroundColor3 = Theme["Color Stroke"],
    }), "Stroke")
    Create("UICorner", {Parent = TextboxFrame, CornerRadius = UDim.new(0, 4)})

    local Pencil = Create("ImageLabel", {
        Parent = TextboxFrame,
        Image = "rbxassetid://15637081879", -- Ícone de lápis que você usou
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(1, -15, 0.5, -6),
        BackgroundTransparency = 1,
        ImageColor3 = Theme["Color Dark Text"]
    })

    local Textbox = Track(Create("TextBox", {
        Parent = TextboxFrame,
        Size = UDim2.new(1, -25, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme["Color Text"],
        Text = "",
        PlaceholderText = Placeholder or "Digite aqui...",
        PlaceholderColor3 = Theme["Color Dark Text"],
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false
    }), "Text")

    Textbox.FocusGained:Connect(function()
        TweenService:Create(Pencil, TweenInfo.new(0.2), {ImageColor3 = Theme["Color Theme"]}):Play()
        TweenService:Create(TextboxFrame, TweenInfo.new(0.2), {BorderColor3 = Theme["Color Theme"], BorderSizePixel = 1}):Play()
    end)
    
    Textbox.FocusLost:Connect(function(enterPressed)
        TweenService:Create(Pencil, TweenInfo.new(0.2), {ImageColor3 = Theme["Color Dark Text"]}):Play()
        TweenService:Create(TextboxFrame, TweenInfo.new(0.2), {BorderColor3 = Color3.fromRGB(0,0,0), BorderSizePixel = 0}):Play()
        if enterPressed then
            pcall(Callback, Textbox.Text)
        end
    end)
    
    local TextboxAPI = {
        Frame = Frame,
        SetText = function(newText) Textbox.Text = newText end,
        GetText = function() return Textbox.Text end,
        OnEnter = function(newCallback)
            -- Remove a conexão antiga pra não ter duas
            Textbox.FocusLost:Connect(function(enterPressed)
                if enterPressed then pcall(newCallback, Textbox.Text) end
            end)
        end
    }

    return TextboxAPI
end

-- ID: I2 - ATUALIZANDO A API DA ABA
local OriginalTab_I = rareLib.CreateTab
function rareLib:CreateTab(Window, TName, TIcon)
    local Tab = OriginalTab_I(self, Window, TName, TIcon)
    
    Tab.AddTextbox = function(Title, Desc, Placeholder, Callback)
        return self:CreateTextbox(Tab, Title, Desc, Placeholder, Callback)
    end
    
    return Tab
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V2 - by RARO XT & DRIP
-- [ ! ] - PARTE 10/20: A CONSTELAÇÃO
-- ====================================================================================== --

-- ID: J1 - O CONSTRUTOR DO EFEITO DE PARTÍCULAS
function rareLib:CreateConstellation(Window)
    local Theme = rareLib.Themes[rareLib.Save.Theme]
    local MainFrame = Window.MainFrame

    local particleFrame = Create("Frame", {
        Parent = MainFrame,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 0 -- Fica atrás de tudo
    })
    
    local particles = {}
    local lines = {}
    local numParticles = 35
    local connectDistance = 100

    -- Cria as partículas iniciais
    for i = 1, numParticles do
        local p = Create("Frame", {
            Parent = particleFrame,
            Size = UDim2.new(0, 3, 0, 3),
            BackgroundColor3 = Theme["Color Theme"],
            BorderSizePixel = 0
        })
        Create("UICorner", {Parent = p, CornerRadius = UDim.new(1, 0)})
        
        table.insert(particles, {
            gui = p,
            pos = Vector2.new(math.random(0, MainFrame.AbsoluteSize.X), math.random(0, MainFrame.AbsoluteSize.Y)),
            vel = Vector2.new(math.random(-20, 20), math.random(-20, 20))
        })
    end

    -- O loop que anima tudo
    RunService.RenderStepped:Connect(function(dt)
        if not MainFrame or not MainFrame.Parent then return end -- Se a UI fechar, para de rodar

        -- Limpa as linhas antigas
        for _, line in ipairs(lines) do
            line:Destroy()
        end
        lines = {}
        
        local size = MainFrame.AbsoluteSize
        if size.X == 0 or size.Y == 0 then return end -- Não roda se a UI estiver invisível

        -- Atualiza a posição de cada partícula
        for i, p1 in ipairs(particles) do
            p1.pos = p1.pos + p1.vel * dt
            
            -- Lógica pra quicar nas bordas
            if p1.pos.X < 0 or p1.pos.X > size.X then p1.vel = Vector2.new(-p1.vel.X, p1.vel.Y) end
            if p1.pos.Y < 0 or p1.pos.Y > size.Y then p1.vel = Vector2.new(p1.vel.X, -p1.vel.Y) end
            
            p1.gui.Position = UDim2.fromOffset(p1.pos.X, p1.pos.Y)
            
            -- Lógica pra criar as linhas de conexão
            for j = i + 1, #particles do
                local p2 = particles[j]
                local dist = (p1.pos - p2.pos).Magnitude
                
                if dist < connectDistance then
                    local line = Create("Frame", {
                        Parent = particleFrame,
                        Size = UDim2.new(0, dist, 0, 1),
                        Position = UDim2.fromOffset((p1.pos.X + p2.pos.X) / 2, (p1.pos.Y + p2.pos.Y) / 2),
                        Rotation = math.deg(math.atan2(p2.pos.Y - p1.pos.Y, p2.pos.X - p1.pos.X)),
                        BackgroundColor3 = Theme["Color Theme"],
                        BackgroundTransparency = 1 - (1 - dist / connectDistance) * 0.8,
                        BorderSizePixel = 0,
                        ZIndex = 0
                    })
                    table.insert(lines, line)
                end
            end
        end
    end)
end


-- ID: J2 - ATUALIZANDO A API DA JANELA
local OriginalWindow_J = rareLib.Window
function rareLib:Window(Title, IconURL)
    local Window = OriginalWindow_J(self, Title, IconURL)
    
    -- Chama o construtor da constelação
    self:CreateConstellation(Window)
    
    return Window
end
-- ====================================================================================== --
-- [ 🐉 ] - RARE LIB V2 - by RARO XT & DRIP
-- [ ! ] - PARTE 11/20: O PACOTE FINAL
-- ====================================================================================== --

-- ID: K1 - O FIM DA LIB, RETORNANDO A TABELA
-- Essa é a última linha da NOSSA LIB. Tudo abaixo será o script do USUÁRIO.
return rareLib
