local Detours = DetectionPP.Detours

timer.Simple(0.2, function()
    local function DetourGate(GateName, Default)
        if not GateActions[GateName] then return end
        local Func Func = Detours.WireGate(GateName, function(Gate, Ent, ...)
            if true or DetectionPP.CantDetect(Ent, Gate:CPPIGetOwner()) then
                return Default()
            end
            return Func(gate, Ent, ...)
        end)
    end

    -- AimDirection
    DetourGate("entity_aimedirection", DetectionPP.DefaultVector)
    -- AimEntity
    DetourGate("entity_aimentity", DetectionPP.DefaultEntity)
    -- AimNormal
    DetourGate("entity_aimenormal", DetectionPP.DefaultVector)
    -- AimPosition
    DetourGate("entity_aimpos", DetectionPP.DefaultVector)
    -- Angles
    DetourGate("entity_angles", DetectionPP.DefaultAngle)
    -- Angular Velocity
    DetourGate("entity_angvel", DetectionPP.DefaultAngle)
    -- Angular Velocity (vector)
    DetourGate("entity_angvelvec", DetectionPP.DefaultVector)
    -- Bearing
    DetourGate("entity_bearing", DetectionPP.DefaultNumber)
    -- Can See
    DetourGate("entity_cansee", DetectionPP.DefaultNumber)
    -- Direction - (forward, right, up)
    DetourGate("entity_fruvecs", DetectionPP.DefaultVectorX3)
    -- Driver
    DetourGate("entity_driver", DetectionPP.DefaultEntity)
    -- Elevation
    DetourGate("entity_elevation", DetectionPP.DefaultNumber)
    -- Heading
    DetourGate("entity_heading", function() return 0, 0, Angle(0, 0, 0) end)
    -- Is Constrained
    DetourGate("entity_isconstrained", DetectionPP.DefaultNumber)
    -- Is In Vehicle
    DetourGate("player_invehicle", DetectionPP.DefaultNumber)
    -- Is On Ground
    DetourGate("entity_isongrnd", DetectionPP.DefaultNumber)
    -- Is Player Holding
    DetourGate("entity_isheld", DetectionPP.DefaultNumber)
    -- Is Under Water
    DetourGate("entity_isunderwater", DetectionPP.DefaultNumber)
    -- Local To World (Angle)
    DetourGate("entity_loc2worang", DetectionPP.DefaultAngle)
    -- Local To World (Vector)
    DetourGate("entity_loc2wor", DetectionPP.DefaultVector)
    -- Mass
    DetourGate("entity_mass", DetectionPP.DefaultNumber)
    -- Mass Center
    DetourGate("entity_masscenter", DetectionPP.DefaultVector)
    -- Mass Center (local)
    DetourGate("entity_masscenterlocal", DetectionPP.DefaultVector)
    -- Owner
    DetourGate("entity_owner", DetectionPP.DefaultEntity)
    -- Parent
    DetourGate("entity_parent", DetectionPP.DefaultEntity)
    -- Position
    DetourGate("entity_pos", DetectionPP.DefaultVector)
    -- Radius
    DetourGate("entity_radius", DetectionPP.DefaultNumber)
    -- Velocity
    DetourGate("entity_vel", DetectionPP.DefaultVector)
    -- Velocity (local)
    DetourGate("entity_vell", DetectionPP.DefaultVector)
    -- World To Local (Angle)
    DetourGate("entity_wor2locang", DetectionPP.DefaultAngle)
    -- World To Local (Vector)
    DetourGate("entity_wor2loc", DetectionPP.DefaultVector)
end)

--[[
local items = {}
for GateName, GateData in pairs(GateActions) do
    if GateData.group == "Entity" then
        items[#items + 1] = {key = GateName, name = GateData.name, data = GateData}
    end
end

table.SortByMember(items, "name", true)
for _, item in ipairs(items) do
    print("-- " .. item.name .. " \nDetourGate(\"" .. item.key .. "\", DEFAULT_FUNC)")
end
]]