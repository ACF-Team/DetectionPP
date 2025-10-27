function DetectionPP.DefaultVector() return Vector(0, 0, 0) end
function DetectionPP.DefaultAngle() return Angle(0, 0, 0) end
function DetectionPP.DefaultVectorAngle() return Vector(0, 0, 0), Angle(0, 0, 0) end
function DetectionPP.DefaultEntity() return NULL end
function DetectionPP.DefaultNumber() return 0 end
function DetectionPP.DefaultString() return "" end
function DetectionPP.DefaultTable() return {} end

function DetectionPP.DefaultTrace(Trace, null)
    if not Trace then -- We are being asked to create a whole new trace
        return {Hit = false}
    else -- We are just being asked to anonymize
        Trace.Entity = null
        Trace.SurfaceFlags = 0
        Trace.PhysicsBone = 0
        Trace.SurfaceProps = 0
        -- TODO: Should we be even more vague?
        return Trace
    end
end