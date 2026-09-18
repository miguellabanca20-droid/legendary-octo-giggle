-- =========================================================================
-- FEARS HUB | Supreme Ultimate Edition (Versão 100% Corrigida e Completa)
-- =========================================================================

-- Inicialização segura para garantir que o Rayfield carregue sem travar
local success, Rayfield = pcall(function()
   return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success or not Rayfield then
   warn("Falha crítica ao carregar a interface Rayfield.")
   return
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local MarketplaceService = game:GetService("MarketplaceService")
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
   Name = "🔥 Fears Hub Supreme | [" .. GameName .. "]",
   LoadingTitle = "Iniciando Fears Hub...",
   LoadingSubtitle = "Carregando Módulos Completos",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false
})

-- Variáveis Globais
local SpeedVal = 16
local SpeedActive = false
local FlyVal = 50
local FlyActive = false
local InfJumpActive = false
local NoclipActive = false

local ServerHopEnabled = false
local FullbrightActive = false
local RainbowLightingActive = false
local TargetPlayerName = ""

local KillAllActive = false
local KillAllSpeed = 0.5

-- ABAS DO HUB
local TabDetected = Window:CreateTab("🎯 Jogo Atual", 4483362458)
local TabGlobal   = Window:CreateTab("⚡ Movimento & Global", 4483362458)
local TabTeleport = Window:CreateTab("📍 Teleporte & Jogadores", 4483362458)
local TabVisuals  = Window:CreateTab("👁️ Visuais & ESP", 4483362458)
local TabTroll    = Window:CreateTab("💥 Troll & Server", 4483362458)
local TabScripts  = Window:CreateTab("📜 Scripts Externos", 4483362458)
local TabExtra    = Window:CreateTab("🎮 Todos os Jogos", 4483362458)

-- ==================== ABA 1: JOGO ATUAL ====================
TabDetected:CreateParagraph({Title = "Painel Dinâmico: " .. GameName, Content = "Detectando recursos específicos para este jogo..."})

local SpecificHitboxSize = 2
local SpecificHitboxActive = false
local SpecificSpeedVal = 16
local SpecificSpeedActive = false

if CurrentPlaceId == 2753915549 or CurrentPlaceId == 4442272183 or CurrentPlaceId == 7449423635 then
   TabDetected:CreateParagraph({Title = "🍊 Blox Fruits Detectado", Content = "Ferramentas de navegação e ilhas ativas."})
   TabDetected:CreateButton({Name = "Teleportar para Ilha Inicial", Callback = function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
         LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(979.3, 16.2, 1429.5)
      end
   end})
   TabDetected:CreateButton({Name = "Radar de Frutas no Mapa", Callback = function()
      for _, f in pairs(workspace:GetChildren()) do
         if string.find(f.Name, "Fruit") and f:FindFirstChild("Handle") then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
               LocalPlayer.Character.HumanoidRootPart.CFrame = f.Handle.CFrame
               Rayfield:Notify({Title = "Fears Hub", Content = "Fruta encontrada!", Duration = 3})
            end
         end
      end
   end})
elseif CurrentPlaceId == 286090429 then
   TabDetected:CreateParagraph({Title = "🔫 Arsenal Detectado", Content = "Módulos de combate ativos."})
   TabDetected:CreateToggle({Name = "Expandir Hitbox de Inimigos", CurrentValue = false, Callback = function(v) SpecificHitboxActive = v end})
   TabDetected:CreateSlider({Name = "Tamanho da Hitbox", Range = {2, 30}, Increment = 1, Suffix = " Studs", CurrentValue = 2, Callback = function(v) SpecificHitboxSize = v end})
else
   TabDetected:CreateParagraph({Title = "🌐 Modo Universal", Content = "Nenhum jogo restrito detectado. Usando modo padrão."})
   TabDetected:CreateToggle({Name = "Ativar Velocidade Específica", CurrentValue = false, Callback = function(v) SpecificSpeedActive = v end})
   TabDetected:CreateSlider({Name = "Velocidade Específica", Range = {16, 250}, Increment = 1, Suffix = " Spd", CurrentValue = 16, Callback = function(v) SpecificSpeedVal = v end})
end

-- ==================== ABA 2: MOVIMENTO & GLOBAL ====================
TabGlobal:CreateToggle({Name = "Ativar Speed Hack", CurrentValue = false, Callback = function(v) SpeedActive = v end})
TabGlobal:CreateSlider({Name = "Velocidade (WalkSpeed)", Range = {16, 300}, Increment = 1, Suffix = " Spd", CurrentValue = 16, Callback = function(v) SpeedVal = v end})

