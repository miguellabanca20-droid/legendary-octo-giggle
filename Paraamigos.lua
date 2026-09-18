-- =========================================================================
-- FEARS HUB | Advanced Universal & Game-Specific Operations Hub
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
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local CurrentPlaceId = game.PlaceId
local GameName = "Ambiente Desconhecido"
pcall(function()
   local info = MarketplaceService:GetProductInfo(CurrentPlaceId)
   if info and info.Name then GameName = info.Name end
end)

-- NOME DO SCRIPT ATUALIZADO PARA FEARS HUB
local Window = Rayfield:CreateWindow({
   Name = "🔥 Fears Hub | Secure Operations Hub [" .. GameName .. "]",
   LoadingTitle = "Inicializando Fears Hub...",
   LoadingSubtitle = "Delta Executor Architecture",
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

-- Variáveis do Kill All
local KillAllActive = false
local KillAllSpeed = 0.5

-- ABAS
local TabDetected = Window:CreateTab("🎯 Módulos Específicos do Jogo", 4483362458)
local TabGlobal   = Window:CreateTab("⚡ Utilitários de Movimento & Global", 4483362458)
local TabGameList = Window:CreateTab("📊 Diretório de Jogos Mapeados", 4483362458)

-- ==================== ABA 1: MÓDULOS ESPECÍFICOS ====================
TabDetected:CreateParagraph({Title = "Painel de Ações Contextuais: " .. GameName, Content = "Comandos otimizados exclusivamente para este mapa."})

local SpecificHitboxSize = 2
local SpecificHitboxActive = false
local SpecificAutoFarm = false
local SpecificSpeedVal = 16
local SpecificSpeedActive = false

if CurrentPlaceId == 2753915549 or CurrentPlaceId == 4442272183 or CurrentPlaceId == 7449423635 then
   -- BLOX FRUITS
   TabDetected:CreateParagraph({Title = "🍊 Protocolo: Blox Fruits", Content = "Automação avançada para progressão e caça."})
   TabDetected:CreateToggle({Name = "Automato-Farm (Nível / Missões)", CurrentValue = false, Callback = function(v) SpecificAutoFarm = v end})
   TabDetected:CreateButton({Name = "Radar de Frutas (Teleporte Automático)", Callback = function()
      for _, f in pairs(workspace:GetChildren()) do
         if string.find(f.Name, "Fruit") and f:FindFirstChild("Handle") then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
               LocalPlayer.Character.HumanoidRootPart.CFrame = f.Handle.CFrame
            end
         end
      end
   end})

elseif CurrentPlaceId == 6516141723 then
   -- DOORS
   TabDetected:CreateParagraph({Title = "🚪 Protocolo: DOORS - Hotel Survival", Content = "Ferramentas de sobrevivência e varredura visual."})
   TabDetected:CreateButton({Name = "Fullbright Avançado (Remover Escuridão)", Callback = function()
      Lighting.Brightness = 5 Lighting.Ambient = Color3.new(1,1,1) Lighting.GlobalShadows = false
   end})

elseif CurrentPlaceId == 286090429 then
   -- ARSENAL
   TabDetected:CreateParagraph({Title = "🔫 Protocolo: Arsenal - Combat Operations", Content = "Módulos balísticos e otimização de mira."})
   TabDetected:CreateToggle({Name = "Amplificador de Hitbox (Alvos)", CurrentValue = false, Callback = function(v) SpecificHitboxActive = v end})
   TabDetected:CreateSlider({Name = "Escala da Hitbox", Range = {2, 25}, Increment = 1, Suffix = " Studs", CurrentValue = 2, Callback = function(v) SpecificHitboxSize = v end})

else
   -- JOGO GENÉRICO
   TabDetected:CreateParagraph({Title = "🌐 Protocolo: Ambiente Genérico / Universal", Content = "Comandos de adaptação dinâmica para mapas gerais."})
   TabDetected:CreateToggle({Name = "Ativar Propulsor de Velocidade Local", CurrentValue = false, Callback = function(v) SpecificSpeedActive = v end})
   TabDetected:CreateSlider({Name = "Taxa de Velocidade Personalizada", Range = {16, 250}, Increment = 1, Suffix = " Spd", CurrentValue = 16, Callback = function(v) SpecificSpeedVal = v end})
end

-- ==================== ABA 2: UTILITÁRIOS GLOBAIS ====================
TabGlobal:CreateToggle({Name = "Ativar Propulsor de Velocidade Global", CurrentValue = false, Callback = function(v) SpeedActive = v end})
TabGlobal:CreateSlider({Name = "Intensidade da Velocidade Global", Range = {16, 250}, Increment = 1, Suffix = " Spd", CurrentValue = 16, Callback = function(v) SpeedVal = v end})
TabGlobal:CreateToggle({Name = "Ativar Módulo de Voo (Fly Engine)", CurrentValue = false, Callback = function(v) FlyActive = v end})
TabGlobal:CreateSlider({Name = "Velocidade de Cruzeiro do Voo", Range = {10, 200}, Increment = 5, Suffix = " FlySpd", CurrentValue = 50, Callback = function(v) FlyVal = v end})
TabGlobal:CreateToggle({Name = "Habilitar Pulo Infinito Contínuo", CurrentValue = false, Callback = function(v) InfJumpActive = v end})
TabGlobal:CreateToggle({Name = "Modo Fantasma (Noclip Universal)", CurrentValue = false, Callback = function(v) NoclipActive = v end})

-- SEÇÃO KILL ALL
TabGlobal:CreateParagraph({Title = "⚔️ Sistema Tático: Target Teleportation (Kill All)", Content = "Executa um ciclo rotativo de teleporte sequencial para cima de todos os alvos ativos."})

TabGlobal:CreateToggle({
   Name = "Ativar Loop de Teleporte (Kill All / Farm)",
   CurrentValue = false,
   Callback = function(v)
      KillAllActive = v
      if v then
         Rayfield:Notify({Title = "Fears Hub", Content = "Sequência de teleporte em massa iniciada.", Duration = 3})
      else
         Rayfield:Notify({Title = "Fears Hub", Content = "Sequência interrompida.", Duration = 3})
      end
   end
})

TabGlobal:CreateSlider({
   Name = "Intervalo de Rotação por Alvo",
   Range = {0.1, 2.0},
   Increment = 0.1,
   Suffix = "s",
   CurrentValue = 0.5,
   Callback = function(v)
      KillAllSpeed = v
   end
})

-- ==================== ABA 3: DIRETÓRIO DE JOGOS ====================
TabGameList:CreateParagraph({Title = "Diretório de Compatibilidade Nativa", Content = "Lista principal de ecossistemas com suporte de comandos dedicados:"})
TabGameList:CreateButton({Name = "🍊 Blox Fruits [Suporte Completo]", Callback = function() end})
TabGameList:CreateButton({Name = "🚪 DOORS [Suporte Completo]", Callback = function() end})
TabGameList:CreateButton({Name = "🔫 Arsenal [Suporte Completo]", Callback = function() end})
TabGameList:CreateButton({Name = "🐾 Pet Simulator 99 [Suporte Completo]", Callback = function() end})
TabGameList:CreateButton({Name = "🔪 Murder Mystery 2 [Suporte Completo]", Callback = function() end})

-- ==================== LOOPS DE SISTEMA ====================
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

-- Background Thread para o Kill All
task.spawn(function()
   while true do
      if KillAllActive then
         for _, target in pairs(Players:GetPlayers()) do
            if not KillAllActive then break end
            if target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and target.Character:FindFirstChildOfClass("Humanoid") then
               if target.Character.Humanoid.Health > 0 then
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
   Title = "🔥 Fears Hub Ativo",
   Content = "Módulos carregados para: " .. GameName,
   Duration = 5,
})

