local Detours = DetectionPP.Detours

local function DetourWireRangers()
    if scripted_ents.GetStored("gmod_wire_ranger") == nil then return end
    local ShowOutput ShowOutput = Detours.SENT("gmod_wire_ranger", "ShowOutput", function(self, Dist, Pos, Vel, Ang, Col, Val, SID, UID, Ent, HNrm, Trace)
        if DetectionPP.CantDetect(Ent, self:CPPIGetOwner()) then
            SID = ""
            UID = 0
            Ent = NULL
            if Trace then
                Trace.Entity = NULL
            end
        end
        return ShowOutput(self, Dist, Pos, Vel, Ang, Col, Val, SID, UID, Ent, HNrm, Trace)
    end)

    local TriggerOutput TriggerOutput = Detours.SENT("gmod_wire_ranger", "TriggerOutput", function(self, Dist, Pos, Vel, Ang, Col, Val, SID, UID, Ent, HNrm, Trace)
        if DetectionPP.CantDetect(Ent, self:CPPIGetOwner()) then
            SID = ""
            UID = 0
            Ent = NULL
            if Trace then
                Trace.Entity = NULL
            end
        end
        return TriggerOutput(self, Dist, Pos, Vel, Ang, Col, Val, SID, UID, Ent, HNrm, Trace)
    end)
end

local function DetourWireHSRangers()
    if scripted_ents.GetStored("gmod_wire_hsranger") == nil then return end

    local Trace Trace = Detours.SENT("gmod_wire_hsranger", "Trace", function(self)
        Trace(self)
        local Ent = Entity(self.Memory[19])
        if IsValid(Ent) and DetectionPP.CantDetect(Ent, self:CPPIGetOwner()) then
            -- Trash the memory addresses relating to entity info
            self.Memory[19] = -1
            for I = 20, 23 do self.Memory[I] = 0 end
        end
    end)
end

local function DetourWireTargetFinders()
    if scripted_ents.GetStored("gmod_wire_target_finder") == nil then return end

    -- Wire target finders SUCK code wise. There's literally zero good place we can detour here beyond Think. And this is horrid to look at.
    -- So this is just the logic for thinking ripped straight from Wiremod. I don't trust that enough servers will have an updated version
    --  of Wiremod in the future if we were to get this rewritten/add a hook, so this will have to do for now.

    local BaseClass = baseclass.Get("base_wire_entity")
    local function CheckPaintTarget(self, i)
        if (self.PaintTarget) then self:TargetPainter(self.SelectedTargets[i], true) end
    end

    Detours.SENT("gmod_wire_target_finder", "Think", function(self)
        BaseClass.Think(self)
        if not (self.Inputs.Hold and self.Inputs.Hold.Value > 0) then
            local Owner = self:GetCreator()
            -- Find targets that meet requirements
            local mypos = self:GetPos()
            local bogeys, dists, ndists = {}, {}, 0
            for _, contact in ipairs(ents.FindInSphere(mypos, self.MaxRange or 10)) do
                local class = contact:GetClass()
                if
                    -- DetectionPP specific check
                    not DetectionPP.CantDetect(contact, Owner) and

                    -- Ignore array of entities if provided
                    (not self.Ignored or not table.HasValue(self.Ignored, contact) ) and
                    -- Ignore owned stuff if checked
                    ((not self.NoTargetOwnersStuff or (class == "player") or (WireLib.GetOwner(contact) ~= self:GetPlayer())) and
                    -- NPCs
                    ((self.TargetNPC and (contact:IsNPC()) and (isOneOf(class, self.NPCName))) or
                    --Players
                    (self.TargetPlayer and (class == "player") and CheckPlayers(self, contact) or
                    --Locators
                    (self.TargetBeacon and (class == "gmod_wire_locator")) or
                    --RPGs
                    (self.TargetRPGs and (class == "rpg_missile")) or
                    -- Hoverballs
                    (self.TargetHoverballs and (class == "gmod_hoverball" or class == "gmod_wire_hoverball")) or
                    -- Thruster
                    (self.TargetThrusters	and (class == "gmod_thruster" or class == "gmod_wire_thruster" or class == "gmod_wire_vectorthruster")) or
                    -- Props
                    (self.TargetProps and (class == "prop_physics") and (isOneOf(contact:GetModel(), self.PropModel))) or
                    -- Vehicles
                    (self.TargetVehicles and contact:IsVehicle()) or
                    -- Entity classnames
                    (self.EntFil ~= "" and isOneOf(class, self.EntFil)))))
                then
                    local dist = (contact:GetPos() - mypos):Length()
                    if (dist >= self.MinRange) then
                        -- put targets in a table index by the distance from the finder
                        bogeys[dist] = contact

                        ndists = ndists + 1
                        dists[ndists] = dist
                    end
                end
            end

            -- sort the list of bogeys by key (distance)
            self.Bogeys = {}
            self.InRange = {}
            table.sort(dists)
            local k = 1
            for i, d in ipairs(dists) do
                if not self:IsTargeted(bogeys[d], i) then
                    self.Bogeys[k] = bogeys[d]
                    k = k + 1
                    if k > self.MaxBogeys then break end
                end
            end


            -- check that the selected targets are valid
            for i = 1, self.MaxTargets do
                if (self:IsOnHold(i)) then
                    self.InRange[i] = true
                end

                if not self.InRange[i] or not self.SelectedTargets[i] or self.SelectedTargets[i] == nil or not self.SelectedTargets[i]:IsValid() then
                    if (self.PaintTarget) then self:TargetPainter(self.SelectedTargets[i], false) end
                    if (#self.Bogeys > 0) then
                        self.SelectedTargets[i] = table.remove(self.Bogeys, 1)
                        CheckPaintTarget(self, i)
                        Wire_TriggerOutput(self, tostring(i), 1)
                        Wire_TriggerOutput(self, tostring(i) .. "_Ent", self.SelectedTargets[i])
                    else
                        self.SelectedTargets[i] = nil
                        Wire_TriggerOutput(self, tostring(i), 0)
                        Wire_TriggerOutput(self, tostring(i) .. "_Ent", NULL)
                    end
                end
            end

        end

        -- temp hack
        -- ^^ The temp hack in question: committed 12 years ago
        if self.SelectedTargets[1] then
            self:ShowOutput(true)
        else
            self:ShowOutput(false)
        end
        self:NextThink(CurTime() + 1)
        return true
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