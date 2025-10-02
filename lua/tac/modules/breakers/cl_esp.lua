local Breaker = GetRenderTarget("Breaker", 256, 256)

function TAC.Breakers.ESP()
	local Config = TAC.Config.ESP
	
	if not Config.Enabled then
		return
	end
	
	render.PushRenderTarget(Breaker)
		render.Clear(0, 0, 0, 255, true, true)
		render.RenderView({
			origin = Vector(0,0,0)
		})
	render.PopRenderTarget()
end

hook.Add("HUDPaint", "TAC.Breakers.ESP", TAC.Breakers.ESP)