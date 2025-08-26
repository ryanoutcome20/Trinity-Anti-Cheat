--[[ ~~~~~~~~~~~~~~~~~~ ]]--
--[[ Trinity Anti-Cheat ]]--
--[[ ~~~~~~~~~~~~~~~~~~ ]]--

--- Setup ---

local TAC = { }

TAC.Config = include("config/tac_client.lua")
TAC.Atlas = include("atlas/cl_atlas.lua")

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
	
	local Object = table.remove(TAC.Flags.Buffer)
	
	-- Check if we even have anything to process.
	if not Object then
		return
	end
	
	-- Send our alert.
	TAC.Atlas:Send(
		"Flag", 
		{
			cID = Object.cID,
			Message = Object.Message
		}
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

function TAC.Lists.Merge(Name)
	if TAC.Lists.Cache[Name] then
		return TAC.Lists.Cache[Name]
	end

	TAC.Lists.Cache[Name] = include("tac/lists/cl_" .. string.lower(Name) .. ".lua")
	
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
	local Variables = {}

	if (Info and Info.what == "Lua") then
		local Upvalues = info.nups

		for i = 1, Upvalues do
			local k,v = debug.getupvalue(Function, i)
			
			Variables[k] = v
		end
	end

	return Variables
end

--- Alerts ---

local shouldNotify = CreateClientConVar("tac_should_notify", 1)

net.Receive("tac-alert", function()
	if not shouldNotify:GetBool() then
		return
	end

	local Message, Type, Sound = unpack(net.ReadTable())
	
	Message = "TAC: " .. Message
	
	notification.AddLegacy(Message, Type, 8)
	surface.PlaySound(Sound)
end)

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

function TAC.LoadFile(Directory)
	if file.Exists(Directory, "LUA") then
		local Code = file.Read(Directory, "LUA")
		
		Code = CompileString(Code, Directory)
		
		if Code then
			setfenv(Code, TAC.Environment)()
			return true
		end
	end
	
	ErrorNoHalt("Trinity File Failure: " .. Directory)
	
	return false
end

function TAC.LoadPlugins(Root)
	Root = Root or "tac/"

    local Stack = { }
	
    table.insert(Stack, Root)

    while #Stack > 0 do
        local Directory = table.remove(Stack)
        local Files, Directories = file.Find(Directory .. "*", "LUA")

		if Root ~= Directory then
			if TAC.LoadFile(Directory .. "init.lua") then
				TAC.Loaded = TAC.Loaded + 1
			end
		end

        for k, Sub in ipairs(Directories) do
            table.insert(Stack, Directory .. Sub .. "/")
        end
    end
end

TAC.LoadPlugins()

CreateClientConVar("_t", TAC.Loaded, false, true, "", TAC.Loaded, TAC.Loaded)

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
	
	concommand.Add("tac_reload_plugins", function()
		TAC.LoadPlugins()
	end)
	
	concommand.Add("tac_reload_config", function()
		TAC.Config = include("config/tac_client.lua")
		TAC.Print("Reloaded config!")
	end)
end