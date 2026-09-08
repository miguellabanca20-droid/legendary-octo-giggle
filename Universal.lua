- Carrega a biblioteca Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Serviços do Roblox
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Criação da Janela com Sistema de Key Nativo
local Window = Rayfield:CreateWindow({
   Name = "⚡ exclusivo para amigos | Hub",
   LoadingTitle = "Verificando Acesso...",
   LoadingSubtitle = "exclusivo para amigos",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = true, -- Ativde key oficial do Rayfield
   KeySettings = {
      Title = "Painel Restrito",
      Subtitle = "Digite a Key de Acesso",
      Note = "A key correta é: amigos123",
      FileName = "AmigosKeyHub",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"amigos123"}
   }
})

-- TODAS AS ABAS (Liberadas após passar pela Key)
local TabAdmin    = Window:CreateTab("👑 Comandos & ESP Admin", 4483362458)
local TabCombat   = Window:CreateTab("🎯 Aimbot & Combat", 4483362458)
local TabMovement = Window:CreateTab("🚀 Movimento Básico", 4483362458)
local TabAFK      = Window:CreateTab("💤 AFK & Otimização", 4483362458)
local TabSettings = Window:CreateTab("⚙️ Configurações", 4483362458)

-- VARIÁVEIS DE CONTROLE GERAIS
local AimbotEnabled = false
local SilentAimEnabled = false
local TriggerBotEnabled = false
local AimPart = "Head"
local FOVRadius = 120
local ShowFOVCircle = false

local SpeedValue = 16
local SpeedEnabled = false
local JumpValue = 50
local JumpEnabled = false

-- Variáveis Protegidas do Admin (ESP e Poderes)
local AdminFlyEnabled = false
local AdminFlyValue = 100
local AdminNoclipEnabled = false
local AdminSpinBotEnabled = false
local AdminSpinSpeed = 100
local AdminHitboxEnabled = false
local AdminHitboxSize = 15
local AdminAirWalkEnabled = false

-- ESP Admin Variables
local AdminESPEnabled = false
local AdminESPBox = false
local AdminESPName = false
local AdminESPDistance = false
local AdminESPLine = false

local AntiAFKEnabled = true
local AutoClickerEnabled = false
local AutoClickerDelay = 0.1
local BlackScreenEnabled = false

-- Círculo FOV
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(0, 255, 150)
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 60
FOVCircle.Radius = FOVRadius
FOVCircle.Filled = false
FOVCircle.Visible = false

-- Tabela para armazenar desenhos de ESP da tela
local ESPDrawings = {}

local function RemovePlayerESP(player)
   if ESPDrawings[player] then
      for _, drawing in pairs(ESPDrawings[player]) do
         if drawing then drawing:Remove() end
      end
      ESPDrawings[player] = nil
   end
end

-- Função Auxiliar: Jogador Mais Próximo
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

-- ==================== ABA COMANDOS & ESP ADMIN ====================

TabAdmin:CreateParagraph({Title = "Modo Administrador Ativo", Content = "Aqui estão todos os comandos restritos e o ESP."})

TabAdmin:CreateParagraph({Title = "👁️ Sistema de ESP Admin", Content = "Ative as opções abaixo para ver os jogadores."})

TabAdmin:CreateToggle({
   Name = "Ativar ESP Geral (Master)",
   CurrentValue = false,
   Callback = function(Value) 
      AdminESPEnabled = Value 
      if not Value then
         for _, p in pairs(Players:GetPlayers()) do RemovePlayerESP(p) end
      end
   end,
})

TabAdmin:CreateToggle({
   Name = "ESP Box (Caixa 2D)",
   CurrentValue = false,
   Callback = function(Value) AdminESPBox = Value end,
})

TabAdmin:CreateToggle({
   Name = "ESP Nome do Jogador",
   CurrentValue = false,
   Callback = function(Value) AdminESPName = Value end,
})

TabAdmin:CreateToggle({
   Name = "ESP Distância",
   CurrentValue = false,
   Callback = function(Value) AdminESPDistance = Value end,
})

TabAdmin:CreateToggle({
   Name = "ESP Linhas (Tracers)",
   CurrentValue = false,
   Callback = function(Value) AdminESPLine = Value end,
})

TabAdmin:CreateParagraph({Title = "⚡ Movimento & Poderes Admin", Content = "Recursos avançados."})

