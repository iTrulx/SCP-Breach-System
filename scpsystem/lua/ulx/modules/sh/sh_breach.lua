
if SERVER then
	util.AddNetworkString("BreachGuiOpen")
	util.AddNetworkString("BreachSendHint")
end


--Actually ULX

local CATEGORY_NAME = "SCP Breaching"

function ulx.breach( calling_ply)
	--Breach them
	if #Breach.Queue and #Breach.Queue>0 then
		Breach.Breach(table.GetLastValue(Breach.Queue))

		ulx.fancyLogAdmin( calling_ply, "#A started a breach")
	else
		DarkRP.notify(calling_ply, 0, 3, "The queue is empty.")
		print("None in queue")
	end
end

local breach = ulx.command( CATEGORY_NAME, "ulx breach", ulx.breach, "!breach" )
breach:defaultAccess( ULib.ACCESS_ADMIN )
breach:help( "Breaches next SCP in the queue." )

--

function ulx.breachply( calling_ply, target_plys)
	local affected_plys = {}

	for i=1, #target_plys do
		local v = target_plys[ i ]
		--Breach them
		Breach.Breach(v)
	end

	ulx.fancyLogAdmin( calling_ply, "#A breached #T", affected_plys)
end

local breachply = ulx.command( CATEGORY_NAME, "ulx breach player", ulx.breachply, "!breachply" )
breachply:addParam{ type=ULib.cmds.PlayersArg }
breachply:defaultAccess( ULib.ACCESS_ADMIN )
breachply:help( "Breaches selected targets." )

--

function ulx.stopbreach( calling_ply)
	Breach.StopBreach()
	DarkRP.notify(calling_ply, 0, 3, "You have stopped all breaches.")
end

local stopbreach = ulx.command( CATEGORY_NAME, "ulx stop breach", ulx.stopbreach, "!stopbreach" )
stopbreach:defaultAccess( ULib.ACCESS_ADMIN )
stopbreach:help( "Ends all breaches." )

--

function ulx.breachqueue( calling_ply)

    Breach.OpenBreachGui(calling_ply, Breach.Queue)

end

local breachqueue = ulx.command( CATEGORY_NAME, "ulx breach queue", ulx.breachqueue, "!breachqueue" )
breachqueue:defaultAccess( ULib.ACCESS_ALL )
breachqueue:help( "Opens breach menu." )

--

function ulx.breachapply( calling_ply)
	print("Applying for breach")
	Breach.AddPlayerToBreachQueue(calling_ply)
end

local breachapply = ulx.command( CATEGORY_NAME, "ulx breach apply", ulx.breachapply, "!breachapply" )
breachapply:defaultAccess( ULib.ACCESS_ALL )
breachapply:help( "Requests to be added to the Breach Queue" )

--

function ulx.breachall( calling_ply)
	local affected_plys = {}

	for i=1, #Breach.Queue do
		local v = Breach.Queue[ i ]
		--Breach them
		Breach.Breach(v)
	end

	Breach.Queue = {}

	ulx.fancyLogAdmin( calling_ply, "#A breached everyone")
end

local breachall = ulx.command( CATEGORY_NAME, "ulx breach all", ulx.breachall, "!breachall" )
breachall:defaultAccess( ULib.ACCESS_ADMIN )
breachall:help( "Breaches everyone in queue." )