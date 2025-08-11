--[[ ~~~~~~~~~~~~~~~~~~ ]]--
--[[ Trinity Anti-Cheat ]]--
--[[ ~~~~~~~~~~~~~~~~~~ ]]--

--- Setup ---

local TAC = { }

TAC.Config = include("config/tac_client.lua")
TAC.Atlas = include("atlas/cl_atlas.lua")

--- Localizers ---

TAC.Localizers = { }

function TAC.Localizers.Localize()
    local Result = {}
    
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

local Color = Get("Color")
local LocalPlayer = Get("LocalPlayer")()

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
		TAC.SIGNITURE_GREEN,
		Text,
		...
	)
end

--- Flag System ---

local Last = 0

function TAC.Flag(cID, Message, ...)
	local Time = CurTime()
	
	if Last >= Time then
		return
	end
	
	TAC.Atlas:Send(
		"Flag", 
		{
			cID = cID,
			Message = string.format(
				Message,
				...
			)
		}
	)
	
	Last = Time + TAC.Config.FlagInterval
end

--- File Stealer Breaker ---

if TAC.Config.FSB.Enabled then
	for k, Indentifier in ipairs(TAC.Config.FSB.Indentifier) do 
		TAC.Config.FSB.Handle(TAC.Config.FSB.Code, Indentifier)
	end
end

--- Mouse ---

TAC.Mouse = { }

function TAC.Mouse.Run(CUserCMD)
	if not vgui.CursorVisible() then
		return
	end
	
	if CUserCMD:GetMouseX() == 0 and CUserCMD:GetMouseY() == 0 then
		return
	end

	TAC.Flag("Client Mouse", "Menu Movement")
end

if TAC.Config.Mouse then
	hook.Add("CreateMove", "TAC.Mouse.Run", TAC.Mouse.Run)
end

--- Engine Prediction ---

TAC.Engine = { 
	Object = NULL
}

function TAC.Engine.CreateMove(CUserCMD)
	local Command = CUserCMD:CommandNumber()

	if Command == 0 then
		return
	end

	TAC.Engine.Object = Command
end

function TAC.Engine.SetupMove(Player, CMoveData, CUserCMD)
	local Command = CUserCMD:CommandNumber()
	
	if Command == 0 or not TAC.Engine.Object then
		return
	end

	if Command > TAC.Engine.Object then
		TAC.Flag("Engine Prediction", "Engine Prediction [in: %i; out: %i]", TAC.Engine.Object, Command)
	end
end

if TAC.Config.EnginePrediction then
	hook.Add("CreateMove", "TAC.Engine.CreateMove", TAC.Engine.CreateMove)
	hook.Add("SetupMove", "TAC.Engine.SetupMove", TAC.Engine.SetupMove)
end

--- Load Message ---

if not TAC.Config.Silent then
	TAC.Print("Trinity Clientside Loaded!")
end