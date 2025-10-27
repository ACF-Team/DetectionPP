local Detours = DetectionPP.Detours

timer.Simple(0.2, function()
    local TriggerInput; TriggerInput = Detours.New("WireLib.TriggerInput", function(Entity, Name, Value, ...)
        if isentity(Value) and DetectionPP.CantDetect(Unwrapped, Entity:DPPIGetOwner()) then
            return
        end

        local ret = TriggerInput(Entity, Name, Value, ...)
        return ret
    end)

    local TriggerOutput; TriggerOutput = Detours.New("WireLib.TriggerOutput", function(Entity, Name, Value, ...)
        if isentity(Value) and DetectionPP.CantDetect(Unwrapped, Entity:DPPIGetOwner()) then
            return
        end

        local ret = TriggerOutput(Entity, Name, Value, ...)
        return ret
    end)
end)
