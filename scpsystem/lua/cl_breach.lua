
net.Receive("BreachGuiOpen", function()
    local ServerBreachers = net.ReadTable()
    PrintTable(ServerBreachers)

    local QueueMenu = vgui.Create("DFrame")
    QueueMenu:SetSize(ScrW()*0.2, ScrH()*0.4)
    QueueMenu:Center()
    QueueMenu:SetTitle("Breach Queue")
    QueueMenu:MakePopup()

    local plyList = vgui.Create("DListView", QueueMenu)
    plyList:Dock(FILL)
    plyList:AddColumn("Player Name")
    plyList:AddColumn("Job")

    for k, v in pairs(ServerBreachers) do
        plyList:AddLine(v:Nick(), v:getDarkRPVar("job"))
    end
end)


