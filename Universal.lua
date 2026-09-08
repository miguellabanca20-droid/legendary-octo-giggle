local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
   Name = "⚡ exclusivo para amigos | Hub",
   LoadingTitle = "Carregando Menu...",
   LoadingSubtitle = "exclusivo para amigos",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false
})

local TabESP     = Window:CreateTab("👁️ ESP Geral", 4483362458)
local TabCombat  = Window:CreateTab("🎯 Aimbot & Combat", 4483362458)
local TabMovement= Window:CreateTab("🚀 Movimento & Admin", 4483362458)
local TabAFK     = Window:CreateTab("💤 AFK & Otimização", 4483362458)
local TabSettings= Window:CreateTab("⚙️ Configurações", 4483362458)

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

local FlyEnabled = false
local FlyValue = 100
local NoclipEnabled = false
local SpinBotEnabled = false
local SpinSpeed = 100
local HitboxEnabled = false
local HitboxSize = 15
local AirWalkEnabled = false

local ESPEnabled = false
local ESPBox = false
local ESPName = false
local ESPDistance = false
local ESPLine = false

local AntiAFKEnabled = true
local AutoClickerEnabled = false
local AutoClickerDelay = 0.1
local BlackScreenEnabled = false

local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(0, 255, 150)
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 60
FOVCircle.Radius = FOVRadius
FOVCircle.Filled = false
FOVCircle.Visible = false

local ESPDrawings = {}

local function RemovePlayerESP(player)
   if ESPDrawings[player] then
      for _, drawing in pairs(ESPDrawings[player]) do
         if drawing then drawing:Remove() end
      end
      ESPDrawings[player] = nil
   end
end

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

-- ==================== ABA ESP ====================

TabESP:CreateParagraph({Title = "👁️ Sistema de ESP", Content = "Ative as opções abaixo para ver os jogadores."})

TabESP:CreateToggle({
   Name = "Ativar ESP Geral (Master)",
   CurrentValue = false,
   Callback = function(Value) 
      ESPEnabled = Value 
      if not Value then
         for _, p in pairs(Players:GetPlayers()) do RemovePlayerESP(p) end
      end
   end,
})

TabESP:CreateToggle({
   Name = "ESP Box (Caixa 2D)",
   CurrentValue = false,
   Callback = function(Value) ESPBox = Value end,
})

TabESP:CreateToggle({
   Name = "ESP Nome do Jogador",
   CurrentValue = false,
   Callback = function(Value) ESPName = Value end,
})

TabESP:CreateToggle({
   Name = "ESP Distância",
   CurrentValue = false,
   Callback = function(Value) ESPDistance = Value end,
})

TabESP:CreateToggle({
   Name = "ESP Linhas (Tracers)",
   CurrentValue = false,
   Callback = function(Value) ESPLine = Value end,
})

-- ==================== ABA COMBATE ====================

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
   Name = "Alvo do Aimbot/Silent",
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

-- ==================== ABA MOVIMENTO & ADMIN ====================

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

TabMovement:CreateParagraph({Title = "⚡ Poderes", Content = "Comandos adicionais."})

TabMovement:CreateToggle({
   Name = "Fly (Voo Rápido)",
   CurrentValue = false,
   Callback = function(Value) FlyEnabled = Value end,
})

TabMovement:CreateSlider({
   Name = "Velocidade do Fly",
   Range = {50, 300},
   Increment = 10,
   Suffix = " Speed",
   CurrentValue = 100,
   Callback = function(Value) FlyValue = Value end,
})

TabMovement:CreateToggle({
   Name = "Noclip (Atravessar TUDO)",
   CurrentValue = false,
   Callback = function(Value) NoclipEnabled = Value end,
})

TabMovement:CreateToggle({
   Name = "SpinBot (Girar Veloz)",
   CurrentValue = false,
   Callback = function(Value) SpinBotEnabled = Value end,
})

TabMovement:CreateSlider({
   Name = "Velocidade do SpinBot",
   Range = {20, 300},
   Increment = 10,
   Suffix = " Speed",
   CurrentValue = 100,
   Callback = function(Value) SpinSpeed = Value end,
})

TabMovement:CreateToggle({
   Name = "Super Hitbox (Gigante)",
   CurrentValue = false,
   Callback = function(Value) HitboxEnabled = Value end,
})

TabMovement:CreateSlider({
   Name = "Tamanho da Hitbox Inimiga",
   Range = {5, 50},
   Increment = 1,
   Suffix = " Studs",
   CurrentValue = 15,
   Callback = function(Value) HitboxSize = Value end,
})

TabMovement:CreateToggle({
   Name = "Air Walk (Piso Flutuante)",
   CurrentValue = false,
   Callback = function(Value)
      AirWalkEnabled = Value
      if not Value and workspace:FindFirstChild("AirWalkPart") then
         workspace.AirWalkPart:Destroy()
      end
   end,
})

