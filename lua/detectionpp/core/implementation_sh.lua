-- Just replicating CPPI a little bit here as a future proofing sort of thing
-- (I'm sure someone will tell me this is excessive and I'll agree later)
local ENTITY = FindMetaTable("Entity")

DPPI = {}
function DPPI:GetName() return "Detection Prop Protection by the ACF Team" end
function DPPI:GetVersion() return "1.0" end

function ENTITY:DPPICanDetect(Player) return DetectionPP.PlayerCanDetect(Player, self) end
local ClassOverrides = {}

function ClassOverrides.gmod_wire_hologram(self) return self:GetPlayer()   end

function ENTITY:DPPIGetOwner()
    if ENTITY.CPPIGetOwner then
        local Owner = ENTITY.CPPIGetOwner(self)
        if Owner then return Owner end
    end

    if not IsValid(self) then return NULL end

    local Class = ENTITY.GetClass(self)
    local Func  = ClassOverrides[Class]
    if Func then
        local Owner = Func(self)
        if IsValid(Owner) then
            return Owner
        end
    end

    -- print("NO OWNER: ", self)
    -- ACF.DumpStack()
    return NULL
end