TabAdmin:CreateToggle({
   Name = "Admin Fly (Voo Rápido)",
   CurrentValue = false,
   Callback = function(Value) AdminFlyEnabled = Value end,
})

TabAdmin:CreateSlider({
   Name = "Velocidade do Fly Admin",
   Range = {50, 300},
   Increment = 10,
   Suffix = " Speed",
   CurrentValue = 100,
   Callback = function(Value) AdminFlyValue = Value end,
})

TabAdmin:CreateToggle({
   Name = "Admin Noclip (Atravessar TUDO)",
   CurrentValue = false,
   Callback = function(Value) AdminNoclipEnabled = Value end,
})

TabAdmin:CreateToggle({
   Name = "Admin SpinBot (Girar Veloz)",
   CurrentValue = false,
   Callback = function(Value) AdminSpinBotEnabled = Value end,
})

TabAdmin:CreateSlider({
   Name = "Velocidade do SpinBot",
   Range = {20, 300},
   Increment = 10,
   Suffix = " Speed",
   CurrentValue = 100,
   Callback = function(Value) AdminSpinSpeed = Value end,
})

TabAdmin:CreateToggle({
   Name = "Super Hitbox (Gigante)",
   CurrentValue = false,
   Callback = function(Value) AdminHitboxEnabled = Value end,
})

TabAdmin:CreateSlider({
   Name = "Tamanho da Hitbox Inimiga",
   Range = {5, 50},
   Increment = 1,
   Suffix = " Studs",
   CurrentValue = 15,
   Callback = function(Value) AdminHitboxSize = Value end,
})

TabAdmin:CreateToggle({
   Name = "Air Walk (Piso Flutuante)",
   CurrentValue = false,
   Callback = function(Value)
      AdminAirWalkEnabled = Value
      if not Value and workspace:FindFirstChild("AdminAirWalkPart") then
         workspace.AdminAirWalkPart:Destroy()
      end
   end,
})

