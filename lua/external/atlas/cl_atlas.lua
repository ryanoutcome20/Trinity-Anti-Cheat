-- Fork of:
-- https://github.com/ryanoutcome20/Atlas/tree/main

local tostring = tostring
local tonumber = tonumber
local tobool = tobool
local pairs = pairs

local net_Start = net.Start
local net_SendToServer = net.SendToServer
local net_Receive = net.Receive

local net_ReadUInt = net.ReadUInt
local net_ReadData = net.ReadData
local net_ReadBool = net.ReadBool
local net_ReadString = net.ReadString

local net_WriteUInt = net.WriteUInt
local net_WriteData = net.WriteData
local net_WriteBool = net.WriteBool
local net_WriteString = net.WriteString

local util_SHA256 = util.SHA256
local util_Compress = util.Compress
local util_Decompress = util.Decompress
local table_concat = table.concat
local table_insert = table.insert

local SFS = include("external/sh_sfs.lua")

local Atlas = {
    Ports = { },

    Cache = { }
}

MODE_FAILED = -2

MODE_NONE = -1
MODE_ALL  = 0

MODE_PARSING  = 1
MODE_DONE     = 2

function Atlas:Call(Function, Meta, ...)
    if not Function then 
        return
    end

    if Meta then 
        Function(Meta, ...)
    else
        Function(...)
    end
end

function Atlas:Listen(Port, Identifier, Mode, Callback, Meta)
    Mode = Mode or MODE_NONE
    
    self.Ports[Port] = self.Ports[Port] or { }

    self.Ports[Port][Identifier] = {
        Callback = Callback,
        Meta     = Meta,
        Mode     = Mode
    }
end

function Atlas:Close(Port, Identifier)
    if not self.Ports[Port] then 
        return
    end

    self.Ports[Port][Identifier] = nil
end

function Atlas:Pack(Data, alreadyPacked)
    alreadyPacked = alreadyPacked or { }

    local Type = TypeID(Data)

    -- Skip invalid types.
    if not Data or Type == TYPE_FUNCTION then 
        return 
    end

    -- Only tables and strings need compression.
    if Type ~= TYPE_TABLE and Type ~= TYPE_STRING then 
        return Data
    end

    -- Avoid infinite loops.
    if alreadyPacked[Data] then 
        return
    end

    -- Mark table as packed before recursion
    if Type == TYPE_TABLE then 
        alreadyPacked[Data] = true
    end

    -- Table compression.
    if Type == TYPE_TABLE then
        local Constructed = { }

        for k, subData in pairs(Data) do
            if alreadyPacked[subData] then
                continue
            end
            
            local Value = self:Pack(subData, alreadyPacked)

            if Value then
                Constructed[k] = {
                    Value = Value,
                    Type = TypeID(subData)
                }
            end
        end

        return util_Compress(SFS.encode(Constructed))
    end

	if #Data < 12000 then
		return Data
	end

    return util_Compress(Data)
end

function Atlas:Unpack(Data)
    -- Attempt decompression.
    local Decompressed = util_Decompress(Data)
    
    -- If decompression fails, return the original data (not compressed).
    if not Decompressed or Decompressed == "" then
        return Data
    end

    -- Try parsing SFS to check if it's a table.
    local Parsed, Failed = SFS.decode(Decompressed)
    
    -- If SFS parsing fails, return decompressed string.
    if Failed ~= nil then
        return Decompressed
    end

    -- Recursive unpacking for nested tables.
    local Constructed = { }

    for k, Data in pairs(Parsed) do
        if not Data.Value or not Data.Type then
            continue
        end

        if Data.Type == TYPE_STRING then
            Constructed[k] = tostring(self:Unpack(Data.Value))
        elseif Data.Type == TYPE_NUMBER then
            Constructed[k] = tonumber(self:Unpack(Data.Value))
        elseif Data.Type == TYPE_BOOL then
            Constructed[k] = self:Unpack(tostring(Data.Value)) == "true"
        else
            Constructed[k] = self:Unpack(Data.Value)
        end
    end

    return Constructed
end

function Atlas:Split(Data)
    local Split, Count = { }, 1

    for i = 1, #Data do
        local Character = Data[i]     

        Split[Count] = Split[Count] or { }
    
        if #Split[Count] > 12000 then 
            Count = Count + 1
            
            Split[Count] = { }
        end
        
        table_insert(Split[Count], Character)
    end

    return Split, Count
end

function Atlas:Read()
    local Data = { }

    Data.Chunk = net_ReadData(net_ReadUInt(16))
    
    Data.Index = net_ReadUInt(8)
    Data.Size  = net_ReadUInt(8)
    Data.Final = net_ReadBool()

    Data.Checksum = net_ReadString()
    Data.Port     = net_ReadString()

    return Data
end

function Atlas:Write(Chunk, Size, Checksum, Index, Port)
    net_WriteUInt(#Chunk, 16)
    net_WriteData(Chunk, #Chunk)
    
    net_WriteUInt(Index, 8)
    net_WriteUInt(Size, 8)

    net_WriteBool(Size == Index)

    net_WriteString(Checksum)
    net_WriteString(Port)
end

function Atlas:Send(Port, ...)
    local Data         = self:Pack({ ... })
    local Split, Count = self:Split(Data)

    local Checksum = util_SHA256(Data)
    local Size     = Count

    for i = 1, Size do 
        timer.Simple(i, function()
            net_Start("tac-networking")
                self:Write(table_concat(Split[i]), Size, Checksum, i, Port)
            net_SendToServer()
		end)
    end
end

function Atlas:Process(Callbacks, Stage, ...)
    for Identifier, Data in pairs(Callbacks) do 
        if Data.Mode == MODE_NONE then 
            continue
        end

        if Data.Mode ~= MODE_ALL and Data.Mode ~= Stage then 
            continue
        end

        self:Call(Data.Callback, Data.Meta, Stage, ...)
    end
end

function Atlas:Receive()
    local Data = self:Read()

    if not Data or not Data.Port then 
        return
    end

    local Callbacks = self.Ports[Data.Port]

    if not Callbacks then 
        return
    end

    local Index = self.Cache[Data.Port] or {
        Slot = 0
    }

    Index.Slot = Index.Slot + 1

    Index[Index.Slot] = Data.Chunk

    self:Process(Callbacks, MODE_PARSING, Data, Index)

    if Data.Final then 
        Index = table_concat(Index, "", 1, Index.Slot)

        if Data.Checksum == util_SHA256(Index) then 
            local Arguments = self:Unpack(Index)

            self:Process(Callbacks, MODE_DONE, unpack(Arguments))
        else
            self:Process(Callbacks, MODE_FAILED, Index)
        end

        Index = {
            Slot = 0
        }
    end

    self.Cache[Data.Port] = Index
end

net_Receive("tac-networking", function()
    Atlas:Receive()
end)

return Atlas