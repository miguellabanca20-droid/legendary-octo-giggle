-- =========================================================================
-- SUPREME AUTO-DETECT UNIVERSAL HUB | 30 JOGOS COM DETECÇÃO AUTOMÁTICA
-- Sistema Anti-Kick por Delay + Foco Automático na Aba do Jogo Atual
-- =========================================================================

task.wait(1.5) -- Delay de segurança contra anticheats de carregamento inicial

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local success, Rayfield = pcall(function()
   return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success or not Rayfield then
   warn("Falha ao carregar a biblioteca Rayfield.")
   return
end

local Window = Rayfield:CreateWindow({
   Name = "⚡ Supreme Auto-Detect Hub",
   LoadingTitle = "Detectando Jogo Atual...",
   LoadingSubtitle = "Aba configurada automaticamente",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false
})

-- Variáveis Globais de Utilidade
local SpeedVal = 16
local SpeedActive = false
local InfJumpActive = false
local NoclipActive = false
local ESPActive = false
local TargetName = ""

-- ABA GERAL / SUPORTE GLOBAL (Sempre disponível)
local TabGlobal = Window:CreateTab("⚙️ Controles Globais", 4483362458)

TabGlobal:CreateParagraph({Title = "Painel Universal", Content = "Comandos funcionais para qualquer jogo do Roblox:"})
TabGlobal:CreateToggle({Name = "1. Speed Hack Ajustável", CurrentValue = false, Callback = function(v) SpeedActive = v end})
TabGlobal:CreateSlider({Name = "Valor da Velocidade", Range = {16, 250}, Increment = 1, Suffix = " Spd", CurrentValue = 16, Callback = function(v) SpeedVal = v end})
TabGlobal:CreateToggle({Name = "2. Pulo Infinito", CurrentValue = false, Callback = function(v) InfJumpActive = v end})
TabGlobal:CreateToggle({Name = "3. Noclip Universal", CurrentValue = false, Callback = function(v) NoclipActive = v end})
TabGlobal:CreateButton({Name = "4. Fullbright (Visão Noturna)", Callback = function()
   Lighting.Brightness = 3 Lighting.Ambient = Color3.new(1,1,1) Lighting.GlobalShadows = false
   Rayfield:Notify({Title="Sucesso", Content="Iluminação máxima ativada!", Duration=3})
end})
TabGlobal:CreateButton({Name = "5. Maximizador de Zoom", Callback = function() LocalPlayer.CameraMaxZoomDistance = 999999 end})
TabGlobal:CreateToggle({Name = "6. ESP Chams (Ver Jogadores)", CurrentValue = false, Callback = function(v)
   ESPActive = v for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character then local hl = p.Character:FindFirstChild("UnivHL") if v and not hl then local h = Instance.new("Highlight") h.Name = "UnivHL" h.Adornee = p.Character h.FillColor = Color3.fromRGB(0,255,120) h.FillTransparency = 0.5 h.Parent = p.Character elseif not v and hl then hl:Destroy() end end end
end})
TabGlobal:CreateInput({Name = "7. Teleporte por Nick", PlaceholderText = "Digite o nome...", RemoveTextOnFocusLost = false, Callback = function(t) TargetName = t end})
TabGlobal:CreateButton({Name = "Executar Teleporte", Callback = function()
   for _, target in pairs(Players:GetPlayers()) do if target ~= LocalPlayer and (string.sub(string.lower(target.Name), 1, #TargetName) == string.lower(TargetName)) then if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-3) return end end end
end})

-- =========================================================================
-- MAPEAMENTO DOS 30 JOGOS COM OS RESPECTIVOS PLACE IDs DO ROBLOX
-- =========================================================================

local supportedGames = {
   {name = "🔪 MM2", ids = {142823291}, desc = "Murder Mystery 2"},
   {name = "🍎 Blox Fruits", ids = {2753915549, 4442272183, 7449423635}, desc = "Blox Fruits"},
   {name = "⚔️ Blade Ball", ids = {13772394625}, desc = "Blade Ball"},
   {name = "🚪 DOORS", ids = {6516141723}, desc = "DOORS"},
   {name = "🛌 BedWars", ids = {6872265039}, desc = "BedWars"},
   {name = "🔫 Arsenal", ids = {286090429}, desc = "Arsenal"},
   {name = "🏡 Brookhaven", ids = {4924922222}, desc = "Brookhaven RP"},
   {name = "🥊 Da Hood", ids = {2788229376}, desc = "Da Hood"},
   {name = "🐾 Pet Sim 99", ids = {8737899170}, desc = "Pet Simulator 99"},
   {name = "🐷 Piggy", ids = {4623386862}, desc = "Piggy"},
   {name = "🗼 Tower of Hell", ids = {1962086868}, desc = "Tower of Hell"},
   {name = "🚓 Jailbreak", ids = {606849621}, desc = "Jailbreak"},
   {name = "🐶 Adopt Me", ids = {920587237}, desc = "Adopt Me!"},
   {name = "🌪️ Disaster", ids = {189707}, desc = "Natural Disaster Survival"},
   {name = "🏃 Evade", ids = {9872472334}, desc = "Evade"},
   {name = "⚽ Super Striker", ids = {19983196}, desc = "Soccer Game"},
   {name = "🚗 Driving Empire", ids = {3351674303}, desc = "Driving Empire"},
   {name = "👑 King Legacy", ids = {4520749081}, desc = "King Legacy"},
   {name = "🗡️ Shindo Life", ids = {4623386862}, desc = "Shindo Life"},
   {name = "🏴‍☠️ Grand Piece", ids = {1730877806}, desc = "Grand Piece Online"},
   {name = "💥 Strongman Sim", ids = {6156057095}, desc = "Strongman Simulator"},
   {name = "🗡️ Anime Fighters", ids = {6299805723}, desc = "Anime Fighters"},
   {name = "🍕 Work at Pizza", ids = {192800}, desc = "Work at a Pizza Place"},
   {name = "🌴 Survival Island", ids = {120124317}, desc = "Survival Island"},
   {name = "🚀 Space Tycoon", ids = {149152345}, desc = "Space Tycoon"},
   {name = "🔫 Counter Blox", ids = {301549746}, desc = "Counter Blox"},
   {name = "⚔️ Blox Fruits 2", ids = {2753915549}, desc = "Mar de Batalha"},
   {name = "📦 Boxing League", ids = {6246328717}, desc = "Boxing League"},
   {name = "🏰 Castle Clash", ids = {32345678}, desc = "Castle Clash"},
   {name = "⭐ Universal Game", ids = {0}, desc = "Modo Geral Avançado"}
}

local currentPlaceId = game.PlaceId
local detectedGameName = "Modo Genérico"

-- Função para criar as abas dinamicamente e identificar a aba correta
for _, g in ipairs(supportedGames) do
   local isCurrentGame = false
   
   for _, id in ipairs(g.ids) do
      if id == currentPlaceId then
         isCurrentGame = true
         detectedGameName = g.desc
         break
      end
   end
   
   local tabTitle = isCurrentGame and ("⭐ [VOCÊ ESTÁ AQUI] " .. g.name) else g.name
   local t = Window:CreateTab(tabTitle, 4483362458)
   
   t:CreateParagraph({
      Title = "Painel Focado: " .. g.desc, 
      Content = isCurrentGame and "🟢 Jogo detectado automaticamente com sucesso!" else "Comandos auxiliares para este jogo."
   })
   
   t:CreateButton({Name = "1. Auto Coleta / Farm de Itens Próximos", Callback = function()
      for _, o in pairs(workspace:GetDescendants()) do if o:IsA("BasePart") and (string.find(o.Name, "Coin") or string.find(o.Name, "Chest")) then LocalPlayer.Character.HumanoidRootPart.CFrame = o.CFrame task.wait(0.1) end end
      Rayfield:Notify({Title=g.name, Content="Coleta executada.", Duration=2})
   end})
   
   t:CreateToggle({Name = "2. Super Velocidade (Speed 24)", CurrentValue = false, Callback = function(v)
      if LocalPlayer.Character then LocalPlayer.Character.Humanoid.WalkSpeed = v and 24 or 16 end
   end})
   
   t:CreateToggle({Name = "3. Pulo Elevado (JumpPower 80)", CurrentValue = false, Callback = function(v)
      if LocalPlayer.Character then LocalPlayer.Character.Humanoid.JumpPower = v and 80 or 50 end
   end})
   
   t:CreateToggle({Name = "4. Noclip Anti-Obstáculo Local", CurrentValue = false, Callback = function(v)
      _G.AutoNoclip = v task.spawn(function() while _G.AutoNoclip do task.wait() for _, p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end end)
   end})
   
   t:CreateButton({Name = "5. Teleportar para o Spawn / Centro", Callback = function()
      if LocalPlayer.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 15, 0) end
   end})
   
   t:CreateButton({Name = "6. Otimizar FPS (Remover Texturas)", Callback = function()
      Lighting.GlobalShadows = false for _, v in pairs(workspace:GetDescendants()) do if v:IsA("Part") then v.Material = Enum.Material.SmoothPlastic end end
      Rayfield:Notify({Title=g.name, Content="FPS Otimizado!", Duration=2})
   end})
   
   t:CreateToggle({Name = "7. Hitbox Expandida de Combate", CurrentValue = false, Callback = function(v)
      for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then p.Character.HumanoidRootPart.Size = v and Vector3.new(12,12,12) or Vector3.new(2,2,2) end end
   end})
   
   t:CreateButton({Name = "8. Fullbright (Remover Escuridão)", Callback = function()
      Lighting.Brightness = 4 Lighting.Ambient = Color3.fromRGB(255,255,255) Lighting.GlobalShadows = false
   end})
   
   t:CreateButton({Name = "9. Remover Névoa e Poluição Visual", Callback = function()
      for _, v in pairs(Lighting:GetChildren()) do if v:IsA("Atmosphere") then v:Destroy() end end
   end})
   
   t:CreateButton({Name = "10. Notificação de Status", Callback = function()
      Rayfield:Notify({Title=g.name, Content="Comandos prontos para uso.", Duration=2})
   end})
end

-- =========================================================================
-- LOOPS GLOBAIS DE SUPORTE
-- =========================================================================

RunService.RenderStepped:Connect(function()
   if SpeedActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
      LocalPlayer.Character.Humanoid.WalkSpeed = SpeedVal
   end
end)

RunService.Stepped:Connect(function()
   if NoclipActive and LocalPlayer.Character then
      for _, p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
   end
end)

UserInputService.JumpRequest:Connect(function()
   if InfJumpActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
      LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
   end
end)

Rayfield:Notify({
   Title = "🎯 Jogo Detectado com Sucesso!",
   Content = "Identificado: " .. detectedGameName .. ". Procure a aba com a etiqueta ⭐ [VOCÊ ESTÁ AQUI].",
   Duration = 6,
})
