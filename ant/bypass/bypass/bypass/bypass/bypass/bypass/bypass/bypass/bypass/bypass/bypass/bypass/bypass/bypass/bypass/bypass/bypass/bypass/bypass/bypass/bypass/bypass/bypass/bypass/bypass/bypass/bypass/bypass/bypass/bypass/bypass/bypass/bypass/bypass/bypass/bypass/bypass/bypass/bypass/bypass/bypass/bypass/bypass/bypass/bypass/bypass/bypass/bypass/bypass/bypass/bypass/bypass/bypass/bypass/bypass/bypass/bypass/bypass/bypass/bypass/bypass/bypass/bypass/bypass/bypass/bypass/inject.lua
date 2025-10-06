-- ====================================================================================== --
-- [ 🐉 ] - SILARE MENU 
-- ====================================================================================== --
-- Notificação Inicial
game:GetService("StarterGui"):SetCore("SendNotification",{
Title = "SilareV1 | Bypassing🔥",
Text = "By Silentx,Raro,Nando", 
Duration = 30 
})
-- 1. CARREGA A LIB DA NUVEM (SEU MODELO)
local rareLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ImNotRaro/I-m-xiter/refs/heads/main/Lib.lua", true))()


-- 3. INICIA A UI E CRIA O HUB (TESTA: API options e TEMA VERMELHO)
local Hub = rareLib:new({
    Title = "- Silare Menu -",
    Config = { UISize = {700, 480} },
    Theme = { ["Color Theme"] = Color3.fromRGB(180, 0, 0) } -- TEMA DRAGÃO VERMELHO
})
-- TABS AQUI!
local MainTab = Hub:CreateTab({ Title = "[🏠]- Main" })
local PlayerTab = Hub:CreateTab({ Title = "[🤵] - Player" })
local PvPTab = Hub:CreateTab({ Title = "[⚔️] - PvP" })
local PvETab = Hub:CreateTab({ Title = "[🤖] - PvE" })
local EspTab = Hub:CreateTab({ Title = "[👁] - Esp" })
local InteractTab = Hub:CreateTab({ Title = "[👉] - Interação" })
local TeleportTab = Hub:CreateTab({ Title = "[🚪] - Teleport" })







-- MAINTAB
-- MAINTAB

MainTab:AddTitle({ Title = "STATUS E INFORMAÇÕES" })
MainTab:AddLabel({ Text = "Bem-vindo ao Silare Menu V1" })
MainTab:AddSeparator({})

-- BUTTON (Limpa o log, utilitário básico)
MainTab:AddButton({
    Title = "Limpar Console",
    Desc = "Limpa a saída do Developer Console para maior foco.",
    Callback = function() 
        print(string.rep("\n", 50)) 
        warn("Console Limpa pelo Silare Menu!")
    end
})

-- LABEL LINK (Créditos)
MainTab:AddLabelLink({
    Text = "Devs: Silentx, Raro, Nando",
    Action = "Clique para Agradecer!",
    Callback = function()
        warn("Silare Menu V1 | Agradecemos aos criadores!")
    end
})

MainTab:AddSeparator({ Title = "OPÇÕES DA UI" })

-- SLIDER (Controle de Transparência do Hub)
-- A Lib V7 não tem um método para controlar a transparência do MainFrame, mas podemos forçar!
local HubFrame = Hub.MainFrame
MainTab:AddSlider({
    Title = "Transparência do Menu",
    Desc = "Ajusta a opacidade da janela principal (0.0 = Invisível).",
    Min = 0, Max = 1, Default = 1,
    Callback = function(value)
        HubFrame.BackgroundTransparency = 1 - value -- O Roblox usa 0 para opaco e 1 para transparente
        HubFrame.TitleBar.BackgroundTransparency = 1 - value
    end
})

MainTab:AddSeparator({})
MainTab:AddLabel({ Text = "Verifique o log para o status final do carregamento." })

-- PLAYER TAB
local Player = game:GetService("Players").LocalPlayer
local BypassLoopConnection = nil
local CurrentSpeedMethod = "WalkSpeed"
local CurrentSpeedValue = 50 -- Valor inicial para o Slider/Textbox

-- Função de Notificação Rápida
local function SendQuickNotification(title, text, duration)
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "Silare Menu | " .. title,
        Text = text, 
        Duration = duration or 3
    })
end

-- Lógica Principal do Loop de Velocidade
local function StartSpeedLoop(speedValue)
    if BypassLoopConnection then return end
    
    CurrentSpeedValue = speedValue
    local Hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
    
    if CurrentSpeedMethod == "WalkSpeed" then
        if Hum then
            Hum.WalkSpeed = speedValue
            SendQuickNotification("Speed", "WalkSpeed Ligado em " .. speedValue, 1)
        end
        BypassLoopConnection = {Disconnect = function() end} -- Conexão fictícia para manter o estado
        
    elseif CurrentSpeedMethod == "TpSpeed" then
        SendQuickNotification("Speed", "TpSpeed Ligado em " .. speedValue .. "! (ALT para subir)", 2)
        
        BypassLoopConnection = RunService.RenderStepped:Connect(function()
            local Char = Player.Character
            local Root = Char and Char:FindFirstChild("HumanoidRootPart")
            local Camera = workspace.CurrentCamera
            
            if Root and Camera then
                local MoveDirection = Hum.MoveDirection
                
                if MoveDirection.Magnitude > 0 then
                    local SpeedVector = Camera.CFrame.lookVector * MoveDirection.Z * speedValue
                    SpeedVector = SpeedVector + Camera.CFrame.rightVector * MoveDirection.X * speedValue
                    
                    -- Lógica de Subida/Descida para TpSpeed (UX de exploit)
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) or UserInputService:IsKeyDown(Enum.KeyCode.RightAlt) then
                        SpeedVector = SpeedVector + Vector3.new(0, speedValue, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift) then
                        SpeedVector = SpeedVector + Vector3.new(0, -speedValue, 0)
                    end
                    
                    Root.CFrame = Root.CFrame + SpeedVector * 0.016 -- Delta de 1 frame (aprox 0.016s)
                end
            end
        end)
    end
