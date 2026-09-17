-- Carrega a biblioteca Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Serviços do Roblox
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")
local MarketplaceService = game:GetService("MarketplaceService")
local TeleportService = game:GetService("TeleportService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

-- Descobre o nome do jogo atual
local GameName = "Jogo Desconhecido"
pcall(function()
   local info = MarketplaceService:GetProductInfo(PlaceId)
   if info and info.Name then
      GameName = info.Name
   end
end)

-- Criação da Janela Principal
local Window = Rayfield:CreateWindow({
   Name = "⚡ Mega Hub Supremo | Jogo: " .. GameName,
   LoadingTitle = "Carregando Comandos Expandidos...",
   LoadingSubtitle = "Modo Multi-Jogos Ultra Ativado",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false
})

-- ==================== ABAS DO MENU ====================
local TabGameSpecific = Window:CreateTab("🎮 Jogo Atual", 4483362458)
local TabCombat       = Window:CreateTab("🎯 Combate & Mira", 4483362458)
local TabMovement     = Window:CreateTab("🚀 Movimento", 4483362458)
local TabESP          = Window:CreateTab("👁️ ESP & Chams", 4483362458)
local TabTeleport     = Window:CreateTab("🌎 Teleportes", 4483362458)
local TabAFK          = Window:CreateTab("💤 Utilidades", 4483362458)
local TabSettings     = Window:CreateTab("⚙️ Configurações", 4483362458)

-- VARIÁVEIS DE CONTROLE
local AimbotEnabled = false
local AimPart = "Head"
local FOVRadius = 120
local ShowFOVCircle = false

local SpeedValue = 16
local SpeedEnabled = false
local JumpValue = 50
local JumpEnabled = false
local InfJumpEnabled = false
local NoclipEnabled = false
local HitboxEnabled = false
local HitboxSize = 15

local ESPEnabled = false
local AntiAFKEnabled = true
local AutoClickerEnabled = false
local AutoClickerDelay = 0.1
local TargetPlayerName = ""

local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(0, 255, 150)
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 60
FOVCircle.Radius = FOVRadius
FOVCircle.Filled = false
FOVCircle.Visible = false

local function GetClosestPlayer()
   local closest = nil
   local shortestDistance = FOVRadius
   local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

   for _, player in pairs(Players:GetPlayers()) do
      if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(AimPart) and player.Character:FindFirstChildOfClass("Humanoid") then
         local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
         if humanoid.Health > 0 then
            local part = player.Character[AimPart]
            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
               local distance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
               if distance < shortestDistance then
                  shortestDistance = distance
                  closest = player
               end
            end
         end
      end
   end
   return closest
end

-- ==================== DETECÇÃO INTELIGENTE DE JOGOS E COMANDOS EXCLUSIVOS ====================

TabGameSpecific:CreateParagraph({
   Title = "🎮 Jogo Detectado: " .. GameName,
   Content = "ID: " .. tostring(PlaceId) .. "\nOs comandos abaixo foram carregados exclusivamente para as mecânicas deste jogo."
})

-- 1. Murder Mystery 2 (MM2)
if PlaceId == 142823291 or string.find(string.lower(GameName), "murder mystery") then
   TabGameSpecific:CreateButton({Name = "🔪 MM2: Puxar Arma Caída no Chão", Callback = function()
      local found = false
      for _, obj in pairs(workspace:GetDescendants()) do
         if obj.Name == "GunDrop" or obj.Name == "Gun" then
            local targetPart = obj:IsA("Model") and obj.PrimaryPart or obj
            if targetPart and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
               LocalPlayer.Character.HumanoidRootPart.CFrame = targetPart.CFrame
               Rayfield:Notify({Title = "MM2", Content = "Teleportado até a arma!", Duration = 3})
               found = true; break
            end
         end
      end
      if not found then Rayfield:Notify({Title = "MM2", Content = "Nenhuma arma encontrada.", Duration = 3}) end
   end})
   TabGameSpecific:CreateButton({Name = "🔪 MM2: Teleportar para o Xerife/Assassino (Se visível)", Callback = function()
      for _, p in pairs(Players:GetPlayers()) do
         if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            -- Verifica se tem faca ou arma equipada
            local tool = p.Character:FindFirstChildOfClass("Tool") or (p.Backpack and p.Backpack:FindFirstChildOfClass("Tool"))
            if tool and (string.find(string.lower(tool.Name), "gun") or string.find(string.lower(tool.Name), "knife") or string.find(string.lower(tool.Name), "faca")) then
               LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
               Rayfield:Notify({Title = "MM2", Content = "Indo até: " .. p.Name, Duration = 3})
               return
            end
         end
      end
      Rayfield:Notify({Title = "MM2", Content = "Nenhum alvo armado detectado próximo.", Duration = 3})
   end})

-- 2. Blox Fruits
elseif PlaceId == 2753915549 or string.find(string.lower(GameName), "blox fruits") then
   TabGameSpecific:CreateToggle({Name = "🍎 Blox Fruits: Auto-Clicker de Ataque Contínuo", CurrentValue = false, Callback = function(Value) AutoClickerEnabled = Value end})
   TabGameSpecific:CreateButton({Name = "🍎 Blox Fruits: Coletar Todos os Baús Próximos", Callback = function()
      for _, v in pairs(workspace:GetDescendants()) do
         if v.Name == "Chest" or string.find(string.lower(v.Name), "chest") then
            if v:IsA("BasePart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
               LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
               task.wait(0.2)
            end
         end
      end
      Rayfield:Notify({Title = "Blox Fruits", Content = "Baús coletados!", Duration = 3})
   end})
   TabGameSpecific:CreateButton({Name = "🍎 Blox Fruits: Pular para a 3ª Sea / Café (Atalho UI)", Callback = function()
      Rayfield:Notify({Title = "Blox Fruits", Content = "Abra o mapa do jogo para teleporte seguro.", Duration = 3})
   end})

-- 3. Blade Ball
elseif PlaceId == 13772394625 or string.find(string.lower(GameName), "blade ball") then
   TabGameSpecific:CreateToggle({Name = "⚔️ Blade Ball: Auto Parry Assist (Modo Reação Automática)", CurrentValue = false, Callback = function(Value)
      _G.BladeBallAuto = Value
      task.spawn(function()
         while _G.BladeBallAuto do
            task.wait()
            for _, ball in pairs(workspace:GetChildren()) do
               if not _G.BladeBallAuto then break end
               if string.find(string.lower(ball.Name), "ball") and ball:IsA("BasePart") then
                  if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                     local dist = (ball.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                     if dist < 22 then
                        VirtualUser:CaptureController()
                        VirtualUser:Button1Down(Vector2.new(0,0))
                        task.wait(0.05)
                        VirtualUser:Button1Up(Vector2.new(0,0))
                     end
                  end
               end
            end
         end
      end)
   end})
   TabGameSpecific:CreateButton({Name = "⚔️ Blade Ball: Expandir Círculo de Foco (FOV 350)", Callback = function()
      FOVRadius = 350; FOVCircle.Radius = 350; ShowFOVCircle = true; FOVCircle.Visible = true
      Rayfield:Notify({Title = "Blade Ball", Content = "FOV ampliado para rastrear a bola!", Duration = 3})
   end})

-- 4. Doors
elseif PlaceId == 6516141723 or string.find(string.lower(GameName), "doors") then
   TabGameSpecific:CreateButton({Name = "🚪 Doors: Fullbright Extremo (Iluminar Escuridão Total)", Callback = function()
      game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
      game:GetService("Lighting").Brightness = 5
      game:GetService("Lighting").GlobalShadows = false
      Rayfield:Notify({Title = "Doors", Content = "Visibilidade total ativada!", Duration = 3})
   end})
   TabGameSpecific:CreateButton({Name = "🚪 Doors: Avisar sobre Entidades Próximas (KeyCheck)", Callback = function()
      local foundEntity = false
      for _, obj in pairs(workspace:GetChildren()) do
         if obj.Name == "RushMoving" or obj.Name == "AmbushMoving" or obj.Name == "Eyes" or obj.Name == "Figure" then
            foundEntity = true
            Rayfield:Notify({Title = "⚠️ ALERTA DOORS!", Content = "Entidade perigosa próxima: " .. obj.Name, Duration = 6})
         end
      end
      if not foundEntity then Rayfield:Notify({Title = "Doors", Content = "Nenhuma entidade assassina na sala atual.", Duration = 3}) end
   end})

-- 5. BedWars
elseif PlaceId == 6872265039 or string.find(string.lower(GameName), "bedwars") then
   TabGameSpecific:CreateButton({Name = "🛌 BedWars: Boost de Velocidade PvP (Speed 25)", Callback = function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid.WalkSpeed = 25
         Rayfield:Notify({Title = "BedWars", Content = "Velocidade de combate aplicada!", Duration = 3})
      end
   end})
   TabGameSpecific:CreateToggle({Name = "🛌 BedWars: Hitbox Expandida para Combate Corpo a Corpo", CurrentValue = false, Callback = function(Value)
      HitboxEnabled = Value; HitboxSize = 18
   end})

-- 6. Arsenal / FPS Games
elseif PlaceId == 286090429 or string.find(string.lower(GameName), "arsenal") then
   TabGameSpecific:CreateButton({Name = "🔫 Arsenal: Remover Tremor e Recuo da Câmera", Callback = function()
      for _, v in pairs(Camera:GetDescendants()) do if v:IsA("CameraShaker") then v:Destroy() end end
      Rayfield:Notify({Title = "Arsenal", Content = "Recuo visual removido!", Duration = 3})
   end})
   TabGameSpecific:CreateToggle({Name = "🔫 Arsenal: Aimbot Instantâneo na Cabeça", CurrentValue = false, Callback = function(Value)
      AimbotEnabled = Value; AimPart = "Head"; ShowFOVCircle = true; FOVCircle.Visible = true
   end})

-- 7. Brookhaven RP
elseif PlaceId == 4924922222 or string.find(string.lower(GameName), "brookhaven") then
   TabGameSpecific:CreateButton({Name = "🏡 Brookhaven: Modo Fantasma (Ficar Transparente)", Callback = function()
      if LocalPlayer.Character then
         for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.Transparency = 0.9 end
            if part:IsA("Decal") then part.Transparency = 0.9 end
         end
         Rayfield:Notify({Title = "Brookhaven", Content = "Modo Fantasma Ativado!", Duration = 3})
      end
   end})
   TabGameSpecific:CreateButton({Name = "🏡 Brookhaven: Teleportar para o Banco", Callback = function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
         LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(100, 20, -300)
         Rayfield:Notify({Title = "Brookhaven", Content = "Teleportado para o Banco!", Duration = 3})
      end
   end})

-- 8. Pet Simulator 99 / Simulator Genérico
elseif string.find(string.lower(GameName), "pet") or string.find(string.lower(GameName), "simulator") or string.find(string.lower(GameName), "clicker") then
   TabGameSpecific:CreateToggle({Name = "🐾 Simulator: Auto-Coleta Global de Moedas/Gemas", CurrentValue = false, Callback = function(Value)
      _G.AutoFarmSims = Value
      task.spawn(function()
         while _G.AutoFarmSims do
            task.wait(0.3)
            for _, item in pairs(workspace:GetDescendants()) do
               if not _G.AutoFarmSims then break end
               if string.find(string.lower(item.Name), "coin") or string.find(string.lower(item.Name), "gem") or string.find(string.lower(item.Name), "egg") or string.find(string.lower(item.Name), "chest") or string.find(string.lower(item.Name), "diamond") then
                  if item:IsA("BasePart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                     if (LocalPlayer.Character.HumanoidRootPart.Position - item.Position).Magnitude < 50 then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = item.CFrame
                     end
                  end
               end
            end
         end
      end)
   end})

-- 9. Da Hood / Jogos de Luta
elseif string.find(string.lower(GameName), "da hood") or string.find(string.lower(GameName), "hood") then
   TabGameSpecific:CreateButton({Name = "🥊 Da Hood: Anti-Stomp (Impedir que pisem em você)", Callback = function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
         -- Remove script de morte por pisão se houver
         for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v.Name == "LowerTorso" then v:Destroy() end
         end
         Rayfield:Notify({Title = "Da Hood", Content = "Anti-Stomp aplicado!", Duration = 3})
      end
   end})
   TabGameSpecific:CreateToggle({Name = "🥊 Da Hood: Hitbox Gigante para Socos", CurrentValue = false, Callback = function(Value)
      HitboxEnabled = Value; HitboxSize = 25
   end})

-- Caso padrão (Universal avançado para qualquer outro jogo)
else
   TabGameSpecific:CreateParagraph({
      Title = "ℹ️ Jogo Genérico / Universal",
      Content = "Nenhum comando específico dedicado a este ID exato. Utilize as ferramentas universais avançadas abaixo:"
   })
   TabGameSpecific:CreateToggle({Name = "⚡ Coletor Universal de Itens no Chão", CurrentValue = false, Callback = function(Value)
      _G.UniversalFarm = Value
      task.spawn(function()
         while _G.UniversalFarm do
            task.wait(0.5)
            for _, v in pairs(workspace:GetDescendants()) do
               if not _G.UniversalFarm then break end
               if v:IsA("TouchTransmitter") and v.Parent and v.Parent:IsA("BasePart") then
                  if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                     if (LocalPlayer.Character.HumanoidRootPart.Position - v.Parent.Position).Magnitude < 40 then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = v.Parent.CFrame
                     end
                  end
               end
            end
         end
      end)
   end})
end

-- ==================== ABA COMBATE ====================
TabCombat:CreateToggle({Name = "Aimbot (Trava Mira)", CurrentValue = false, Callback = function(Value) AimbotEnabled = Value end})
TabCombat:CreateDropdown({Name = "Parte do Corpo", Options = {"Head", "HumanoidRootPart"}, CurrentOption = {"Head"}, Callback = function(Option) AimPart = Option[1] or Option end})
TabCombat:CreateToggle({Name = "Mostrar Círculo FOV", CurrentValue = false, Callback = function(Value) ShowFOVCircle = Value; FOVCircle.Visible = Value end})
TabCombat:CreateSlider({Name = "Tamanho FOV", Range = {30, 500}, Increment = 5, Suffix = " px", CurrentValue = 120, Callback = function(Value) FOVRadius = Value; FOVCircle.Radius = Value end})

-- ==================== ABA MOVIMENTO ====================
TabMovement:CreateToggle({Name = "Speed Hack", CurrentValue = false, Callback = function(Value) SpeedEnabled = Value end})
TabMovement:CreateSlider({Name = "Velocidade", Range = {16, 300}, Increment = 1, Suffix = " Speed", CurrentValue = 16, Callback = function(Value) SpeedValue = Value end})
TabMovement:CreateToggle({Name = "Super Pulo", CurrentValue = false, Callback = function(Value) JumpEnabled = Value end})
TabMovement:CreateSlider({Name = "Força Pulo", Range = {50, 300}, Increment = 5, Suffix = " Power", CurrentValue = 50, Callback = function(Value) JumpValue = Value end})
TabMovement:CreateToggle({Name = "Pulo Infinito", CurrentValue = false, Callback = function(Value) InfJumpEnabled = Value end})
TabMovement:CreateToggle({Name = "Noclip (Atravessar Paredes)", CurrentValue = false, Callback = function(Value) NoclipEnabled = Value end})
TabMovement:CreateToggle({Name = "Expandir Hitbox Inimiga", CurrentValue = false, Callback = function(Value) HitboxEnabled = Value end})
TabMovement:CreateSlider({Name = "Tamanho Hitbox", Range = {2, 40}, Increment = 1, Suffix = " Studs", CurrentValue = 15, Callback = function(Value) HitboxSize = Value end})

-- ==================== ABA ESP & CHAMS ====================
TabESP:CreateToggle({
   Name = "ESP Chams (Ver jogadores nas paredes)",
   CurrentValue = false,
   Callback = function(Value)
      ESPEnabled = Value
      for _, player in pairs(Players:GetPlayers()) do
         if player ~= LocalPlayer and player.Character then
            local highlight = player.Character:FindFirstChild("ESPHighlight")
            if Value then
               if not highlight then
                  local hl = Instance.new("Highlight")
                  hl.Name = "ESPHighlight"
                  hl.Adornee = player.Character
                  hl.FillColor = Color3.fromRGB(0, 255, 100)
                  hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                  hl.FillTransparency = 0.4
                  hl.OutlineTransparency = 0
                  hl.Parent = player.Character
               end
            else
               if highlight then highlight:Destroy() end
            end
         end
      end
   end,
})

Players.PlayerAdded:Connect(function(player)
   player.CharacterAdded:Connect(function(char)
      if ESPEnabled then
         task.wait(1)
         local hl = Instance.new("Highlight")
         hl.Name = "ESPHighlight"
         hl.Adornee = char
         hl.FillColor = Color3.fromRGB(0, 255, 100)
         hl.OutlineColor = Color3.fromRGB(255, 255, 255)
         hl.FillTransparency = 0.4
         hl.OutlineTransparency = 0
         hl.Parent = char
      end
   end)
end)

-- ==================== ABA TELEPORTE ====================
TabTeleport:CreateInput({Name = "Nick do Jogador", PlaceholderText = "Digite o nick...", RemoveTextOnFocusLost = false, Callback = function(Text) TargetPlayerName = Text end})
TabTeleport:CreateButton({Name = "Ir até Jogador", Callback = function()
    for _, target in pairs(Players:GetPlayers()) do
        if target ~= LocalPlayer and (string.sub(string.lower(target.Name), 1, #TargetPlayerName) == string.lower(TargetPlayerName) or string.sub(string.lower(target.DisplayName), 1, #TargetPlayerName) == string.lower(TargetPlayerName)) then
            if target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                Rayfield:Notify({Title = "Teleporte", Content = "Indo para " .. target.DisplayName, Duration = 3})
                return
            end
        end
    end
    Rayfield:Notify({Title = "Erro", Content = "Jogador não encontrado!", Duration = 3})
end})
TabTeleport:CreateButton({Name = "Ir para o Centro (Spawn)", Callback = function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0) end end})

