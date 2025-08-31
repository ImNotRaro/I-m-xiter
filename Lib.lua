-- NeverwinGUI Library
local NeverwinGUI = {}

-- Dependências
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

--[[
Função para criar a janela principal do GUI.
Retorna: gui (ScreenGui) e main (frame principal de conteúdo, ScrollingFrame).
Uso: local gui, main = NeverwinGUI.CreateWindow({Name="NEVERWIN_UI"})
]]
function NeverwinGUI.CreateWindow(config)
    config = config or {}
    local name = config.Name or "NeverwinUI"
    -- Criar o ScreenGui
    local gui = Instance.new("ScreenGui")
    gui.Name = name
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    -- Frame principal (ScrollingFrame para permitir rolagem)
    local main = Instance.new("ScrollingFrame", gui)
    main.Name = "NeverwinMainFrame"
    main.Size = UDim2.new(0, 620, 0, 360)
    main.Position = UDim2.new(0.5, -310, 0.5, -180)
    main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    main.BorderSizePixel = 2
    main.BorderColor3 = Color3.fromRGB(255, 255, 255)
    main.Active = true
    main.Draggable = true
    main.ClipsDescendants = true
    main.AutomaticCanvasSize = Enum.AutomaticSize.Y
    main.ScrollBarThickness = 6
    main.ScrollBarImageColor3 = Color3.fromRGB(139, 0, 0)
    -- Arredondar cantos
    local mainCorner = Instance.new("UICorner", main)
    mainCorner.CornerRadius = UDim.new(0, 12)
    -- Padding interno
    local mainPadding = Instance.new("UIPadding", main)
    mainPadding.PaddingLeft = UDim.new(0, 10)
    mainPadding.PaddingRight = UDim.new(0, 10)
    mainPadding.PaddingTop = UDim.new(0, 10)
    mainPadding.PaddingBottom = UDim.new(0, 10)
    -- Layout para organizar seções verticalmente
    local mainLayout = Instance.new("UIListLayout", main)
    mainLayout.SortOrder = Enum.SortOrder.LayoutOrder
    mainLayout.Padding = UDim.new(0, 5)

    -- Guardar referência do GUI, útil para dropdown se necessário
    NeverwinGUI._RootGui = gui

    return gui, main
end

-- Função para criar uma seção (selção) dentro do GUI.
-- parent: frame principal de conteúdo (o 'main' retornado em CreateWindow).
-- text: título da seção.
-- Retorna: container da seção e o frame de itens (onde serão adicionados toggles, sliders, etc).
function NeverwinGUI.CreateSelection(parent, text)
    -- Container da seção
    local container = Instance.new("Frame", parent)
    container.Name = text .. "_Section"
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    -- Layout interno para título e itens
    local layout = Instance.new("UIListLayout", container)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    -- Label do título
    local title = Instance.new("TextLabel", container)
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = "< 爱 > • " .. (text or "")
    title.TextColor3 = Color3.fromRGB(139, 0, 0)
    title.TextSize = 20
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.LayoutOrder = 1

    -- Frame para itens (toggles, sliders, etc)
    local itemsFrame = Instance.new("Frame", container)
    itemsFrame.Name = text .. "_Items"
    itemsFrame.BackgroundTransparency = 1
    itemsFrame.Size = UDim2.new(1, 0, 0, 0)
    itemsFrame.AutomaticSize = Enum.AutomaticSize.Y
    itemsFrame.LayoutOrder = 2
    -- Layout vertical para itens da seção
    local itemsLayout = Instance.new("UIListLayout", itemsFrame)
    itemsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    itemsLayout.Padding = UDim.new(0, 5)

    return container, itemsFrame
end

