-- Carrega a biblioteca Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Serviços do Roblox
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Criação da Janela Principal (Sem Sistema de Key)
local Window = Rayfield:CreateWindow({
   Name = "⚡ exclusivo para amigos | Full Hub",
   LoadingTitle = "Carregando Todos os Comandos...",
   LoadingSubtitle = "exclusivo para amigos",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false
})

-- ABAS DO MENU
local TabESP      = Window:CreateTab("👁️ Visuais & ESP", 4483362458)
local TabCombat   = Window:CreateTab("🎯 Aimbot & Combat", 4483362458)
local TabMovement = Window:CreateTab("🚀 Movimento & Poderes", 4483362458)
local TabTeleport = Window:CreateTab("🌎 Teleportes", 4483362458)
local TabAFK      = Window:CreateTab("💤 AFK & Otimização", 4483362458)
local TabSettings = Window:CreateTab("⚙️ Configurações", 4483362458)

-- VARIÁVEIS DE CONTROLE
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
local FlySpeed = 50
local NoclipEnabled = false
local SpinBotEnabled = false
local SpinSpeed = 50
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

local TargetPlayerName = ""

-- Círculo FOV
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(0, 255, 150)
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 60
FOVCircle.Radius = FOVRadius
FOVCircle.Filled = false
FOVCircle.Visible = false

-- Tabela para armazenar desenhos de ESP
local ESPDrawings = {}

-- Função para remover ESP de um jogador
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

-- ==================== ABA ESP ====================

TabESP:CreateToggle({
   Name = "Ativar ESP Master",
   CurrentValue = false,
   Callback = function(Value) 
      ESPEnabled = Value 
      if not Value then
         for _, p in pairs(Players:GetPlayers()) do RemovePlayerESP(p) end
      end
   end,
})

TabESP:CreateToggle({Name = "ESP Box (Caixa 2D)", CurrentValue = false, Callback = function(Value) ESPBox = Value end})
TabESP:CreateToggle({Name = "ESP Nome", CurrentValue = false, Callback = function(Value) ESPName = Value end})
TabESP:CreateToggle({Name = "ESP Distância", CurrentValue = false, Callback = function(Value) ESPDistance = Value end})
TabESP:CreateToggle({Name = "ESP Linha (Tracer)", CurrentValue = false, Callback = function(Value) ESPLine = Value end})

TabESP:CreateButton({
   Name = "Visão Noturna (Fullbright)",
   Callback = function()
      game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
      game:GetService("Lighting").Brightness = 2
      game:GetService("Lighting").GlobalShadows = false
   end,
})

-- ==================== ABA COMBATE ====================

TabCombat:CreateToggle({Name = "Aimbot (Trava Mira)", CurrentValue = false, Callback = function(Value) AimbotEnabled = Value end})
TabCombat:CreateToggle({Name = "Silent Aim (tiro curva)", CurrentValue = false, Callback = function(Value) SilentAimEnabled = Value end})
TabCombat:CreateToggle({Name = "TriggerBot (Atira Auto)", CurrentValue = false, Callback = function(Value) TriggerBotEnabled = Value end})
TabCombat:CreateDropdown({Name = "Parte do Corpo", Options = {"Head", "HumanoidRootPart"}, CurrentOption = {"Head"}, Callback = function(Option) AimPart = Option[1] or Option end})

TabCombat:CreateToggle({Name = "Mostrar Círculo FOV", CurrentValue = false, Callback = function(Value) ShowFOVCircle = Value; FOVCircle.Visible = Value end})
TabCombat:CreateSlider({Name = "Tamanho FOV", Range = {30, 500}, Increment = 5, Suffix = " px", CurrentValue = 120, Callback = function(Value) FOVRadius = Value; FOVCircle.Radius = Value end})

-- ==================== ABA MOVIMENTO & PODERES ====================

TabMovement:CreateToggle({Name = "Speed Hack", CurrentValue = false, Callback = function(Value) SpeedEnabled = Value end})
TabMovement:CreateSlider({Name = "Velocidade", Range = {16, 350}, Increment = 1, Suffix = " Speed", CurrentValue = 16, Callback = function(Value) SpeedValue = Value end})
TabMovement:CreateToggle({Name = "Super Pulo", CurrentValue = false, Callback = function(Value) JumpEnabled = Value end})
TabMovement:CreateSlider({Name = "Força Pulo", Range = {50, 300}, Increment = 5, Suffix = " Power", CurrentValue = 50, Callback = function(Value) JumpValue = Value end})

