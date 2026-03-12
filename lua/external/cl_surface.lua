
// =============================================================================
// Library
// =============================================================================

local Surface = { }
local surface = surface
local math = math
local string = string
local table = table
local gui = gui

// =============================================================================
// Surface Library
// =============================================================================

local Material = Material
local Materials = { }

//-/~ GetTextSize
function Surface:GetTextSize( Font, String )
    surface.SetFont( Font )
    return surface.GetTextSize( String )
end

//-/~ DrawText
function Surface:DrawText( String, Font, x, y, Color )
    surface.SetTextColor( Color )
    surface.SetTextPos( x, y )
    surface.SetFont( Font )
    surface.DrawText( String )
end

//-/~ DrawTexturedRectRotated
function Surface:DrawTexturedRectRotated( Mat, Color, x, y, w, h, Rotation )
    if not Materials[ Mat ] then
        Materials[ Mat ] = Material( Mat, "noclamp smooth" )
    end

    surface.SetDrawColor( Color )
    surface.SetMaterial( Materials[ Mat ] )
    surface.DrawTexturedRectRotated( x, y, w, h, Rotation )
end

//-/~ DrawRect
function Surface:DrawRect( x, y, w, h, Color )
    surface.SetDrawColor( Color )
    surface.DrawRect( x, y, w, h )
end

// -/~ DrawLine
function Surface:DrawLine( x, y, x2, y2, Color )
    surface.SetDrawColor( Color )
    surface.DrawLine( x, y, x2, y2 )
end

//-/~ DrawOutlinedRect
function Surface:DrawOutlinedRect( x, y, w, h, Thick, Color )
    surface.SetDrawColor( Color )
    surface.DrawOutlinedRect( x, y, w, h, Thick )
end

//-/~ DrawRectRotated
local mat_white = Material( "vgui/white" )

function Surface:DrawRectRotated( x, y, w, h, col, ang )
    surface.SetMaterial( mat_white )
    surface.SetDrawColor( col )
    surface.DrawTexturedRectRotated( x, y, w, h, ang )
end

//-/~ DrawTexturedRect
function Surface:DrawTexturedRect( Mat, Color, x, y, w, h )
    if not Materials[ Mat ] then
        Materials[ Mat ] = Material( Mat )
    end

    surface.SetDrawColor( Color )
    surface.SetMaterial( Materials[ Mat ], "noclamp smooth" )
    surface.DrawTexturedRect( x, y, w, h )
end

// =============================================================================
// Fonts
// =============================================================================

Surface.FontCache = { }

local scale = 1

function Surface:Scale( Size )
    return math.floor( ( Size * scale ) + 0.5 )
end

function Surface:ScaleEven( Size )
    Size = self:Scale( Size )

    if Size % 2 ~= 0 then
        Size = Size + 1
    end

    return v
end

function Surface:CreateFont( name, font, size, weight )
    self.FontCache[ name ] = self.FontCache[ name ] or {
        font = font,
        size = size,
        weight = weight
    }

    surface.CreateFont( "vs." .. name, {
        font = font,
        size = ( ScrH( ) / 1080 ) * size,
        antialias = true,
        weight = weight
    } )
end

hook.Add( "OnScreenSizeChanged", "TAC.Interface", function( )
    for k, v in pairs( Surface.FontCache ) do
        Surface:CreateFont( k, v.font, v.size, v.weight )
    end
end )

-- for i = 14, 100 do
--     Surface:CreateFont( "ui." .. i, "Purista", i )
--     Surface:CreateFont( "uib." .. i, "Purista", i, 1024 )
-- end

return Surface