-- Função para adicionar um toggle (checkbox) dentro de um frame pai.
-- parent: frame (geralmente o 'itemsFrame' de uma seção).
-- options: tabela com keys Text (string), Initial (boolean), Callback (function).
function NeverwinGUI.AddToggle(parent, options)
    options = options or {}
    local text = options.Text or ""
    local state = options.Initial or false
    local callback = options.Callback

    -- Container do toggle
    local frame = Instance.new("Frame", parent)
    frame.Name = text .. "_Toggle"
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, 0, 0, 25)

    -- Label do texto do toggle
    local label = Instance.new("TextLabel", frame)
    label.Name = "Label"
    label.Size = UDim2.new(0.8, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = text or ""
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left

    -- Botão/interruptor
    local switch = Instance.new("TextButton", frame)
    switch.Name = "Switch"
    switch.Size = UDim2.new(0.2, 0, 1, 0)
    switch.Position = UDim2.new(0.8, 0, 0, 0)
    switch.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    switch.Text = ""
    switch.AutoButtonColor = false
    local corner = Instance.new("UICorner", switch)
    corner.CornerRadius = UDim.new(1, 0)
    -- Traço branco no switch (estilo)
    local stroke = Instance.new("UIStroke", switch)
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 1

    -- Pino do toggle
    local knob = Instance.new("Frame", switch)
    knob.Name = "Knob"
    knob.Size = UDim2.new(0.4, 0, 0.8, 0)
    knob.Position = UDim2.new(0.05, 0, 0.1, 0)
    knob.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    knob.BorderSizePixel = 0
    local knobCorner = Instance.new("UICorner", knob)
    knobCorner.CornerRadius = UDim.new(1, 0)

    -- Configurar estado inicial
    if state then
        knob.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
        knob.Position = UDim2.new(0.55, 0, 0.1, 0)
    end

    -- Função para alternar o estado
    switch.MouseButton1Click:Connect(function()
        state = not state
        if state then
            knob.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
            knob.Position = UDim2.new(0.55, 0, 0.1, 0)
        else
            knob.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
            knob.Position = UDim2.new(0.05, 0, 0.1, 0)
        end
        if callback then
            callback(state)
        end
    end)
end

-- Função para adicionar um slider (barra de seleção numérica).
-- parent: frame (geralmente 'itemsFrame').
-- options: tabela com keys Text, Min, Max, Value, Callback.
function NeverwinGUI.AddSlide(parent, options)
    options = options or {}
    local text = options.Text or ""
    local minVal = options.Min or 0
    local maxVal = options.Max or 100
    local value = options.Value or minVal
    local callback = options.Callback

    -- Container do slider
    local frame = Instance.new("Frame", parent)
    frame.Name = text .. "_Slider"
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, 0, 0, 30)

    -- Label do texto do slider
    local label = Instance.new("TextLabel", frame)
    label.Name = "Label"
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = text or ""
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left

    -- Track do slider
    local track = Instance.new("Frame", frame)
    track.Name = "Track"
    track.Size = UDim2.new(0.5, 0, 0, 6)
    track.Position = UDim2.new(0.45, 0, 0.5, 0)
    track.AnchorPoint = Vector2.new(0.5, 0.5)
    track.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    local trackCorner = Instance.new("UICorner", track)
    trackCorner.CornerRadius = UDim.new(0, 3)

    -- Knob do slider
    local knob = Instance.new("Frame", track)
    knob.Name = "Knob"
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    -- Calcula posição inicial do knob com base em 'value'
    local relative = (value - minVal) / (maxVal - minVal)
    knob.Position = UDim2.new(relative, 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
    local knobCorner = Instance.new("UICorner", knob)
    knobCorner.CornerRadius = UDim.new(1, 0)

    local dragging = false
    local function updateValue(input)
        local pos = input.Position.X
        local trackPos = track.AbsolutePosition.X
        local trackSize = track.AbsoluteSize.X
        local rel = (pos - trackPos) / trackSize
        rel = math.clamp(rel, 0, 1)
        knob.Position = UDim2.new(rel, 0, 0.5, 0)
        local newVal = minVal + rel * (maxVal - minVal)
        newVal = math.floor(newVal)
        if callback then
            callback(newVal)
        end
    end

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    knob.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            if callback then
                local finalVal = math.floor(minVal + (knob.Position.X.Scale * (maxVal - minVal)))
                callback(finalVal)
            end
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateValue(input)
        end
    end)
end

