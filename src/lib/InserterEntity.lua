---@class InserterEntity
InserterEntity = {}

local Table = KuxCoreLib.Table
local StringBuilder = KuxCoreLib.StringBuilder
local InserterControlBehavior = require("lib/InserterControlBehavior")


InserterEntity.members = {
	name = {canRead=true, canWrite=false, canCall=false},
type = {canRead=true, canWrite=false, canCall=false},
prototype = {canRead=true, canWrite=false, canCall=false, type="LuaEntityPrototype"},
localised_name = {canRead=true, canWrite=false, canCall=false},
localised_description = {canRead=true, canWrite=false, canCall=false},
active = {canRead=true, canWrite=true, canCall=false},
destructible = {canRead=true, canWrite=true, canCall=false},
minable = {canRead=true, canWrite=true, canCall=false},
rotatable = {canRead=true, canWrite=true, canCall=false},
operable = {canRead=true, canWrite=true, canCall=false},
health = {canRead=true, canWrite=true, canCall=false},
direction = {canRead=true, canWrite=true, canCall=false},
supports_direction = {canRead=true, canWrite=false, canCall=false},
orientation = {canRead=true, canWrite=true, canCall=false},
energy = {canRead=true, canWrite=true, canCall=false},
tile_width = {canRead=true, canWrite=false, canCall=false},
tile_height = {canRead=true, canWrite=false, canCall=false},
valid = {canRead=true, canWrite=false, canCall=false},
object_name = {canRead=true, canWrite=false, canCall=false},
tags = {canRead=true, canWrite=true, canCall=false},
backer_name = {canRead=true, canWrite=false, canCall=false},
stickers = {canRead=true, canWrite=false, canCall=false},
status = {canRead=true, canWrite=false, canCall=false},
drop_position = {canRead=true, canWrite=true, canCall=false},
pickup_position = {canRead=true, canWrite=true, canCall=false},
drop_target = {canRead=true, canWrite=true, canCall=false},
pickup_target = {canRead=true, canWrite=true, canCall=false},
held_stack = {canRead=true, canWrite=false, canCall=false, type="LuaItemStack"},
held_stack_position = {canRead=true, canWrite=false, canCall=false},
filter_slot_count = {canRead=true, canWrite=false, canCall=false},
inserter_target_pickup_count = {canRead=true, canWrite=false, canCall=false},
inserter_stack_size_override = {canRead=true, canWrite=true, canCall=false},
inserter_filter_mode = {canRead=true, canWrite=false, canCall=false},
relative_turret_orientation = {canRead=true, canWrite=false, canCall=false},
driver_is_gunner = {canRead=true, canWrite=false, canCall=false},
speed = {canRead=true, canWrite=false, canCall=false},
effective_speed = {canRead=true, canWrite=false, canCall=false},
temperature = {canRead=true, canWrite=false, canCall=false},
train = {canRead=true, canWrite=false, canCall=false},
fluidbox = {canRead=true, canWrite=true, canCall=false, type="LuaFluidBox"},
entity_label = {canRead=true, canWrite=true, canCall=false},
color = {canRead=true, canWrite=true, canCall=false},
productivity_bonus = {canRead=true, canWrite=false, canCall=false},
pollution_bonus = {canRead=true, canWrite=false, canCall=false},
speed_bonus = {canRead=true, canWrite=false, canCall=false},
consumption_bonus = {canRead=true, canWrite=false, canCall=false},
logistic_network = {canRead=true, canWrite=false, canCall=false},
logistic_cell = {canRead=true, canWrite=false, canCall=false},
last_user = {canRead=true, canWrite=true, canCall=false, type="LuaPlayer"},
electric_buffer_size = {canRead=true, canWrite=false, canCall=false},
electric_input_flow_limit = {canRead=true, canWrite=false, canCall=false},
electric_output_flow_limit = {canRead=true, canWrite=false, canCall=false},
electric_drain = {canRead=true, canWrite=false, canCall=false},
electric_emissions = {canRead=true, canWrite=false, canCall=false},
unit_number = {canRead=true, canWrite=false, canCall=false},
mining_progress = {canRead=true, canWrite=true, canCall=false},
bonus_mining_progress = {canRead=true, canWrite=true, canCall=false},
bounding_box = {canRead=true, canWrite=false, canCall=false},
secondary_bounding_box = {canRead=true, canWrite=false, canCall=false},
selection_box = {canRead=true, canWrite=false, canCall=false},
secondary_selection_box = {canRead=true, canWrite=false, canCall=false},
circuit_connected_entities = {canRead=true, canWrite=false, canCall=false},
circuit_connection_definitions = {canRead=true, canWrite=false, canCall=false},
request_slot_count = {canRead=true, canWrite=false, canCall=false},
grid = {canRead=true, canWrite=false, canCall=false},
graphics_variation = {canRead=true, canWrite=false, canCall=false},
burner = {canRead=true, canWrite=false, canCall=false},
effects = {canRead=true, canWrite=false, canCall=false},
beacons_count = {canRead=true, canWrite=false, canCall=false},
render_player = {canRead=true, canWrite=true, canCall=false},
render_to_forces = {canRead=true, canWrite=true, canCall=false},
electric_network_id = {canRead=true, canWrite=false, canCall=false},
is_entity_with_force = {canRead=true, canWrite=false, canCall=false},
is_military_target = {canRead=true, canWrite=false, canCall=false},
is_entity_with_owner = {canRead=true, canWrite=false, canCall=false},
is_entity_with_health = {canRead=true, canWrite=false, canCall=false},
}

