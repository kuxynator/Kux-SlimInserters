require("mod")
require("lib.Entity")
require("modules.Utils")
require("modules.PickerDollies")
local InserterConfiguration=require("modules.InserterConfiguration") --[[@as InserterConfiguration]]

local this = {}

function this.get_relative_pickup_position(entity) --HACK
	return {
		x = entity.pickup_position.x - entity.position.x,
		y = entity.pickup_position.y - entity.position.y
	}
end

function this.get_relative_drop_position(entity) --HACK
	return {
		x = entity.drop_position.x - entity.position.x,
		y = entity.drop_position.y - entity.position.y
	}
end

function this.fix_positions(entity)
	local look = (entity.orientation * 4)
	local pOffset = 0.34765625
	local dOffset = 0.5
	if entity.prototype.inserter_drop_position[2] == 1.35 then
		pOffset = 1.34765625
		dOffset = 1.5
	end
	if look == 0 then
		entity.drop_position = { entity.position.x, entity.position.y + pOffset }
		entity.pickup_position = { entity.position.x, entity.position.y - dOffset }
	end
	if look == 1 then
		entity.drop_position = { entity.position.x - pOffset, entity.position.y }
		entity.pickup_position = { entity.position.x + dOffset, entity.position.y }
	end
	if look == 2 then
		entity.drop_position = { entity.position.x, entity.position.y - pOffset }
		entity.pickup_position = { entity.position.x, entity.position.y + dOffset }
	end
	if look == 3 then
		entity.drop_position = { entity.position.x + pOffset, entity.position.y }
		entity.pickup_position = { entity.position.x - dOffset, entity.position.y }
	end
end

function this.check_positions(entity)
	if(game.active_mods["bobinserters"] or game.active_mods["Smart_Inserters"]) then --HACK:
		-- I do not think we need to check this
		local relPick = this.get_relative_pickup_position(entity)
		local relDrop = this.get_relative_drop_position(entity)
		--print("check_positions {"..relPick.x..", "..relPick.y.."} -> {"..relDrop.x..", "..relDrop.y.."}")
		--print("check_positions {"..relPick.x..", "..relPick.y.."} -> {"..relDrop.x..", "..relDrop.y.."}")

	else
		local xCheck = math.abs(entity.drop_position.x - entity.pickup_position.x)
		local yCheck = math.abs(entity.drop_position.y - entity.pickup_position.y)
		if (((entity.orientation * 4) % 2 == 1 and xCheck ~= 0.84765625 and xCheck ~= 2.84765625)
				or ((entity.orientation * 4) % 2 == 0 and yCheck ~= 0.84765625 and yCheck ~= 2.84765625))
				and entity.active
		then
			this.fix_positions(entity)
		end
	end
end

require("events/on_built_entity")
require("events/on_destroyed_entity")
require("events/on_player_rotated_entity")

function this.on_init()
	this.on_debug_mode_changed("on_init")
	PickerDollies.init()
	global.events = {}
end

function this.on_debug_mode_changed(event_name)
	local isLoading=event_name=="on_init" or event_name=="on_load"
	local isDebugMode = settings.global["Kux-SlimInserters_runtime-debug-mode"].value
	if(isLoading and isDebugMode ) then
		print("Enable console output for Kux-SlimInserters")
	elseif(isDebugMode and _G.print_original) then
		_G.print = _G.print_original
		_G.print_original = nil
		print("Enable console output for Kux-SlimInserters")
	elseif(not isDebugMode and not _G.print_original) then
		print("Disable console output for Kux-SlimInserters")
		_G.print_original = _G.print
		_G.print = function() end
	end
end

function this.on_load()
	this.on_debug_mode_changed("on_load")
	PickerDollies.init()

	local g_events = global.events or {}
	if(g_events.on_nth_tick_1) then script.on_nth_tick(1, this.on_nth_tick_1) end
	for key, value in pairs(global.events or {}) do
		if(type(value)=="table") then
			script.on_event(value[1], value[2])
		elseif(type(value)=="string" or type(value)=="number") then
			if(type(this[value])=="function") then
				script.on_event(key, this[value])
			else
				local dummy = function() end
				script.on_event(key, dummy)
			end
		end
	end
end

function this.on_configuration_changed(evt)
	Utils.reload_recipes("on_configuration_changed")
	global.events = global.events or {}

	if(settings.startup[mod.prefix.."debug-mode"].value and not global.events.on_nth_tick_1) then
		script.on_nth_tick(1, this.on_nth_tick_1)
		global.events.on_nth_tick_1 = true
	elseif(not settings.startup[mod.prefix.."debug-mode"].value and global.events.on_nth_tick_1) then
		script.on_nth_tick(1, nil)
		global.events.on_nth_tick_1 = nil
	end
end

function this.on_nth_tick_1(evt)
	local g_events = global.events or {}
	g_events.on_nth_tick_1 = nil
	script.on_nth_tick(1, nil)
	this.on_loaded()
end

function this.on_loaded()
	Utils.reload_recipes()
