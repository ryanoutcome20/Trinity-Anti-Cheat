--[[ ~~~~~~~~~~~~~~~~~~ ]]--
--[[ Trinity Anti-Cheat ]]--
--[[ ~~~~~~~~~~~~~~~~~~ ]]--

--- Anti-Hooking ---

local Blank = function() end

for i = 1, 10 do
	jit.flush()

	-- Garry'd
	-- jit.attach(Blank, "trace")

	jit.flush()
end

--- Setup ---

local TAC = { }

TAC.Atlas = include("external/atlas/cl_atlas.lua")
TAC.Print = include("external/sh_print.lua")

TAC.Loaded = 0

--- Localizers ---

TAC.Localizers = { }

function TAC.Localizers.Localize()
    local Result = { }
    
	local Stack = {
		{
			Source = _G, 
			Destination = Result
		} 
	}
    
	local Visted = {
		[_G] = true 
	}
	
    while #Stack > 0 do
        local Frame = table.remove(Stack)
		
        for Index, Value in pairs(Frame.Source) do
            if type(Value) == "table" and not Visted[Value] then
                local Target = { }
				
                Frame.Destination[Index] = Target
				
                Visted[Value] = true
				
                table.insert(Stack, {
					Source = Value, 
					Destination = Target
				})
            elseif type(Frame.Source) == "table" then
                Frame.Destination[Index] = Value
            end
        end
    end
		
	return Result
end

function TAC.Localizers.Get(...)
	local Current = TAC.Localizers.Table

	for k,v in ipairs({...}) do 
		if Current[v] then
			Current = Current[v]
		else
			return
		end
	end
	
	return Current
end

TAC.Localizers.Table = TAC.Localizers.Localize()

local Get = TAC.Localizers.Get

--- Manual Localizers ---

local string = Get("string")
local net = Get("net")
local math = Get("math")
local util = Get("util")
local table = Get("table")
local hook = Get("hook")
local debug = Get("debug")
local file = Get("file")
local jit = Get("jit")
local surface = Get("surface")
local notify = Get("notify")
local concommand = Get("concommand")

local tostring = Get("tostring")
local tobool = Get("tobool")
local istable = Get("istable")
local isstring = Get("isstring")
local isfunction = Get("isfunction")
local pcall = Get("pcall")
local pairs = Get("pairs")
local ipairs = Get("ipairs")
local setfenv = Get("setfenv")
local getfenv = Get("getfenv")
local Color = Get("Color")
local Angle = Get("Angle")
local Vector = Get("Vector")
local include = Get("include")
local CompileString = Get("CompileString")
local CreateClientConVar = Get("CreateClientConVar")
local LocalPlayer = Get("LocalPlayer")
local FindMetaTable = Get("FindMetaTable")

local PRINT_DEBUG = Get("PRINT_DEBUG")
local PRINT_INFO = Get("PRINT_INFO")
local PRINT_WARN = Get("PRINT_WARN")
local PRINT_ERROR = Get("PRINT_ERROR")

--- Colors ---

TAC.RED = Color(255,0,0)
TAC.GREEN = Color(0,255,0)
TAC.BLUE = Color(0,0,255)
TAC.YELLOW = Color(255,255,0)
TAC.GRAY = Color(180,180,180)
TAC.WHITE = Color(255,255,255)
TAC.BLACK = Color(0,0,0)
TAC.SIGNITURE_BLUE = Color(51,153,255)
TAC.SIGNITURE_GREEN = Color(66,255,96)
TAC.SIGNITURE_RED = Color(225, 1, 26)
TAC.SIGNITURE_GOLD = Color(245,194,71)

--- Base ---

function TAC.Random(Length)
	Length = Length or math.random(20, 40)
	
	local Text = ""
	
	for i = 1, Length do
		Text = Text .. string.char(math.random(97, 122))
	end
	
	return Text
end

function TAC.Size(Table)
	-- Close enough.
	
	if not istable(Table) then
		return #tostring(Table)
	end

	local Size = 0
	
	for k,v in pairs(Table) do 
		Size = Size + #tostring(v)
	end
	
	return Size
end

function TAC.StandardAngle(Yaw)
	if Yaw >= 0 and Yaw <= 180 then
		return Yaw
	end

	return Yaw - 360
