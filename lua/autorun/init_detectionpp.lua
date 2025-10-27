include("includes/gloader.lua")

gloader.Load("DetectionPP", "detectionpp")

-- Simple helper function. The world isnt valid, so this allows the world to pass the check
function DetectionPP.CantDetect(Entity, Player)
    if not IsValid(Entity) and Entity ~= game.GetWorld() then return true end

    return not Entity:DPPICanDetect(Player)
end