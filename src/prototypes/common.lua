if(not data.raw["recipe-category"]["sub-items"]) then
	data:extend{
		{
			type = "recipe-category",
			name = "sub-items",

			--TODO: customize
			order = "z",
			inventory_order = "z",
			icon = "__core__/graphics/icons/category/unsorted.png",
			icon_size = 128,
		}
	}
end

if(not data.raw["item-group"]["sub-items"]) then
	data:extend{
		{
			type = "item-group",
			name = "sub-items",

			--TODO: customize
			order = "z",
			inventory_order = "z",
			icon = "__core__/graphics/icons/category/unsorted.png",
			icon_size = 128,
		}
	}
end

data:extend{
	{
		type = "item-subgroup",
		name = "inserter-sub-items",
		group = "sub-items",
		order = "z",
	}
}