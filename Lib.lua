
local NeverwinGUI = {}

-- Dependências
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local Debris = game:GetService("Debris")
local vim = game:GetService("VirtualInputManager")
local camera = Workspace.CurrentCamera

NeverwinGUI.Services = {
    Players = Players,
    LocalPlayer = LocalPlayer,
    CoreGui = CoreGui,
    RunService = RunService,
    TweenService = TweenService,
    UserInputService = UserInputService,
    ReplicatedStorage = ReplicatedStorage,
    Workspace = Workspace,
    TeleportService = TeleportService,
    Debris = Debris,
    vim = vim,
    camera = camera,
}

-- Destroy antiga UI se existir
function NeverwinGUI.DestroyOld(name)
    if CoreGui:FindFirstChild(name) then
        CoreGui[name]:Destroy()
    end
end

-- Cria GUI principal
function NeverwinGUI.CreateWindow(opts)
    opts = opts or {}
    local winName = opts.Name or "NeverwinUI"
    local size = opts.Size or UDim2.new(0, 620, 0, 360)
    local pos = opts.Position or UDim2.new(0.5, -310, 0.5, -180)

    NeverwinGUI.DestroyOld(winName)

    local gui = Instance.new("ScreenGui")
    gui.Name = winName
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    local main = Instance.new("Frame", gui)
    main.Name = "MainFrame"
    main.Size = size
    main.Position = pos
    main.BackgroundColor3 = Color3.fromRGB(0,0,0)
    main.BorderSizePixel = 2
    main.BorderColor3 = Color3.fromRGB(255,255,255)
    main.Active = true
    main.Draggable = true
    main.ClipsDescendants = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
    local mainPadding = Instance.new("UIPadding", main)
    mainPadding.PaddingLeft = UDim.new(0,10)
    mainPadding.PaddingRight = UDim.new(0,10)
    mainPadding.PaddingTop = UDim.new(0,10)
    mainPadding.PaddingBottom = UDim.new(0,10)

    return gui, main
end

-- Cria seleção (título + área de itens)
function NeverwinGUI.CreateSelection(parent, text)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, 0, 0, 60) -- Espaço extra para título e itens
    container.BackgroundTransparency = 1

    local title = Instance.new("TextLabel", container)
    title.Name = "SelectionTitle"
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0,0,0,0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = text
    title.TextColor3 = Color3.fromRGB(139,0,0)
    title.TextSize = 20
    title.TextXAlignment = Enum.TextXAlignment.Left

    local itemsFrame = Instance.new("Frame", container)
    itemsFrame.Name = "ItemsFrame"
    itemsFrame.BackgroundTransparency = 1
    itemsFrame.Size = UDim2.new(1,0,0,30)
    itemsFrame.Position = UDim2.new(0,0,0,30)
    -- Layout para os itens
    local layout = Instance.new("UIListLayout", itemsFrame)
    layout.Padding = UDim.new(0, 5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    return container, itemsFrame
end

-- Função universal para Toggle
function NeverwinGUI.AddToggle(parent, opts)
    opts = opts or {}
    local text = opts.Text or "Toggle"
    local initial = opts.Initial or false
    local callback = opts.Callback

    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 25)
    frame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.8, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200,200,200)
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left

    local switch = Instance.new("TextButton", frame)
    switch.Size = UDim2.new(0.2, 0, 1, 0)
    switch.Position = UDim2.new(0.8, 0, 0, 0)
    switch.BackgroundColor3 = Color3.fromRGB(50,50,55)
    switch.Text = ""
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1,0)

    local knob = Instance.new("Frame", switch)
    knob.Size = UDim2.new(0.4, 0, 0.8, 0)
    knob.Position = initial and UDim2.new(0.55,0,0.1,0) or UDim2.new(0.05,0,0.1,0)
    knob.BackgroundColor3 = initial and Color3.fromRGB(139,0,0) or Color3.fromRGB(150,150,150)
    knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

    local state = initial
    switch.MouseButton1Click:Connect(function()
        state = not state
        knob.Position = state and UDim2.new(0.55,0,0.1,0) or UDim2.new(0.05,0,0.1,0)
        knob.BackgroundColor3 = state and Color3.fromRGB(139,0,0) or Color3.fromRGB(150,150,150)
        if callback then callback(state) end
    end)
    return frame
