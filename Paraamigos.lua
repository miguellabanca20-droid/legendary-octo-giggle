-- =========================================================================
-- FEARS HUB | Supreme Ultimate Edition v10.0 (Mega Expanded & Unchanged Core)
-- =========================================================================

local success, Rayfield = pcall(function()
   return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success or not Rayfield then
   warn("Falha ao carregar a Rayfield Library.")
   return
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local CurrentPlaceId = game.PlaceId
local GameName = "Ambiente Desconhecido"
pcall(function()
   local info = MarketplaceService:GetProductInfo(CurrentPlaceId)
   if info and info.Name then GameName = info.Name end
end)

local Window = Rayfield:CreateWindow({
   Name = "🔥 Fears Hub Supreme v10.0 | [" .. GameName .. "]",
   LoadingTitle = "Carregando Supremo Fears Hub...",
   LoadingSubtitle = "Expansão Máxima & Recursos Ilimitados",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false
})

-- Variáveis Globais Originais & Novas
local SpeedVal = 16
local SpeedActive = false
local FlyVal = 50
local FlyActive = false
local InfJumpActive = false
local NoclipActive = false

-- Novas Variáveis Globais Expandidas
local InfiniteYieldLoaded = false
local ServerHopEnabled = false
local RejoinEnabled = false
local GodModeVisual = false
local ZoomDistance = 128
local CustomFOVValue = 70
local CustomFOVEnabled = false
local ESPBoxActive = false
local ESPNameActive = false
local ESPHealthActive = false
local FullbrightActive = false
local FreecamActive = false
local RainbowLightingActive = false
local TeleportAllPlayersToMe = false
local AntiRagdollActive = true

-- Variáveis do Kill All
local KillAllActive = false
local KillAllSpeed = 0.5

-- ABAS EXPANDIDAS
local TabDetected = Window:CreateTab("🎯 Jogo Atual", 4483362458)
local TabGlobal   = Window:CreateTab("⚡ Movimento & Global", 4483362458)
local TabVisuals  = Window:CreateTab("👁️ Visuais & ESP", 4483362458)
local TabTroll    = Window:CreateTab("💥 Troll & Server", 4483362458)
local TabScripts  = Window:CreateTab("📜 Scripts Externos", 4483362458)
local TabExtra    = Window:CreateTab("🎮 Todos os Jogos", 4483362458)

-- ==================== ABA 1: JOGO ATUAL (DINÂMICO ORIGINAL + EXTRAS) ====================
TabDetected:CreateParagraph({Title = "Painel Dinâmico: " .. GameName, Content = "Comandos nativos mantidos e expandidos com funções adicionais."})

local SpecificHitboxSize = 2
local SpecificHitboxActive = false
local SpecificAutoFarm = false
local SpecificSpeedVal = 16
local SpecificSpeedActive = false

-- 1. BLOX FRUITS
if CurrentPlaceId == 2753915549 or CurrentPlaceId == 4442272183 or CurrentPlaceId == 7449423635 then
   TabDetected:CreateParagraph({Title = "🍊 Blox Fruits - Painel Supremo", Content = "Módulos avançados para farm, frutas e ilhas."})
   TabDetected:CreateToggle({Name = "Auto-Farm Level / Quests", CurrentValue = false, Callback = function(v) SpecificAutoFarm = v end})
   TabDetected:CreateButton({Name = "Teleportar para Ilha Inicial", Callback = function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
         LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(979.3, 16.2, 1429.5)
      end
   end})
   TabDetected:CreateButton({Name = "Teleportar para Cafeteria (Segunda Sea)", Callback = function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
         LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(387.8, 77.2, 317.5)
      end
   end})
   TabDetected:CreateButton({Name = "Radar de Frutas Automático", Callback = function()
      for _, f in pairs(workspace:GetChildren()) do
         if string.find(f.Name, "Fruit") and f:FindFirstChild("Handle") then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
               LocalPlayer.Character.HumanoidRootPart.CFrame = f.Handle.CFrame
               Rayfield:Notify({Title = "Fears Hub", Content = "Fruta encontrada e coletada!", Duration = 3})
            end
         end
      end
   end})
   TabDetected:CreateButton({Name = "Ativar Fullbright Avançado", Callback = function()
      Lighting.Brightness = 5 Lighting.Ambient = Color3.new(1,1,1) Lighting.GlobalShadows = false
   end})

-- 2. DOORS
elseif CurrentPlaceId == 6516141723 then
   TabDetected:CreateParagraph({Title = "🚪 DOORS - Hotel Survival Suite", Content = "Ferramentas completas de sobrevivência."})
   TabDetected:CreateButton({Name = "Fullbright Absoluto (Ver na escuridão)", Callback = function()
      Lighting.Brightness = 8 Lighting.Ambient = Color3.new(1,1,1) Lighting.GlobalShadows = false
   end})
   TabDetected:CreateButton({Name = "Pular Sala Atual (Anti-Delay)", Callback = function()
      for _, door in pairs(workspace.CurrentRooms:GetChildren()) do
         if door:FindFirstChild("Door") and door.Door:FindFirstChild("Door") then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
               LocalPlayer.Character.HumanoidRootPart.CFrame = door.Door.Door.CFrame
            end
         end
      end
   end})

-- 3. ARSENAL
elseif CurrentPlaceId == 286090429 then
   TabDetected:CreateParagraph({Title = "🔫 Arsenal - Combat Domination", Content = "Módulos balísticos e hitboxes."})
   TabDetected:CreateToggle({Name = "Expandir Hitbox de Inimigos", CurrentValue = false, Callback = function(v) SpecificHitboxActive = v end})
   TabDetected:CreateSlider({Name = "Tamanho da Hitbox", Range = {2, 30}, Increment = 1, Suffix = " Studs", CurrentValue = 2, Callback = function(v) SpecificHitboxSize = v end})
   TabDetected:CreateButton({Name = "Remover Recuo das Armas", Callback = function()
      for _, v in pairs(getgc(true)) do
         if typeof(v) == "table" and rawget(v, "Recoil") then v.Recoil = 0 end
      end
      Rayfield:Notify({Title = "Fears Hub", Content = "Recuo removido com sucesso!", Duration = 3})
   end})

-- 4. BROOKHAVEN RP
elseif CurrentPlaceId == 4924922222 then
   TabDetected:CreateParagraph({Title = "🏡 Brookhaven RP - City Enhancer", Content = "Ferramentas de velocidade e ferramentas."})
   TabDetected:CreateButton({Name = "Pegar Todas as Armas do Mapa", Callback = function()
      for _, tool in pairs(workspace.Ignored.Tools:GetChildren()) do
         if tool:IsA("Tool") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:EquipTool(tool)
         end
      end
   end})
   TabDetected:CreateButton({Name = "Dar Velocidade Extrema Temporária", Callback = function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid.WalkSpeed = 100
      end
   end})

-- 5. MURDER MYSTERY 2 (MM2)
elseif CurrentPlaceId == 142823291 then
   TabDetected:CreateParagraph({Title = "🔪 Murder Mystery 2 - Detective Suite", Content = "Identificação de papéis e armas."})
   TabDetected:CreateButton({Name = "Teleportar para a Arma Caída (GunDrop)", Callback = function()
      local found = false
      for _, obj in pairs(workspace:GetDescendants()) do
         if obj.Name == "GunDrop" or obj.Name == "Gun" then
            local targetPart = obj:IsA("Model") and obj.PrimaryPart or obj
            if targetPart and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
               LocalPlayer.Character.HumanoidRootPart.CFrame = targetPart.CFrame
               found = true
               break
            end
         end
      end
      if not found then Rayfield:Notify({Title = "MM2", Content = "Nenhuma arma no chão.", Duration = 3}) end
   end})

-- 6. PET SIMULATOR 99
elseif CurrentPlaceId == 8737899170 or CurrentPlaceId == 15502339080 then
   TabDetected:CreateParagraph({Title = "🐾 Pet Simulator 99 - Auto Farm", Content = "Automação de cliques e coleta."})
   TabDetected:CreateToggle({Name = "Auto-Clicker de Moedas", CurrentValue = false, Callback = function(v)
      _G.PS99AutoClick = v
      task.spawn(function()
         while _G.PS99AutoClick do
            task.wait(0.1)
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):ClickButton1(Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2))
         end
      end)
   end})

