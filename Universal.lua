local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "⚡ Hub para Amigos",
   LoadingTitle = "Carregando Hub...",
   LoadingSubtitle = "Exclusivo para Amigos",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false
})

local TabAdmin = Window:CreateTab("👑 Painel Admin & ESP", 4483362458)
local TabCombat = Window:CreateTab("🎯 Combate & Movimento", 4483362458)

TabAdmin:CreateParagraph({Title = "Status", Content = "Menu carregado diretamente no executor com sucesso!"})

TabAdmin:CreateButton({
   Name = "Ativar Godmode (Vida Infinita)",
   Callback = function()
      local player = game.Players.LocalPlayer
      if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
         player.Character:FindFirstChildOfClass("Humanoid").Health = math.huge
         Rayfield:Notify({Title = "Admin", Content = "Godmode ativado com sucesso!", Duration = 3})
      end
   end,
})

TabCombat:CreateToggle({
   Name = "Speed Hack (Velocidade 50)",
   CurrentValue = false,
   Callback = function(Value)
      local player = game.Players.LocalPlayer
      if player.Character and player.Character:FindFirstChild("Humanoid") then
         player.Character.Humanoid.WalkSpeed = Value and 50 or 16
      end
   end,
})

Rayfield:Notify({Title = "Sucesso!", Content = "O script abriu perfeitamente.", Duration = 4})