function InserterEntity.copy_filter(source,dest)
	if(not source or not dest) then return end
	if(source.filter_slot_count==0 or dest.filter_slot_count==0) then return end
	--  Callable only on entities that have filters.
	local filter = source.get_filter(1)
	dest.set_filter(1, filter)
	trace("copy_filter", source.name, dest.name, serpent.line(filter))
end

function InserterEntity.get_relative_pickup_position(entity)
	return {
		x = entity.pickup_position.x - entity.position.x,
		y = entity.pickup_position.y - entity.position.y
	}
end

function InserterEntity.get_relative_drop_position(entity)
	return {
		x = entity.drop_position.x - entity.position.x,
		y = entity.drop_position.y - entity.position.y
	}
end

function InserterEntity.get_directional_position(x,y)
	x = math.abs(x)
	y = math.abs(y)
	return math.max(x,y), math.min(x,y)
end

function InserterEntity.connect_green_wire(entity1,entity2)
	if(not entity1 or not entity2) then return end

	-- Überprüfen, ob bereits ein grünes Kabel besteht
	local green_wire_exists = false
	local connections = entity1.circuit_connection_definitions
	for _, connection in ipairs(connections) do
		if connection.source_entity == entity1 and
			connection.target_entity == entity2 and
			connection.wire == defines.wire_type.green then
			green_wire_exists = true
			break
		end
	end

	-- Wenn kein grünes Kabel existiert, dann erstellen Sie eins
	if not green_wire_exists then
		local connected = entity1.connect_neighbour{
			target_entity = entity2,
			wire = defines.wire_type.green,
			-- source_circuit_id = defines.circuit_connector_id.combinator_input,
			-- target_circuit_id = defines.circuit_connector_id.combinator_output,
			-- source_circuit_position = defines.circuit_connector_id.combinator_input,
			-- target_circuit_position = defines.circuit_connector_id.combinator_output,
		}
		trace("connect_green_wire", entity1.name, entity2.name, "connected: "..tostring(connected))
	end
end

local function get_control_behavior_name(arg)
	local t = nil
	if(type(arg)=="number") then t = arg
	elseif(type(arg)=="table" and arg["object_name"]=="LuaEntity") then
		local b = arg.get_control_behavior()--[[@as LuaControlBehavior]]
		if(not b) then return nil end
		t = b.type
	end
	for name, value in pairs(defines.control_behavior.type) do
		if(value == t) then return name end
	end
	return tostring(t)
end

--TODO: move to utils
local function definesToString(defines, value, includeId)
	if(value==nil) then return "nil" end
	if(type(defines)=="string") then 
		if(not defines:match("^defines")) then defines="defines."..defines end
		defines = safeget(defines)
	end
	if(not defines) then return tostring(value) end
	for name, v in pairs(defines) do
		if(value == v) then return includeId and name.."("..value..")" or name end
	end
	return tostring(value)
end

