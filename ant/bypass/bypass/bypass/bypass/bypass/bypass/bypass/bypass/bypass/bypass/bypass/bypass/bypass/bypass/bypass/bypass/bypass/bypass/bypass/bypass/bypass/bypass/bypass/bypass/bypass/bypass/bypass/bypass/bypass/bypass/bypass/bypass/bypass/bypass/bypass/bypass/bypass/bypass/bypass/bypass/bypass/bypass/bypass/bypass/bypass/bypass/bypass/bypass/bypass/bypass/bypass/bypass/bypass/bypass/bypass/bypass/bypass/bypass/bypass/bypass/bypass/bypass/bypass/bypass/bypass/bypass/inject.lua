-- ====================================================================================== --
-- [ 🐉 ] - SILARE MENU V1 (SISTEMA DE LOGIN E UX)
-- ====================================================================================== --

game:GetService("StarterGui"):SetCore("SendNotification",{
Title = "SilareV1 | Bypassing🔥",
Text = "By Silentx,Raro,Nando", 
Duration = 30 
})
-- 1. CARREGA A LIB DA NUVEM (SEU MODELO)
local rareLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ImNotRaro/I-m-xiter/refs/heads/main/Lib.lua", true))()

-- 2. DADOS DE LOGIN (A SENHA SECRETA!)
local CORRECT_PASSWORD = "123456789" 

-- 3. INICIA A UI E CRIA O HUB (TESTA: API options e TEMA VERMELHO)
local Hub = rareLib:new({
    Title = "- Silare Menu -",
    Config = { UISize = {700, 480} },
    Theme = { ["Color Theme"] = Color3.fromRGB(180, 0, 0) } -- TEMA DRAGÃO VERMELHO
})


local PasswordTextbox -- Variável para guardar a referência do Textbox


-- 4. CRIAÇÃO DAS ABAS (Login é a única tab visível inicialmente)
local LoginTab = Hub:CreateTab({ Title = "|| Login" })
-- A Tab de conteúdo principal será criada DEPOIS do login


-- ====================================================================================== --
-- ABA LOGIN
-- ====================================================================================== --

LoginTab:AddTitle({ Title = "// Main Silare" })
LoginTab:AddSeparator({})
LoginTab:AddLabel({ Text = "Solara V1 | 🔧 Update: 29/09 | API: Online | Dev: Raro_Modz" })
LoginTab:AddSeparator({ Title = "Update Log" })

-- LOG DE ATUALIZAÇÃO
LoginTab:AddLabel({ Text = "Versão V1 [Lançamento]." })
LoginTab:AddLabel({ Text = [[
  - Sistema de Login (Criado)
  - Novo Bypass (Implementado)
  - UI redefinida (Atualizado)
]] })


LoginTab:AddSeparator({ Title = "discord.gg/YG6vFKSHcV" })
LoginTab:AddLabelLink({
    Text = "Acesse nosso servidor",
    Action = "Clique!"
})
