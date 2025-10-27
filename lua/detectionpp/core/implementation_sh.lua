-- Just replicating CPPI a little bit here as a future proofing sort of thing
-- (I'm sure someone will tell me this is excessive and I'll agree later)
local ENTITY = FindMetaTable("Entity")

DPPI = {}
function DPPI:GetName() return "Detection Prop Protection by the ACF Team" end
function DPPI:GetVersion() return "1.0" end

function ENTITY:DPPICanDetect(Player) return DetectionPP.PlayerCanDetect(Player, self) end
function ENTITY:DPPIGetOwner()
    if ENTITY.CPPIGetOwner then
        local Owner = ENTITY.CPPIGetOwner(self)
        if Owner then return Owner end
    end

    -- Wiremod hologram support 
    local Class = ENTITY.GetClass(self)

    if Class == "gmod_wire_hologram" then
        local Owner = self:GetPlayer()
        return Owner
    end

    -- print("NO OWNER: ", self, "\n", debug.traceback())
    return NULL
end