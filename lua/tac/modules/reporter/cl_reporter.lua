local sensitivity = GetConVar("sensitivity")

function TAC.Reporter()
    TAC.OS = "Windows"

    if system.IsOSX() then
        TAC.OS = "OSX"
    elseif system.IsLinux() then
        TAC.OS = "Linux"
    end

    TAC.Sensitivity = sensitivity:GetFloat()
    TAC.Resolution = {
        ScrW = ScrW(),
        ScrH = ScrH()
    }

    TAC.Atlas:Send(
        "Reporter",
        TAC.OS,
        TAC.Sensitivity,
        TAC.Resolution
    )
end

TAC.Reporter()

cvars.AddChangeCallback("sensitivity", TAC.Reporter)