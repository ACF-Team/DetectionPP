local Detours = DetectionPP.Detours
local ENTITY  = FindMetaTable "Entity"
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

    -- This is a HACK: but I can't find a better solution right now. The issue is that some entities call WireLib.TriggerOutput's with their own entities
    -- in a Spawn hook - before we ever get an owner at all. So we'll just trust that some entities know what they're doing. But we should find a better
    -- solution... I just can't think of one that doesn't suck, god I hate the gmod API sometimes for this stuff
    local TrustedClassesForOutputs = {
        gmod_wire_egp = {wirelink = true},
        gmod_wire_egp_emitter = {wirelink = true},
        gmod_wire_egp_hud = {wirelink = true},

        acf_controller = {Entity = true} -- TODO: Can we avoid this and fix it in ACF ourselves...
    }

    local TriggerInput; TriggerInput = Detours.New("WireLib.TriggerInput", function(Entity, Name, Value, ...)
        Value = ValidateValue(Value)
        local ret = TriggerInput(Entity, Name, Value, ...)
        return ret
    end)

    local TriggerOutput; TriggerOutput = Detours.New("WireLib.TriggerOutput", function(Entity, Name, Value, ...)
        local Class = ENTITY.GetClass(Entity)
        local Trust = TrustedClassesForOutputs[Class]
        if Trust == true or (Trust ~= nil and Trust[Name] == true) then
            return TriggerOutput(Entity, Name, Value, ...) -- Do not validate, trust the class knows what its doing
        end

        Value = ValidateValue(Value)
        local ret = TriggerOutput(Entity, Name, Value, ...)
        return ret
    end)
end)
