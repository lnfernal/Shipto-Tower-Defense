local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PhysicsService = game:GetService("PhysicsService")
local Runservice = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local towers = ReplicatedStorage:WaitForChild("Towers")
local events = ReplicatedStorage:WaitForChild("Events")
local spawnTowerEvent = events:WaitForChild("SpawnTower")
local camera = workspace.CurrentCamera
local gui = script.Parent
local towerToSpawn = nil

local function MouseRaycast(blacklist)
    local mousePosition = UserInputService:GetMouseLocation()
    local mouseRay = camera:ViewportPointToRay(mousePosition.X, mousePosition.Y)
    local raycastParams = RaycastParams.new()

    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = blacklist
    
    local raycastresult = workspace:Raycast(mouseRay.Origin, mouseRay.Direction * 1000, raycastParams)

    return raycastresult
end

local function RemovePlaceholderTower()
    if towerToSpawn then
        towerToSpawn:Destroy()
        towerToSpawn = nil
    end
end

local function AddPlaceholderTower(name)
    local towerExists = towers:FindFirstChild(name)

    if towerExists then
        local towerToSpawn = towerExists:Clone()
        towerToSpawn.Parent = workspace.Towers

        for i, object in ipairs(towerToSpawn:GetDescendants()) do
            if object:IsA("BasePart") then
                PhysicsService:SetPartCollisionGroup(object, "Tower")     
                object.Material = Enum.Material.ForceField
            end
        end
    end
end

gui.Spawn.Activated:Connect(function()
    AddPlaceholderTower("Dummy")
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then
        return
    end

    if towerToSpawn then
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            -- if item :IsA("BasePart") then
            --     item.Color = Color3.new(1,0,0) 
            -- end
            spawnTowerEvent:FireServer(towerToSpawn.Name, towerToSpawn.PriamaryPart.CFrame)
        end 
    end
end)

Runservice.RenderStepped:Connect(function()
    if towerToSpawn then
        local result = MouseRaycast({towerToSpawn})
        if result and result.Instance then
            RemovePlaceholderTower()
            -- towerToSpawn = result.Instance
            local x = result.Position.X
            local y = result.Position.Y + towerToSpawn.Humanoid.HipeHeight + (towerToSpawn.PriamaryPart.Size.Y / 2)
            local z = result.Position.Z
    
            local cframe = CFrame.new(x, y, z)
            towerToSpawn:SetPrimaryPartCFrame(cframe)
        end 
    end
end)