Utils = {}

Utils.empty_sheet = {
	filename = "__core__/graphics/empty.png",
	priority = "very-low",
	width = 1,
	height = 1,
	hr_version = {
		filename = "__core__/graphics/empty.png",
		priority = "very-low",
		width = 1,
		height = 1,
	}
}
Utils.known_prefixes={"basic", "fast"}
Utils.known_tags={"stack", "long", "filter", "double"}
Utils.known_suffixes={"arrow", "part", "part-a","part-b"}

function Utils.create_name(preset, suffix)
	local name = "slim-inserter"
	local tags = preset.tags or {}

	for i = #Utils.known_tags, 1, -1 do
		local n = Utils.known_tags[i]
		if tags[n] and not name:find(n.."-") then name = n.."-"..name end
	end
	suffix = suffix or preset.suffix
	if(suffix and not suffix:match("^_")) then suffix="_"..suffix end
	return (preset.prefix or "") .. name..(suffix or "")
end

function Utils.get_prefix(name)
	local x = name
	for _, n in ipairs(Utils.known_prefixes) do
		x= x:gsub("^"..n.."%-", "")
	end
	local prefix = name:sub(1, #name - #x)
	return prefix
end

function Utils.get_suffix(name)
	local suffix = name:match("_.-$")
	return suffix
end

--- stack- long- filter- double-
function Utils.tag_name(name, tags)
	if not tags then return name end
	local prefix = Utils.get_prefix(name)
	for i = #Utils.known_tags, 1, -1 do
		local n = Utils.known_tags[i]
		if tags[n] and not name:find(n.."-") then name = n.."-"..name end
	end
	return (prefix or "")..name
end

Utils.get_entity = {
	[defines.events.on_player_mined_entity] = function(e) return e.entity end,
	[defines.events.on_built_entity       ] = function(e) return e.created_entity end,
	[defines.events.on_robot_built_entity ] = function(e) return e.created_entity end,
	[defines.events.script_raised_built   ] = function(e) return e.entity end,
	[defines.events.script_raised_revive  ] = function(e) return e.entity end,
	[defines.events.on_robot_mined_entity ] = function(e) return e.entity end,
	[defines.events.on_entity_died        ] = function(e) return e.entity end,
	[defines.events.script_raised_destroy ] = function(e) return e.entity end,
}

Utils.evt_displaynames={}
for key, value in pairs(defines.events) do Utils.evt_displaynames[value]=key.."("..value..")" end

function Utils.generate_tag_combinations()
	local function generate(arr, start, result, current)
		for i = start, #arr do
			local newCombination = current .. arr[i]
			table.insert(result, newCombination)
			generate(arr, i + 1, result, newCombination)
		end
	end
	local t = {}
	table.insert(t, "")
	for _, tag in ipairs(Utils.known_tags) do table.insert(t, tag.."-") end local combinations = {}
	generate(t, 1, combinations, "")
	return combinations
end

function Utils.get_item_filter()
	local filter = {}
	local tag_combinations = Utils.generate_tag_combinations()
	local suffixes = {""}; 	for _, suffix in ipairs(Utils.known_suffixes) do table.insert(suffixes, "_"..suffix) end
	for _, prefix in ipairs(Utils.known_prefixes) do
		for _, tag in ipairs(tag_combinations) do
			for _, suffix in ipairs(suffixes) do
				table.insert(filter, {filter="name", mode="or", name=prefix.."-"..tag .."slim-inserter".. suffix})
			end
		end
	end
	return filter
end

function Utils.reload_recipes()
	-- Enable researched recipes
	for i, force in pairs(game.forces) do
		for _, tech in pairs(force.technologies) do
			if tech.researched then
				for _, effect in pairs(tech.effects) do
					if effect.type == "unlock-recipe" and script.get_prototype_history("recipe", effect.recipe).created == script.mod_name then
						--print("Enabling recipe: "..effect.recipe)
						force.recipes[effect.recipe].enabled = true
					end
				end
			end
		end
	end
end
  
--   script.on_init(reload_recipes)
--   script.on_configuration_changed(reload_recipes)

--   commands.add_command(
-- 	"recipes-reload",
-- 	"Reload all recipes from researched technologies",
-- 	reload_recipes
--   )()
	

function Utils.create_arrow(inserter)
	local name = inserter.name
	if false --[[HACK: feature disabled]] and game.active_mods["bobinserters"] then
		name = name:gsub("long%-", "")
		name = name:gsub("stack%-", "")
	end
	local arr = inserter.surface.create_entity {
		name      = name .. "_arrow",
		position  = inserter.position,
		direction = (inserter.direction + 4) % 8,
		force     = inserter.force,
		type      = "constant-combinator"
	}
	arr.destructible = false
	return arr
end