end

function TAC.GetBinaryNames(Name)
	-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/includes/extensions/util.lua#L394-L418

	local Names = { }
	local Suffixes = { /*"osx64", "osx", "linux64", "linux", "linux32",*/ "win64", "win32" }
	
	for k, Suffix in ipairs(Suffixes) do 
		table.insert(Names, string.format(
			"lua/bin/gmcl_%s_%s.dll", 
			Name, 
			Suffix
		))
		
		table.insert(Names, string.format(
			"lua/bin/gmsv_%s_%s.dll", 
			Name, 
			Suffix
		))

		table.insert(Names, string.format(
			"lua/bin/gm_%s.dll", 
			Name
		))
	end
	
	return Names
end

--- List Manager ---

TAC.Lists = { 
	Cache = { }
}

function TAC.Lists.GetStringCase(Name)
	Name = string.Replace(Name, " ", "_")

	return string.lower(Name)
end

function TAC.Lists.Merge(Name, Shared)
	local Prefix = Shared and "sh_" or "cl_"

	if TAC.Lists.Cache[Name] then
		return TAC.Lists.Cache[Name]
	end

	local File = "tac/lists/" .. Prefix .. TAC.Lists.GetStringCase(Name) .. ".lua"

	if not file.Exists(File, "LUA") then
		TAC.Audit(
			string.format(
				"List Merge Failure `%s`!",
				File
			),
			"Integrity",
			"Loading"
		)
		
		return { }
	end
	
	TAC.Lists.Cache[Name] = include(File)

	return TAC.Lists.Cache[Name]
end

function TAC.Lists.Grab(Name)
	return TAC.Lists.Cache[Name]
end

--- Matches ---

local Match = TAC.Lists.Merge("Match")

function TAC.Match(String)
	String = string.lower(tostring(String))

	for k, Name in ipairs(Match) do 
		if string.find(String, Name) then
			return Name
		end
	end
	
	return false
end

--- Audits ----

local Keys = { }

function TAC.Audit(Message, Source, Key)
	if Key ~= nil then
		if Keys[Key] then
			return
		end

		Keys[Key] = true
	end

	TAC.Atlas:Send(
		"Audit",
		Message,
		Source
	)
end

--- Function Buffers ---

