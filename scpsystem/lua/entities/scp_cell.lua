AddCSLuaFile()

local RenderCells = true

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName = "SCP Cell"
ENT.Author = "Matthias"
ENT.Spawnable = true
ENT.Whitelist = {}

function ENT:SetupDataTables()
    self:NetworkVar("Vector", 0, "Mins")
    self:NetworkVar("Vector", 1, "Maxs")
    self:NetworkVar("Vector", 2, "DrawColor")

    self:NetworkVar("String", 0, "Uid")
end

function ENT:Initialize()
	if CLIENT then
		self:SetRenderBounds( self:GetMins(), self:GetMaxs() )
    end

    self:DrawShadow(false)
end

function ENT:Draw()
    if not RenderCells then return end
    if LocalPlayer():IsSuperAdmin() then
        render.DrawWireframeBox( self:GetPos(), self:GetAngles(), self:GetMins(), self:GetMaxs(), self:GetDrawColor():ToColor(), false )

        cam.Start3D2D(self:GetPos(), Angle(0, LocalPlayer():EyeAngles().y-90, 90), 1)
            surface.SetDrawColor( 255, 255, 255, 200 )
            local w = 64
            surface.DrawRect( -w*0.5, 0, w, 8 )

            surface.SetFont("Default")
            surface.SetTextColor( 55, 55, 55, 255 )
            surface.SetTextPos( -w*0.5, -2)
            surface.DrawText( self:GetUid())
        cam.End3D2D()
    end
end


if SERVER then

    hook.Add("PostCleanupMap", "MakeScriptedCells", function()
        local ServerEnts, directories = file.Find("scpcells/*","DATA")
                
        for k,v in pairs(ServerEnts) do
            local JsonText = file.Read("scpcells/"..v, "DATA")
            local tab = util.JSONToTable(JsonText)
            
            local Door = ents.Create("scp_cell")
            Door:SetMins(tab.Min)
            Door:SetMaxs(tab.Max)
            Door:SetDrawColor(tab.Color)
            Door:SetUid(v)
            Door:SetPos(tab.Midpoint)
            Door.Whitelist = tab.Whitelist
            Door:Spawn()
            Door:SetCollisionBounds(Door:GetMins(), Door:GetMaxs())
        end
    end
    )

    hook.Add("InitPostEntity", "MakeScriptedCells", function()
        local ServerEnts, directories = file.Find("scpcells/*","DATA")
                
        for k,v in pairs(ServerEnts) do
            local JsonText = file.Read("scpcells/"..v, "DATA")
            local tab = util.JSONToTable(JsonText)
            
            local Door = ents.Create("scp_cell")
            Door:SetMins(tab.Min)
            Door:SetMaxs(tab.Max)
            Door:SetDrawColor(tab.Color)
            Door:SetUid(v)
            Door:SetPos(tab.Midpoint)
            Door.Whitelist = tab.Whitelist
            Door:Spawn()
            Door:SetCollisionBounds(Door:GetMins(), Door:GetMaxs())
        end
    end
    )

    hook.Add("Think", "CellAreaCheck", function()

        local Cells = {}
        
        for k, v in pairs(ents.FindByClass("scp_cell")) do
            table.insert(Cells, 1, {job = v.Whitelist, pos = v:GetPos(), max = v:GetMaxs(), min = v:GetMins()})
        end

        for k,v in pairs(Cells) do
            
            for j, l in pairs(player.GetAll()) do
                if l:getDarkRPVar("job")==v.job then

                    local mins = v.pos+v.min
                    local maxs = v.pos+v.max

                    local PlayerIsInBox = false
                    local HopefullyPlayer = ents.FindInBox(mins, maxs)

                    --Three loops, I suck...
                    for h, k in pairs(HopefullyPlayer) do
                        if k:IsPlayer() and k==l then
                            PlayerIsInBox = true
                        end
                    end

                    if not PlayerIsInBox then
                        if not l:GetNWBool("IsBreaching") then

                            local EmptyPos = DarkRP.findEmptyPos(v.pos-Vector(0,0,40), {}, 100, 10, Vector(16, 16, 64))

                            if EmptyPos then
                                l:SetPos(EmptyPos)
                            else
                                l:SetPos(v.pos-Vector(0,0,40))
                            end

                            DarkRP.notify(l, 1, 5, "You don’t have permission to leave your CC. Try !breachapply.")
                        end
                    end


                end
            end
        end
    end
    )
end