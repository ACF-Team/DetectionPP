DetectionPP.FriendsChanges = {}

function DetectionPP.ClientPanel(Panel)
    DetectionPP.RequestFriends(DetectionPP.UpdatePanelFriends)
    Panel:ClearControls()
    if not DetectionPP.ClientCPanel then DetectionPP.ClientCPanel = Panel end
    Panel:SetName("DetectionPP - Client Panel")

    local txt = Panel:Help("Friends Panel")
    txt:SetContentAlignment(TEXT_ALIGN_CENTER)
    txt:SetFont("DermaDefaultBold")
    txt:SetAutoStretchVertical(false)

    DetectionPP.FriendsChanges = {} -- Reset the table

    local Players = player.GetAll()
    if #Players == 1 then
        Panel:Help("No other players are online")
    else
        for _, Player in pairs(Players) do
            if IsValid(Player) and Player ~= LocalPlayer() then
                local Checkbox = Panel:Add "DCheckBoxLabel"
                Checkbox:SetText(Player:Nick())
                function Checkbox:OnChange(Value)
                    if IsValid(Player) then
                        DetectionPP.FriendsChanges[Player:SteamID64()] = Value
                    end
                end
                Panel:AddItem(Checkbox)
            end
        end

        Panel:Button("Apply Friends", "detectionpp_applyfriends")
    end
end

function DetectionPP.GetFriendsChanges()
    return DetectionPP.FriendsChanges
end

concommand.Add("detectionpp_applyfriends", function() DetectionPP.UpdateFriends(DetectionPP.GetFriendsChanges()) end)

function DetectionPP.UpdatePanelFriends(LUT)

end

function DetectionPP.SpawnMenuOpen()
    if DetectionPP.ClientCPanel then DetectionPP.ClientPanel(DetectionPP.ClientCPanel) end
end
hook.Add("SpawnMenuOpen", "DetectionPP.SpawnMenuOpen", DetectionPP.SpawnMenuOpen)

function DetectionPP.PopulateToolMenu()
    spawnmenu.AddToolMenuOption("Utilities", "DetectionPP", "Client", "Client", "", "", DetectionPP.ClientPanel)
end
hook.Add("PopulateToolMenu", "DetectionPP.PopulateToolMenu", DetectionPP.PopulateToolMenu)