TabMovement:CreateInput({
   Name = "Teleportar até Jogador (Nick)",
   PlaceholderText = "Nick do jogador...",
   RemoveTextOnFocusLost = false,
   Callback = function(Nick)
      if Nick == "" then return end
      for _, target in pairs(Players:GetPlayers()) do
         if target ~= LocalPlayer and (string.sub(string.lower(target.Name), 1, #Nick) == string.lower(Nick) or string.sub(string.lower(target.DisplayName), 1, #Nick) == string.lower(Nick)) then
            if target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
               LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
               Rayfield:Notify({Title = "Teleporte", Content = "Indo para: " .. target.DisplayName, Duration = 3})
               return
            end
         end
      end
   end,
})

TabMovement:CreateButton({
   Name = "Modo Deus (Godmode - Vida Máxima)",
   Callback = function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
         LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health = math.huge
         Rayfield:Notify({Title = "Godmode", Content = "Aplicado com sucesso!", Duration = 3})
      end
   end,
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

TabAFK:CreateToggle({
   Name = "Black Screen (Economia de Bateria)",
   CurrentValue = false,
   Flag = "BlackScreenToggle",
   Callback = function(Value)
      BlackScreenEnabled = Value
      local blackFrame = CoreGui:FindFirstChild("AFKBlackFrame")
      if Value then
         if not blackFrame then
            local sg = Instance.new("ScreenGui", CoreGui)
            sg.Name = "AFKBlackFrame"
            local frame = Instance.new("Frame", sg)
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            local txt = Instance.new("TextLabel", frame)
            txt.Size = UDim2.new(1, 0, 1, 0)
            txt.Text = "⚡ MODO AFK ATIVO\nEconomizando Bateria"
            txt.TextColor3 = Color3.fromRGB(0, 255, 150)
            txt.TextSize = 24
            txt.BackgroundTransparency = 1
         end
      else
         if blackFrame then blackFrame:Destroy() end
      end
   end,
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
      if CoreGui:FindFirstChild("AFKBlackFrame") then CoreGui.AFKBlackFrame:Destroy() end
      if workspace:FindFirstChild("AirWalkPart") then workspace.AirWalkPart:Destroy() end
      Rayfield:Destroy()
   end,
})

-- ==================== SISTEMAS E HOOKS DE SILENT AIM ====================

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

-- Hook nativo para redirecionar o Raycast do Silent Aim em armas/jogos compatíveis
local oldIndex
oldIndex = hookmetamethod(game, "__namecall", function(self, ...)
   local method = getnamecallmethod()
   local args = {...}
   
   if SilentAimEnabled and (method == "FindPartOnRay" or method == "FindPartOnRayWithIgnoreList" or method == "Raycast") then
      local target = GetClosestPlayer()
      if target and target.Character and target.Character:FindFirstChild(AimPart) then
         local targetPart = target.Character[AimPart]
         if method == "Raycast" and self == workspace then
            local origin = args[1]
            local direction = (targetPart.Position - origin).Unit * args[2].Magnitude
            args[2] = direction
            return oldIndex(self, unpack(args))
         end
      end
   end
   return oldIndex(self, ...)
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

   if ESPEnabled then
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

               if ESPBox then
                  cache.Box.Visible = true
                  cache.Box.Size = Vector2.new(width, height)
                  cache.Box.Position = Vector2.new(vector.X - width / 2, headPos.Y)
               else
                  cache.Box.Visible = false
               end

               if ESPName then
                  cache.Name.Visible = true
                  cache.Name.Text = player.Name
                  cache.Name.Position = Vector2.new(vector.X, headPos.Y - 18)
               else
                  cache.Name.Visible = false
               end

               if ESPDistance and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                  local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                  cache.Distance.Visible = true
                  cache.Distance.Text = "[" .. dist .. "m]"
                  cache.Distance.Position = Vector2.new(vector.X, legPos.Y + 2)
               else
                  cache.Distance.Visible = false
               end

               if ESPLine then
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

   if FlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
      local hrp = LocalPlayer.Character.HumanoidRootPart
      local moveDir = LocalPlayer.Character:FindFirstChildOfClass("Humanoid").MoveDirection
      if moveDir.Magnitude > 0 then
         hrp.Velocity = Camera.CFrame.LookVector * (FlyValue * moveDir.Magnitude)
      else
         hrp.Velocity = Vector3.new(0, 0, 0)
      end
   end

   if SpinBotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
      LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(SpinSpeed), 0)
   end

   if AirWalkEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
      local part = workspace:FindFirstChild("AirWalkPart") or Instance.new("Part", workspace)
      part.Name = "AirWalkPart"
      part.Size = Vector3.new(7, 1, 7)
      part.Transparency = 0.8
      part.Anchored = true
      part.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, -3.5, 0)
   end

   if AimbotEnabled or TriggerBotEnabled then
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
   
