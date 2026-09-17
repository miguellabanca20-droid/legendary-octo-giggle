-- Carrega a biblioteca Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Serviços do Roblox
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")
local MarketplaceService = game:GetService("MarketplaceService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

-- Descobre o nome do jogo atual de forma segura
local GameName = "Jogo Desconhecido"
pcall(function()
   local info = MarketplaceService:GetProductInfo(PlaceId)
   if info and info.Name then
      GameName = info.Name
   end
end)

-- Criação da Janela Principal
local Window = Rayfield:CreateWindow({
   Name = "⚡ Hub Inteligente | Jogo: " .. GameName,
   LoadingTitle = "Detectando Jogo Atual...",
   LoadingSubtitle = "PlaceId: " .. tostring(PlaceId),
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false
})

-- ==================== ABAS DO MENU ====================
-- Aba Dinâmica do Jogo Atual (Fica em primeiro lugar para fácil acesso)
local TabGameSpecific = Window:CreateTab("🎮 Jogo Atual", 4483362458)
local TabCombat       = Window:CreateTab("🎯 Combate & Mira", 4483362458)
local TabMovement     = Window:CreateTab("🚀 Movimento", 4483362458)
local TabESP          = Window:CreateTab("👁️ ESP Paredes", 4483362458)
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

-- ==================== DETECÇÃO AUTOMÁTICA DE JOGO E COMANDOS ESPECÍFICOS ====================

TabGameSpecific:CreateParagraph({
   Title = "🎮 Jogo Detectado: " .. GameName,
   Content = "ID do Jogo: " .. tostring(PlaceId) .. "\nOs comandos abaixo foram adaptados automaticamente para este jogo."
})

-- Identificação por IDs conhecidos de jogos populares no Roblox
-- Murder Mystery 2 (PlaceId: 142823291)
if PlaceId == 142823291 or string.find(string.lower(GameName), "murder mystery") then
   TabGameSpecific:CreateButton({
      Name = "🔪 MM2: Puxar Arma Caída no Chão",
      Callback = function()
         local found = false
         for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "GunDrop" or obj.Name == "Gun" then
               local targetPart = obj:IsA("Model") and obj.PrimaryPart or obj
               if targetPart and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                  LocalPlayer.Character.HumanoidRootPart.CFrame = targetPart.CFrame
                  Rayfield:Notify({Title = "MM2", Content = "Teleportado até a arma!", Duration = 3})
                  found = true
                  break
               end
            end
         end
         if not found then Rayfield:Notify({Title = "MM2", Content = "Nenhuma arma caída encontrada.", Duration = 3}) end
      end,
   })

-- Blox Fruits (PlaceId: 2753915549)
elseif PlaceId == 2753915549 or string.find(string.lower(GameName), "blox fruits") then
   TabGameSpecific:CreateToggle({
      Name = "🍎 Blox Fruits: Auto-Clicker de Ataque/Farm",
      CurrentValue = false,
      Callback = function(Value)
         AutoClickerEnabled = Value
         Rayfield:Notify({Title = "Blox Fruits", Content = "Auto-Click: " .. tostring(Value), Duration = 3})
      end,
   })
   TabGameSpecific:CreateButton({
      Name = "⚡ Blox Fruits: Aumentar Velocidade (Super Humanoid)",
      Callback = function()
         if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 50
            Rayfield:Notify({Title = "Blox Fruits", Content = "Velocidade ajustada para farm!", Duration = 3})
         end
      end,
   })

-- Blade Ball (PlaceId: 13772394625)
elseif PlaceId == 13772394625 or string.find(string.lower(GameName), "blade ball") then
   TabGameSpecific:CreateButton({
      Name = "⚔️ Blade Ball: Expandir FOV de Reação da Bola",
      Callback = function()
         FOVRadius = 300
         FOVCircle.Radius = 300
         ShowFOVCircle = true
         FOVCircle.Visible = true
         Rayfield:Notify({Title = "Blade Ball", Content = "Foco expandido para facilitar o Parry!", Duration = 3})
      end,
   })

-- Doors (PlaceId: 6516141723)
elseif PlaceId == 6516141723 or string.find(string.lower(GameName), "doors") then
   TabGameSpecific:CreateButton({
      Name = "🚪 Doors: Fullbright (Visão Total na Escuridão)",
      Callback = function()
         game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
         game:GetService("Lighting").Brightness = 4
         game:GetService("Lighting").GlobalShadows = false
         Rayfield:Notify({Title = "Doors", Content = "Salas escuras iluminadas!", Duration = 3})
      end,
   })

-- BedWars (PlaceId: 6872265039)
elseif PlaceId == 6872265039 or string.find(string.lower(GameName), "bedwars") then
   TabGameSpecific:CreateButton({
      Name = "🛌 BedWars: Boost de Velocidade PvP",
      Callback = function()
         if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 23
            Rayfield:Notify({Title = "BedWars", Content = "Velocidade otimizada para PvP!", Duration = 3})
         end
      end,
   })

-- Arsenal (PlaceId: 286090429)
elseif PlaceId == 286090429 or string.find(string.lower(GameName), "arsenal") then
   TabGameSpecific:CreateButton({
      Name = "🔫 Arsenal: Remover Tremor de Câmera (No-Recoil Visual)",
      Callback = function()
         for _, v in pairs(Camera:GetDescendants()) do
            if v:IsA("CameraShaker") then v:Destroy() end
         end
         Rayfield:Notify({Title = "Arsenal", Content = "Efeitos de recuo removidos!", Duration = 3})
      end,
   })

-- Brookhaven RP (PlaceId: 4924922222)
elseif PlaceId == 4924922222 or string.find(string.lower(GameName), "brookhaven") then
   TabGameSpecific:CreateButton({
      Name = "🏡 Brookhaven: Modo Fantasma (Invisibilidade Leve)",
      Callback = function()
         if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
               if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                  part.Transparency = 0.9
               elseif part:IsA("Decal") then
                  part.Transparency = 0.9
               end
            end
            Rayfield:Notify({Title = "Brookhaven", Content = "Modo Fantasma Ativado!", Duration = 3})
         end
      end,
   })

-- Caso genérico (Pet Sim / Simulators / Outros)
else
   TabGameSpecific:CreateParagraph({
      Title = "ℹ️ Modo Universal Ativo",
      Content = "Nenhum script nativo exclusivo obrigatório para este ID exato. Utilize as ferramentas universais de coleta automática abaixo:"
   })
   
   TabGameSpecific:CreateToggle({
      Name = "🥚 Auto-Coleta Genérica (Ovos / Moedas / Gems)",
      CurrentValue = false,
      Callback = function(Value)
         _G.AutoFarmSims = Value
         task.spawn(function()
            while _G.AutoFarmSims do
               task.wait(0.4)
               for _, item in pairs(workspace:GetDescendants()) do
                  if not _G.AutoFarmSims then break end
                  if string.find(string.lower(item.Name), "coin") or string.find(string.lower(item.Name), "gem") or string.find(string.lower(item.Name), "egg") or string.find(string.lower(item.Name), "ovo") then
                     if item:IsA("BasePart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        if (LocalPlayer.Character.HumanoidRootPart.Position - item.Position).Magnitude < 40 then
                           LocalPlayer.Character.HumanoidRootPart.CFrame = item.CFrame
                        end
                     end
                  end
               end
            end
         end)
      end,
   })
end

-- ==================== ABA COMBATE ====================
TabCombat:CreateToggle({Name = "Aimbot (Trava Mira)", CurrentValue = false, Callback = function(Value) AimbotEnabled = Value end})
TabCombat:CreateDropdown({Name = "Parte do Corpo", Options = {"Head", "HumanoidRootPart"}, CurrentOption = {"Head"}, Callback = function(Option) AimPart = Option[1] or Option end})
TabCombat:CreateToggle({Name = "Mostrar Círculo FOV", CurrentValue = false, Callback = function(Value) ShowFOVCircle = Value; FOVCircle.Visible = Value end})
TabCombat:CreateSlider({Name = "Tamanho FOV", Range = {30, 500}, Increment = 5, Suffix = " px", CurrentValue = 120, Callback = function(Value) FOVRadius = Value; FOVCircle.Radius = Value end})

-- ==================== ABA MOVIMENTO ====================
TabMovement:CreateToggle({Name = "Speed Hack", CurrentValue = false, Callback = function(Value) SpeedEnabled = Value end})
TabMovement:CreateSlider({Name = "Velocidade", Range = {16, 250}, Increment = 1, Suffix = " Speed", CurrentValue = 16, Callback = function(Value) SpeedValue = Value end})
TabMovement:CreateToggle({Name = "Super Pulo", CurrentValue = false, Callback = function(Value) JumpEnabled = Value end})
TabMovement:CreateSlider({Name = "Força Pulo", Range = {50, 300}, Increment = 5, Suffix = " Power", CurrentValue = 50, Callback = function(Value) JumpValue = Value end})
TabMovement:CreateToggle({Name = "Pulo Infinito", CurrentValue = false, Callback = function(Value) InfJumpEnabled = Value end})
TabMovement:CreateToggle({Name = "Noclip (Atravessar Paredes)", CurrentValue = false, Callback = function(Value) NoclipEnabled = Value end})
TabMovement:CreateToggle({Name = "Expandir Hitbox Inimiga", CurrentValue = false, Callback = function(Value) HitboxEnabled = Value end})
TabMovement:CreateSlider({Name = "Tamanho Hitbox", Range = {2, 30}, Increment = 1, Suffix = " Studs", CurrentValue = 15, Callback = function(Value) HitboxSize = Value end})

-- ==================== ABA ESP PAREDES ====================
TabESP:CreateToggle({
   Name = "ESP Chams (Ver através da parede)",
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

-- ==================== ABA UTILIDADES ====================
TabAFK:CreateToggle({Name = "Anti-AFK", CurrentValue = true, Callback = function(Value) AntiAFKEnabled = Value end})
TabAFK:CreateToggle({Name = "Auto Clicker", CurrentValue = false, Callback = function(Value) AutoClickerEnabled = Value end})
TabAFK:CreateSlider({Name = "Delay Click (seg)", Range = {0.05, 2}, Increment = 0.05, Suffix = "s", CurrentValue = 0.1, Callback = function(Value) AutoClickerDelay = Value end})
TabAFK:CreateButton({Name = "Otimizar Gráficos (FPS Boost)", Callback = function()
    for _, v in pairs(game:GetDescendants()) do if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then v.Material = Enum.Material.SmoothPlastic elseif v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end end
    game:GetService("Lighting").GlobalShadows = false
end})

-- ==================== ABA CONFIGURAÇÕES ====================
TabSettings:CreateButton({Name = "Destruir Script", Callback = function()
    FOVCircle:Remove()
    _G.AutoFarmSims = false
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("ESPHighlight") then
            player.Character.ESPHighlight:Destroy()
        end
    end
    Rayfield:Destroy()
end})

-- ==================== SISTEMAS E THREADS ====================

LocalPlayer.Idled:Connect(function() if AntiAFKEnabled then VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end end)

UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

task.spawn(function()
   while true do
      task.wait(AutoClickerDelay)
      if AutoClickerEnabled then
         VirtualUser:CaptureController()
         VirtualUser:ClickButton1(Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2))
      end
   end
end)

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    if SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = SpeedValue end
    if JumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.UseJumpPower = true; LocalPlayer.Character.Humanoid.JumpPower = JumpValue end
    
    if AimbotEnabled then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(AimPart) then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character[AimPart].Position)
        end
    end
end)

RunService.Stepped:Connect(function()
   if NoclipEnabled and LocalPlayer.Character then
      for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
         if part:IsA("BasePart") then part.CanCollide = false end
      end
   end
   if HitboxEnabled then
      for _, player in pairs(Players:GetPlayers()) do
         if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            hrp.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
            hrp.Transparency = 0.6
            hrp.CanCollide = false
         end
      end
   end
end)

Rayfield:Notify({Title = "⚡ Carregado com Sucesso!", Content = "Detectado: " .. GameName, Duration = 5})
