function DetectionPP.Default() return nil end
function DetectionPP.DefaultVector() return Vector(0, 0, 0) end
function DetectionPP.DefaultVectorX2() return Vector(0, 0, 0), Vector(0, 0, 0) end
function DetectionPP.DefaultVectorX3() return Vector(0, 0, 0), Vector(0, 0, 0), Vector(0, 0, 0) end
function DetectionPP.DefaultAngle() return Angle(0, 0, 0) end
function DetectionPP.DefaultVectorAngle() return Vector(0, 0, 0), Angle(0, 0, 0) end
function DetectionPP.DefaultEntity() return NULL end
function DetectionPP.DefaultPhysicsObject() return nil end
function DetectionPP.DefaultNumber() return 0 end
function DetectionPP.DefaultString() return "" end
function DetectionPP.DefaultTable() return {} end

function DetectionPP.DefaultTrace(Trace, null)
    if not Trace then -- We are being asked to create a whole new trace
        return {
            Hit = false, HitWorld = false, HitNonWorld = false, HitSky = false, HitNoDraw = false,
            StartSolid = false, AllSolid = false,
            HitPos = Vector(0, 0, 0), StartPos = Vector(0, 0, 0), HitNormal = Vector(0, 0, 0), Normal = Vector(0, 0, 0),
            Fraction = 0, FractionLeftSolid = 0,
            Entity = NULL,
            HitBox = 0, HitGroup = 0, PhysicsBone = 0, MatType = 0, SurfaceProps = 0, SurfaceFlags = 0, DispFlags = 0, Contents = 0,
            HitTexture = "",
        }
    else -- We are just being asked to anonymize
        Trace.Entity = null
        Trace.SurfaceFlags = 0
        Trace.PhysicsBone = 0
        Trace.SurfaceProps = 0
        -- TODO: Should we be even more vague?
        return Trace
    end
end