require("modules/Utils")

ItemBuilder={}

local count = 0
function ItemBuilder.create_item(preset)
	local base_name = preset.base_name or error("Argument Exception. preset.base_name must not be nil.")
	local name = Utils.create_name(preset)

	local item = table.deepcopy(data.raw.item[base_name]) --[[@as Item]]
	item.name = name
	item.place_result = name
	item.localised_name = { "item-name." .. item.name }
	if(name:find("double-")) then
		item.order = "z[slim-inserter]-b"..count
		item.icons = { {
			icon = mod.path.."graphics/double-arrow.png",
			icon_size = 64,
			tint = preset.tint
		} }
	elseif(name:find("loader-")) then
		item.order = "z[slim-inserter]-c"..count
		item.icons = { {
			icon = mod.path.."graphics/loader/arrow.png",
			icon_size = 64,
			tint = preset.tint
		} }
	else
		item.order = "z[slim-inserter]-a"..count
		item.icons = { {
			icon = mod.path.."graphics/arrow.png",
			icon_size = 64,
			tint = preset.tint
		} }
	end
	data:extend { item }
end

return ItemBuilder
