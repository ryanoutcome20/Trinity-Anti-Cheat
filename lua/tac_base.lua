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
		)
	)
end

function TAC.Print(Text, ...)
	return TAC.PrintColor(
		TAC.SIGNITURE_GOLD,
		Text,
		...
	)
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