end

function this.on_selected_entity_changed(evt)
	local entity = evt.last_entity
	if entity and entity.type == "inserter" and string.match(entity.name, "%-slim%-inserter") then
		this.check_positions(entity)
	end
end

function Qp(v)
	if(v<-0.25) then return -Qp(-v) end

	if(v>3.25 -0.5-0.1) then return 3.0 + 0.2 end
	if(v>=3.0 -0.5-0.1) then return 3.0 end
	if(v>=2.75-0.5-0.1) then return 3.0 - 0.2 end

	if(v>2.25 -0.5-0.1) then return 2.0 + 0.2 end
	if(v>=2.0 -0.5-0.1) then return 2.0 end
	if(v>=1.75-0.5-0.1) then return 2.0 - 0.2 end

	if(v>1.25 -0.5-0.1) then return 1.0 + 0.2 end
	if(v>=1.0 -0.5-0.1) then return 1.0 end
	if(v>=0.75-0.5-0.1) then return 1.0 - 0.2 end

	return v
end

local _relPick, _relDrop
function this.on_gui_opened(evt)
	local entity = evt.entity
	if entity and entity.type == "inserter" and string.match(entity.name, "%-slim%-inserter$") then
		local entity = evt.entity
		_relPick = this.get_relative_pickup_position(entity)
		_relDrop = this.get_relative_drop_position(entity)

		-- local p = this.get_relative_pickup_position(entity)
		-- local x,y = p.x, p.y
		-- x=Qp(x); y=Qp(y)
		-- entity.pickup_position = { entity.position.x + x, entity.position.y + y }
		-- local d = this.get_relative_drop_position(entity)
		-- x,y = d.x, d.y
		-- x=Qp(x); y=Qp(y)
		-- entity.drop_position = { entity.position.x + x, entity.position.y + y }

		--entity.operable = false
	end
end

function Q(v)
	if(v<-0.25) then return -Q(-v) end

	if(v>3.25 ) then return 2.5 + 0.2 end
	if(v>=3.0 ) then return 2.5 end
	if(v>=2.75) then return 2.5 - 0.2 end

	if(v>2.25 ) then return 1.5 + 0.2 end
	if(v>=2.0 ) then return 1.5 end
	if(v>=1.75) then return 1.5 - 0.2 end

	if(v>1.25 ) then return 0.5 + 0.2 end
	if(v>=1.0 ) then return 0.5 end
	if(v>=0.75) then return 0.5 - 0.2 end

	return v
end

function get_directional_position(x,y)
	x = math.abs(x)
	y = math.abs(y)
	return math.max(x,y), math.min(x,y)
end

function this.on_gui_closed(evt)
	local entity = evt.entity
	if not entity or entity.type ~= "inserter" or not string.match(entity.name, "%-slim%-inserter") then return end
	if(not InserterConfiguration.is_workaround_required()) then return end
	--- NOTE: _relDrop, _relPick could be nil, if the game was loaded while the UI was open.
	if(not _relDrop or not _relPick) then return end

	-- HACK: temporary workaround for bobinserters 1.1.7 and other configuration mods

	local p = this.get_relative_pickup_position(entity)
	local d = this.get_relative_drop_position(entity)
	local look = (entity.orientation * 4 )
	print("on_gui_closed: {"..p.x..", "..p.y.."} => {"..d.x..", "..d.y.."} look="..look)

	local x,y = d.x, d.y

	if(_relDrop.x ~= x or _relDrop.y ~= y) then
		x=Q(x); y=Q(y)
		-- local a,b = get_directional_position(x,y)
		-- if    (look==0) then x= b; y= a
		-- elseif(look==1) then x=-a; y= b
		-- elseif(look==2) then x= b; y=-a
		-- else                 x= a; y= b end
		entity.drop_position = { entity.position.x + x, entity.position.y + y }
	end

	x,y = p.x, p.y
	if(_relPick.x ~= x or _relPick.y ~= y) then
		x=Q(x); y=Q(y)
		local a = get_directional_position(x,y)
		if    (look==0) then x= 0; y=-a
		elseif(look==1) then x= a; y= 0
		elseif(look==2) then x= 0; y= a
		else                 x=-a; y= 0 end
		entity.pickup_position = { entity.position.x + x, entity.position.y + y }
	end
end

function this.on_runtime_mod_setting_changed(e)
	if(e.setting=="Kux-SlimInserters_runtime-debug-mode") then this.on_debug_mode_changed() end
end

script.on_init(this.on_init)
script.on_load(this.on_load)
script.on_configuration_changed(this.on_configuration_changed)
script.on_event(defines.events.on_gui_opened, this.on_gui_opened)
script.on_event(defines.events.on_gui_closed, this.on_gui_closed)
script.on_event(defines.events.on_selected_entity_changed, this.on_selected_entity_changed)
script.on_event(defines.events.on_runtime_mod_setting_changed, this.on_runtime_mod_setting_changed)

-- game.players[1].print(serpent.block {})
-- game.players[1].print("hoi")
