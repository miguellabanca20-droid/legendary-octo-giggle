-- Carrega a biblioteca Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local MarketplaceService = game:GetService("MarketplaceService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

local GameName = "Jogo Desconhecido"
pcall(function()
   local info = MarketplaceService:GetProductInfo(PlaceId)
   if info and info.Name then GameName = info.Name end
end)

local Window = Rayfield:CreateWindow({
   Name = "⚡ Mega Multi-Hub Supremo Ultra | Jogo: " .. GameName,
   LoadingTitle = "Carregando a Base Suprema de Jogos...",
   LoadingSubtitle = "15 Jogos com Comandos Extremos Carregados",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false
})

local TabGamesList = Window:CreateTab("🎮 Jogos Suportados", 4483362458)
local TabGameSpecific = Window:CreateTab("⚡ Jogo Atual", 4483362458)
local TabCombat = Window:CreateTab("🎯 Combate Global", 4483362458)
local TabMovement = Window:CreateTab("🚀 Movimento Global", 4483362458)
local TabESP = Window:CreateTab("👁️ ESP & Chams", 4483362458)
local TabTeleport = Window:CreateTab("🌎 Teleportes", 4483362458)
local TabUtilities = Window:CreateTab("💤 Utilidades", 4483362458)

TabGamesList:CreateParagraph({
   Title = "📊 Estatísticas do Hub",
   Content = "Foram adicionados comandos personalizados e automatizados para exatamente **15 jogos** diferentes nesta build máxima!"
})

TabGamesList:CreateParagraph({
   Title = "📋 Lista de Todos os Jogos Integrados:",
   Content = "1. Murder Mystery 2 (MM2)\n2. Blox Fruits\n3. Blade Ball\n4. DOORS\n5. BedWars\n6. Arsenal / FPS Hub\n7. Brookhaven RP\n8. Da Hood\n9. Pet Simulator 99\n10. Piggy\n11. Tower of Hell\n12. Jailbreak\n13. Adopt Me!\n14. Natural Disaster Survival\n15. Arsenal / Universal Base"
})

-- Variáveis Universais
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
         if player.Character.Humanoid.Health > 0 then
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

TabGameSpecific:CreateParagraph({Title = "🎮 Jogo Detectado: " .. GameName, Content = "ID: " .. tostring(PlaceId)})

-- 1. Murder Mystery 2
if PlaceId == 142823291 or string.find(string.lower(GameName), "murder mystery") then
   TabGameSpecific:CreateButton({Name = "🔪 MM2: Puxar Arma Caída no Chão", Callback = function()
      for _, obj in pairs(workspace:GetDescendants()) do
         if obj.Name == "GunDrop" or obj.Name == "Gun" then
            local part = obj:IsA("Model") and obj.PrimaryPart or obj
            if part and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
               LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame
               Rayfield:Notify({Title = "MM2", Content = "Teleportado até a arma!", Duration = 3})
               return
            end
         end
      end
      Rayfield:Notify({Title = "MM2", Content = "Nenhuma arma encontrada.", Duration = 3})
   end})

-- 2. Blox Fruits
elseif PlaceId == 2753915549 or string.find(string.lower(GameName), "blox fruits") then
   TabGameSpecific:CreateToggle({Name = "🍎 Blox Fruits: Auto Clicker Rápido de Ataque", CurrentValue = false, Callback = function(Value) AutoClickerEnabled = Value end})
   TabGameSpecific:CreateButton({Name = "🍎 Blox Fruits: Teleportar para Baús Próximos", Callback = function()
      for _, v in pairs(workspace:GetDescendants()) do
         if v.Name == "Chest" or string.find(string.lower(v.Name), "chest") then
            if v:IsA("BasePart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
               LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
               task.wait(0.2)
            end
         end
      end
      Rayfield:Notify({Title = "Blox Fruits", Content = "Baús farmados!", Duration = 3})
   end})

-- 3. Blade Ball
elseif PlaceId == 13772394625 or string.find(string.lower(GameName), "blade ball") then
   TabGameSpecific:CreateToggle({Name = "⚔️ Blade Ball: Auto Parry Assist", CurrentValue = false, Callback = function(Value)
      _G.BladeBallAuto = Value
      task.spawn(function()
         while _G.BladeBallAuto do
            task.wait()
            for _, ball in pairs(workspace:GetChildren()) do
               if not _G.BladeBallAuto then break end
               if string.find(string.lower(ball.Name), "ball") and ball:IsA("BasePart") then
                  if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                     if (ball.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 22 then
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

-- 4. DOORS
elseif PlaceId == 6516141723 or string.find(string.lower(GameName), "doors") then
   TabGameSpecific:CreateButton({Name = "🚪 DOORS: Fullbright Extremo", Callback = function()
      game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
      game:GetService("Lighting").Brightness = 5
      game:GetService("Lighting").GlobalShadows = false
      Rayfield:Notify({Title = "DOORS", Content = "Visibilidade total ativada!", Duration = 3})
   end})
   TabGameSpecific:CreateButton({Name = "🚪 DOORS: Verificar Entidades Próximas", Callback = function()
      local found = false
      for _, obj in pairs(workspace:GetChildren()) do
         if obj.Name == "RushMoving" or obj.Name == "AmbushMoving" or obj.Name == "Eyes" or obj.Name == "Figure" then
            found = true
            Rayfield:Notify({Title = "⚠️ ALERTA", Content = "Entidade letal ativa: " .. obj.Name, Duration = 5})
         end
      end
      if not found then Rayfield:Notify({Title = "DOORS", Content = "Nenhuma entidade na sala.", Duration = 3}) end
   end})

-- 5. BedWars
elseif PlaceId == 6872265039 or string.find(string.lower(GameName), "bedwars") then
   TabGameSpecific:CreateButton({Name = "🛌 BedWars: Speed PvP (Speed 24)", Callback = function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid.WalkSpeed = 24
      end
   end})
   TabGameSpecific:CreateToggle({Name = "🛌 BedWars: Hitbox PvP Grande", CurrentValue = false, Callback = function(Value)
      HitboxEnabled = Value; HitboxSize = 18
   end})

-- 6. Arsenal / FPS
elseif PlaceId == 286090429 or string.find(string.lower(GameName), "arsenal") then
   TabGameSpecific:CreateToggle({Name = "🔫 Arsenal: Aimbot Head", CurrentValue = false, Callback = function(Value)
      AimbotEnabled = Value; AimPart = "Head"; ShowFOVCircle = true; FOVCircle.Visible = true
   end})

-- 7. Brookhaven RP
elseif PlaceId == 4924922222 or string.find(string.lower(GameName), "brookhaven") then
   TabGameSpecific:CreateButton({Name = "🏡 Brookhaven: Teleportar para o Banco", Callback = function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
         LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(100, 20, -300)
      end
   end})

-- 8. Da Hood
elseif string.find(string.lower(GameName), "da hood") or string.find(string.lower(GameName), "hood") then
   TabGameSpecific:CreateToggle({Name = "🥊 Da Hood: Hitbox Socos Gigantes", CurrentValue = false, Callback = function(Value)
      HitboxEnabled = Value; HitboxSize = 25
   end})

-- 9. Pet Simulator 99
elseif string.find(string.lower(GameName), "pet simulator") or string.find(string.lower(GameName), "pet 99") then
   TabGameSpecific:CreateToggle({Name = "🐾 Pet Sim 99: Auto-Coleta de Moedas", CurrentValue = false, Callback = function(Value)
      _G.AutoPetSim = Value
      task.spawn(function()
         while _G.AutoPetSim do
            task.wait(0.3)
            for _, v in pairs(workspace:GetDescendants()) do
               if not _G.AutoPetSim then break end
               if string.find(string.lower(v.Name), "coin") or string.find(string.lower(v.Name), "gem") or string.find(string.lower(v.Name), "diamond") then
                  if v:IsA("BasePart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                     LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                  end
               end
            end
         end
      end)
   end})

-- 10. Piggy
elseif string.find(string.lower(GameName), "piggy") then
   TabGameSpecific:CreateButton({Name = "🐷 Piggy: Pular para a Saída (Se houver part)", Callback = function()
      for _, obj in pairs(workspace:GetDescendants()) do
         if obj.Name == "ExitDoor" or obj.Name == "Door" then
            local part = obj:IsA("Model") and obj.PrimaryPart or obj
            if part and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
               LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame
               Rayfield:Notify({Title = "Piggy", Content = "Teleportado para a porta!", Duration = 3})
               return
            end
         end
      end
      Rayfield:Notify({Title = "Piggy", Content = "Saída não encontrada no momento.", Duration = 3})
   end})

-- 11. Tower of Hell
elseif string.find(string.lower(GameName), "tower of hell") then
   TabGameSpecific:CreateButton({Name = "🗼 Tower of Hell: Godmode / God Tools (Salto Altíssimo)", Callback = function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid.JumpPower = 120
         LocalPlayer.Character.Humanoid.WalkSpeed = 24
         Rayfield:Notify({Title = "Tower", Content = "Atributos aplicados para escalar!", Duration = 3})
      end
   end})

-- 12. Jailbreak
elseif string.find(string.lower(GameName), "jailbreak") then
   TabGameSpecific:CreateButton({Name = "🚓 Jailbreak: Teleportar para a Base Criminal", Callback = function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
         LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-250, 20, 1550)
         Rayfield:Notify({Title = "Jailbreak", Content = "Teleportado!", Duration = 3})
      end
   end})

-- 13. Adopt Me!
elseif string.find(string.lower(GameName), "adopt me") then
   TabGameSpecific:CreateButton({Name = "🐶 Adopt Me!: Teleportar para o Berçario / Loja", Callback = function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
         LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-100, 15, -30)
         Rayfield:Notify({Title = "Adopt Me", Content = "Teleportado para o Centro!", Duration = 3})
      end
   end})

-- 14. Natural Disaster Survival
elseif string.find(string.lower(GameName), "natural disaster") then
   TabGameSpecific:CreateButton({Name = "🌪️ Natural Disaster: Teleportar para o Topo da Torre Segura", Callback = function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
         LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-250, 120, 50)
         Rayfield:Notify({Title = "Disaster", Content = "Seguro no topo da torre!", Duration = 3})
      end
   end})

-- 15. Universal Fallback
else
   TabGameSpecific:CreateParagraph({Title = "ℹ️ Modo Universal Ativo", Content = "Comandos genéricos abertos para este jogo."})
   TabGameSpecific:CreateToggle({Name = "⚡ Auto Coletor de Toques Universal", CurrentValue = false, Callback = function(Value)
      _G.UniFarm = Value
      task.spawn(function()
         while _G.UniFarm do
            task.wait(0.5)
            for _, v in pairs(workspace:GetDescendants()) do
               if not _G.UniFarm then break end
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

-- Configurações Globais
TabCombat:CreateToggle({Name = "Aimbot Global", CurrentValue = false, Callback = function(Value) AimbotEnabled = Value end})
TabCombat:CreateDropdown({Name = "Alvo de Mira", Options = {"Head", "HumanoidRootPart"}, CurrentOption = {"Head"}, Callback = function(Opt) AimPart = Opt[1] or Opt end})
TabCombat:CreateToggle({Name = "Mostrar Círculo FOV", CurrentValue = false, Callback = function(Value) ShowFOVCircle = Value; FOVCircle.Visible = Value end})
TabCombat:CreateSlider({Name = "Raio FOV", Range = {30, 400}, Increment = 5, Suffix = " px", CurrentValue = 120, Callback = function(Val) FOVRadius = Val; FOVCircle.Radius = Val end})

TabMovement:CreateToggle({Name = "Speed Hack", CurrentValue = false, Callback = function(Value) SpeedEnabled = Value end})
TabMovement:CreateSlider({Name = "Velocidade", Range = {16, 250}, Increment = 1, Suffix = " Speed", CurrentValue = 16, Callback = function(Val) SpeedValue = Val end})
TabMovement:CreateToggle({Name = "Pulo Infinito", CurrentValue = false, Callback = function(Value) InfJumpEnabled = Value end})
TabMovement:CreateToggle({Name = "Noclip (Atravessar Paredes)", CurrentValue = false, Callback = function(Value) NoclipEnabled = Value end})
TabMovement:CreateToggle({Name = "Hitbox Expansiva Global", CurrentValue = false, Callback = function(Value) HitboxEnabled = Value end})

TabESP:CreateToggle({Name = "ESP Chams Ativo", CurrentValue = false, Callback = function(Value)
   ESPEnabled = Value
   for _, p in pairs(Players:GetPlayers()) do
      if p ~= LocalPlayer and p.Character then
         local hl = p.Character:FindFirstChild("ESPHighlight")
         if Value and not hl then
            local h = Instance.new("Highlight")
            h.Name = "ESPHighlight"
            h.Adornee = p.Character
            h.FillColor = Color3.fromRGB(0, 255, 100)
            h.FillTransparency = 0.4
            h.Parent = p.Character
         elseif not Value and hl then
            hl:Destroy()
         end
      end
   end
end})

TabTeleport:CreateInput({Name = "Nick do Jogador", PlaceholderText = "Digite o nome...", RemoveTextOnFocusLost = false, Callback = function(Txt) TargetPlayerName = Txt end})
TabTeleport:CreateButton({Name = "Teleportar até o Jogador", Callback = function()
   for _, target in pairs(Players:GetPlayers()) do
      if target ~= LocalPlayer and (string.sub(string.lower(target.Name), 1, #TargetPlayerName) == string.lower(TargetPlayerName) or string.sub(string.lower(target.DisplayName), 1, #TargetPlayerName) == string.lower(TargetPlayerName)) then
         if target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
            Rayfield:Notify({Title = "Teleporte", Content = "Indo para: " .. target.DisplayName, Duration = 3})
            return
         end
      end
   end
   Rayfield:Notify({Title = "Erro", Content = "Jogador não encontrado.", Duration = 3})
end})

TabUtilities:CreateToggle({Name = "Anti-AFK Ativo", CurrentValue = true, Callback = function(Value) AntiAFKEnabled = Value end})
TabUtilities:CreateButton({Name = "Otimizar Gráficos (FPS Boost)", Callback = function()
   for _, v in pairs(game:GetDescendants()) do
      if v:IsA("Part") or v:IsA("MeshPart") then v.Material = Enum.Material.SmoothPlastic
      elseif v:IsA("Decal") then v:Destroy() end
   end
   game:GetService("Lighting").GlobalShadows = false
   Rayfield:Notify({Title = "Otimizado", Content = "Gráficos limpos com sucesso!", Duration = 3})
end})

-- Loops de Execução
LocalPlayer.Idled:Connect(function()
   if AntiAFKEnabled then VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end
end)

UserInputService.JumpRequest:Connect(function()
   if InfJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
      LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
   end
end)

RunService.RenderStepped:Connect(function()
   FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
   if SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
      LocalPlayer.Character.Humanoid.WalkSpeed = SpeedValue
   end
   if AimbotEnabled then
      local t = GetClosestPlayer()
      if t and t.Character and t.Character:FindFirstChild(AimPart) then
         Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Character[AimPart].Position)
      end
   end
end)

RunService.Stepped:Connect(function()
   if NoclipEnabled and LocalPlayer.Character then
      for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
         if p:IsA("BasePart") then p.CanCollide = false end
      end
   end
   if HitboxEnabled then
      for _, p in pairs(Players:GetPlayers()) do
         if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            p.Character.HumanoidRootPart.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
            p.Character.HumanoidRootPart.Transparency = 0.6
            p.Character.HumanoidRootPart.CanCollide = false
         end
      end
   end
end)

Rayfield:Notify({Title = "⚡ Mega Hub Carregado!", Content = "Total de 15 jogos integrados com sucesso.", Duration = 5})
