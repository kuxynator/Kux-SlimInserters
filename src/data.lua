require("mod")

require("prototypes/common")
Presets = require("prototypes/Presets")

require("modules/EntityBuilder")
require("modules/ItemBuilder")
require("modules/RecipeBuilder")
require('modules/TechnologyBuilder')

local this = {}

-- Mk0    Mk1     Mk2      Mk3      Mk4     Mk5     Mk6
-- -      basic   fast     stack    
--        long
--                filter	filter

local function create(preset)
	EntityBuilder.create_entity(preset)
	ItemBuilder.create_item(preset)
	RecipeBuilder.create_recipe(preset)
	TechnologyBuilder.add_to_tech(preset)
end

-- vanilla
create(Presets.basic)
create(Presets.long)
create(Presets.fast)
create(Presets.filter)
create(Presets.stack)
create(Presets.stack_filter)

-- kr2
if false --[[HACK: deactivated]] and mods["Krastorio2"] then
	create(Presets.fast_boi)
	if not (mods["boblogistics"] or mods["bobinserters"]) then
		create(Presets.long_boi)
	end
end

--HACK: feate disabled, we have the color purple already used for filter inserter
if false --[[HACK: deactivated]] and mods["boblogistics"] then
	create(Presets.purple_one)
end

-- because "Collision-box has to contain the [0,0] point." we can not put 2 entities on the same tile!
-- workaround: remove collision-box and handle collission manually

local function create_dual_part_a(preset)
	local base_name = Utils.create_name(preset)
	local entity = table.deepcopy(data.raw["inserter"][base_name])
	--entity.collision_box = { { -0.25, -0.01 }, { 0, 0.01 } }
	--entity.collision_mask =  {}
	--entity.collision_box = {{0,0}, {0,0}}
	entity.collision_box=nil
	entity.selection_box = { { -0.4, -0.2 }, { 0.0, 0.2 } }
	entity.name=base_name.."_part-a"
	entity.subgroup = "inserter-sub-items"
	entity.fast_replaceable_group = ""
	entity.platform_picture.sheet.filename = mod.path.."graphics/arrow2-l.png"
	entity.platform_picture.sheet.hr_version.filename = mod.path.."graphics/arrow2-l.png"
	-- entity.pickup_position = { -0.20, -0.5 } entity.insert_position = { -0.20, 0.5 }	
	-- FAIL: entity.tile_width = 0.5; entity.pickup_position = { 0, -0.5 }, 	entity.insert_position = { 0, 0.5 }
	entity.pickup_position = { 0, -0.5 }
	entity.insert_position = { -0.20, 0.5 }
	entity.placeable_by = { item = base_name, count = 1 }

	local item = table.deepcopy(data.raw["item"][base_name])
	item.name = entity.name
	item.subgroup = "inserter-sub-items"
	item.place_result = entity.name

	local arrow = table.deepcopy(data.raw["constant-combinator"][base_name.."_arrow"])
	arrow.name = entity.name.."_arrow"
	arrow.sprites.sheet.filename = entity.platform_picture.sheet.filename
	arrow.integration_patch.sheet.filename = entity.platform_picture.sheet.filename

	data:extend{entity,arrow}
end

local function create_dual_part_b(preset)
	local base_name = Utils.create_name(preset)
	local entity = table.deepcopy(data.raw["inserter"][base_name]) --[[@as Inserter]]
	--entity.collision_box = { { 0, -0.01 }, { 0.25, 0.01 } }
	--entity.collision_mask =  {}
	--entity.collision_box = {{0,0}, {0,0}}
	entity.collision_box=nil
	entity.selection_box = { { 0.0, -0.2 }, { 0.4, 0.2 } }
	entity.name=base_name.."_part-b"
	entity.subgroup = "inserter-sub-items"
	entity.fast_replaceable_group = ""
	entity.platform_picture.sheet.filename = mod.path.."graphics/arrow2-r.png"
	entity.platform_picture.sheet.hr_version.filename = mod.path.."graphics/arrow2-r.png"
	-- entity.pickup_position = { -0.20, -0.5 } entity.insert_position = { -0.20, 0.5 }	
	-- FAIL: entity.tile_width = 0.5; entity.pickup_position = { 0, -0.5 }, 	entity.insert_position = { 0, 0.5 }
	entity.pickup_position = { 0, -0.5 } entity.insert_position = { 0.20, 0.5 }
	entity.placeable_by = { item = base_name, count = 1 }

	local arrow = table.deepcopy(data.raw["constant-combinator"][base_name.."_arrow"])
	arrow.name = entity.name.."_arrow"
	arrow.sprites.sheet.filename = entity.platform_picture.sheet.filename
	arrow.integration_patch.sheet.filename = entity.platform_picture.sheet.filename

	data:extend{entity,arrow}
