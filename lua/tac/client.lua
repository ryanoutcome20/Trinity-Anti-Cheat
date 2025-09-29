--[[ ~~~~~~~~~~~~~~~~~~ ]]--
--[[ Trinity Anti-Cheat ]]--
--[[ ~~~~~~~~~~~~~~~~~~ ]]--

--- Setup ---

local TAC = { }

TAC.Atlas = include("external/atlas/cl_atlas.lua")
TAC.Print = include("external/sh_print.lua")

TAC.Loaded = 0

--- Plugin Setup ---

TAC.Garbage = gcinfo()

TAC.Sizes = {
	Commands = {Key = concommand.GetTable, Index = 1},
	Hooks = {Key = hook.GetTable, Index = 1},
	Net = {Key = net.Receivers, Index = -1}
}

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

local pcall = Get("pcall")
local Color = Get("Color")
local Angle = Get("Angle")
local Vector = Get("Vector")
local include = Get("include")
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

function TAC.Visible(Mask, Target, From)
	From = From or LocalPlayer():EyePos()
	
	local Trace = util.TraceLine({
		start = From,
		endpos = Target:EyePos(),
		mask = Mask,
		filter = {
			LocalPlayer(), 
			Target
		}
	})
	
	return not Trace.Hit or Trace.Entity == Target
end

function TAC.StandardAngle(Yaw)
	if Yaw >= 0 and Yaw <= 180 then
		return Yaw
	end

	return Yaw - 360
end

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

timer.Create("Batch", 0.25, 0, TAC.Batch.Process)

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

--- List Manager ---

TAC.Lists = { 
	Cache = { }
}

function TAC.Lists.Merge(Name, Shared)
	local Prefix = Shared and "sh_" or "cl_"

	if TAC.Lists.Cache[Name] then
		return TAC.Lists.Cache[Name]
	end

	TAC.Lists.Cache[Name] = include("tac/lists/" .. Prefix .. string.lower(Name) .. ".lua")
	
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

--- Function Buffers ---

function TAC.GenerateBuffer(Function, noFormat)
	local GetInfo, FuncInfo = debug.getinfo(Function), jit.util.funcinfo(Function)

	local Data = {
		source = tostring(GetInfo.source or "s"):gsub("\\", "/"), -- OS specific. (#13)
		short_src = GetInfo.short_src or "sh",
		what = GetInfo.what or "wh",
		linedefined = GetInfo.linedefined or "ld",
		lastlinedefined = GetInfo.lastlinedefined or "lld",
		
		j_linedefined = FuncInfo.linedefined or "ld",
		j_ffid = FuncInfo.ffid or "ffid",
		j_upvalues = FuncInfo.upvalues or "uv",
		
		isfunc = GetInfo.name and GetInfo.namewhat and GetInfo.linedefined > 0,
		
		equals = (GetInfo.func == Function) and "fde" or "fne"
	}
	
	if noFormat then
		return Data
	end

	return string.format(
		"%s:%s:%s:%s:%s:%s:%s:%s:%s",
		Data.source,
		Data.short_src,
		Data.what,
		Data.linedefined,
		Data.lastlinedefined,
		Data.j_linedefined,
		Data.j_ffid,
		Data.j_upvalues,
		Data.equals
	)
end

function TAC.GenerateUpvalueTree(Function)
	local Info = debug.getinfo(Function, "uS")
	local Variables = { }

	if Info and Info.what == "Lua" then
		local Upvalues = info.nups

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

function TAC.Hooks.Run(Event, ...)
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

--- Config System ---

TAC.Config = { }

TAC.Atlas:Listen("Config", "TAC.Config", MODE_DONE, function(Stage, Config)	
	TAC.Config = Config

	TAC.Hooks.Run("TAC.TransferConfig", Config)
end)

--- PIC ---

TAC.PIC = { }

function TAC.PIC.Generate(Target, Visited, Buffer)
	Visited = Visited or { 
		[_G] = true
	}
	Target = Target or _G
	Buffer = Buffer or { }

	for k,v in pairs(Target) do 
		if Visited[v] then
			continue
		end
		
		Visited[v] = true
		
		if istable(v) then
			if Buffer[k] then
				continue
			end
		
			Buffer[k] = { }
			TAC.PIC.Generate(v, Visited, Buffer[k])
		elseif isfunction(v) then
			Buffer[k] = { 
				Key = tostring(k),
				Value = TAC.GenerateBuffer(v)
			}
		end
	end
	
	return Buffer
end

function TAC.PIC.Sort(Target)
	local Keys = { }
	
	for k,v in pairs(Target) do
		table.insert(Keys, k)
	end
	
	table.sort(Keys, function(a, b)
		return tostring(a) < tostring(b)
	end)
	
	return Keys
end

function TAC.PIC.GenerateChecksum(Target, Buffer)
	Buffer = Buffer or ""

	local Keys = TAC.PIC.Sort(Target)
	
	for k, v in ipairs(Keys) do
		local Object = Target[v]
		
		if not istable(Object) then
			continue
		end
		
		if Object.Key and Object.Value then
			Buffer = Buffer .. "|" .. Object.Key .. ":" .. Object.Value
		else
			Buffer = Buffer .. "|" .. tostring(v)
			Buffer = Buffer .. TAC.PIC.GenerateChecksum(Object, "")
		end
	end
	
	return util.CRC(Buffer)
end

TAC.PIC.Generated = TAC.PIC.Generate()

--- Build Sizes ---

for k, Object in pairs(TAC.Sizes) do 
	if Object.Index == -1 then
		Object.Size = table.Count(Object.Key)
	else	
		local Key, Value = debug.getupvalue(Object.Key, Object.Index)
		
		if istable(Value) then
			Object.Size = table.Count(Value)
		end
	end
end

--- Load Message ---

TAC.Print(
	PRINT_INFO,
	"Info",
	"Trinity Pre-Init Loaded"
)

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
	for k, Object in ipairs(TAC.Plugins) do
		if not Object then
			continue
		end
		
		setfenv(Object, TAC.Environment)()
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

	Code = CompileString(Code, File or "MISSING")
	
	if Code then
		table.insert(TAC.Plugins, Code)
	end
end

TAC.Atlas:Listen("Plugin", "TAC.Plugins", MODE_DONE, function(Stage, File, Code)	
	TAC.LoadCode(Code, File)
end)

--- Debug Mode ---

local Debug = true

if Debug then
	TAC.Print(
		PRINT_DEBUG,
		"Debug",
		"Trinity Debug Enabled"
	)

	concommand.Add("tac_globalize", function()
		_G.TAC = TAC
		
		TAC.Print(
			PRINT_DEBUG,
			"Debug",
			"Object `%s` dumped to globals",
			tostring(_G.TAC)
		)
	end)
	
	concommand.Add("tac_dbg_out", function()
		PrintTable(TAC)
	end)
end