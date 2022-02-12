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
local canPlace = false
local rotation = 0

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
        rotation = 0
    end
end

local function AddPlaceholderTower(name)
    local towerExists = towers:FindFirstChild(name)

    if towerExists then
        towerToSpawn = towerExists:Clone()
        towerToSpawn.Parent = workspace.Towers

        for i, object in ipairs(towerToSpawn:GetDescendants()) do
            if object:IsA("BasePart") then
                PhysicsService:SetPartCollisionGroup(object, "Tower")     
                object.Material = Enum.Material.ForceField
            end
        end
    end
end

local function ColorPlaceholderTower(color)
    for i, object in ipairs(towerToSpawn:GetDescendants()) do
        if object:IsA("BasePart") then
            PhysicsService:SetPartCollisionGroup(object, "Tower")     
            object.Color = color
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
            if canPlace then
                spawnTowerEvent:FireServer(towerToSpawn.Name, towerToSpawn.PrimaryPart.CFrame)
                RemovePlaceholderTower()
            end
                RemovePlaceholderTower()
            end
        elseif input.KeyCode == Enum.KeyCode.R then
            rotation += 90
        end  
end)

Runservice.RenderStepped:Connect(function()
    if towerToSpawn then
        local result = MouseRaycast({towerToSpawn})
        if result and result.Instance then
            if result.Instance.Parent.Name == "TowerArea" then
                 canPlace = true
                 ColorPlaceholderTower(Color3.new(0,1,0))
            else
                canPlace = false
                ColorPlaceholderTower(Color3.new(1,0,0))
            end
            -- towerToSpawn = result.Instance
            local x = result.Position.X
            local y = result.Position.Y + towerToSpawn.Humanoid.HipHeight + (towerToSpawn.PrimaryPart.Size.Y / 2)
            local z = result.Position.Z
    
            local CFrame = CFrame.new(x, y, z) * CFrame.Angles(0, math.rad(rotation), 0)
            towerToSpawn:SetPrimaryPartCFrame(CFrame)
        end 
    end
end)