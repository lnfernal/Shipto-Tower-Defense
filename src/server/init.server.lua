local mob = require(script.mob)
local tower = require(script.tower)
local map = workspace.Basemap

for wave=1, 5 do
    print("WAVE: ".. wave.." Is STARTING")
    if wave < 5 then 
        mob.Spawn("Mech", 3 * wave, map)
        mob.Spawn("Zombie", 3 * wave, map)
    elseif wave == 5 then
        mob.Spawn("Zombie", 100, map)
    end

    repeat 
        task.wait(1)
    until #workspace.Mobs:GetChildren() == 0

    print("WAVE ENDED")
    task.wait(1)
end