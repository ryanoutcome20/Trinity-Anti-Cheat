--[[--------------------------]]--
--[[ hLibrary - Better Hooks! ]]--
--[[--------------------------]]--

-- https://github.com/ryanoutcome20/hLib/tree/main

hLib = { 
	Cache = { },
	
	gameEvents = {
		achievement_earned = true,
		achievement_event = true,
		break_breakable = true,
		break_prop = true,
		client_beginconnect = true,
		client_connected = true,
		client_disconnect = true,
		entity_killed = true,
		flare_ignite_npc = true,
		freezecam_started = true,
		game_newmap = true,
		hide_freezepanel = true,
		hltv_cameraman = true,
		hltv_changed_mode = true,
		hltv_changed_target = true,
		hltv_chase = true,
		hltv_fixed = true,
		hltv_message = true,
		hltv_rank_camera = true,
		hltv_rank_entity = true,
		hltv_status = true,
		hltv_title = true,
		host_quit = true,
		OnRequestFullUpdate = true,
		player_activate = true,
		player_changename = true,
		player_connect = true,
		player_connect_client = true,
		player_disconnect = true,
		player_hurt = true,
		player_info = true,
		player_say = true,
		player_spawn = true,
		ragdoll_dissolved = true,
		server_addban = true,
		server_cvar = true,
		server_removeban = true,
		server_spawn = true,
		show_freezepanel = true,
		user_data_downloaded = true
	}
}

-- =============================================================================
-- Library Functionality.
-- =============================================================================

function hLib:Add(Event, ID, Callback, Meta, isLocked)
	if (not self.Cache[Event]) then
		self.Cache[Event] = { }
		
		if (self.gameEvents[Event]) then
			gameevent.Listen(Event)
		end
		
		hook.Add(Event, "hLib", function(...)
			local Result = hLib:Run(Event, ...)
			
			if (Result) then
				return unpack(Result, 2)
			end
		end)
	end
	
	local Exists, Data = self:Exists(Event, ID)
	
	if (Exists and Data.isLocked) then
		debug.Trace()
	
		return ErrorNoHalt("Attempted to register on a locked hook ID.\n")
	end
	
	table.insert(self.Cache[Event], {
		ID = ID,
		Callback = Callback,
		Meta = Meta,
		isLocked = isLocked
	})
end

function hLib:Remove(Event, ID)
	local Cache = self.Cache[Event]
	
	if (not Cache) then
		return false
	end
	
	for i = #Cache, 1, -1 do
		if (Cache[i].ID == ID) then
			table.remove(Cache, i)
			return true
		end
	end
		
	return false
end

function hLib:Exists(Event, ID)
	local Cache = self.Cache[Event]
	
	if (not Cache) then
		return false
	end
	
	for i = 1, #Cache do
		if (Cache[i].ID == ID) then
			return true, Cache[i]
		end
	end
		
	return false
end

function hLib:Run(Event, ...)
	local Cache = self.Cache[Event]
	
	if (not Cache) then
		return false
	end
	
	for i = 1, #Cache do
		local Status, Result = self:ProtectedCall(Cache[i].Callback, Cache[i].Meta, ...)
	
		if (Status and istable(Result) and Result[1] ~= nil) then
			return Result
		end
	end
	
	return false
end

function hLib:Call(Event, ...)
	return hook.Run(Event, ...)
end

function hLib:GetTable(Event)
	if (not Event) then
		return self.Cache
	end
	
	return self.Cache[Event]
end

function hLib:ProtectedCall(Callback, Meta, ...)
	local Status, Result = pcall(function(Callback, Meta, ...)
		if Meta then
			return { Callback(Meta, ...) }
		else
			return { Callback(...) }
		end
	end, Callback, Meta, ...)
	
	if (not Status) then
		ErrorNoHalt(Result)
	end

	return Status, Result
end