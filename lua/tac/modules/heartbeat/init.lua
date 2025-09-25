if SERVER then
    include("sv_heartbeat.lua")
    
    return {
        "cl_heartbeat.lua"
    }
end