-- Função para adicionar um dropdown (lista de seleção).
-- parent: frame (geralmente 'itemsFrame').
-- options: tabela com keys Text, Items (tabela de strings), Callback.
function NeverwinGUI.AddDropdown(parent, options)
    options = options or {}
    local text = options.Text or ""
    local items = options.Items or {}
    local callback = options.Callback

    -- Container do dropdown
    local frame = Instance.new("Frame", parent)
    frame.Name = text .. "_Dropdown"
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, 0, 0, 25)

    -- Label do texto do dropdown
    local label = Instance.new("TextLabel", frame)
    label.Name = "Label"
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = text or ""
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left

    -- Botão do dropdown (metade direita)
    local dropButton = Instance.new("TextButton", frame)
    dropButton.Name = "DropButton"
    dropButton.Size = UDim2.new(0.6, 0, 1, 0)
    dropButton.Position = UDim2.new(0.4, 0, 0, 0)
    dropButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    dropButton.Text = ""
    dropButton.AutoButtonColor = false
    local dropCorner = Instance.new("UICorner", dropButton)
    dropCorner.CornerRadius = UDim.new(0, 4)
    local dropStroke = Instance.new("UIStroke", dropButton)
    dropStroke.Color = Color3.fromRGB(255, 255, 255)
    dropStroke.Thickness = 1

    -- Label do item selecionado
    local selectedLabel = Instance.new("TextLabel", dropButton)
    selectedLabel.Name = "Selected"
    selectedLabel.AnchorPoint = Vector2.new(0, 0.5)
    selectedLabel.Position = UDim2.new(0.05, 0, 0.5, 0)
    selectedLabel.Size = UDim2.new(0.9, 0, 0.8, 0)
    selectedLabel.BackgroundTransparency = 1
    selectedLabel.Font = Enum.Font.Gotham
    selectedLabel.Text = items[1] or ""
    selectedLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    selectedLabel.TextSize = 16
    selectedLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Ícone seta
    local arrow = Instance.new("TextLabel", dropButton)
    arrow.Name = "Arrow"
    arrow.AnchorPoint = Vector2.new(1, 0.5)
    arrow.Position = UDim2.new(0.98, 0, 0.5, 0)
    arrow.Size = UDim2.new(0, 16, 0, 16)
    arrow.BackgroundTransparency = 1
    arrow.Font = Enum.Font.Gotham
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(200, 200, 200)
    arrow.TextSize = 16
    arrow.TextXAlignment = Enum.TextXAlignment.Center

    -- Lista de opções
    local listFrame = Instance.new("Frame", parent)
    listFrame.Name = text .. "_DropList"
    listFrame.Size = UDim2.new(1, 0, 0, 0)
    listFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    listFrame.BorderSizePixel = 0
    listFrame.ClipsDescendants = true
    listFrame.Visible = false
    local listCorner = Instance.new("UICorner", listFrame)
    listCorner.CornerRadius = UDim.new(0, 4)
    local listLayout = Instance.new("UIListLayout", listFrame)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 2)
    listFrame.AutomaticSize = Enum.AutomaticSize.Y

    -- Preencher lista com opções
    for i, v in ipairs(items) do
        local itemBtn = Instance.new("TextButton", listFrame)
        itemBtn.Name = "Option_"..i
        itemBtn.BackgroundTransparency = 1
        itemBtn.Size = UDim2.new(1, 0, 0, 20)
        itemBtn.Font = Enum.Font.Gotham
        itemBtn.Text = v
        itemBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        itemBtn.TextSize = 16
        itemBtn.TextXAlignment = Enum.TextXAlignment.Left
        itemBtn.LayoutOrder = i
        itemBtn.MouseButton1Click:Connect(function()
            selectedLabel.Text = v
            listFrame.Visible = false
            arrow.Text = "▼"
            if callback then
                callback(v)
            end
        end)
    end

    -- Evento de clique do botão dropdown
    dropButton.MouseButton1Click:Connect(function()
        listFrame.Visible = not listFrame.Visible
        arrow.Text = listFrame.Visible and "▲" or "▼"
    end)
end

-- Função para adicionar um texto simples (label informativo).
-- parent: frame (geralmente 'itemsFrame').
-- options: tabela com keys Text, Size (número), Color (Color3).
function NeverwinGUI.AddText(parent, options)
    options = options or {}
    local text = options.Text or ""
    local size = options.Size or 16
    local color = options.Color or Color3.fromRGB(255, 255, 255)

    local frame = Instance.new("Frame", parent)
    frame.Name = "Text_"..tostring(text)
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, 0, 0, size + 6)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = color
    label.TextSize = size
    label.TextXAlignment = Enum.TextXAlignment.Center
    return frame
end

return NeverwinGUI
