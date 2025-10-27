local FILE_NAME = "detectionpp_config.json"

local ENTITY = FindMetaTable("Entity")

local DPP_Enabled = CreateConVar("detectionpp_enabled", "1", bit.bor(FCVAR_ARCHIVE, FCVAR_NOTIFY), "Enables/disables DetectionPP.", 0, 1)

if file.Exists(FILE_NAME, "DATA") then
    local FileData = file.Read(FILE_NAME, "DATA")
    DetectionPP.Permissions = util.JSONToTable(FileData)
    if not DetectionPP.Permissions then
        DetectionPP.Permissions = {}

        local BackupName = "detectionpp_config_backup_" .. os.date("%Y-%m-%dT%H%M%S%z") .. ".json"
        print("ERROR: DetectionPP's " .. FILE_NAME .. " was corrupt and failed to parse as valid JSON.")
        if file.Write(BackupName, FileData) then
            print("A backup was made at " .. BackupName .. ", in case you want to try fixing it.")
        else
            print("A backup could not be made.")
        end
    end
else
    DetectionPP.Permissions = {}
end


function DetectionPP.Save()
    file.Write(FILE_NAME, util.TableToJSON {
        Permissions = DetectionPP.Permissions
    })
end

-- These function names are lengthy, but mostly used internally, and I feel like
-- length but easy to understand is more important than trying to find a smipler name for now.

function DetectionPP.AllowPlayer1ToDetectPlayer2(Player1, Player2)
    if not IsValid(Player1) then return end
    if not IsValid(Player2) then return end

    if Player1 == Player2 then return end

    local Player1_SteamID, Player2_SteamID = Player1:SteamID64(), Player2:SteamID64()

    DetectionPP.Permissions[Player2_SteamID] = DetectionPP.Permissions[Player2_SteamID] or {}
    DetectionPP.Permissions[Player2_SteamID][Player1_SteamID] = true
    DetectionPP.Save()
end

-- Denies Player 1 from detecting Player 2.
function DetectionPP.DenyPlayer1FromDetectingPlayer2(Player1, Player2)
    if not IsValid(Player1) then return end
    if not IsValid(Player2) then return end

    if Player1 == Player2 then return end

    local Player2_SteamID = Player2:SteamID64()
    if not DetectionPP.Permissions[Player2_SteamID] then return end

    DetectionPP.Permissions[Player2_SteamID][Player1:SteamID64()] = nil
    DetectionPP.Save()
end

-- Checks if Player 1 has allowed Player 2 to detect Player 1's entities.
function DetectionPP.Player1AllowsPlayer2(Player1, Player2)
    if not IsValid(Player1) then return false end
    if not IsValid(Player2) then return false end

    -- Global enabled/disabled
    if not DPP_Enabled:GetBool() then return true end

    -- The players checking itself
    if Player1 == Player2 then return true end

    local Player1_SteamID = Player1:SteamID64()

    if not DetectionPP.Permissions[Player1_SteamID] then return false end
    return DetectionPP.Permissions[Player1_SteamID][Player2:SteamID64()] == true
end

-- Checks if the player can detect this entity.
local CAN_ALWAYS_DETECT_WORLD = true -- Only set to false when testing.
function DetectionPP.PlayerCanDetect(Player, Entity)
    -- Allow everyone to detect worldspawn
    if ENTITY.IsWorld(Entity) then return CAN_ALWAYS_DETECT_WORLD end

    -- Different type of check for players
    if ENTITY.IsPlayer(Entity) then
        return DetectionPP.Player1AllowsPlayer2(Entity, Player)
    end

    return DetectionPP.Player1AllowsPlayer2(ENTITY.DPPIGetOwner(Entity), Player)
end

util.AddNetworkString("DetectionPP_RefreshFriends")
util.AddNetworkString("DetectionPP_Friends")
util.AddNetworkString("DetectionPP_AllowedUpdate")

-- This timeout stuff is just to avoid potential net spam
local ALLOC_TABLE_REFRESH = 1
local ALLOC_TABLE_SET     = 2
local Friends_Timeouts = {
    [ALLOC_TABLE_REFRESH] = {},
    [ALLOC_TABLE_SET]     = {}
}

local TIME_BETWEEN_REQUESTS = 3

local function TryAllocTimeout(AllocTable, SteamID)
    local Now = CurTime()
    local Timeouts = Friends_Timeouts[AllocTable]
    -- If not allocated...
    if not Timeouts[SteamID] then
        Timeouts[SteamID] = Now + TIME_BETWEEN_REQUESTS
        return 0
    end
    -- If it's been long enough...
    if Now > Timeouts[SteamID] then
        Timeouts[SteamID] = Now + TIME_BETWEEN_REQUESTS
        return 0
    end

    return Timeouts[SteamID] - Now
end

net.Receive("DetectionPP_RefreshFriends", function(_, Player)
    if not IsValid(Player) then return end

    local SteamID = Player:SteamID64()
    local TimeRemaining = TryAllocTimeout(ALLOC_TABLE_REFRESH, SteamID)
    if TimeRemaining > 0 then
        -- DetectionPP.Notify(Player, string.format("Rate limited; cannot retrieve friends (try again in %.2f seconds)", TimeRemaining))
        -- ^^ would just get annoying
        return
    end

    local Friends = {}
    local FriendsLUT = DetectionPP.Permissions[SteamID]
    if FriendsLUT then
        for _, SearchPlayer in player.Iterator() do
            if IsValid(SearchPlayer) then
                local PlayerSteamID = SearchPlayer:SteamID64()
                if FriendsLUT[PlayerSteamID] then
                    Friends[#Friends + 1] = PlayerSteamID
                end
            end
        end
    end

    net.Start("DetectionPP_Friends")
    net.WriteUInt(#Friends, 8) -- There may be a future (unlikely though) where this value is no longer limited to 7 bits?
    for i = 1, #Friends do
        net.WriteUInt64(Friends[I])
    end
    net.Send(Player)
end)

net.Receive("DetectionPP_Friends", function(_, Player)
    if not IsValid(Player) then return end

    local SteamID = Player:SteamID64()
    local TimeRemaining = TryAllocTimeout(ALLOC_TABLE_SET, SteamID)
    if TimeRemaining > 0 then
        DetectionPP.Notify(Player, string.format("Rate limited; cannot set friends (try again in %.2f seconds)", TimeRemaining))
        return
    end

    local TotalPlayers = net.ReadUInt(8)
    local TempLookup = {}
    for i = 1, TotalPlayers do
        TempLookup[net.ReadString()] = net.ReadBool()
    end
    for _, SearchPlayer in player.Iterator() do
        if IsValid(SearchPlayer) then
            local PlayerSteamID = SearchPlayer:SteamID64()
            local Wishes = TempLookup[PlayerSteamID]
            if Wishes == true then
                DetectionPP.AllowPlayer1ToDetectPlayer2(SearchPlayer, Player)
            elseif Wishes == false then
                DetectionPP.DenyPlayer1FromDetectingPlayer2(SearchPlayer, Player)
            end
        end
    end
end)