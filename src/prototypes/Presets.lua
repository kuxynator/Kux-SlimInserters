---@class Preset
---@field base_name string
---@field prefix string?
---@field tint Color
---@field energy Energy
---@field recipe Recipe
---@field tags table<string, boolean>?

---@Class Presets : Preset[]
local Presets = {}

---@type Preset
Presets.basic = {
	base_name = "inserter",
	prefix = "basic-",
	tint = { r = 1.0, g = 1.0, b = 0.0 },
	energy = { passive = "150W", active = "4.5kJ" },
	recipe = { {
		{ "inserter", 1 },
		{ "electronic-circuit", 1 }
	}, 1 },
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
	recipe = { {
		{ "long-handed-inserter", 1 },
		{ "electronic-circuit", 1 }
	}, 1 },
	tags = { long = true },
	double_extra_ingredients = {
		{ "iron-plate", 2 }
	}
}
if mods["bobelectronics"] then
	Presets.long.recipe[1][2][2] = 2
end
if mods["boblogistics"] or mods["bobinserters"] then
	--HACK: preset.long.prefix = "red-"
end

---@type Preset
Presets.fast = {
	base_name = "fast-inserter",
	prefix = "fast-",
	tint = { r = 0.0, g = 0.5, b = 1.0 },
	energy = { passive = "200W", active = "6kJ" },
	recipe = { {
		{ "fast-inserter", 1 },
		{ "steel-plate", 1 }
	}, 1 },
	double_extra_ingredients = {
		{ "steel-plate", 2 }
	}
}
if mods["bobelectronics"] then
	Presets.fast.recipe[1][2] = {"advanced-circuit", 2}
end
if mods["boblogistics"] or mods["bobinserters"] then
	--HACK: preset.fast.prefix = "blue-"
end

---@type Preset
Presets.filter = { --TODO: new feature
	base_name = "filter-inserter",
	tint = { r = 0.698, g = 0.0, b = 1 },
	energy = { passive = "200W", active = "6kJ" },
	recipe = { {
		{ "filter-inserter", 1 },
		{ "steel-plate", 1 }
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
	recipe = { {
		{ "stack-inserter", 1 },
		{ "advanced-circuit", 1 }
	}, 1 },
	double_extra_ingredients = {
		{ "steel-plate", 2 }
	},
	tags = { stack = true }
}
if mods["bobelectronics"] then
	Presets.stack.recipe[1][1] = {"express-inserter", 1}
	Presets.stack.recipe[1][2] = {"advanced-processing-unit", 2}
end
if mods["boblogistics"] or mods["bobinserters"] then
	--HACK: preset.stack.prefix = "green-"
end
if mods["boblogistics"] then
	Presets.stack.base_name = "express-inserter"
end

---@type Preset
Presets.stack_filter = { --TODO: new feature
	base_name = "stack-filter-inserter",
	tint = { r = 0.9, g = 0.9, b = 0.9 }, --white
	energy = { passive = "400W", active = "16kJ" },
	recipe = { {
		{ "stack-filter-inserter", 1 },
		{ "advanced-circuit", 1 }
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

return Presets