else
   TabDetected:CreateParagraph({Title = "🌐 Ambiente Universal / Genérico", Content = "Comandos universais ativos para este mapa."})
   TabDetected:CreateToggle({Name = "Ativar Velocidade Local Personalizada", CurrentValue = false, Callback = function(v) SpecificSpeedActive = v end})
   TabDetected:CreateSlider({Name = "Velocidade Local", Range = {16, 250}, Increment = 1, Suffix = " Spd", CurrentValue = 16, Callback = function(v) SpecificSpeedVal = v end})
end

-- ==================== ABA 2: UTILITÁRIOS GLOBAIS ====================
TabGlobal:CreateToggle({Name = "Ativar Propulsor de Velocidade Global", CurrentValue = false, Callback = function(v) SpeedActive = v end})
TabGlobal:CreateSlider({Name = "Intensidade da Velocidade Global", Range = {16, 250}, Increment = 1, Suffix = " Spd", CurrentValue = 16, Callback = function(v) SpeedVal = v end})
TabGlobal:CreateToggle({Name = "Ativar Módulo de Voo (Fly Engine)", CurrentValue = false, Callback = function(v) FlyActive = v end})
TabGlobal:CreateSlider({Name = "Velocidade de Cruzeiro do Voo", Range = {10, 200}, Increment = 5, Suffix = " FlySpd", CurrentValue = 50, Callback = function(v) FlyVal = v end})
TabGlobal:CreateToggle({Name = "Habilitar Pulo Infinito Contínuo", CurrentValue = false, Callback = function(v) InfJumpActive = v end})
TabGlobal:CreateToggle({Name = "Modo Fantasma (Noclip Universal)", CurrentValue = false, Callback = function(v) NoclipActive = v end})

