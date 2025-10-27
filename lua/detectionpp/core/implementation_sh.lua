-- Just replicating CPPI a little bit here as a future proofing sort of thing
-- (I'm sure someone will tell me this is excessive and I'll agree later)
DPPI = {}
function DPPI:GetName() return "Detection Prop Protection by the ACF Team" end
function DPPI:GetVersion() return "1.0" end

function ENTITY:DPPICanDetect(Player) return DetectionPP.PlayerCanDetect(Player, self) end
function ENTITY:DPPIGetOwner()
    -- For now, this method just returns what CPPIGetOwner returns. Every time we get called,
    -- we should try to override ourselves - if we fail, return NULL. The only reason this exists is
    -- to allow ourselves to decouple if need be.
    if ENTITY.CPPIGetOwner then
        ENTITY.DPPIGetOwner = ENTITY.CPPIGetOwner
        -- ^^ then every other call will go to the CPPI implementor rather than needing a double-function call each time.
        return ENTITY.CPPIGetOwner(self)
    end

    return NULL
end