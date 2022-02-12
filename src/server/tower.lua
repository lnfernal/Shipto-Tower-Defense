local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PhysicsService = game:GetService("PhysicsService")
local Runservice = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ServerStorage = game:GetService("ServerStorage")
local events = ReplicatedStorage:WaitForChild("Events")
local spawnTowerEvent = events:WaitForChild("SpawnTower")
local tower = {}

function tower.Spawn(player, name, cframe)
    local towerExists = ReplicatedStorage.Tower:FindFirstChild(name)

    if towerExists then
        local newTower = towerExists:Clone()
        newTower.HumanoidRootPart.CFrame = cframe
        newTower.Parent = workspace.Towers
        newTower.HumanoidRootPart:SetNewworkOwner(nil)
        
        for i, object in ipairs(newTower:GetDescendants()) do
            if object:IsA("BasePart") then
                PhysicsService:SetPartCollisionGroup(object, "Tower")     
            end
        end
    else
        warn("Requested tower does not exist: ", name)
    end
end

spawnTowerEvent.OnServerEvent:Connect(tower.Spawn)

return tower