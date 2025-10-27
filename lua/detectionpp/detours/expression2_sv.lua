local Detours = DetectionPP.Detours

timer.Simple(1, function()
    local OriginalCompile; OriginalCompile = Detours.New("E2Lib.Compiler.CompileExpr", function(...)
        local op, ty = OriginalCompile(...)
        if ty == "e" then
            local oldOp = op
            op = function(ctx, ...)
                local ret = oldOp(ctx, ...)
                if IsValid(ret) and not ret:DPPICanDetect(ctx.player) then
                    return NULL
                end
                return ret
            end
        end

        return op, ty
    end)
end)