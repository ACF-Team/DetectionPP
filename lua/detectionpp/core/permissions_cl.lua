local ENTITY = FindMetaTable("Entity")

local CallbackForFriends
DetectionPP.PlayersWhoAllowYouToDetectThem = {} -- Awesome name!
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
    local TotalPlayers = net.ReadUInt(8)
    local TempLookup = {}
    for i = 1, TotalPlayers do
        TempLookup[net.ReadString()] = true
    end
    if CallbackForFriends then
        pcall(CallbackForFriends, TempLookup)
        CallbackForFriends = nil
    end
    LastLUT = TempLookup
end)

-- Checks if Player 1 has allowed you to detect Player 1's entities.
function DetectionPP.PlayerAllows(Player)
    -- Global enabled/disabled
    if not DPP_Enabled:GetBool() then return true end

    if not IsValid(Player) then return false end

    -- The players checking itself
    if Player == LocalPlayer() then return true end

    local Player_SteamID = Player:SteamID()

    return DetectionPP.PlayersWhoAllowYouToDetectThem[Player_SteamID] == true
end

-- Checks if the player can detect this entity.
function DetectionPP.PlayerCanDetect(Player, Entity)
    -- Allow everyone to detect worldspawn
    if ENTITY.IsWorld(Entity) then return true end

    -- Information about whether other players can detect other players isnt networked. Just bail
    -- if this is the case.
    if Player ~= LocalPlayer() then return false end

    -- Different type of check for players
    if Entity:IsPlayer() then
        return DetectionPP.PlayerAllows(Entity)
    end

    return DetectionPP.PlayerAllows(ENTITY.DPPIGetOwner(Entity))
end

net.Receive("DetectionPP_AllowedUpdate", function()
    local Player = net.ReadString()
    local State = net.ReadBool()

    if State then
        DetectionPP.PlayersWhoAllowYouToDetectThem[Player] = true
    else
        DetectionPP.PlayersWhoAllowYouToDetectThem[Player] = nil
    end
end)