end

-- Lógica de Desligar o Loop
local function StopSpeedLoop()
    if not BypassLoopConnection then return end
    
    if CurrentSpeedMethod == "WalkSpeed" then
        local Hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
        if Hum then Hum.WalkSpeed = 16 end
    end
    
    if BypassLoopConnection.Disconnect then BypassLoopConnection:Disconnect() end
    BypassLoopConnection = nil
    SendQuickNotification("Speed", "Desligado. Velocidade Restaurada.", 1)
end

-- ====================================================================================== --
-- CONSTRUÇÃO DA TAB
-- ====================================================================================== --

PlayerTab:AddTitle({ Title = "Speed" })
PlayerTab:AddSeparator({ Title = "ATIVAÇÃO E MÉTODO" })

-- TOGGLE (Ligar/Desligar)
local ToggleSpeedAPI = PlayerTab:AddToggle({
    Title = "Ativar Múltiplos",
    Desc = "Liga e desliga o cheat de velocidade.",
    Default = false,
    Callback = function(newState)
        if newState then
            StartSpeedLoop(CurrentSpeedValue)
        else
            StopSpeedLoop()
        end
    end
})

-- DROPDOWN (Seleção de Método)
PlayerTab:AddDropdown({
    Title = "Método de Velocidade",
    Desc = "Seleciona entre WalkSpeed comum e Teleport Speed.",
    Options = {"WalkSpeed", "TpSpeed"},
    Default = CurrentSpeedMethod,
    Callback = function(selection)
        CurrentSpeedMethod = selection
        SendQuickNotification("Speed", "Método alterado para: " .. selection, 1.5)
        
        -- Reinicia o loop se já estiver ligado
        if ToggleSpeedAPI.GetState() then
            StopSpeedLoop()
            StartSpeedLoop(CurrentSpeedValue)
        end
    end
})

PlayerTab:AddSeparator({ Title = "VALOR E AJUSTE" })

-- LABEL DE EXPLICAÇÃO
PlayerTab:AddLabel({ Text = "WalkSpeed: Altera o valor da velocidade de caminhada do seu Humanoid." })
PlayerTab:AddLabel({ Text = "TpSpeed: Move o seu corpo teletransportando-o suavemente (ALT para subir)." })


-- SLIDER (Controle deslizante)
local SliderSpeedAPI = PlayerTab:AddSlider({
    Title = "Velocidade Deslizante",
    Desc = "Valor ajustável via mouse/toque.",
    Min = 20, Max = 200, Default = CurrentSpeedValue,
    Callback = function(newValue)
        local roundedValue = math.floor(newValue)
        CurrentSpeedValue = roundedValue
        
        -- Atualiza a Textbox e o Loop
        if TextboxSpeedAPI then TextboxSpeedAPI.SetText(tostring(roundedValue)) end
        if ToggleSpeedAPI.GetState() then StartSpeedLoop(CurrentSpeedValue) end -- Notificação rápida
        
        SendQuickNotification("Ajuste", "Velocidade: " .. roundedValue, 0.5)
    end
})

-- TEXTBOX (Controle por texto)
local TextboxSpeedAPI = PlayerTab:AddTextbox({
    Title = "Velocidade por Texto",
    Desc = "Insira a velocidade e tecle ENTER (Máx 200).",
    Placeholder = tostring(CurrentSpeedValue),
    Callback = function(text)
        local value = tonumber(text)
        if value and value >= 20 and value <= 200 then
            CurrentSpeedValue = value
            SliderSpeedAPI.SetValue(value) -- Atualiza o Slider
            if ToggleSpeedAPI.GetState() then StartSpeedLoop(CurrentSpeedValue) end -- Notificação rápida
            SendQuickNotification("Ajuste", "Velocidade setada para: " .. value, 1.5)
        else
            SendQuickNotification("Erro", "Valor inválido! Mín: 20, Máx: 200.", 2)
        end
    end
})

PlayerTab:AddSeparator({})

-- NOTA IMPORTANTE PARA DESLIGAR
PlayerTab:AddLabel({ Text = "NOTA: Desligue o cheat de TpSpeed antes de mudar de jogo/spawnar!" })




-- NOTIFICAÇÃO FINAL
-- Notificação Inicial
game:GetService("StarterGui"):SetCore("SendNotification",{
Title = "🇲🇪MENU FULL!",
Text = "SilareV1 Carregado com Sucesso!", 
Duration = 14 
})