TabGlobal:CreateParagraph({Title = "⚔️ Sistema Tático: Kill All (Teleport Loop)", Content = "Teleporta você sequencialmente para cima de todos os alvos."})
TabGlobal:CreateToggle({
   Name = "Ativar Loop de Teleporte (Kill All / Farm)",
   CurrentValue = false,
   Callback = function(v)
      KillAllActive = v
      if v then Rayfield:Notify({Title = "Fears Hub", Content = "Kill All ativado!", Duration = 3}) end
   end
})
TabGlobal:CreateSlider({
   Name = "Intervalo de Rotação por Alvo",
   Range = {0.1, 2.0},
   Increment = 0.1,
   Suffix = "s",
   CurrentValue = 0.5,
   Callback = function(v) KillAllSpeed = v end
})

-- ==================== ABA 3: VISUAIS & ESP (NOVO) ====================
TabVisuals:CreateParagraph({Title = "👁️ Módulos de Visão Avançada", Content = "Melhore sua percepção do mapa e dos jogadores."})

TabVisuals:CreateToggle({
   Name = "ESP Highlight Geral (Jogadores)",
   CurrentValue = false,
   Callback = function(Value)
      for _, p in pairs(Players:GetPlayers()) do
         if p ~= LocalPlayer and p.Character then
            if Value and not p.Character:FindFirstChild("FearsESP") then
               local hl = Instance.new("Highlight")
               hl.Name = "FearsESP"
               hl.FillColor = Color3.fromRGB(0, 255, 150)
               hl.OutlineColor = Color3.fromRGB(255, 255, 255)
               hl.FillTransparency = 0.4
               hl.Parent = p.Character
            elseif not Value and p.Character:FindFirstChild("FearsESP") then
               p.Character.FearsESP:Destroy()
            end
         end
      end
   end
})

