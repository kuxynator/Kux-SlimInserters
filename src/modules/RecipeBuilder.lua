require("modules/Utils")

RecipeBuilder = {}

local icon = mod.path.."graphics/arrow.png"
local count = 0

function RecipeBuilder.create_recipe(preset)
	local base_name = preset.base_name or error("Argument Exception. preset.base_name must not be nil.")
	local name = Utils.create_name(preset)
	local recipe = table.deepcopy(data.raw.recipe[base_name]) --[[@as Recipe]]

	recipe.name = name
	recipe.localised_name = { "entity-name." .. recipe.name }
	recipe.result = name
	
	recipe.normal = nil
	recipe.expensive = nil
	recipe.ingredients = preset.recipe[1] or recipe.ingredients
	recipe.result_count = preset.recipe[2] or recipe.result_count
	recipe.icons = { {
		icon = icon,
		icon_size = 64,
		tint = preset.tint
	} }

	if(name:find("double-")) then
		recipe.order = "z[slim-inserter]-b" .. count .. "[" .. name .. "]"
		recipe.icons[1].icon = mod.path.."graphics/double-arrow.png"
	elseif(name:find("loader-")) then
		recipe.order = "z[slim-inserter]-c" .. count .. "[" .. name .. "]"
		recipe.icons[1].icon = mod.path.."graphics/loader/arrow.png"
	else
		recipe.order = "z[slim-inserter]-a" .. count .. "[" .. name .. "]"
	end

	count = count + 1
	data:extend { recipe }
	return recipe
end

return RecipeBuilder
