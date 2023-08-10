Entity = {}
--[[
name                           [R]	:: string	Name of the entity prototype.
type                           [R]	:: string	The entity prototype type of this entity.
prototype                      [R]	:: LuaEntityPrototype	The entity prototype of this entity.
localised_name                 [R]	:: LocalisedString	Localised name of the entity.
localised_description          [R]	:: LocalisedString	
active                        [RW]	:: boolean	Deactivating an entity will stop all its operations (car will stop moving, inserters will stop working, fish will stop moving etc).
destructible                  [RW]	:: boolean	If set to false, this entity can't be damaged and won't be attacked automatically.
minable                       [RW]	:: boolean	
rotatable                     [RW]	:: boolean	When entity is not to be rotatable (inserter, transport belt etc), it can't be rotated by player using the R key.
operable                      [RW]	:: boolean	Player can't open gui of this entity and he can't quick insert/input stuff in to the entity when it is not operable.
health                        [RW]	:: float?	The current health of the entity, if any.
direction                     [RW]	:: defines.direction	The current direction this entity is facing.
supports_direction             [R]	:: boolean	Whether the entity has direction.
orientation                   [RW]	:: RealOrientation	The smooth orientation of this entity.
energy                        [RW]	:: double	Energy stored in the entity (heat in furnace, energy stored in electrical devices etc.).
tile_width                     [R]	:: uint	Specifies the tiling size of the entity, is used to decide, if the center should be in the center of the tile (odd tile size dimension) or on the tile border (even tile size dimension).
tile_height                    [R]	:: uint	Specifies the tiling size of the entity, is used to decide, if the center should be in the center of the tile (odd tile size dimension) or on the tile border (even tile size dimension).
valid                          [R]	:: boolean	Is this object valid?
object_name                    [R]	:: string	The class name of this object.
tags                          [RW]	:: Tags?	The tags associated with this entity ghost.
backer_name                   [RW]	:: string?	The backer name assigned to this entity.
stickers                       [R]	:: array[LuaEntity]?	The sticker entities attached to this entity, if any.
sticked_to                     [R]	:: LuaEntity	The entity this sticker is sticked to.
status                         [R]	:: defines.entity_status?	The status of this entity, if any.

  -- entity-ghost --
ghost_name                     [R]	:: string	Name of the entity or tile contained in this ghost
ghost_localised_name           [R]	:: LocalisedString	Localised name of the entity or tile contained in this ghost.
ghost_localised_description    [R]	:: LocalisedString	
ghost_type                     [R]	:: string	The prototype type of the entity or tile contained in this ghost.
ghost_prototype                [R]	:: LuaEntityPrototype or LuaTilePrototype	The prototype of the entity or tile contained in this ghost.

  -- inserter --
drop_position                 [RW]	:: MapPosition	Position where the entity puts its stuff.
pickup_position               [RW]	:: MapPosition	Where the inserter will pick up items from.
drop_target                   [RW]	:: LuaEntity?	The entity this entity is putting its items to.
pickup_target                 [RW]	:: LuaEntity?	The entity this inserter will attempt to pick up items from.
held_stack                     [R]	:: LuaItemStack	The item stack currently held in an inserter's hand.
held_stack_position            [R]	:: MapPosition	Current position of the inserter's "hand".
filter_slot_count              [R]	:: uint	The number of filter slots this inserter, loader, or logistic storage container has.
inserter_target_pickup_count   [R]	:: uint	Returns the current target pickup count of the inserter.
inserter_stack_size_override  [RW]	:: uint	Sets the stack size limit on this inserter.
inserter_filter_mode          [RW]	:: string?	The filter mode for this filter inserter.

cliff_orientation              [R]	:: CliffOrientation	The orientation of this cliff.
relative_turret_orientation   [RW]	:: RealOrientation?	The relative orientation of the vehicle turret, artillery turret, artillery wagon.
torso_orientation             [RW]	:: RealOrientation	The torso orientation of this spider vehicle.
amount                        [RW]	:: uint	Count of resource units contained.
initial_amount                [RW]	:: uint?	Count of initial resource units contained.
effectivity_modifier          [RW]	:: float	Multiplies the acceleration the vehicle can create for one unit of energy.
consumption_modifier          [RW]	:: float	Multiplies the energy consumption.
friction_modifier             [RW]	:: float	Multiplies the car friction rate.
driver_is_gunner              [RW]	:: boolean?	Whether the driver of this car or spidertron is the gunner.
vehicle_automatic_targeting_parameters[RW]	:: VehicleAutomaticTargetingParameters	Read when this spidertron auto-targets enemies
speed                         [RW]	:: float?	The current speed if this is a car, rolling stock, projectile or spidertron, or the maximum speed if this is a unit.
effective_speed                [R]	:: float?	The current speed of this unit in tiles per tick, taking into account any walking speed modifier given by the tile the unit is standing on.
stack                          [R]	:: LuaItemStack	
selected_gun_index            [RW]	:: uint?	Index of the currently selected weapon slot of this character, car, or spidertron.
temperature                   [RW]	:: double?	The temperature of this entity's heat energy source.
previous_recipe                [R]	:: LuaRecipe?	The previous recipe this furnace was using, if any.
train                          [R]	:: LuaTrain?	The train this rolling stock belongs to, if any.
neighbours                     [R]	:: dictionary[string → array[LuaEntity] ] or array[array[LuaEntity] ] or LuaEntity	A list of neighbours for certain types of entities.
belt_neighbours                [R]	:: dictionary[string → array[LuaEntity] ]	The belt connectable neighbours of this belt connectable entity.
fluidbox                      [RW]	:: LuaFluidBox	Fluidboxes of this entity.
entity_label                  [RW]	:: string?	The label on this spider-vehicle entity, if any.
time_to_live                  [RW]	:: uint	The ticks left before a ghost, combat robot, highlight box or smoke with trigger is destroyed.
color                         [RW]	:: Color?	The color of this character, rolling stock, train stop, car, spider-vehicle, flying text, corpse or simple-entity-with-owner.
text                          [RW]	:: LocalisedString	The text of this flying-text entity.
signal_state                   [R]	:: defines.signal_state         The state of this rail signal.
chain_signal_state             [R]	:: defines.chain_signal_state   The state of this chain signal.
to_be_looted                  [RW]	:: boolean	                    Will this entity be picked up automatically when the player walks over it?
crafting_speed                 [R]	:: double                       The current crafting speed, including speed bonuses from modules and beacons.
crafting_progress             [RW]	:: float                        The current crafting progress, as a number in range [0, 1].
bonus_progress                [RW]	:: double                       The current productivity bonus progress, as a number in range [0, 1].
productivity_bonus             [R]	:: double                       The productivity bonus of this entity.
pollution_bonus                [R]	:: double                       The pollution bonus of this entity.
speed_bonus                    [R]	:: double                       The speed bonus of this entity.
consumption_bonus              [R]	:: double                       The consumption bonus of this entity.
belt_to_ground_type            [R]	:: "input" or "output"	Whether this underground belt goes into or out of the ground.
loader_type                   [RW]	:: "input" or "output"	Whether this loader gets items from or puts item into a container.
rocket_parts                  [RW]	:: uint	Number of rocket parts in the silo.
logistic_network              [RW]	:: LuaLogisticNetwork	The logistic network this entity is a part of, or nil if this entity is not a part of any logistic network.
logistic_cell                  [R]	:: LuaLogisticCell	The logistic cell this entity is a part of.
item_requests                 [RW]	:: dictionary[string → uint]	Items this ghost will request when revived or items this item request proxy is requesting.
player                         [R]	:: LuaPlayer?	The player connected to this character, if any.
unit_group                     [R]	:: LuaUnitGroup?	The unit group this unit is a member of, if any.
damage_dealt                  [RW]	:: double	The damage dealt by this turret, artillery turret, or artillery wagon.
kills                         [RW]	:: uint	The number of units killed by this turret, artillery turret, or artillery wagon.
last_user                     [RW]	:: LuaPlayer or PlayerIdentification?	The last player that changed any setting on this entity.
electric_buffer_size          [RW]	:: double?	The buffer size for the electric energy source.
electric_input_flow_limit      [R]	:: double?	The input flow limit for the electric energy source.
electric_output_flow_limit     [R]	:: double?	The output flow limit for the electric energy source.
electric_drain                 [R]	:: double?	The electric drain for the electric energy source.
electric_emissions             [R]	:: double?	The emissions for the electric energy source.
unit_number                    [R]	:: uint?	A unique number identifying this entity for the lifetime of the save.
ghost_unit_number              [R]	:: uint?	The unit_number of the entity contained in this ghost.
mining_progress               [RW]	:: double?	The mining progress for this mining drill.
bonus_mining_progress         [RW]	:: double?	The bonus mining progress for this mining drill.
power_production              [RW]	:: double	The power production specific to the ElectricEnergyInterface entity type.
power_usage                   [RW]	:: double	The power usage specific to the ElectricEnergyInterface entity type.
bounding_box                   [R]	:: BoundingBox	LuaEntityPrototype::collision_box around entity's given position and respecting the current entity orientation.
secondary_bounding_box         [R]	:: BoundingBox?	The secondary bounding box of this entity or nil if it doesn't have one.
selection_box                  [R]	:: BoundingBox	LuaEntityPrototype::selection_box around entity's given position and respecting the current entity orientation.
secondary_selection_box        [R]	:: BoundingBox?	The secondary selection box of this entity or nil if it doesn't have one.
mining_target                  [R]	:: LuaEntity?	The mining target, if any.
circuit_connected_entities     [R]	:: table?	Entities that are directly connected to this entity via the circuit network.
circuit_connection_definitions [R]	:: array[CircuitConnectionDefinition]?	The connection definition for entities that are directly connected to this entity via the circuit network.
request_slot_count             [R]	:: uint	The index of the configured request with the highest index for this entity.
loader_container               [R]	:: LuaEntity?	The container entity this loader is pointing at/pulling from depending on the LuaEntity::loader_type, if any.
grid                           [R]	:: LuaEquipmentGrid?	This entity's equipment grid, if any.
graphics_variation            [RW]	:: uint8?	The graphics variation for this entity.
tree_color_index              [RW]	:: uint8	Index of the tree color.
tree_color_index_max           [R]	:: uint8	Maximum index of the tree colors.
tree_stage_index              [RW]	:: uint8	Index of the tree stage.
tree_stage_index_max           [R]	:: uint8	Maximum index of the tree stages.
tree_gray_stage_index         [RW]	:: uint8	Index of the tree gray stage
tree_gray_stage_index_max      [R]	:: uint8	Maximum index of the tree gray stages.
burner                         [R]	:: LuaBurner?	The burner energy source for this entity, if any.
shooting_target               [RW]	:: LuaEntity?	The shooting target for this turret, if any.
proxy_target                   [R]	:: LuaEntity?	The target entity for this item-request-proxy, if any.
parameters                    [RW]	:: ProgrammableSpeakerParameters	
alert_parameters              [RW]	:: ProgrammableSpeakerAlertParameters	
electric_network_statistics    [R]	:: LuaFlowStatistics	The electric network statistics for this electric pole.
products_finished             [RW]	:: uint	The number of products this machine finished crafting in its lifetime.
spawner                        [R]	:: LuaEntity?	The spawner associated with this unit entity, if any.
units                          [R]	:: array[LuaEntity]	The units associated with this spawner entity.
power_switch_state            [RW]	:: boolean	The state of this power switch.
effects                        [R]	:: ModuleEffects?	The effects being applied to this entity, if any.
beacons_count                  [R]	:: uint?	Number of beacons affecting this effect receiver.
infinity_container_filters    [RW]	:: array[InfinityInventoryFilter]	The filters for this infinity container.
remove_unfiltered_items       [RW]	:: boolean	Whether items not included in this infinity container filters should be removed from the container.
character_corpse_player_index [RW]	:: uint	The player index associated with this character corpse.
character_corpse_tick_of_death[RW]	:: uint	The tick this character corpse died at.
character_corpse_death_cause  [RW]	:: LocalisedString	The reason this character corpse character died.
associated_player             [RW]	:: LuaPlayer or PlayerIdentification?	The player this character is associated with, if any.
tick_of_last_attack           [RW]	:: uint	The last tick this character entity was attacked.
tick_of_last_damage           [RW]	:: uint	The last tick this character entity was damaged.
splitter_filter               [RW]	:: LuaItemPrototype?	The filter for this splitter, if any is set.
splitter_input_priority       [RW]	:: string	The input priority for this splitter.
splitter_output_priority      [RW]	:: string	The output priority for this splitter.
armed                          [R]	:: boolean	Whether this land mine is armed.
recipe_locked                 [RW]	:: boolean	When locked; the recipe in this assembling machine can't be changed by the player.
connected_rail                 [R]	:: LuaEntity?	The rail entity this train stop is connected to, if any.
connected_rail_direction       [R]	:: defines.rail_direction	Rail direction to which this train stop is binding.
trains_in_block                [R]	:: uint	The number of trains in this rail block for this rail entity.
timeout                       [RW]	:: uint	The timeout that's left on this landmine in ticks.
neighbour_bonus                [R]	:: double	The current total neighbour bonus of this reactor.
ai_settings                    [R]	:: LuaAISettings	The ai settings of this unit.
highlight_box_type            [RW]	:: string	The hightlight box type of this highlight box entity.
highlight_box_blink_interval  [RW]	:: uint	The blink interval of this highlight box entity.
enable_logistics_while_moving [RW]	:: boolean	Whether equipment grid logistics are enabled while this vehicle is moving.
render_player                 [RW]	:: LuaPlayer or PlayerIdentification?	The player that this simple-entity-with-owner, simple-entity-with-force, flying-text, or highlight-box is visible to.
render_to_forces              [RW]	:: array[ForceIdentification]?	The forces that this simple-entity-with-owner, simple-entity-with-force, or flying-text is visible to.
pump_rail_target               [R]	:: LuaEntity?	The rail target of this pump, if any.
moving                         [R]	:: boolean	Returns true if this unit is moving.
electric_network_id            [R]	:: uint?	Returns the id of the electric network that this entity is connected to, if any.
allow_dispatching_robots      [RW]	:: boolean	Whether this character's personal roboports are allowed to dispatch robots.
auto_launch                   [RW]	:: boolean	Whether this rocket silo automatically launches the rocket when cargo is inserted.
energy_generated_last_tic     k[R]	:: double	How much energy this generator generated in the last tick.
storage_filter                [RW]	:: LuaItemPrototype?	The storage filter for this logistic storage container.
request_from_buffers          [RW]	:: boolean	Whether this requester chest is set to also request from buffer chests.
corpse_expires                [RW]	:: boolean	Whether this corpse will ever fade away.
corpse_immune_to_entity_placement[RW]	:: boolean	If true, corpse won't be destroyed when entities are placed over it.
command                        [R]	:: Command?	The command given to this unit, if any.
distraction_command            [R]	:: Command?	The distraction command given to this unit, if any.
time_to_next_effect           [RW]	:: uint	The ticks until the next trigger effect of this smoke-with-trigger.
autopilot_destination         [RW]	:: MapPosition?	Destination of this spidertron's autopilot, if any.
autopilot_destinations         [R]	:: array[MapPosition]	The queued destination positions of spidertron's autopilot.
trains_count                   [R]	:: uint	Amount of trains related to this particular train stop.
trains_limit                  [RW]	:: uint	Amount of trains above which no new trains will be sent to this train stop.
is_entity_with_force           [R]	:: boolean	(deprecated by 1.1.51) If this entity is a MilitaryTarget.
is_military_target            [RW]	:: boolean	Whether this entity is a MilitaryTarget.
is_entity_with_owner           [R]	:: boolean	If this entity is EntityWithOwner
is_entity_with_health          [R]	:: boolean	If this entity is EntityWithHealth
combat_robot_owner            [RW]	:: LuaEntity?	The owner of this combat robot, if any.
link_id                       [RW]	:: uint	The link ID this linked container is using.
follow_target                 [RW]	:: LuaEntity?	The follow target of this spidertron, if any.
follow_offset                 [RW]	:: Vector?	The follow offset of this spidertron, if any entity is being followed.
linked_belt_type              [RW]	:: string	Type of linked belt: it is either "input" or "output".
linked_belt_neighbour          [R]	:: LuaEntity?	Neighbour to which this linked belt is connected to, if any.
radar_scan_progress            [R]	:: float	The current radar scan progress, as a number in range [0, 1].
rocket_silo_status             [R]	:: defines.rocket_silo_status	The status of this rocket silo entity.
]]
local entity_properties = {
	"name",
"type",
"prototype",
"localised_name",
"localised_description",
"active",
"destructible",
"minable",
"rotatable",
"operable",
"health",
"direction",
"supports_direction",
"orientation",
"energy",
"tile_width",
"tile_height",
"valid",
"object_name",
"tags",
"backer_name",
"stickers",
"sticked_to",
"status",

--"--entity-ghost--",
"ghost_name",
"ghost_localised_name",
"ghost_localised_description",
"ghost_type",
"ghost_prototype",

--"--inserter--",
"drop_position",
"pickup_position",
"drop_target",
"pickup_target",
"held_stack",
"held_stack_position",
"filter_slot_count",
"inserter_target_pickup_count",
"inserter_stack_size_override",
"inserter_filter_mode",

"cliff_orientation",
"relative_turret_orientation",
"torso_orientation",
"amount",
"initial_amount",
"effectivity_modifier",
"consumption_modifier",
"friction_modifier",
"driver_is_gunner",
"vehicle_automatic_targeting_parameters",
"speed",
"effective_speed",
"stack",
"selected_gun_index",
"temperature",
"previous_recipe",
"train",
"neighbours",
"belt_neighbours",
"fluidbox",
"entity_label",
"time_to_live",
"color",
"text",
"signal_state",
"chain_signal_state",
"to_be_looted",
"crafting_speed",
"crafting_progress",
"bonus_progress",
"productivity_bonus",
"pollution_bonus",
"speed_bonus",
"consumption_bonus",
"belt_to_ground_type",
"loader_type",
"rocket_parts",
"logistic_network",
"logistic_cell",
"item_requests",
"player",
"unit_group",
"damage_dealt",
"kills",
"last_user",
"electric_buffer_size",
"electric_input_flow_limit",
"electric_output_flow_limit",
"electric_drain",
"electric_emissions",
"unit_number",
"ghost_unit_number",
"mining_progress",
"bonus_mining_progress",
"power_production",
"power_usage",
"bounding_box",
"secondary_bounding_box",
"selection_box",
"secondary_selection_box",
"mining_target",
"circuit_connected_entities",
"circuit_connection_definitions",
"request_slot_count",
"loader_container",
"grid",
"graphics_variation",
"tree_color_index",
"tree_color_index_max",
"tree_stage_index",
"tree_stage_index_max",
"tree_gray_stage_index",
"tree_gray_stage_index_max",
"burner",
"shooting_target",
"proxy_target",
"parameters",
"alert_parameters",
"electric_network_statistics",
"products_finished",
"spawner",
"units",
"power_switch_state",
"effects",
"beacons_count",
"infinity_container_filters",
"remove_unfiltered_items",
"character_corpse_player_index",
"character_corpse_tick_of_death",
"character_corpse_death_cause",
"associated_player",
"tick_of_last_attack",
"tick_of_last_damage",
"splitter_filter",
"splitter_input_priority",
"splitter_output_priority",
"armed",
"recipe_locked",
"connected_rail",
"connected_rail_direction",
"trains_in_block",
"timeout",
"neighbour_bonus",
"ai_settings",
"highlight_box_type",
"highlight_box_blink_interval",
"enable_logistics_while_moving",
"render_player",
"render_to_forces",
"pump_rail_target",
"moving",
"electric_network_id",
"allow_dispatching_robots",
"auto_launch",
"energy_generated_last_tick",
"storage_filter",
"request_from_buffers",
"corpse_expires",
"corpse_immune_to_entity_placement",
"command",
"distraction_command",
"time_to_next_effect",
"autopilot_destination",
"autopilot_destinations",
"trains_count",
"trains_limit",
"is_entity_with_force",
"is_military_target",
"is_entity_with_owner",
"is_entity_with_health",
"combat_robot_owner",
"link_id",
"follow_target",
"follow_offset",
"linked_belt_type",
"linked_belt_neighbour",
"radar_scan_progress",
"rocket_silo_status"
}

