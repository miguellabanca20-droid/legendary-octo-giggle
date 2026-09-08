-- Carrega a biblioteca Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Criação da Janela Principal
local Window = Rayfield:CreateWindow({
   Name = "⚡ exclusivo para amigos",
   LoadingTitle = "Carregando Rayfield...",
   LoadingSubtitle = "exclusivo para amigos",
   ShowText = "⚡",
   Theme = "Default",
   ConfigurationSaving = {
      Enabled = false
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false
})

-- ABAS
local TabMovement = Window:CreateTab("🚀 Movimento", 4483362458)
local TabTeleport = Window:CreateTab("📍 Teleporte", 4483362458)
local TabVisuals  = Window:CreateTab("👁️ Visuais", 4483362458)
local TabSettings = Window:CreateTab("⚙️ Menu", 4483362458)

-- VARIÁVEIS DE CONTROLE
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local SpeedValue = 16
local SpeedEnabled = false

local FlyValue = 50
local FlyEnabled = false

local InfJumpEnabled = false
local NoclipEnabled = false
local TargetPlayerName = ""

-- ==================== ABA MOVIMENTO ====================

TabMovement:CreateToggle({
   Name = "Ativar Speed Hack",
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
   Name = "Velocidade do Speed",
   Range = {16, 300},
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
   Name = "Ativar Fly (Voo)",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
      FlyEnabled = Value
   end,
})

TabMovement:CreateSlider({
   Name = "Velocidade do Fly",
   Range = {10, 200},
   Increment = 5,
   Suffix = " FlySpeed",
   CurrentValue = 50,
   Flag = "FlySlider",
   Callback = function(Value)
      FlyValue = Value
   end,
})

TabMovement:CreateToggle({
   Name = "Pulo Infinito",
   CurrentValue = false,
   Flag = "InfJumpToggle",
   Callback = function(Value)
      InfJumpEnabled = Value
   end,
})

TabMovement:CreateToggle({
   Name = "Atravessar Paredes (Noclip)",
   CurrentValue = false,
   Flag = "NoclipToggle",
   Callback = function(Value)
      NoclipEnabled = Value
   end,
})

-- ==================== ABA TELEPORTE ====================

TabTeleport:CreateInput({
   Name = "Nick do Jogador (Ou parte do nome)",
   PlaceholderText = "Ex: Player123",
   RemoveTextOnFocusLost = false,
   Callback = function(Text)
      TargetPlayerName = Text
   end,
})

TabTeleport:CreateButton({
   Name = "Teleportar até o Jogador",
   Callback = function()
      if TargetPlayerName == "" then
         Rayfield:Notify({Title = "Aviso", Content = "Digite o Nick do jogador primeiro!", Duration = 3})
         return
      end

      local foundPlayer = nil
      for _, target in pairs(Players:GetPlayers()) do
         if target ~= LocalPlayer then
            if string.sub(string.lower(target.Name), 1, #TargetPlayerName) == string.lower(TargetPlayerName) or
               string.sub(string.lower(target.DisplayName), 1, #TargetPlayerName) == string.lower(TargetPlayerName) then
               foundPlayer = target
               break
            end
         end
      end

      if foundPlayer and foundPlayer.Character and foundPlayer.Character:FindFirstChild("HumanoidRootPart") then
         if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = foundPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
            Rayfield:Notify({Title = "Teleportado!", Content = "Você foi até: " .. foundPlayer.DisplayName, Duration = 3})
         end
      else
         Rayfield:Notify({Title = "Erro", Content = "Jogador não encontrado.", Duration = 3})
      end
   end,
})

-- ==================== ABA VISUAIS ====================

TabVisuals:CreateToggle({
   Name = "ESP - Ver Jogadores nas Paredes",
   CurrentValue = false,
   Flag = "ESPToggle",
   Callback = function(Value)
      for _, player in pairs(Players:GetPlayers()) do
         if player ~= LocalPlayer and player.Character then
            if Value then
               if not player.Character:FindFirstChild("HighlightESP") then
                  local highlight = Instance.new("Highlight")
                  highlight.Name = "HighlightESP"
                  highlight.FillColor = Color3.fromRGB(0, 255, 150)
                  highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                  highlight.FillTransparency = 0.5
                  highlight.Parent = player.Character
               end
            else
               if player.Character:FindFirstChild("HighlightESP") then
                  player.Character.HighlightESP:Destroy()
               end
            end
         end
      end
   end,
})

TabVisuals:CreateButton({
   Name = "Visão Noturna (Fullbright)",
   Callback = function()
      game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
      game:GetService("Lighting").Brightness = 2
      game:GetService("Lighting").GlobalShadows = false
      Rayfield:Notify({Title = "Sucesso", Content = "Visão Noturna Ativada!", Duration = 3})
   end,
})

-- ==================== ABA MENU / CONFIGURAÇÕES ====================

TabSettings:CreateParagraph({Title = "Controle de Interface", Content = "Clique no ícone flutuante do Rayfield na tela para abrir e fechar a janela."})

TabSettings:CreateButton({
   Name = "Destruir / Fechar Script Definitivamente",
   Callback = function()
      Rayfield:Destroy()
   end,
})

-- ==================== LOOPS & LÓGICAS DO SCRIPT ====================

RunService.RenderStepped:Connect(function()
   if SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
      LocalPlayer.Character.Humanoid.WalkSpeed = SpeedValue
   end

   if FlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
      local hrp = LocalPlayer.Character.HumanoidRootPart
      local camera = workspace.CurrentCamera
      local moveDir = LocalPlayer.Character:FindFirstChildOfClass("Humanoid").MoveDirection

      if moveDir.Magnitude > 0 then
         hrp.Velocity = camera.CFrame.LookVector * (FlyValue * moveDir.Magnitude)
      else
         hrp.Velocity = Vector3.new(0, 0, 0)
      end
   end
end)

RunService.Stepped:Connect(function()
   if NoclipEnabled and LocalPlayer.Character then
      for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
         if part:IsA("BasePart") then
            part.CanCollide = false
         end
      end
   end
end)

UserInputService.JumpRequest:Connect(function()
   if InfJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
      LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
   end
end)

Rayfield:Notify({
   Title = "⚡ exclusivo para amigos",
   Content = "Script carregado com a biblioteca Rayfield!",
   Duration = 5,
})
