
--- Derma includes ---

include("cl_frame.lua")

--- ssss ---

local Frame
concommand.Add( "tac_menu", function()
    if IsValid( Frame ) then
        Frame:Remove()
    end

    Frame = vgui.Create( "TAC.Frame" )
end )