function TAC.GenerateBuffer(Function)
	local GetInfo, FuncInfo = debug.getinfo(Function, "fnS"), jit.util.funcinfo(Function)

	return {
		source = tostring(GetInfo.source or "s"):gsub("\\", "/"), -- OS specific. (#13)
		short_src = GetInfo.short_src or "sh",
		what = GetInfo.what or "wh",
		linedefined = GetInfo.linedefined or "ld",
		lastlinedefined = GetInfo.lastlinedefined or "lld",
		
		j_linedefined = FuncInfo.linedefined or "ld",
		
		name = GetInfo.name,
		namewhat = GetInfo.namewhat,
	}
end

function TAC.GenerateUpvalueTree(Function)
	local Info = debug.getinfo(Function, "uS")
	local Variables = { }

	if Info and Info.what == "Lua" then
		local Upvalues = Info.nups

		for i = 1, Upvalues do
			local k,v = debug.getupvalue(Function, i)
			
			Variables[k] = v
		end
	end

	return Variables
end

--- Detour System ---

TAC.Detour = {
    Registry = {}
}

function TAC.Detour.Register(Name, Callback, Meta)
    local Table, Key, Original;

    if Meta then
        Table = FindMetaTable(Meta)
       
		if not Table then 
			return 
		end
        
		Key = Name
        Original = Table[Key]
        Table[Key] = function(...)
			return Callback(Original, ...)
		end
    else
        local Split = string.Split(Name, ".")
		
        Table = _G
		
        for i = 1, #Split - 1 do
            Table = Table[Split[i]]
			
            if not Table then 
				return 
			end
        end
		
        Key = Split[#Split]
        Original = Table[Key]
        Table[Key] = function(...)
			return Callback(Original, ...)
		end
    end

    TAC.Detour.Registry[Name .. (Meta or "")] = {
        Table = Table,
        Key = Key,
        Original = Original
    }
end

function TAC.Detour.Unregister(Name, Meta)
    local Entry = TAC.Detour.Registry[Name .. (Meta or "")]
    
	if not Entry then 
		return 
	end

    Entry.Table[Entry.Key] = Entry.Original
	
    TAC.Detour.Registry[Name .. (Meta or "")] = nil
end

function TAC.Detour.Find(Function)
    for ID, Data in pairs(TAC.Detour.Registry) do
        if Data.Table[Data.Key] == Function then
            return ID, Data
        end
    end
end

--- Hook System ---

TAC.Hooks = { 
	ULX = file.Exists("ulib/shared/hook.lua", "LUA")
}

function TAC.Hooks.Add(Event, Name, Callback)
	if TAC.Hooks.ULX then
		return _G.hook.Add(Event, Name, Callback)
	end

	TAC.Hooks[Event] = TAC.Hooks[Event] or { }
	
	TAC.Hooks[Event][Name] = Callback
end

function TAC.Hooks.Remove(Event, Name)
	if TAC.Hooks.ULX then
		return _G.hook.Remove(Event, Name)
	end

	TAC.Hooks[Event] = TAC.Hooks[Event] or { }
	
	TAC.Hooks[Event][Name] = nil
end

function TAC.Hooks.Run(Event, ...)
	if TAC.Hooks.ULX then
		return _G.hook.Run(Event, ...)
	end
	
	TAC.Hooks[Event] = TAC.Hooks[Event] or { }

	for k, Callback in pairs(TAC.Hooks[Event]) do 
		local Data = { Callback(...) }
	
		if #Data ~= 0 then
			return unpack(Data)
		end
	end
end

if not TAC.Hooks.ULX then
	TAC.Detour.Register("hook.Call", function(Original, Event, Gamemode, ...)
		TAC.Hooks[Event] = TAC.Hooks[Event] or { }
		
		for k, Callback in pairs(TAC.Hooks[Event]) do 
			local Data = { Callback(...) }

			if #Data ~= 0 then
				return unpack(Data)
			end
		end

		return Original(Event, Gamemode, ...)
	end)
else
	TAC.Print(
		PRINT_WARN,
		"HOOKS",
		"ULX system is overriding hooks, using insecure hooks"
	)
end

TAC.Localizers.Table.hook.Add = TAC.Hooks.Add
TAC.Localizers.Table.hook.Remove = TAC.Hooks.Remove
TAC.Localizers.Table.hook.Run = TAC.Hooks.Run

--- CVar Callback ---

TAC.CVars = { 
	Callbacks = { }
}

function TAC.CVars.AddChangeCallback(Name, Callback, Identifier)
	TAC.CVars.Callbacks[Name] = TAC.CVars.Callbacks[Name] or { }

	if not Identifier then
		return table.insert(TAC.CVars.Callbacks[Name], Callback)
	end

	TAC.CVars.Callbacks[Name][Identifier] = Callback
end

function TAC.CVars.RemoveChangeCallback(Name, Identifier)
	TAC.CVars.Callbacks[Name] = TAC.CVars.Callbacks[Name] or { }

	TAC.CVars.Callbacks[Identifier] = nil
end

TAC.Detour.Register("cvars.OnConVarChanged", function(Original, Name, Old, New, ...)
	TAC.CVars.Callbacks[Name] = TAC.CVars.Callbacks[Name] or { }
	
	for k, Callback in pairs(TAC.CVars.Callbacks[Name]) do 
		Callback(Name, Old, New)
	end

	return Original(Name, Old, New, ...)
end)

TAC.Localizers.Table.cvars.AddChangeCallback = TAC.CVars.AddChangeCallback
TAC.Localizers.Table.cvars.RemoveChangeCallback = TAC.CVars.RemoveChangeCallback

--- Batch System ---

TAC.Batch = {
	Cache = { },
	Buffer = { },
	Head = 1
}

function TAC.Batch.Add(Message, Data, Size)
	TAC.Batch.Buffer[#TAC.Batch.Buffer + 1] = {
		Message = Message,
		Data = Data,
		Size = Size
	}
end

function TAC.Batch.Process()
	-- Add our repeat timer.
	timer.Simple(TAC.Config.ProcessTime, TAC.Batch.Process)

	-- Check if we have anything to process.
	if TAC.Batch.Head > #TAC.Batch.Buffer then
		TAC.Batch.Head = 1
		TAC.Batch.Buffer = { }
		return
	end
	
	-- Get our batch that we're sending.
	local Objects = {
		Send = { },
		Size = 0
	}
	
	while true do 
		local Object = TAC.Batch.Buffer[TAC.Batch.Head]
		
		if not Object then
			break
		end
		
		if Objects.Size + Object.Size > TAC.Config.Batch then
			break
		end
		
		Objects.Size = Objects.Size + Object.Size
		
		Objects.Send[Object.Message] = Objects.Send[Object.Message] or { }
		
		table.insert(Objects.Send[Object.Message], Object.Data)
		
		TAC.Batch.Head = TAC.Batch.Head + 1
	end
	
	-- Check if we even have anything to process.
	if Objects.Size == 0 then
		return
	end
	
	-- Send our alerts.
	for Name, Send in pairs(Objects.Send) do 
		TAC.Atlas:Send(
			Name .. " Batch",
			Send
		)
	end
end

TAC.Hooks.Add("TAC.TransferConfig", "TAC.Batch.Process", TAC.Batch.Process)

--- Flag System ---

function TAC.FlagEx(Buffered, cID, Message, ...)
	local Data = {
		cID = cID,
		Message = string.format(
			Message,
			...
		)
	}

	if Buffered then
		TAC.Batch.Add(
			"Flag", 
			Data, 
			#Data.cID + #Data.Message
		)
		
		return
	end
	
	TAC.Atlas:Send(
		"Flag", 
		Data
	)
end

function TAC.Flag(cID, Message, ...)
	return TAC.FlagEx(
		true,
		cID,
		Message,
		...
	)
end

--- Config System ---

TAC.Config = { }

TAC.Atlas:Listen("Config", "TAC.Config", MODE_DONE, function(Stage, Config)
	TAC.Config = Config

	TAC.Hooks.Run("TAC.TransferConfig", Config)
end)

--- Plugin System ---

TAC.Plugins = { }

TAC.Environment = setmetatable({
	TAC = TAC,
	
	_G = _G,
	_T = TAC.Localizers.Table
}, {
	__index = TAC.Localizers.Table
})

function TAC.Run()
	TAC.Loaded = TAC.Loaded + #TAC.Plugins

	for k, Object in ipairs(TAC.Plugins) do
		if not Object then
			continue
		end
		
		local Wrapped = setfenv(Object, TAC.Environment)
	
		xpcall(Wrapped, function(Message)
			TAC.Audit(
				string.format(
					"Got runtime error `%s`!",
					Message
				),
				"Integrity",
				"Loading"
			)
		end)
	end

	TAC.Plugins = { }

	TAC.Hooks.Run("TAC.Initialize", TAC.Config)
end

TAC.Hooks.Add("TAC.TransferConfig", "TAC.Run", TAC.Run)

--- Plugin Receiver ---

function TAC.LoadCode(Code, File)
	if not Code then
		return TAC.Print(
			PRINT_ERROR,
			"Plugins",
			"Invalid file format provided `%s`",
			File
		)
	end

	local Status = CompileString(Code, File or "MISSING", false)
	
	if isfunction(Status) then
		table.insert(TAC.Plugins, Status)
	else
		TAC.Audit(
			string.format(
				"Got compile error `%s`!",
				Status
			),
			"Integrity",
			"Loading"
		)
		
		TAC.Loaded = TAC.Loaded - 1
	end
end

TAC.Atlas:Listen("Plugin", "TAC.Plugins", MODE_DONE, function(Stage, File, Code)
	TAC.LoadCode(Code, File)
end)

--- Security Helper ---

TAC.Secure = { }

function TAC.IsSecure(Function)
	if TAC.Secure[Function] then
		return true
	end
	
	local Environment = getfenv(Function)

	if Environment == TAC.Environment then
		return true
	end
	
	local ID, Entry = TAC.Detour.Find(Function)

	if ID ~= nil then
		return true
	end

	return TAC[Function] ~= nil
end

--- Local Detours ---

TAC.Detour.Register("getfenv", function(Original, ...)
	local Environment = Original(...)

	if Environment == TAC.Environment then
		return _G
	end

	return Environment
end)

TAC.Detour.Register("setfenv", function(Original, Location, ...)
	local Environment = getfenv(Location, ...)

	if Environment == TAC.Environment then
		return Location
	end

	return Original(Location, ...)
end)

TAC.Detour.Register("debug.getfenv", function(Original, ...)
	local Environment = Original(...)

	if Environment == TAC.Environment then
		return _G
	end

	return Environment
end)

TAC.Detour.Register("debug.setfenv", function(Original, Location, ...)
	local Environment = debug.getfenv(Location, ...)

	if Environment == TAC.Environment then
		return Location
	end

	return Original(Location, ...)
end)

TAC.Detour.Register("debug.getlocal", function(Original, ...)
	local Name, Value = Original(...)

	if Name ~= nil then 
		if isfunction(Value) and TAC.IsSecure(Value) then
			return "(*temporary)", TAC.Random()
		elseif Value == TAC.Environment then
			return "(*temporary)", TAC.Random()
		end
	end

	return Name, Value
end)

TAC.Detour.Register("debug.getupvalue", function(Original, Function, ...)
	local Name, Value = Original(Function, ...)

	if Name ~= nil then 
		if isfunction(Function) and TAC.IsSecure(Function) then
			return TAC.Random(), TAC.Random()
		elseif isfunction(Value) and TAC.IsSecure(Value) then
			return TAC.Random(), TAC.Random()
		elseif Value == TAC.Environment then
			return TAC.Random(), TAC.Random()
		end
	end

	return Name, Value
end)

--- Libraries Check ---

TAC.Libraries = {
	Slots = {
		{
			Key = concommand.GetTable,
			Config = "concommand", 
			Index = "CommandList"
		},
		{
			Key = net.Receivers,
			Config = "net"
		}
	}
}

for k, Data in ipairs(TAC.Libraries.Slots) do 
	local Size = -1

	if Data.Index then
		Size = table.Count(TAC.GenerateUpvalueTree(Data.Key)[Data.Index])
	else
		Size = table.Count(Data.Key)
	end

	Data.Size = Size
end

function TAC.Libraries.Run()
	if not TAC.Config then
		return
	end

	local Config = TAC.Config.Integrity.Libraries

	if not Config.Enabled then
		return
	end

	for k, Data in ipairs(TAC.Libraries.Slots) do 
		local Sub = Config[Data.Config]

		if not Sub.Enabled then
			continue
		end

		if not Data.Size or Data.Size ~= Sub.Size then
			return TAC.Flag("Libraries", "Bad Libraries [%s; expected: %i; got: %s]", Data.Config, Sub.Size, Data.Size)
		end
	end
end

TAC.Hooks.Add("TAC.TransferConfig", "TAC.Libraries.Run", TAC.Libraries.Run)

--- Game Events ---

TAC.GameEvents = {
	Cache = TAC.Lists.Merge("Events")
}

TAC.Detour.Register("gameevent.Listen", function(Original, Hook, ...)
	TAC.GameEvents.Cache[Hook] = true

	TAC.Captures.Stack("gameevent.Listen")

	return Original(Hook, ...)
end)

--- Lua Directory Audit ---

function TAC.DirectoryAudit()
	local Luas = file.Find("lua/*.lua", "GAME")

	if #Luas ~= 0 then
		TAC.Atlas:Send(
			"Directory Audit",
			Luas
		)
	end
end

TAC.Hooks.Add("TAC.TransferConfig", "TAC.DirectoryAudit", TAC.DirectoryAudit)

--- Captures ---

TAC.Captures = {
	Ran = { },
	Hot = { }
}

function TAC.Captures.ClearHotTraces()
	TAC.Captures.Hot = { }
	timer.Simple(TAC.Config and TAC.Config.HT or 300, TAC.Captures.ClearHotTraces)
end

function TAC.Captures.Direct(Function, Message)
	local Data = TAC.GenerateBuffer(Function)

	if TAC.Detours.Whitelist.Whitelisted(Function, Data) then
		return
	end

	Data.Message = Message

	Data.source = nil

	TAC.Batch.Add(
		"Function", 
		Data, 
		TAC.Size(Data)
	)
end

function TAC.Captures.Stack(Message)
	for i = 3, 8 do 
		local Info = debug.getinfo(i, "f")
		
		if not Info then
			break
		end
		
		local Hash = tostring(Info.func)
		
		local Hot = (TAC.Captures.Hot[Hash] or 0) + 1

		TAC.Captures.Hot[Hash] = Hot

		if Hot > 15 then
			break
		elseif TAC.Captures.Ran[Hash] then
			continue
		end

		TAC.Captures.Direct(Info.func, Message)
		
		TAC.Captures.Ran[Hash] = true
	end
end

TAC_Capture_Stack = function(...)
	return TAC.Captures.Stack(...)
end

TAC_Capture_Direct = function(...)
	return TAC.Captures.Direct(...)
end

TAC.Secure[TAC_Capture_Stack] = true
TAC.Secure[TAC_Capture_Direct] = true

TAC.Captures.ClearHotTraces()

--- Detours ---

TAC.Detours = { 
	Whitelist = {
		Counter = 0,
		Identifiers = { 
			["RunString(Ex)"] = true,
			["CompileString"] = true
		},
		Hashes = { },
		Dumps = { }
	}
}

setmetatable(TAC.Detours.Whitelist.Dumps, {
	__mode = "k"
})

function TAC.Detours.Whitelist.Whitelisted(Function, Info)
	local Whitelist = TAC.Detours.Whitelist

	if Whitelist.Counter == 0 or not Whitelist.Identifiers[Info.short_src] then
		return false
	end
	
	local Hash = Whitelist.Hash(Function, Info.short_src)

	if Hash and Whitelist.Hashes[Hash] then
		Whitelist.Counter = math.max(Whitelist.Counter - 1, 0)
		return true
	end
	
	return false
end

function TAC.Detours.Whitelist.Hash(Function, Identifier)
	if not Function then
		return
	end
	
	if isstring(Function) then
		Function = CompileString(Function, Identifier)
	end
	
	if TAC.Detours.Whitelist.Dumps[Function] then
		return TAC.Detours.Whitelist.Dumps[Function]
	end

	local Valid, Dump = pcall(string.dump, Function, true)

	if not Valid then
		return 
	end
	
	local Checksum = util.CRC(Dump)
	
	TAC.Detours.Whitelist.Dumps[Function] = Checksum
	
	return Checksum
end

function TAC.Detours.Whitelist.Increment()
	TAC.Detours.Whitelist.Counter = TAC.Detours.Whitelist.Counter + 1
end

function TAC.Detours.Whitelist.Update(Code, Identifier)
	local Hash = TAC.Detours.Whitelist.Hash(Code, Identifier)

	if not Hash then
		return
	end

	TAC.Detours.Whitelist.Hashes[Hash] = true
end

TAC.Detour.Register("RunString", function(Original, Code, Identifier, ...)
	TAC.Captures.Stack("RunString")
	
	if Identifier then
		TAC.Detours.Whitelist.Identifiers[Identifier] = true
	end
	
	if isstring(Code) then
		TAC.Detours.Whitelist.Update(Code, Identifier)
	end
	
	TAC.Detours.Whitelist.Increment()
	
	return Original(Code, Identifier, ...)
end)

TAC.Detour.Register("RunStringEx", function(Original, Code, Identifier, ...)
	TAC.Captures.Stack("RunStringEx")
	
	if Identifier then
		TAC.Detours.Whitelist.Identifiers[Identifier] = true
	end
	
	if isstring(Code) then
		TAC.Detours.Whitelist.Update(Code, Identifier)
	end
	
	TAC.Detours.Whitelist.Increment()
	
	return Original(Code, Identifier, ...)
end)

TAC.Detour.Register("CompileString", function(Original, Code, Identifier, ...)
	TAC.Captures.Stack("CompileString")
	
	if Identifier then
		TAC.Detours.Whitelist.Identifiers[Identifier] = true
	end
	
	local Output = Original(Code, Identifier, ...)

	if isfunction(Output) then		
		TAC.Detours.Whitelist.Update(Output, Identifier)
	end
	
	TAC.Detours.Whitelist.Increment()
	
	return Output
end)