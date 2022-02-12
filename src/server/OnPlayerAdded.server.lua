local Players = game:GetService("Players")
local PhysicsService = game:GetService("PhysicsService")

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        for i, object in ipairs(character:GetDescendants()) do
            if object:IsA("BasePart") then
                PhysicsService:SetPartCollisionGroup(object, "Player")     
            end
        end
    end)
end)