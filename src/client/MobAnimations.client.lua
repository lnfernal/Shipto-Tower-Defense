local function animateMob(object)
    local humanoid = object:WaitForChild("Humanoid")
    local animationsFolder = object:WaitForChild("Animations")

    if humanoid and animationsFolder then
        local walkAnimation = animationsFolder:WaitForChild("Walk")

        if walkAnimation then
            local animator = humanoid:FindFirstChild(walkAnimation) or Instance.new("Animator", humanoid)
            local walkTrack = animator:LoadAnimation(walkAnimation)
            walkTrack:Play()
        end
    else
        warn("Could not find humanoid or animations folder for: ", object)
    end
end

workspace.Mobs.ChildAdded:Connect(animateMob)