end

-- Slider
function NeverwinGUI.AddSlide(parent, opts)
    opts = opts or {}
    local text = opts.Text or "Slide"
    local min = opts.Min or 0
    local max = opts.Max or 100
    local value = opts.Value or min
    local callback = opts.Callback

    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = text .. ": " .. tostring(value)
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left

    local slider = Instance.new("Frame", frame)
    slider.Size = UDim2.new(0.5, -10, 0, 10)
    slider.Position = UDim2.new(0.5, 10, 0.5, -5)
    slider.BackgroundColor3 = Color3.fromRGB(139,0,0)
    Instance.new("UICorner",slider).CornerRadius = UDim.new(1,0)

    local knob = Instance.new("Frame", slider)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new((value-min)/(max-min),-7,0.5,-7)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner",knob).CornerRadius = UDim.new(1,0)

    -- Interação básica
    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local conn
            conn = UserInputService.InputChanged:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseMovement then
                    local rel = inp.Position.X - slider.AbsolutePosition.X
                    local pct = math.clamp(rel/slider.AbsoluteSize.X, 0, 1)
                    value = math.floor(min + (max-min)*pct)
                    knob.Position = UDim2.new(pct,-7,0.5,-7)
                    label.Text = text .. ": " .. tostring(value)
                    if callback then callback(value) end
                end
            end)
            input.Changed:Connect(function(endType)
                if endType == Enum.UserInputState.End then
                    if conn then conn:Disconnect() end
                end
            end)
        end
    end)

    return frame
end

-- Dropdown
function NeverwinGUI.AddDropdown(parent, opts)
    opts = opts or {}
    local text = opts.Text or "Dropdown"
    local items = opts.Items or {}
    local callback = opts.Callback

    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.5,0,1,0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200,200,200)
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left

    local drop = Instance.new("TextButton", frame)
    drop.Size = UDim2.new(0.5,0,1,0)
    drop.Position = UDim2.new(0.5,0,0,0)
    drop.BackgroundColor3 = Color3.fromRGB(50,50,55)
    drop.Text = items[1] or ""
    drop.Font = Enum.Font.Gotham
    drop.TextColor3 = Color3.fromRGB(139,0,0)
    drop.TextSize = 16
    Instance.new("UICorner",drop).CornerRadius = UDim.new(1,0)

    local expanded = false
    local dropdownMenu
    drop.MouseButton1Click:Connect(function()
        if expanded then
            if dropdownMenu then dropdownMenu:Destroy() end
            expanded = false
        else
            dropdownMenu = Instance.new("Frame", frame)
            dropdownMenu.Position = UDim2.new(0.5,0,1,0)
            dropdownMenu.Size = UDim2.new(0.5,0,0,#items*26)
            dropdownMenu.BackgroundColor3 = Color3.fromRGB(30,30,30)
            Instance.new("UICorner",dropdownMenu).CornerRadius = UDim.new(1,0)
            local layout = Instance.new("UIListLayout",dropdownMenu)
            layout.Padding = UDim.new(0,2)
            for i,v in ipairs(items) do
                local opt = Instance.new("TextButton",dropdownMenu)
                opt.Size = UDim2.new(1,0,0,24)
                opt.BackgroundTransparency = 1
                opt.Text = v
                opt.Font = Enum.Font.Gotham
                opt.TextSize = 14
                opt.TextColor3 = Color3.fromRGB(200,200,200)
                opt.MouseButton1Click:Connect(function()
                    drop.Text = v
                    if callback then callback(v) end
                    dropdownMenu:Destroy()
                    expanded = false
                end)
            end
            expanded = true
        end
    end)

    return frame
end

-- Text
function NeverwinGUI.AddText(parent, opts)
    opts = opts or {}
    local text = opts.Text or "Texto"
    local size = opts.Size or 18
    local color = opts.Color or Color3.fromRGB(200,200,200)
    local align = opts.XAlign or Enum.TextXAlignment.Left

    local label = Instance.new("TextLabel", parent)
    label.Size = UDim2.new(1, 0, 0, size+12)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = color
    label.TextSize = size
    label.TextXAlignment = align

    return label
end

return NeverwinGUI
