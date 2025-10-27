local Detours = DetectionPP.Detours

timer.Simple(0.2, function()
    local CreateWrapper; CreateWrapper = Detours.New("SF.Instance.CreateWrapper", function(Instance, Metatable, TypeData, ...)
        local ret = CreateWrapper(Instance, Metatable, TypeData, ...)
        if TypeData == SF.Types.Entity or TypeData == SF.Types.Hologram or TypeData == SF.Types.Player then
            local Wrap, Unwrap = Metatable.Wrap, Metatable.Unwrap

            function Metatable.Wrap(Value)
                if DetectionPP.CantDetect(Value, Instance.player) then
                    return NULL
                end
                return Wrap(Value)
            end

            function Metatable.Unwrap(Value)
                local Unwrapped = Unwrap(Value)
                if DetectionPP.CantDetect(Unwrapped, Instance.player) then
                    return NULL
                end
                return Unwrapped
            end
        end
        return ret
    end)
end)
