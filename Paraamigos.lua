-- =========================================================================
-- EXPANSÃO MÁXIMA DE JOGOS POPULARES - FEARS HUB
-- =========================================================================

-- ==================== 10. ADOPT ME! ====================
if CurrentPlaceId == 920587237 then
   TabPopular:CreateParagraph({Title = "🐾 Adopt Me!", Content = "Utilitários e atalhos de mapa."})
   TabPopular:CreateButton({
      Name = "Teleportar para o Berçário (Nursery)",
      Callback = function()
         if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-102.5, 15, -60.5)
            Rayfield:Notify({Title = "Adopt Me", Content = "Teleportado para o Berçário!", Duration = 3})
         end
      end,
   })
   TabPopular:CreateButton({
      Name = "Teleportar para a Loja de Presentes",
      Callback = function()
         if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-254.5, 18.5, -45.5)
            Rayfield:Notify({Title = "Adopt Me", Content = "Teleportado para a Loja de Presentes!", Duration = 3})
         end
      end,
   })

-- ==================== 11. ARSENAL ====================
elseif CurrentPlaceId == 286090429 then
   TabPopular:CreateParagraph({Title = "🔫 Arsenal", Content = "Ferramentas de combate e mira."})
   TabPopular:CreateToggle({
      Name = "Expandir Hitbox dos Inimigos (Arsenal)",
      CurrentValue = false,
      Callback = function(v)
         _G.ArsenalHitbox = v
         task.spawn(function()
            while _G.ArsenalHitbox do
               for _, p in pairs(Players:GetPlayers()) do
                  if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                     p.Character.HumanoidRootPart.Size = Vector3.new(7, 7, 7)
                     p.Character.HumanoidRootPart.Transparency = 0.5
                     p.Character.HumanoidRootPart.CanCollide = false
                  end
               end
               task.wait(1)
            end
         end)
      end,
   })

-- ==================== 12. PIGGY ====================
elseif CurrentPlaceId == 4623386862 then
   TabPopular:CreateParagraph({Title = "🐷 Piggy", Content = "Facilitadores de fuga."})
   TabPopular:CreateButton({
      Name = "Fullbright (Ver no Escuro do Piggy)",
      Callback = function()
         game:GetService("Lighting").Brightness = 3
         game:GetService("Lighting").ClockTime = 12
         game:GetService("Lighting").GlobalShadows = false
         Rayfield:Notify({Title = "Piggy", Content = "Mapa iluminado!", Duration = 3})
      end,
   })

-- ==================== 13. EVADE ====================
elseif CurrentPlaceId == 9872472334 then
   TabPopular:CreateParagraph({Title = "🏃 Evade", Content = "Ajustes de velocidade extrema."})
   TabPopular:CreateButton({
      Name = "Boost de Velocidade para Fuga (Evade)",
      Callback = function()
         if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 30
            Rayfield:Notify({Title = "Evade", Content = "Velocidade de fuga aplicada!", Duration = 3})
         end
      end,
   })

-- ==================== 14. SLAP BATTLES ====================
elseif CurrentPlaceId == 6403373529 then
   TabPopular:CreateParagraph({Title = "💥 Slap Battles", Content = "Utilitários de arena."})
   TabPopular:CreateButton({
      Name = "Teleportar para a Ilha Principal (Arena)",
      Callback = function()
         if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
            Rayfield:Notify({Title = "Slap Battles", Content = "Teleportado para o centro!", Duration = 3})
         end
      end,
   })

-- ==================== 15. NATURAL DISASTER SURVIVAL ====================
elseif CurrentPlaceId == 189689454 then
   TabPopular:CreateParagraph({Title = "🌪️ Natural Disaster Survival", Content = "Ferramentas de sobrevivência."})
   TabPopular:CreateButton({
      Name = "Teleportar para a Torre Central",
      Callback = function()
         if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-250, 200, 38)
            Rayfield:Notify({Title = "Disaster", Content = "Seguro no topo da torre!", Duration = 3})
         end
      end,
   })

-- ==================== 16. FLEE THE FACILITY ====================
elseif CurrentPlaceId == 893973440 then
   TabPopular:CreateParagraph({Title = "🔨 Flee the Facility", Content = "Ajudantes de hack e fuga."})
   TabPopular:CreateButton({
      Name = "Fullbright (Visão Clara nos Mapas)",
      Callback = function()
         game:GetService("Lighting").Brightness = 2
         game:GetService("Lighting").GlobalShadows = false
         Rayfield:Notify({Title = "Flee the Facility", Content = "Luz ativada!", Duration = 3})
      end,
   })

-- ==================== 17. CATALOG AVATAR CREATOR ====================
elseif CurrentPlaceId == 7041939546 then
   TabPopular:CreateParagraph({Title = "🎨 Catalog Avatar Creator", Content = "Opções de customização."})
   TabPopular:CreateButton({
      Name = "Notificação de Status do Hub",
      Callback = function()
         Rayfield:Notify({Title = "Catalog", Content = "Divirta-se criando seus avatares!", Duration = 3})
      end,
   })
end