---@param entity1 LuaEntity
---@param entity2 LuaEntity
function InserterEntity.copy_behavior(entity1,entity2)
	trace("copy_connection_conditions", entity1.name, entity2.name)
	local behavior1 = entity1.get_control_behavior() --[[@as  LuaInserterControlBehavior]]
	if(not behavior1) then return end
	local behavior2 = entity2.get_or_create_control_behavior() --[[@as  LuaInserterControlBehavior]]

	behavior2.circuit_condition           = behavior1.circuit_condition
	behavior2.circuit_hand_read_mode      = behavior1.circuit_hand_read_mode
	behavior2.circuit_mode_of_operation   = behavior1.circuit_mode_of_operation
	behavior2.circuit_read_hand_contents  = behavior1.circuit_read_hand_contents
	behavior2.circuit_set_stack_size      = behavior1.circuit_set_stack_size
	if(behavior1.circuit_stack_control_signal) then behavior2.circuit_stack_control_signal=behavior1.circuit_stack_control_signal end
	
	behavior2.connect_to_logistic_network = behavior1.connect_to_logistic_network
	behavior2.logistic_condition		  = behavior1.logistic_condition
end

function InserterEntity.copyToTable(entity, t)
	t.name = entity.name
	t.position = entity.position
	t.direction = entity.direction
	t.drop_position = entity.drop_position
	t.pickup_position = entity.pickup_position
	t.drop_target = entity.drop_target
	t.pickup_target = entity.pickup_target
	t.filters = entity.filters
	t.filter_mode = entity.filter_mode
	t.override_stack_size = entity.override_stack_size
	t.circuit_connection_definitions = entity.circuit_connection_definitions
	t.circuit_connected_entities = entity.circuit_connected_entities
	t.circuit_wire_connection_points = entity.circuit_wire_connection_points
	t.circuit_wire_max_distance = entity.circuit_wire_max_distance

	t.get_control_behavior = InserterControlBehavior.asTable(entity.get_control_behavior())

end

---@param entity LuaEntity
function InserterEntity.dump_circuit_connected_entities(entity)
	local sb = StringBuilder:new()
	sb:appendLine("circuit_connected_entities:")
	for color, color_table in pairs(entity.circuit_connected_entities) do
		for _, other in ipairs(color_table) do
			sb:appendLine(string.format("  %s: %s #%d", color, other.name, other.unit_number))
		end
	end
	return sb:toString()
end

---@param entity LuaEntity
function InserterEntity.dump_circuit_connection_definitions(entity)
	local sb = StringBuilder:new()

	sb:appendLine("  circuit_connection_definitions:")
	for _, value in ipairs(entity.circuit_connection_definitions) do
		sb:appendLine(string.format("    %s #%d %s %s %s",
			value.target_entity.name,
			value.target_entity.unit_number,
			definesToString(defines.wire_type,value.wire),
			definesToString(defines.circuit_connector_id, value.source_circuit_id),
			definesToString(defines.circuit_connector_id, value.target_circuit_id)
		))
	end

	return sb:toString()
end

function InserterEntity.dump_circuit_behavior(entity)
	local behavior = entity.get_control_behavior() --[[@as LuaInserterControlBehavior]]
	if(behavior == nil) then return "" end

	local sb = StringBuilder:new()
	sb:appendLine("  circuit_behavior:")
	sb:appendLine(string.format("    circuit_mode_of_operation    = %s", definesToString(defines.control_behavior.inserter.circuit_mode_of_operation, behavior.circuit_mode_of_operation)))
	sb:appendLine(string.format("    circuit_hand_read_mode       = %s", definesToString(defines.control_behavior.inserter.hand_read_mode, behavior.circuit_hand_read_mode)))
	sb:appendLine(string.format("    circuit_read_hand_contents   = %s", tostring(behavior.circuit_read_hand_contents)))
	sb:appendLine(string.format("    circuit_set_stack_size       = %s", tostring(behavior.circuit_set_stack_size)))
	sb:appendLine(string.format("    circuit_stack_control_signal = %s", tostring(behavior.circuit_stack_control_signal)))
	sb:appendLine(string.format("    circuit_condition            = %s", serpent.line(behavior.circuit_condition)))

	return sb:toString()
end
function InserterEntity.dump_logistic_behavior(entity)
	local behavior = entity.get_control_behavior() --[[@as LuaInserterControlBehavior]]
	if(behavior == nil) then return "" end

	local sb = StringBuilder:new()
	sb:appendLine("  circuit_behavior:")
	sb:appendLine(string.format("    connect_to_logistic_network  = %s", tostring(behavior.connect_to_logistic_network)))
	sb:appendLine(string.format("    logistic_condition           = %s", serpent.line(behavior.logistic_condition)))

	return sb:toString()
end



return InserterEntity