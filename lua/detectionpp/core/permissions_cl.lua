local ENTITY = FindMetaTable("Entity")

local CallbackForFriends
local LastLUT
function DetectionPP.RequestFriends(Callback)
    CallbackForFriends = Callback
    net.Start("DetectionPP_RefreshFriends")
    net.SendToServer()
    return LastLUT or {}
end

local DPP_Enabled = CreateConVar("detectionpp_enabled", "1", FCVAR_REPLICATED, "Enables/disables DetectionPP.", 0, 1)

function DetectionPP.UpdateFriends(FriendsChanges)
    if not LastLUT then -- Maintain a local version of our state
        LastLUT = {}
    end

    local Friends = {}
    for _, SearchPlayer in player.Iterator() do
        if IsValid(SearchPlayer) then
            local PlayerSteamID = SearchPlayer:SteamID()
            local Wishes = FriendsChanges[PlayerSteamID]
            if Wishes ~= nil then
                Friends[#Friends + 1] = PlayerSteamID
                LastLUT[PlayerSteamID] = Wishes == true
            else
                LastLUT[PlayerSteamID] = nil
            end
        end
    end
    net.Start("DetectionPP_Friends")
    net.WriteUInt(#Friends, 8)
    for I = 1, #Friends do
        net.WriteString(Friends[I])
        net.WriteBool(FriendsChanges[Friends[I]] == true)
    end

    net.SendToServer()
end

net.Receive("DetectionPP_Friends", function()
    local FullUpdate = net.ReadBool()

    local TotalPlayers = net.ReadUInt(8)
    local TempLookup = FullUpdate and {} or (LastLUT or {})
    for i = 1, TotalPlayers do
        TempLookup[net.ReadString()] = true
    end
    if CallbackForFriends then
        pcall(CallbackForFriends, TempLookup)
        CallbackForFriends = nil
    end
    LastLUT = TempLookup
end)

-- Clientside mirror of the server's detection graph: PermissionGraph[ownerSteamID][detectorSteamID] = true.
-- The server sends the full graph (online players only) when we become ready (DetectionPP_FullGraph) and
-- broadcasts a delta on every change (DetectionPP_GraphUpdate). Because we mirror the whole graph rather
-- than just our own inbound permissions, PlayerCanDetect can be evaluated correctly for ANY detector -
-- not just LocalPlayer - which is what other players' clientside Starfall instances need.
DetectionPP.PermissionGraph = {}

-- Checks if Owner has allowed Detector to detect Owner's entities.
function DetectionPP.OwnerAllowsDetector(Owner, Detector)
    -- Global enabled/disabled
    if not DPP_Enabled:GetBool() then return true end

    if not IsValid(Owner) then return false end
    if not IsValid(Detector) then return false end

    -- A player can always detect their own entities
    if Owner == Detector then return true end

    local Row = DetectionPP.PermissionGraph[Owner:SteamID()]
    return Row ~= nil and Row[Detector:SteamID()] == true
end

-- Checks if Player (the detector) can detect this entity.
function DetectionPP.PlayerCanDetect(Player, Entity)
    -- Allow everyone to detect worldspawn
    if ENTITY.IsWorld(Entity) then return true end

    -- For players, the entity itself is its own owner
    if Entity:IsPlayer() then
        return DetectionPP.OwnerAllowsDetector(Entity, Player)
    end

    return DetectionPP.OwnerAllowsDetector(ENTITY.DPPIGetOwner(Entity), Player)
end

net.Receive("DetectionPP_FullGraph", function()
    local Graph = {}
    local OwnerCount = net.ReadUInt(8)
    for _ = 1, OwnerCount do
        local OwnerSteamID = net.ReadString()
        local Row = {}
        local DetectorCount = net.ReadUInt(8)
        for _ = 1, DetectorCount do
            Row[net.ReadString()] = true
        end
        Graph[OwnerSteamID] = Row
    end
    DetectionPP.PermissionGraph = Graph
end)

net.Receive("DetectionPP_GraphUpdate", function()
    local OwnerSteamID    = net.ReadString()
    local DetectorSteamID = net.ReadString()
    local State           = net.ReadBool()

    local Graph = DetectionPP.PermissionGraph
    if State then
        local Row = Graph[OwnerSteamID]
        if not Row then
            Row = {}
            Graph[OwnerSteamID] = Row
        end
        Row[DetectorSteamID] = true
    else
        local Row = Graph[OwnerSteamID]
        if Row then
            Row[DetectorSteamID] = nil
            -- Drop empty rows so the graph doesn't accumulate stale owners
            if next(Row) == nil then
                Graph[OwnerSteamID] = nil
            end
        end
    end
end)