
local PANEL = { }

local Surface = include("external/cl_surface.lua")
local CloseMat = Material("tac/close.png", "noclamp smooth")

function PANEL:Init()
    local w, h = Surface:Scale( 1100 ), Surface:Scale( 720 )

    self:SetSize( w, h )
    self:MakePopup()
    self:Center()
    self:SetAlpha( 0 )
    self:AlphaTo( 255, .12, .05 )

    self.navbar = vgui.Create( "Panel", self )
    self.navbar:Dock( TOP )
    self.navbar:SetTall( 35 )

    function self.navbar:Paint( w, h )
        Surface:DrawRect( 0, 0, w, h, Color( 25, 25, 25 ) )
        Surface:DrawRect( 0, h - 1, w, 1, Color( 55, 55, 55 ) )
    end

    self.holder = vgui.Create( "Panel", self )
    self.holder:Dock( TOP )
    self.holder:DockMargin( 0, 1, 0, 0 )
    self.holder:SetTall( 40 )
    self.holder.Paint = function(s,w,h)
        Surface:DrawRect( 0, 0, w, h, Color(255,0,0,5) )
    end

    self.populate = vgui.Create( "Panel", self )
    self.populate:Dock( FILL )
    self.populate:DockMargin( 10, 0, 10, 10 )
    self.populate.Paint = function(s,w,h)
        Surface:DrawRect( 0, 0, w, h, Color(0,255,0,2) )
    end

    self.title = vgui.Create( "DLabel", self.navbar )
    self.title:Dock( LEFT )
    self.title:DockMargin( 5, 0, 0, 0 )
    self.title:SetFont( "vs.ui.20" )
    self.title:SetText( "Trinity Anti-Cheat" )
    self.title:SetTextColor( color_white )
    self.title:SizeToContents()

    self.close = vgui.Create( "DButton", self.navbar )
    self.close:Dock( RIGHT )
    self.close:SetWide( self.navbar:GetTall() )
    self.close:SetText("")

    self.close.OnMousePressed = function() 
        self:Close() 
    end

    local Red = Color( 255, 26, 26 )

    function self.close:Paint( w, h )
        local size = h * .5
        local Hovered = self:IsHovered()
        local Frametime = FrameTime()

        self.fraction = math.Clamp( ( self.fraction or .5 ) + ( Hovered and Frametime * 6 or - Frametime * 3 ), 0, 1 )

        surface.SetMaterial( CloseMat )
        surface.SetDrawColor( color_white )
        surface.DrawTexturedRect( w / 2 - size / 2, h / 2 - size / 2, size, size )

        local i = math.Remap( self.fraction, .5, 1, 0, 1 )

        surface.SetMaterial( CloseMat )

        if i > 0 then
            surface.SetDrawColor( ColorAlpha( Red, Red.a * i ) )
        end

        surface.DrawTexturedRect( w / 2 - size / 2, h / 2 - size / 2, size, size )
    end
end

function PANEL:Paint( w, h )
    Surface:DrawRect( 0, 0, w, h, Color( 18, 18, 18 ) )
end

function PANEL:Close()
    self:AlphaTo( 0, .1, .1, function() self:Remove() end )
    self:SetMouseInputEnabled( false )
    self:SetKeyboardInputEnabled( false )
end

function PANEL:OnKeyCodePressed( key )
    if key == KEY_TAB then
        self:Close()
    end
end

vgui.Register( "TAC.Frame", PANEL, "Panel" )