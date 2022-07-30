if SERVER then
	util.AddNetworkString("SCPCellsSetStage")
end

TOOL.Category = "SCP"
TOOL.Name = "Cell Areas"
TOOL.Command = nil
TOOL.ConfigName	= nil
TOOL.Max = nil
TOOL.Min = nil
TOOL.Whitelist = "None"

if CLIENT then
	language.Add("tool.scpcells.name", "SCP Cells")
	language.Add("tool.scpcells.desc", "Save cell areas to map.")
	language.Add("tool.scpcells.0", "Select option from control panel.")
	language.Add("tool.scpcells.1", "Left click to set max.")
	language.Add("tool.scpcells.2", "Left click to set min.")
	language.Add("tool.scpcells.3", "Left click to confirm your selection")
else
	net.Receive("SCPCellsSetStage", function(len, ply)
			local stage = net.ReadInt(4)
			local _whitelist = net.ReadString()
			local colVector = net.ReadVector()
			local gun = ply:GetTool("scpcells")
			gun:SetStage(stage)
			gun.Whitelist = _whitelist
			gun:SetDoorValues(colVector)
		end
	)
end

function TOOL:Deploy()
	self:SetStage(0)
end


function TOOL:Holster()
	self:SetStage(0)
end

function TOOL:DrawToolScreen( width, height )
	surface.SetDrawColor( Color( 20, 20, 20 ) )
	surface.DrawRect( 0, 0, width, height )

	draw.SimpleText( "Praise Matthias!", "DermaLarge", width / 2, height / 2, Color( 200, 200, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

function TOOL:SetDoorValues(colVec)
	self.Color = colVec
end

function TOOL:LeftClick(trace)
	if (!self:GetOwner():IsSuperAdmin()) then
		return
	end

	if (SERVER) then
		if ((self.nextClick or 0) < CurTime()) then
			self.nextClick = CurTime() + 0.1
		else
			return
		end
		
		if self:GetStage()==0 then
			self:GetOwner():ChatPrint("Choose an option from the menu")
		elseif self:GetStage()==1 then
			--Set max
			local tr = self:GetOwner():GetEyeTrace()
			self.Max = tr.HitPos
			self:SetStage(2)
		elseif self:GetStage()==2 then
			--Set min
			local tr = self:GetOwner():GetEyeTrace()
			self.Min = tr.HitPos
			self:SetStage(3)
		elseif self:GetStage()==3 then

			local tr = self:GetOwner():GetEyeTrace()
			
			local TestVar = (self.Max+self.Min)*0.5

			self.Max = TestVar-self.Max
			self.Min = TestVar-self.Min
			
			local DoorInfo = {["Max"] = self.Max, ["Min"] = self.Min, ["Midpoint"] = TestVar, ["Whitelist"] = self.Whitelist, ["Color"] = self.Color}
			local tab = util.TableToJSON(DoorInfo, true)
			print(util.TableToJSON(DoorInfo, true))
			file.CreateDir("scpcells")
			local FileName = "Cell"..math.random(0,9999)..".txt"
			file.Write("scpcells/"..FileName, tab)


			local Door = ents.Create("scp_cell")
			Door:SetMins(DoorInfo.Min)
			Door:SetMaxs(DoorInfo.Max)
			Door:SetDrawColor(DoorInfo.Color)
			Door:SetUid(FileName)
			Door:SetPos(DoorInfo.Midpoint)
			Door.Whitelist = DoorInfo.Whitelist
			Door:Spawn()
			Door:SetCollisionBounds(Door:GetMins(), Door:GetMaxs())

			self:SetStage(0)
		end
		
	end

	return true
end

function TOOL:RightClick(trace)
	if (!self:GetOwner():IsSuperAdmin()) then
		return
	end

	self:SetStage(0)
end

function TOOL:Allowed()
	return self:GetOwner():IsSuperAdmin()
end

function TOOL.BuildCPanel(panel)

	local listPan = vgui.Create("DListView", panel)
	listPan:DockMargin(8,8,8,8)
	listPan:Dock(TOP)
	listPan:SetSize(0, 100)
	listPan:SetMultiSelect(false)

	listPan:AddColumn("Jobs")

	for k, v in pairs(RPExtraTeams) do
		if v.name then
			listPan:AddLine(v.name)
		else
			listPan:AddLine(k)
		end
	end


	--[[
	local colorPan = vgui.Create("DColorMixer", panel)
	colorPan:DockMargin(8,8,8,8)
	colorPan:Dock(TOP)
	]]
	
	
	local newCheckButt = panel:Button("New Cell")
	function newCheckButt:DoClick()
		local DoorColor = Color(255,255,255)
		if colorPan then
			DoorColor = colorPan:GetColor()
		end

		local Lines = listPan:GetSelected()
		local LineInfo
		for k, v in pairs(Lines) do
			LineInfo = tostring(v:GetValue(1))
		end

		net.Start("SCPCellsSetStage")
			net.WriteInt(1,4)
			net.WriteString(LineInfo)
			net.WriteVector(Vector(DoorColor["r"]/255, DoorColor["g"]/255, DoorColor["b"]/255))
		net.SendToServer()
	end
	
end