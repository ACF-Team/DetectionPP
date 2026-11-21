local Detours = DetectionPP.Detours

-- Runs Func with Library[Name] replaced by Wrap(original), puts it back even if Func errors
local function WithSwapped(Library, Name, Wrap, Func, ...)
    local Original = Library[Name]
    Library[Name] = Wrap(Original)
    local Results = {pcall(Func, ...)}
    Library[Name] = Original
    if not Results[1] then error(Results[2], 0) end
    return unpack(Results, 2, table.maxn(Results))
end

local function DetourWireRangers()
    if scripted_ents.GetStored("gmod_wire_ranger") == nil then return end

    -- All the outputs happen inside Think, clean up the trace it gets
    local Think Think = Detours.SENT("gmod_wire_ranger", "Think", function(self)
        local Owner = self:CPPIGetOwner()
        return WithSwapped(util, "TraceLine", function(TraceLine)
            return function(...)
                local Trace = TraceLine(...)
                if Trace and IsValid(Trace.Entity) and DetectionPP.CantDetect(Trace.Entity, Owner) then
                    DetectionPP.DefaultTrace(Trace, NULL)
                end
                return Trace
            end
        end, Think, self)
    end)
end

local function DetourWireHSRangers()
    if scripted_ents.GetStored("gmod_wire_hsranger") == nil then return end

    local Trace Trace = Detours.SENT("gmod_wire_hsranger", "Trace", function(self)
        Trace(self)
        local Index = self.Memory and self.Memory[19]
        local Ent = isnumber(Index) and Entity(Index)
        if IsValid(Ent) and DetectionPP.CantDetect(Ent, self:CPPIGetOwner()) then
            -- Trash the memory addresses relating to entity info
            self.Memory[19] = -1
            for I = 20, 23 do self.Memory[I] = 0 end
        end
    end)
end

local function DetourWireTargetFinders()
    if scripted_ents.GetStored("gmod_wire_target_finder") == nil then return end

    -- Target finders get all their candidates from one FindInSphere in Think
    local Think Think = Detours.SENT("gmod_wire_target_finder", "Think", function(self)
        local Owner = self:CPPIGetOwner()
        return WithSwapped(ents, "FindInSphere", function(FindInSphere)
            return function(...)
                local Found = FindInSphere(...)
                for I = #Found, 1, -1 do
                    if DetectionPP.CantDetect(Found[I], Owner) then table.remove(Found, I) end
                end
                return Found
            end
        end, Think, self)
    end)
end

local function DetourWireTriggers()
    if scripted_ents.GetStored("gmod_wire_trigger_entity") == nil then return end

    local StartTouch StartTouch = Detours.SENT("gmod_wire_trigger_entity", "StartTouch", function(self, Ent)
        if DetectionPP.CantDetect(Ent, self:GetTriggerEntity():CPPIGetOwner()) then return end
        StartTouch(self, Ent)
    end)
end

local function TriggerDetourRebuild()
    Detours.WireDetoursLoaded = true

    DetourWireRangers()
    DetourWireHSRangers()
    DetourWireTargetFinders()
    DetourWireTriggers()
end

DetectionPP.TriggerWireDetourRebuild = TriggerDetourRebuild
timer.Simple(Detours.WireDetoursLoaded and 0 or 3, TriggerDetourRebuild)