local LuaControl = {}
LuaControl.property_names = {
"surface",
"surface_index",
"position",
"vehicle",
"force",
"force_index",
"selected",
"opened",
"crafting_queue_size",
"crafting_queue_progress",
"walking_state",
"riding_state",
"mining_state",
"shooting_state",
"picking_state",
"repair_state",
"cursor_stack",
"cursor_ghost",
"driving",
"crafting_queue",
"following_robots",
"cheat_mode",
"character_crafting_speed_modifier",
"character_mining_speed_modifier",
"character_additional_mining_categories",
"character_running_speed_modifier",
"character_build_distance_bonus",
"character_item_drop_distance_bonus",
"character_reach_distance_bonus",
"character_resource_reach_distance_bonus",
"character_item_pickup_distance_bonus",
"character_loot_pickup_distance_bonus",
"character_inventory_slots_bonus",
"character_trash_slot_count_bonus",
"character_maximum_following_robot_count_bonus",
"character_health_bonus",
"character_personal_logistic_requests_enabled",
"vehicle_logistic_requests_enabled",
"opened_gui_type",
"build_distance",
"drop_item_distance",
"reach_distance",
"item_pickup_distance",
"loot_pickup_distance",
"resource_reach_distance",
"in_combat",
"character_running_speed",
"character_mining_progress",
"get_inventory",
"get_max_inventory_index",
"get_main_inventory",
"can_insert",
"insert",
"set_gui_arrow",
"clear_gui_arrow",
"get_item_count",
"has_items_inside",
"can_reach_entity",
"clear_items_inside",
"remove_item",
"teleport",
"update_selected_entity",
"clear_selected_entity",
"disable_flashlight",
"enable_flashlight",
"is_flashlight_enabled",
"get_craftable_count",
"begin_crafting",
"cancel_crafting",
"mine_entity",
"mine_tile",
"is_player",
"open_technology_gui",
"set_personal_logistic_slot",
"set_vehicle_logistic_slot",
"get_personal_logistic_slot",
"get_vehicle_logistic_slot",
"clear_personal_logistic_slot",
"clear_vehicle_logistic_slot",
"is_cursor_blueprint",
"get_blueprint_entities",
"is_cursor_empty",
}
local property_names={}
for _,v in pairs(entity_properties) do table.insert(property_names,v) end
for _,v in pairs(LuaControl.property_names) do table.insert(property_names,v) end