end

if(true) then --HACK: temporary feature "half inserter"
	create_dual_part_a(Presets.basic);create_dual_part_b(Presets.basic)
	create_dual_part_a(Presets.long);create_dual_part_b(Presets.long)
	create_dual_part_a(Presets.fast);create_dual_part_b(Presets.fast)
	create_dual_part_a(Presets.filter);create_dual_part_b(Presets.filter)
	create_dual_part_a(Presets.stack);create_dual_part_b(Presets.stack)
	create_dual_part_a(Presets.stack_filter);create_dual_part_b(Presets.stack_filter)
end

local function prepare_double_recipe(preset)
	--print(serpent.block(preset.recipe[1]))
	local a = preset.recipe or error("Argument Exception. preset.recipe must not be nil.\n"..serpent.block(preset))
	local ingredients = a[1] or error("Argument Exception. preset.recipe[1] must not be nil.\n"..serpent.block(preset))

	local function find_ingredient(name)
		for _, value in ipairs(ingredients) do
			if value[1]==name then return value end
		end
		return nil
	end

	for _, value in ipairs(ingredients) do
		value[2]=value[2]*2
	end
	for _, extra in ipairs(preset.double_extra_ingredients) do
		local x = find_ingredient(extra[1])
		if(x) then x[2] = x[2] + extra[2]
		else table.insert(ingredients, extra) end
	end
end

local count = 1
function this.create_double(preset)
	--print("create_double()")
	local base_name = Utils.create_name(preset)
	local entity = table.deepcopy(data.raw["inserter"][base_name])
	preset = table.deepcopy(preset);
	preset.tags = preset.tags or {}
	preset.tags.double = true
	prepare_double_recipe(preset)
	--entity.collision_box = { { -0.25, -0.01 }, { 0, 0.01 } }
	--entity.collision_mask =  {}
	--entity.collision_box = {{0,0}, {0,0}}
	entity.collision_box=nil
	entity.selection_box = { { -0.4, -0.2 }, { 0.0, 0.2 } }
	entity.name = Utils.create_name(preset); --print("  name: "..entity.name)
	entity.order = "z[slim-inserter]-b" .. count.."["..entity.name.."]"
	entity.fast_replaceable_group = "slim-inserter"
	entity.platform_picture.sheet.filename = mod.path.."graphics/double-arrow.png"
	entity.platform_picture.sheet.hr_version.filename = mod.path.."graphics/double-arrow.png"
	-- entity.pickup_position = { -0.20, -0.5 } entity.insert_position = { -0.20, 0.5 }	
	-- FAIL: entity.tile_width = 0.5; entity.pickup_position = { 0, -0.5 }, 	entity.insert_position = { 0, 0.5 }
	entity.pickup_position = { 0, -0.5 }
	entity.insert_position = { -0.20, 0.5 }
	entity.minable.result = entity.name
	data:extend{entity}

	ItemBuilder.create_item(preset)
	RecipeBuilder.create_recipe(preset)
	
	EntityBuilder.create_arrow(entity, preset.tint)

	TechnologyBuilder.add_to_tech(preset)

	this.create_double_part(preset)
	count = count + 1
end

function this.create_double_part(preset)
	local base_name = Utils.create_name(preset)
	local entity = table.deepcopy(data.raw["inserter"][base_name])
	--entity.collision_box = { { 0, -0.01 }, { 0.25, 0.01 } }
	--entity.collision_mask =  {}
	--entity.collision_box = {{0,0}, {0,0}}
	entity.collision_box=nil
	entity.selection_box = { { 0.0, -0.2 }, { 0.4, 0.2 } }
	entity.name=Utils.create_name(preset).."_part"
	entity.fast_replaceable_group = "slim-inserter"
	entity.platform_picture.sheet.filename = mod.path.."graphics/arrow.png" --TODO use empty sprite
	entity.platform_picture.sheet.hr_version.filename = mod.path.."graphics/double-arrow.png"--TODO use empty sprite
	-- entity.pickup_position = { -0.20, -0.5 } entity.insert_position = { -0.20, 0.5 }	
	-- FAIL: entity.tile_width = 0.5; entity.pickup_position = { 0, -0.5 }, 	entity.insert_position = { 0, 0.5 }
	entity.pickup_position = { 0, -0.5 } entity.insert_position = { 0.20, 0.5 }
	entity.placeable_by = { item = Utils.create_name(preset), count = 1 }

	local arrow = table.deepcopy(data.raw["constant-combinator"][Utils.create_name(preset).."_arrow"])
	arrow.name = entity.name.."_arrow"
	arrow.sprites.sheet.filename = entity.platform_picture.sheet.filename
	arrow.integration_patch.sheet.filename = entity.platform_picture.sheet.filename

	data:extend{entity,arrow}