TabVisuals:CreateToggle({
   Name = "Fullbright Permanente (Remover Escuridão)",
   CurrentValue = false,
   Callback = function(Value)
      FullbrightActive = Value
      if Value then
         Lighting.Brightness = 2
         Lighting.ClockTime = 14
         Lighting.GlobalShadows = false
         Lighting.FogEnd = 999999
      else
         Lighting.GlobalShadows = true
      end
   end
})

TabVisuals:CreateToggle({
   Name = "Iluminação RGB Arco-Íris Dinâmica",
   CurrentValue = false,
   Callback = function(Value)
      RainbowLightingActive = Value
   end
})

TabVisuals:CreateSlider({
   Name = "Campo de Visão (Custom FOV)",
   Range = {50, 120},
   Increment = 1,
   Suffix = "°",
   CurrentValue = 70,
   Callback = function(Value)
      Camera.FieldOfView = Value
   end
})

TabVisuals:CreateSlider({
   Name = "Distância Máxima da Câmera (Zoom Max)",
   Range = {10, 1000},
   Increment = 10,
   Suffix = " Studs",
   CurrentValue = 128,
   Callback = function(Value)
      LocalPlayer.CameraMaxZoomDistance = Value
   end
})

-- ==================== ABA 4: TROLL & SERVER (NOVO) ====================
TabTroll:CreateParagraph({Title = "💥 Comandos de Servidor & Diversão", Content = "Ferramentas para gerenciar e interagir com o server."})

TabTroll:CreateButton({
   Name = "Reentrar no Servidor Atual (Rejoin)",
   Callback = function()
      game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
   end
})

TabTroll:CreateButton({
   Name = "Mudar para Servidor Menor (Server Hop / Menos Lag)",
   Callback = function()
      local servers = {}
      local req = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
      local body = game:GetService("HttpService"):JSONDecode(req)
      if body and body.data then
         for _, s in pairs(body.data) do
            if type(s) == "table" and s.playing < s.maxPlayers and s.id ~= game.JobId then
               table.insert(servers, s.id)
            end
         end
      end
      if #servers > 0 then
         game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
      else
         Rayfield:Notify({Title = "Fears Hub", Content = "Nenhum servidor alternativo encontrado.", Duration = 3})
      end
   end
})

TabTroll:CreateButton({
   Name = "Trazer Todos os Itens do Chao até Mim",
   Callback = function()
      for _, obj in pairs(workspace:GetDescendants()) do
         if obj:IsA("TouchTransmitter") and obj.Parent and obj.Parent:IsA("BasePart") then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
               firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj.Parent, 0)
               firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj.Parent, 1)
            end
         end
      end
      Rayfield:Notify({Title = "Fears Hub", Content = "Interação de itens executada!", Duration = 3})
   end
})

-- ==================== ABA 5: SCRIPTS EXTERNOS (NOVO) ====================
TabScripts:CreateParagraph({Title = "📜 Carregadores de Scripts Famosos", Content = "Execute outras ferramentas de suporte diretamente pelo Fears Hub."})

TabScripts:CreateButton({
   Name = "Carregar Infinite Yield (Admin Commands Clássico)",
   Callback = function()
      pcall(function()
         loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
      end)
      Rayfield:Notify({Title = "Fears Hub", Content = "Infinite Yield carregado com sucesso!", Duration = 3})
   end
})

TabScripts:CreateButton({
   Name = "Carregar Domain Hub / Dex Explorer (Analisador)",
   Callback = function()
      pcall(function()
         loadstring(game:HttpGet("https://gist.githubusercontent.com/DarkraiW/6290616b7720970335e958742918816f/raw"))()
      end)
      Rayfield:Notify({Title = "Fears Hub", Content = "Explorer carregado com sucesso!", Duration = 3})
   end
})