function Entity.dump(entity)
	local t = {}
	for _, prop in pairs(entity_properties) do
		pcall(function()
			t[prop] = entity[prop]
			if(type(t[prop])=="function") then t[prop] = nil end
		end)
	end
	return serpent.block(t)
end

function Entity.accesstTest(entity)
	for _, value in pairs(entity_properties) do
		xpcall(function()
			local x=entity[value]-- read access test
			entity[value] = x -- write access test
			-- if x~=nil then
				-- print(value) -- read success AND not nil
			-- end
			print(value)
		end, function(err)
			--print("ERROR  "..value.." "..err)
		end)
	end
end

local function get_placeable(entity)
	local placeable = entity.prototype.items_to_place_this;
	if(placeable) then placeable = placeable[1] else placeable = {name=entity.name, count=1} end
	return placeable
end

---Deconstructs an entity and gives the item back to the player or robot or drop it on the ground
---@param entity LuaEntity The entity to deconstruct
---@param evt table? event parameter
---@param destroy_options LuaEntity.destroy_param? Options for the destruction
---@return boolean #Returns false if the entity was valid and destruction failed, true in all other cases.
function Entity.deconstruct(entity, evt, destroy_options)
	local name = entity.name
	local position = entity.position
	local item_stack = get_placeable(entity)
	local result = entity.destroy(destroy_options or {})
	if(not result) then
		print("  can not deconstruct");
		return false
	end

	-- drop item or back to inventory
	evt.position = position
	return Entity.give_back(item_stack, evt)
