local o_print = MsgC
_G.MsgC = function(...)
	TAC.CaptureStack("MsgC")
	return o_print(...)
end