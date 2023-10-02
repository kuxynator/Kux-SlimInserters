require("mod")
require("lib/Entity")
require("modules/Utils")
require("modules/PickerDollies")
local InserterConfiguration=require("modules/InserterConfiguration") --[[@as InserterConfiguration]]
require("modules/InserterGui")
require("lib/InserterEntity")

---@class Control
local this = {}

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
		local relPick = InserterEntity.get_relative_pickup_position(entity)
		local relDrop = InserterEntity.get_relative_drop_position(entity)
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
end

function this.on_configuration_changed(evt)
	Utils.reload_recipes("on_configuration_changed")
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

function this.on_runtime_mod_setting_changed(e)
	if(e.setting=="Kux-SlimInserters_runtime-debug-mode") then this.on_debug_mode_changed() end
end

Events.on_init(this.on_init)
Events.on_load(this.on_load)
Events.on_loaded(this.on_loaded)
Events.on_configuration_changed(this.on_configuration_changed)
Events.on_event(defines.events.on_selected_entity_changed, this.on_selected_entity_changed)
Events.on_event(defines.events.on_runtime_mod_setting_changed, this.on_runtime_mod_setting_changed)

-- game.players[1].print(serpent.block {})
-- game.players[1].print("hoi")
