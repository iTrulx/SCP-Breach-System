Breach = {}

Breach.AllowedSCPS = {
    {
        name = "SCP-173",
        doorPos = Vector(0,0,0)
    },

    {
        name = "SCP-457",
        doorPos = Vector(0,0,0)
    },

    {
        name = "SCP-049",
        doorPos = Vector(0,0,0)
    },

    {
        name = "SCP-035",
        doorPos = Vector(0,0,0)
    },

    {
        name = "SCP-087-II",
        doorPos = Vector(0,0,0)
    },

    {
        name = "SCP-008-II",
        doorPos = Vector(0,0,0)
    },

    {
        name = "SCP-096", --Shy guy
        doorPos = Vector(0,0,0)
    },

    {
        name = "SCP-106",
        doorPos = Vector(0,0,0)
    },

    {
        name = "SCP-076-II",
        doorPos = Vector(0,0,0)
    },

    {
        name = "SCP-913",
        doorPos = Vector(0,0,0)
    },

    {
        name = "SCP-939",
        doorPos = Vector(0,0,0)
    },

    {
        name = "SCP-682",
        doorPos = Vector(0,0,0)
    },

}


if SERVER then
    include("sv_breach.lua")
else
    AddCSLuaFile("cl_breach.lua")
    include("cl_breach.lua")
end