end

---Gives back an item stack to the player or robot or drop it on the ground
---@param item_stack ItemStackDefinition
---@param evt table? event parameter
---@return boolean
function Entity.give_back(item_stack, evt)
	if(evt and evt.robot) then
		local inventory = evt.robot.get_inventory(defines.inventory.robot_cargo)
		--TODO: check if robot has space
		inventory.insert({name = item_stack.name, count = 1})
		print("  + bot "..item_stack.name)
		return true
	elseif(evt and evt.player_index) then
		local player = game.players[evt.player_index]
		local inventory = player.get_main_inventory()
		if(inventory)then
			--TODO: check if player has space
			inventory.insert({name = item_stack.name, count = 1})
			print("  + player "..item_stack.name)
			return true
		end
	end
	--TODO: user player position, if evt.position is nil
	surface.spill_item_stack(evt.position, {name = item_stack.name, count = 1}, true)
	print("  + ground "..item_stack.name)
	--TODO: do not put on a belt
	return true
end

function Entity.copy_inserter_properties(template, entity)
	assert(template~=nil, "Argument must not be nil. Name: 'template'")
	assert(entity~=nil, "Argument must not be nil. Name: 'entity'")
	-- for _, property in ipairs(inserter_ghost_properties_to_copy) do
	-- 	new_entity[property] = old_entity[property]
	-- end
	entity.pickup_position = template.pickup_position
	entity.drop_position = template.drop_position
	entity.inserter_stack_size_override = template.inserter_stack_size_override
	if(template.filter_slot_count>0 and entity.filter_slot_count>0) then
		entity.inserter_filter_mode = template.inserter_filter_mode
		for i = 1, math.max(template.filter_slot_count, entity.filter_slot_count), 1 do
			entity.set_filter(i, template.get_filter(i))
		end
	end
end

return Entity