TabAdmin:CreateInput({
   Name = "Teleportar até Jogador (Nick)",
   PlaceholderText = "Nick do jogador...",
   RemoveTextOnFocusLost = false,
   Callback = function(Nick)
      if Nick == "" then return end
      for _, target in pairs(Players:GetPlayers()) do
         if target ~= LocalPlayer and (string.sub(string.lower(target.Name), 1, #Nick) == string.lower(Nick) or string.sub(string.lower(target.DisplayName), 1, #Nick) == string.lower(Nick)) then
            if target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
               LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
               Rayfield:Notify({Title = "Teleporte Admin", Content = "Indo para: " .. target.DisplayName, Duration = 3})
               return
            end
         end
      end
   end,
})

TabAdmin:CreateButton({
   Name = "Modo Deus (Godmode - Vida Máxima)",
   Callback = function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
         LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health = math.huge
         Rayfield:Notify({Title = "Admin", Content = "Godmode aplicado!", Duration = 3})
      end
   end,
})

-- ==================== ABA COMBATE (PÚBLICA) ====================

TabCombat:CreateToggle({
   Name = "Ativar Aimbot",
   CurrentValue = false,
   Flag = "AimbotToggle",
   Callback = function(Value) AimbotEnabled = Value end,
})

TabCombat:CreateToggle({
   Name = "Ativar Silent Aim",
   CurrentValue = false,
   Flag = "SilentAimToggle",
   Callback = function(Value) SilentAimEnabled = Value end,
})

TabCombat:CreateToggle({
   Name = "Ativar TriggerBot",
   CurrentValue = false,
   Flag = "TriggerBotToggle",
   Callback = function(Value) TriggerBotEnabled = Value end,
})

TabCombat:CreateDropdown({
   Name = "Alvo do Aimbot",
   Options = {"Head", "HumanoidRootPart"},
   CurrentOption = {"Head"},
   Flag = "AimPartDropdown",
   Callback = function(Option) AimPart = Option[1] or Option end,
})

TabCombat:CreateToggle({
   Name = "Mostrar Círculo FOV",
   CurrentValue = false,
   Flag = "FOVCircleToggle",
   Callback = function(Value)
      ShowFOVCircle = Value
      FOVCircle.Visible = Value
   end,
})

TabCombat:CreateSlider({
   Name = "Tamanho do Círculo FOV",
   Range = {30, 400},
   Increment = 5,
   Suffix = " px",
   CurrentValue = 120,
   Flag = "FOVSlider",
   Callback = function(Value)
      FOVRadius = Value
      FOVCircle.Radius = Value
   end,
})

-- ==================== ABA MOVIMENTO BÁSICO ====================

TabMovement:CreateToggle({
   Name = "Speed Hack",
   CurrentValue = false,
   Flag = "SpeedToggle",
   Callback = function(Value)
      SpeedEnabled = Value
      if not Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid.WalkSpeed = 16
      end
   end,
})

TabMovement:CreateSlider({
   Name = "Velocidade",
   Range = {16, 150},
   Increment = 1,
   Suffix = " Speed",
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(Value)
      SpeedValue = Value
      if SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

TabMovement:CreateToggle({
   Name = "Super Pulo",
   CurrentValue = false,
   Flag = "JumpToggle",
   Callback = function(Value) JumpEnabled = Value end,
})

TabMovement:CreateSlider({
   Name = "Força do Pulo",
   Range = {50, 200},
   Increment = 5,
   Suffix = " Power",
   CurrentValue = 50,
   Flag = "JumpSlider",
   Callback = function(Value) JumpValue = Value end,
})

-- ==================== ABA AFK & OTIMIZAÇÃO ====================

TabAFK:CreateToggle({
   Name = "Anti-AFK (Evita Expulsão)",
   CurrentValue = true,
   Flag = "AntiAFKToggle",
   Callback = function(Value) AntiAFKEnabled = Value end,
})

TabAFK:CreateToggle({
   Name = "Auto Clicker",
   CurrentValue = false,
   Flag = "AutoClickerToggle",
   Callback = function(Value) AutoClickerEnabled = Value end,
})

TabAFK:CreateSlider({
   Name = "Delay do Clicker (s)",
   Range = {0.05, 2},
   Increment = 0.05,
   Suffix = "s",
   CurrentValue = 0.1,
   Flag = "AutoClickerDelaySlider",
   Callback = function(Value) AutoClickerDelay = Value end,
})

TabAFK:CreateButton({
   Name = "Otimizar Gráficos (FPS Boost)",
   Callback = function()
      for _, v in pairs(game:GetDescendants()) do
         if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then
            v.Material = Enum.Material.SmoothPlastic
         elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
         end
      end
      game:GetService("Lighting").GlobalShadows = false
      Rayfield:Notify({Title = "FPS Boost", Content = "Gráficos Otimizados!", Duration = 3})
   end,
})

-- ==================== ABA CONFIGURAÇÕES ====================

TabSettings:CreateButton({
   Name = "Destruir Script",
   Callback = function()
      FOVCircle:Remove()
      for _, p in pairs(Players:GetPlayers()) do RemovePlayerESP(p) end
      if workspace:FindFirstChild("AdminAirWalkPart") then workspace.AdminAirWalkPart:Destroy() end
      Rayfield:Destroy()
   end,
})

-- ==================== SISTEMAS E THREADS ====================

Players.PlayerRemoving:Connect(function(player)
   RemovePlayerESP(player)
end)

LocalPlayer.Idled:Connect(function()
   if AntiAFKEnabled then
      VirtualUser:CaptureController()
      VirtualUser:ClickButton2(Vector2.new())
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

   if SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
      LocalPlayer.Character.Humanoid.WalkSpeed = SpeedValue
   end
   if JumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
      LocalPlayer.Character.Humanoid.UseJumpPower = true
      LocalPlayer.Character.Humanoid.JumpPower = JumpValue
   end

   -- ESP Loop
   if AdminESPEnabled then
      for _, player in pairs(Players:GetPlayers()) do
         if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local hrp = player.Character.HumanoidRootPart
            
            if not ESPDrawings[player] then
               ESPDrawings[player] = {
                  Box = Drawing.new("Square"),
                  Name = Drawing.new("Text"),
                  Distance = Drawing.new("Text"),
                  Line = Drawing.new("Line")
               }
               ESPDrawings[player].Box.Thickness = 1.5
               ESPDrawings[player].Box.Filled = false
               ESPDrawings[player].Box.Color = Color3.fromRGB(0, 255, 150)

               ESPDrawings[player].Name.Size = 14
               ESPDrawings[player].Name.Center = true
               ESPDrawings[player].Name.Outline = true
               ESPDrawings[player].Name.Color = Color3.fromRGB(255, 255, 255)

               ESPDrawings[player].Distance.Size = 13
               ESPDrawings[player].Distance.Center = true
               ESPDrawings[player].Distance.Outline = true
               ESPDrawings[player].Distance.Color = Color3.fromRGB(0, 255, 150)

               ESPDrawings[player].Line.Thickness = 1
               ESPDrawings[player].Line.Color = Color3.fromRGB(0, 255, 150)
            end

            local cache = ESPDrawings[player]
            local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)

            if onScreen and humanoid.Health > 0 then
               local headPos = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 2.2, 0))
               local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 2.5, 0))
               local height = math.abs(headPos.Y - legPos.Y)
               local width = height / 2

               if AdminESPBox then
                  cache.Box.Visible = true
                  cache.Box.Size = Vector2.new(width, height)
                  cache.Box.Position = Vector2.new(vector.X - width / 2, headPos.Y)
               else
                  cache.Box.Visible = false
               end

               if AdminESPName then
                  cache.Name.Visible = true
                  cache.Name.Text = player.Name
                  cache.Name.Position = Vector2.new(vector.X, headPos.Y - 18)
               else
                  cache.Name.Visible = false
               end

               if AdminESPDistance and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                  local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                  cache.Distance.Visible = true
                  cache.Distance.Text = "[" .. dist .. "m]"
                  cache.Distance.Position = Vector2.new(vector.X, legPos.Y + 2)
               else
                  cache.Distance.Visible = false
               end

               if AdminESPLine then
                  cache.Line.Visible = true
                  cache.Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                  cache.Line.To = Vector2.new(vector.X, legPos.Y)
               else
                  cache.Line.Visible = false
               end
            else
               cache.Box.Visible = false
               cache.Name.Visible = false
               cache.Distance.Visible = false
               cache.Line.Visible = false
            end
         else
            RemovePlayerESP(player)
         end
      end
   else
      for _, p in pairs(Players:GetPlayers()) do RemovePlayerESP(p) end
   end

   if AdminFlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
      local hrp = LocalPlayer.Character.HumanoidRootPart
      local moveDir = LocalPlayer.Character:FindFirstChildOfClass("Humanoid").MoveDirection
      if moveDir.Magnitude > 0 then
         hrp.Velocity = Camera.CFrame.LookVector * (AdminFlyValue * moveDir.Magnitude)
      else
         hrp.Velocity = Vector3.new(0, 0, 0)
      end
   end

   if AdminSpinBotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
      LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(AdminSpinSpeed), 0)
   end

   if AdminAirWalkEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
      local part = workspace:FindFirstChild("AdminAirWalkPart") or Instance.new("Part", workspace)
      part.Name = "AdminAirWalkPart"
      part.Size = Vector3.new(7, 1, 7)
      part.Transparency = 0.8
      part.Anchored = true
      part.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, -3.5, 0)
   end

   if AimbotEnabled or SilentAimEnabled or TriggerBotEnabled then
      local target = GetClosestPlayer()
      if target and target.Character and target.Character:FindFirstChild(AimPart) then
         local targetPos = target.Character[AimPart].Position
         if AimbotEnabled then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
         end
         if TriggerBotEnabled then
            local mouseRay = Camera:ViewportPointToRay(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
            local raycastParams = RaycastParams.new()
            raycastParams.FilterAncestorsCases = {LocalPlayer.Character}
            local result = workspace:Raycast(mouseRay.Origin, mouseRay.Direction * 500, raycastParams)
            if result and result.Instance and result.Instance:IsDescendantOf(target.Character) then
               VirtualUser:CaptureController()
               VirtualUser:ClickButton1(Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2))
            end
         end
      end
   end
end)

RunService.Stepped:Connect(function()
   if AdminNoclipEnabled and LocalPlayer.Character then
      for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
         if part:IsA("BasePart") then
            part.CanCollide = false
         end
      end
   end

   if AdminHitboxEnabled then
      for _, player in pairs(Players:GetPlayers()) do
         if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            hrp.Size = Vector3.new(AdminHitboxSize, AdminHitboxSize, AdminHitboxSize)
            hrp.Transparency = 0.7
            hrp.BrickColor = BrickColor.new("Really red")
            hrp.Material = Enum.Material.Neon
    -- Carrega a 
