local Detours = DetectionPP.Detours

local function DetourE(E2Sig, Default, Post)
    local Func Func = Detours.Expression2(E2Sig, function(Scope, Args, ...)
        if DetectionPP.CantDetect(Args[1], Scope.player) then
            return Default()
        end
        return Post and Post(Scope.player, Func(Scope, Args, ...)) or Func(Scope, Args, ...)
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

local function DetourXRD(E2Sig, Default)
    local Func Func = Detours.Expression2(E2Sig, function(Scope, Args, ...)
        local Ranger = Args[1]
        if IsValid(Ranger.Entity) and DetectionPP.CantDetect(Ranger.Entity, Scope.player) then
            return Default(Func, Scope, Args, ...)
        end

        return Func(Scope, Args, ...)
    end)
end

function DetectionPP.DefaultE2Array() return {} end
function DetectionPP.DefaultE2Table() return E2Lib.newE2Table() end

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
DetourE("e:attachmentAng(n)", DetectionPP.DefaultAngle)
DetourE("e:attachmentAng(s)", DetectionPP.DefaultAngle)
DetourE("e:eyeAngles()", DetectionPP.DefaultAngle)
DetourE("e:eyeAnglesVehicle()", DetectionPP.DefaultAngle)
DetourE("e:ragdollGetAng()", DetectionPP.DefaultAngle)

DetourE("e:aabbMax()", DetectionPP.DefaultVector)
DetourE("e:aabbMin()", DetectionPP.DefaultVector)
DetourE("e:aabbSize()", DetectionPP.DefaultVector)
DetourE("e:aabbWorldMax()", DetectionPP.DefaultVector)
DetourE("e:aabbWorldMin()", DetectionPP.DefaultVector)
DetourE("e:aabbWorldSize()", DetectionPP.DefaultVector)
DetourE("e:aabbWorldSize()", DetectionPP.Default)

DetourE("e:aimEntity()", DetectionPP.DefaultEntity)
DetourE("e:aimNormal()", DetectionPP.DefaultVector)
DetourE("e:angles()", DetectionPP.DefaultAngle)
DetourE("e:attachmentAng(n)", DetectionPP.DefaultAngle)
DetourE("e:attachmentAng(s)", DetectionPP.DefaultAngle)
DetourE("e:attachmentPos(n)", DetectionPP.DefaultVector)
DetourE("e:attachmentPos(s)", DetectionPP.DefaultVector)
DetourE("e:bearing(v)", DetectionPP.DefaultNumber)
DetourE("e:boxCenter()", DetectionPP.DefaultVector)
DetourE("e:bone(n)", DetectionPP.DefaultPhysicsObject)
DetourE("e:boneCount()", DetectionPP.DefaultNumber)
DetourE("e:bones()", DetectionPP.DefaultE2Array)
DetourE("e:boxCenterW()", DetectionPP.DefaultVector)
DetourE("e:boxMax()", DetectionPP.DefaultVector)
DetourE("e:boxMin()", DetectionPP.DefaultVector)
DetourE("e:boxSize()", DetectionPP.DefaultVector)
DetourE("e:children()", DetectionPP.DefaultE2Array)
DetourE("e:driver()", DetectionPP.DefaultEntity)
DetourE("e:eye()", DetectionPP.DefaultVector)
DetourE("e:eyeAngles()", DetectionPP.DefaultAngle)
DetourE("e:eyeAnglesVehicle()", DetectionPP.DefaultAngle)
DetourE("e:eyeTrace()", DetectionPP.DefaultTrace)
DetourE("e:eyeTraceCursor()", DetectionPP.DefaultTrace)
DetourE("e:forward()", DetectionPP.DefaultVector)
DetourE("e:frictionSnapshot()", DetectionPP.DefaultE2Table)
DetourE("e:friends()", DetectionPP.DefaultE2Array)
DetourE("e:fromModelBone(n)", DetectionPP.DefaultPhysicsObject)
DetourE("e:getConnectedEntities(r)", DetectionPP.DefaultE2Array)
DetourE("e:getConnectedEntities(...)", DetectionPP.DefaultE2Array)
DetourE("e:getConstraints()", DetectionPP.DefaultE2Array)
DetourE("e:getContraption()", DetectionPP.Default)
DetourE("e:getEditData()", DetectionPP.DefaultE2Table)
DetourE("e:getEditProperty(s)", DetectionPP.DefaultString)
DetourE("e:getModelBoneCount()", DetectionPP.DefaultNumber)
DetourE("e:getModelBoneIndex(s)", DetectionPP.DefaultNumber)
DetourE("e:getModelBoneName(n)", DetectionPP.DefaultString)
DetourE("e:getModelBones(n)", DetectionPP.DefaultE2Array)
DetourE("e:hasConstraints(s)", DetectionPP.DefaultNumber)
DetourE("e:hasConstraints()", DetectionPP.DefaultNumber)
DetourE("e:hasWeapon(s)", DetectionPP.DefaultNumber)
DetourE("e:heading(v)", DetectionPP.DefaultAngle)
DetourE("e:inVehicle()", DetectionPP.DefaultNumber)
DetourE("e:isConstrained()", DetectionPP.DefaultNumber)
DetourE("e:isConstrainedTo(s, n)", DetectionPP.DefaultEntity)
DetourE("e:isConstrainedTo()", DetectionPP.DefaultEntity)
DetourE("e:isConstrainedTo(n)", DetectionPP.DefaultEntity)
DetourE("e:isConstrainedTo(s)", DetectionPP.DefaultEntity)
DetourE("e:isFrozen()", DetectionPP.DefaultNumber)
DetourE("e:isOnGround()", DetectionPP.DefaultNumber)
DetourE("e:isPenetrating()", DetectionPP.DefaultNumber)
DetourE("e:isPlayerHolding()", DetectionPP.DefaultNumber)
DetourE("e:isUnderWater()", DetectionPP.DefaultNumber)
DetourE("e:isWeldedTo(n)", DetectionPP.DefaultEntity)
DetourE("e:isWeldedTo()", DetectionPP.DefaultEntity)
DetourE("e:keyAttack1()", DetectionPP.DefaultNumber)
DetourE("e:keyAttack2()", DetectionPP.DefaultNumber)
DetourE("e:keyBack()", DetectionPP.DefaultNumber)
DetourE("e:keyDuck()", DetectionPP.DefaultNumber)
DetourE("e:keyForward()", DetectionPP.DefaultNumber)
DetourE("e:keyJump()", DetectionPP.DefaultNumber)
DetourE("e:keyLeft()", DetectionPP.DefaultNumber)
DetourE("e:keyLeftTurn()", DetectionPP.DefaultNumber)
DetourE("e:KeyPressed(s)", DetectionPP.DefaultNumber)
DetourE("e:keyReload()", DetectionPP.DefaultNumber)
DetourE("e:keyRight()", DetectionPP.DefaultNumber)
DetourE("e:keyRightTurn()", DetectionPP.DefaultNumber)
DetourE("e:keySprint()", DetectionPP.DefaultNumber)
DetourE("e:keyUse()", DetectionPP.DefaultNumber)
DetourE("e:keyWalk()", DetectionPP.DefaultNumber)
DetourE("e:keyZoom()", DetectionPP.DefaultNumber)
DetourE("e:keyvalues()", DetectionPP.DefaultE2Table)
DetourE("e:lookupAttachment()", DetectionPP.DefaultNumber)
DetourE("e:mass()", DetectionPP.DefaultNumber)
DetourE("e:massCenter()", DetectionPP.DefaultVector)
DetourE("e:massCenterL()", DetectionPP.DefaultVector)
DetourE("e:nearestPoint(v)", DetectionPP.DefaultVector)
DetourE("e:owner()", DetectionPP.DefaultEntity)
DetourE("e:parent()", DetectionPP.DefaultEntity)
DetourE("e:parentBone()", DetectionPP.DefaultPhysicsObject)
DetourE("e:propIsDupeable()", DetectionPP.DefaultNumber)
DetourE("e:radius()", DetectionPP.DefaultNumber)
DetourE("e:right()", DetectionPP.DefaultNumber)
DetourE("e:shootPos()", DetectionPP.DefaultVector)
DetourE("e:stress()", DetectionPP.DefaultNumber)
DetourE("e:surfaceArea()", DetectionPP.DefaultNumber)
DetourE("e:tool()", DetectionPP.DefaultString)
DetourE("e:up()", DetectionPP.DefaultVector)
DetourE("e:vehicle()", DetectionPP.DefaultEntity)
DetourE("e:vel()", DetectionPP.DefaultVector)
DetourE("e:velAtPoint(v)", DetectionPP.DefaultVector)
DetourE("e:velL()", DetectionPP.DefaultVector)
DetourE("e:weapon(s)", DetectionPP.DefaultEntity)
DetourE("e:weapons()", DetectionPP.DefaultE2Array)

DetourB("b:angVel()", DetectionPP.DefaultAngles)
DetourB("b:angVelVector()", DetectionPP.DefaultVector)
DetourB("b:angles()", DetectionPP.DefaultAngles)
DetourB("b:bearing(v)", DetectionPP.DefaultNumber)
DetourB("b:elevation(v)", DetectionPP.DefaultNumber)
DetourB("b:entity()", DetectionPP.DefaultEntity)
DetourB("b:forward()", DetectionPP.DefaultVector)
DetourB("b:heading(v)", DetectionPP.DefaultAngle)
DetourB("b:isFrozen()", DetectionPP.DefaultNumber)
DetourB("b:mass()", DetectionPP.DefaultNumber)
DetourB("b:massCenter()", DetectionPP.DefaultVector)
DetourB("b:massCenterL()", DetectionPP.DefaultVector)
DetourB("b:right()", DetectionPP.DefaultVector)
DetourB("b:up()", DetectionPP.DefaultVector)
DetourB("b:vel()", DetectionPP.DefaultVector)
DetourB("b:velL()", DetectionPP.DefaultVector)

DetourXRD("xrd:acfEffectiveArmor()", DetectionPP.DefaultNumber)
DetourXRD("xrd:bone()", DetectionPP.DefaultPhysicsObject)
DetourXRD("xrd:entity()", DetectionPP.DefaultEntity)
DetourXRD("xrd:toTable()", function(Func, Scope, Args, ...)
    Args[1] = DetectionPP.DefaultTrace(Args[1], NULL)
    return Func(Scope, Args, ...)
end)

-- We need a better way to deal with the find methods in E2.
-- Maybe we can PR something to handle this.

local FindListModifiers = {"findInSphere(v, n)", "findInCone(v, v, n, n)", "findInBox(v, v)", "findByName(s)", "findByModel(s)", "findByClass(s)", }
for _, FuncName in ipairs(FindListModifiers) do
    local Func Func = Detours.Expression2(FuncName, function(Scope, Args, ...)
        Func(Scope, Args, ...)
        local Array = Scope.data.findlist
        for I = #Array, 1, -1 do
            if DetectionPP.CantDetect(Array[I], Scope.player) then
                table.remove(Array, I)
            end
        end
        return #Array
    end)
end
