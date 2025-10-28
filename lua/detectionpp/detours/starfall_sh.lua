local ReportMissing = false
hook.Add("DetectionPPDetours_Starfall_PrePatchInstance", "StarfallChecks", function(Instance)
    local function DetourMethod(Type, CheckShouldDefault, Method, Default, Cond, Override)
        if Cond == false then return end
        local Func = Type.Methods[Method]
        if not Func then
            if ReportMissing then print("DetectionPP: Starfall detour error due to missing method '" .. Method .. "'.") end
            return
        end
        Type.Methods[Method] = Override or function(self, ...)
            if CheckShouldDefault(self, Instance.player) then
                return Default()
            end
            return Func(self, ...)
        end
        return Func
    end
    local ewrap, eunwrap     = Instance.Types.Entity.Wrap, Instance.Types.Entity.Unwrap
    local plywrap, plyunwrap = Instance.Types.Player.Wrap, Instance.Types.Player.Unwrap
    local vehwrap, vehunwrap = Instance.Types.Vehicle.Wrap, Instance.Types.Vehicle.Unwrap
    local vwrap, _           = Instance.Types.Vector.Wrap, Instance.Types.Vector.Unwrap
    local awrap, _           = Instance.Types.Angle.Wrap, Instance.Types.Angle.Unwrap
    local mwrap, _           = Instance.Types.VMatrix.Wrap, Instance.Types.VMatrix.Unwrap
    -- local cwrap, _           = Instance.Types.Color.Wrap, Instance.Types.Color.Unwrap
    local pwrap, punwrap     = Instance.Types.PhysObj.Wrap, Instance.Types.PhysObj.Unwrap
    local wwrap, wunwrap           = Instance.Types.Weapon.Wrap, Instance.Types.Weapon.Unwrap
    local quat_meta = Instance.Types.Quaternion
    local function qwrap(q)
        return setmetatable(q, quat_meta)
    end

    local CHECK_ENT = function(E, P) return DetectionPP.CantDetect(eunwrap(E), P) end
    local CHECK_PLY = function(E, P) return DetectionPP.CantDetect(plyunwrap(E), P) end
    local CHECK_WEP = function(E, P) return DetectionPP.CantDetect(wunwrap(E), P) end
    local CHECK_VEH = function(E, P) return DetectionPP.CantDetect(vehunwrap(E), P) end
    local CHECK_PHY = function(E, P)
        local Phy = punwrap(E)
        if not IsValid(Phy) then return false end
        return DetectionPP.CantDetect(Phy:GetEntity(), P)
    end

    local DEFAULT_NONE          = function() end
    local DEFAULT_NIL           = function() return nil end
    local DEFAULT_EMPTY_TABLE   = function() return {} end
    local DEFAULT_NUMBER        = function() return 0 end
    local DEFAULT_NEG1          = function() return -1 end
    local DEFAULT_STRING        = function() return "" end
    local DEFAULT_ENTITY        = function() return ewrap(NULL) end
    local DEFAULT_PLAYER        = function() return plywrap(NULL) end
    local DEFAULT_WEAPON        = function() return wwrap(NULL) end
    local DEFAULT_VEHICLE        = function() return vehwrap(NULL) end
    -- local DEFAULT_COLOR         = function() return cwrap(Color(0, 0, 0, 0)) end
    local DEFAULT_VECTOR        = function() return vwrap(Vector(0, 0, 0)) end
    local DEFAULT_ANGLE         = function() return awrap(Angle(0, 0, 0)) end
    local DEFAULT_VECTOR_ANGLE  = function() return vwrap(Vector(0, 0, 0)), awrap(Angle(0, 0, 0)) end
    local DEFAULT_VECTOR_VECTOR = function() return vwrap(Vector(0, 0, 0)), vwrap(Vector(0, 0, 0)) end
    local DEFAULT_MATRIX        = function() return mwrap(Matrix()) end
    local DEFAULT_QUATERNION    = function() return qwrap{0, 0, 0, 0} end
    local DEFAULT_PHYSOBJ       = function() return pwrap(nil) end
    local DEFAULT_BOOL          = function() return false end

    local function TrashTrace(Trace)
        local E = eunwrap(Trace.Entity)
        if DetectionPP.CantDetect(E, Instance.player) then
            DetectionPP.DefaultTrace(Trace, ewrap(NULL))
        end
        return Trace
    end

    local function DetourEntMethod(Method, Cond)                      DetourMethod(Instance.Types.Entity, CHECK_ENT, Method, DEFAULT_NONE, Cond) end
    local function DetourEntMethodReturningNil(Method, Cond)          DetourMethod(Instance.Types.Entity, CHECK_ENT, Method, DEFAULT_NIL, Cond) end
    local function DetourEntMethodReturningEmptyTable(Method, Cond)   DetourMethod(Instance.Types.Entity, CHECK_ENT, Method, DEFAULT_EMPTY_TABLE, Cond) end
    local function DetourEntMethodReturningNumber(Method, Cond)       DetourMethod(Instance.Types.Entity, CHECK_ENT, Method, DEFAULT_NUMBER, Cond) end
    -- local function DetourEntMethodReturning0000(Method, Cond)         DetourMethod(Instance.Types.Entity, CHECK_ENT, Method, function() return 0,0,0,0 end, Cond) end
    local function DetourEntMethodReturningNeg1(Method, Cond)         DetourMethod(Instance.Types.Entity, CHECK_ENT, Method, DEFAULT_NEG1, Cond) end
    local function DetourEntMethodReturningString(Method, Cond)       DetourMethod(Instance.Types.Entity, CHECK_ENT, Method, DEFAULT_STRING, Cond) end
    local function DetourEntMethodReturningAngle(Method, Cond)        DetourMethod(Instance.Types.Entity, CHECK_ENT, Method, DEFAULT_ANGLE, Cond) end
    local function DetourEntMethodReturningVector(Method, Cond)       DetourMethod(Instance.Types.Entity, CHECK_ENT, Method, DEFAULT_VECTOR, Cond) end
    -- local function DetourEntMethodReturningColor(Method, Cond)        DetourMethod(Instance.Types.Entity, CHECK_ENT, Method, DEFAULT_COLOR, Cond) end
    local function DetourEntMethodReturningMatrix(Method, Cond)       DetourMethod(Instance.Types.Entity, CHECK_ENT, Method, DEFAULT_MATRIX, Cond) end
    local function DetourEntMethodReturningEntity(Method, Cond)       DetourMethod(Instance.Types.Entity, CHECK_ENT, Method, DEFAULT_ENTITY, Cond) end
    local function DetourEntMethodReturningPhysObj(Method, Cond)      DetourMethod(Instance.Types.Entity, CHECK_ENT, Method, DEFAULT_PHYSOBJ, Cond) end
    local function DetourEntMethodReturningQuaternion(Method, Cond)   DetourMethod(Instance.Types.Entity, CHECK_ENT, Method, DEFAULT_QUATERNION, Cond) end
    local function DetourEntMethodReturningVectorAngle(Method, Cond)  DetourMethod(Instance.Types.Entity, CHECK_ENT, Method, DEFAULT_VECTOR_ANGLE, Cond) end
    local function DetourEntMethodReturningVectorVector(Method, Cond) DetourMethod(Instance.Types.Entity, CHECK_ENT, Method, DEFAULT_VECTOR_VECTOR, Cond) end
    local function DetourEntMethodReturningBool(Method, Cond)         DetourMethod(Instance.Types.Entity, CHECK_ENT, Method, DEFAULT_BOOL, Cond) end

    -- local function DetourPhysObjMethod(Method, Cond)                      DetourMethod(Instance.Types.PhysObj, CHECK_PHY, Method, DEFAULT_NONE, Cond) end
    local function DetourPhysObjMethodReturningNil(Method, Cond)          DetourMethod(Instance.Types.PhysObj, CHECK_PHY, Method, DEFAULT_NIL, Cond) end
    local function DetourPhysObjMethodReturningBool(Method, Cond)         DetourMethod(Instance.Types.PhysObj, CHECK_PHY, Method, DEFAULT_BOOL, Cond) end
    local function DetourPhysObjMethodReturningEmptyTable(Method, Cond)   DetourMethod(Instance.Types.PhysObj, CHECK_PHY, Method, DEFAULT_EMPTY_TABLE, Cond) end
    local function DetourPhysObjMethodReturningNumber(Method, Cond)       DetourMethod(Instance.Types.PhysObj, CHECK_PHY, Method, DEFAULT_NUMBER, Cond) end
    local function DetourPhysObjMethodReturning00(Method, Cond)         DetourMethod(Instance.Types.PhysObj, CHECK_PHY, Method, function() return 0,0 end, Cond) end
    -- local function DetourPhysObjMethodReturningNeg1(Method, Cond)         DetourMethod(Instance.Types.PhysObj, CHECK_PHY, Method, DEFAULT_NEG1, Cond) end
    -- local function DetourPhysObjMethodReturningString(Method, Cond)       DetourMethod(Instance.Types.PhysObj, CHECK_PHY, Method, DEFAULT_STRING, Cond) end
    local function DetourPhysObjMethodReturningAngle(Method, Cond)        DetourMethod(Instance.Types.PhysObj, CHECK_PHY, Method, DEFAULT_ANGLE, Cond) end
    local function DetourPhysObjMethodReturningVector(Method, Cond)       DetourMethod(Instance.Types.PhysObj, CHECK_PHY, Method, DEFAULT_VECTOR, Cond) end
    -- local function DetourPhysObjMethodReturningColor(Method, Cond)        DetourMethod(Instance.Types.PhysObj, CHECK_PHY, Method, DEFAULT_COLOR, Cond) end
    local function DetourPhysObjMethodReturningMatrix(Method, Cond)       DetourMethod(Instance.Types.PhysObj, CHECK_PHY, Method, DEFAULT_MATRIX, Cond) end
    local function DetourPhysObjMethodReturningEntity(Method, Cond)       DetourMethod(Instance.Types.PhysObj, CHECK_PHY, Method, DEFAULT_ENTITY, Cond) end
    -- local function DetourPhysObjMethodReturningPhysObj(Method, Cond)      DetourMethod(Instance.Types.PhysObj, CHECK_PHY, Method, DEFAULT_PHYSOBJ, Cond) end
    -- local function DetourPhysObjMethodReturningQuaternion(Method, Cond)   DetourMethod(Instance.Types.PhysObj, CHECK_PHY, Method, DEFAULT_QUATERNION, Cond) end
    -- local function DetourPhysObjMethodReturningVectorAngle(Method, Cond)  DetourMethod(Instance.Types.PhysObj, CHECK_PHY, Method, DEFAULT_VECTOR_ANGLE, Cond) end
    local function DetourPhysObjMethodReturningVectorVector(Method, Cond) DetourMethod(Instance.Types.PhysObj, CHECK_PHY, Method, DEFAULT_VECTOR_VECTOR, Cond) end

    -- local function DetourPlayerMethod(Method, Cond)                      DetourMethod(Instance.Types.Player, CHECK_PLY, Method, DEFAULT_NONE, Cond) end
    -- local function DetourPlayerMethodReturningNil(Method, Cond)          DetourMethod(Instance.Types.Player, CHECK_PLY, Method, DEFAULT_NIL, Cond) end
    local function DetourPlayerMethodReturningEmptyTable(Method, Cond)   DetourMethod(Instance.Types.Player, CHECK_PLY, Method, DEFAULT_EMPTY_TABLE, Cond) end
    local function DetourPlayerMethodReturningNumber(Method, Cond)       DetourMethod(Instance.Types.Player, CHECK_PLY, Method, DEFAULT_NUMBER, Cond) end
    -- local function DetourPlayerMethodReturning0000(Method, Cond)         DetourMethod(Instance.Types.Player, CHECK_PLY, Method, function() return 0,0,0,0 end, Cond) end
    -- local function DetourPlayerMethodReturningNeg1(Method, Cond)         DetourMethod(Instance.Types.Player, CHECK_PLY, Method, DEFAULT_NEG1, Cond) end
    -- local function DetourPlayerMethodReturningString(Method, Cond)       DetourMethod(Instance.Types.Player, CHECK_PLY, Method, DEFAULT_STRING, Cond) end
    local function DetourPlayerMethodReturningAngle(Method, Cond)        DetourMethod(Instance.Types.Player, CHECK_PLY, Method, DEFAULT_ANGLE, Cond) end
    local function DetourPlayerMethodReturningVector(Method, Cond)       DetourMethod(Instance.Types.Player, CHECK_PLY, Method, DEFAULT_VECTOR, Cond) end
    -- local function DetourPlayerMethodReturningColor(Method, Cond)        DetourMethod(Instance.Types.Player, CHECK_PLY, Method, DEFAULT_COLOR, Cond) end
    -- local function DetourPlayerMethodReturningMatrix(Method, Cond)       DetourMethod(Instance.Types.Player, CHECK_PLY, Method, DEFAULT_MATRIX, Cond) end
    local function DetourPlayerMethodReturningEntity(Method, Cond)       DetourMethod(Instance.Types.Player, CHECK_PLY, Method, DEFAULT_ENTITY, Cond) end
    local function DetourPlayerMethodReturningWeapon(Method, Cond)       DetourMethod(Instance.Types.Player, CHECK_PLY, Method, DEFAULT_WEAPON, Cond) end
    -- local function DetourPlayerMethodReturningPhysObj(Method, Cond)      DetourMethod(Instance.Types.Player, CHECK_PLY, Method, DEFAULT_PHYSOBJ, Cond) end
    local function DetourPlayerMethodReturningVehicle(Method, Cond)      DetourMethod(Instance.Types.Player, CHECK_PLY, Method, DEFAULT_VEHICLE, Cond) end
    -- local function DetourPlayerMethodReturningQuaternion(Method, Cond)   DetourMethod(Instance.Types.Player, CHECK_PLY, Method, DEFAULT_QUATERNION, Cond) end
    -- local function DetourPlayerMethodReturningVectorAngle(Method, Cond)  DetourMethod(Instance.Types.Player, CHECK_PLY, Method, DEFAULT_VECTOR_ANGLE, Cond) end
    -- local function DetourPlayerMethodReturningVectorVector(Method, Cond) DetourMethod(Instance.Types.Player, CHECK_PLY, Method, DEFAULT_VECTOR_VECTOR, Cond) end
    local function DetourPlayerMethodReturningBool(Method, Cond)         DetourMethod(Instance.Types.Player, CHECK_PLY, Method, DEFAULT_BOOL, Cond) end
    local function DetourPlayerMethodReturningTrace(Method, Cond)        local Func Func = DetourMethod(Instance.Types.Player, nil, Method, nil, Cond, function(self, ...)
        if DetectionPP.CantDetect(plyunwrap(self), Instance.player) then
            return {Hit = false}
        end

        local Trace = Func(self, ...)
        return TrashTrace(Trace)
    end) end

    -- local function DetourWeaponMethod(Method, Cond)                      DetourMethod(Instance.Types.Weapon, CHECK_WEP, Method, DEFAULT_NONE, Cond) end
    -- local function DetourWeaponMethodReturningNil(Method, Cond)          DetourMethod(Instance.Types.Weapon, CHECK_WEP, Method, DEFAULT_NIL, Cond) end
    -- local function DetourWeaponMethodReturningEmptyTable(Method, Cond)   DetourMethod(Instance.Types.Weapon, CHECK_WEP, Method, DEFAULT_EMPTY_TABLE, Cond) end
    local function DetourWeaponMethodReturningNumber(Method, Cond)       DetourMethod(Instance.Types.Weapon, CHECK_WEP, Method, DEFAULT_NUMBER, Cond) end
    -- local function DetourWeaponMethodReturning0000(Method, Cond)         DetourMethod(Instance.Types.Weapon, CHECK_WEP, Method, function() return 0,0,0,0 end, Cond) end
    -- local function DetourWeaponMethodReturningNeg1(Method, Cond)         DetourMethod(Instance.Types.Weapon, CHECK_WEP, Method, DEFAULT_NEG1, Cond) end
    local function DetourWeaponMethodReturningString(Method, Cond)       DetourMethod(Instance.Types.Weapon, CHECK_WEP, Method, DEFAULT_STRING, Cond) end
    -- local function DetourWeaponMethodReturningAngle(Method, Cond)        DetourMethod(Instance.Types.Weapon, CHECK_WEP, Method, DEFAULT_ANGLE, Cond) end
    -- local function DetourWeaponMethodReturningVector(Method, Cond)       DetourMethod(Instance.Types.Weapon, CHECK_WEP, Method, DEFAULT_VECTOR, Cond) end
    -- local function DetourWeaponMethodReturningColor(Method, Cond)        DetourMethod(Instance.Types.Weapon, CHECK_WEP, Method, DEFAULT_COLOR, Cond) end
    -- local function DetourWeaponMethodReturningMatrix(Method, Cond)       DetourMethod(Instance.Types.Weapon, CHECK_WEP, Method, DEFAULT_MATRIX, Cond) end
    -- local function DetourWeaponMethodReturningEntity(Method, Cond)       DetourMethod(Instance.Types.Weapon, CHECK_WEP, Method, DEFAULT_ENTITY, Cond) end
    -- local function DetourWeaponMethodReturningPhysObj(Method, Cond)      DetourMethod(Instance.Types.Weapon, CHECK_WEP, Method, DEFAULT_PHYSOBJ, Cond) end
    -- local function DetourWeaponMethodReturningQuaternion(Method, Cond)   DetourMethod(Instance.Types.Weapon, CHECK_WEP, Method, DEFAULT_QUATERNION, Cond) end
    -- local function DetourWeaponMethodReturningVectorAngle(Method, Cond)  DetourMethod(Instance.Types.Weapon, CHECK_WEP, Method, DEFAULT_VECTOR_ANGLE, Cond) end
    -- local function DetourWeaponMethodReturningVectorVector(Method, Cond) DetourMethod(Instance.Types.Weapon, CHECK_WEP, Method, DEFAULT_VECTOR_VECTOR, Cond) end
    local function DetourWeaponMethodReturningBool(Method, Cond)         DetourMethod(Instance.Types.Weapon, CHECK_WEP, Method, DEFAULT_BOOL, Cond) end

    -- local function DetourVehicleMethod(Method, Cond)                      DetourMethod(Instance.Types.Vehicle, CHECK_VEH, Method, DEFAULT_NONE, Cond) end
    -- local function DetourVehicleMethodReturningNil(Method, Cond)          DetourMethod(Instance.Types.Vehicle, CHECK_VEH, Method, DEFAULT_NIL, Cond) end
    -- local function DetourVehicleMethodReturningEmptyTable(Method, Cond)   DetourMethod(Instance.Types.Vehicle, CHECK_VEH, Method, DEFAULT_EMPTY_TABLE, Cond) end
    -- local function DetourVehicleMethodReturningNumber(Method, Cond)       DetourMethod(Instance.Types.Vehicle, CHECK_VEH, Method, DEFAULT_NUMBER, Cond) end
    -- local function DetourVehicleMethodReturning0000(Method, Cond)         DetourMethod(Instance.Types.Vehicle, CHECK_VEH, Method, function() return 0,0,0,0 end, Cond) end
    -- local function DetourVehicleMethodReturningNeg1(Method, Cond)         DetourMethod(Instance.Types.Vehicle, CHECK_VEH, Method, DEFAULT_NEG1, Cond) end
    -- local function DetourVehicleMethodReturningString(Method, Cond)       DetourMethod(Instance.Types.Vehicle, CHECK_VEH, Method, DEFAULT_STRING, Cond) end
    -- local function DetourVehicleMethodReturningAngle(Method, Cond)        DetourMethod(Instance.Types.Vehicle, CHECK_VEH, Method, DEFAULT_ANGLE, Cond) end
    -- local function DetourVehicleMethodReturningVector(Method, Cond)       DetourMethod(Instance.Types.Vehicle, CHECK_VEH, Method, DEFAULT_VECTOR, Cond) end
    -- local function DetourVehicleMethodReturningColor(Method, Cond)        DetourMethod(Instance.Types.Vehicle, CHECK_VEH, Method, DEFAULT_COLOR, Cond) end
    -- local function DetourVehicleMethodReturningMatrix(Method, Cond)       DetourMethod(Instance.Types.Vehicle, CHECK_VEH, Method, DEFAULT_MATRIX, Cond) end
    -- local function DetourVehicleMethodReturningEntity(Method, Cond)       DetourMethod(Instance.Types.Vehicle, CHECK_VEH, Method, DEFAULT_ENTITY, Cond) end
    -- local function DetourVehicleMethodReturningPhysObj(Method, Cond)      DetourMethod(Instance.Types.Vehicle, CHECK_VEH, Method, DEFAULT_PHYSOBJ, Cond) end
    -- local function DetourVehicleMethodReturningQuaternion(Method, Cond)   DetourMethod(Instance.Types.Vehicle, CHECK_VEH, Method, DEFAULT_QUATERNION, Cond) end
    -- local function DetourVehicleMethodReturningVectorAngle(Method, Cond)  DetourMethod(Instance.Types.Vehicle, CHECK_VEH, Method, DEFAULT_VECTOR_ANGLE, Cond) end
    -- local function DetourVehicleMethodReturningVectorVector(Method, Cond) DetourMethod(Instance.Types.Vehicle, CHECK_VEH, Method, DEFAULT_VECTOR_VECTOR, Cond) end
    local function DetourVehicleMethodReturningPlayer(Method, Cond)       DetourMethod(Instance.Types.Vehicle, CHECK_VEH, Method, DEFAULT_PLAYER, Cond) end


    -- TODO: Check how many of these use CPPI already. Those that do can be excluded from this list.

    DetourEntMethod("addCollisionListener")
    DetourEntMethodReturningEntity("entOwner")
    DetourEntMethodReturningEmptyTable("getAllConstrained")
    DetourEntMethodReturningAngle("getAngles")
    DetourEntMethodReturningVector("getAngleVelocity")
    DetourEntMethodReturningAngle("getAngleVelocityAngle")
    DetourEntMethodReturningVectorAngle("getAttachment")
    DetourEntMethodReturningNumber("getAttachmentParent")
    DetourEntMethodReturningNil("getAttachments")
    DetourEntMethodReturningNumber("getBodygroup")
    DetourEntMethodReturningNumber("getBodygroupCount")
    DetourEntMethodReturningString("getBodygroupName")
    DetourEntMethodReturningEmptyTable("getBodygroups")
    DetourEntMethodReturningMatrix("getBoneMatrix")
    DetourEntMethodReturningString("getBoneName")
    DetourEntMethodReturningNeg1("getBoneParent")
    DetourEntMethodReturningVectorAngle("getBonePosition")
    DetourEntMethodReturningNumber("getBoundingRadius")
    DetourEntMethodReturningEmptyTable("getChildren")
    DetourEntMethodReturningEmptyTable("getClipping")
    DetourEntMethodReturningVectorVector("getCollisionBounds")
    DetourEntMethodReturningNumber("getCollisionGroup")
    DetourEntMethodReturningNil("getDTAngle")
    DetourEntMethodReturningNil("getDTBool")
    DetourEntMethodReturningNil("getDTEntity")
    DetourEntMethodReturningNil("getDTFloat")
    DetourEntMethodReturningNil("getDTInt")
    DetourEntMethodReturningNil("getDTString")
    DetourEntMethodReturningNil("getDTVector")
    DetourEntMethodReturningAngle("getEyeAngles")
    DetourEntMethodReturningVectorVector("getEyePos")
    DetourEntMethodReturningVector("getForward")
    DetourEntMethodReturningAngle("getLocalAngles")
    DetourEntMethodReturningVector("getLocalPos")
    DetourEntMethodReturningVector("getLocalVelocity")
    DetourEntMethodReturningNumber("getMass")
    DetourEntMethodReturningVector("getMassCenter")
    DetourEntMethodReturningVector("getMassCenterW")
    DetourEntMethodReturningMatrix("getMatrix")
    -- are these two necessary?
    DetourEntMethodReturningVectorVector("getModelBounds")
    DetourEntMethodReturningNumber("getModelRadius")
    DetourEntMethodReturningVectorVector("getModelRenderBounds")
    DetourEntMethodReturningVector("getNearestPoint")
    DetourEntMethodReturningNil("getNetworkVars")
    DetourEntMethodReturningNil("getNWVar")
    DetourEntMethodReturningEmptyTable("getNWVarTable")
    DetourEntMethodReturningNil("getOwner")
    DetourEntMethodReturningNil("getParent")
    DetourEntMethodReturningPhysObj("getPhysicsObject")
    DetourEntMethodReturningNumber("getPhysicsObjectCount")
    DetourEntMethodReturningPhysObj("getPhysicsObjectNum")
    DetourEntMethodReturningVector("getPos")
    DetourEntMethodReturningQuaternion("getQuaternion")
    DetourEntMethodReturningVectorVector("getRenderBounds")
    DetourEntMethodReturningVector("getRight")
    DetourEntMethodReturningVectorVector("getRotatedAABB")
    DetourEntMethodReturningEmptyTable("getSaveTable")
    DetourEntMethodReturningEmptyTable("getTable")
    DetourEntMethodReturningVector("getUp")
    DetourEntMethodReturningNil("getVar")
    DetourEntMethodReturningVector("getVelocity")
    DetourEntMethodReturningNumber("getWaterLevel")
    DetourEntMethodReturningBool("isFrozen")
    DetourEntMethodReturningBool("isOnGround")
    DetourEntMethodReturningBool("isPlayerHolding")
    DetourEntMethodReturningEntity("isWeldedTo")
    DetourEntMethodReturningVector("localToWorld")
    DetourEntMethodReturningAngle("localToWorldAngles")
    DetourEntMethodReturningVector("localToWorldVector")
    DetourEntMethodReturningVector("obbCenter")
    DetourEntMethodReturningVector("obbCenterW")
    DetourEntMethodReturningVector("obbMaxs")
    DetourEntMethodReturningVector("obbMins")
    DetourEntMethodReturningVector("obbSize")
    -- This ones fun: we need to detour setParent because Sparky wants it so anyone can parent entities to anyones entities! Which is
    -- completely inconsistent with E2's behavior, and has caused security issues before with AdvDupe2. Very annoying problem - and 
    -- also opens up exploits here (parent a holo to an entity belonging to someone who hasnt consented to detection, then use that
    -- hologram to track them instead).
    DetourEntMethod("setParent")
    DetourEntMethodReturningVectorVector("worldSpaceAABB")
    DetourEntMethodReturningVector("worldToLocal")
    DetourEntMethodReturningAngle("worldToLocalAngles")
    DetourEntMethodReturningVector("worldToLocalVector")

    DetourPlayerMethodReturningWeapon("getActiveWeapon")
    DetourPlayerMethodReturningVector("getAimVector")
    DetourPlayerMethodReturningEntity("getEntityInUse")
    DetourPlayerMethodReturningTrace("getEyeTrace")
    DetourPlayerMethodReturningNumber("getFOV")
    DetourPlayerMethodReturningEntity("getGroundEntity")
    DetourPlayerMethodReturningVehicle("getVehicle")
    DetourPlayerMethodReturningEntity("getViewEntity")
    DetourPlayerMethodReturningEntity("getViewModel")
    DetourPlayerMethodReturningAngle("getViewPunchAngles")
    DetourPlayerMethodReturningWeapon("getWeapon")
    DetourPlayerMethodReturningVector("getWeaponColor")
    DetourPlayerMethodReturningEmptyTable("getWeapons")
    DetourPlayerMethodReturningBool("keyDown")
    DetourPlayerMethodReturningNumber("lastHitGroup")

    DetourWeaponMethodReturningString("getToolMode")
    DetourWeaponMethodReturningBool("isWeaponVisible")
    DetourWeaponMethodReturningNumber("lastShootTime")

    DetourVehicleMethodReturningPlayer("getDriver")
    DetourVehicleMethodReturningPlayer("getPassenger")

    DetourPhysObjMethodReturningVectorVector("calculateForceOffset")
    DetourPhysObjMethodReturningVectorVector("calculateVelocityOffset")
    DetourPhysObjMethodReturningVectorVector("getAABB")
    DetourPhysObjMethodReturningAngle("getAngles")
    DetourPhysObjMethodReturningVector("getAngleVelocity")
    DetourPhysObjMethodReturningEntity("getEntity")
    DetourPhysObjMethodReturningEmptyTable("getFrictionSnapshot")
    DetourPhysObjMethodReturningVector("getLocalVelocity")
    DetourPhysObjMethodReturningNumber("getMass")
    DetourPhysObjMethodReturningVector("getMassCenter")
    DetourPhysObjMethodReturningMatrix("getMatrix")
    DetourPhysObjMethodReturningEmptyTable("getMesh")
    DetourPhysObjMethodReturningEmptyTable("getMeshConvexes")
    DetourPhysObjMethodReturningVector("getPos")
    DetourPhysObjMethodReturning00("getStress")
    DetourPhysObjMethodReturningNil("getSurfaceArea")
    DetourPhysObjMethodReturningVector("getVelocity")
    DetourPhysObjMethodReturningVector("getVelocityAtPoint")
    DetourPhysObjMethodReturningNil("getVolume")
    DetourPhysObjMethodReturningBool("hasGameFlags")
    DetourPhysObjMethodReturningBool("isAsleep")
    DetourPhysObjMethodReturningBool("isMoveable")
    DetourPhysObjMethodReturningVector("localToWorld")
    DetourPhysObjMethodReturningVector("localToWorldVector")
    DetourPhysObjMethodReturningVector("worldToLocal")
    DetourPhysObjMethodReturningVector("worldToLocalVector")

    do
        local function TrashArray(Array, Check)
            for I = #Array, 1, -1 do
                if Check(Array[I], Instance.player) then
                    table.remove(Array, I)
                end
            end
            return Array
        end

        local find_library = Instance.Libraries.find
        local Funcs = {"all", "allPlayers", "byClass", "byModel", "byName", "closest", "inBox", "inCone", "inPVS", "inRay", "inSphere"}
        for _, FuncName in ipairs(Funcs) do
            local Func = find_library[FuncName]
            find_library[FuncName] = function(...) return TrashArray(Func(...), CHECK_ENT) end
        end
    end

    do
        local trace_library = Instance.Libraries.trace
        local FuncHull = trace_library.hull; function trace_library.hull(...) return TrashTrace(FuncHull(...)) end
        local FuncLine = trace_library.line; function trace_library.line(...) return TrashTrace(FuncLine(...)) end
    end
end)