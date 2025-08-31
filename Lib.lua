--[[
    NeverwinLib - Roblox GUI Framework
    PROJETO NEVERWIN V5 - by ⏤͟͞ঔৣོ⟟🇪🇬 RARO XT 㝹 & DRIP
    Uso:
    local lib = require(path.To.NeverwinLib)
    local gui, main, panels = lib.CreateWindow({Name="NEVERWIN_UI"})
    local sel, items = lib.createSelection(panels.ContentPanel, "Minha Seleção")
    lib.AddToggle(items, {...})
    lib.AddSlide(items, {...})
    lib.AddDropdown(items, {...})
    lib.AddText(items, {...})
]]

local NeverwinLib = {}

-- Dependências Roblox
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

NeverwinLib.Services = {
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
function NeverwinLib.DestroyOld(name)
    if CoreGui:FindFirstChild(name) then
        CoreGui[name]:Destroy()
    end
end

-- Cria janela principal + painéis/abas
function NeverwinLib.CreateWindow(opts)
    opts = opts or {}
    local winName = opts.Name or "NeverwinUI"
    local size = opts.Size or UDim2.new(0, 620, 0, 360)
    local pos = opts.Position or UDim2.new(0.5, -310, 0.5, -180)

    NeverwinLib.DestroyOld(winName)

    local gui = Instance.new("ScreenGui")
    gui.Name = winName
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    local MainFrame = Instance.new("Frame", gui)
    MainFrame.Name = "MainFrame"
    MainFrame.Size = size
    MainFrame.Position = pos
    MainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    MainFrame.BorderSizePixel = 2
    MainFrame.BorderColor3 = Color3.fromRGB(255,255,255)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.ClipsDescendants = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
    local MainPadding = Instance.new("UIPadding", MainFrame)
    MainPadding.PaddingLeft = UDim.new(0,10)
    MainPadding.PaddingRight = UDim.new(0,10)
    MainPadding.PaddingTop = UDim.new(0,10)
    MainPadding.PaddingBottom = UDim.new(0,10)

    -- Botão Fantasma
    local ToggleButton = Instance.new("TextButton", gui)
    ToggleButton.Size = UDim2.new(0, 50, 0, 50)
    ToggleButton.Position = UDim2.new(0, 15, 0.5, -25)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(139,0,0)
    ToggleButton.Text = "愛"
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.TextColor3 = Color3.fromRGB(255,255,255)
    ToggleButton.TextSize = 32
    ToggleButton.Draggable = true
    Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", ToggleButton).Color = Color3.fromRGB(255,255,255)
    ToggleButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    -- Painéis principais
    local NavContainer = Instance.new("ScrollingFrame", MainFrame)
    NavContainer.Size = UDim2.new(0, 150, 1, 0)
    NavContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    NavContainer.BorderSizePixel = 0
    NavContainer.CanvasSize = UDim2.new(0, 0, 1.2, 0)
    NavContainer.ScrollBarImageColor3 = Color3.fromRGB(139, 0, 0)
    NavContainer.ScrollBarThickness = 6
    Instance.new("UICorner", NavContainer).CornerRadius = UDim.new(0, 6)
    local NavLayout = Instance.new("UIListLayout", NavContainer)
    NavLayout.Padding = UDim.new(0, 5)
    NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
    local NavPadding = Instance.new("UIPadding", NavContainer)
    NavPadding.PaddingTop = UDim.new(0, 10)

    local ContentPanel = Instance.new("Frame", MainFrame)
    ContentPanel.Size = UDim2.new(1, -380, 1, 0)
    ContentPanel.Position = UDim2.new(0, 160, 0, 0)
    ContentPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    ContentPanel.BorderSizePixel = 0
    Instance.new("UICorner", ContentPanel).CornerRadius = UDim.new(0, 6)

    local RightPanel = Instance.new("Frame", MainFrame)
    RightPanel.Size = UDim2.new(0, 200, 1, 0)
    RightPanel.Position = UDim2.new(1, -200, 0, 0)
    RightPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    RightPanel.BorderSizePixel = 0
    Instance.new("UICorner", RightPanel).CornerRadius = UDim.new(0, 6)
    local RightPanelPadding = Instance.new("UIPadding", RightPanel)
    RightPanelPadding.PaddingTop = UDim.new(0, 10)
    RightPanelPadding.PaddingLeft = UDim.new(0, 10)
    RightPanelPadding.PaddingRight = UDim.new(0, 10)

    -- Efeito constelação
    local particleFrame=Instance.new("Frame",MainFrame)
    particleFrame.Size=UDim2.new(1,0,1,0)
    particleFrame.BackgroundTransparency=1
    particleFrame.ZIndex=0
    local particles={}
    local numParticles=35
    local connectDistance=100
    for i=1,numParticles do
        local p=Instance.new("Frame",particleFrame)
        p.Size=UDim2.new(0,3,0,3)
        p.BackgroundColor3=Color3.fromRGB(255,0,0)
        p.BorderSizePixel=0
        Instance.new("UICorner",p).CornerRadius=UDim.new(1,0)
        table.insert(particles,{gui=p,pos=Vector2.new(math.random(0,MainFrame.AbsoluteSize.X),math.random(0,MainFrame.AbsoluteSize.Y)),vel=Vector2.new(math.random(-20,20),math.random(-20,20))})
    end
    local lines={}
    RunService.RenderStepped:Connect(function(dt)
        for _,line in ipairs(lines) do line:Destroy() end
        lines={}
        local size=MainFrame.AbsoluteSize
        for i,p1 in ipairs(particles) do
            p1.pos=p1.pos+p1.vel*dt
            if p1.pos.X<0 or p1.pos.X>size.X then p1.vel=Vector2.new(-p1.vel.X,p1.vel.Y) end
            if p1.pos.Y<0 or p1.pos.Y>size.Y then p1.vel=Vector2.new(p1.vel.X,-p1.vel.Y) end
            p1.gui.Position=UDim2.fromOffset(p1.pos.X,p1.pos.Y)
            for j=i+1,#particles do
                local p2=particles[j]
                local dist=(p1.pos-p2.pos).Magnitude
                if dist<connectDistance then
                    local line=Instance.new("Frame",particleFrame)
                    line.Size=UDim2.new(0,dist,0,1)
                    line.Position=UDim2.fromOffset((p1.pos.X+p2.pos.X)/2,(p1.pos.Y+p2.pos.Y)/2)
                    line.Rotation=math.deg(math.atan2(p2.pos.Y-p1.pos.Y,p2.pos.X-p1.pos.X))
                    line.BackgroundColor3=Color3.fromRGB(255,0,0)
                    line.BackgroundTransparency=1-(1-dist/connectDistance)*0.8
                    line.BorderSizePixel=0
                    table.insert(lines,line)
                end
            end
        end
    end)

    -- Navegação lateral
    local NavTitle = Instance.new("TextLabel", NavContainer)
    NavTitle.LayoutOrder=0
    NavTitle.Size=UDim2.new(1,0,0,40)
    NavTitle.BackgroundTransparency=1
    NavTitle.Font=Enum.Font.GothamBold
    NavTitle.Text="NEVERWIN"
    NavTitle.TextColor3=Color3.fromRGB(139,0,0)
    NavTitle.TextSize=24

    local function CreateNavButton(text, order)
        local btn = Instance.new("TextButton",NavContainer)
        btn.LayoutOrder=order
        btn.Size=UDim2.new(1,-20,0,35)
        btn.Position=UDim2.new(0,10,0,0)
        btn.BackgroundColor3=Color3.fromRGB(25,25,25)
        btn.Text=" "..text
        btn.Font=Enum.Font.Gotham
        btn.TextColor3=Color3.fromRGB(200,200,200)
        btn.TextSize=16
        btn.TextXAlignment=Enum.TextXAlignment.Left
        local c=Instance.new("UICorner",btn)
        c.CornerRadius=UDim.new(0,4)
        local s=Instance.new("UIStroke",btn)
        s.Color=Color3.fromRGB(255,255,255)
        s.Thickness=1
        return btn
    end

    -- Aba RPG lateral direita
    pcall(function()
        local FichaRPG = Instance.new("Frame", RightPanel); FichaRPG.Size = UDim2.new(1, 0, 1, 0); FichaRPG.BackgroundTransparency = 1
        local fundoGradient = Instance.new("UIGradient", FichaRPG); fundoGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(40,0,0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(15,0,0))}); fundoGradient.Rotation = 90
        local _, thumbUrl = pcall(Players.GetUserThumbnailAsync, Players, LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180)
        local estandarteImg = Instance.new("ImageLabel", FichaRPG); estandarteImg.Size=UDim2.new(0,64,0,64); estandarteImg.Position=UDim2.new(0.5,-32,0,120); estandarteImg.BackgroundColor3=Color3.fromRGB(139,0,0); estandarteImg.ScaleType=Enum.ScaleType.Crop; estandarteImg.Image=thumbUrl or ""; Instance.new("UIAspectRatioConstraint",estandarteImg).AspectRatio=1; Instance.new("UICorner",estandarteImg).CornerRadius=UDim.new(1,0)
        local nomePrincipalLabel = Instance.new("TextLabel", FichaRPG); nomePrincipalLabel.Size=UDim2.new(1,0,0,25); nomePrincipalLabel.Position=UDim2.new(0,0,0,190); nomePrincipalLabel.Font=Enum.Font.GothamBold; nomePrincipalLabel.Text=LocalPlayer.DisplayName; nomePrincipalLabel.TextColor3=Color3.fromRGB(240,240,240); nomePrincipalLabel.TextSize=20; nomePrincipalLabel.BackgroundTransparency=1
        local subtituloNomeLabel = Instance.new("TextLabel", FichaRPG); subtituloNomeLabel.Size=UDim2.new(1,0,0,20); subtituloNomeLabel.Position=UDim2.new(0,0,0,215); subtituloNomeLabel.Font=Enum.Font.Gotham; subtituloNomeLabel.Text="⏤͟͞ঔৣོ⟟🇪🇬 RARO 𝑋𝑇 㝹"; subtituloNomeLabel.TextColor3=Color3.fromRGB(139,0,0); subtituloNomeLabel.TextSize=14; subtituloNomeLabel.BackgroundTransparency=1
        local function criarRotuloStatus(nome, posY)
            local container=Instance.new("Frame",FichaRPG); container.Size=UDim2.new(1,-20,0,22); container.Position=UDim2.new(0,10,0,posY); container.BackgroundTransparency=1
            local nomeLabel=Instance.new("TextLabel",container); nomeLabel.Size=UDim2.new(0.5,0,1,0); nomeLabel.Font=Enum.Font.GothamBold; nomeLabel.TextColor3=Color3.fromRGB(139,0,0); nomeLabel.Text=nome..":"; nomeLabel.TextXAlignment=Enum.TextXAlignment.Left; nomeLabel.TextSize=18; nomeLabel.BackgroundTransparency=1
            local valorLabel=Instance.new("TextLabel",container); valorLabel.Size=UDim2.new(0.5,0,1,0); valorLabel.Position=UDim2.new(0.5,0,0,0); valorLabel.Font=Enum.Font.Gotham; valorLabel.TextColor3=Color3.fromRGB(240,240,240); valorLabel.Text="..."; valorLabel.TextXAlignment=Enum.TextXAlignment.Right; valorLabel.TextSize=18; valorLabel.BackgroundTransparency=1; return valorLabel
        end
        local vidaValor = criarRotuloStatus("VIDA", 20); local pingValor = criarRotuloStatus("PING", 50); local fpsValor = criarRotuloStatus("FPS", 80)
        task.spawn(function()
            while task.wait(1) do if FichaRPG and FichaRPG.Parent then
                pcall(function() local hum=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid"); if hum then vidaValor.Text=string.format("%d/%d",math.floor(hum.Health),math.floor(hum.MaxHealth)) end end)
                pcall(function() pingValor.Text=game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString() end)
                pcall(function() fpsValor.Text=tostring(math.floor(Workspace:GetRealPhysicsFPS())) end)
            end end
        end)
    end)

    -- Botões de aba
    local playerButton = CreateNavButton("Player", 1)
    local pvpButton = CreateNavButton("Pvp", 2)
    local espButton = CreateNavButton("Esp", 3)

    local panels = {
        ContentPanel = ContentPanel,
        NavContainer = NavContainer,
        RightPanel = RightPanel,
        MainFrame = MainFrame,
        PlayerButton = playerButton,
        PvpButton = pvpButton,
        EspButton = espButton
    }

    return gui, MainFrame, panels