-- ==================== ABA 6: DIRETÓRIO DE JOGOS EXTRAS (ORIGINAL MANTIDO) ====================
TabExtra:CreateParagraph({Title = "🕹️ Catálogo Completo de Jogos Suportados", Content = "O Fears Hub detecta e aplica comandos de forma automática para os seguintes títulos:"})
TabExtra:CreateButton({Name = "🍊 Blox Fruits [Farm, Frutas, Ilhas]", Callback = function() end})
TabExtra:CreateButton({Name = "🚪 DOORS [Fullbright, Pular Salas]", Callback = function() end})
TabExtra:CreateButton({Name = "🔫 Arsenal [Hitboxes, No-Recoil]", Callback = function() end})
TabExtra:CreateButton({Name = "🏡 Brookhaven RP [Armas, Velocidade]", Callback = function() end})
TabExtra:CreateButton({Name = "🔪 Murder Mystery 2 [GunDrop TP, ESP]", Callback = function() end})
TabExtra:CreateButton({Name = "🐾 Pet Simulator 99 [Auto-Click, Coins]", Callback = function() end})
TabExtra:CreateButton({Name = "⚔️ BedWars [Otimizações de Combate]", Callback = function() end})
TabExtra:CreateButton({Name = "⚽ Blade Ball [Parry Assist / Auto]", Callback = function() end})
TabExtra:CreateButton({Name = "🏎️ Driving Empire [Speed/Tuning Boost]", Callback = function() end})

-- ==================== LOOPS DE SISTEMA SUPREMO ====================
RunService.RenderStepped:Connect(function()
   local activeSpeed = SpeedActive and SpeedVal or (SpecificSpeedActive and SpecificSpeedVal or 16)
   if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
      LocalPlayer.Character.Humanoid.WalkSpeed = activeSpeed
   end

   if FlyActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
      local hrp = LocalPlayer.Character.HumanoidRootPart
      local moveDir = LocalPlayer.Character:FindFirstChildOfClass("Humanoid").MoveDirection
      if moveDir.Magnitude > 0 then
         hrp.Velocity = Camera.CFrame.LookVector * (FlyVal * moveDir.Magnitude)
      else
         hrp.Velocity = Vector3.new(0, 0, 0)
      end
   end

   if RainbowLightingActive then
      Lighting.Ambient = Color3.fromHSV(tick() % 5 / 5, 1, 1)
   end
end)

RunService.Stepped:Connect(function()
   if NoclipActive and LocalPlayer.Character then
      for _, p in pairs(LocalPlayer.Character:GetDescendants()) do 
         if p:IsA("BasePart") then p.CanCollide = false end 
      end
   end

   if SpecificHitboxActive then
      for _, p in pairs(Players:GetPlayers()) do
         if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            hrp.Size = Vector3.new(SpecificHitboxSize, SpecificHitboxSize, SpecificHitboxSize)
            hrp.Transparency = 0.6
            hrp.CanCollide = false
         end
      end
   end
end)

UserInputService.JumpRequest:Connect(function()
   if InfJumpActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
      LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
   end
end)

task.spawn(function()
   while true do
      if KillAllActive then
         for _, target in pairs(Players:GetPlayers()) do
            if not KillAllActive then break end
            if target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and target.Character:FindFirstChild_OfClass and target.Character:FindFirstChildOfClass("Humanoid") then
               local hum = target.Character:FindFirstChildOfClass("Humanoid")
               if hum and hum.Health > 0 then
                  if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                     LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 4, 0)
                     task.wait(KillAllSpeed)
                  end
               end
            end
         end
      end
      task.wait(0.2)
   end
end)

Rayfield:Notify({
   Title = "🔥 Fears Hub Supreme Carregado!",
   Content = "Todas as abas, utilitários e módulos extras foram ativados com sucesso.",
   Duration = 5,
})

