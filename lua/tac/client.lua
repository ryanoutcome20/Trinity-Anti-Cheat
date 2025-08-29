--[[ ~~~~~~~~~~~~~~~~~~ ]]--
--[[ Trinity Anti-Cheat ]]--
--[[ ~~~~~~~~~~~~~~~~~~ ]]--

--- Setup ---

local TAC = { }

TAC.Config = include("tac/config/client.lua")
TAC.Atlas = include("atlas/cl_atlas.lua")

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

Get = TAC.Localizers.Get

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

--- Colors ---

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

--- Base ---

function TAC.PrintColor(TagColor, Text, ...)
	MsgC(
		TAC.WHITE,
		"[",
		TagColor,
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
		TAC.SIGNITURE_GREEN,
		Text,
		...
	)
end

function TAC.Random(Length)
	Length = Length or math.random(20, 40)
	
	local Text = ""
	
	for i = 1, Length do
		Text = Text .. string.char(math.random(97, 122))
	end
	
	return Text
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

--- Flag System ---

TAC.Flags = { 
	Buffer = { }
}

function TAC.Flags.Flag(cID, Message, ...)	
	table.insert(TAC.Flags.Buffer, {
		cID = cID,
		Message = string.format(
			Message,
			...
		)
	})
end

function TAC.Flags.Process()
	timer.Simple(0.25, TAC.Flags.Process)
	
	-- Get our batch that we're sending.
	local Objects, Size = { }, 0
	
	while Size < TAC.Config.BatchSize and #Objects < TAC.Config.BatchCount do 
		local Object = table.remove(TAC.Flags.Buffer)
		
		if not Object then
			break
		end
		
		Size = Size + #Object.Message + #Object.cID
		
		table.insert(Objects, Object)
	end
	
	-- Check if we even have anything to process.
	if #Objects == 0 then
		return
	end
	
	-- Send our alert.
	TAC.Atlas:Send(
		"Flag Batch", 
		Objects
	)
	
	-- Clamp flags.
	while #TAC.Flags.Buffer > 15 do 
		table.remove(TAC.Flags.Buffer)
	end
end

timer.Simple(0.25, TAC.Flags.Process)

TAC.Flag = TAC.Flags.Flag

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
	for k, Name in ipairs(Match) do 
		if string.find(String, Name) then
			return Name
		end
	end
	
	return false
end

--- Function Buffers ---

function TAC.GenerateBuffer(Function)
	local GetInfo, FuncInfo = debug.getinfo(Function), jit.util.funcinfo(Function)

	return string.format(
		"%s:%s:%s:%s:%s %s:%s:%s %s",
		tostring(GetInfo.source or "s"):gsub("\\", "/"), -- OS specific.
		GetInfo.short_src or "sh",
		GetInfo.what or "wh",
		GetInfo.linedefined or "ld",
		GetInfo.lastlinedefined or "lld",
		
		FuncInfo.linedefined or "ld",
		FuncInfo.ffid or "ffid",
		FuncInfo.upvalues or "uv",
		
		(GetInfo.func == Function) and "fde" or "fne"
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

if not TAC.Config.Silent then
	TAC.Print("Trinity Pre-Init Loaded!")
end

--- Load Plugins ---

TAC.Environment = setmetatable({
	TAC = TAC,
	_G = _G
}, {
	__index = _G
})

function TAC.LoadCode(Code, File)
	Code = CompileString(Code, File or "MISSING")
	
	if Code then
		return setfenv(Code, TAC.Environment)()
	end
end

TAC.Atlas:Listen("Plugin", "TAC.Plugins", MODE_DONE, function(Stage, File, Code)	
	TAC.LoadCode(Code, File)
end)

--- Debug Mode ---

local Debug = true

if Debug then
	TAC.Print("Trinity Debug Enabled!")

	concommand.Add("tac_globalize", function()
		_G.TAC = TAC
	end)
	
	concommand.Add("tac_dbg_out", function()
		PrintTable(TAC)
	end)
	
	concommand.Add("tac_reload_config", function()
		TAC.Config = include("tac/config/client.lua")
		TAC.Print("Reloaded config!")
	end)
end