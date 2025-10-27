local Detours = DetectionPP.Detours

timer.Simple(1, function()
    local OriginalCompile; OriginalCompile = Detours.New("E2Lib.Compiler.CompileExpr", function(...)
        local op, ty = OriginalCompile(...)

        if ty == "e" then
            op = function(...)

            end
        end

        return op, ty
    end)
end)