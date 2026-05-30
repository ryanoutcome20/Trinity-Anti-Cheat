-- This file was auto generated.

return {
	-- debug
	{Pointer = debug.setmetatable, Name = "debug.setmetatable", Message = "bad argument #2 to '?' (nil or table expected)"},
	{Pointer = debug.setfenv, Name = "debug.setfenv", Message = "bad argument #2 to '?' (table expected, got no value)"},
	{Pointer = debug.getinfo, Name = "debug.getinfo", Message = "bad argument #1 to '?' (function or level expected)"},

	-- jit.util
	{Pointer = jit.util.funcbc, Name = "jit.util.funcbc", Message = "bad argument #1 to '?' (function expected, got nil)"},
	{Pointer = jit.util.funcinfo, Name = "jit.util.funcinfo", Message = "bad argument #1 to '?' (function expected, got nil)"},

	-- string
	{Pointer = string.format, Name = "string.format", Message = "bad argument #1 to '?' (string expected, got nil)"},
	{Pointer = string.len, Name = "string.len", Message = "bad argument #1 to '?' (string expected, got nil)"},
	{Pointer = string.gsub, Name = "string.gsub", Message = "bad argument #1 to '?' (string expected, got nil)"},
	{Pointer = string.char, Name = "string.char", Message = "bad argument #1 to '?' (number expected, got nil)"},
	{Pointer = string.rep, Name = "string.rep", Message = "bad argument #1 to '?' (string expected, got nil)"},
	{Pointer = string.reverse, Name = "string.reverse", Message = "bad argument #1 to '?' (string expected, got nil)"},
	{Pointer = string.find, Name = "string.find", Message = "bad argument #1 to '?' (string expected, got nil)"},
	{Pointer = string.upper, Name = "string.upper", Message = "bad argument #1 to '?' (string expected, got nil)"},
	{Pointer = string.sub, Name = "string.sub", Message = "bad argument #1 to '?' (string expected, got nil)"},
	{Pointer = string.lower, Name = "string.lower", Message = "bad argument #1 to '?' (string expected, got nil)"},
	{Pointer = string.match, Name = "string.match", Message = "bad argument #1 to '?' (string expected, got nil)"},
	{Pointer = string.dump, Name = "string.dump", Message = "bad argument #1 to '?' (function expected, got nil)"},
	{Pointer = string.byte, Name = "string.byte", Message = "bad argument #1 to '?' (string expected, got nil)"},

	-- net
	{Pointer = net.Receive, Name = "net.Receive", Message = "lua/includes/extensions/net.lua:12: attempt to index local 'name' (a nil value)"},
	{Pointer = net.Start, Name = "net.Start", Message = "bad argument #1 to '?' (string expected, got nil)"}
}