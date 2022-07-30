if CLIENT then return end

AddCSLuaFile("cl_breach.lua")

util.AddNetworkString("BreachGuiOpen")
util.AddNetworkString("BreachSendHint")

Breach.Queue = {}

function Breach.OpenBreachGui(_ply, _tab)
    print("Sending message to client")
    net.Start("BreachGuiOpen")
        net.WriteTable(_tab)
    net.Send(_ply)
end

function Breach.Breach(_ply)
    _ply:SetNWBool("IsBreaching", true)
    table.RemoveByValue(Breach.Queue, _ply)
    DarkRP.notify(_ply, 0, 3, "You are breaching your cell!")
end

function Breach.StopBreach()
    for k, v in pairs(player.GetAll()) do
        v:SetNWBool("IsBreaching", false)
    end
end

function Breach.AddPlayerToBreachQueue(_ply)
    local IsAllowed = false
    local AlreadyInQueue = false

    for k, v in pairs(Breach.AllowedSCPS) do
        if v.name == _ply:getDarkRPVar("job") then
            IsAllowed = true
        end
    end

    if table.KeyFromValue(Breach.Queue, _ply) then
        IsAllowed = false
        AlreadyInQueue = true
    end

    if IsAllowed then
        table.insert(Breach.Queue, 1, _ply)
        DarkRP.notify(_ply, 0, 3, "You have been added to the queue.")
    else
        if AlreadyInQueue then
            print("Already in queue")
            DarkRP.notify(_ply, 1, 3, "You are already in queue.")
        else
            DarkRP.notify(_ply, 1, 3, "You are unable to use that command!")
        end
    end
end

hook.Add("PlayerSpawn", "SetPlayerNWVals", function(_ply)
    _ply:SetNWBool("IsBreaching", false)
end)

hook.Add("OnPlayerChangedTeam", "RemoveFromQueue", function(_ply, _oldTeam, _newTeam)
    local IsAllowed = false

    for k, v in pairs(Breach.AllowedSCPS) do
        if v.name == _ply:getDarkRPVar("job") then
            IsAllowed = true
        end
    end

    if not IsAllowed and table.KeyFromValue(Breach.Queue, _ply) then
        table.RemoveByValue(Breach.Queue, _ply)
    end
end)

hook.Add("PlayerDisconnected", "RemovePlayerFromQueue", function(_ply)
    if table.KeyFromValue(Breach.Queue, _ply) then
        table.RemoveByValue(Breach.Queue, _ply)
    end
end)