require("mod")

if(true) then
	log("shrink selection_box for most entities to not overlap with slim inserters. you can disable this in settings.")

	local types = {
		"container",
		"assembling-machine",
		"fluid-turret",
		"furnace",
		"lab",
		"linked-container",
		"linked-belt",
		"logistic-container",
		"offshore-pump",
		"reactor",
		"roboport",
		"rocket-silo",
		--"storage-tank",
		"transport-belt",
		"underground-belt",

	}
	local function op(v1, v2)
		if(math.abs(v1)<0.25) then return v1 end
		local r = v1+v2
		if(v2<0) then
			if(r<0.25) then r = 0.25 end
		else
			if(r>-0.25) then r = -0.25 end
		end
		return r
	end

	local function get_tile_with(entity)
		local tile_width = entity.tile_width
		if(tile_width) then return tonumber(tile_width) end
		local collision_box = entity.collision_box
		if(not collision_box) then return 0 end
		local width = collision_box[2][1] - collision_box[1][1]
		return math.ceil(width)
	end
	local function get_tile_height(entity)
		local tile_height = entity.tile_height
		if(tile_height) then return tonumber(tile_height) end
		local collision_box = entity.collision_box
		if(not collision_box) then return 0 end
		local height = collision_box[2][2] - collision_box[1][2]
		return math.ceil(height)
	end

	local function modify(entity)
		print("modify", entity.name, tonumber(entity.tile_width), tonumber(entity.tile_height))
		local min=math.min
		local max=math.max
		local v = 0.1
		local box = entity.selection_box
		if(not box) then return end
		

		--calcutate optimal selection box for tile-size
		local hv = get_tile_with(entity) /2
		local vv = get_tile_height(entity) /2
		local box2 = {{min(-hv+v,0), min(-vv+v,0)}, {max(hv-v,0), max(vv-v,0)}}
		--WTF?? most entities have no tile_width/tile_height
		--Default: calculated by the collision box width/height rounded up.

		-- use optimal selection box corner or original if it closer to center
		box = {
			{max(box2[1][1],box[1][1]), max(box2[1][2],box[1][2])},
			{min(box2[2][1],box[2][1]), min(box2[2][2],box[2][2])}
		}
		entity.selection_box = box
	end
	for _, type in ipairs(types) do
		for _, entity in pairs(data.raw[type]) do
			modify(entity)
		end
	end


end