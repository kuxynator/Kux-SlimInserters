---@class Preset
---@field base_name string The prototype from which the new inserter will be derived
---@field prefix string?
---@field tint Color
---@field energy Energy
---@field recipe Recipe
---@field tags table<string, boolean>?

---@Class Presets : Preset[]
local Presets = {}

local function fallback(...)
	local args = {...}
	if(#args == 1 and type(args[1]=="table")) then args = args[1] end
	for _, name in ipairs(args) do
		if(data.raw.item[name]) then
			return name
		end
	end
	error("No fallback found for "..table.concat(args, ", "))
end

local consume_vanilla_inserter = settings.startup[mod.prefix.."consume-vanilla-inserter"].value

---@type Preset
Presets.basic = {
	base_name = "inserter",
	prefix = "basic-",
	tint = { r = 1.0, g = 1.0, b = 0.0 },
	energy = { passive = "150W", active = "4.5kJ" },
	recipe = {
		consume_vanilla_inserter and {
			{ "inserter", 1 },
			{ "electronic-circuit", 1 }
		} or {
			{ "iron-plate", 2 },
			{ "iron-gear-wheel", 2 },
			{ "iron-stick", 1 }
		}
		, 1 },
	double_extra_ingredients = {
		{ "iron-plate", 2 }
	}
}
if mods["bobelectronics"] then
	Presets.basic.recipe[1][2] = {"basic-circuit-board", 2}
end

---@type Preset
Presets.long = {
	base_name = "long-handed-inserter",
	tint = { r = 1.0, g = 0.2, b = 0.2 },
	energy = { passive = "150W", active = "4.5kJ" },
	recipe = {
		consume_vanilla_inserter and {
			{ "long-handed-inserter", 1 },
			{ "electronic-circuit", 1 }
		} or {
			{ "iron-plate", 4 },
			{ "iron-gear-wheel",4 },
			{ "iron-stick", 2 }
	}, 1 },
	tags = { long = true },
	double_extra_ingredients = {
		{ "iron-plate", 2 }
	}
}
-- if mods["bobelectronics"] then
-- 	Presets.long.recipe[1][2][2] = 2
-- end


---@type Preset
Presets.fast = {
	base_name = "fast-inserter",
	prefix = "fast-",
	tint = { r = 0.0, g = 0.5, b = 1.0 },
	energy = { passive = "200W", active = "6kJ" },
	recipe = {
		consume_vanilla_inserter and {
			{ "fast-inserter", 1 },
			{ "steel-plate", 1 }
		} or {
			{ fallback{"steel-plate", "iron-plate" }, 4 },
			{ fallback{"steel-gear-wheel", "iron-gear-wheel" }, 4 },
			{ fallback{"steel-stick", "iron-stick"}, 2 }
	}, 1 },
	double_extra_ingredients = {
		{ "steel-plate", 2 }
	}
}
-- if mods["bobelectronics"] then
-- 	Presets.fast.recipe[1][2] = {"advanced-circuit", 2}
-- end

---@type Preset
Presets.filter = { --TODO: new feature
	base_name = "filter-inserter",
	tint = { r = 0.698, g = 0.0, b = 1 },
	energy = { passive = "200W", active = "6kJ" },
	recipe = {
		consume_vanilla_inserter and {
			{ "filter-inserter", 1 },
			{ "steel-plate", 1 }
		} or {
			{ "fast-slim-inserter", 1 },
			{ fallback{"steel-gear-wheel", "iron-gear-wheel", }, 2 },
			{ fallback{"electronic-circuit"}, 2 }
	}, 1 },
	double_extra_ingredients = {
		{ "steel-plate", 2 }
	},
	tags = { filter = true }
}
if mods["bobelectronics"] then
	Presets.fast.recipe[1][2] = {"advanced-circuit", 2}
end

---@type Preset
Presets.stack = {
	base_name = "stack-inserter",
	tint = { r = 0.5, g = 1.0, b = 0.4 },
	energy = { passive = "400W", active = "16kJ" },
	recipe = {
		consume_vanilla_inserter and {
			{ "stack-inserter", 1 },
			{ "advanced-circuit", 1 }
		} or {
			{ "steel-plate", 10},
			{ fallback{"steel-gear-wheel", "iron-gear-wheel", }, 8 },
			{ fallback{"advanced-circuit"}, 4 }
	}, 1 },
	double_extra_ingredients = {
		{ "steel-plate", 2 }
	},
	tags = { stack = true }
}
-- if mods["bobelectronics"] then
-- 	Presets.stack.recipe[1][1] = {"express-inserter", 1}
-- 	Presets.stack.recipe[1][2] = {"advanced-processing-unit", 2}
-- end
-- if mods["boblogistics"] then
-- 	Presets.stack.base_name = "express-inserter"
-- end

---@type Preset
Presets.stack_filter = { --TODO: new feature
	base_name = "stack-filter-inserter",
	tint = { r = 0.9, g = 0.9, b = 0.9 }, --white
	energy = { passive = "400W", active = "16kJ" },
	recipe = {
		consume_vanilla_inserter and {
			{ "stack-filter-inserter", 1 },
			{ "advanced-circuit", 2 }
		} or {
			{ "stack-slim-inserter", 1 },
			{ fallback{"advanced-circuit"}, 2 }
	}, 1 },
	double_extra_ingredients = {
		{ "steel-plate", 2 }
	},
	tags = { stack = true, filter = true }
}

---@type Preset
-- for boblogistics
Presets.purple_one = {
	base_name = "turbo-inserter",
	prefix = "purple-",
	tint = { r = 0.4375, g = 0.0, b = 0.5 },
	energy = { passive = "400W", active = "16kJ" },
	recipe = { {
		{ "turbo-inserter", 1 },
		{ "processing-unit", 2 }
	}, 1 },
	double_extra_ingredients = {
		{ "steel-plate", 2 }
	}
}

---@type Preset
---for K2
Presets.fast_boi = {
	base_name = "kr-superior-inserter",
	prefix = "superior-",
	tint = { r = 0.15, g = 0.18, b = 0.2 },
	energy = { passive = "400W", active = "18kJ" },
	recipe = { {
		{ "kr-superior-inserter", 1 },
		{ "processing-unit", 1 }
	}, 1 },
	double_extra_ingredients = {
		{ "steel-plate", 2 }
	}
}

---@type Preset
---for K2
Presets.long_boi = {
	base_name = "kr-superior-long-inserter",
	prefix = "superior-long-",
	tint = { r = 0.35, g = 0.15, b = 0.18 },
	energy = { passive = "400W", active = "18.5kJ" },
	recipe = { {
		{ "kr-superior-long-inserter", 1 },
		{ "processing-unit", 1 }
	}, 1 },
	double_extra_ingredients = {
		{ "steel-plate", 2 }
	},
	tags = { long = true }
}

---@type Preset
Presets.basic_loader = {
	base_name = "basic-slim-inserter",
	prefix = "basic-",
	tint = { r = 1.0, g = 1.0, b = 0.0 },
	energy = { passive = "150W", active = "4.5kJ" },
	rotation_speed = 1000 * 0.000046296,
	recipe = { {
		{ "iron-plate", 20 },
		{ "iron-stick", 10 },
		{ "iron-gear-wheel", 20 }
	}, 1 },
	tags = { loader = true }
}

---@type Preset
Presets.fast_loader = {
	base_name = "fast-slim-inserter",
	prefix = "fast-",
	tint = { r = 0.0, g = 0.5, b = 1.0 },
	energy = { passive = "200W", active = "6kJ" },
	rotation_speed = 1600 * 0.000046296,
	recipe = { {
		{ "steel-plate", 20 },
		{ "iron-stick", 10 },
		{ "iron-gear-wheel", 20 }
	}, 1 },
	tags = { loader = true }
}
--TODO: move to data-updates
if(data.raw.item["steel-stick"]) then Presets.fast.recipe[1][2] = {"steel-stick", 5} end
if(data.raw.item["steel-gear-wheel"]) then Presets.fast.recipe[1][2] = {"steel-gear-wheel", 5} end

---@type Preset
Presets.filter_loader = {
	base_name = "filter-slim-inserter",
	prefix = "",
	tags = { filter = true, loader = true },
	tint = { r = 0.698, g = 0.0, b = 1 },
	energy = { passive = "200W", active = "6kJ" },
	rotation_speed = Presets.fast_loader.rotation_speed,
	recipe = { {
		{ "fast-loader-slim-inserter", 1 },
		{ "electronic-circuit", 20 }
	}, 1 },	
}
-- if mods["bobelectronics"] then
-- 	Presets.filter_loader.recipe[1][2] = {"advanced-circuit", Presets.filter_loader.recipe[1][2][2]}
-- end


---@type Preset
Presets.mk3_loader = {
	base_name = "fast-slim-inserter",
	prefix = "fast2-",
	tags = { loader = true },
	tint = Presets.stack.tint,
	energy = { passive = "600W", active = "18kJ" },
	rotation_speed = 2000 * 0.000046296,
	recipe = { {
		{ "fast-loader-slim-inserter",2 },
		{ "processing-unit", 5 }
	}, 1 },
	
}

---@type Preset
Presets.mk3_filter_loader = {
	base_name = "filter-slim-inserter",
	prefix = "fast2-",
	tags = { filter = true, loader = true },
	tint = Presets.stack_filter.tint,
	energy = { passive = "800W", active = "24kJ" },
	rotation_speed = Presets.mk3_loader.rotation_speed,
	recipe = { {
		{ "fast2-loader-slim-inserter", 1 },
		{ "advanced-circuit", 10 }
	}, 1 }
}

return Presets