end

---@param preset Preset
function this.create_loader(preset)
	--print("create_loader()")
	local base_name = preset.base_name
	local entity = table.deepcopy(data.raw["inserter"][base_name])
	preset = table.deepcopy(preset);
	preset.tags = preset.tags or {}
	--entity.collision_box = { { -0.25, -0.01 }, { 0, 0.01 } }
	--entity.collision_mask =  {}
	--entity.collision_box = {{0,0}, {0,0}}
	entity.collision_box=nil
	entity.selection_box = { { -0.4, -0.2 }, { 0.4, 0.2 } }
	entity.name = Utils.create_name(preset); --print("  name: "..entity.name)
	entity.order = "z[slim-inserter]-c" .. count.."["..entity.name.."]"
	entity.fast_replaceable_group = "slim-loader"
	entity.platform_picture.sheet.filename = mod.path.."graphics/loader/arrow.png"
	entity.platform_picture.sheet.hr_version.filename = mod.path.."graphics/loader/arrow.png"
	entity.pickup_position = { -0.20, -0.5 +0.2 }
	entity.insert_position = { -0.20,  0.5 -0.2 }
	entity.minable.result = entity.name
	entity.stack=true
	entity.stack_size_bonus = 10
	entity.rotation_speed = preset.rotation_speed
	entity.allow_custom_vectors = false
	entity.draw_inserter_arrow=false
	data:extend{entity}

	ItemBuilder.create_item(preset)
	RecipeBuilder.create_recipe(preset)
	
	EntityBuilder.create_arrow(entity, preset.tint)

	TechnologyBuilder.add_to_tech(preset)

	this.create_loader_part(preset)
	count = count + 1
end

---@param preset Preset
function this.create_loader_part(preset)
	local base_name = preset.base_name
	local entity = table.deepcopy(data.raw["inserter"][base_name])
	--entity.collision_box = { { 0, -0.01 }, { 0.25, 0.01 } }
	--entity.collision_mask =  {}
	--entity.collision_box = {{0,0}, {0,0}}
	entity.collision_box=nil
	entity.selection_box=nil
	entity.name=Utils.create_name(preset).."_loaderpart"
	entity.fast_replaceable_group = nil
	entity.platform_picture.sheet.filename = mod.path.."graphics/loader/arrow.png" --TODO use empty sprite
	entity.platform_picture.sheet.hr_version.filename = mod.path.."graphics/loader/arrow.png"--TODO use empty sprite
	entity.pickup_position = { 0.2, -0.5 + 0.2 } -- right near
	entity.insert_position = { 0.2,  0.5 + 0.2 } -- right far
	entity.allow_custom_vectors = false
	entity.placeable_by = nil
	entity.flags={"hidden", "not-blueprintable", "not-deconstructable", "not-on-map", "not-flammable", "not-repairable", "no-copy-paste", "not-selectable-in-game", "not-upgradable", "not-in-kill-statistics"}
	entity.stack=true
	entity.stack_size_bonus = 10
	entity.rotation_speed = preset.rotation_speed
	entity.draw_inserter_arrow=false
	
	data:extend{entity}
end

if(true) then
	this.create_double(Presets.basic);
	this.create_double(Presets.long);
	this.create_double(Presets.fast);
	this.create_double(Presets.filter);
	this.create_double(Presets.stack);
	this.create_double(Presets.stack_filter);
end

if(true) then
	this.create_loader(Presets.basic_loader);
	this.create_loader(Presets.fast_loader);
	this.create_loader(Presets.filter_loader);
	this.create_loader(Presets.mk3_loader);
	this.create_loader(Presets.mk3_filter_loader);
end

-- print("List of inserters:")
-- for key, value in pairs(data.raw.inserter) do
-- 	if key:match("%-slim%-inserter$") then print(key) end
-- end