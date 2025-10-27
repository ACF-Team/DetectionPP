local Detours = DetectionPP.Detours

local function DetourE(E2Sig, Default)
    local Func Func = Detours.Expression2(E2Sig, function(Scope, Args, ...)
        if DetectionPP.CantDetect(Args[1], Scope.player) then
            return Default()
        end
        return Func(Scope, Args, ...)
    end)
end

local function DetourB(E2Sig, Default)
    local Func Func = Detours.Expression2(E2Sig, function(Scope, Args, ...)
        if IsValid(Args[1]) and DetectionPP.CantDetect(Args[1]:GetEntity(), Scope.player) then
            return Default()
        end
        return Func(Scope, Args, ...)
    end)
end

DetourE("e:pos()", DetectionPP.DefaultVector)
DetourB("b:pos()", DetectionPP.DefaultVector)

DetourE("e:aimPos()", DetectionPP.DefaultVector)
DetourE("e:attachmentPos(n)", DetectionPP.DefaultVector)
DetourE("e:attachmentPos(s)", DetectionPP.DefaultVector)
DetourE("e:shootPos()", DetectionPP.DefaultVector)

DetourE("e:toWorld(a)", DetectionPP.DefaultAngle)
DetourE("e:toWorld(v)", DetectionPP.DefaultVector)
DetourE("e:toLocal(a)", DetectionPP.DefaultAngle)
DetourE("e:toLocal(v)", DetectionPP.DefaultVector)
DetourE("e:toWorldAxis(v)", DetectionPP.DefaultVector)
DetourE("e:toLocalAxis(v)", DetectionPP.DefaultVector)

DetourB("b:toWorld(v)", DetectionPP.DefaultVector)
DetourB("b:toLocal(v)", DetectionPP.DefaultVector)

DetourE("e:angVel()", DetectionPP.DefaultAngle)
DetourE("e:angVelVector()", DetectionPP.DefaultVector)
DetourE("e:angles()", DetectionPP.DefaultAngle)
DetourE("e:attachmentAng(n)", DetectionPP.DefaultAngle)
DetourE("e:attachmentAng(s)", DetectionPP.DefaultAngle)
DetourE("e:eyeAngles()", DetectionPP.DefaultAngle)
DetourE("e:eyeAnglesVehicle()", DetectionPP.DefaultAngle)
DetourE("e:ragdollGetAng()", DetectionPP.DefaultAngle)