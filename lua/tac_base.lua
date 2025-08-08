TAC.RED = Color(255,0,0)
TAC.GREEN = Color(0,255,0)
TAC.BLUE = Color(0,0,255)
TAC.YELLOW = Color(255,255,0)
TAC.WHITE = Color(255,255,255)
TAC.BLACK = Color(0,0,0)
TAC.SIGNITURE_BLUE = Color(51,153,255)
TAC.SIGNITURE_GREEN = Color(66,255,96)
TAC.SIGNITURE_RED = Color(225, 1, 26)
TAC.SIGNITURE_GOLD = Color(245,194,71)

local Player = FindMetaTable("Player")

function TAC.PrintColor(tagColor, Text, ...)
	MsgC(
		TAC.WHITE,
		"[",
		tagColor,
		"TAC",
		TAC.WHITE,
		"] ",
		string.format(
			Text,
			...
		),
		"\n"
	)
end

function TAC.Print(Text, ...)
	return TAC.PrintColor(
		TAC.SIGNITURE_GOLD,
		Text,
		...
	)
end

function TAC.StandardAngle(Yaw)
	if Yaw >= 0 and Yaw <= 180 then
		return Yaw
	end

	return Yaw - 360
end

function TAC.Sanitize(Text)
	local Indexes = {
		["\r"] = "\\r",
		["\n"] = "\\n",
		["\t"] = "\\t",
		["\b"] = "\\b",
		["\f"] = "\\f"
	}
	
	Text = Text:sub(1, 50)
	
	for k,v in pairs(Indexes) do 
		Text = Text:Replace(k,v)
	end
	
	return Text
end

TAC.Fix = TAC.Sanitize
tSanitize = TAC.Sanitize

function TAC.Enum(...)
	for k, Name in pairs({...}) do 
		_G[Name] = k - 1
	end
end

function TAC.IsStaff(Player)
	local Config = TAC.Config.Staff
	
	if Config.Roles[Player:GetUserGroup()] then
		return true
	end
	
	if Config.IDs[Player:SteamID()] or Config.IDs[Player:SteamID64()] then
		return true
	end
	
	return false
end

function TAC.Format(Token, Text, ...)
	if not Token then
		return
	end
	
	if not Text then
		if not Token.Message then
			return ""
		end
		
		Text = Token.Message
	end
	
	local Interpolated = string.Interpolate(Text, {
		["Name"] = TAC.Sanitize(Token.Player:Nick()),
		["SteamID64"] = Token.Player:SteamID64(),
		["SteamID"] = Token.Player:SteamID(),
		["IP"] = Token.Player:IPAddress(),
		["Ping"] = Token.Player:Ping(),
		["Loss"] = Token.Player:PacketLoss(),
		["Position"] = tostring(Token.Player:GetPos()),
		["Angle"] = tostring(Token.Player:EyeAngles()),
		
		["Info"] = Token.Info,
		["ID"] = Token.ID,
		
		["Flags"] = tostring(Token.flagsCount) or "N/A",
		
		["Contact"] = TAC.Config.Contact,
		["Map"] = game.GetMap(),
		["Gamemode"] = engine.ActiveGamemode()
	})
	
	return string.format(Interpolated, ...)
end

tFormat = TAC.Format
 
function TAC.Tell(What, Who, Type, Sound, Ignore)
	if TAC.Debug then
		What = What .. " [dbg]"
		Ignore = nil
	end
	
	if not Who or Who == ALERT_NONE then
		return
	end
		
	if not TAC.Config.Alerts.Enabled then
		return
	end
	
	Type = Type or NOTIFY_GENERIC

	for k, Player in ipairs(player.GetHumans()) do 
		if Ignore == Player then
			continue
		end
		
		if Who == ALERT_STAFF and not TAC.IsStaff(Player) then
			continue
		end
		
		Player:tAlert(
			What,
			Type,
			Sound
		)
	end
end

function TAC.Timer(Player, Delay, Callback)
	-- This would need a wrapper for callback if you
	-- wanted to apply arguments (like Tokens for 
	-- example).

	timer.Simple(Delay, function()
		if Player ~= nil and IsValid(Player) then
			if Callback ~= nil then
				Callback(Player)
			end
		end
	end)
end

function Player:Set(Key, Value)
	self.TAC = self.TAC or { }
	
	self.TAC[Key] = Value
	
	return Value
end

function Player:Grab(Key, Default)
	self.TAC = self.TAC or { }

	return self.TAC[Key] or Default
end

TAC.Enum(
	"ALERT_NONE",
	"ALERT_STAFF", 
	"ALERT_EVERYONE"
)

TAC.Enum(
	"NOTIFY_GENERIC",
	"NOTIFY_ERROR", 
	"NOTIFY_UNDO",
	"NOTIFY_HINT",
	"NOTIFY_CLEANUP"
)

TAC.Enum(
	"PUNISHMENT_LOG",
	"PUNISHMENT_KICK",
	"PUNISHMENT_BAN"
)

TAC.Enum(
	"EVALUATE_FAILED",
	"EVALUATE_FALLBACK",
	"EVALUATE_SUCCESS",
	"EVALUATE_BYPASSED",
	"EVALUATE_FORCED"
)

TAC.Enum(
	"EXECUTE_FAILED",
	"EXECUTE_FLAG",
	"EXECUTE_SUCCESS",
	"EXECUTE_BYPASSED"
)