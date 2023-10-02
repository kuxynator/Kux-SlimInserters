require("modules/Utils")
EntityBuilder = {}

local platform_picture_path = mod.path.."graphics/arrow.png"
local icon=mod.path.."graphics/arrow.png"
---comment
---@param entity table InserterPrototype
---@param tint Color
---@param energy table
local function constants(entity, tint, energy)
	entity.icons = { {
		icon = icon,
		icon_size = 64,
		tint = tint
	} }
	entity.selection_priority = 255
	entity.rotation_speed = entity.rotation_speed / 100 * 120 -- HACK: de-nerf
	entity.energy_per_rotation = energy.active or entity.energy_per_rotation
	entity.energy_source.drain = energy.passive or entity.energy_source.drain
	entity.allow_custom_vectors = true -- HACK: allow bobinserters configuration
	entity.pickup_position = { 0, -0.5 }
	entity.insert_position = { -0.001, 0.5 } --HACK: { 0, 0.35 } 
	entity.collision_box = nil --HACK: { { -0.25, -0.01 }, { 0.25, 0.01 } }
	entity.selection_box = { { -0.4, -0.2 }, { 0.4, 0.2 } }
	entity.collision_mask = { "item-layer", "object-layer", "player-layer", }
	entity.flags = { "placeable-neutral", "placeable-player", "player-creation" }
	entity.fast_replaceable_group = "slim-inserter"
	entity.next_upgrade = ""
	entity.protected_from_tile_building = false
	entity.tile_height = 0
	entity.tile_width = 1
	entity.draw_inserter_arrow = true -- HACK: (false)
	entity.draw_held_item = false --HACK:
	entity.chases_belt_items = false
	entity.hand_size = 0.05
	entity.hand_base_picture = Utils.empty_sheet
	entity.hand_base_shadow = Utils.empty_sheet
	entity.hand_closed_picture = Utils.empty_sheet
	entity.hand_closed_shadow = Utils.empty_sheet
	entity.hand_open_picture = Utils.empty_sheet
	entity.hand_open_shadow = Utils.empty_sheet
	entity.platform_picture.sheet.scale = 0.5
	entity.platform_picture.sheet.size = 64
	entity.platform_picture.sheet.shift = { 0, 0 }
	entity.platform_picture.sheet.filename = platform_picture_path
	entity.platform_picture.sheet.tint = tint
	entity.platform_picture.sheet.hr_version.size = 64
	entity.platform_picture.sheet.hr_version.shift = { 0, 0 }
	entity.platform_picture.sheet.hr_version.tint = tint
	entity.platform_picture.sheet.hr_version.filename = platform_picture_path
	--HACK: disabled feature
	-- if settings.startup["add-one-filter-slot"].value then
	-- 	eBase.filter_count = 1
	-- 	eBase.filter_mode = "blacklist"
	-- end
end

---tag_works
---@param entity Inserter
---@param tags any
---@return Inserter
local function tag_works(entity, tags)
	if(not tags) then return entity end
	if tags.filter then
		entity.filter_count = 1
	end
	if tags.long then
		entity.pickup_position = { 0, -1.5 }
		entity.insert_position = { -0.2, 1.35 } --HACK:{ 0, 1.35 }
	end
	if tags.stack then
		entity.stack = true
	end

	return entity
end

local count = 0

function EntityBuilder.create_entity(preset)
	local base_name = preset.base_name or error("Argument Exception. preset.base_name must not be nil.")
	local name = Utils.create_name(preset)

	local entity = table.deepcopy(data.raw.inserter[base_name]) --[[@as Inserter]]
	constants(entity, preset.tint, preset.energy)
	entity.name = name
	entity.minable.result = name
	entity.order = "z[slim-inserter]-a"..count.."[" .. name .. "]"
	entity.localised_name = { "entity-name." .. entity.name }

	if mods["Squeak Through"] then entity.collision_mask[3] = nil end --TODO: revise [3]

	tag_works(entity, preset.tags)

	EntityBuilder.create_arrow(entity, preset.tint)
	data:extend { entity }
	print("Created entity: " .. entity.name)

	count=count+1
end

---comment
---@param parent Inserter
---@param tint Color?
---@return table
function EntityBuilder.create_arrow(parent, tint)
	if(not tint) then tint=parent.platform_picture.sheet.tint end
	local entity = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
	entity.name = parent.name .. "_arrow"
	entity.collision_mask = {}
	entity.item_slot_count = 0
	entity.circuit_wire_max_distance = 0
	entity.integration_patch_render_layer = "higher-object-above"
	entity.collision_box = { { 0, 0 }, { 0, 0 } }
	entity.selection_box = { { 0, 0 }, { 0, 0 } }
	entity.tile_height = 0
	entity.tile_width = 1
	entity.sprites = { sheet = {
		--filename = platform_picture_path,
		filename=parent.platform_picture.sheet.filename,
		size = { 1, 1 },
		position = { 0, 0 },
		tint = tint,
		scale = 0.5,
	} }
	entity.integration_patch = { sheet = {
		--filename = platform_picture_path,
		filename=parent.platform_picture.sheet.filename,
		size = 64,
		position = { 0, 0 },
		tint = tint,
		scale = 0.5,
	} }
	data:extend { entity }
end

return EntityBuilder
