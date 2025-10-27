local Detours = DetectionPP.Detours

timer.Simple(0.2, function()
    local OriginalCompile; OriginalCompile = Detours.New("E2Lib.Compiler.CompileExpr", function(...)
        local op, ty = OriginalCompile(...)
        if ty == "e" then
            local oldOp = op
            op = function(ctx, ...)
                local ret = oldOp(ctx, ...)
                if DetectionPP.CantDetect(ret, ctx.player) then
                    return NULL
                end
                return ret
            end
        end

        return op, ty
    end)
end)