TabMovement:CreateParagraph({Title = "⚡ Poderes Admin", Content = "Comandos de movimentação avançada."})
TabMovement:CreateToggle({Name = "Fly (Voo Direcional)", CurrentValue = false, Callback = function(Value) FlyEnabled = Value end})
TabMovement:CreateSlider({Name = "Velocidade do Voo", Range = {10, 250}, Increment = 5, Suffix = " Speed", CurrentValue = 50, Callback = function(Value) FlySpeed = Value end})
TabMovement:CreateToggle({Name = "Noclip (Atravessar Paredes)", CurrentValue = false, Callback = function(Value) NoclipEnabled = Value end})
TabMovement:CreateToggle({Name = "SpinBot (Girar Rápido)", CurrentValue = false, Callback = function(Value) SpinBotEnabled = Value end})
TabMovement:CreateSlider({Name = "Velocidade SpinBot", Range = {10, 300}, Increment = 5, Suffix = " RPM", CurrentValue = 50, Callback = function(Value) SpinSpeed = Value end})
TabMovement:CreateToggle({Name = "Expandir Hitbox Inimiga", CurrentValue = false, Callback = function(Value) HitboxEnabled = Value end})
TabMovement:CreateSlider({Name = "Tamanho Hitbox", Range = {2, 50}, Increment = 1, Suffix = " Studs", CurrentValue = 15, Callback = function(Value) HitboxSize = Value end})
TabMovement:CreateToggle({Name = "Air Walk (Andar no Ar)", CurrentValue = false, Callback = function(Value) AirWalkEnabled = Value end})
TabMovement:CreateButton({Name = "Modo Deus (Godmode)", Callback = function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health = 9e9 end end})

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

-- ==================== ABA AFK & OTIMIZAÇÃO ====================

TabAFK:CreateToggle({Name = "Anti-AFK", CurrentValue = true, Callback = function(Value) AntiAFKEnabled = Value end})
TabAFK:CreateToggle({Name = "Auto Clicker", CurrentValue = false, Callback = function(Value) AutoClickerEnabled = Value end})
TabAFK:CreateSlider({Name = "Delay Click (seg)", Range = {0.05, 2}, Increment = 0.05, Suffix = "s", CurrentValue = 0.1, Callback = function(Value) AutoClickerDelay = Value end})
TabAFK:CreateToggle({Name = "Black Screen (Economia Bateria)", CurrentValue = false, Callback = function(Value)
    BlackScreenEnabled = Value
    local blackFrame = CoreGui:FindFirstChild("AFKBlackFrame")
    if Value then
        if not blackFrame then
            local sg = Instance.new("ScreenGui", CoreGui); sg.Name = "AFKBlackFrame"
            local frame = Instance.new("Frame", sg); frame.Size = UDim2.new(1, 0, 1, 0); frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            local txt = Instance.new("TextLabel", frame); txt.Size = UDim2.new(1, 0, 1, 0); txt.Text = "⚡ MODO AFK ATIVO\nEconomizando Bateria"; txt.TextColor3 = Color3.fromRGB(0, 255, 150); txt.TextSize = 24; txt.BackgroundTransparency = 1
        end
    else
        if blackFrame then blackFrame:Destroy() end
    end
end})
TabAFK:CreateButton({Name = "Otimizar Gráficos (FPS Boost)", Callback = function()
    for _, v in pairs(game:GetDescendants()) do if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then v.Material = Enum.Material.SmoothPlastic elseif v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end end
    game:GetService("Lighting").GlobalShadows = false
end})

-- ==================== ABA CONFIGURAÇÕES ====================
TabSettings:CreateButton({Name = "Destruir Script", Callback = function()
    FOVCircle:Remove()
    for _, p in pairs(Players:GetPlayers()) do RemovePlayerESP(p) end
    if CoreGui:FindFirstChild("AFKBlackFrame") then CoreGui.AFKBlackFrame:Destroy() end
    if workspace:FindFirstChild("AirWalkPart") then workspace.AirWalkPart:Destroy() end
    Rayfield:Destroy()
end})

-- ==================== SISTEMAS E THREADS ====================

-- Anti-AFK
LocalPlayer.Idled:Connect(function() if AntiAFKEnabled then VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end end)

-- Auto Clicker
task.spawn(function() while true do task.wait(AutoClickerDelay) if AutoClickerEnabled then VirtualUser:CaptureController(); VirtualUser:ClickButton1(Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)) end end end)

-- Loop Principal (Render & Stepped)
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    if SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = SpeedValue end
    if JumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.UseJumpPower = true; LocalPlayer.Character.Humanoid.JumpPower = JumpValue end
    if FlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local moveDir = LocalPlayer.Character:FindFirstChildOfClass("Humanoid").MoveDirection
        if moveDir.Magnitude > 0 then hrp.Velocity = Camera.CFrame.LookVector * (FlySpeed * moveDir.Magnitude) else hrp.Velocity = Vector3.new(0, 0, 0) end
    end
    if SpinBotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(SpinSpeed), 0) end
    if AirWalkEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local part = workspace:FindFirstChild("AirWalkPart") or Instance.new("Part", workspace); part.Name = "AirWalkPart"; part.Size = Vector3.new(7, 1, 7); part.Transparency = 0.8; part.Anchored = true; part.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, -3.5, 0)
    end
    if (AimbotEnabled or SilentAimEnabled or TriggerBotEnabled) then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(AimPart) then
            local targetPos = target.Character[AimPart].Position
            if AimbotEnabled then Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos) end
            if TriggerBotEnabled then local mouseRay = Camera:ViewportPointToRay(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2); local raycastParams = RaycastParams.new
               