TabGlobal:CreateToggle({Name = "Ativar Fly (Voo)", CurrentValue = false, Callback = function(v) FlyActive = v end})
TabGlobal:CreateSlider({Name = "Velocidade do Voo", Range = {10, 200}, Increment = 5, Suffix = " FlySpd", CurrentValue = 50, Callback = function(v) FlyVal = v end})

TabGlobal:CreateToggle({Name = "Pulo Infinito", CurrentValue = false, Callback = function(v) InfJumpActive = v end})
TabGlobal:CreateToggle({Name = "Atravessar Paredes (Noclip)", CurrentValue = false, Callback = function(v) NoclipActive = v end})

TabGlobal:CreateParagraph({Title = "⚔️ Sistema Kill All (Teleport Loop)", Content = "Vai até os jogadores em loop automático."})
TabGlobal:CreateToggle({Name = "Ativar Kill All Loop", CurrentValue = false, Callback = function(v) KillAllActive = v end})
TabGlobal:CreateSlider({Name = "Velocidade do Loop", Range = {0.1, 2.0}, Increment = 0.1, Suffix = "s", CurrentValue = 0.5, Callback = function(v) KillAllSpeed = v end})

-- ==================== ABA 3: TELEPORTE ====================
TabTeleport:CreateInput({
   Name = "Nick do Jogador (ou parte do nome)",
   PlaceholderText = "Digite o nome...",
   RemoveTextOnFocusLost = false,
   Callback = function(Text) TargetPlayerName = Text end,
})

TabTeleport:CreateButton({
   Name = "Teleportar até o Jogador",
   Callback = function()
      if TargetPlayerName == "" then
         Rayfield:Notify({Title = "Aviso", Content = "Digite um nome primeiro!", Duration = 3})
         return
      end
      local found = nil
      for _, p in pairs(Players:GetPlayers()) do
         if p ~= LocalPlayer and (string.sub(string.lower(p.Name), 1, #TargetPlayerName) == string.lower(TargetPlayerName) or string.sub(string.lower(p.DisplayName), 1, #TargetPlayerName) == string.lower(TargetPlayerName)) then
            found = p
            break
         end
      end
      if found and found.Character and found.Character:FindFirstChild("HumanoidRootPart") then
         if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = found.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
            Rayfield:Notify({Title = "Sucesso", Content = "Teleportado para " .. found.DisplayName, Duration = 3})
         end
      else
         Rayfield:Notify({Title = "Erro", Content = "Jogador não encontrado.", Duration = 3})
      end
   end,
})

-- ==================== ABA 4: VISUAIS & ESP ====================
TabVisuals:CreateToggle({
   Name = "ESP Highlight (Ver pelas paredes)",
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
   Name = "Fullbright (Visão Noturna)",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         Lighting.Brightness = 2
         Lighting.ClockTime = 14
         Lighting.GlobalShadows = false
      else
         Lighting.GlobalShadows = true
      end
   end
})

TabVisuals:CreateSlider({
   Name = "Campo de Visão (FOV)",
   Range = {50, 120},
   Increment = 1,
   Suffix = "°",
   CurrentValue = 70,
   Callback = function(Value) Camera.FieldOfView = Value end,
})

-- ==================== ABA 5: TROLL & SERVER ====================
TabTroll:CreateButton({
   Name = "Reentrar no Servidor (Rejoin)",
   Callback = function()
      game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
   end
})

TabTroll:CreateButton({
   Name = "Mudar para Servidor Menor (Server Hop)",
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
         Rayfield:Notify({Title = "Fears Hub", Content = "Nenhum servidor encontrado.", Duration = 3})
      end
   end
})

-- ==================== ABA 6: SCRIPTS EXTERNOS ====================
TabScripts:CreateButton({
   Name = "Carregar Infinite Yield (Admin)",
   Callback = function()
      pcall(function()
         loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
      end)
      Rayfield:Notify({Title = "Fears Hub", Content = "Infinite Yield carregado!", Duration = 3})
   end
})

-- ==================== ABA 7: TODOS OS JOGOS ====================
TabExtra:CreateParagraph({Title = "Jogos Compatíveis", Content = "Blox Fruits, DOORS, Arsenal, Brookhaven, MM2, Pet Sim 99, etc."})

-- ==================== LOOPS DE EXECUÇÃO ====================
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
            if target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
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
   Content = "Painel aberto com sucesso no Delta.",
   Duration = 5,
})
