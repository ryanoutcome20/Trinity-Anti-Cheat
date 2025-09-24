return {
    -- Global.
    {Name = "PreFrameStageNotify", Type = "Global"},
    {Name = "PostFrameStageNotify", Type = "Global"},
    {Name = "DrawModelExecute", Type = "Global"},
    {Name = "RunOnClient", Type = "Global"},
    {Name = "RunOnMenu", Type = "Global"},

    -- proxi.
    {Name = "CreateMoveEx", Type = "proxi"},

    -- zxcmodule.
    {Name = "PreCreateMove", Type = "zxcmodule"},
    {Name = "PostCreateMove", Type = "zxcmodule"},
    {Name = "ShouldUpdateAnimation", Type = "zxcmodule"},
    {Name = "EndSceneOverlay", Type = "zxcmodule"},
    {Name = "SendNetMsg", Type = "zxcmodule"},
    {Name = "OnImpact", Type = "zxcmodule"},
    {Name = "ViewRenderDraw", Type = "zxcmodule"},
    {Name = "RunStringEx", Type = "zxcmodule"}
}