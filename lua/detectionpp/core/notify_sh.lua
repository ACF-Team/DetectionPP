if SERVER then
    util.AddNetworkString("DetectionPP_Notify")
    function DetectionPP.Notify(Player, Text, Type, Length)
        net.Start("DetectionPP_Notify")

        net.Send(Player)
    end
else
    net.Receive("DetectionPP_Notify", function()
        notification.AddLegacy(net.ReadString(), net.ReadInt(5), net.ReadFloat())
    end)
end