end

-- Cria seleção (título + área para itens)
function NeverwinLib.createSelection(parent, text)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, 0, 0, 60)
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
    local layout = Instance.new("UIListLayout", itemsFrame)
    layout.Padding = UDim.new(0, 5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    return container, itemsFrame
end

-- Toggle universal
function NeverwinLib.AddToggle(parent, opts)
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

-- Slider universal
function NeverwinLib.AddSlide(parent, opts)
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

-- Dropdown universal
function NeverwinLib.AddDropdown(parent, opts)
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

-- Texto universal
function NeverwinLib.AddText(parent, opts)
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

-- Sistema de abas igual ao seu GUI original
function NeverwinLib.SetupTabs(panels, tabs)
    local tabFuncs = {}
    -- Player Tab
    tabFuncs.Player = function()
        for _, child in ipairs(panels.ContentPanel:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextLabel") then child:Destroy() end
        end
        local sel, items = NeverwinLib.createSelection(panels.ContentPanel, "< 愛 > • Player")
        NeverwinLib.AddToggle(items, {
            Text="God Mode (Clássico)",
            Initial=false,
            Callback=function(state)
                if state then
                    pcall(function() local h=Players.LocalPlayer.Character.Humanoid; h.MaxHealth=math.huge; task.wait(); h.Health=math.huge end)
                else
                    pcall(function() local h=Players.LocalPlayer.Character.Humanoid; h.MaxHealth=100; task.wait(); h.Health=100 end)
                end
            end
        })
        NeverwinLib.AddToggle(items, {
            Text="Noclip",
            Initial=false,
            Callback=function(state)
                local noclipAtivo, noclipConexao = state, nil
                if noclipAtivo then
                    noclipConexao = RunService.Stepped:Connect(function()
                        if not noclipAtivo then noclipConexao:Disconnect(); noclipConexao=nil; return end
                        pcall(function()
                            for _,p in pairs(Players.LocalPlayer.Character:GetDescendants()) do
                                if p:IsA("BasePart") then p.CanCollide=false end
                            end
                        end)
                    end)
                elseif noclipConexao then
                    noclipConexao:Disconnect(); noclipConexao=nil
                end
            end
        })
    end
    -- PvP Tab
    tabFuncs.Pvp = function()
        for _, child in ipairs(panels.ContentPanel:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextLabel") then child:Destroy() end
        end
        local sel, items = NeverwinLib.createSelection(panels.ContentPanel, "< 愛 > • PvP")
        NeverwinLib.AddToggle(items, {
            Text="Aimbot",
            Initial=false,
            Callback=function(state)
                -- Adicione lógica do aimbot aqui
            end
        })
    end
    -- ESP Tab
    tabFuncs.ESP = function()
        for _, child in ipairs(panels.ContentPanel:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextLabel") then child:Destroy() end
        end
        local sel, items = NeverwinLib.createSelection(panels.ContentPanel, "< 愛 > • ESP")
        -- Adicione lógica do ESP aqui
    end

    tabs.Player.MouseButton1Click:Connect(tabFuncs.Player)
    tabs.Pvp.MouseButton1Click:Connect(tabFuncs.Pvp)
    tabs.ESP.MouseButton1Click:Connect(tabFuncs.ESP)
    -- Abre Player por padrão
    tabFuncs.Player()
end

return NeverwinLib
