local Detours = DetectionPP.Detours

timer.Simple(0.2, function()
    local ValidationFuncs = {}

    local function ValidateValue(Value)
        local Type = type(Value)
        local Func = ValidationFuncs[Type]
        if Func then
            return Func(Value)
        end
        return Value
    end

    function ValidationFuncs.Entity(Value)
        if DetectionPP.CantDetect(Value, Value:DPPIGetOwner()) then
            Value = NULL
        end
        return Value
    end

    ValidationFuncs.Vehicle = ValidationFuncs.Entity
    ValidationFuncs.Player  = ValidationFuncs.Player

    function ValidationFuncs.table(Value)
        for K, V in pairs(Value) do -- This makes me feel bad. I'm sorry. 
            Value[K] = ValidateValue(V)
        end
    end

    local TriggerInput; TriggerInput = Detours.New("WireLib.TriggerInput", function(Entity, Name, Value, ...)
        Value = ValidateValue(Value)
        local ret = TriggerInput(Entity, Name, Value, ...)
        return ret
    end)

    local TriggerOutput; TriggerOutput = Detours.New("WireLib.TriggerOutput", function(Entity, Name, Value, ...)
        Value = ValidateValue(Value)
        local ret = TriggerOutput(Entity, Name, Value, ...)
        return ret
    end)
end)
