PRINT_DEBUG = 1
PRINT_INFO = 2
PRINT_WARN = 3
PRINT_ERROR = 4

local Schemes = {
    [PRINT_DEBUG] = {Name = "DEBUG", Color = Color( 0, 200, 150 )},
    [PRINT_INFO] = {Name = "INFO",  Color = Color( 255, 135, 255 )},
    [PRINT_WARN] = {Name = "WARN",  Color = Color( 255, 130, 90 )},
    [PRINT_ERROR] = {Name = "ERROR", Color = Color( 250, 55, 40 )}
}

local Realm = {
	Name = SERVER and "SERVER" or "CLIENT",
	Color = SERVER and TAC.SIGNITURE_BLUE or Color(66,255,96)
}

local White = SERVER and TAC.WHITE or Color(255,255,255)
local Gray = SERVER and TAC.GRAY or Color(180,180,180)

local Length = 0

for k, Scheme in pairs(Schemes) do
    if #Scheme.Name > Length then 
		Length = #Scheme.Name
	end
end

return function(Level, Module, Text, ...)
	if not Level or not Module then
		return
	end

	local Scheme = Schemes[Level]
	
	if not Scheme then
		return
	end
	
	local Padding = string.format("%-" .. Length .. "s", Scheme.Name)

    MsgC(
		Gray, 
		"[ ",
		Realm.Color,
		"Trinity",
		Gray,
		" : ",
		Realm.Name,
		" ] ",
		Scheme.Color, 
		Padding,
		Gray, 
		" --> ", 
		Realm.Color,
		string.upper(Module), 
		Gray, 
		" : ",
		White, 
		string.format(
			Text,
			...
		), 
		"\n" 
	)
end